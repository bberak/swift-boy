import Foundation

enum MBCType: UInt8 {
    case zero = 0x00
    case one = 0x01
}

func mbcZero(_ rom: Data) -> MemoryAccessArray {
    let rom = MemoryBlock(range: 0x0000...0x7FFF, buffer: rom.map { $0 }, readOnly: true, enabled: true)
    let ram = MemoryBlock(range: 0xA000...0xBFFF, readOnly: false, enabled: true)
    
    return MemoryAccessArray([rom, ram])
}

func mbcOne(_ rom: Data) -> MemoryAccessArray {
    //-- References:
    //-- https://github.com/juchi/gameboy.js/blob/2eeed5eb5fdc497b47584e2719c18fe8aa13c1ea/src/mbc.js#L10
    //-- https://retrocomputing.stackexchange.com/questions/11732/how-does-the-gameboys-memory-bank-switching-work
    
    let rom0 = MemoryBlock(range: 0x0000...0x3FFF, buffer: rom.extract(0x0000...0x3FFF), readOnly: true, enabled: true)
    let romBank = MemoryBlockBanked(range: 0x4000...0x7FFF, buffer: rom.extractFrom(0x4000), readOnly: true, enabled: true)
    //-- TODO:
    //-- Check size of ram (2KB, 8KB or 4 x 8KB) from the rom data?
    let ramBank = MemoryBlock(range: 0xA000...0xBFFF, readOnly: false, enabled: true)
    let mem = MemoryAccessArray([rom0, romBank, ramBank])
    var mode: UInt8 = 0
    
    mem.subscribe({ (a, _) in a <= 0x1FFF }) { byte in
        ramBank.enabled = (byte & 0x0A) == 0x0A
    }
    
    mem.subscribe({ (a, _) in a >= 0x2000 && a <= 0x3FFF }) { byte in
        var bank = UInt8(0)
        var upper = UInt8(0)
        var lower = UInt8(0)
        
        upper = romBank.bankIndex
        upper = upper & 0b01100000
        lower = byte
        lower = lower & 0b00011111
        lower = lower == 0 ? 1 : lower // If zero, automatically set to one
        bank = upper | lower
        bank = bank - 1 // Convert to index
        
        romBank.bankIndex = bank
    }
    
    mem.subscribe({ (a, _) in a >= 0x6000 && a <= 0x7FFF }) { byte in
        mode = byte
    }
    
    mem.subscribe({ (a, _) in a >= 0x4000 && a <= 0x5FFF }) { byte in
        if mode == 0 {
            var bank = UInt8(0)
            var upper = UInt8(0)
            var lower = UInt8(0)
            
            upper = upper & 0b00000011
            upper = upper << 5
            lower = romBank.bankIndex + 1
            lower = lower & 0b00011111
            bank = upper | lower
            bank = bank - 1 // Convert to index
                
            romBank.bankIndex = bank
        } else {
            // Set RAM bank
        }
    }
    
    return mem
}

public class Cartridge: MemoryAccessArray {
    public init(rom: Data) {
        super.init()
        
        let type = MBCType(rawValue: rom[0x0147])!
        
        switch type {
        case .zero:
            super.copy(other: mbcZero(rom))
        case .one:
            super.copy(other: mbcOne(rom))
        }
    }
    
    public convenience init(path: URL) {
        self.init(rom: readPath(path: path))
    }
}
