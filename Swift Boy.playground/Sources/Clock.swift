import Foundation

public class Clock {
    private let mmu: MMU
    private let ppu: PPU
    private let cpu: CPU
    private let fps: Double
    private let frameTime: Double
    
    public init(_ mmu: MMU, _ ppu: PPU, _ cpu: CPU) {
        self.mmu = mmu
        self.ppu = ppu
        self.cpu = cpu
        self.fps = 60
        self.frameTime = 1 / fps
    }
    
    public func start(_ current: DispatchTime = .now()) {
        var next = current + frameTime
        
        DispatchQueue.global(qos: .userInteractive).async {
            try! self.frame()
            let now = DispatchTime.now()
            
            if now > next {
                next = now
            }
   
            DispatchQueue.main.asyncAfter(deadline: next, execute: {
                self.start(next)
            })
        }
    }
       
    // 70224 clock cycles = 1 frame
    // 456 clock cycles = 1 scanline
    public func frame() throws {
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
