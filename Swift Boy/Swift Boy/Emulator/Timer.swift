import Foundation

public class Timer {
    private let mmu: MMU
    private var enabled = false
    private var modulo: UInt8 = 0
    private var speed: UInt = 0
    
    private var cycles: UInt = 0 {
        didSet {
            if cycles % 16 == 0 {
                divider = divider &+ 1
            }
            
            if cycles % speed == 0 {
                counter = counter &+ 1
            }
        }
    }
    
    private var divider: UInt8 {
        get {
            return try! mmu.readByte(address: 0xFF04)
        }
        set {
            try! mmu.writeByte(address: 0xFF04, byte: newValue)
        }
    }
    
    private var counter: UInt8 {
        get {
            return try! mmu.readByte(address: 0xFF05)
        }
        set {
            if newValue == 0 {
                var flags = try! mmu.readByte(address: Interrupts.flagAddress)
                flags = flags.set(Interrupts.timer.bit)
                try! mmu.writeByte(address: 0xFF05, byte: modulo)
                try! mmu.writeByte(address: Interrupts.flagAddress, byte: flags)
            } else {
                try! mmu.writeByte(address: 0xFF05, byte: newValue)
            }
        }
    }
        
    public init(_ mmu: MMU) {
        self.mmu = mmu
        
        self.mmu.subscribe(address: 0xFF06) { modulo in
            self.modulo = modulo
        }
        
        self.mmu.subscribe(address: 0xFF07) { control in
            self.enabled = control.bit(2)
            
            let n = control & 0b00000011
            
            if n == 0 {
                self.speed = 64
            } else if n == 1 {
                self.speed = 1
            } else if n == 2 {
                self.speed = 4
            } else {
                self.speed = 16
            }
        }
    }
    
    public func run(for time: UInt8) throws {
        if enabled {
            cycles = cycles &+ UInt(time)
        }
    }
}
