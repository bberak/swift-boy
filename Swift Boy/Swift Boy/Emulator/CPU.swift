struct Instruction {
    internal var build: (CPU) throws -> Command
    
    init(build: @escaping (CPU) throws -> Command) {
        self.build = build
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

class Flags: CustomStringConvertible {
    internal var zero = false
    internal var subtract = false
    internal var halfCarry = false
    internal var carry = false
    
    public var description: String {
        return "z: \(zero ? 1 : 0), n: \(subtract ? 1 : 0), h: \(halfCarry ? 1 : 0), c: \(carry ? 1 : 0)"
    }
    
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

enum OpCode: Hashable, CustomStringConvertible {
    case byte(UInt8)
    case word(UInt8)
    
    public var description: String {
        switch self {
        case .byte(let value):
            return "0x\(value.toHexString())"
        case .word(let value):
            return "0x\(value.toHexString()) (word)"
        }
    }
}

enum CPUError: Error {
    case instructionNotFound(OpCode)
    case instructionNotImplemented(OpCode)
    case debug
}

public class CPU: CustomStringConvertible {
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
    private let ppu: PPU
    private var queue: [Command] = []
    private var cycles: Int16 = 0
    public var printOpcodes = false
    
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
    
    public var description: String {
        return "a: \(a), flags: (\(flags)), b: \(b), c: \(c), d: \(d), e: \(e), h: \(h), l: \(l), sp: \(sp), pc: \(pc), ime: \(ime), cycles: \(cycles)"
    }
    
    public init(_ mmu: MMU, _ ppu: PPU) {
        self.mmu = mmu
        self.ppu = ppu
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
        
        let enabled = try mmu.readByte(address: Interrupts.enabledAddress)
        
        if enabled == 0x00 {
            return
        }
        
        let flags = try mmu.readByte(address: Interrupts.flagAddress);
        
        if flags == 0x00 {
            return
        }
        
        for interrupt in Interrupts.priority {
            if enabled.bit(interrupt.bit) && flags.bit(interrupt.bit) {
                try pushWordOnStack(word: pc)
                try mmu.writeByte(address: Interrupts.flagAddress, byte: flags.reset(interrupt.bit))
                ime = false
                pc = interrupt.address
                cycles = cycles - 5
                
                return
            }
        }
    }
    
    public func run(for time: UInt8) throws {
        cycles = cycles + Int16(time)
     
        while cycles > 0 {
            try handleInterrupts()
            
            let cmd = queue.count > 0 ? queue.removeFirst() : try fetchNextInstruction().build(self)
            let next = try cmd.run()
             
            cycles = cycles - Int16(cmd.cycles)
             
            if next != nil {
                queue.insert(next!, at: 0)
            }
        }
    }
}
