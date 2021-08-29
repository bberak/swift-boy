import Foundation

let biosProgram: [UInt8] = [
    0x31, 0xFE, 0xFF, 0xAF, 0x21, 0xFF, 0x9F, 0x32, 0xCB, 0x7C, 0x20, 0xFB, 0x21, 0x26, 0xFF, 0x0E,
    0x11, 0x3E, 0x80, 0x32, 0xE2, 0x0C, 0x3E, 0xF3, 0xE2, 0x32, 0x3E, 0x77, 0x77, 0x3E, 0xFC, 0xE0,
    0x47, 0x11, 0x04, 0x01, 0x21, 0x10, 0x80, 0x1A, 0xCD, 0x95, 0x00, 0xCD, 0x96, 0x00, 0x13, 0x7B,
    0xFE, 0x34, 0x20, 0xF3, 0x11, 0xD8, 0x00, 0x06, 0x08, 0x1A, 0x13, 0x22, 0x23, 0x05, 0x20, 0xF9,
    0x3E, 0x19, 0xEA, 0x10, 0x99, 0x21, 0x2F, 0x99, 0x0E, 0x0C, 0x3D, 0x28, 0x08, 0x32, 0x0D, 0x20,
    0xF9, 0x2E, 0x0F, 0x18, 0xF3, 0x67, 0x3E, 0x64, 0x57, 0xE0, 0x42, 0x3E, 0x91, 0xE0, 0x40, 0x04,
    0x1E, 0x02, 0x0E, 0x0C, 0xF0, 0x44, 0xFE, 0x90, 0x20, 0xFA, 0x0D, 0x20, 0xF7, 0x1D, 0x20, 0xF2,
    0x0E, 0x13, 0x24, 0x7C, 0x1E, 0x83, 0xFE, 0x62, 0x28, 0x06, 0x1E, 0xC1, 0xFE, 0x64, 0x20, 0x06,
    0x7B, 0xE2, 0x0C, 0x3E, 0x87, 0xF2, 0xF0, 0x42, 0x90, 0xE0, 0x42, 0x15, 0x20, 0xD2, 0x05, 0x20,
    0x4F, 0x16, 0x20, 0x18, 0xCB, 0x4F, 0x06, 0x04, 0xC5, 0xCB, 0x11, 0x17, 0xC1, 0xCB, 0x11, 0x17,
    0x05, 0x20, 0xF5, 0x22, 0x23, 0x22, 0x23, 0xC9, 0xCE, 0xED, 0x66, 0x66, 0xCC, 0x0D, 0x00, 0x0B,
    0x03, 0x73, 0x00, 0x83, 0x00, 0x0C, 0x00, 0x0D, 0x00, 0x08, 0x11, 0x1F, 0x88, 0x89, 0x00, 0x0E,
    0xDC, 0xCC, 0x6E, 0xE6, 0xDD, 0xDD, 0xD9, 0x99, 0xBB, 0xBB, 0x67, 0x63, 0x6E, 0x0E, 0xEC, 0xCC,
    0xDD, 0xDC, 0x99, 0x9F, 0xBB, 0xB9, 0x33, 0x3E, 0x3c, 0x42, 0xB9, 0xA5, 0xB9, 0xA5, 0x42, 0x4C,
    0x21, 0x04, 0x01, 0x11, 0xA8, 0x00, 0x1A, 0x13, 0xBE, 0x20, 0xFE, 0x23, 0x7D, 0xFE, 0x34, 0x20,
    0xF5, 0x06, 0x19, 0x78, 0x86, 0x23, 0x05, 0x20, 0xFB, 0x86, 0x20, 0xFE, 0x3E, 0x01, 0xE0, 0x50
]

enum MemoryAccessError: Error {
    case addressOutOfRange
    case readOnly
}

protocol MemoryAccess: class {
    func contains(address: UInt16) -> Bool
    func readByte(address: UInt16) throws -> UInt8
    func writeByte(address: UInt16, byte: UInt8) throws -> Void
}

extension MemoryAccess {
    func readWord(address: UInt16) throws -> UInt16 {
        let bytes = [try readByte(address: address), try readByte(address: address + 1)]
        return bytes.toWord()
    }
    
    func writeWord(address: UInt16, word: UInt16) throws -> Void {
        let bytes = word.toBytes()
        try writeByte(address: address, byte: bytes[0])
        try writeByte(address: address + 1, byte: bytes[1])
    }
}

class MemoryAccessArray: MemoryAccess {
    private var arr: [MemoryAccess]
    
    init(_ arr: [MemoryAccess]) {
        self.arr = arr
    }
    
    func find(address: UInt16) -> MemoryAccess? {
        return arr.first { $0.contains(address: address) }
    }
    
    func remove(item: MemoryAccess) {
        let index = arr.firstIndex { x in
            return x === item
        }
        
        if index != nil {
            arr.remove(at: index!)
        }
    }
    
    func contains(address: UInt16) -> Bool {
        let block = find(address: address)
        return block != nil ? true : false
    }
    
    func readByte(address: UInt16) throws -> UInt8 {
        if let block = find(address: address) {
            return try block.readByte(address: address)
        }
        
        throw MemoryAccessError.addressOutOfRange
    }
    
    func writeByte(address: UInt16, byte: UInt8) throws {
        if let block = find(address: address) {
            return try block.writeByte(address: address, byte: byte)
        }
        
        throw MemoryAccessError.addressOutOfRange
    }
}

class MemoryBlock: MemoryAccess {
    private let range: ClosedRange<UInt16>
    private var buffer: [UInt8]
    private var readOnly: Bool
    
    init(range: ClosedRange<UInt16>, buffer: [UInt8], readOnly: Bool) {
        self.range = range
        self.buffer = buffer
        self.readOnly = readOnly
    }
    
    convenience init(range: ClosedRange<UInt16>, readOnly: Bool) {
        self.init(range: range, buffer: [UInt8](repeating: 0, count: range.count), readOnly: readOnly)
    }
    
    convenience init(range: ClosedRange<UInt16>, block: MemoryBlock) {
        self.init(range: range, buffer: block.buffer, readOnly: block.readOnly)
    }
    
    func contains(address: UInt16)-> Bool {
        return range.contains(address)
    }
    
    func readByte(address: UInt16) throws -> UInt8 {
        if range.contains(address) == false {
            throw MemoryAccessError.addressOutOfRange
        }
        
        let index = Int(address - range.lowerBound)
        
        return buffer[index % buffer.count]
    }
    
    func writeByte(address: UInt16, byte: UInt8) throws {
        if readOnly {
            throw MemoryAccessError.readOnly
        }
        
        if range.contains(address) == false {
            throw MemoryAccessError.addressOutOfRange
        }
        
        let index = Int(address - range.lowerBound)
        
        buffer[index % buffer.count] = byte
    }
}

public class MMU: MemoryAccess {
    private let cartridge: Cartridge?
    private let bios: MemoryBlock
    private let wram: MemoryBlock
    private let echo: MemoryBlock
    private let hram: MemoryBlock
    private var memory: MemoryAccessArray
    private var subscribers: [UInt16: [(UInt8)->Void]] = [:]
    private var queue: [Command] = []
    private var cycles: Int16 = 0
    
    public init() {
        self.cartridge = nil
        self.bios = MemoryBlock(range: 0x0000...0x00FF, buffer: biosProgram, readOnly: true)
        self.wram = MemoryBlock(range: 0xC000...0xCFFF, readOnly: false)
        self.echo = MemoryBlock(range: 0xE000...0xFDFF, block: wram)
        self.hram = MemoryBlock(range: 0xFF80...0xFFFE, readOnly: false)
        self.memory = MemoryAccessArray([
            bios,
            wram,
            echo,
            hram,
            // Catch-all
            MemoryBlock(range: 0x0000...0xFFFF, readOnly: false)
        ])
        self.subscribe(address: 0xFF50) { byte in
            if byte == 1 {
                self.memory.remove(item: self.bios)
            }
        }
        self.subscribe(address: 0xFF46) { byte in
            self.startDMATransfer(byte: byte)
        }
    }
    
    // TODO: Make sure only HRAM is accessible to the CPU
    // during the DMA transfer process
    func startDMATransfer(byte: UInt8) {
        let start = UInt16(byte) << 8
        for offset in 0..<0xA0 {
            self.queue.append(Command(cycles: 1) {
                let data = try self.readByte(address: start + UInt16(offset))
                try self.writeByte(address: 0xFE00 + UInt16(offset), byte: data)
                return nil
            })
        }
    }
    
    func subscribe(address: UInt16, handler: @escaping (UInt8)->Void) {
        let list = self.subscribers[address];

        if list == nil {
            self.subscribers[address] = [handler]
        } else {
            self.subscribers[address]!.append(handler)
        }
    }
    
    func contains(address: UInt16)-> Bool {
        return memory.contains(address: address)
    }
    
    func readByte(address: UInt16) throws -> UInt8 {
        return try memory.readByte(address: address)
    }
    
    func writeByte(address: UInt16, byte: UInt8) throws {
        try memory.writeByte(address: address, byte: byte)
        
        let callbacks = self.subscribers[address]
        
        callbacks?.forEach { $0(byte) }
    }
    
     public func run(for time: Int16) throws {
        if queue.count > 0 {
            cycles = cycles + time
         
             while cycles > 0 && queue.count > 0 {
                let cmd = queue.removeFirst()
                let next = try cmd.run()
                 
                cycles = cycles - Int16(cmd.cycles)
                 
                if next != nil {
                    queue.insert(next!, at: 0)
                }
            }
            
            if cycles > 0 {
                cycles = 0
            }
        }
    }
}
