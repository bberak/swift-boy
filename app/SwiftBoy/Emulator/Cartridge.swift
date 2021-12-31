// References:
// https://github.com/juchi/gameboy.js/blob/2eeed5eb5fdc497b47584e2719c18fe8aa13c1ea/src/mbc.js#L10
// https://retrocomputing.stackexchange.com/questions/11732/how-does-the-gameboys-memory-bank-switching-work
// https://b13rg.github.io/Gameboy-MBC-Analysis/

import Foundation

enum MBCType: UInt8 {
    case zero = 0x00
    case one = 0x01
    case one_ram = 0x02
    case one_ram_battery = 0x03
}

func getRamSize(rom: Data) -> Int {
    switch rom[0x0149] {
    case 1:
        return 2048
    case 2:
        return 8096
    case 3:
        return 8096 * 4
    default:
        return 2048
    }
}

func mbcZero(_ rom: Data) -> MemoryAccessArray {
    let rom = MemoryBlock(range: 0x0000...0x7FFF, buffer: rom.map { $0 }, readOnly: true, enabled: true)
    let ram = MemoryBlock(range: 0xA000...0xBFFF, readOnly: false, enabled: true)
    
    return MemoryAccessArray([rom, ram])
}

func mbcOne(_ rom: Data) -> MemoryAccessArray {
    let rom0 = MemoryBlock(range: 0x0000...0x3FFF, buffer: rom.extract(0x0000...0x3FFF), readOnly: true, enabled: true)
    let romBank = MemoryBlockBanked(range: 0x4000...0x7FFF, buffer: rom.extractFrom(0x4000), readOnly: true, enabled: true)
    let ramSize = getRamSize(rom: rom)
    let ramBank = MemoryBlockBanked(range: 0xA000...0xBFFF, buffer: [UInt8](repeating: 0xFF, count: ramSize), readOnly: false, enabled: true)
    let mbc = MemoryAccessArray([rom0, romBank, ramBank])
    var mode: UInt8 = 0
    
    mbc.subscribe({ (a, _) in a <= 0x1FFF }) { byte in
        ramBank.enabled = (byte & 0x0A) == 0x0A
    }
    
    mbc.subscribe({ (a, _) in a >= 0x2000 && a <= 0x3FFF }) { byte in
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
    
    mbc.subscribe({ (a, _) in a >= 0x6000 && a <= 0x7FFF }) { byte in
        mode = byte
    }
    
    mbc.subscribe({ (a, _) in a >= 0x4000 && a <= 0x5FFF }) { byte in
        if mode == 0 {
            var bank = UInt8(0)
            var upper = UInt8(0)
            var lower = UInt8(0)
            
            upper = upper & 0b00000011
            upper = upper << 5
            lower = romBank.bankIndex + 1 // ROM bank numbers start from 1, index starts from 0
            lower = lower & 0b00011111
            bank = upper | lower
            bank = bank - 1 // Convert to index
            
            romBank.bankIndex = bank
        } else {
            let bank = byte & 0b00000011
            ramBank.bankIndex = bank
        }
    }
    
    return mbc
}

public class Cartridge: MemoryAccessArray {
    public init(rom: Data) {
        super.init()
        
        guard let type = MBCType(rawValue: rom[0x0147]) else {
            print("MBC \(rom[0x0147]) is not currently supported")
            return
        }
        
        switch type {
        case .zero:
            super.copy(other: mbcZero(rom))
        case .one, .one_ram, .one_ram_battery:
            super.copy(other: mbcOne(rom))
        }
    }
    
    public convenience init(path: URL) {
        self.init(rom: readPath(path: path))
    }
}
