struct Atomic {
    internal var cycles: Int
    internal var command: () -> Void
    
    init(cycles: Int, command: @escaping () -> Void) {
        self.cycles = cycles;
        self.command = command;
    }
}

struct Instruction {
    internal var operands: UInt8
    internal var operations: (CPU, [UInt8]) -> [Atomic]
    
    init(operands: UInt8, operations: @escaping (CPU, [UInt8]) -> [Atomic]) {
        self.operands = operands
        self.operations = operations
    }
}

class Flags: CustomStringConvertible {
    internal var z = false
    internal var n = false
    internal var h = false
    internal var c = false
    
    public var description: String {
        return "z: \(z ? 1 : 0), n: \(n ? 1 : 0), h: \(h ? 1 : 0), c: \(c ? 1 : 0)"
    }
    
    func clear() {
        z = false
        n = false
        h = false
        c = false
    }
    
    func toUInt8() -> UInt8 {
        var result: UInt8 = 0;
        let arr = [z, n, h, c]
        
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
    case bit8(UInt8)
    case bit16(UInt8)
    
    public var description: String {
        switch self {
        case .bit8(let value):
            return "0x\(value.toHexString()) (8bit)"
        case .bit16(let value):
            return "0x\(value.toHexString()) (16bit)"
        }
    }
}

enum CPUError: Error {
    case instructionNotFound(OpCode)
}

public class CPU: CustomStringConvertible {
    private let mmu: MMU
    private var pc: UInt16
    private var cycles: Int
    internal var a: UInt8
    internal let f: Flags
    internal var b: UInt8
    internal var c: UInt8
    internal var d: UInt8
    internal var e: UInt8
    internal var h: UInt8
    internal var l: UInt8
    internal var sp: UInt16
    
    public var description: String {
        return "a: \(a), f: (\(f)), b: \(b), c: \(c), d: \(d), e: \(e), h: \(h), l: \(l), sp: \(sp), pc: \(pc), cycles: \(cycles)"
    }
    
    public init(mmu: MMU) {
        self.mmu = mmu
        a = 0
        f = Flags()
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
    
    func readNextOpCode() throws -> OpCode {
        var value = try mmu.readByte(address: pc)
        pc+=1
        
        if value == 0xCB {
            value = try mmu.readByte(address: pc)
            pc+=1
            
            return OpCode.bit16(value)
        }
        
        return OpCode.bit8(value)
    }
    
    func readNextOperands(num: UInt8) throws -> [UInt8] {
        var operands: [UInt8] = []
        
        if num == 0 {
            return operands
        }
        
        for _ in 0...num-1 {
            operands.append(try mmu.readByte(address: pc))
            pc+=1
        }
        
        return operands
    }
    
    public func run() throws {
        while true {
            let opCode = try readNextOpCode()
            
            print("opCode \(opCode)")
            
            if let instruction = instructions[opCode] {
                let operands = try readNextOperands(num: instruction.operands)
                let ops = instruction.operations(self, operands)
                
                ops.forEach { op in
                    op.command()
                    cycles+=op.cycles
                }
            } else {
                throw CPUError.instructionNotFound(opCode)
            }
            
            print(self)
        }
    }
}
