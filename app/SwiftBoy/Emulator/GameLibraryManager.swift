import Foundation

class GameLibraryManager: ObservableObject {
    @Published var library: [Cartridge]
    @Published var inserted: Cartridge
    
    let mmu: MMU
    let cpu: CPU
    let ppu: PPU
    
    init(_ gameLibrary: [Cartridge], _ mmu: MMU, _ ppu: PPU, _ cpu: CPU) {
        self.library = gameLibrary
        self.inserted = gameLibrary[0]
        self.mmu = mmu
        self.cpu = cpu
        self.ppu = ppu
    }
    
    func insertCartridge(_ nextCartridge: Cartridge? = nil) {
        // Save cartridge state (RAM)
        // Swap cartridge in MMU
        // Reset MMU + clear queue
        // Reset CPU + clear queue
        // Reset PPU + clear queue
        // Wouldn't I also need to stop the clock? And/or do some locking? Because this code will run on a separate thread to the game loop?
        // I can probably just dispatch the code below on the global queue
        
        DispatchQueue.global(qos: .userInteractive).async {
            if let cart = nextCartridge ?? self.library.first {
                self.inserted = cart
                self.mmu.insertCartridge(cart)
            }
        }
    }
    
    // Write some code to save cartridge state (RAM) when app is about to close
}
