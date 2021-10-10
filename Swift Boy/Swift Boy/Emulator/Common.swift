import Foundation

public func readPath(path: URL) -> Data {
    do {
        let handle = try FileHandle(forReadingFrom: path)
        let bytes = handle.readDataToEndOfFile()
        
        return bytes
    } catch {
        print("Unexpected error: \(error).")
    }
    
    return Data()
}

public extension Data {
    func extract(_ range: ClosedRange<Int>) -> [UInt8] {
        return range.map({ self[$0] })
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

public extension Array where Element == UInt8 {
    func toWord() -> UInt16 {
        let hb = self[1]
        let lb = self[0]
        return UInt16(hb) << 8 + UInt16(lb)
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
    
    func set(bit: UInt8, as value: Bool) -> UInt8 {
        if value == false {
            return reset(bit)
        }
        
        return set(bit)
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

public extension Int8 {
    func toUInt16() -> UInt16 {
        return UInt16(bitPattern: Int16(self))
    }
}

public extension Int16 {
    func toUInt16() -> UInt16 {
        return UInt16(bitPattern: self)
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

public func add(_ num1: UInt8, _ num2: UInt8, carry: Bool = false) -> ByteOp {
    let cy: UInt8 = carry ? 1 : 0
    let value: UInt8 = num1 &+ num2 &+ cy
    let halfCarry = (num1 & 0x0F) + (num2 & 0x0F) + cy > 0x0F
    let carry = UInt16(num1) + UInt16(num2) + UInt16(cy) > 0xFF
    
    return ByteOp(value: value, halfCarry: halfCarry, carry: carry, subtract: false)
}

public func sub(_ num1: UInt8, _ num2: UInt8, carry: Bool = false) -> ByteOp {
    let cy: UInt8 = carry ? 1 : 0
    let value: UInt8 = num1 &- num2 &- cy
    let halfCarry = ((num1 & 0x0F) &- (num2 & 0x0F) &- cy) & 0x10 != 0x00
    let carry = UInt16(num1) < UInt16(num2) + UInt16(cy)
    
    return ByteOp(value: value, halfCarry: halfCarry, carry: carry, subtract: true)
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

public func checkCarry(_ num1: UInt16, _ num2: UInt16, carryBit: UInt8) -> Bool {
    let mask = UInt16(0xFFFF) >> (15 - carryBit)
    return (num1 & mask) + (num2 & mask) > mask
}

public func add(_ num1: UInt16, _ num2: UInt16, carryBit: UInt8) -> WordOp {
    let value: UInt16 = num1 &+ num2
    let halfCarry = checkCarry(num1, num2, carryBit: carryBit)
    let carry = num1 > 0xFFFF - num2

    return WordOp(value: value, halfCarry: halfCarry, carry: carry, subtract: false)
}

public struct Command {
    public let cycles: UInt16
    public let run: () throws -> Command?
    
    public init(cycles: UInt16, run: @escaping () throws -> Command?) {
        self.cycles = cycles;
        self.run = run;
    }
}

public struct Interrupts {
    static let vBlank = (bit: UInt8(0), address: UInt16(0x0040))
    static let lcdStat = (bit: UInt8(1), address: UInt16(0x0048))
    static let timer = (bit: UInt8(2), address: UInt16(0x0050))
    static let serial = (bit: UInt8(3), address: UInt16(0x0058))
    static let joypad = (bit: UInt8(4), address: UInt16(0x0060))
    static let priority = [Interrupts.vBlank, Interrupts.lcdStat, Interrupts.timer, Interrupts.serial, Interrupts.joypad]
}
