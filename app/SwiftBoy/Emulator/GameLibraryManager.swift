import Foundation

class GameLibraryManager: ObservableObject {
    @Published private(set) var library: [Cartridge]
    @Published private(set) var inserted: Cartridge
    
    let clock: Clock
    
    init(_ clock: Clock) {
        let bundledGames = FileSystem.listAbsoluteURLs(inDirectory: Bundle.main.bundlePath, suffix: ".gb")
        let importedGames = FileSystem.listAbsoluteURLs(inDirectory: FileSystem.documentsDirectory, suffix: ".gb")
        
        let bundledCarts = bundledGames.map { romPath -> Cartridge in
            let ramPath = URL(fileURLWithPath: "\(FileSystem.documentsDirectory)/\(romPath.lastPathComponent).ram")
            return Cartridge(romPath: romPath, ramPath: ramPath)
        }
        let importedCarts = importedGames.map { romPath -> Cartridge in
            return Cartridge(romPath: romPath, ramPath: romPath.appendingPathExtension("ram"))
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
        let previous = self.inserted
        
        self.inserted = next
        
        self.clock.sync { mmu, cpu, ppu, apu, timer in
            previous.saveRam()
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
            let romPath = URL(fileURLWithPath: "\(FileSystem.documentsDirectory)/\(src.lastPathComponent)")
            let ramPath = romPath.appendingPathExtension("ram")
            try! FileSystem.moveItem(at: src, to: romPath)
            return Cartridge(romPath: romPath, ramPath: ramPath)
        })
    }
}
