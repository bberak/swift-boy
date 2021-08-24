import Foundation

public class Clock {
    private let cpu: CPU
    private let ppu: PPU
    
    public init(_ cpu: CPU, _ ppu: PPU) {
        self.cpu = cpu
        self.ppu = ppu
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
        try cpu.run(for: 8)
        try ppu.run(for: 16)
    }
}
