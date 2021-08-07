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

extension Array where Element == UInt8 {
    func toWord() -> UInt16 {
        let lb = self[0]
        let hb = self[1]
        return UInt16(hb) << 8 + UInt16(lb)
    }
}

extension UInt16 {
    func toBytes() -> [UInt8] {
        let arr = [UInt8(0x00FF & self), UInt8(0xFF00 & self)]
        return arr
    }
}
