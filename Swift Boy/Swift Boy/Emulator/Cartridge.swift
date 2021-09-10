import Foundation

enum MBC: UInt8 {
    case zero = 0x00
    case one = 0x01
}

public class Cartridge: MemoryAccess {
    private var memory: MemoryAccessArray
    private let mbc: MBC
    
    public init(rom: Data) {
        self.mbc = MBC(rawValue: rom[0x0147])!
        switch self.mbc {
        case .zero:
            self.memory = MemoryAccessArray([
                // ROM
                MemoryBlock(range: 0x0000...0x7FFF, buffer: rom.map { $0 }, readOnly: true),
                // RAM
                MemoryBlock(range: 0xA000...0xBFFF, readOnly: false)
            ])
        case .one:
            self.memory = MemoryAccessArray([
                // ROM Bank 0
                MemoryBlock(range: 0x0000...0x3FFF, buffer: rom.extract(0x0000...0x3FFF), readOnly: true),
                // Switchable ROM Banks
                MemoryBlock(range: 0x4000...0x7FFF, buffer: rom.extract(0x4000...0x7FFF), readOnly: true),
                // RAM
                MemoryBlock(range: 0xA000...0xBFFF, readOnly: false)
            ])
        }
    }
    
    public convenience init(path: URL) {
        self.init(rom: readPath(path: path))
    }
    
    func contains(address: UInt16) -> Bool {
        return memory.contains(address: address)
    }
    
    func readByte(address: UInt16) throws -> UInt8 {
        return try memory.readByte(address: address)
    }
    
    func writeByte(address: UInt16, byte: UInt8) throws {
        return try memory.writeByte(address: address, byte: byte)
    }
}
