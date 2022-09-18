// References:
// https://github.com/juchi/gameboy.js/blob/2eeed5eb5fdc497b47584e2719c18fe8aa13c1ea/src/mbc.js#L10
// https://retrocomputing.stackexchange.com/questions/11732/how-does-the-gameboys-memory-bank-switching-work
// https://b13rg.github.io/Gameboy-MBC-Analysis/

// TODO: Support more MBC types
// TODO: Make sure memory bank switching is working properly
// TODO: Make sure catridge RAM restoration is working properly

import Foundation

enum MBCType {
    case zero
    case one
    case one_ram
    case one_ram_battery
    case five
    case five_ram
    case five_ram_battery
    case five_rumble
    case five_rumble_ram
    case five_rumble_ram_battery
    case unsupported
    
    init(rawValue: UInt8) {
        switch rawValue {
        case 0x00: self = .zero
        case 0x01: self = .one
        case 0x02: self = .one_ram
        case 0x03: self = .one_ram_battery
        case 0x19: self = .five
        case 0x1A: self = .five_ram
        case 0x1B: self = .five_ram_battery
        case 0x1C: self = .five_rumble
        case 0x1D: self = .five_rumble_ram
        case 0x1E: self = .five_rumble_ram_battery
        default: self = .unsupported
        }
    }
}

struct MBC {
    let memory: MemoryAccessArray
    let extractRam: () -> [UInt8]
}

func getRamSize(rom: Data) -> Int {
    let eightKB = 8192
    
    switch rom[0x0149] {
    case 0x00,0x01:
        return eightKB
    case 0x02:
        return eightKB
    case 0x03:
        return eightKB * 4
    case 0x04:
        return eightKB * 16
    case 0x05:
        return eightKB * 8
    default:
        return eightKB * 4
    }
}

func mbcZero(rom: Data, ram: Data) -> MBC {
    let romBlock = MemoryBlock(range: 0x0000...0x7FFF, buffer: rom.map { $0 }, readOnly: true, enabled: true)
    let ramSize = getRamSize(rom: rom)
    let ramBlock = ramSize > 0 ?
        MemoryBlock(range: 0xA000...0xBFFF, buffer: ram.extractFrom(0).fillUntil(count: ramSize, with: 0xFF), readOnly: false, enabled: true) :
        MemoryBlock(range: 0xA000...0xBFFF, readOnly: false, enabled: true)
    
    return MBC(memory: MemoryAccessArray([romBlock, ramBlock])) {
        return ramBlock.buffer
    }
}

func mbcOne(rom: Data, ram: Data) -> MBC {
    let romBank1 = MemoryBlockBanked(range: 0x0000...0x3FFF, buffer: rom.extractFrom(0x0000), readOnly: true, enabled: true)
    let romBank2 = MemoryBlockBanked(range: 0x4000...0x7FFF, buffer: rom.extractFrom(0x4000), readOnly: true, enabled: true)
    let ramSize = getRamSize(rom: rom)
    let ramBank = ramSize > 0 ?
        MemoryBlockBanked(range: 0xA000...0xBFFF, buffer: ram.extractFrom(0).fillUntil(count: ramSize, with: 0xFF), readOnly: false, enabled: false) :
        MemoryBlockBanked(range: 0xA000...0xBFFF, readOnly: false, enabled: false)
    let memory = MemoryAccessArray([romBank1, romBank2, ramBank])
    var modeRegister: UInt8 = 0 {
        didSet {
            if modeRegister == 0 {
                romBank1.bankIndex = 0
                ramBank.bankIndex = 0
            } else if modeRegister == 1 {
                romBank1.bankIndex = UInt16(bank2Register << 5)
                ramBank.bankIndex = UInt16(bank2Register)
            }
        }
    }
    var bank1Register: UInt8 = 1 {
        didSet {
            romBank2.bankIndex = UInt16((bank2Register << 5) | bank1Register) - 1 // Normalize to zero-based index
        }
    }
    var bank2Register: UInt8 = 0 {
        didSet {
            romBank2.bankIndex = UInt16((bank2Register << 5) | bank1Register) - 1 // Normalize to zero-based index
            
            if modeRegister == 1 {
                romBank1.bankIndex = UInt16(bank2Register << 5)
                ramBank.bankIndex = UInt16(bank2Register)
            }
        }
    }

    memory.subscribe({ addr, _ in addr <= 0x1FFF }) { _, byte in
        ramBank.enabled = (byte & 0x0A) == 0x0A
    }

    memory.subscribe({ addr, _ in addr >= 0x2000 && addr <= 0x3FFF }) { _, byte in
        let nextBank1 = byte & 0b00011111
        bank1Register = nextBank1 == 0 ? 1 : nextBank1
    }

    memory.subscribe({ addr, _ in addr >= 0x4000 && addr <= 0x5FFF }) { _, byte in
        bank2Register = byte & 0b00000011
    }

    memory.subscribe({ addr, _ in addr >= 0x6000 && addr <= 0x7FFF }) { _, byte in
        modeRegister = byte & 0b00000001
    }
    
    return MBC(memory: memory) {
        return ramBank.banks.reduce([]) { agg, arr in
            return agg + arr
        }
    }
}

func mbcFive(rom: Data, ram: Data) -> MBC {
    let rom0 = MemoryBlock(range: 0x0000...0x3FFF, buffer: rom.extractFrom(0x0000...0x3FFF), readOnly: true, enabled: true)
    let romBank = MemoryBlockBanked(range: 0x4000...0x7FFF, buffer: rom.extractFrom(0x4000), readOnly: true, enabled: true)
    let ramSize = getRamSize(rom: rom)
    let ramBank = ramSize > 0 ?
        MemoryBlockBanked(range: 0xA000...0xBFFF, buffer: ram.extractFrom(0).fillUntil(count: ramSize, with: 0xFF), readOnly: false, enabled: true) :
        MemoryBlockBanked(range: 0xA000...0xBFFF, readOnly: false, enabled: true)
    let memory = MemoryAccessArray([rom0, romBank, ramBank])
    
    romBank.bankIndex = 1
    
    memory.subscribe({ addr, _ in addr <= 0x1FFF }) { _, byte in
        ramBank.enabled = (byte & 0x0A) == 0x0A
    }
    
    memory.subscribe({ addr, _ in addr >= 0x2000 && addr <= 0x2FFF }) { _, byte in
        var bank = UInt16(0)
        var upper = UInt16(0)
        var lower = UInt16(0)

        upper = romBank.bankIndex & 0b100000000
        lower = UInt16(byte)
        bank = upper | lower

        romBank.bankIndex = bank
    }
    
    memory.subscribe({ addr, _ in addr >= 0x3000 && addr <= 0x3FFF }) { _, byte in
        var bank = UInt16(0)
        var upper = UInt16(0)
        var lower = UInt16(0)

        upper = UInt16(byte & 0b00000001) << 8
        lower = romBank.bankIndex & 0b11111111
        bank = upper | lower

        romBank.bankIndex = bank
    }
    
    memory.subscribe({ addr, _ in addr >= 0x4000 && addr <= 0x5FFF }) { _, byte in
        ramBank.bankIndex = UInt16(byte & 0x0F)
    }
    
    return MBC(memory: memory) {
        return ramBank.banks.reduce([]) { agg, arr in
            return agg + arr
        }
    }
}

func mbcUnsupported(rom: Data) -> MBC {
    let titleBuffer = (0x0134...0x0143).map { rom[$0] }
    let romWithTitleOnly = MemoryBlock(range: 0x0134...0x0143, buffer: titleBuffer, readOnly: true, enabled: true)

    return MBC(memory: MemoryAccessArray([romWithTitleOnly])) {
        return []
    }
}

public class Cartridge: MemoryAccessArray, Identifiable {
    let type: MBCType
    let romPath: URL
    let ramPath: URL
    
    private var extractRam: (() -> [UInt8])?
    
    public var title: String {
        get {
            let bytes = (0x0134...0x0143).map { try! self.readByte(address: $0) }
            return String(bytes: bytes, encoding: .utf8) ?? romPath.lastPathComponent.replacingOccurrences(of: ".gb", with: "")
        }
    }
    
    public var canBeDeleted: Bool {
        get {
            return !romPath.absoluteString.contains(Bundle.main.bundleURL.absoluteString)
        }
    }
    
    public init(romPath: URL, ramPath: URL) {
        let rom = FileSystem.readItem(at: romPath)
        let ram = FileSystem.readItem(at: ramPath)
        
        self.type = MBCType(rawValue: rom[0x0147])
        self.romPath = romPath
        self.ramPath = ramPath
        
        super.init()
        
        switch type {
        case .zero:
            let mbc = mbcZero(rom: rom, ram: ram)
            super.copy(other: mbc.memory)
            self.extractRam = mbc.extractRam
        case .one, .one_ram, .one_ram_battery:
            let mbc = mbcOne(rom: rom, ram: ram)
            super.copy(other: mbc.memory)
            self.extractRam = mbc.extractRam
        case .five, .five_ram, .five_ram_battery, .five_rumble, .five_rumble_ram, .five_rumble_ram_battery:
            let mbc = mbcFive(rom: rom, ram: ram)
            super.copy(other: mbc.memory)
            self.extractRam = mbc.extractRam
        case .unsupported:
            let mbc = mbcUnsupported(rom: rom)
            super.copy(other: mbc.memory)
            self.extractRam = mbc.extractRam
        }
    }
    
    public func saveRam() {
        if let extractRam = self.extractRam {
            let bytes = extractRam()
            FileSystem.writeItem(at: ramPath, data: Data(bytes))
        }
    }
}

public extension Array where Element == Cartridge {
    func sortedByDeletablilityAndTitle() -> [Cartridge] {
        return self
            .sorted(by: { a, b in
                if a.canBeDeleted && b.canBeDeleted {
                    return a.title.lowercased() < b.title.lowercased()
                } else if a.canBeDeleted {
                    return false
                } else {
                  return true
                }
            })
    }
}
