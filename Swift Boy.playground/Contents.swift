import Foundation

let cartridge = Cartridge(path: #fileLiteral(resourceName: "cpu_instrs.gb"), title: "Blargg CPU Test")
let mmu = MMU(cartridge: cartridge)
let cpu = CPU(mmu: mmu)


func printInstruction(op: UInt8) {
print(
"""
    OpCode.word(0x\(op.toHexString())): Instruction.atomic(cycles: 2) { cpu in
        // Add comment here
        throw CPUError.instructionNotImplemented(OpCode.word(0x\(op.toHexString())))
    },
""")
}

for i in 0x00...0xFF {
    printInstruction(op: UInt8(i))
}

//try cpu.start()

