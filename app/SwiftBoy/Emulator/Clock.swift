import Foundation

public class Clock {
    private let mmu: MMU
    private let ppu: PPU
    private let cpu: CPU
    private let apu: APU
    private let timer: Timer
    private let fps: Double
    private let frameTime: Double
    public var printFrameDuration = false
    
    public init(_ mmu: MMU, _ ppu: PPU, _ cpu: CPU, _ apu: APU, _ timer: Timer) {
        self.mmu = mmu
        self.ppu = ppu
        self.cpu = cpu
        self.apu = apu
        self.timer = timer
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
        
        StopWatch.global.start("frame")
        
        while total < 70224 {
            
            StopWatch.global.start("cpu")
            try cpu.run(for: cycles / 4)
            StopWatch.global.stop("cpu")
            
            StopWatch.global.start("mmu")
            try mmu.run(for: cycles / 4)
            StopWatch.global.stop("mmu")
            
            StopWatch.global.start("ppu")
            try ppu.run(for: cycles / 2)
            StopWatch.global.stop("ppu")
            
            StopWatch.global.start("apu")
            try apu.run(for: cycles / 16)
            StopWatch.global.stop("apu")
            
            StopWatch.global.start("timer")
            try timer.run(for: cycles / 16)
            StopWatch.global.stop("timer")
            
            total = total + Int(cycles)
        }
        
        StopWatch.global.stop("frame")
        maybe {
            StopWatch.global.printAll()
        }
        StopWatch.global.resetAll()
    }
}
