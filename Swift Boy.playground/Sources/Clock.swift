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
        DispatchQueue.global(qos: .userInteractive).async {
            try! self.tick()
            
            DispatchQueue.main.async {
                self.start()
            }
        }
    }
    
    public func tick() throws {
        //-- 70224 clock cycles = 1 frame = 1/60 sec
        //-- 456 clock cycles = 1 scanline
        let cycles: Int16 = 32
        
        try cpu.run(for: cycles / 4)
        try mmu.run(for: cycles / 4)
        try ppu.run(for: cycles / 2)
    }
}
