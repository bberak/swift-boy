struct Atomic {
    internal var cycles: Int
    internal var command: () -> Void
    
    init(_ cycles: Int, command: @escaping () -> Void) {
        self.cycles = cycles;
        self.command = command;
    }
}

struct Instruction {
    internal var bytes: UInt16
    internal var operations: (CPU, [UInt8]) -> [Atomic]
    
    init(bytes: UInt16, operations: @escaping (CPU, [UInt8]) -> [Atomic]) {
        self.bytes = bytes
        self.operations = operations
    }
}

class Flags: CustomStringConvertible {
    private var z = false
    private var n = false
    private var h = false
    private var c = false
    
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

public class CPU: CustomStringConvertible {
    private let mmu: MMU
    private var a: UInt8
    private let f: Flags
    private var b: UInt8
    private var c: UInt8
    private var d: UInt8
    private var e: UInt8
    private var h: UInt8
    private var l: UInt8
    internal var sp: UInt16
    private var pc: UInt16
    private var cycles: Int
    
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
    
    public func start() throws {
        print(self)
        
        let opCode = try mmu.readByte(address: pc)
        
        if let instruction = instructions[opCode] {
            let operands: [UInt8] = try (1...instruction.bytes-1).map { try mmu.readByte(address: pc + $0) }
            let ops = instruction.operations(self, operands)
            
            ops.forEach { op in
                op.command()
                cycles+=op.cycles
            }
            
            pc+=instruction.bytes
        }
        
        print(self)
    }
}
