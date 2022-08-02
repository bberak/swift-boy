// TODO: Reading and writing files needs refactoring.. Paths need to be normalized using some sort of sanitization logic.

import Foundation

struct FileSystem {
    static func listPaths(inDirectory: String, suffix: String = "") -> [String] {
        if let files = try? FileManager.default.contentsOfDirectory(atPath: inDirectory) {
            return files
                .filter { $0.hasSuffix(suffix) }
                .map { $0.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "" }
                .filter { $0.isNotEmpty }
        }
        
        return []
    }
    
    static func listAbsolutePaths(inDirectory: String, suffix: String = "") -> [String] {
        return listPaths(inDirectory: inDirectory, suffix: suffix).map { "\(inDirectory)/\($0)" }
    }
    
    static func getDocumentsDirectory() -> String {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].path
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
            let manager = FileManager.default

            if !manager.fileExists(atPath: at.absoluteString) {
                manager.createFile(atPath: at.absoluteString, contents: nil, attributes: nil)
            }
            
            let handle = try FileHandle(forWritingTo: at)

            handle.write(data)

            try handle.close()
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
