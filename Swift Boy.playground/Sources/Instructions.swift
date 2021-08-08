let instructions: [OpCode: Instruction] = [
    OpCode.byte(0x00): Instruction.atomic(cycles: 1) { cpu in
        // Only advances the program counter by 1. Performs no other operations that would have an effect (nop).
    },
    OpCode.byte(0x01): Instruction.atomic(cycles: 3) { cpu in
        // Load the 2 bytes of immediate data into register pair BC.
        cpu.bc = try cpu.readNextWord()
    },
    OpCode.byte(0x02): Instruction.atomic(cycles: 3) { cpu in
        // Store the contents of register A in the memory location specified by register pair BC.
        try cpu.mmu.writeByte(address: cpu.bc, byte: cpu.a)
    },
    OpCode.byte(0x31): Instruction.atomic(cycles: 3) { cpu in
        // Load the 2 bytes of immediate data into register pair SP.
        cpu.sp = try cpu.readNextWord()
    },
    OpCode.byte(0xAF): Instruction.atomic(cycles: 1) { cpu in
        // Take the logical exclusive-OR for each bit of the contents of register A and the contents of register A,
        // and store the results in register A.
        cpu.a^=cpu.a
        cpu.f.z = cpu.a == 0
    },
    OpCode.byte(0x21): Instruction.atomic(cycles: 3) { cpu in
        // Load the 2 bytes of immediate data into register pair HL.
        cpu.hl = try cpu.readNextWord()
    },
]
