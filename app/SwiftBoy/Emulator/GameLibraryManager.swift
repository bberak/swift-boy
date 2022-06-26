import Foundation

class GameLibraryManager: ObservableObject {
    @Published private(set) var library: [Cartridge]
    @Published private(set) var inserted: Cartridge
    
    let mmu: MMU
    let cpu: CPU
    let ppu: PPU
    let timer: Timer
    
    init(_ gameLibrary: [Cartridge], _ mmu: MMU, _ ppu: PPU, _ cpu: CPU, _ timer: Timer) {
        self.library = gameLibrary
        self.inserted = gameLibrary[0]
        self.mmu = mmu
        self.cpu = cpu
        self.ppu = ppu
        self.timer = timer
    }
    
    func insertCartridge(_ nextCartridge: Cartridge? = nil) {
        // Save cartridge state (RAM)
        // Swap cartridge in MMU
        // Reset MMU + clear queue
        // Reset CPU + clear queue
        // Reset PPU + clear queue
        // Wouldn't I also need to stop the clock? And/or do some locking? Because this code will run on a separate thread to the game loop?
        // I can probably just dispatch the code below on the global queue
        
        if let cart = nextCartridge ?? self.library.first {
            self.inserted = cart
            self.mmu.insertCartridge(cart)
//            self.mmu.reset()
//            self.cpu.reset()
//            self.ppu.reset()
//            self.timer.reset()
        }
    }
    
    // Write some code to save cartridge state (RAM) when app is about to close
}
