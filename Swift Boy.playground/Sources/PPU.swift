import Foundation

public class PPU {
    private let mmu: MMU
    
    public init(_ mmu: MMU) {
        self.mmu = mmu
    }
}
