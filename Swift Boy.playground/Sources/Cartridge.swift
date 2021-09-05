import Foundation

enum MBC: UInt8 {
    case zero = 0x00
    case one = 0x01
}

public class Cartridge: MemoryAccess {
    private var memory: MemoryAccessArray
    private var title: String
    private let mbc: MBC
    
    public init(rom: Data, title: String) {
        self.mbc = MBC(rawValue: rom[0x0147])!
        switch self.mbc {
        case .zero:
            self.memory = MemoryAccessArray([
                MemoryBlock(range: 0x0000...0x7FFF, buffer: rom.map { $0 }, readOnly: true),
                MemoryBlock(range: 0xA000...0xBFFF, readOnly: false)
            ])
        case .one:
            self.memory = MemoryAccessArray([
                MemoryBlock(range: 0x0000...0x7FFF, buffer: rom.map { $0 }, readOnly: true),
                MemoryBlock(range: 0xA000...0xBFFF, readOnly: false)
            ])
        }
        self.title = title
    }
    
    public convenience init(path: URL, title: String) {
        self.init(rom: readPath(path: path), title: title)
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
