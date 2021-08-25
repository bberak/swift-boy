import Foundation

public func readBytes(path: URL) -> Data {
    do {
        let handle = try FileHandle(forReadingFrom: path)
        let bytes = handle.readDataToEndOfFile()
        
        return bytes
    } catch {
        print("Unexpected error: \(error).")
    }
    
    return Data()
}

public func calculateTime(block : (() -> Void)) {
    let start = DispatchTime.now()
    block()
    let end = DispatchTime.now()
    let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
    let timeInterval = Double(nanoTime) / 1_000_000_000
    print("Time: \(timeInterval) seconds")
}

public extension Array where Element == UInt8 {
    func toWord() -> UInt16 {
        let hb = self[1]
        let lb = self[0]
        return UInt16(hb) << 8 + UInt16(lb)
    }
}

public func &+(left: UInt16, right: Int8) -> UInt16 {
    return right > 0 ? left &+ UInt16(right.toUInt8()) : left &- UInt16(right.toUInt8())
}

public extension UInt16 {
    func toBytes() -> [UInt8] {
        return [UInt8(0x00FF & self), UInt8((0xFF00 & self) >> 8)]
    }
    
    func toHexString() -> String {
        let bytes = toBytes()
        return String(format:"%02X", bytes[1]) + String(format:"%02X", bytes[0])
    }
    
    func bit(_ pos: UInt8) -> Bool {
        let mask = UInt16(0x0001 << pos)
        return (self & mask) == mask
    }
}

public extension UInt8 {
    func toHexString() -> String {
        return String(format:"%02X", self)
    }
    
    func bit(_ bit: UInt8) -> Bool {
        let mask = UInt8(0x01 << bit)
        return (self & mask) == mask
    }
    
    func crumb(_ crumb: UInt8) -> UInt8 {
        let mask = UInt8(0b00000011)
        return (self >> (crumb * 2)) & mask
    }
    
    func nibble(_ nibble: UInt8) -> UInt8 {
        let mask = UInt8(0b00001111)
        return (self >> (nibble * 4)) & mask
    }
    
    func reset(_ bit: UInt8) -> UInt8 {
        let mask = ~UInt8(0x01 << bit)
        return self & mask
    }
    
    func set(_ bit: UInt8) -> UInt8 {
        let mask = UInt8(0x01 << bit)
        return self | mask
    }
    
    func swap() -> UInt8 {
        let hb = self << 4
        let lb = self >> 4
        return hb + lb
    }
    
    func toInt8() -> Int8 {
        return Int8(bitPattern: self)
    }
    
    
}

public extension Int8 {
    func toUInt8() -> UInt8 {
        return self < 0 ? UInt8((self * -1) & 0b01111111) : UInt8(self & 0b01111111)
    }
}

public struct ByteOp {
    public var value: UInt8
    public var halfCarry: Bool
    public var carry: Bool
    public var subtract: Bool
    public var zero: Bool {
        return value == 0
    }
}

public func add(num1: UInt8, num2: UInt8) -> ByteOp {
    let value: UInt8 = num1 &+ num2
    let halfCarry = (((num1 & 0x0F) + (num2 & 0x0F)) & 0x10) == 0x10
    let carry = value < num1 || value < num2
    
    return ByteOp(value: value, halfCarry: halfCarry, carry: carry, subtract: false)
}

public func add(_ num1: UInt8, _ num2: UInt8) -> ByteOp {
    return add(num1: num1, num2: num2)
}

public func sub(num1: UInt8, num2: UInt8) -> ByteOp {
    let complement: UInt8 = ~num2 &+ 1
    let result = add(num1, complement)
    return ByteOp(value: result.value, halfCarry: result.halfCarry, carry: result.carry, subtract: true)
}

public func sub(_ num1: UInt8, _ num2: UInt8) -> ByteOp {
    return sub(num1: num1, num2: num2)
}

public struct WordOp {
    public var value: UInt16
    public var halfCarry: Bool
    public var carry: Bool
    public var subtract: Bool
    public var zero: Bool {
        return value == 0
    }
}

public func add(num1: UInt16, num2: UInt16) -> WordOp {
    let value: UInt16 = num1 &+ num2
    let halfCarry = (((num1 & 0x0FFF) + (num2 & 0x0FFF)) & 0x1000) == 0x1000
    let carry = value < num1 || value < num2
    
    return WordOp(value: value, halfCarry: halfCarry, carry: carry, subtract: false)
}

public func add(_ num1: UInt16, _ num2: UInt16) -> WordOp {
    return add(num1: num1, num2: num2)
}

public func sub(num1: UInt16, num2: UInt16) -> WordOp {
    let complement: UInt16 = ~num2 &+ 1
    let result = add(num1, complement)
    return WordOp(value: result.value, halfCarry: result.halfCarry, carry: result.carry, subtract: true)
}

public func sub(_ num1: UInt16, _ num2: UInt16) -> WordOp {
    return sub(num1: num1, num2: num2)
}

public class DynamicIterator<T> : IteratorProtocol {
    private var items: [T] = []
    private var index = 0
    
    init(generator: (DynamicIterator<T>) -> Void) {
        generator(self)
    }
    
    public func yield(_ item: T) {
        self.items.append(item)
    }
    
    public func next() -> T? {
        if index > (items.count-1) {
            return nil
        }
        
        let item = items[index]
        index+=1
        
        return item
    }
}

public class DynamicSequence<T>: Sequence {
    let generator: (DynamicIterator<T>) -> Void
    
    public init(generator: @escaping (DynamicIterator<T>) -> Void) {
        self.generator = generator
    }
    
    public func makeIterator() -> DynamicIterator<T> {
        return DynamicIterator(generator: self.generator)
    }
}

public struct Command {
    public let cycles: UInt16
    public let run: () throws -> Command?
    
    public init(cycles: UInt16, run: @escaping () throws -> Command?) {
        self.cycles = cycles;
        self.run = run;
    }
}

