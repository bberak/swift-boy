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
    
    func bit(_ pos: UInt8) -> Bool {
        let mask = UInt8(0x01 << pos)
        return (self & mask) == mask
    }
}

public func add(num1: UInt8, num2: UInt8) -> (value: UInt8, halfCarry: Bool, carry: Bool) {
    let value: UInt16 = UInt16(num1) + UInt16(num2)
    let halfCarry = (((num1 & 0x0F) + (num2 & 0x0F)) & 0x10) == 0x10
    let carry = value > 0x00FF
    
    return (value: UInt8(value & 0x00FF), halfCarry: halfCarry, carry: carry)
}

public func add(_ num1: UInt8, _ num2: UInt8) -> (value: UInt8, halfCarry: Bool, carry: Bool) {
    return add(num1: num1, num2: num2)
}

public func subtract(num1: UInt8, num2: UInt8) -> (value: UInt8, halfCarry: Bool, carry: Bool) {
    return add(num1, (0xFF - UInt16(num2) + 1).toBytes()[0])
}

public func subtract(_ num1: UInt8, _ num2: UInt8) -> (value: UInt8, halfCarry: Bool, carry: Bool) {
    return subtract(num1: num1, num2: num2)
}

public func sub(_ num1: UInt8, _ num2: UInt8) -> (value: UInt8, halfCarry: Bool, carry: Bool) {
    return subtract(num1: num1, num2: num2)
}
