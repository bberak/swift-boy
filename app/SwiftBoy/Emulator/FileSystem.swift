import Foundation

struct FileSystem {
    static var documentsDirectory: String {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].path
    }
    
    static func listAbsoluteURLs(inDirectory: String, suffix: String = "") -> [URL] {
        if let files = try? FileManager.default.contentsOfDirectory(atPath: inDirectory) {
            return files
                .filter { $0.hasSuffix(suffix) }
                .map { URL(fileURLWithPath: "\(inDirectory)/\($0)") }
        }
        
        return []
    }
    
    static func removeItem(at: URL) throws {
        try FileManager.default.removeItem(atPath: at.path)
    }
    
    static func readItem(at: URL) -> Data {
        do {
            let handle = try FileHandle(forReadingFrom: at)
            let bytes = handle.readDataToEndOfFile()
            
            try handle.close()
            
            return bytes
        } catch {
            print("Unexpected error: \(error).")
        }
        
        return Data()
    }
    
    static func writeItem(at: URL, data: Data) {
        do {
            try data.write(to: at)
        } catch {
            print("Unexpected error: \(error).")
        }
    }
    
    static func copyItem(at: URL, to: URL) throws {
        try FileManager.default.copyItem(at: at, to: to)
    }
    
    static func moveItem(at: URL, to: URL) throws {
        try FileManager.default.moveItem(at: at, to: to)
    }
}
