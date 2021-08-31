import Foundation

public class Cartridge: MemoryAccess {
    private var rom: MemoryBlock
    private var ram: MemoryBlock
    private var memory: MemoryAccessArray
    private var title: String
    
    public init(rom: Data, title: String) {
        self.rom = MemoryBlock(range: 0x0000...0x7FFF, buffer: rom.map { $0 }, readOnly: true)
        self.ram = MemoryBlock(range: 0xA000...0xBFFF, readOnly: false)
        self.memory = MemoryAccessArray([
            self.rom,
            self.ram
        ])
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
