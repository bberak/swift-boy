import Foundation

class GameLibraryManager: ObservableObject {
    @Published private(set) var library: [Cartridge]
    @Published private(set) var inserted: Cartridge
    
    let clock: Clock
    
    init(_ clock: Clock) {
        let roms = FileSystem.listAbsolutePaths(inDirectory: Bundle.main.bundlePath, suffix: ".gb")
        let carts = roms.map { Cartridge(path: URL(string: $0)!) }
        
        self.library = carts.sorted(by: { x, y in x.title < y.title })
        self.inserted = carts.first!
        self.clock = clock
        self.insertCartridge(inserted)
    }
    
    func deleteCartridge(_ discarded: Cartridge) {
        if discarded === inserted {
            let discardedIndex = library.firstIndex(where: { $0 === discarded})!
            let nextIndex = discardedIndex == library.count - 1 ? discardedIndex - 1 : discardedIndex + 1
            let next = library[nextIndex]
            insertCartridge(next)
        }
        
        library = library.filter { $0 !== discarded }
        try? FileSystem.removeItem(at: discarded.path)
        
        // TODO: Delete the discarded cartridge's RAM
    }
    
    func insertCartridge(_ next: Cartridge) {
        if next === inserted {
            return
        }
        
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
    
    // TODO: Write some code to save current cartridge's RAM when the app is about to close
}
