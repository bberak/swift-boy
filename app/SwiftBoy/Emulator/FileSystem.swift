import Foundation

struct FileSystem {
    static func write<T: Encodable>(
        _ object: T,
        inDirectory directoryName: String,
        toDocumentNamed documentName: String,
        encodedUsing encoder: JSONEncoder = .init()
    ) throws {
        let manager = FileManager.default
        
        let rootFolderURL = try manager.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )

        let nestedFolderURL = rootFolderURL.appendingPathComponent(directoryName)
        
        if !manager.fileExists(atPath: nestedFolderURL.relativePath) {
            try manager.createDirectory(
                at: nestedFolderURL,
                withIntermediateDirectories: false,
                attributes: nil
            )
        }

        try manager.createDirectory(
            at: nestedFolderURL,
            withIntermediateDirectories: false,
            attributes: nil
        )

        let fileURL = nestedFolderURL.appendingPathComponent(documentName)
        let data = try encoder.encode(object)
        try data.write(to: fileURL)
    }
    
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
            
            return bytes
        } catch {
            print("Unexpected error: \(error).")
        }
        
        return Data()
    }
    
    static func copyItem(at: URL, to: URL) throws {
        try FileManager.default.copyItem(at: at, to: to)
    }
    
    static func moveItem(at: URL, to: URL) throws {
        try FileManager.default.moveItem(at: at, to: to)
    }
}
