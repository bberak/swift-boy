let instructions: [OpCode: Instruction] = [
    OpCode.byte(0x00): Instruction.atomic(cycles: 1) { cpu in
        // Only advances the program counter by 1. Performs no other operations that would have an effect.
    },
    OpCode.byte(0x01): Instruction.atomic(cycles: 3) { cpu in
        // Load the 2 bytes of immediate data into register pair BC.
        cpu.bc = try cpu.readNextWord()
    },
    OpCode.byte(0x02): Instruction.atomic(cycles: 3) { cpu in
        // Store the contents of register A in the memory location specified by register pair BC.
        try cpu.mmu.writeByte(address: cpu.bc, byte: cpu.a)
    },
    OpCode.byte(0x03): Instruction.atomic(cycles: 2) { cpu in
        // Increment the contents of register pair BC by 1.
        cpu.bc+=1
    },
    OpCode.byte(0x04): Instruction.atomic(cycles: 1) { cpu in
        // Increment the contents of register B by 1.
        let result = add(cpu.b, 1)
        cpu.b = result.value
        cpu.f.z = cpu.b == 0
        cpu.f.n = false
        cpu.f.h = result.halfCarry
    },
    OpCode.byte(0x05): Instruction.atomic(cycles: 1) { cpu in
        // Decrement the contents of register B by 1
        let result = sub(cpu.b, 1)
        cpu.b = result.value
        cpu.f.z = cpu.b == 0
        cpu.f.n = true
        cpu.f.h = result.halfCarry
    },
    OpCode.byte(0x06): Instruction.atomic(cycles: 2) { cpu in
        // Load the 8-bit immediate operand d8 into register B.
        cpu.b = try cpu.readNextByte()
    },
    OpCode.byte(0x07): Instruction.atomic(cycles: 1) { cpu in
        // Rotate the contents of register A to the left. That is, the contents of bit 0 are copied
        // to bit 1, and the previous contents of bit 1 (before the copy operation) are copied to bit 2.
        // The same operation is repeated in sequence for the rest of the register. The contents of bit 7
        // are placed in both the CY flag and bit 0 of register A.
        let carry = cpu.a.bit(7)
        cpu.a = (cpu.a << 1) + (carry ? 1 : 0)
        cpu.f.c = carry
    }
]

//-    OpCode.byte(0x31): Instruction.atomic(cycles: 3) { cpu in
//-        // Load the 2 bytes of immediate data into register pair SP.
//-        cpu.sp = try cpu.readNextWord()
//-    },
//-    OpCode.byte(0xAF): Instruction.atomic(cycles: 1) { cpu in
//-        // Take the logical exclusive-OR for each bit of the contents of register A and the contents of register A,
//-        // and store the results in register A.
//-        cpu.a^=cpu.a
//-        cpu.f.z = cpu.a == 0
//-    },
//-    OpCode.byte(0x21): Instruction.atomic(cycles: 3) { cpu in
//-        // Load the 2 bytes of immediate data into register pair HL.
//-        cpu.hl = try cpu.readNextWord()
//-    }
