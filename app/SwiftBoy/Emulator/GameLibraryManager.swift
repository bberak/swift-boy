import Foundation

class GameLibraryManager: ObservableObject {
    @Published private(set) var library: [Cartridge]
    @Published private(set) var inserted: Cartridge
    
    let clock: Clock
    
    init(_ clock: Clock) {
        let roms = FileSystem.listAbsolutePaths(inDirectory: Bundle.main.bundlePath, suffix: ".gb")
        let carts = roms.map { Cartridge(path: URL(string: $0)!) }
        
        self.library = carts
        self.inserted = carts.first!
        self.clock = clock
        self.insertCartridge(inserted)
    }
    
    func insertCartridge(_ next: Cartridge) {
        // TODO: Save prev cartridge's RAM
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
    
    // TODO: Write some code to save current cartridge's RAM when app is about to close
}
