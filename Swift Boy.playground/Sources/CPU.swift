struct Atom {
    internal var cycles: Int
    internal var command: () throws -> Void
    
    init(cycles: Int, command: @escaping () throws -> Void) {
        self.cycles = cycles;
        self.command = command;
    }
}

struct Instruction {
    internal var atoms: (CPU) throws -> [Atom]
    
    init(atoms: @escaping (CPU) throws -> [Atom]) {
        self.atoms = atoms
    }
    
    static func atomic(cycles: Int, command: @escaping (CPU) throws -> Void) -> Instruction {
        return Instruction { cpu in
            return [Atom(cycles: cycles) {
                try command(cpu)
            }]
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
}

public class CPU: CustomStringConvertible {
    private var pc: UInt16
    private var cycles: Int
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
        return "a: \(a), f: (\(flags)), b: \(b), c: \(c), d: \(d), e: \(e), h: \(h), l: \(l), sp: \(sp), pc: \(pc), cycles: \(cycles)"
    }
    
    public init(mmu: MMU) {
        self.mmu = mmu
        flags = Flags()
        a = 0
        b = 0
        c = 0
        d = 0
        e = 0
        h = 0
        l = 0
        sp = 0x0000
        pc = 0x0000
        cycles = 0
    }
    
    func readNextByte() throws -> UInt8 {
        let byte = try mmu.readByte(address: pc)
        pc+=1
        
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
        
    public func start() throws {
        while true {
            let opCode = try readNextOpCode()
            
            print("opCode: \(opCode)")
            
            if let instruction = instructions[opCode] {
                let atoms = try instruction.atoms(self)
                
                try atoms.forEach { atom in
                    try atom.command()
                    cycles+=atom.cycles
                }
            } else {
                throw CPUError.instructionNotFound(opCode)
            }
            
            print(self)
        }
    }
}
