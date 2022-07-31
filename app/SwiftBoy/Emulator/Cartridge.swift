// References:
// https://github.com/juchi/gameboy.js/blob/2eeed5eb5fdc497b47584e2719c18fe8aa13c1ea/src/mbc.js#L10
// https://retrocomputing.stackexchange.com/questions/11732/how-does-the-gameboys-memory-bank-switching-work
// https://b13rg.github.io/Gameboy-MBC-Analysis/

// TODO: Support more MBC types
// TODO: Support RAM persistence to local storage (saves, games state etc)

import Foundation

enum MBCType {
    case zero
    case one
    case one_ram
    case one_ram_battery
    case unsupported
    
    init(rawValue: UInt8) {
        switch rawValue {
        case 0x00: self = .zero
        case 0x01: self = .one
        case 0x02: self = .one_ram
        case 0x03: self = .one_ram_battery
        default: self = .unsupported
        }
    }
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
    
    mbc.subscribe({ addr, _ in addr <= 0x1FFF }) { _, byte in
        ramBank.enabled = (byte & 0x0A) == 0x0A
    }
    
    mbc.subscribe({ addr, _ in addr >= 0x2000 && addr <= 0x3FFF }) { _, byte in
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
    
    mbc.subscribe({ addr, _ in addr >= 0x6000 && addr <= 0x7FFF }) { _, byte in
        mode = byte
    }
    
    mbc.subscribe({ addr, _ in addr >= 0x4000 && addr <= 0x5FFF }) { _, byte in
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

func mbcUnsupported(_ rom: Data) -> MemoryAccessArray {
    let titleBuffer = (0x0134...0x0143).map { rom[$0] }
    let romWithTitleOnly = MemoryBlock(range: 0x0134...0x0143, buffer: titleBuffer, readOnly: true, enabled: true)

    return MemoryAccessArray([romWithTitleOnly])
}

public class Cartridge: MemoryAccessArray, Identifiable {
    let type: MBCType
    let romPath: URL
    let ramPath: URL
    
    public var title: String {
        get {
            let bytes = (0x0134...0x0143).map { try! self.readByte(address: $0) }
            return String(bytes: bytes, encoding: .utf8) ?? romPath.lastPathComponent.replacingOccurrences(of: ".gb", with: "")
        }
    }
    
    public init(romPath: URL, ramPath: URL) {
        let rom = FileSystem.readItem(at: romPath)
        
        self.type = MBCType(rawValue: rom[0x0147])
        self.romPath = romPath
        self.ramPath = ramPath
        
        super.init()
        
        switch type {
        case .zero:
            super.copy(other: mbcZero(rom))
        case .one, .one_ram, .one_ram_battery:
            super.copy(other: mbcOne(rom))
        case .unsupported:
            super.copy(other: mbcUnsupported(rom))
        }
    }
}
