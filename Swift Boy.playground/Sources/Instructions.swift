let instructions: [OpCode: Instruction] = [
    OpCode.bit8(0x31): Instruction.atomic(cycles: 3) { cpu in
        let operands = try cpu.readNextBytes(count: 2)
        let address = operands.toWord()
        cpu.sp = address
    },
    OpCode.bit8(0xAF): Instruction.atomic(cycles: 1) { cpu in
        cpu.a^=cpu.a
        cpu.f.z = cpu.a == 0
    },
    OpCode.bit8(0x21): Instruction.atomic(cycles: 3) { cpu in
        let operands = try cpu.readNextBytes(count: 2)
        cpu.l = operands[0]
        cpu.h = operands[1]
    },
]
