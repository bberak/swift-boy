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
                let prev = counter
                let next = prev &+ delta
                if next < prev {
                    // Overflowed
                    let modulo = try! mmu.readByte(address: 0xFF06)
                    var flags = try! mmu.readByte(address: Interrupts.flagAddress)
                    flags = flags.set(Interrupts.timer.bit)
                    counter = modulo
                    try! mmu.writeByte(address: Interrupts.flagAddress, byte: flags)
                } else {
                    counter = next
                }
                counterCycles = counterCycles - UInt(delta)
            }
        }
    }
    
    private var counter: UInt8 {
        get {
            return try! mmu.readByte(address: 0xFF05)
        }
        set {
            try! mmu.writeByte(address: 0xFF05, byte: newValue)
        }
    }
    
    private var divCycles: UInt = 0 {
        didSet {
            if divCycles >= divTreshold {
                divider = divider &+ 1
                divCycles = divCycles - divTreshold
            }
        }
    }
    
    private var divider: UInt8 {
        get {
            return try! mmu.readByte(address: 0xFF04)
        }
        set {
            try! mmu.writeByte(address: 0xFF04, byte: newValue, publish: false)
        }
    }
    
    public init(_ mmu: MMU) {
        self.mmu = mmu
        
        self.mmu.subscribe(address: 0xFF04) { _ in
            self.divider = 0
        }
        
        self.mmu.subscribe(address: 0xFF07) { control in
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
