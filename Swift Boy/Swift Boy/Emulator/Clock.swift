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

//    public func start(_ current: DispatchTime = .now()) {
//        var next = current + frameTime
//
//        DispatchQueue.global(qos: .userInteractive).async {
//            let start = DispatchTime.now()
//
//            try! self.frame()
//
//            let now = DispatchTime.now()
//
//            if self.printFrameDuration {
//                let ns = now.uptimeNanoseconds - start.uptimeNanoseconds
//                print("ms", ns / 1000 / 1000)
//            }
//
//            if now > next {
//                next = now
//            }
//
//            DispatchQueue.main.asyncAfter(deadline: next, execute: {
//                self.start(next)
//            })
//        }
//    }
    
    // 70224 clock cycles = 1 frame
    // 456 clock cycles = 1 scanline
    public func frame() async throws {
        var total: Int = 0
        let cycles: Int16 = 456
        
        StopWatch.global.start("total")
        
        while total < 70224 {
            let t1 = Task(priority: .userInitiated) {
                try cpu.run(for: cycles / 4)
                try mmu.run(for: cycles / 4)
                try timer.run(for: cycles / 16)
            }

            let t2 = Task(priority: .userInitiated) {
                try ppu.run(for: cycles / 2)
            }

            try await [t1.value, t2.value]
            
            total = total + Int(cycles)
        }
        
        StopWatch.global.stop("total")
        StopWatch.global.maybePrintAll()
        StopWatch.global.resetAll()
        
        try await self.frame()
        
//        while total < 70224 {
//            total = total + Int(cycles)
//        }
        
//            let j1 = Job {
//                try! self.cpu.run(for: cycles / 4)
//                try! self.mmu.run(for: cycles / 4)
//                try! self.timer.run(for: cycles / 16)
//
//            }
//
//            let j2 = Job {
//                try! self.ppu.run(for: cycles / 2)
//            }
//
//            j1.qualityOfService = QualityOfService.userInteractive
//            j2.qualityOfService = QualityOfService.userInteractive
//            j1.start()
//            j2.start()
//
//            while j1.isFinished == false || j2.isFinished == false {
//                try await Task.sleep(nanoseconds: 100)
//            }
           
//            await withThrowingTaskGroup(of: Void.self) { group in
//                group.addTask {
//                    await sw.start("rest")
//                    try self.cpu.run(for: cycles / 4)
//                    try self.mmu.run(for: cycles / 4)
//                    try self.timer.run(for: cycles / 16)
//                    await sw.stop("rest")
//                }
//
//                group.addTask {
//                    await sw.start("ppu")
//                    try self.ppu.run(for: cycles / 2)
//                    await sw.stop("ppu")
//                }
//            }

//
//             let t1 = Task(priority: .userInitiated) {
//                 await sw.start("rest")
//                 // await Task.sleep(64000)
//                 try cpu.run(for: cycles / 4)
//                 try mmu.run(for: cycles / 4)
//                 try timer.run(for: cycles / 16)
//                 await sw.stop("rest")
//             }
//
//             let t2 = Task(priority: .userInitiated) {
//                 await sw.start("ppu")
//                 // await Task.sleep(64000)
//                 try ppu.run(for: cycles / 2)
//                 await sw.stop("ppu")
//             }
//
//            try await [t1.value, t2.value]
    

//        let t1 = Task(priority: .userInitiated) {
//             await sw.start("rest")
//             try await Task.sleep(nanoseconds: 3 * 1000000)
//             await sw.stop("rest")
//         }
//
//        let t2 = Task(priority: .userInitiated) {
//             await sw.start("ppu")
//             try await Task.sleep(nanoseconds: 6 * 1000000)
//             await sw.stop("ppu")
//         }
//
//        try await [t1.value, t2.value]

//        while total < 70224 {
//            DispatchQueue.concurrentPerform(iterations: 3) { n in
//                switch n {
//                case 0:
//                    try! cpu.run(for: cycles / 4)
//                case 1:
//                    try! mmu.run(for: cycles / 4)
//                case 2:
//                    try! ppu.run(for: cycles / 2)
//                case 3:
//                    try! timer.run(for: cycles / 16)
//                default:
//                    print("Did not handle \(n)")
//                }
//            }
//
//            total = total + Int(cycles)
//        }
    }
}
