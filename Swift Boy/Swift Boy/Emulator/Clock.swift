import Foundation

public class Clock {
    private let mmu: MMU
    private let ppu: PPU
    private let cpu: CPU
    private let timer: Timer
    private let fps: Double
    private let frameTime: Double
    public var printFrameDuration = false
    
    public init(_ mmu: MMU, _ ppu: PPU, _ cpu: CPU, _ timer: Timer) {
        self.mmu = mmu
        self.ppu = ppu
        self.cpu = cpu
        self.timer = timer;
        self.fps = 60
        self.frameTime = 1 / fps
    }

    public func start(_ current: DispatchTime = .now()) {
        var next = current + frameTime

        DispatchQueue.global(qos: .userInteractive).async {
            let start = DispatchTime.now()

            try! self.frame()

            let now = DispatchTime.now()

            if self.printFrameDuration {
                let ns = now.uptimeNanoseconds - start.uptimeNanoseconds
                print("ms", ns / 1000 / 1000)
            }

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
        let cycles: Int16 = 456 // 48
        
        StopWatch.global.start("total")
        
        while total < 70224 {
            try cpu.run(for: cycles / 4)
            try mmu.run(for: cycles / 4)
            try timer.run(for: cycles / 16)
            try ppu.run(for: cycles / 2)
            
            total = total + Int(cycles)
        }
        
        StopWatch.global.stop("total")
        StopWatch.global.maybePrintAll()
        StopWatch.global.resetAll()
    }
}
