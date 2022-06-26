// TODO: Refactor cycle calculations in the frame() function. Need to be more explicit and maybe encapsulated into their respective components

import Foundation

public class Clock {
    private let mmu: MMU
    private let ppu: PPU
    private let cpu: CPU
    private let apu: APU
    private let timer: Timer
    private let fps: Double
    private let frameTime: Double
    private var syncTasks: [(MMU, CPU, PPU, APU, Timer) -> Void] = []
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
    
    public func sync(task: @escaping (MMU, CPU, PPU, APU, Timer) -> Void) {
        self.syncTasks.append(task)
    }

    public func start(_ current: DispatchTime = .now()) {
        var next = current + frameTime

        DispatchQueue.global(qos: .userInteractive).async {
            if self.syncTasks.isNotEmpty {
                self.syncTasks.forEach { $0(self.mmu, self.cpu, self.ppu, self.apu, self.timer) }
                self.syncTasks.removeAll()
            }
            
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
    // Clock runs at 4 MHz
    public func frame() throws {
        var total: Int = 0
        let cycles: Int16 = 456 // Or 48 if we want to get more granular
        let seconds = Float(cycles) / 4000000
        
        StopWatch.global.start("frame")
        
        while total < 70224 {
            StopWatch.global.start("cpu")
            try cpu.run(cpuCycles: cycles / 4) // 1 MHz
            StopWatch.global.stop("cpu")
            
            StopWatch.global.start("mmu")
            try mmu.run(mmuCycles: cycles / 4) // 1 MHZ
            StopWatch.global.stop("mmu")
            
            StopWatch.global.start("ppu")
            try ppu.run(ppuCycles: cycles / 2) // 2 MHz
            StopWatch.global.stop("ppu")
            
            StopWatch.global.start("apu")
            try apu.run(seconds: seconds)
            StopWatch.global.stop("apu")
            
            StopWatch.global.start("timer")
            try timer.run(timerCycles: cycles / 16) // 250 KHz
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
