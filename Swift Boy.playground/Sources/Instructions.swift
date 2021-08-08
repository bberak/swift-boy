let instructions: [OpCode: Instruction] = [
    OpCode.bit8(0x31): Instruction(operands: 2) { cpu, operands in
        return [
            Atomic(cycles: 3) {
                var address = operands.toWord()
                cpu.sp = address
            }
        ]
    },
    OpCode.bit8(0xAF): Instruction(operands: 0) { cpu, operands in
        return [
            Atomic(cycles: 1) {
                cpu.a^=cpu.a
                cpu.f.z = cpu.a == 0
            }
        ]
    },
    OpCode.bit8(0x21): Instruction(operands: 2) { cpu, operands in
        return [
            Atomic(cycles: 3) {
                cpu.l = operands[0]
                cpu.h = operands[1]
            }
        ]
    },
]
