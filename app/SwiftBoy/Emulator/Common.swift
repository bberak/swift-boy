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
    
    func extractFrom(_ start: Int) -> [UInt8] {
        return self.extract(start...(self.count-1))
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
    
    // TODO:
    // Rename this to swapNibbles
    func swap() -> UInt8 {
        let hb = self << 4
        let lb = self >> 4
        return hb + lb
    }
    
    func toInt8() -> Int8 {
        return Int8(bitPattern: self)
    }
    
    func isBetween(_ lower: UInt8, _ upper: UInt8) -> Bool {
        return self >= lower && self <= upper
    }
    
    subscript(index: UInt8) -> Bool {
        get {
            return bit(index)
        }
        set {
            if newValue {
                self = set(index)
            } else {
                self = reset(index)
            }
        }
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
    
    func isBetween(_ lower: UInt16, _ upper: UInt16) -> Bool {
        return self >= lower && self <= upper
    }
}

public extension UInt64 {
    func inMs() -> UInt64 {
        return self / 1000000
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
    
    func isBetween(_ lower: Int, _ upper: Int) -> Bool {
        return self >= lower && self <= upper
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

func maybe(doThis: () -> Void) {
    if Int.random(in: 0...100) == 7 {
        doThis()
    }
}

func rarely(doThis: () -> Void) {
    if Int.random(in: 0...10000) == 7 {
        doThis()
    }
}

class StopWatch {
    static let global = StopWatch()
    
    private var timers: [String: DispatchTime] = [:]
    private var ledger: [String: UInt64] = [:]
    
    func start(_ label: String) {
        timers[label] = DispatchTime.now();
    }
    
    func stop(_ label: String) {
        if let start = timers[label] {
            let end = DispatchTime.now();
            let duration = end.uptimeNanoseconds - start.uptimeNanoseconds
            let current = ledger[label] ?? 0
            ledger[label] = current + duration
        }
    }
    
    func reset(_ label: String) {
        timers[label] = nil
        ledger[label] = nil
    }
    
    func check(_ label: String) -> UInt64 {
        return ledger[label] ?? 0
    }
    
    func resetAll() {
        timers.removeAll(keepingCapacity: false)
        ledger.removeAll(keepingCapacity: false)
    }
    
    func printAll() {
        let all = ledger.sorted(by: { $0.value > $1.value }).map( { (k,v) in
            return "\(k): \(v.inMs())ms"
        })
        
        print(all.joined(separator: ", "))
    }
    
    func maybePrintAll() {
        maybe {
            printAll()
        }
    }
}

class Memo<T> {
    private var value: T?
    private var deps: [AnyHashable] = []
    
    func get (deps: [AnyHashable], _ getter: @escaping () -> T) -> T {
        if value == nil || self.deps != deps {
            value = getter()
            self.deps = deps
        }
        
        return value!
    }
}
