struct Instruction {
    internal var toCommand: (CPU) throws -> Command
    
    init(toCommand: @escaping (CPU) throws -> Command) {
        self.toCommand = toCommand
    }
    
    static func atomic(cycles: UInt16, command: @escaping (CPU) throws -> Void) -> Instruction {
        return Instruction { cpu in
            return Command(cycles: cycles) {
                try command(cpu)
                return nil
            }
        }
    }
}

class Flags {
    internal var zero = false
    internal var subtract = false
    internal var halfCarry = false
    internal var carry = false
    
    func clear() {
        zero = false
        subtract = false
        halfCarry = false
        carry = false
    }
    
    func set(byte: UInt8) {
        zero = (byte & 0b10000000) != 0
        subtract = (byte & 0b01000000) != 0
        halfCarry = (byte & 0b00100000) != 0
        carry = (byte & 0b00010000) != 0
    }
    
    func toUInt8() -> UInt8 {
        var result: UInt8 = 0;
        let arr = [zero, subtract, halfCarry, carry]
        
        arr.forEach {
            if $0 { 
                result+=1 
            }
            
            result<<=1
        }
        
        result<<=3
        
        return result
    }
}

enum OpCode: Hashable {
    case byte(UInt8)
    case word(UInt8)
}

enum CPUError: Error {
    case instructionNotFound(OpCode)
    case instructionNotImplemented(OpCode)
}

public struct Interrupts {
    static let vBlank = (bit: UInt8(0), address: UInt16(0x0040))
    static let lcdStat = (bit: UInt8(1), address: UInt16(0x0048))
    static let timer = (bit: UInt8(2), address: UInt16(0x0050))
    static let serial = (bit: UInt8(3), address: UInt16(0x0058))
    static let joypad = (bit: UInt8(4), address: UInt16(0x0060))
    static let priority = [Interrupts.vBlank, Interrupts.lcdStat, Interrupts.timer, Interrupts.serial, Interrupts.joypad]
}

public class CPU {
    internal let mmu: MMU
    internal let flags: Flags = Flags()
    internal var a: UInt8 = 0
    internal var b: UInt8 = 0
    internal var c: UInt8 = 0
    internal var d: UInt8 = 0
    internal var e: UInt8 = 0
    internal var h: UInt8 = 0
    internal var l: UInt8 = 0
    internal var sp: UInt16 = 0x0000
    internal var pc: UInt16 = 0x0000
    internal var ime: Bool = false
    private var queue: [Command] = []
    private var cycles: Int16 = 0
    public var printOpcodes = false
    public var enabled = true
    
    internal var af: UInt16 {
        get {
            return [flags.toUInt8(), a].toWord()
        }
        
        set {
            let bytes = newValue.toBytes()
            a = bytes[1]
            flags.set(byte: bytes[0])
        }
    }
    
    internal var bc: UInt16 {
        get {
            return [c, b].toWord()
        }
        
        set {
            let bytes = newValue.toBytes()
            b = bytes[1]
            c = bytes[0]
        }
    }
    
    internal var de: UInt16 {
        get {
            return [e, d].toWord()
        }
        
        set {
            let bytes = newValue.toBytes()
            d = bytes[1]
            e = bytes[0]
        }
    }
    
    internal var hl: UInt16 {
        get {
            return [l, h].toWord()
        }
        
        set {
            let bytes = newValue.toBytes()
            h = bytes[1]
            l = bytes[0]
        }
    }
    
    public init(_ mmu: MMU) {
        self.mmu = mmu
        
        self.mmu.interruptFlags.subscribe { flags in
            if flags > 0 && self.enabled == false {
                self.enabled = flags & self.mmu.interruptsEnabled.read() > 0
            }
        }
    }
    
    func readNextByte() throws -> UInt8 {
        let byte = try mmu.readByte(address: pc)
        pc = pc &+ 1
        
        return byte
    }
    
    func readNextWord() throws -> UInt16 {
        return [try readNextByte(), try readNextByte()].toWord()
    }
    
    func readNextOpCode() throws -> OpCode {
        var value = try readNextByte()
        
        if value == 0xCB {
            value = try readNextByte()
            
            return OpCode.word(value)
        }
        
        return OpCode.byte(value)
    }
    
    func popByteOffStack() throws -> UInt8 {
        let byte = try mmu.readByte(address: sp)
        sp = sp &+ 1
        return byte
    }
    
    func popWordOffStack() throws -> UInt16 {
        let word = try mmu.readWord(address: sp)
        sp = sp &+ 2
        return word
    }
    
    func pushByteOnStack(byte: UInt8) throws -> Void {
        sp = sp &- 1
        try mmu.writeByte(address: sp, byte: byte)
    }
    
    func pushWordOnStack(word: UInt16) throws -> Void {
        sp = sp &- 2
        try mmu.writeWord(address: sp, word: word)
    }
    
    func fetchNextInstruction() throws -> Instruction {
        let opCode = try readNextOpCode()
        let instruction = instructions[opCode]
        
        if instruction == nil {
            throw CPUError.instructionNotFound(opCode)
        }
        
        if printOpcodes {
            print(opCode)
        }
        
        return instruction!
    }
    
    func handleInterrupts() throws {
        if ime == false {
            return
        }
        
        let enabled = mmu.interruptsEnabled.read()
        
        if enabled == 0x00 {
            return
        }
        
        let flags = mmu.interruptFlags.read()
        
        if flags == 0x00 {
            return
        }
        
        for interrupt in Interrupts.priority {
            if enabled.bit(interrupt.bit) && flags.bit(interrupt.bit) {
                try pushWordOnStack(word: pc)
                mmu.interruptFlags.write(flags.reset(interrupt.bit))
                ime = false
                pc = interrupt.address
                cycles = cycles - 5
                
                return
            }
        }
    }
        
    public func run(for time: Int16) throws {
        cycles = cycles + (enabled ? time : 0)
     
        while cycles > 0 && enabled {
            if queue.count > 0 {
                let cmd = queue.removeFirst()
                // TODO: Only execute cmd if you have enough cycles?
                // TODO: if cmd.cycles > cycles {
                // TODO:    queue.insert(cmd, at: 0)
                // TODO:    return
                // TODO: }
                
                let next = try cmd.run()
                
                cycles = cycles - Int16(cmd.cycles)
                
                if next != nil {
                    queue.insert(next!, at: 0)
                }
            } else {
                try handleInterrupts()
                queue.insert(try fetchNextInstruction().toCommand(self), at: 0)
            }
        }
    }
}
