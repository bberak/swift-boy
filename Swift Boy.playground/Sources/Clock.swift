import Foundation

public class Clock {
    private let mmu: MMU
    private let ppu: PPU
    private let cpu: CPU
   
    public init(_ mmu: MMU, _ ppu: PPU, _ cpu: CPU) {
        self.mmu = mmu
        self.ppu = ppu
        self.cpu = cpu
    }
    
    public func start() {
        let fps: Double = 60
        let target: Double = 1 / fps

        DispatchQueue.global(qos: .userInteractive).async {
            let start = CFAbsoluteTimeGetCurrent()
            try! self.frame()
            let diff = CFAbsoluteTimeGetCurrent() - start
            let delay = diff > target ? 0 : target - diff

            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                self.start()
            })
        }
    }
            
    public func frame() throws {
        // 70224 clock cycles = 1 frame
        // 456 clock cycles = 1 scanline
        
        var total: Int = 0
        let cycles: Int16 = 48
        
        while total < 70224 {
            try cpu.run(for: cycles / 4)
            try mmu.run(for: cycles / 4)
            try ppu.run(for: cycles / 2)
            
            total = total + Int(cycles)
        }
    }
}
