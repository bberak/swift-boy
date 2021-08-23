import Foundation
import SwiftUI

public class PPU {
    private let mmu: MMU
    public var screen: some View {
        VStack(spacing: 0) {
            ForEach(1...144, id: \.self) { _ in
                HStack(spacing: 0) {
                    ForEach(1...160, id: \.self) { _ in
                        Rectangle()
                            .foregroundColor(Color.gray)
                            .frame(width: 1, height: 1)
                    }
                }
            }
        }
    }
    
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
