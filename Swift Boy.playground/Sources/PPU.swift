import Foundation

public class PPU {
    private let mmu: MMU
    
    public init(_ mmu: MMU) {
        self.mmu = mmu
        self.mmu.subscribe(address: 0xFF40) { byte in
            print("LCD control:", byte.toHexString())
        }
        self.mmu.subscribe(address: 0xFF42) { byte in
            print("Vertical scroll register:", byte.toHexString())
        }
    }
}
