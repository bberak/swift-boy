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
        self.insertCartridge()
    }
    
    func insertCartridge(_ nextCartridge: Cartridge? = nil) {
        if let cart = nextCartridge ?? self.library.first {
            // Save current cartridge's RAM
            self.inserted = cart
            self.clock.insertCartridgeSynced(cart)
        }
    }
    
    // Write some code to save current cartridge's RAM when app is about to close
}
