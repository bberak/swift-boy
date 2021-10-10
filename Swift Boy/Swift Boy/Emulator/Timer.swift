import Foundation

public class Timer {
    private let mmu: MMU
    private let divTreshold: UInt = 16
    private var counterThreshold: UInt = 0
    private var enabled = false
        
    private var counterCycles: UInt = 0 {
        didSet {
            // TODO:
            // Try refactor code below
            if counterCycles >= counterThreshold {
                let delta = counterThreshold == 1 ? UInt8(counterCycles) : UInt8(1)
                let prev = mmu.timerCounter.read()
                let next = prev &+ delta
                if next < prev {
                    // Overflowed
                    mmu.timerCounter.write(mmu.timerModulo.read())
                    mmu.interruptFlags.writeBit(Interrupts.timer.bit, as: true)
                } else {
                    mmu.timerCounter.write(next)
                }
                counterCycles = counterCycles - UInt(delta)
            }
        }
    }
    
    private var divCycles: UInt = 0 {
        didSet {
            if divCycles >= divTreshold {
                let divider = mmu.dividerRegister
                divider.write(divider.read() &+ 1, publish: false)
                divCycles = divCycles - divTreshold
            }
        }
    }
    
    public init(_ mmu: MMU) {
        self.mmu = mmu
        
        self.mmu.dividerRegister.subscribe { _ in
            self.mmu.dividerRegister.write(0, publish: false)
        }
        
        self.mmu.timerControl.subscribe { control in
            self.enabled = control.bit(2)
            
            let speed = control & 0b00000011
            
            if speed == 0 {
                self.counterThreshold = 64
            } else if speed == 1 {
                self.counterThreshold = 1
            } else if speed == 2 {
                self.counterThreshold = 4
            } else {
                self.counterThreshold = 16
            }
        }
    }
    
    public func run(for time: UInt8) throws {
        if enabled {
            counterCycles = counterCycles &+ UInt(time)
        }
        
        divCycles = divCycles &+ UInt(time)
    }
}
