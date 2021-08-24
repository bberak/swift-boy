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
    internal let flags: Flags
    internal var a: UInt8
    internal var b: UInt8
    internal var c: UInt8
    internal var d: UInt8
    internal var e: UInt8
    internal var h: UInt8
    internal var l: UInt8
    internal var sp: UInt16
    internal var pc: UInt16
    internal var ime: Bool
    private var cycles: Int16
    private let ppu: PPU
    
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
        self.flags = Flags()
        self.a = 0
        self.b = 0
        self.c = 0
        self.d = 0
        self.e = 0
        self.h = 0
        self.l = 0
        self.sp = 0x0000
        self.pc = 0x0000
        self.ime = false
        self.cycles = 0
        self.mmu.subscribe(address: 0xFFFF) { byte in
            print("Interrupt Enable (R/W):", byte.toHexString())
        }
        self.mmu.subscribe(address: 0xFF0F) { byte in
            print("Interrupt Flag (R/W):", byte.toHexString())
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
    
    public func run(for time: Int16) throws {
        cycles = cycles + time
        
        while cycles > 0 {
            let opCode = try readNextOpCode()
            
            if let instruction = instructions[opCode] {
                var cmd: Command? = try instruction.build(self)
                
                while cmd != nil {
                    let next = try cmd!.run()
                    cycles = cycles - Int16(cmd!.cycles)
                    cmd = next
                }
            } else {
                throw CPUError.instructionNotFound(opCode)
            }
        }
    }
}
