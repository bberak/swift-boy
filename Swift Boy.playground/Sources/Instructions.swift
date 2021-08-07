let instructions: [UInt8: Instruction] = [
    0x31: Instruction(bytes: 3) { cpu, operands in 
        return [
            Atomic(3) {
                var address = operands.toWord()
                cpu.sp = address
            }
        ]
    },
    0x33: Instruction(bytes: 3) { cpu, operands in
        return [
            Atomic(3) {
                var address = operands.toWord()
            }
        ]
    }
]
