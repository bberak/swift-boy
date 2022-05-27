import Foundation

public class Timer {
    private let mmu: MMU
    private let divTreshold: UInt = 16
    private var counterThreshold: UInt = 0
    private var enabled = false
        
    private var counterCycles: UInt = 0 {
        didSet {
            let result = counterCycles.quotientAndRemainder(dividingBy: divTreshold)
            
            if result.quotient > 0 {
                let previousValue = mmu.timerCounter.read()
                let nextValue = previousValue &+ UInt8(result.quotient)
                
                if nextValue < previousValue {
                    // Overflowed
                    mmu.timerCounter.write(mmu.timerModulo.read())
                    mmu.interruptFlags.writeBit(Interrupts.timer.bit, as: true)
                } else {
                    mmu.timerCounter.write(nextValue)
                }
                
                counterCycles = result.remainder
            }
        }
    }
    
    private var divCycles: UInt = 0 {
        didSet {
            let result = divCycles.quotientAndRemainder(dividingBy: divTreshold)
            
            if result.quotient > 0 {
                let previousValue = mmu.dividerRegister.read()
                let nextValue = previousValue &+ UInt8(result.quotient)
                mmu.dividerRegister.write(nextValue, publish: false)
                divCycles = result.remainder
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
    
    public func run(timerCycles: Int16) throws {
        if enabled {
            counterCycles = counterCycles &+ UInt(timerCycles)
        }
                
        divCycles = divCycles &+ UInt(timerCycles)
    }
}
