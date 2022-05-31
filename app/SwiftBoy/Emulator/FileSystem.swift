import Foundation

enum GameDirectory: String {
    case roms = "roms"
    case saves = "saves"
}

struct FileSystem {
    static func write<T: Encodable>(
        _ object: T,
        inDirectory directoryName: GameDirectory,
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

        let nestedFolderURL = rootFolderURL.appendingPathComponent(directoryName.rawValue)
        
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
            return files.filter { $0.hasSuffix(suffix) }
        }
        
        return []
    }
    
    static func listAbsolutePaths(inDirectory: String, suffix: String = "") -> [String] {
        return listPaths(inDirectory: inDirectory, suffix: suffix).map { "\(inDirectory)/\($0)" }
    }
}
