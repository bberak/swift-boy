import Foundation

class GameLibraryManager: ObservableObject {
    @Published private(set) var library: [Cartridge]
    @Published private(set) var inserted: Cartridge
    
    let clock: Clock
    
    init(_ clock: Clock) {
        let bundledGames = FileSystem.listAbsolutePaths(inDirectory: Bundle.main.bundlePath, suffix: ".gb")
        let importedGames = FileSystem.listAbsolutePaths(inDirectory: FileSystem.getDocumentsDirectory(), suffix: ".gb")
        let bundledCarts = bundledGames.map { rom -> Cartridge in
            let romPath = URL(string: rom)!
            let ramPath = URL(string:
                (FileSystem.getDocumentsDirectory() + "/" + romPath.lastPathComponent + ".ram")
                    .addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
            )!
            return Cartridge(romPath: romPath, ramPath: ramPath)
        }
        let importedCarts = importedGames.map { rom -> Cartridge in
            return Cartridge(romPath: URL(string: rom)!, ramPath: URL(string: rom + ".ram")!)
        }
        let allCarts = bundledCarts + importedCarts
        
        self.library = allCarts.sorted(by: { a, b in a.title < b.title })
        self.inserted = allCarts.first!
        self.clock = clock
        self.insertCartridge(self.inserted)
    }
    
    func deleteCartridge(_ discarded: Cartridge) {
        if discarded === inserted {
            let discardedIndex = library.firstIndex(where: { $0 === discarded})!
            let nextIndex = discardedIndex == library.count - 1 ? discardedIndex - 1 : discardedIndex + 1
            let next = library[nextIndex]
            insertCartridge(next)
        }
        
        library = library.filter { $0 !== discarded }
        
        try? FileSystem.removeItem(at: discarded.romPath)
        try? FileSystem.removeItem(at: discarded.ramPath)
    }
    
    func insertCartridge(_ next: Cartridge) {
        // TODO: Save the previous cartridge's RAM
        
        self.inserted = next
        
        self.clock.sync { mmu, cpu, ppu, apu, timer in
            mmu.insertCartridge(next)
            mmu.reset()
            cpu.reset()
            ppu.reset()
            apu.reset()
            timer.reset()
        }
    }
    
    func importURLs(urls: [URL]) {
        library.append(contentsOf: urls.map { src in
            let romPath = URL(string:
                // Identical schemes are required for move operation
                src.scheme! + "://" + (FileSystem.getDocumentsDirectory() + "/" + src.lastPathComponent).addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
            )!
            let ramPath = romPath.appendingPathExtension("ram")
            try! FileSystem.moveItem(at: src, to: romPath)
            return Cartridge(romPath: romPath, ramPath: ramPath)
        })
    }
    
    // TODO: Write some code to save current cartridge's RAM when the app is about to close
}
