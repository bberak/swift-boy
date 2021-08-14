let instructions: [OpCode: Instruction] = [
	OpCode.byte(0x00): Instruction.atomic(cycles: 1) { cpu in
		// NOP
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: - - - -
		//
		// Only advances the program counter by 1. Performs no other operations that would have an effect.
		//
		throw CPUError.instructionNotImplemented(OpCode.byte(0x00))
	},
	OpCode.byte(0x01): Instruction.atomic(cycles: 3) { cpu in
		// LD BC, d16
		//
		// Cycles: 3
		// Bytes: 3
		// Flags: - - - -
		//
		// Load the 2 bytes of immediate data into register pair BC.
		// The first byte of immediate data is the lower byte (i.e., bits 0-7), and the second byte of immediate data is the higher byte (i.e., bits 8-15).
		//
		//let data = try cpu.readNextWord()
		//cpu.bc = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x01))
	},
	OpCode.byte(0x02): Instruction.atomic(cycles: 2) { cpu in
		// LD (BC), A
		//
		// Cycles: 2
		// Bytes: 1
		// Flags: - - - -
		//
		// Store the contents of register A in the memory location specified by register pair BC.
		//
		//let data = cpu.a
		//try cpu.mmu.writeByte(address: cpu.bc, byte: data)
		throw CPUError.instructionNotImplemented(OpCode.byte(0x02))
	},
	OpCode.byte(0x03): Instruction.atomic(cycles: 2) { cpu in
		// INC BC
		//
		// Cycles: 2
		// Bytes: 1
		// Flags: - - - -
		//
		// Increment the contents of register pair BC by 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.byte(0x03))
	},
	OpCode.byte(0x04): Instruction.atomic(cycles: 1) { cpu in
		// INC B
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 0 8-bit -
		//
		// Increment the contents of register B by 1.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x04))
	},
	OpCode.byte(0x05): Instruction.atomic(cycles: 1) { cpu in
		// DEC B
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 1 8-bit -
		//
		// Decrement the contents of register B by 1.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x05))
	},
	OpCode.byte(0x06): Instruction.atomic(cycles: 2) { cpu in
		// LD B, d8
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Load the 8-bit immediate operand d8 into register B.
		//
		//let data = try cpu.readNextByte()
		//cpu.b = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x06))
	},
	OpCode.byte(0x07): Instruction.atomic(cycles: 1) { cpu in
		// RLCA
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: 0 0 0 A7
		//
		// Rotate the contents of register A to the left. That is, the contents of bit 0 are copied to bit 1, and the previous contents of bit 1 (before the copy operation) are copied to bit 2. The same operation is repeated in sequence for the rest of the register. The contents of bit 7 are placed in both the CY flag and bit 0 of register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x07))
	},
	OpCode.byte(0x08): Instruction.atomic(cycles: 5) { cpu in
		// LD (a16), SP
		//
		// Cycles: 5
		// Bytes: 3
		// Flags: - - - -
		//
		// Store the lower byte of stack pointer SP at the address specified by the 16-bit immediate operand a16, and store the upper byte of SP at address a16 + 1.
		//
		//try cpu.mmu.writeByte(address: cpu.a16, byte: data)
		throw CPUError.instructionNotImplemented(OpCode.byte(0x08))
	},
	OpCode.byte(0x09): Instruction.atomic(cycles: 2) { cpu in
		// ADD HL, BC
		//
		// Cycles: 2
		// Bytes: 1
		// Flags: - 0 16-bit 16-bit
		//
		// Add the contents of register pair BC to the contents of register pair HL, and store the results in register pair HL.
		//
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x09))
	},
	OpCode.byte(0x0A): Instruction.atomic(cycles: 2) { cpu in
		// LD A, (BC)
		//
		// Cycles: 2
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the 8-bit contents of memory specified by register pair BC into register A.
		//
		//let data = try cpu.mmu.readByte(address: cpu.bc)
		//cpu.a = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x0A))
	},
	OpCode.byte(0x0B): Instruction.atomic(cycles: 2) { cpu in
		// DEC BC
		//
		// Cycles: 2
		// Bytes: 1
		// Flags: - - - -
		//
		// Decrement the contents of register pair BC by 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.byte(0x0B))
	},
	OpCode.byte(0x0C): Instruction.atomic(cycles: 1) { cpu in
		// INC C
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 0 8-bit -
		//
		// Increment the contents of register C by 1.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x0C))
	},
	OpCode.byte(0x0D): Instruction.atomic(cycles: 1) { cpu in
		// DEC C
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 1 8-bit -
		//
		// Decrement the contents of register C by 1.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x0D))
	},
	OpCode.byte(0x0E): Instruction.atomic(cycles: 2) { cpu in
		// LD C, d8
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Load the 8-bit immediate operand d8 into register C.
		//
		//let data = try cpu.readNextByte()
		//cpu.c = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x0E))
	},
	OpCode.byte(0x0F): Instruction.atomic(cycles: 1) { cpu in
		// RRCA
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: 0 0 0 A0
		//
		// Rotate the contents of register A to the right. That is, the contents of bit 7 are copied to bit 6, and the previous contents of bit 6 (before the copy) are copied to bit 5. The same operation is repeated in sequence for the rest of the register. The contents of bit 0 are placed in both the CY flag and bit 7 of register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x0F))
	},
	OpCode.byte(0x10): Instruction.atomic(cycles: 1) { cpu in
		// STOP
		//
		// Cycles: 1
		// Bytes: 2
		// Flags: - - - -
		//
		// Execution of a STOP instruction stops both the system clock and oscillator circuit. STOP mode is entered and the LCD controller also stops. However, the status of the internal RAM register ports remains unchanged.
		// STOP mode can be cancelled by a reset signal.
		// If the RESET terminal goes LOW in STOP mode, it becomes that of a normal reset status.
		// The following conditions should be met before a STOP instruction is executed and stop mode is entered:
		// All interrupt-enable (IE) flags are reset.
		// Input to P10-P13 is LOW for all.
		//
		throw CPUError.instructionNotImplemented(OpCode.byte(0x10))
	},
	OpCode.byte(0x11): Instruction.atomic(cycles: 3) { cpu in
		// LD DE, d16
		//
		// Cycles: 3
		// Bytes: 3
		// Flags: - - - -
		//
		// Load the 2 bytes of immediate data into register pair DE.
		// The first byte of immediate data is the lower byte (i.e., bits 0-7), and the second byte of immediate data is the higher byte (i.e., bits 8-15).
		//
		//let data = try cpu.readNextWord()
		//cpu.de = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x11))
	},
	OpCode.byte(0x12): Instruction.atomic(cycles: 2) { cpu in
		// LD (DE), A
		//
		// Cycles: 2
		// Bytes: 1
		// Flags: - - - -
		//
		// Store the contents of register A in the memory location specified by register pair DE.
		//
		//let data = cpu.a
		//try cpu.mmu.writeByte(address: cpu.de, byte: data)
		throw CPUError.instructionNotImplemented(OpCode.byte(0x12))
	},
	OpCode.byte(0x13): Instruction.atomic(cycles: 2) { cpu in
		// INC DE
		//
		// Cycles: 2
		// Bytes: 1
		// Flags: - - - -
		//
		// Increment the contents of register pair DE by 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.byte(0x13))
	},
	OpCode.byte(0x14): Instruction.atomic(cycles: 1) { cpu in
		// INC D
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 0 8-bit -
		//
		// Increment the contents of register D by 1.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x14))
	},
	OpCode.byte(0x15): Instruction.atomic(cycles: 1) { cpu in
		// DEC D
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 1 8-bit -
		//
		// Decrement the contents of register D by 1.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x15))
	},
	OpCode.byte(0x16): Instruction.atomic(cycles: 2) { cpu in
		// LD D, d8
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Load the 8-bit immediate operand d8 into register D.
		//
		//let data = try cpu.readNextByte()
		//cpu.d = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x16))
	},
	OpCode.byte(0x17): Instruction.atomic(cycles: 1) { cpu in
		// RLA
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: 0 0 0 A7
		//
		// Rotate the contents of register A to the left, through the carry (CY) flag. That is, the contents of bit 0 are copied to bit 1, and the previous contents of bit 1 (before the copy operation) are copied to bit 2. The same operation is repeated in sequence for the rest of the register. The previous contents of the carry flag are copied to bit 0.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x17))
	},
	OpCode.byte(0x18): Instruction.atomic(cycles: 3) { cpu in
		// JR s8
		//
		// Cycles: 3
		// Bytes: 2
		// Flags: - - - -
		//
		// Jump s8 steps from the current address in the program counter (PC). (Jump relative.)
		//
		throw CPUError.instructionNotImplemented(OpCode.byte(0x18))
	},
	OpCode.byte(0x19): Instruction.atomic(cycles: 2) { cpu in
		// ADD HL, DE
		//
		// Cycles: 2
		// Bytes: 1
		// Flags: - 0 16-bit 16-bit
		//
		// Add the contents of register pair DE to the contents of register pair HL, and store the results in register pair HL.
		//
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x19))
	},
	OpCode.byte(0x1A): Instruction.atomic(cycles: 2) { cpu in
		// LD A, (DE)
		//
		// Cycles: 2
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the 8-bit contents of memory specified by register pair DE into register A.
		//
		//let data = try cpu.mmu.readByte(address: cpu.de)
		//cpu.a = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x1A))
	},
	OpCode.byte(0x1B): Instruction.atomic(cycles: 2) { cpu in
		// DEC DE
		//
		// Cycles: 2
		// Bytes: 1
		// Flags: - - - -
		//
		// Decrement the contents of register pair DE by 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.byte(0x1B))
	},
	OpCode.byte(0x1C): Instruction.atomic(cycles: 1) { cpu in
		// INC E
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 0 8-bit -
		//
		// Increment the contents of register E by 1.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x1C))
	},
	OpCode.byte(0x1D): Instruction.atomic(cycles: 1) { cpu in
		// DEC E
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 1 8-bit -
		//
		// Decrement the contents of register E by 1.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x1D))
	},
	OpCode.byte(0x1E): Instruction.atomic(cycles: 2) { cpu in
		// LD E, d8
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Load the 8-bit immediate operand d8 into register E.
		//
		//let data = try cpu.readNextByte()
		//cpu.e = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x1E))
	},
	OpCode.byte(0x1F): Instruction.atomic(cycles: 1) { cpu in
		// RRA
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: 0 0 0 A0
		//
		// Rotate the contents of register A to the right, through the carry (CY) flag. That is, the contents of bit 7 are copied to bit 6, and the previous contents of bit 6 (before the copy) are copied to bit 5. The same operation is repeated in sequence for the rest of the register. The previous contents of the carry flag are copied to bit 7.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x1F))
	},
	OpCode.byte(0x20): Instruction.atomic(cycles: 2) { cpu in
		// JR NZ, s8
		//
		// Cycles: 3/2
		// Bytes: 2
		// Flags: - - - -
		//
		// If the Z flag is 0, jump s8 steps from the current address stored in the program counter (PC). If not, the instruction following the current JP instruction is executed (as usual).
		//
		throw CPUError.instructionNotImplemented(OpCode.byte(0x20))
	},
	OpCode.byte(0x21): Instruction.atomic(cycles: 3) { cpu in
		// LD HL, d16
		//
		// Cycles: 3
		// Bytes: 3
		// Flags: - - - -
		//
		// Load the 2 bytes of immediate data into register pair HL.
		// The first byte of immediate data is the lower byte (i.e., bits 0-7), and the second byte of immediate data is the higher byte (i.e., bits 8-15).
		//
		//let data = try cpu.readNextWord()
		//cpu.hl = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x21))
	},
	OpCode.byte(0x22): Instruction.atomic(cycles: 2) { cpu in
		// LD (HL+), A
		//
		// Cycles: 2
		// Bytes: 1
		// Flags: - - - -
		//
		// Store the contents of register A into the memory location specified by register pair HL, and simultaneously increment the contents of HL.
		//
		//let data = cpu.a
		//try cpu.mmu.writeByte(address: cpu.hl, byte: data)
		throw CPUError.instructionNotImplemented(OpCode.byte(0x22))
	},
	OpCode.byte(0x23): Instruction.atomic(cycles: 2) { cpu in
		// INC HL
		//
		// Cycles: 2
		// Bytes: 1
		// Flags: - - - -
		//
		// Increment the contents of register pair HL by 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.byte(0x23))
	},
	OpCode.byte(0x24): Instruction.atomic(cycles: 1) { cpu in
		// INC H
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 0 8-bit -
		//
		// Increment the contents of register H by 1.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x24))
	},
	OpCode.byte(0x25): Instruction.atomic(cycles: 1) { cpu in
		// DEC H
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 1 8-bit -
		//
		// Decrement the contents of register H by 1.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x25))
	},
	OpCode.byte(0x26): Instruction.atomic(cycles: 2) { cpu in
		// LD H, d8
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Load the 8-bit immediate operand d8 into register H.
		//
		//let data = try cpu.readNextByte()
		//cpu.h = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x26))
	},
	OpCode.byte(0x27): Instruction.atomic(cycles: 1) { cpu in
		// DAA
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z - 0 CY
		//
		// Adjust the accumulator (register A) too a binary-coded decimal (BCD) number after BCD addition and subtraction operations.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x27))
	},
	OpCode.byte(0x28): Instruction.atomic(cycles: 2) { cpu in
		// JR Z, s8
		//
		// Cycles: 3/2
		// Bytes: 2
		// Flags: - - - -
		//
		// If the Z flag is 1, jump s8 steps from the current address stored in the program counter (PC). If not, the instruction following the current JP instruction is executed (as usual).
		//
		throw CPUError.instructionNotImplemented(OpCode.byte(0x28))
	},
	OpCode.byte(0x29): Instruction.atomic(cycles: 2) { cpu in
		// ADD HL, HL
		//
		// Cycles: 2
		// Bytes: 1
		// Flags: - 0 16-bit 16-bit
		//
		// Add the contents of register pair HL to the contents of register pair HL, and store the results in register pair HL.
		//
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x29))
	},
	OpCode.byte(0x2A): Instruction.atomic(cycles: 2) { cpu in
		// LD A, (HL+)
		//
		// Cycles: 2
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the contents of memory specified by register pair HL into register A, and simultaneously increment the contents of HL.
		//
		//cpu.a = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x2A))
	},
	OpCode.byte(0x2B): Instruction.atomic(cycles: 2) { cpu in
		// DEC HL
		//
		// Cycles: 2
		// Bytes: 1
		// Flags: - - - -
		//
		// Decrement the contents of register pair HL by 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.byte(0x2B))
	},
	OpCode.byte(0x2C): Instruction.atomic(cycles: 1) { cpu in
		// INC L
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 0 8-bit -
		//
		// Increment the contents of register L by 1.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x2C))
	},
	OpCode.byte(0x2D): Instruction.atomic(cycles: 1) { cpu in
		// DEC L
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 1 8-bit -
		//
		// Decrement the contents of register L by 1.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x2D))
	},
	OpCode.byte(0x2E): Instruction.atomic(cycles: 2) { cpu in
		// LD L, d8
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Load the 8-bit immediate operand d8 into register L.
		//
		//let data = try cpu.readNextByte()
		//cpu.l = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x2E))
	},
	OpCode.byte(0x2F): Instruction.atomic(cycles: 1) { cpu in
		// CPL
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: - 1 1 -
		//
		// Take the one's complement (i.e., flip all bits) of the contents of register A.
		//
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x2F))
	},
	OpCode.byte(0x30): Instruction.atomic(cycles: 2) { cpu in
		// JR NC, s8
		//
		// Cycles: 3/2
		// Bytes: 2
		// Flags: - - - -
		//
		// If the CY flag is 0, jump s8 steps from the current address stored in the program counter (PC). If not, the instruction following the current JP instruction is executed (as usual).
		//
		throw CPUError.instructionNotImplemented(OpCode.byte(0x30))
	},
	OpCode.byte(0x31): Instruction.atomic(cycles: 3) { cpu in
		// LD SP, d16
		//
		// Cycles: 3
		// Bytes: 3
		// Flags: - - - -
		//
		// Load the 2 bytes of immediate data into register pair SP.
		// The first byte of immediate data is the lower byte (i.e., bits 0-7), and the second byte of immediate data is the higher byte (i.e., bits 8-15).
		//
		//let data = try cpu.readNextWord()
		//cpu.sp = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x31))
	},
	OpCode.byte(0x32): Instruction.atomic(cycles: 2) { cpu in
		// LD (HL-), A
		//
		// Cycles: 2
		// Bytes: 1
		// Flags: - - - -
		//
		// Store the contents of register A into the memory location specified by register pair HL, and simultaneously decrement the contents of HL.
		//
		//let data = cpu.a
		//try cpu.mmu.writeByte(address: cpu.hl, byte: data)
		throw CPUError.instructionNotImplemented(OpCode.byte(0x32))
	},
	OpCode.byte(0x33): Instruction.atomic(cycles: 2) { cpu in
		// INC SP
		//
		// Cycles: 2
		// Bytes: 1
		// Flags: - - - -
		//
		// Increment the contents of register pair SP by 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.byte(0x33))
	},
	OpCode.byte(0x34): Instruction.atomic(cycles: 3) { cpu in
		// INC (HL)
		//
		// Cycles: 3
		// Bytes: 1
		// Flags: Z 0 8-bit -
		//
		// Increment the contents of memory specified by register pair HL by 1.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x34))
	},
	OpCode.byte(0x35): Instruction.atomic(cycles: 3) { cpu in
		// DEC (HL)
		//
		// Cycles: 3
		// Bytes: 1
		// Flags: Z 1 8-bit -
		//
		// Decrement the contents of memory specified by register pair HL by 1.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x35))
	},
	OpCode.byte(0x36): Instruction.atomic(cycles: 3) { cpu in
		// LD (HL), d8
		//
		// Cycles: 3
		// Bytes: 1
		// Flags: - - - -
		//
		// Store the contents of 8-bit immediate operand d8 in the memory location specified by register pair HL.
		//
		//let data = try cpu.readNextByte()
		//try cpu.mmu.writeByte(address: cpu.hl, byte: data)
		throw CPUError.instructionNotImplemented(OpCode.byte(0x36))
	},
	OpCode.byte(0x37): Instruction.atomic(cycles: 1) { cpu in
		// SCF
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: - 0 0 1
		//
		// Set the carry flag CY.
		//
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x37))
	},
	OpCode.byte(0x38): Instruction.atomic(cycles: 2) { cpu in
		// JR C, s8
		//
		// Cycles: 3/2
		// Bytes: 2
		// Flags: - - - -
		//
		// If the CY flag is 1, jump s8 steps from the current address stored in the program counter (PC). If not, the instruction following the current JP instruction is executed (as usual).
		//
		throw CPUError.instructionNotImplemented(OpCode.byte(0x38))
	},
	OpCode.byte(0x39): Instruction.atomic(cycles: 2) { cpu in
		// ADD HL, SP
		//
		// Cycles: 2
		// Bytes: 1
		// Flags: - 0 16-bit 16-bit
		//
		// Add the contents of register pair SP to the contents of register pair HL, and store the results in register pair HL.
		//
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x39))
	},
	OpCode.byte(0x3A): Instruction.atomic(cycles: 2) { cpu in
		// LD A, (HL-)
		//
		// Cycles: 2
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the contents of memory specified by register pair HL into register A, and simultaneously decrement the contents of HL.
		//
		//cpu.a = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x3A))
	},
	OpCode.byte(0x3B): Instruction.atomic(cycles: 2) { cpu in
		// DEC SP
		//
		// Cycles: 2
		// Bytes: 1
		// Flags: - - - -
		//
		// Decrement the contents of register pair SP by 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.byte(0x3B))
	},
	OpCode.byte(0x3C): Instruction.atomic(cycles: 1) { cpu in
		// INC A
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 0 8-bit -
		//
		// Increment the contents of register A by 1.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x3C))
	},
	OpCode.byte(0x3D): Instruction.atomic(cycles: 1) { cpu in
		// DEC A
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 1 8-bit -
		//
		// Decrement the contents of register A by 1.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x3D))
	},
	OpCode.byte(0x3E): Instruction.atomic(cycles: 2) { cpu in
		// LD A, d8
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Load the 8-bit immediate operand d8 into register A.
		//
		//let data = try cpu.readNextByte()
		//cpu.a = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x3E))
	},
	OpCode.byte(0x3F): Instruction.atomic(cycles: 1) { cpu in
		// CCF
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: - 0 0 !CY
		//
		// Flip the carry flag CY.
		//
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x3F))
	},
	OpCode.byte(0x40): Instruction.atomic(cycles: 1) { cpu in
		// LD B, B
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the contents of register B into register B.
		//
		//let data = cpu.b
		//cpu.b = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x40))
	},
	OpCode.byte(0x41): Instruction.atomic(cycles: 1) { cpu in
		// LD B, C
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the contents of register C into register B.
		//
		//let data = cpu.c
		//cpu.b = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x41))
	},
	OpCode.byte(0x42): Instruction.atomic(cycles: 1) { cpu in
		// LD B, D
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the contents of register D into register B.
		//
		//let data = cpu.d
		//cpu.b = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x42))
	},
	OpCode.byte(0x43): Instruction.atomic(cycles: 1) { cpu in
		// LD B, E
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the contents of register E into register B.
		//
		//let data = cpu.e
		//cpu.b = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x43))
	},
	OpCode.byte(0x44): Instruction.atomic(cycles: 1) { cpu in
		// LD B, H
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the contents of register H into register B.
		//
		//let data = cpu.h
		//cpu.b = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x44))
	},
	OpCode.byte(0x45): Instruction.atomic(cycles: 1) { cpu in
		// LD B, L
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the contents of register L into register B.
		//
		//let data = cpu.l
		//cpu.b = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x45))
	},
	OpCode.byte(0x46): Instruction.atomic(cycles: 2) { cpu in
		// LD B, (HL)
		//
		// Cycles: 2
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the 8-bit contents of memory specified by register pair HL into register B.
		//
		//let data = try cpu.mmu.readByte(address: cpu.hl)
		//cpu.b = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x46))
	},
	OpCode.byte(0x47): Instruction.atomic(cycles: 1) { cpu in
		// LD B, A
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the contents of register A into register B.
		//
		//let data = cpu.a
		//cpu.b = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x47))
	},
	OpCode.byte(0x48): Instruction.atomic(cycles: 1) { cpu in
		// LD C, B
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the contents of register B into register C.
		//
		//let data = cpu.b
		//cpu.c = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x48))
	},
	OpCode.byte(0x49): Instruction.atomic(cycles: 1) { cpu in
		// LD C, C
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the contents of register C into register C.
		//
		//let data = cpu.c
		//cpu.c = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x49))
	},
	OpCode.byte(0x4A): Instruction.atomic(cycles: 1) { cpu in
		// LD C, D
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the contents of register D into register C.
		//
		//let data = cpu.d
		//cpu.c = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x4A))
	},
	OpCode.byte(0x4B): Instruction.atomic(cycles: 1) { cpu in
		// LD C, E
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the contents of register E into register C.
		//
		//let data = cpu.e
		//cpu.c = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x4B))
	},
	OpCode.byte(0x4C): Instruction.atomic(cycles: 1) { cpu in
		// LD C, H
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the contents of register H into register C.
		//
		//let data = cpu.h
		//cpu.c = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x4C))
	},
	OpCode.byte(0x4D): Instruction.atomic(cycles: 1) { cpu in
		// LD C, L
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the contents of register L into register C.
		//
		//let data = cpu.l
		//cpu.c = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x4D))
	},
	OpCode.byte(0x4E): Instruction.atomic(cycles: 2) { cpu in
		// LD C, (HL)
		//
		// Cycles: 2
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the 8-bit contents of memory specified by register pair HL into register C.
		//
		//let data = try cpu.mmu.readByte(address: cpu.hl)
		//cpu.c = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x4E))
	},
	OpCode.byte(0x4F): Instruction.atomic(cycles: 1) { cpu in
		// LD C, A
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the contents of register A into register C.
		//
		//let data = cpu.a
		//cpu.c = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x4F))
	},
	OpCode.byte(0x50): Instruction.atomic(cycles: 1) { cpu in
		// LD D, B
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the contents of register B into register D.
		//
		//let data = cpu.b
		//cpu.d = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x50))
	},
	OpCode.byte(0x51): Instruction.atomic(cycles: 1) { cpu in
		// LD D, C
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the contents of register C into register D.
		//
		//let data = cpu.c
		//cpu.d = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x51))
	},
	OpCode.byte(0x52): Instruction.atomic(cycles: 1) { cpu in
		// LD D, D
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the contents of register D into register D.
		//
		//let data = cpu.d
		//cpu.d = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x52))
	},
	OpCode.byte(0x53): Instruction.atomic(cycles: 1) { cpu in
		// LD D, E
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the contents of register E into register D.
		//
		//let data = cpu.e
		//cpu.d = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x53))
	},
	OpCode.byte(0x54): Instruction.atomic(cycles: 1) { cpu in
		// LD D, H
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the contents of register H into register D.
		//
		//let data = cpu.h
		//cpu.d = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x54))
	},
	OpCode.byte(0x55): Instruction.atomic(cycles: 1) { cpu in
		// LD D, L
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the contents of register L into register D.
		//
		//let data = cpu.l
		//cpu.d = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x55))
	},
	OpCode.byte(0x56): Instruction.atomic(cycles: 2) { cpu in
		// LD D, (HL)
		//
		// Cycles: 2
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the 8-bit contents of memory specified by register pair HL into register D.
		//
		//let data = try cpu.mmu.readByte(address: cpu.hl)
		//cpu.d = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x56))
	},
	OpCode.byte(0x57): Instruction.atomic(cycles: 1) { cpu in
		// LD D, A
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the contents of register A into register D.
		//
		//let data = cpu.a
		//cpu.d = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x57))
	},
	OpCode.byte(0x58): Instruction.atomic(cycles: 1) { cpu in
		// LD E, B
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the contents of register B into register E.
		//
		//let data = cpu.b
		//cpu.e = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x58))
	},
	OpCode.byte(0x59): Instruction.atomic(cycles: 1) { cpu in
		// LD E, C
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the contents of register C into register E.
		//
		//let data = cpu.c
		//cpu.e = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x59))
	},
	OpCode.byte(0x5A): Instruction.atomic(cycles: 1) { cpu in
		// LD E, D
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the contents of register D into register E.
		//
		//let data = cpu.d
		//cpu.e = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x5A))
	},
	OpCode.byte(0x5B): Instruction.atomic(cycles: 1) { cpu in
		// LD E, E
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the contents of register E into register E.
		//
		//let data = cpu.e
		//cpu.e = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x5B))
	},
	OpCode.byte(0x5C): Instruction.atomic(cycles: 1) { cpu in
		// LD E, H
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the contents of register H into register E.
		//
		//let data = cpu.h
		//cpu.e = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x5C))
	},
	OpCode.byte(0x5D): Instruction.atomic(cycles: 1) { cpu in
		// LD E, L
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the contents of register L into register E.
		//
		//let data = cpu.l
		//cpu.e = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x5D))
	},
	OpCode.byte(0x5E): Instruction.atomic(cycles: 2) { cpu in
		// LD E, (HL)
		//
		// Cycles: 2
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the 8-bit contents of memory specified by register pair HL into register E.
		//
		//let data = try cpu.mmu.readByte(address: cpu.hl)
		//cpu.e = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x5E))
	},
	OpCode.byte(0x5F): Instruction.atomic(cycles: 1) { cpu in
		// LD E, A
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the contents of register A into register E.
		//
		//let data = cpu.a
		//cpu.e = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x5F))
	},
	OpCode.byte(0x60): Instruction.atomic(cycles: 1) { cpu in
		// LD H, B
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the contents of register B into register H.
		//
		//let data = cpu.b
		//cpu.h = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x60))
	},
	OpCode.byte(0x61): Instruction.atomic(cycles: 1) { cpu in
		// LD H, C
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the contents of register C into register H.
		//
		//let data = cpu.c
		//cpu.h = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x61))
	},
	OpCode.byte(0x62): Instruction.atomic(cycles: 1) { cpu in
		// LD H, D
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the contents of register D into register H.
		//
		//let data = cpu.d
		//cpu.h = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x62))
	},
	OpCode.byte(0x63): Instruction.atomic(cycles: 1) { cpu in
		// LD H, E
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the contents of register E into register H.
		//
		//let data = cpu.e
		//cpu.h = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x63))
	},
	OpCode.byte(0x64): Instruction.atomic(cycles: 1) { cpu in
		// LD H, H
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the contents of register H into register H.
		//
		//let data = cpu.h
		//cpu.h = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x64))
	},
	OpCode.byte(0x65): Instruction.atomic(cycles: 1) { cpu in
		// LD H, L
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the contents of register L into register H.
		//
		//let data = cpu.l
		//cpu.h = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x65))
	},
	OpCode.byte(0x66): Instruction.atomic(cycles: 2) { cpu in
		// LD H, (HL)
		//
		// Cycles: 2
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the 8-bit contents of memory specified by register pair HL into register H.
		//
		//let data = try cpu.mmu.readByte(address: cpu.hl)
		//cpu.h = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x66))
	},
	OpCode.byte(0x67): Instruction.atomic(cycles: 1) { cpu in
		// LD H, A
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the contents of register A into register H.
		//
		//let data = cpu.a
		//cpu.h = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x67))
	},
	OpCode.byte(0x68): Instruction.atomic(cycles: 1) { cpu in
		// LD L, B
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the contents of register B into register L.
		//
		//let data = cpu.b
		//cpu.l = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x68))
	},
	OpCode.byte(0x69): Instruction.atomic(cycles: 1) { cpu in
		// LD L, C
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the contents of register C into register L.
		//
		//let data = cpu.c
		//cpu.l = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x69))
	},
	OpCode.byte(0x6A): Instruction.atomic(cycles: 1) { cpu in
		// LD L, D
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the contents of register D into register L.
		//
		//let data = cpu.d
		//cpu.l = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x6A))
	},
	OpCode.byte(0x6B): Instruction.atomic(cycles: 1) { cpu in
		// LD L, E
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the contents of register E into register L.
		//
		//let data = cpu.e
		//cpu.l = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x6B))
	},
	OpCode.byte(0x6C): Instruction.atomic(cycles: 1) { cpu in
		// LD L, H
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the contents of register H into register L.
		//
		//let data = cpu.h
		//cpu.l = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x6C))
	},
	OpCode.byte(0x6D): Instruction.atomic(cycles: 1) { cpu in
		// LD L, L
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the contents of register L into register L.
		//
		//let data = cpu.l
		//cpu.l = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x6D))
	},
	OpCode.byte(0x6E): Instruction.atomic(cycles: 2) { cpu in
		// LD L, (HL)
		//
		// Cycles: 2
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the 8-bit contents of memory specified by register pair HL into register L.
		//
		//let data = try cpu.mmu.readByte(address: cpu.hl)
		//cpu.l = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x6E))
	},
	OpCode.byte(0x6F): Instruction.atomic(cycles: 1) { cpu in
		// LD L, A
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the contents of register A into register L.
		//
		//let data = cpu.a
		//cpu.l = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x6F))
	},
	OpCode.byte(0x70): Instruction.atomic(cycles: 2) { cpu in
		// LD (HL), B
		//
		// Cycles: 2
		// Bytes: 1
		// Flags: - - - -
		//
		// Store the contents of register B in the memory location specified by register pair HL.
		//
		//let data = cpu.b
		//try cpu.mmu.writeByte(address: cpu.hl, byte: data)
		throw CPUError.instructionNotImplemented(OpCode.byte(0x70))
	},
	OpCode.byte(0x71): Instruction.atomic(cycles: 2) { cpu in
		// LD (HL), C
		//
		// Cycles: 2
		// Bytes: 1
		// Flags: - - - -
		//
		// Store the contents of register C in the memory location specified by register pair HL.
		//
		//let data = cpu.c
		//try cpu.mmu.writeByte(address: cpu.hl, byte: data)
		throw CPUError.instructionNotImplemented(OpCode.byte(0x71))
	},
	OpCode.byte(0x72): Instruction.atomic(cycles: 2) { cpu in
		// LD (HL), D
		//
		// Cycles: 2
		// Bytes: 1
		// Flags: - - - -
		//
		// Store the contents of register D in the memory location specified by register pair HL.
		//
		//let data = cpu.d
		//try cpu.mmu.writeByte(address: cpu.hl, byte: data)
		throw CPUError.instructionNotImplemented(OpCode.byte(0x72))
	},
	OpCode.byte(0x73): Instruction.atomic(cycles: 2) { cpu in
		// LD (HL), E
		//
		// Cycles: 2
		// Bytes: 1
		// Flags: - - - -
		//
		// Store the contents of register E in the memory location specified by register pair HL.
		//
		//let data = cpu.e
		//try cpu.mmu.writeByte(address: cpu.hl, byte: data)
		throw CPUError.instructionNotImplemented(OpCode.byte(0x73))
	},
	OpCode.byte(0x74): Instruction.atomic(cycles: 2) { cpu in
		// LD (HL), H
		//
		// Cycles: 2
		// Bytes: 1
		// Flags: - - - -
		//
		// Store the contents of register H in the memory location specified by register pair HL.
		//
		//let data = cpu.h
		//try cpu.mmu.writeByte(address: cpu.hl, byte: data)
		throw CPUError.instructionNotImplemented(OpCode.byte(0x74))
	},
	OpCode.byte(0x75): Instruction.atomic(cycles: 2) { cpu in
		// LD (HL), L
		//
		// Cycles: 2
		// Bytes: 1
		// Flags: - - - -
		//
		// Store the contents of register L in the memory location specified by register pair HL.
		//
		//let data = cpu.l
		//try cpu.mmu.writeByte(address: cpu.hl, byte: data)
		throw CPUError.instructionNotImplemented(OpCode.byte(0x75))
	},
	OpCode.byte(0x76): Instruction.atomic(cycles: 1) { cpu in
		// HALT
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: - - - -
		//
		// After a HALT instruction is executed, the system clock is stopped and HALT mode is entered. Although the system clock is stopped in this status, the oscillator circuit and LCD controller continue to operate.
		// In addition, the status of the internal RAM register ports remains unchanged.
		// HALT mode is cancelled by an interrupt or reset signal.
		// The program counter is halted at the step after the HALT instruction. If both the interrupt request flag and the corresponding interrupt enable flag are set, HALT mode is exited, even if the interrupt master enable flag is not set.
		// Once HALT mode is cancelled, the program starts from the address indicated by the program counter.
		// If the interrupt master enable flag is set, the contents of the program coounter are pushed to the stack and control jumps to the starting address of the interrupt.
		// If the RESET terminal goes LOW in HALT moode, the mode becomes that of a normal reset.
		//
		throw CPUError.instructionNotImplemented(OpCode.byte(0x76))
	},
	OpCode.byte(0x77): Instruction.atomic(cycles: 2) { cpu in
		// LD (HL), A
		//
		// Cycles: 2
		// Bytes: 1
		// Flags: - - - -
		//
		// Store the contents of register A in the memory location specified by register pair HL.
		//
		//let data = cpu.a
		//try cpu.mmu.writeByte(address: cpu.hl, byte: data)
		throw CPUError.instructionNotImplemented(OpCode.byte(0x77))
	},
	OpCode.byte(0x78): Instruction.atomic(cycles: 1) { cpu in
		// LD A, B
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the contents of register B into register A.
		//
		//let data = cpu.b
		//cpu.a = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x78))
	},
	OpCode.byte(0x79): Instruction.atomic(cycles: 1) { cpu in
		// LD A, C
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the contents of register C into register A.
		//
		//let data = cpu.c
		//cpu.a = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x79))
	},
	OpCode.byte(0x7A): Instruction.atomic(cycles: 1) { cpu in
		// LD A, D
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the contents of register D into register A.
		//
		//let data = cpu.d
		//cpu.a = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x7A))
	},
	OpCode.byte(0x7B): Instruction.atomic(cycles: 1) { cpu in
		// LD A, E
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the contents of register E into register A.
		//
		//let data = cpu.e
		//cpu.a = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x7B))
	},
	OpCode.byte(0x7C): Instruction.atomic(cycles: 1) { cpu in
		// LD A, H
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the contents of register H into register A.
		//
		//let data = cpu.h
		//cpu.a = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x7C))
	},
	OpCode.byte(0x7D): Instruction.atomic(cycles: 1) { cpu in
		// LD A, L
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the contents of register L into register A.
		//
		//let data = cpu.l
		//cpu.a = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x7D))
	},
	OpCode.byte(0x7E): Instruction.atomic(cycles: 2) { cpu in
		// LD A, (HL)
		//
		// Cycles: 2
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the 8-bit contents of memory specified by register pair HL into register A.
		//
		//let data = try cpu.mmu.readByte(address: cpu.hl)
		//cpu.a = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x7E))
	},
	OpCode.byte(0x7F): Instruction.atomic(cycles: 1) { cpu in
		// LD A, A
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the contents of register A into register A.
		//
		//let data = cpu.a
		//cpu.a = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0x7F))
	},
	OpCode.byte(0x80): Instruction.atomic(cycles: 1) { cpu in
		// ADD A, B
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 0 8-bit 8-bit
		//
		// Add the contents of register B to the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x80))
	},
	OpCode.byte(0x81): Instruction.atomic(cycles: 1) { cpu in
		// ADD A, C
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 0 8-bit 8-bit
		//
		// Add the contents of register C to the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x81))
	},
	OpCode.byte(0x82): Instruction.atomic(cycles: 1) { cpu in
		// ADD A, D
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 0 8-bit 8-bit
		//
		// Add the contents of register D to the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x82))
	},
	OpCode.byte(0x83): Instruction.atomic(cycles: 1) { cpu in
		// ADD A, E
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 0 8-bit 8-bit
		//
		// Add the contents of register E to the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x83))
	},
	OpCode.byte(0x84): Instruction.atomic(cycles: 1) { cpu in
		// ADD A, H
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 0 8-bit 8-bit
		//
		// Add the contents of register H to the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x84))
	},
	OpCode.byte(0x85): Instruction.atomic(cycles: 1) { cpu in
		// ADD A, L
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 0 8-bit 8-bit
		//
		// Add the contents of register L to the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x85))
	},
	OpCode.byte(0x86): Instruction.atomic(cycles: 2) { cpu in
		// ADD A, (HL)
		//
		// Cycles: 2
		// Bytes: 1
		// Flags: Z 0 8-bit 8-bit
		//
		// Add the contents of memory specified by register pair HL to the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x86))
	},
	OpCode.byte(0x87): Instruction.atomic(cycles: 1) { cpu in
		// ADD A, A
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 0 8-bit 8-bit
		//
		// Add the contents of register A to the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x87))
	},
	OpCode.byte(0x88): Instruction.atomic(cycles: 1) { cpu in
		// ADC A, B
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 0 8-bit 8-bit
		//
		// Add the contents of register B and the CY flag to the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x88))
	},
	OpCode.byte(0x89): Instruction.atomic(cycles: 1) { cpu in
		// ADC A, C
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 0 8-bit 8-bit
		//
		// Add the contents of register C and the CY flag to the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x89))
	},
	OpCode.byte(0x8A): Instruction.atomic(cycles: 1) { cpu in
		// ADC A, D
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 0 8-bit 8-bit
		//
		// Add the contents of register D and the CY flag to the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x8A))
	},
	OpCode.byte(0x8B): Instruction.atomic(cycles: 1) { cpu in
		// ADC A, E
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 0 8-bit 8-bit
		//
		// Add the contents of register E and the CY flag to the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x8B))
	},
	OpCode.byte(0x8C): Instruction.atomic(cycles: 1) { cpu in
		// ADC A, H
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 0 8-bit 8-bit
		//
		// Add the contents of register H and the CY flag to the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x8C))
	},
	OpCode.byte(0x8D): Instruction.atomic(cycles: 1) { cpu in
		// ADC A, L
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 0 8-bit 8-bit
		//
		// Add the contents of register L and the CY flag to the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x8D))
	},
	OpCode.byte(0x8E): Instruction.atomic(cycles: 2) { cpu in
		// ADC A, (HL)
		//
		// Cycles: 2
		// Bytes: 1
		// Flags: Z 0 8-bit 8-bit
		//
		// Add the contents of memory specified by register pair HL and the CY flag to the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x8E))
	},
	OpCode.byte(0x8F): Instruction.atomic(cycles: 1) { cpu in
		// ADC A, A
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 0 8-bit 8-bit
		//
		// Add the contents of register A and the CY flag to the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x8F))
	},
	OpCode.byte(0x90): Instruction.atomic(cycles: 1) { cpu in
		// SUB B
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 1 8-bit 8-bit
		//
		// Subtract the contents of register B from the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x90))
	},
	OpCode.byte(0x91): Instruction.atomic(cycles: 1) { cpu in
		// SUB C
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 1 8-bit 8-bit
		//
		// Subtract the contents of register C from the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x91))
	},
	OpCode.byte(0x92): Instruction.atomic(cycles: 1) { cpu in
		// SUB D
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 1 8-bit 8-bit
		//
		// Subtract the contents of register D from the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x92))
	},
	OpCode.byte(0x93): Instruction.atomic(cycles: 1) { cpu in
		// SUB E
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 1 8-bit 8-bit
		//
		// Subtract the contents of register E from the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x93))
	},
	OpCode.byte(0x94): Instruction.atomic(cycles: 1) { cpu in
		// SUB H
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 1 8-bit 8-bit
		//
		// Subtract the contents of register H from the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x94))
	},
	OpCode.byte(0x95): Instruction.atomic(cycles: 1) { cpu in
		// SUB L
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 1 8-bit 8-bit
		//
		// Subtract the contents of register L from the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x95))
	},
	OpCode.byte(0x96): Instruction.atomic(cycles: 2) { cpu in
		// SUB (HL)
		//
		// Cycles: 2
		// Bytes: 1
		// Flags: Z 1 8-bit 8-bit
		//
		// Subtract the contents of memory specified by register pair HL from the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x96))
	},
	OpCode.byte(0x97): Instruction.atomic(cycles: 1) { cpu in
		// SUB A
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 1 8-bit 8-bit
		//
		// Subtract the contents of register A from the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x97))
	},
	OpCode.byte(0x98): Instruction.atomic(cycles: 1) { cpu in
		// SBC A, B
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 1 8-bit 8-bit
		//
		// Subtract the contents of register B and the CY flag from the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x98))
	},
	OpCode.byte(0x99): Instruction.atomic(cycles: 1) { cpu in
		// SBC A, C
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 1 8-bit 8-bit
		//
		// Subtract the contents of register C and the CY flag from the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x99))
	},
	OpCode.byte(0x9A): Instruction.atomic(cycles: 1) { cpu in
		// SBC A, D
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 1 8-bit 8-bit
		//
		// Subtract the contents of register D and the CY flag from the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x9A))
	},
	OpCode.byte(0x9B): Instruction.atomic(cycles: 1) { cpu in
		// SBC A, E
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 1 8-bit 8-bit
		//
		// Subtract the contents of register E and the CY flag from the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x9B))
	},
	OpCode.byte(0x9C): Instruction.atomic(cycles: 1) { cpu in
		// SBC A, H
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 1 8-bit 8-bit
		//
		// Subtract the contents of register H and the CY flag from the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x9C))
	},
	OpCode.byte(0x9D): Instruction.atomic(cycles: 1) { cpu in
		// SBC A, L
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 1 8-bit 8-bit
		//
		// Subtract the contents of register L and the CY flag from the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x9D))
	},
	OpCode.byte(0x9E): Instruction.atomic(cycles: 2) { cpu in
		// SBC A, (HL)
		//
		// Cycles: 2
		// Bytes: 1
		// Flags: Z 1 8-bit 8-bit
		//
		// Subtract the contents of memory specified by register pair HL and the carry flag CY from the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x9E))
	},
	OpCode.byte(0x9F): Instruction.atomic(cycles: 1) { cpu in
		// SBC A, A
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 1 8-bit 8-bit
		//
		// Subtract the contents of register A and the CY flag from the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0x9F))
	},
	OpCode.byte(0xA0): Instruction.atomic(cycles: 1) { cpu in
		// AND B
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 0 1 0
		//
		// Take the logical AND for each bit of the contents of register B and the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0xA0))
	},
	OpCode.byte(0xA1): Instruction.atomic(cycles: 1) { cpu in
		// AND C
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 0 1 0
		//
		// Take the logical AND for each bit of the contents of register C and the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0xA1))
	},
	OpCode.byte(0xA2): Instruction.atomic(cycles: 1) { cpu in
		// AND D
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 0 1 0
		//
		// Take the logical AND for each bit of the contents of register D and the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0xA2))
	},
	OpCode.byte(0xA3): Instruction.atomic(cycles: 1) { cpu in
		// AND E
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 0 1 0
		//
		// Take the logical AND for each bit of the contents of register E and the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0xA3))
	},
	OpCode.byte(0xA4): Instruction.atomic(cycles: 1) { cpu in
		// AND H
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 0 1 0
		//
		// Take the logical AND for each bit of the contents of register H and the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0xA4))
	},
	OpCode.byte(0xA5): Instruction.atomic(cycles: 1) { cpu in
		// AND L
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 0 1 0
		//
		// Take the logical AND for each bit of the contents of register L and the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0xA5))
	},
	OpCode.byte(0xA6): Instruction.atomic(cycles: 2) { cpu in
		// AND (HL)
		//
		// Cycles: 2
		// Bytes: 1
		// Flags: Z 0 1 0
		//
		// Take the logical AND for each bit of the contents of memory specified by register pair HL and the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0xA6))
	},
	OpCode.byte(0xA7): Instruction.atomic(cycles: 1) { cpu in
		// AND A
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 0 1 0
		//
		// Take the logical AND for each bit of the contents of register A and the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0xA7))
	},
	OpCode.byte(0xA8): Instruction.atomic(cycles: 1) { cpu in
		// XOR B
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 0 0 0
		//
		// Take the logical exclusive-OR for each bit of the contents of register B and the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0xA8))
	},
	OpCode.byte(0xA9): Instruction.atomic(cycles: 1) { cpu in
		// XOR C
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 0 0 0
		//
		// Take the logical exclusive-OR for each bit of the contents of register C and the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0xA9))
	},
	OpCode.byte(0xAA): Instruction.atomic(cycles: 1) { cpu in
		// XOR D
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 0 0 0
		//
		// Take the logical exclusive-OR for each bit of the contents of register D and the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0xAA))
	},
	OpCode.byte(0xAB): Instruction.atomic(cycles: 1) { cpu in
		// XOR E
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 0 0 0
		//
		// Take the logical exclusive-OR for each bit of the contents of register E and the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0xAB))
	},
	OpCode.byte(0xAC): Instruction.atomic(cycles: 1) { cpu in
		// XOR H
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 0 0 0
		//
		// Take the logical exclusive-OR for each bit of the contents of register H and the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0xAC))
	},
	OpCode.byte(0xAD): Instruction.atomic(cycles: 1) { cpu in
		// XOR L
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 0 0 0
		//
		// Take the logical exclusive-OR for each bit of the contents of register L and the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0xAD))
	},
	OpCode.byte(0xAE): Instruction.atomic(cycles: 2) { cpu in
		// XOR (HL)
		//
		// Cycles: 2
		// Bytes: 1
		// Flags: Z 0 0 0
		//
		// Take the logical exclusive-OR for each bit of the contents of memory specified by register pair HL and the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0xAE))
	},
	OpCode.byte(0xAF): Instruction.atomic(cycles: 1) { cpu in
		// XOR A
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 0 0 0
		//
		// Take the logical exclusive-OR for each bit of the contents of register A and the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0xAF))
	},
	OpCode.byte(0xB0): Instruction.atomic(cycles: 1) { cpu in
		// OR B
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 0 0 0
		//
		// Take the logical OR for each bit of the contents of register B and the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0xB0))
	},
	OpCode.byte(0xB1): Instruction.atomic(cycles: 1) { cpu in
		// OR C
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 0 0 0
		//
		// Take the logical OR for each bit of the contents of register C and the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0xB1))
	},
	OpCode.byte(0xB2): Instruction.atomic(cycles: 1) { cpu in
		// OR D
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 0 0 0
		//
		// Take the logical OR for each bit of the contents of register D and the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0xB2))
	},
	OpCode.byte(0xB3): Instruction.atomic(cycles: 1) { cpu in
		// OR E
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 0 0 0
		//
		// Take the logical OR for each bit of the contents of register E and the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0xB3))
	},
	OpCode.byte(0xB4): Instruction.atomic(cycles: 1) { cpu in
		// OR H
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 0 0 0
		//
		// Take the logical OR for each bit of the contents of register H and the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0xB4))
	},
	OpCode.byte(0xB5): Instruction.atomic(cycles: 1) { cpu in
		// OR L
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 0 0 0
		//
		// Take the logical OR for each bit of the contents of register L and the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0xB5))
	},
	OpCode.byte(0xB6): Instruction.atomic(cycles: 2) { cpu in
		// OR (HL)
		//
		// Cycles: 2
		// Bytes: 1
		// Flags: Z 0 0 0
		//
		// Take the logical OR for each bit of the contents of memory specified by register pair HL and the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0xB6))
	},
	OpCode.byte(0xB7): Instruction.atomic(cycles: 1) { cpu in
		// OR A
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 0 0 0
		//
		// Take the logical OR for each bit of the contents of register A and the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0xB7))
	},
	OpCode.byte(0xB8): Instruction.atomic(cycles: 1) { cpu in
		// CP B
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 1 8-bit 8-bit
		//
		// Compare the contents of register B and the contents of register A by calculating A - B, and set the Z flag if they are equal.
		// The execution of this instruction does not affect the contents of register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0xB8))
	},
	OpCode.byte(0xB9): Instruction.atomic(cycles: 1) { cpu in
		// CP C
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 1 8-bit 8-bit
		//
		// Compare the contents of register C and the contents of register A by calculating A - C, and set the Z flag if they are equal.
		// The execution of this instruction does not affect the contents of register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0xB9))
	},
	OpCode.byte(0xBA): Instruction.atomic(cycles: 1) { cpu in
		// CP D
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 1 8-bit 8-bit
		//
		// Compare the contents of register D and the contents of register A by calculating A - D, and set the Z flag if they are equal.
		// The execution of this instruction does not affect the contents of register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0xBA))
	},
	OpCode.byte(0xBB): Instruction.atomic(cycles: 1) { cpu in
		// CP E
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 1 8-bit 8-bit
		//
		// Compare the contents of register E and the contents of register A by calculating A - E, and set the Z flag if they are equal.
		// The execution of this instruction does not affect the contents of register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0xBB))
	},
	OpCode.byte(0xBC): Instruction.atomic(cycles: 1) { cpu in
		// CP H
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 1 8-bit 8-bit
		//
		// Compare the contents of register H and the contents of register A by calculating A - H, and set the Z flag if they are equal.
		// The execution of this instruction does not affect the contents of register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0xBC))
	},
	OpCode.byte(0xBD): Instruction.atomic(cycles: 1) { cpu in
		// CP L
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 1 8-bit 8-bit
		//
		// Compare the contents of register L and the contents of register A by calculating A - L, and set the Z flag if they are equal.
		// The execution of this instruction does not affect the contents of register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0xBD))
	},
	OpCode.byte(0xBE): Instruction.atomic(cycles: 2) { cpu in
		// CP (HL)
		//
		// Cycles: 2
		// Bytes: 1
		// Flags: Z 1 8-bit 8-bit
		//
		// Compare the contents of memory specified by register pair HL and the contents of register A by calculating A - (HL), and set the Z flag if they are equal.
		// The execution of this instruction does not affect the contents of register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0xBE))
	},
	OpCode.byte(0xBF): Instruction.atomic(cycles: 1) { cpu in
		// CP A
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: Z 1 8-bit 8-bit
		//
		// Compare the contents of register A and the contents of register A by calculating A - A, and set the Z flag if they are equal.
		// The execution of this instruction does not affect the contents of register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0xBF))
	},
	OpCode.byte(0xC0): Instruction.atomic(cycles: 2) { cpu in
		// RET NZ
		//
		// Cycles: 5/2
		// Bytes: 1
		// Flags: - - - -
		//
		// If the Z flag is 0, control is returned to the source program by popping from the memory stack the program counter PC value that was pushed to the stack when the subroutine was called.
		// The contents of the address specified by the stack pointer SP are loaded in the lower-order byte of PC, and the contents of SP are incremented by 1. The contents of the address specified by the new SP value are then loaded in the higher-order byte of PC, and the contents of SP are incremented by 1 again. (THe value of SP is 2 larger than before instruction execution.) The next instruction is fetched from the address specified by the content of PC (as usual).
		//
		throw CPUError.instructionNotImplemented(OpCode.byte(0xC0))
	},
	OpCode.byte(0xC1): Instruction.atomic(cycles: 3) { cpu in
		// POP BC
		//
		// Cycles: 3
		// Bytes: 1
		// Flags: - - - -
		//
		// Pop the contents from the memory stack into register pair into register pair BC by doing the following:
		// Load the contents of memory specified by stack pointer SP into the lower portion of BC.
		// Add 1 to SP and load the contents from the new memory location into the upper portion of BC.
		// By the end, SP should be 2 more than its initial value.
		//
		throw CPUError.instructionNotImplemented(OpCode.byte(0xC1))
	},
	OpCode.byte(0xC2): Instruction.atomic(cycles: 3) { cpu in
		// JP NZ, a16
		//
		// Cycles: 4/3
		// Bytes: 3
		// Flags: - - - -
		//
		// Load the 16-bit immediate operand a16 into the program counter PC if the Z flag is 0. If the Z flag is 0, then the subsequent instruction starts at address a16. If not, the contents of PC are incremented, and the next instruction following the current JP instruction is executed (as usual).
		// The second byte of the object code (immediately following the opcode) corresponds to the lower-order byte of a16 (bits 0-7), and the third byte of the object code corresponds to the higher-order byte (bits 8-15).
		//
		throw CPUError.instructionNotImplemented(OpCode.byte(0xC2))
	},
	OpCode.byte(0xC3): Instruction.atomic(cycles: 4) { cpu in
		// JP a16
		//
		// Cycles: 4
		// Bytes: 3
		// Flags: - - - -
		//
		// Load the 16-bit immediate operand a16 into the program counter (PC). a16 specifies the address of the subsequently executed instruction.
		// The second byte of the object code (immediately following the opcode) corresponds to the lower-order byte of a16 (bits 0-7), and the third byte of the object code corresponds to the higher-order byte (bits 8-15).
		//
		throw CPUError.instructionNotImplemented(OpCode.byte(0xC3))
	},
	OpCode.byte(0xC4): Instruction.atomic(cycles: 3) { cpu in
		// CALL NZ, a16
		//
		// Cycles: 6/3
		// Bytes: 3
		// Flags: - - - -
		//
		// If the Z flag is 0, the program counter PC value corresponding to the memory location of the instruction following the CALL instruction is pushed to the 2 bytes following the memory byte specified by the stack pointer SP. The 16-bit immediate operand a16 is then loaded into PC.
		// The lower-order byte of a16 is placed in byte 2 of the object code, and the higher-order byte is placed in byte 3.
		//
		throw CPUError.instructionNotImplemented(OpCode.byte(0xC4))
	},
	OpCode.byte(0xC5): Instruction.atomic(cycles: 4) { cpu in
		// PUSH BC
		//
		// Cycles: 4
		// Bytes: 1
		// Flags: - - - -
		//
		// Push the contents of register pair BC onto the memory stack by doing the following:
		// Subtract 1 from the stack pointer SP, and put the contents of the higher portion of register pair BC on the stack.
		// Subtract 2 from SP, and put the lower portion of register pair BC on the stack.
		// Decrement SP by 2.
		//
		throw CPUError.instructionNotImplemented(OpCode.byte(0xC5))
	},
	OpCode.byte(0xC6): Instruction.atomic(cycles: 2) { cpu in
		// ADD A, d8
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 8-bit 8-bit
		//
		// Add the contents of the 8-bit immediate operand d8 to the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0xC6))
	},
	OpCode.byte(0xC7): Instruction.atomic(cycles: 4) { cpu in
		// RST 0
		//
		// Cycles: 4
		// Bytes: 1
		// Flags: - - - -
		//
		// Push the current value of the program counter PC onto the memory stack, and load into PC the 1th byte of page 0 memory addresses, 0x00. The next instruction is fetched from the address specified by the new content of PC (as usual).
		// With the push, the contents of the stack pointer SP are decremented by 1, and the higher-order byte of PC is loaded in the memory address specified by the new SP value. The value of SP is then again decremented by 1, and the lower-order byte of the PC is loaded in the memory address specified by that value of SP.
		// The RST instruction can be used to jump to 1 of 8 addresses. Because all ofthe addresses are held in page 0 memory, 0x00 is loaded in the higher-orderbyte of the PC, and 0x00 is loaded in the lower-order byte.
		//
		throw CPUError.instructionNotImplemented(OpCode.byte(0xC7))
	},
	OpCode.byte(0xC8): Instruction.atomic(cycles: 2) { cpu in
		// RET Z
		//
		// Cycles: 5/2
		// Bytes: 1
		// Flags: - - - -
		//
		// If the Z flag is 1, control is returned to the source program by popping from the memory stack the program counter PC value that was pushed to the stack when the subroutine was called.
		// The contents of the address specified by the stack pointer SP are loaded in the lower-order byte of PC, and the contents of SP are incremented by 1. The contents of the address specified by the new SP value are then loaded in the higher-order byte of PC, and the contents of SP are incremented by 1 again. (THe value of SP is 2 larger than before instruction execution.) The next instruction is fetched from the address specified by the content of PC (as usual).
		//
		throw CPUError.instructionNotImplemented(OpCode.byte(0xC8))
	},
	OpCode.byte(0xC9): Instruction.atomic(cycles: 4) { cpu in
		// RET
		//
		// Cycles: 4
		// Bytes: 1
		// Flags: - - - -
		//
		// Pop from the memory stack the program counter PC value pushed when the subroutine was called, returning contorl to the source program.
		// The contents of the address specified by the stack pointer SP are loaded in the lower-order byte of PC, and the contents of SP are incremented by 1. The contents of the address specified by the new SP value are then loaded in the higher-order byte of PC, and the contents of SP are incremented by 1 again. (THe value of SP is 2 larger than before instruction execution.) The next instruction is fetched from the address specified by the content of PC (as usual).
		//
		throw CPUError.instructionNotImplemented(OpCode.byte(0xC9))
	},
	OpCode.byte(0xCA): Instruction.atomic(cycles: 3) { cpu in
		// JP Z, a16
		//
		// Cycles: 4/3
		// Bytes: 3
		// Flags: - - - -
		//
		// Load the 16-bit immediate operand a16 into the program counter PC if the Z flag is 1. If the Z flag is 1, then the subsequent instruction starts at address a16. If not, the contents of PC are incremented, and the next instruction following the current JP instruction is executed (as usual).
		// The second byte of the object code (immediately following the opcode) corresponds to the lower-order byte of a16 (bits 0-7), and the third byte of the object code corresponds to the higher-order byte (bits 8-15).
		//
		throw CPUError.instructionNotImplemented(OpCode.byte(0xCA))
	},
	OpCode.byte(0xCC): Instruction.atomic(cycles: 3) { cpu in
		// CALL Z, a16
		//
		// Cycles: 6/3
		// Bytes: 3
		// Flags: - - - -
		//
		// If the Z flag is 1, the program counter PC value corresponding to the memory location of the instruction following the CALL instruction is pushed to the 2 bytes following the memory byte specified by the stack pointer SP. The 16-bit immediate operand a16 is then loaded into PC.
		// The lower-order byte of a16 is placed in byte 2 of the object code, and the higher-order byte is placed in byte 3.
		//
		throw CPUError.instructionNotImplemented(OpCode.byte(0xCC))
	},
	OpCode.byte(0xCD): Instruction.atomic(cycles: 6) { cpu in
		// CALL a16
		//
		// Cycles: 6
		// Bytes: 3
		// Flags: - - - -
		//
		// In memory, push the program counter PC value corresponding to the address following the CALL instruction to the 2 bytes following the byte specified by the current stack pointer SP. Then load the 16-bit immediate operand a16 into PC.
		// The subroutine is placed after the location specified by the new PC value. When the subroutine finishes, control is returned to the source program using a return instruction and by popping the starting address of the next instruction (which was just pushed) and moving it to the PC.
		// With the push, the current value of SP is decremented by 1, and the higher-order byte of PC is loaded in the memory address specified by the new SP value. The value of SP is then decremented by 1 again, and the lower-order byte of PC is loaded in the memory address specified by that value of SP.
		// The lower-order byte of a16 is placed in byte 2 of the object code, and the higher-order byte is placed in byte 3.
		//
		throw CPUError.instructionNotImplemented(OpCode.byte(0xCD))
	},
	OpCode.byte(0xCE): Instruction.atomic(cycles: 2) { cpu in
		// ADC A, d8
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 8-bit 8-bit
		//
		// Add the contents of the 8-bit immediate operand d8 and the CY flag to the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0xCE))
	},
	OpCode.byte(0xCF): Instruction.atomic(cycles: 4) { cpu in
		// RST 1
		//
		// Cycles: 4
		// Bytes: 1
		// Flags: - - - -
		//
		// Push the current value of the program counter PC onto the memory stack, and load into PC the 2th byte of page 0 memory addresses, 0x08. The next instruction is fetched from the address specified by the new content of PC (as usual).
		// With the push, the contents of the stack pointer SP are decremented by 1, and the higher-order byte of PC is loaded in the memory address specified by the new SP value. The value of SP is then again decremented by 1, and the lower-order byte of the PC is loaded in the memory address specified by that value of SP.
		// The RST instruction can be used to jump to 1 of 8 addresses. Because all ofthe addresses are held in page 0 memory, 0x00 is loaded in the higher-orderbyte of the PC, and 0x08 is loaded in the lower-order byte.
		//
		throw CPUError.instructionNotImplemented(OpCode.byte(0xCF))
	},
	OpCode.byte(0xD0): Instruction.atomic(cycles: 2) { cpu in
		// RET NC
		//
		// Cycles: 5/2
		// Bytes: 1
		// Flags: - - - -
		//
		// If the CY flag is 0, control is returned to the source program by popping from the memory stack the program counter PC value that was pushed to the stack when the subroutine was called.
		// The contents of the address specified by the stack pointer SP are loaded in the lower-order byte of PC, and the contents of SP are incremented by 1. The contents of the address specified by the new SP value are then loaded in the higher-order byte of PC, and the contents of SP are incremented by 1 again. (THe value of SP is 2 larger than before instruction execution.) The next instruction is fetched from the address specified by the content of PC (as usual).
		//
		throw CPUError.instructionNotImplemented(OpCode.byte(0xD0))
	},
	OpCode.byte(0xD1): Instruction.atomic(cycles: 3) { cpu in
		// POP DE
		//
		// Cycles: 3
		// Bytes: 1
		// Flags: - - - -
		//
		// Pop the contents from the memory stack into register pair into register pair DE by doing the following:
		// Load the contents of memory specified by stack pointer SP into the lower portion of DE.
		// Add 1 to SP and load the contents from the new memory location into the upper portion of DE.
		// By the end, SP should be 2 more than its initial value.
		//
		throw CPUError.instructionNotImplemented(OpCode.byte(0xD1))
	},
	OpCode.byte(0xD2): Instruction.atomic(cycles: 3) { cpu in
		// JP NC, a16
		//
		// Cycles: 4/3
		// Bytes: 3
		// Flags: - - - -
		//
		// Load the 16-bit immediate operand a16 into the program counter PC if the CY flag is 0. If the CY flag is 0, then the subsequent instruction starts at address a16. If not, the contents of PC are incremented, and the next instruction following the current JP instruction is executed (as usual).
		// The second byte of the object code (immediately following the opcode) corresponds to the lower-order byte of a16 (bits 0-7), and the third byte of the object code corresponds to the higher-order byte (bits 8-15).
		//
		throw CPUError.instructionNotImplemented(OpCode.byte(0xD2))
	},
	OpCode.byte(0xD4): Instruction.atomic(cycles: 3) { cpu in
		// CALL NC, a16
		//
		// Cycles: 6/3
		// Bytes: 3
		// Flags: - - - -
		//
		// If the CY flag is 0, the program counter PC value corresponding to the memory location of the instruction following the CALL instruction is pushed to the 2 bytes following the memory byte specified by the stack pointer SP. The 16-bit immediate operand a16 is then loaded into PC.
		// The lower-order byte of a16 is placed in byte 2 of the object code, and the higher-order byte is placed in byte 3.
		//
		throw CPUError.instructionNotImplemented(OpCode.byte(0xD4))
	},
	OpCode.byte(0xD5): Instruction.atomic(cycles: 4) { cpu in
		// PUSH DE
		//
		// Cycles: 4
		// Bytes: 1
		// Flags: - - - -
		//
		// Push the contents of register pair DE onto the memory stack by doing the following:
		// Subtract 1 from the stack pointer SP, and put the contents of the higher portion of register pair DE on the stack.
		// Subtract 2 from SP, and put the lower portion of register pair DE on the stack.
		// Decrement SP by 2.
		//
		throw CPUError.instructionNotImplemented(OpCode.byte(0xD5))
	},
	OpCode.byte(0xD6): Instruction.atomic(cycles: 2) { cpu in
		// SUB d8
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 1 8-bit 8-bit
		//
		// Subtract the contents of the 8-bit immediate operand d8 from the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0xD6))
	},
	OpCode.byte(0xD7): Instruction.atomic(cycles: 4) { cpu in
		// RST 2
		//
		// Cycles: 4
		// Bytes: 1
		// Flags: - - - -
		//
		// Push the current value of the program counter PC onto the memory stack, and load into PC the 3th byte of page 0 memory addresses, 0x10. The next instruction is fetched from the address specified by the new content of PC (as usual).
		// With the push, the contents of the stack pointer SP are decremented by 1, and the higher-order byte of PC is loaded in the memory address specified by the new SP value. The value of SP is then again decremented by 1, and the lower-order byte of the PC is loaded in the memory address specified by that value of SP.
		// The RST instruction can be used to jump to 1 of 8 addresses. Because all ofthe addresses are held in page 0 memory, 0x00 is loaded in the higher-orderbyte of the PC, and 0x10 is loaded in the lower-order byte.
		//
		throw CPUError.instructionNotImplemented(OpCode.byte(0xD7))
	},
	OpCode.byte(0xD8): Instruction.atomic(cycles: 2) { cpu in
		// RET C
		//
		// Cycles: 5/2
		// Bytes: 1
		// Flags: - - - -
		//
		// If the CY flag is 1, control is returned to the source program by popping from the memory stack the program counter PC value that was pushed to the stack when the subroutine was called.
		// The contents of the address specified by the stack pointer SP are loaded in the lower-order byte of PC, and the contents of SP are incremented by 1. The contents of the address specified by the new SP value are then loaded in the higher-order byte of PC, and the contents of SP are incremented by 1 again. (THe value of SP is 2 larger than before instruction execution.) The next instruction is fetched from the address specified by the content of PC (as usual).
		//
		throw CPUError.instructionNotImplemented(OpCode.byte(0xD8))
	},
	OpCode.byte(0xD9): Instruction.atomic(cycles: 4) { cpu in
		// RETI
		//
		// Cycles: 4
		// Bytes: 1
		// Flags: - - - -
		//
		// Used when an interrupt-service routine finishes. The address for the return from the interrupt is loaded in the program counter PC. The master interrupt enable flag is returned to its pre-interrupt status.
		// The contents of the address specified by the stack pointer SP are loaded in the lower-order byte of PC, and the contents of SP are incremented by 1. The contents of the address specified by the new SP value are then loaded in the higher-order byte of PC, and the contents of SP are incremented by 1 again. (THe value of SP is 2 larger than before instruction execution.) The next instruction is fetched from the address specified by the content of PC (as usual).
		//
		throw CPUError.instructionNotImplemented(OpCode.byte(0xD9))
	},
	OpCode.byte(0xDA): Instruction.atomic(cycles: 3) { cpu in
		// JP C, a16
		//
		// Cycles: 4/3
		// Bytes: 3
		// Flags: - - - -
		//
		// Load the 16-bit immediate operand a16 into the program counter PC if the CY flag is 1. If the CY flag is 1, then the subsequent instruction starts at address a16. If not, the contents of PC are incremented, and the next instruction following the current JP instruction is executed (as usual).
		// The second byte of the object code (immediately following the opcode) corresponds to the lower-order byte of a16 (bits 0-7), and the third byte of the object code corresponds to the higher-order byte (bits 8-15).
		//
		throw CPUError.instructionNotImplemented(OpCode.byte(0xDA))
	},
	OpCode.byte(0xDC): Instruction.atomic(cycles: 3) { cpu in
		// CALL C, a16
		//
		// Cycles: 6/3
		// Bytes: 3
		// Flags: - - - -
		//
		// If the CY flag is 1, the program counter PC value corresponding to the memory location of the instruction following the CALL instruction is pushed to the 2 bytes following the memory byte specified by the stack pointer SP. The 16-bit immediate operand a16 is then loaded into PC.
		// The lower-order byte of a16 is placed in byte 2 of the object code, and the higher-order byte is placed in byte 3.
		//
		throw CPUError.instructionNotImplemented(OpCode.byte(0xDC))
	},
	OpCode.byte(0xDE): Instruction.atomic(cycles: 2) { cpu in
		// SBC A, d8
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 1 8-bit 8-bit
		//
		// Subtract the contents of the 8-bit immediate operand d8 and the carry flag CY from the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0xDE))
	},
	OpCode.byte(0xDF): Instruction.atomic(cycles: 4) { cpu in
		// RST 3
		//
		// Cycles: 4
		// Bytes: 1
		// Flags: - - - -
		//
		// Push the current value of the program counter PC onto the memory stack, and load into PC the 4th byte of page 0 memory addresses, 0x18. The next instruction is fetched from the address specified by the new content of PC (as usual).
		// With the push, the contents of the stack pointer SP are decremented by 1, and the higher-order byte of PC is loaded in the memory address specified by the new SP value. The value of SP is then again decremented by 1, and the lower-order byte of the PC is loaded in the memory address specified by that value of SP.
		// The RST instruction can be used to jump to 1 of 8 addresses. Because all ofthe addresses are held in page 0 memory, 0x00 is loaded in the higher-orderbyte of the PC, and 0x18 is loaded in the lower-order byte.
		//
		throw CPUError.instructionNotImplemented(OpCode.byte(0xDF))
	},
	OpCode.byte(0xE0): Instruction.atomic(cycles: 3) { cpu in
		// LD (a8), A
		//
		// Cycles: 3
		// Bytes: 2
		// Flags: - - - -
		//
		// Store the contents of register A in the internal RAM, port register, or mode register at the address in the range 0xFF00-0xFFFF specified by the 8-bit immediate operand a8.
		// Note: Should specify a 16-bit address in the mnemonic portion for a8, although the immediate operand only has the lower-order 8 bits.
		// 0xFF00-0xFF7F: Port/Mode registers, control register, sound register
		// 0xFF80-0xFFFE: Working & Stack RAM (127 bytes)
		// 0xFFFF: Interrupt Enable Register
		//
		//let data = cpu.a
		//try cpu.mmu.writeByte(address: cpu.a8, byte: data)
		throw CPUError.instructionNotImplemented(OpCode.byte(0xE0))
	},
	OpCode.byte(0xE1): Instruction.atomic(cycles: 3) { cpu in
		// POP HL
		//
		// Cycles: 3
		// Bytes: 1
		// Flags: - - - -
		//
		// Pop the contents from the memory stack into register pair into register pair HL by doing the following:
		// Load the contents of memory specified by stack pointer SP into the lower portion of HL.
		// Add 1 to SP and load the contents from the new memory location into the upper portion of HL.
		// By the end, SP should be 2 more than its initial value.
		//
		throw CPUError.instructionNotImplemented(OpCode.byte(0xE1))
	},
	OpCode.byte(0xE2): Instruction.atomic(cycles: 2) { cpu in
		// LD (C), A
		//
		// Cycles: 2
		// Bytes: 1
		// Flags: - - - -
		//
		// Store the contents of register A in the internal RAM, port register, or mode register at the address in the range 0xFF00-0xFFFF specified by register C.
		// 0xFF00-0xFF7F: Port/Mode registers, control register, sound register
		// 0xFF80-0xFFFE: Working & Stack RAM (127 bytes)
		// 0xFFFF: Interrupt Enable Register
		//
		//let data = cpu.a
		//try cpu.mmu.writeByte(address: cpu.c, byte: data)
		throw CPUError.instructionNotImplemented(OpCode.byte(0xE2))
	},
	OpCode.byte(0xE5): Instruction.atomic(cycles: 4) { cpu in
		// PUSH HL
		//
		// Cycles: 4
		// Bytes: 1
		// Flags: - - - -
		//
		// Push the contents of register pair HL onto the memory stack by doing the following:
		// Subtract 1 from the stack pointer SP, and put the contents of the higher portion of register pair HL on the stack.
		// Subtract 2 from SP, and put the lower portion of register pair HL on the stack.
		// Decrement SP by 2.
		//
		throw CPUError.instructionNotImplemented(OpCode.byte(0xE5))
	},
	OpCode.byte(0xE6): Instruction.atomic(cycles: 2) { cpu in
		// AND d8
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 1 0
		//
		// Take the logical AND for each bit of the contents of 8-bit immediate operand d8 and the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0xE6))
	},
	OpCode.byte(0xE7): Instruction.atomic(cycles: 4) { cpu in
		// RST 4
		//
		// Cycles: 4
		// Bytes: 1
		// Flags: - - - -
		//
		// Push the current value of the program counter PC onto the memory stack, and load into PC the 5th byte of page 0 memory addresses, 0x20. The next instruction is fetched from the address specified by the new content of PC (as usual).
		// With the push, the contents of the stack pointer SP are decremented by 1, and the higher-order byte of PC is loaded in the memory address specified by the new SP value. The value of SP is then again decremented by 1, and the lower-order byte of the PC is loaded in the memory address specified by that value of SP.
		// The RST instruction can be used to jump to 1 of 8 addresses. Because all ofthe addresses are held in page 0 memory, 0x00 is loaded in the higher-orderbyte of the PC, and 0x20 is loaded in the lower-order byte.
		//
		throw CPUError.instructionNotImplemented(OpCode.byte(0xE7))
	},
	OpCode.byte(0xE8): Instruction.atomic(cycles: 4) { cpu in
		// ADD SP, s8
		//
		// Cycles: 4
		// Bytes: 2
		// Flags: 0 0 16-bit 16-bit
		//
		// Add the contents of the 8-bit signed (2's complement) immediate operand s8 and the stack pointer SP and store the results in SP.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0xE8))
	},
	OpCode.byte(0xE9): Instruction.atomic(cycles: 1) { cpu in
		// JP HL
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the contents of register pair HL into the program counter PC. The next instruction is fetched from the location specified by the new value of PC.
		//
		throw CPUError.instructionNotImplemented(OpCode.byte(0xE9))
	},
	OpCode.byte(0xEA): Instruction.atomic(cycles: 4) { cpu in
		// LD (a16), A
		//
		// Cycles: 4
		// Bytes: 3
		// Flags: - - - -
		//
		// Store the contents of register A in the internal RAM or register specified by the 16-bit immediate operand a16.
		//
		//let data = cpu.a
		//try cpu.mmu.writeByte(address: cpu.a16, byte: data)
		throw CPUError.instructionNotImplemented(OpCode.byte(0xEA))
	},
	OpCode.byte(0xEE): Instruction.atomic(cycles: 2) { cpu in
		// XOR d8
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 0
		//
		// Take the logical exclusive-OR for each bit of the contents of the 8-bit immediate operand d8 and the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0xEE))
	},
	OpCode.byte(0xEF): Instruction.atomic(cycles: 4) { cpu in
		// RST 5
		//
		// Cycles: 4
		// Bytes: 1
		// Flags: - - - -
		//
		// Push the current value of the program counter PC onto the memory stack, and load into PC the 6th byte of page 0 memory addresses, 0x28. The next instruction is fetched from the address specified by the new content of PC (as usual).
		// With the push, the contents of the stack pointer SP are decremented by 1, and the higher-order byte of PC is loaded in the memory address specified by the new SP value. The value of SP is then again decremented by 1, and the lower-order byte of the PC is loaded in the memory address specified by that value of SP.
		// The RST instruction can be used to jump to 1 of 8 addresses. Because all ofthe addresses are held in page 0 memory, 0x00 is loaded in the higher-orderbyte of the PC, and 0x28 is loaded in the lower-order byte.
		//
		throw CPUError.instructionNotImplemented(OpCode.byte(0xEF))
	},
	OpCode.byte(0xF0): Instruction.atomic(cycles: 3) { cpu in
		// LD A, (a8)
		//
		// Cycles: 3
		// Bytes: 2
		// Flags: - - - -
		//
		// Load into register A the contents of the internal RAM, port register, or mode register at the address in the range 0xFF00-0xFFFF specified by the 8-bit immediate operand a8.
		// Note: Should specify a 16-bit address in the mnemonic portion for a8, although the immediate operand only has the lower-order 8 bits.
		// 0xFF00-0xFF7F: Port/Mode registers, control register, sound register
		// 0xFF80-0xFFFE: Working & Stack RAM (127 bytes)
		// 0xFFFF: Interrupt Enable Register
		//
		//cpu.a = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0xF0))
	},
	OpCode.byte(0xF1): Instruction.atomic(cycles: 3) { cpu in
		// POP AF
		//
		// Cycles: 3
		// Bytes: 1
		// Flags: - - - -
		//
		// Pop the contents from the memory stack into register pair into register pair AF by doing the following:
		// Load the contents of memory specified by stack pointer SP into the lower portion of AF.
		// Add 1 to SP and load the contents from the new memory location into the upper portion of AF.
		// By the end, SP should be 2 more than its initial value.
		//
		throw CPUError.instructionNotImplemented(OpCode.byte(0xF1))
	},
	OpCode.byte(0xF2): Instruction.atomic(cycles: 2) { cpu in
		// LD A, (C)
		//
		// Cycles: 2
		// Bytes: 1
		// Flags: - - - -
		//
		// Load into register A the contents of the internal RAM, port register, or mode register at the address in the range 0xFF00-0xFFFF specified by register C.
		// 0xFF00-0xFF7F: Port/Mode registers, control register, sound register
		// 0xFF80-0xFFFE: Working & Stack RAM (127 bytes)
		// 0xFFFF: Interrupt Enable Register
		//
		//cpu.a = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0xF2))
	},
	OpCode.byte(0xF3): Instruction.atomic(cycles: 1) { cpu in
		// DI
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: - - - -
		//
		// Reset the interrupt master enable (IME) flag and prohibit maskable interrupts.
		// Even if a DI instruction is executed in an interrupt routine, the IME flag is set if a return is performed with a RETI instruction.
		//
		throw CPUError.instructionNotImplemented(OpCode.byte(0xF3))
	},
	OpCode.byte(0xF5): Instruction.atomic(cycles: 4) { cpu in
		// PUSH AF
		//
		// Cycles: 4
		// Bytes: 1
		// Flags: - - - -
		//
		// Push the contents of register pair AF onto the memory stack by doing the following:
		// Subtract 1 from the stack pointer SP, and put the contents of the higher portion of register pair AF on the stack.
		// Subtract 2 from SP, and put the lower portion of register pair AF on the stack.
		// Decrement SP by 2.
		//
		throw CPUError.instructionNotImplemented(OpCode.byte(0xF5))
	},
	OpCode.byte(0xF6): Instruction.atomic(cycles: 2) { cpu in
		// OR d8
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 0
		//
		// Take the logical OR for each bit of the contents of the 8-bit immediate operand d8 and the contents of register A, and store the results in register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0xF6))
	},
	OpCode.byte(0xF7): Instruction.atomic(cycles: 4) { cpu in
		// RST 6
		//
		// Cycles: 4
		// Bytes: 1
		// Flags: - - - -
		//
		// Push the current value of the program counter PC onto the memory stack, and load into PC the 7th byte of page 0 memory addresses, 0x30. The next instruction is fetched from the address specified by the new content of PC (as usual).
		// With the push, the contents of the stack pointer SP are decremented by 1, and the higher-order byte of PC is loaded in the memory address specified by the new SP value. The value of SP is then again decremented by 1, and the lower-order byte of the PC is loaded in the memory address specified by that value of SP.
		// The RST instruction can be used to jump to 1 of 8 addresses. Because all ofthe addresses are held in page 0 memory, 0x00 is loaded in the higher-orderbyte of the PC, and 0x30 is loaded in the lower-order byte.
		//
		throw CPUError.instructionNotImplemented(OpCode.byte(0xF7))
	},
	OpCode.byte(0xF8): Instruction.atomic(cycles: 3) { cpu in
		// LD HL, SP+s8
		//
		// Cycles: 3
		// Bytes: 2
		// Flags: 0 0 16-bit 16-bit
		//
		// Add the 8-bit signed operand s8 (values -128 to +127) to the stack pointer SP, and store the result in register pair HL.
		//
		//cpu.hl = data
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0xF8))
	},
	OpCode.byte(0xF9): Instruction.atomic(cycles: 2) { cpu in
		// LD SP, HL
		//
		// Cycles: 2
		// Bytes: 1
		// Flags: - - - -
		//
		// Load the contents of register pair HL into the stack pointer SP.
		//
		//let data = cpu.hl
		//cpu.sp = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0xF9))
	},
	OpCode.byte(0xFA): Instruction.atomic(cycles: 4) { cpu in
		// LD A, (a16)
		//
		// Cycles: 4
		// Bytes: 3
		// Flags: - - - -
		//
		// Load into register A the contents of the internal RAM or register specified by the 16-bit immediate operand a16.
		//
		//cpu.a = data
		throw CPUError.instructionNotImplemented(OpCode.byte(0xFA))
	},
	OpCode.byte(0xFB): Instruction.atomic(cycles: 1) { cpu in
		// EI
		//
		// Cycles: 1
		// Bytes: 1
		// Flags: - - - -
		//
		// Set the interrupt master enable (IME) flag and enable maskable interrupts. This instruction can be used in an interrupt routine to enable higher-order interrupts.
		// The IME flag is reset immediately after an interrupt occurs. The IME flag reset remains in effect if coontrol is returned from the interrupt routine by a RET instruction. However, if an EI instruction is executed in the interrupt routine, control is returned with IME = 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.byte(0xFB))
	},
	OpCode.byte(0xFE): Instruction.atomic(cycles: 2) { cpu in
		// CP d8
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 1 8-bit 8-bit
		//
		// Compare the contents of register A and the contents of the 8-bit immediate operand d8 by calculating A - d8, and set the Z flag if they are equal.
		// The execution of this instruction does not affect the contents of register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.byte(0xFE))
	},
	OpCode.byte(0xFF): Instruction.atomic(cycles: 4) { cpu in
		// RST 7
		//
		// Cycles: 4
		// Bytes: 1
		// Flags: - - - -
		//
		// Push the current value of the program counter PC onto the memory stack, and load into PC the 8th byte of page 0 memory addresses, 0x38. The next instruction is fetched from the address specified by the new content of PC (as usual).
		// With the push, the contents of the stack pointer SP are decremented by 1, and the higher-order byte of PC is loaded in the memory address specified by the new SP value. The value of SP is then again decremented by 1, and the lower-order byte of the PC is loaded in the memory address specified by that value of SP.
		// The RST instruction can be used to jump to 1 of 8 addresses. Because all ofthe addresses are held in page 0 memory, 0x00 is loaded in the higher-orderbyte of the PC, and 0x38 is loaded in the lower-order byte.
		//
		throw CPUError.instructionNotImplemented(OpCode.byte(0xFF))
	},
	OpCode.word(0x00): Instruction.atomic(cycles: 2) { cpu in
		// RLC B
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 B7
		//
		// Rotate the contents of register B to the left. That is, the contents of bit 0 are copied to bit 1, and the previous contents of bit 1 (before the copy operation) are copied to bit 2. The same operation is repeated in sequence for the rest of the register. The contents of bit 7 are placed in both the CY flag and bit 0 of register B.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x00))
	},
	OpCode.word(0x01): Instruction.atomic(cycles: 2) { cpu in
		// RLC C
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 C7
		//
		// Rotate the contents of register C to the left. That is, the contents of bit 0 are copied to bit 1, and the previous contents of bit 1 (before the copy operation) are copied to bit 2. The same operation is repeated in sequence for the rest of the register. The contents of bit 7 are placed in both the CY flag and bit 0 of register C.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x01))
	},
	OpCode.word(0x02): Instruction.atomic(cycles: 2) { cpu in
		// RLC D
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 D7
		//
		// Rotate the contents of register D to the left. That is, the contents of bit 0 are copied to bit 1, and the previous contents of bit 1 (before the copy operation) are copied to bit 2. The same operation is repeated in sequence for the rest of the register. The contents of bit 7 are placed in both the CY flag and bit 0 of register D.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x02))
	},
	OpCode.word(0x03): Instruction.atomic(cycles: 2) { cpu in
		// RLC E
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 E7
		//
		// Rotate the contents of register E to the left. That is, the contents of bit 0 are copied to bit 1, and the previous contents of bit 1 (before the copy operation) are copied to bit 2. The same operation is repeated in sequence for the rest of the register. The contents of bit 7 are placed in both the CY flag and bit 0 of register E.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x03))
	},
	OpCode.word(0x04): Instruction.atomic(cycles: 2) { cpu in
		// RLC H
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 H7
		//
		// Rotate the contents of register H to the left. That is, the contents of bit 0 are copied to bit 1, and the previous contents of bit 1 (before the copy operation) are copied to bit 2. The same operation is repeated in sequence for the rest of the register. The contents of bit 7 are placed in both the CY flag and bit 0 of register H.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x04))
	},
	OpCode.word(0x05): Instruction.atomic(cycles: 2) { cpu in
		// RLC L
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 L7
		//
		// Rotate the contents of register L to the left. That is, the contents of bit 0 are copied to bit 1, and the previous contents of bit 1 (before the copy operation) are copied to bit 2. The same operation is repeated in sequence for the rest of the register. The contents of bit 7 are placed in both the CY flag and bit 0 of register L.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x05))
	},
	OpCode.word(0x06): Instruction.atomic(cycles: 4) { cpu in
		// RLC (HL)
		//
		// Cycles: 4
		// Bytes: 2
		// Flags: Z 0 0 (HL)7
		//
		// Rotate the contents of memory specified by register pair HL to the left. That is, the contents of bit 0 are copied to bit 1, and the previous contents of bit 1 (before the copy operation) are copied to bit 2. The same operation is repeated in sequence for the rest of the memory location. The contents of bit 7 are placed in both the CY flag and bit 0 of (HL).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x06))
	},
	OpCode.word(0x07): Instruction.atomic(cycles: 2) { cpu in
		// RLC A
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 A7
		//
		// Rotate the contents of register A to the left. That is, the contents of bit 0 are copied to bit 1, and the previous contents of bit 1 (before the copy operation) are copied to bit 2. The same operation is repeated in sequence for the rest of the register. The contents of bit 7 are placed in both the CY flag and bit 0 of register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x07))
	},
	OpCode.word(0x08): Instruction.atomic(cycles: 2) { cpu in
		// RRC B
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 B0
		//
		// Rotate the contents of register B to the right. That is, the contents of bit 7 are copied to bit 6, and the previous contents of bit 6 (before the copy operation) are copied to bit 5. The same operation is repeated in sequence for the rest of the register. The contents of bit 0 are placed in both the CY flag and bit 7 of register B.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x08))
	},
	OpCode.word(0x09): Instruction.atomic(cycles: 2) { cpu in
		// RRC C
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 C0
		//
		// Rotate the contents of register C to the right. That is, the contents of bit 7 are copied to bit 6, and the previous contents of bit 6 (before the copy operation) are copied to bit 5. The same operation is repeated in sequence for the rest of the register. The contents of bit 0 are placed in both the CY flag and bit 7 of register C.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x09))
	},
	OpCode.word(0x0A): Instruction.atomic(cycles: 2) { cpu in
		// RRC D
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 D0
		//
		// Rotate the contents of register D to the right. That is, the contents of bit 7 are copied to bit 6, and the previous contents of bit 6 (before the copy operation) are copied to bit 5. The same operation is repeated in sequence for the rest of the register. The contents of bit 0 are placed in both the CY flag and bit 7 of register D.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x0A))
	},
	OpCode.word(0x0B): Instruction.atomic(cycles: 2) { cpu in
		// RRC E
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 E0
		//
		// Rotate the contents of register E to the right. That is, the contents of bit 7 are copied to bit 6, and the previous contents of bit 6 (before the copy operation) are copied to bit 5. The same operation is repeated in sequence for the rest of the register. The contents of bit 0 are placed in both the CY flag and bit 7 of register E.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x0B))
	},
	OpCode.word(0x0C): Instruction.atomic(cycles: 2) { cpu in
		// RRC H
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 H0
		//
		// Rotate the contents of register H to the right. That is, the contents of bit 7 are copied to bit 6, and the previous contents of bit 6 (before the copy operation) are copied to bit 5. The same operation is repeated in sequence for the rest of the register. The contents of bit 0 are placed in both the CY flag and bit 7 of register H.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x0C))
	},
	OpCode.word(0x0D): Instruction.atomic(cycles: 2) { cpu in
		// RRC L
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 L0
		//
		// Rotate the contents of register L to the right. That is, the contents of bit 7 are copied to bit 6, and the previous contents of bit 6 (before the copy operation) are copied to bit 5. The same operation is repeated in sequence for the rest of the register. The contents of bit 0 are placed in both the CY flag and bit 7 of register L.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x0D))
	},
	OpCode.word(0x0E): Instruction.atomic(cycles: 4) { cpu in
		// RRC (HL)
		//
		// Cycles: 4
		// Bytes: 2
		// Flags: Z 0 0 (HL)0
		//
		// Rotate the contents of memory specified by register pair HL to the right. That is, the contents of bit 7 are copied to bit 6, and the previous contents of bit 6 (before the copy operation) are copied to bit 5. The same operation is repeated in sequence for the rest of the memory location. The contents of bit 0 are placed in both the CY flag and bit 7 of (HL).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x0E))
	},
	OpCode.word(0x0F): Instruction.atomic(cycles: 2) { cpu in
		// RRC A
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 A0
		//
		// Rotate the contents of register A to the right. That is, the contents of bit 7 are copied to bit 6, and the previous contents of bit 6 (before the copy operation) are copied to bit 5. The same operation is repeated in sequence for the rest of the register. The contents of bit 0 are placed in both the CY flag and bit 7 of register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x0F))
	},
	OpCode.word(0x10): Instruction.atomic(cycles: 2) { cpu in
		// RL B
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 B7
		//
		// Rotate the contents of register B to the left. That is, the contents of bit 0 are copied to bit 1, and the previous contents of bit 1 (before the copy operation) are copied to bit 2. The same operation is repeated in sequence for the rest of the register. The previous contents of the carry (CY) flag are copied to bit 0 of register B.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x10))
	},
	OpCode.word(0x11): Instruction.atomic(cycles: 2) { cpu in
		// RL C
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 C7
		//
		// Rotate the contents of register C to the left. That is, the contents of bit 0 are copied to bit 1, and the previous contents of bit 1 (before the copy operation) are copied to bit 2. The same operation is repeated in sequence for the rest of the register. The previous contents of the carry (CY) flag are copied to bit 0 of register C.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x11))
	},
	OpCode.word(0x12): Instruction.atomic(cycles: 2) { cpu in
		// RL D
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 D7
		//
		// Rotate the contents of register D to the left. That is, the contents of bit 0 are copied to bit 1, and the previous contents of bit 1 (before the copy operation) are copied to bit 2. The same operation is repeated in sequence for the rest of the register. The previous contents of the carry (CY) flag are copied to bit 0 of register D.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x12))
	},
	OpCode.word(0x13): Instruction.atomic(cycles: 2) { cpu in
		// RL E
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 E7
		//
		// Rotate the contents of register E to the left. That is, the contents of bit 0 are copied to bit 1, and the previous contents of bit 1 (before the copy operation) are copied to bit 2. The same operation is repeated in sequence for the rest of the register. The previous contents of the carry (CY) flag are copied to bit 0 of register E.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x13))
	},
	OpCode.word(0x14): Instruction.atomic(cycles: 2) { cpu in
		// RL H
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 H7
		//
		// Rotate the contents of register H to the left. That is, the contents of bit 0 are copied to bit 1, and the previous contents of bit 1 (before the copy operation) are copied to bit 2. The same operation is repeated in sequence for the rest of the register. The previous contents of the carry (CY) flag are copied to bit 0 of register H.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x14))
	},
	OpCode.word(0x15): Instruction.atomic(cycles: 2) { cpu in
		// RL L
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 L7
		//
		// Rotate the contents of register L to the left. That is, the contents of bit 0 are copied to bit 1, and the previous contents of bit 1 (before the copy operation) are copied to bit 2. The same operation is repeated in sequence for the rest of the register. The previous contents of the carry (CY) flag are copied to bit 0 of register L.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x15))
	},
	OpCode.word(0x16): Instruction.atomic(cycles: 4) { cpu in
		// RL (HL)
		//
		// Cycles: 4
		// Bytes: 2
		// Flags: Z 0 0 (HL)7
		//
		// Rotate the contents of memory specified by register pair HL to the left, through the carry flag. That is, the contents of bit 0 are copied to bit 1, and the previous contents of bit 1 (before the copy operation) are copied to bit 2. The same operation is repeated in sequence for the rest of the memory location. The previous contents of the CY flag are copied into bit 0 of (HL).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x16))
	},
	OpCode.word(0x17): Instruction.atomic(cycles: 2) { cpu in
		// RL A
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 A7
		//
		// Rotate the contents of register A to the left. That is, the contents of bit 0 are copied to bit 1, and the previous contents of bit 1 (before the copy operation) are copied to bit 2. The same operation is repeated in sequence for the rest of the register. The previous contents of the carry (CY) flag are copied to bit 0 of register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x17))
	},
	OpCode.word(0x18): Instruction.atomic(cycles: 2) { cpu in
		// RR B
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 B0
		//
		// Rotate the contents of register B to the right. That is, the contents of bit 7 are copied to bit 6, and the previous contents of bit 6 (before the copy operation) are copied to bit 5. The same operation is repeated in sequence for the rest of the register. The previous contents of the carry (CY) flag are copied to bit 7 of register B.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x18))
	},
	OpCode.word(0x19): Instruction.atomic(cycles: 2) { cpu in
		// RR C
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 C0
		//
		// Rotate the contents of register C to the right. That is, the contents of bit 7 are copied to bit 6, and the previous contents of bit 6 (before the copy operation) are copied to bit 5. The same operation is repeated in sequence for the rest of the register. The previous contents of the carry (CY) flag are copied to bit 7 of register C.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x19))
	},
	OpCode.word(0x1A): Instruction.atomic(cycles: 2) { cpu in
		// RR D
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 D0
		//
		// Rotate the contents of register D to the right. That is, the contents of bit 7 are copied to bit 6, and the previous contents of bit 6 (before the copy operation) are copied to bit 5. The same operation is repeated in sequence for the rest of the register. The previous contents of the carry (CY) flag are copied to bit 7 of register D.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x1A))
	},
	OpCode.word(0x1B): Instruction.atomic(cycles: 2) { cpu in
		// RR E
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 E0
		//
		// Rotate the contents of register E to the right. That is, the contents of bit 7 are copied to bit 6, and the previous contents of bit 6 (before the copy operation) are copied to bit 5. The same operation is repeated in sequence for the rest of the register. The previous contents of the carry (CY) flag are copied to bit 7 of register E.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x1B))
	},
	OpCode.word(0x1C): Instruction.atomic(cycles: 2) { cpu in
		// RR H
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 H0
		//
		// Rotate the contents of register H to the right. That is, the contents of bit 7 are copied to bit 6, and the previous contents of bit 6 (before the copy operation) are copied to bit 5. The same operation is repeated in sequence for the rest of the register. The previous contents of the carry (CY) flag are copied to bit 7 of register H.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x1C))
	},
	OpCode.word(0x1D): Instruction.atomic(cycles: 2) { cpu in
		// RR L
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 L0
		//
		// Rotate the contents of register L to the right. That is, the contents of bit 7 are copied to bit 6, and the previous contents of bit 6 (before the copy operation) are copied to bit 5. The same operation is repeated in sequence for the rest of the register. The previous contents of the carry (CY) flag are copied to bit 7 of register L.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x1D))
	},
	OpCode.word(0x1E): Instruction.atomic(cycles: 4) { cpu in
		// RR (HL)
		//
		// Cycles: 4
		// Bytes: 2
		// Flags: Z 0 0 (HL)0
		//
		// Rotate the contents of memory specified by register pair HL to the right, through the carry flag. That is, the contents of bit 7 are copied to bit 6, and the previous contents of bit 6 (before the copy operation) are copied to bit 5. The same operation is repeated in sequence for the rest of the memory location. The previous contents of the CY flag are copied into bit 7 of (HL).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x1E))
	},
	OpCode.word(0x1F): Instruction.atomic(cycles: 2) { cpu in
		// RR A
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 A0
		//
		// Rotate the contents of register A to the right. That is, the contents of bit 7 are copied to bit 6, and the previous contents of bit 6 (before the copy operation) are copied to bit 5. The same operation is repeated in sequence for the rest of the register. The previous contents of the carry (CY) flag are copied to bit 7 of register A.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x1F))
	},
	OpCode.word(0x20): Instruction.atomic(cycles: 2) { cpu in
		// SLA B
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 B7
		//
		// Shift the contents of register B to the left. That is, the contents of bit 0 are copied to bit 1, and the previous contents of bit 1 (before the copy operation) are copied to bit 2. The same operation is repeated in sequence for the rest of the register. The contents of bit 7 are copied to the CY flag, and bit 0 of register B is reset to 0.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x20))
	},
	OpCode.word(0x21): Instruction.atomic(cycles: 2) { cpu in
		// SLA C
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 C7
		//
		// Shift the contents of register C to the left. That is, the contents of bit 0 are copied to bit 1, and the previous contents of bit 1 (before the copy operation) are copied to bit 2. The same operation is repeated in sequence for the rest of the register. The contents of bit 7 are copied to the CY flag, and bit 0 of register C is reset to 0.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x21))
	},
	OpCode.word(0x22): Instruction.atomic(cycles: 2) { cpu in
		// SLA D
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 D7
		//
		// Shift the contents of register D to the left. That is, the contents of bit 0 are copied to bit 1, and the previous contents of bit 1 (before the copy operation) are copied to bit 2. The same operation is repeated in sequence for the rest of the register. The contents of bit 7 are copied to the CY flag, and bit 0 of register D is reset to 0.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x22))
	},
	OpCode.word(0x23): Instruction.atomic(cycles: 2) { cpu in
		// SLA E
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 E7
		//
		// Shift the contents of register E to the left. That is, the contents of bit 0 are copied to bit 1, and the previous contents of bit 1 (before the copy operation) are copied to bit 2. The same operation is repeated in sequence for the rest of the register. The contents of bit 7 are copied to the CY flag, and bit 0 of register E is reset to 0.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x23))
	},
	OpCode.word(0x24): Instruction.atomic(cycles: 2) { cpu in
		// SLA H
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 H7
		//
		// Shift the contents of register H to the left. That is, the contents of bit 0 are copied to bit 1, and the previous contents of bit 1 (before the copy operation) are copied to bit 2. The same operation is repeated in sequence for the rest of the register. The contents of bit 7 are copied to the CY flag, and bit 0 of register H is reset to 0.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x24))
	},
	OpCode.word(0x25): Instruction.atomic(cycles: 2) { cpu in
		// SLA L
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 L7
		//
		// Shift the contents of register L to the left. That is, the contents of bit 0 are copied to bit 1, and the previous contents of bit 1 (before the copy operation) are copied to bit 2. The same operation is repeated in sequence for the rest of the register. The contents of bit 7 are copied to the CY flag, and bit 0 of register L is reset to 0.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x25))
	},
	OpCode.word(0x26): Instruction.atomic(cycles: 4) { cpu in
		// SLA (HL)
		//
		// Cycles: 4
		// Bytes: 2
		// Flags: Z 0 0 (HL)7
		//
		// Shift the contents of memory specified by register pair HL to the left. That is, the contents of bit 0 are copied to bit 1, and the previous contents of bit 1 (before the copy operation) are copied to bit 2. The same operation is repeated in sequence for the rest of the memory location. The contents of bit 7 are copied to the CY flag, and bit 0 of (HL) is reset to 0.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x26))
	},
	OpCode.word(0x27): Instruction.atomic(cycles: 2) { cpu in
		// SLA A
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 A7
		//
		// Shift the contents of register A to the left. That is, the contents of bit 0 are copied to bit 1, and the previous contents of bit 1 (before the copy operation) are copied to bit 2. The same operation is repeated in sequence for the rest of the register. The contents of bit 7 are copied to the CY flag, and bit 0 of register A is reset to 0.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x27))
	},
	OpCode.word(0x28): Instruction.atomic(cycles: 2) { cpu in
		// SRA B
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 B0
		//
		// Shift the contents of register B to the right. That is, the contents of bit 7 are copied to bit 6, and the previous contents of bit 6 (before the copy operation) are copied to bit 5. The same operation is repeated in sequence for the rest of the register. The contents of bit 0 are copied to the CY flag, and bit 7 of register B is unchanged.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x28))
	},
	OpCode.word(0x29): Instruction.atomic(cycles: 2) { cpu in
		// SRA C
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 C0
		//
		// Shift the contents of register C to the right. That is, the contents of bit 7 are copied to bit 6, and the previous contents of bit 6 (before the copy operation) are copied to bit 5. The same operation is repeated in sequence for the rest of the register. The contents of bit 0 are copied to the CY flag, and bit 7 of register C is unchanged.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x29))
	},
	OpCode.word(0x2A): Instruction.atomic(cycles: 2) { cpu in
		// SRA D
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 D0
		//
		// Shift the contents of register D to the right. That is, the contents of bit 7 are copied to bit 6, and the previous contents of bit 6 (before the copy operation) are copied to bit 5. The same operation is repeated in sequence for the rest of the register. The contents of bit 0 are copied to the CY flag, and bit 7 of register D is unchanged.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x2A))
	},
	OpCode.word(0x2B): Instruction.atomic(cycles: 2) { cpu in
		// SRA E
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 E0
		//
		// Shift the contents of register E to the right. That is, the contents of bit 7 are copied to bit 6, and the previous contents of bit 6 (before the copy operation) are copied to bit 5. The same operation is repeated in sequence for the rest of the register. The contents of bit 0 are copied to the CY flag, and bit 7 of register E is unchanged.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x2B))
	},
	OpCode.word(0x2C): Instruction.atomic(cycles: 2) { cpu in
		// SRA H
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 H0
		//
		// Shift the contents of register H to the right. That is, the contents of bit 7 are copied to bit 6, and the previous contents of bit 6 (before the copy operation) are copied to bit 5. The same operation is repeated in sequence for the rest of the register. The contents of bit 0 are copied to the CY flag, and bit 7 of register H is unchanged.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x2C))
	},
	OpCode.word(0x2D): Instruction.atomic(cycles: 2) { cpu in
		// SRA L
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 L0
		//
		// Shift the contents of register L to the right. That is, the contents of bit 7 are copied to bit 6, and the previous contents of bit 6 (before the copy operation) are copied to bit 5. The same operation is repeated in sequence for the rest of the register. The contents of bit 0 are copied to the CY flag, and bit 7 of register L is unchanged.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x2D))
	},
	OpCode.word(0x2E): Instruction.atomic(cycles: 4) { cpu in
		// SRA (HL)
		//
		// Cycles: 4
		// Bytes: 2
		// Flags: Z 0 0 (HL)0
		//
		// Shift the contents of memory specified by register pair HL to the right. That is, the contents of bit 7 are copied to bit 6, and the previous contents of bit 6 (before the copy operation) are copied to bit 5. The same operation is repeated in sequence for the rest of the memory location. The contents of bit 0 are copied to the CY flag, and bit 7 of (HL) is unchanged.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x2E))
	},
	OpCode.word(0x2F): Instruction.atomic(cycles: 2) { cpu in
		// SRA A
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 A0
		//
		// Shift the contents of register A to the right. That is, the contents of bit 7 are copied to bit 6, and the previous contents of bit 6 (before the copy operation) are copied to bit 5. The same operation is repeated in sequence for the rest of the register. The contents of bit 0 are copied to the CY flag, and bit 7 of register A is unchanged.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x2F))
	},
	OpCode.word(0x30): Instruction.atomic(cycles: 2) { cpu in
		// SWAP B
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 0
		//
		// Shift the contents of the lower-order four bits (0-3) of register B to the higher-order four bits (4-7) of the register, and shift the higher-order four bits to the lower-order four bits.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x30))
	},
	OpCode.word(0x31): Instruction.atomic(cycles: 2) { cpu in
		// SWAP C
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 0
		//
		// Shift the contents of the lower-order four bits (0-3) of register C to the higher-order four bits (4-7) of the register, and shift the higher-order four bits to the lower-order four bits.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x31))
	},
	OpCode.word(0x32): Instruction.atomic(cycles: 2) { cpu in
		// SWAP D
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 0
		//
		// Shift the contents of the lower-order four bits (0-3) of register D to the higher-order four bits (4-7) of the register, and shift the higher-order four bits to the lower-order four bits.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x32))
	},
	OpCode.word(0x33): Instruction.atomic(cycles: 2) { cpu in
		// SWAP E
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 0
		//
		// Shift the contents of the lower-order four bits (0-3) of register E to the higher-order four bits (4-7) of the register, and shift the higher-order four bits to the lower-order four bits.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x33))
	},
	OpCode.word(0x34): Instruction.atomic(cycles: 2) { cpu in
		// SWAP H
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 0
		//
		// Shift the contents of the lower-order four bits (0-3) of register H to the higher-order four bits (4-7) of the register, and shift the higher-order four bits to the lower-order four bits.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x34))
	},
	OpCode.word(0x35): Instruction.atomic(cycles: 2) { cpu in
		// SWAP L
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 0
		//
		// Shift the contents of the lower-order four bits (0-3) of register L to the higher-order four bits (4-7) of the register, and shift the higher-order four bits to the lower-order four bits.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x35))
	},
	OpCode.word(0x36): Instruction.atomic(cycles: 4) { cpu in
		// SWAP (HL)
		//
		// Cycles: 4
		// Bytes: 2
		// Flags: Z 0 0 0
		//
		// Shift the contents of the lower-order four bits (0-3) of the contents of memory specified by register pair HL to the higher-order four bits (4-7) of that memory location, and shift the contents of the higher-order four bits to the lower-order four bits.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x36))
	},
	OpCode.word(0x37): Instruction.atomic(cycles: 2) { cpu in
		// SWAP A
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 0
		//
		// Shift the contents of the lower-order four bits (0-3) of register A to the higher-order four bits (4-7) of the register, and shift the higher-order four bits to the lower-order four bits.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x37))
	},
	OpCode.word(0x38): Instruction.atomic(cycles: 2) { cpu in
		// SRL B
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 B0
		//
		// Shift the contents of register B to the right. That is, the contents of bit 7 are copied to bit 6, and the previous contents of bit 6 (before the copy operation) are copied to bit 5. The same operation is repeated in sequence for the rest of the register. The contents of bit 0 are copied to the CY flag, and bit 7 of register B is reset to 0.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x38))
	},
	OpCode.word(0x39): Instruction.atomic(cycles: 2) { cpu in
		// SRL C
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 C0
		//
		// Shift the contents of register C to the right. That is, the contents of bit 7 are copied to bit 6, and the previous contents of bit 6 (before the copy operation) are copied to bit 5. The same operation is repeated in sequence for the rest of the register. The contents of bit 0 are copied to the CY flag, and bit 7 of register C is reset to 0.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x39))
	},
	OpCode.word(0x3A): Instruction.atomic(cycles: 2) { cpu in
		// SRL D
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 D0
		//
		// Shift the contents of register D to the right. That is, the contents of bit 7 are copied to bit 6, and the previous contents of bit 6 (before the copy operation) are copied to bit 5. The same operation is repeated in sequence for the rest of the register. The contents of bit 0 are copied to the CY flag, and bit 7 of register D is reset to 0.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x3A))
	},
	OpCode.word(0x3B): Instruction.atomic(cycles: 2) { cpu in
		// SRL E
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 E0
		//
		// Shift the contents of register E to the right. That is, the contents of bit 7 are copied to bit 6, and the previous contents of bit 6 (before the copy operation) are copied to bit 5. The same operation is repeated in sequence for the rest of the register. The contents of bit 0 are copied to the CY flag, and bit 7 of register E is reset to 0.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x3B))
	},
	OpCode.word(0x3C): Instruction.atomic(cycles: 2) { cpu in
		// SRL H
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 H0
		//
		// Shift the contents of register H to the right. That is, the contents of bit 7 are copied to bit 6, and the previous contents of bit 6 (before the copy operation) are copied to bit 5. The same operation is repeated in sequence for the rest of the register. The contents of bit 0 are copied to the CY flag, and bit 7 of register H is reset to 0.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x3C))
	},
	OpCode.word(0x3D): Instruction.atomic(cycles: 2) { cpu in
		// SRL L
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 L0
		//
		// Shift the contents of register L to the right. That is, the contents of bit 7 are copied to bit 6, and the previous contents of bit 6 (before the copy operation) are copied to bit 5. The same operation is repeated in sequence for the rest of the register. The contents of bit 0 are copied to the CY flag, and bit 7 of register L is reset to 0.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x3D))
	},
	OpCode.word(0x3E): Instruction.atomic(cycles: 4) { cpu in
		// SRL (HL)
		//
		// Cycles: 4
		// Bytes: 2
		// Flags: Z 0 0 (HL)0
		//
		// Shift the contents of memory specified by register pair HL to the right. That is, the contents of bit 7 are copied to bit 6, and the previous contents of bit 6 (before the copy operation) are copied to bit 5. The same operation is repeated in sequence for the rest of the memory location. The contents of bit 0 are copied to the CY flag, and bit 7 of (HL) is reset to 0.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x3E))
	},
	OpCode.word(0x3F): Instruction.atomic(cycles: 2) { cpu in
		// SRL A
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: Z 0 0 A0
		//
		// Shift the contents of register A to the right. That is, the contents of bit 7 are copied to bit 6, and the previous contents of bit 6 (before the copy operation) are copied to bit 5. The same operation is repeated in sequence for the rest of the register. The contents of bit 0 are copied to the CY flag, and bit 7 of register A is reset to 0.
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		//cpu.flags.carry = result.carry
		throw CPUError.instructionNotImplemented(OpCode.word(0x3F))
	},
	OpCode.word(0x40): Instruction.atomic(cycles: 2) { cpu in
		// BIT 0, B
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: !r0 0 1 -
		//
		// Copy the complement of the contents of bit 0 in register B to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x40))
	},
	OpCode.word(0x41): Instruction.atomic(cycles: 2) { cpu in
		// BIT 0, C
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: !r0 0 1 -
		//
		// Copy the complement of the contents of bit 0 in register C to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x41))
	},
	OpCode.word(0x42): Instruction.atomic(cycles: 2) { cpu in
		// BIT 0, D
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: !r0 0 1 -
		//
		// Copy the complement of the contents of bit 0 in register D to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x42))
	},
	OpCode.word(0x43): Instruction.atomic(cycles: 2) { cpu in
		// BIT 0, E
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: !r0 0 1 -
		//
		// Copy the complement of the contents of bit 0 in register E to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x43))
	},
	OpCode.word(0x44): Instruction.atomic(cycles: 2) { cpu in
		// BIT 0, H
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: !r0 0 1 -
		//
		// Copy the complement of the contents of bit 0 in register H to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x44))
	},
	OpCode.word(0x45): Instruction.atomic(cycles: 2) { cpu in
		// BIT 0, L
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: !r0 0 1 -
		//
		// Copy the complement of the contents of bit 0 in register L to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x45))
	},
	OpCode.word(0x46): Instruction.atomic(cycles: 3) { cpu in
		// BIT 0, (HL)
		//
		// Cycles: 3
		// Bytes: 2
		// Flags: !(HL)0 0 1 -
		//
		// Copy the complement of the contents of bit 0 in the memory location specified by register pair HL to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x46))
	},
	OpCode.word(0x47): Instruction.atomic(cycles: 2) { cpu in
		// BIT 0, A
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: !r0 0 1 -
		//
		// Copy the complement of the contents of bit 0 in register A to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x47))
	},
	OpCode.word(0x48): Instruction.atomic(cycles: 2) { cpu in
		// BIT 1, B
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: !r1 0 1 -
		//
		// Copy the complement of the contents of bit 1 in register B to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x48))
	},
	OpCode.word(0x49): Instruction.atomic(cycles: 2) { cpu in
		// BIT 1, C
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: !r1 0 1 -
		//
		// Copy the complement of the contents of bit 1 in register C to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x49))
	},
	OpCode.word(0x4A): Instruction.atomic(cycles: 2) { cpu in
		// BIT 1, D
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: !r1 0 1 -
		//
		// Copy the complement of the contents of bit 1 in register D to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x4A))
	},
	OpCode.word(0x4B): Instruction.atomic(cycles: 2) { cpu in
		// BIT 1, E
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: !r1 0 1 -
		//
		// Copy the complement of the contents of bit 1 in register E to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x4B))
	},
	OpCode.word(0x4C): Instruction.atomic(cycles: 2) { cpu in
		// BIT 1, H
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: !r1 0 1 -
		//
		// Copy the complement of the contents of bit 1 in register H to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x4C))
	},
	OpCode.word(0x4D): Instruction.atomic(cycles: 2) { cpu in
		// BIT 1, L
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: !r1 0 1 -
		//
		// Copy the complement of the contents of bit 1 in register L to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x4D))
	},
	OpCode.word(0x4E): Instruction.atomic(cycles: 3) { cpu in
		// BIT 1, (HL)
		//
		// Cycles: 3
		// Bytes: 2
		// Flags: !(HL)1 0 1 -
		//
		// Copy the complement of the contents of bit 1 in the memory location specified by register pair HL to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x4E))
	},
	OpCode.word(0x4F): Instruction.atomic(cycles: 2) { cpu in
		// BIT 1, A
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: !r1 0 1 -
		//
		// Copy the complement of the contents of bit 1 in register A to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x4F))
	},
	OpCode.word(0x50): Instruction.atomic(cycles: 2) { cpu in
		// BIT 2, B
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: !r2 0 1 -
		//
		// Copy the complement of the contents of bit 2 in register B to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x50))
	},
	OpCode.word(0x51): Instruction.atomic(cycles: 2) { cpu in
		// BIT 2, C
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: !r2 0 1 -
		//
		// Copy the complement of the contents of bit 2 in register C to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x51))
	},
	OpCode.word(0x52): Instruction.atomic(cycles: 2) { cpu in
		// BIT 2, D
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: !r2 0 1 -
		//
		// Copy the complement of the contents of bit 2 in register D to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x52))
	},
	OpCode.word(0x53): Instruction.atomic(cycles: 2) { cpu in
		// BIT 2, E
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: !r2 0 1 -
		//
		// Copy the complement of the contents of bit 2 in register E to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x53))
	},
	OpCode.word(0x54): Instruction.atomic(cycles: 2) { cpu in
		// BIT 2, H
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: !r2 0 1 -
		//
		// Copy the complement of the contents of bit 2 in register H to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x54))
	},
	OpCode.word(0x55): Instruction.atomic(cycles: 2) { cpu in
		// BIT 2, L
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: !r2 0 1 -
		//
		// Copy the complement of the contents of bit 2 in register L to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x55))
	},
	OpCode.word(0x56): Instruction.atomic(cycles: 3) { cpu in
		// BIT 2, (HL)
		//
		// Cycles: 3
		// Bytes: 2
		// Flags: !(HL)2 0 1 -
		//
		// Copy the complement of the contents of bit 2 in the memory location specified by register pair HL to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x56))
	},
	OpCode.word(0x57): Instruction.atomic(cycles: 2) { cpu in
		// BIT 2, A
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: !r2 0 1 -
		//
		// Copy the complement of the contents of bit 2 in register A to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x57))
	},
	OpCode.word(0x58): Instruction.atomic(cycles: 2) { cpu in
		// BIT 3, B
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: !r3 0 1 -
		//
		// Copy the complement of the contents of bit 3 in register B to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x58))
	},
	OpCode.word(0x59): Instruction.atomic(cycles: 2) { cpu in
		// BIT 3, C
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: !r3 0 1 -
		//
		// Copy the complement of the contents of bit 3 in register C to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x59))
	},
	OpCode.word(0x5A): Instruction.atomic(cycles: 2) { cpu in
		// BIT 3, D
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: !r3 0 1 -
		//
		// Copy the complement of the contents of bit 3 in register D to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x5A))
	},
	OpCode.word(0x5B): Instruction.atomic(cycles: 2) { cpu in
		// BIT 3, E
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: !r3 0 1 -
		//
		// Copy the complement of the contents of bit 3 in register E to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x5B))
	},
	OpCode.word(0x5C): Instruction.atomic(cycles: 2) { cpu in
		// BIT 3, H
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: !r3 0 1 -
		//
		// Copy the complement of the contents of bit 3 in register H to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x5C))
	},
	OpCode.word(0x5D): Instruction.atomic(cycles: 2) { cpu in
		// BIT 3, L
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: !r3 0 1 -
		//
		// Copy the complement of the contents of bit 3 in register L to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x5D))
	},
	OpCode.word(0x5E): Instruction.atomic(cycles: 3) { cpu in
		// BIT 3, (HL)
		//
		// Cycles: 3
		// Bytes: 2
		// Flags: !(HL)3 0 1 -
		//
		// Copy the complement of the contents of bit 3 in the memory location specified by register pair HL to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x5E))
	},
	OpCode.word(0x5F): Instruction.atomic(cycles: 2) { cpu in
		// BIT 3, A
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: !r3 0 1 -
		//
		// Copy the complement of the contents of bit 3 in register A to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x5F))
	},
	OpCode.word(0x60): Instruction.atomic(cycles: 2) { cpu in
		// BIT 4, B
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: !r4 0 1 -
		//
		// Copy the complement of the contents of bit 4 in register B to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x60))
	},
	OpCode.word(0x61): Instruction.atomic(cycles: 2) { cpu in
		// BIT 4, C
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: !r4 0 1 -
		//
		// Copy the complement of the contents of bit 4 in register C to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x61))
	},
	OpCode.word(0x62): Instruction.atomic(cycles: 2) { cpu in
		// BIT 4, D
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: !r4 0 1 -
		//
		// Copy the complement of the contents of bit 4 in register D to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x62))
	},
	OpCode.word(0x63): Instruction.atomic(cycles: 2) { cpu in
		// BIT 4, E
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: !r4 0 1 -
		//
		// Copy the complement of the contents of bit 4 in register E to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x63))
	},
	OpCode.word(0x64): Instruction.atomic(cycles: 2) { cpu in
		// BIT 4, H
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: !r4 0 1 -
		//
		// Copy the complement of the contents of bit 4 in register H to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x64))
	},
	OpCode.word(0x65): Instruction.atomic(cycles: 2) { cpu in
		// BIT 4, L
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: !r4 0 1 -
		//
		// Copy the complement of the contents of bit 4 in register L to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x65))
	},
	OpCode.word(0x66): Instruction.atomic(cycles: 3) { cpu in
		// BIT 4, (HL)
		//
		// Cycles: 3
		// Bytes: 2
		// Flags: !(HL)4 0 1 -
		//
		// Copy the complement of the contents of bit 4 in the memory location specified by register pair HL to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x66))
	},
	OpCode.word(0x67): Instruction.atomic(cycles: 2) { cpu in
		// BIT 4, A
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: !r4 0 1 -
		//
		// Copy the complement of the contents of bit 4 in register A to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x67))
	},
	OpCode.word(0x68): Instruction.atomic(cycles: 2) { cpu in
		// BIT 5, B
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: !r5 0 1 -
		//
		// Copy the complement of the contents of bit 5 in register B to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x68))
	},
	OpCode.word(0x69): Instruction.atomic(cycles: 2) { cpu in
		// BIT 5, C
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: !r5 0 1 -
		//
		// Copy the complement of the contents of bit 5 in register C to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x69))
	},
	OpCode.word(0x6A): Instruction.atomic(cycles: 2) { cpu in
		// BIT 5, D
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: !r5 0 1 -
		//
		// Copy the complement of the contents of bit 5 in register D to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x6A))
	},
	OpCode.word(0x6B): Instruction.atomic(cycles: 2) { cpu in
		// BIT 5, E
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: !r5 0 1 -
		//
		// Copy the complement of the contents of bit 5 in register E to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x6B))
	},
	OpCode.word(0x6C): Instruction.atomic(cycles: 2) { cpu in
		// BIT 5, H
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: !r5 0 1 -
		//
		// Copy the complement of the contents of bit 5 in register H to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x6C))
	},
	OpCode.word(0x6D): Instruction.atomic(cycles: 2) { cpu in
		// BIT 5, L
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: !r5 0 1 -
		//
		// Copy the complement of the contents of bit 5 in register L to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x6D))
	},
	OpCode.word(0x6E): Instruction.atomic(cycles: 3) { cpu in
		// BIT 5, (HL)
		//
		// Cycles: 3
		// Bytes: 2
		// Flags: !(HL)5 0 1 -
		//
		// Copy the complement of the contents of bit 5 in the memory location specified by register pair HL to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x6E))
	},
	OpCode.word(0x6F): Instruction.atomic(cycles: 2) { cpu in
		// BIT 5, A
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: !r5 0 1 -
		//
		// Copy the complement of the contents of bit 5 in register A to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x6F))
	},
	OpCode.word(0x70): Instruction.atomic(cycles: 2) { cpu in
		// BIT 6, B
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: !r6 0 1 -
		//
		// Copy the complement of the contents of bit 6 in register B to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x70))
	},
	OpCode.word(0x71): Instruction.atomic(cycles: 2) { cpu in
		// BIT 6, C
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: !r6 0 1 -
		//
		// Copy the complement of the contents of bit 6 in register C to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x71))
	},
	OpCode.word(0x72): Instruction.atomic(cycles: 2) { cpu in
		// BIT 6, D
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: !r6 0 1 -
		//
		// Copy the complement of the contents of bit 6 in register D to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x72))
	},
	OpCode.word(0x73): Instruction.atomic(cycles: 2) { cpu in
		// BIT 6, E
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: !r6 0 1 -
		//
		// Copy the complement of the contents of bit 6 in register E to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x73))
	},
	OpCode.word(0x74): Instruction.atomic(cycles: 2) { cpu in
		// BIT 6, H
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: !r6 0 1 -
		//
		// Copy the complement of the contents of bit 6 in register H to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x74))
	},
	OpCode.word(0x75): Instruction.atomic(cycles: 2) { cpu in
		// BIT 6, L
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: !r6 0 1 -
		//
		// Copy the complement of the contents of bit 6 in register L to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x75))
	},
	OpCode.word(0x76): Instruction.atomic(cycles: 3) { cpu in
		// BIT 6, (HL)
		//
		// Cycles: 3
		// Bytes: 2
		// Flags: !(HL)6 0 1 -
		//
		// Copy the complement of the contents of bit 6 in the memory location specified by register pair HL to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x76))
	},
	OpCode.word(0x77): Instruction.atomic(cycles: 2) { cpu in
		// BIT 6, A
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: !r6 0 1 -
		//
		// Copy the complement of the contents of bit 6 in register A to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x77))
	},
	OpCode.word(0x78): Instruction.atomic(cycles: 2) { cpu in
		// BIT 7, B
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: !r7 0 1 -
		//
		// Copy the complement of the contents of bit 7 in register B to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x78))
	},
	OpCode.word(0x79): Instruction.atomic(cycles: 2) { cpu in
		// BIT 7, C
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: !r7 0 1 -
		//
		// Copy the complement of the contents of bit 7 in register C to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x79))
	},
	OpCode.word(0x7A): Instruction.atomic(cycles: 2) { cpu in
		// BIT 7, D
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: !r7 0 1 -
		//
		// Copy the complement of the contents of bit 7 in register D to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x7A))
	},
	OpCode.word(0x7B): Instruction.atomic(cycles: 2) { cpu in
		// BIT 7, E
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: !r7 0 1 -
		//
		// Copy the complement of the contents of bit 7 in register E to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x7B))
	},
	OpCode.word(0x7C): Instruction.atomic(cycles: 2) { cpu in
		// BIT 7, H
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: !r7 0 1 -
		//
		// Copy the complement of the contents of bit 7 in register H to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x7C))
	},
	OpCode.word(0x7D): Instruction.atomic(cycles: 2) { cpu in
		// BIT 7, L
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: !r7 0 1 -
		//
		// Copy the complement of the contents of bit 7 in register L to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x7D))
	},
	OpCode.word(0x7E): Instruction.atomic(cycles: 3) { cpu in
		// BIT 7, (HL)
		//
		// Cycles: 3
		// Bytes: 2
		// Flags: !(HL)7 0 1 -
		//
		// Copy the complement of the contents of bit 7 in the memory location specified by register pair HL to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x7E))
	},
	OpCode.word(0x7F): Instruction.atomic(cycles: 2) { cpu in
		// BIT 7, A
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: !r7 0 1 -
		//
		// Copy the complement of the contents of bit 7 in register A to the Z flag of the program status word (PSW).
		//
		//cpu.flags.zero = result.zero
		//cpu.flags.subtract = result.subtract
		//cpu.flags.halfCarry = result.halfCarry
		throw CPUError.instructionNotImplemented(OpCode.word(0x7F))
	},
	OpCode.word(0x80): Instruction.atomic(cycles: 2) { cpu in
		// RES 0, B
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 0 in register B to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0x80))
	},
	OpCode.word(0x81): Instruction.atomic(cycles: 2) { cpu in
		// RES 0, C
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 0 in register C to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0x81))
	},
	OpCode.word(0x82): Instruction.atomic(cycles: 2) { cpu in
		// RES 0, D
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 0 in register D to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0x82))
	},
	OpCode.word(0x83): Instruction.atomic(cycles: 2) { cpu in
		// RES 0, E
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 0 in register E to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0x83))
	},
	OpCode.word(0x84): Instruction.atomic(cycles: 2) { cpu in
		// RES 0, H
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 0 in register H to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0x84))
	},
	OpCode.word(0x85): Instruction.atomic(cycles: 2) { cpu in
		// RES 0, L
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 0 in register L to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0x85))
	},
	OpCode.word(0x86): Instruction.atomic(cycles: 4) { cpu in
		// RES 0, (HL)
		//
		// Cycles: 4
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 0 in the memory location specified by register pair HL to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0x86))
	},
	OpCode.word(0x87): Instruction.atomic(cycles: 2) { cpu in
		// RES 0, A
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 0 in register A to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0x87))
	},
	OpCode.word(0x88): Instruction.atomic(cycles: 2) { cpu in
		// RES 1, B
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 1 in register B to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0x88))
	},
	OpCode.word(0x89): Instruction.atomic(cycles: 2) { cpu in
		// RES 1, C
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 1 in register C to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0x89))
	},
	OpCode.word(0x8A): Instruction.atomic(cycles: 2) { cpu in
		// RES 1, D
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 1 in register D to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0x8A))
	},
	OpCode.word(0x8B): Instruction.atomic(cycles: 2) { cpu in
		// RES 1, E
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 1 in register E to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0x8B))
	},
	OpCode.word(0x8C): Instruction.atomic(cycles: 2) { cpu in
		// RES 1, H
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 1 in register H to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0x8C))
	},
	OpCode.word(0x8D): Instruction.atomic(cycles: 2) { cpu in
		// RES 1, L
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 1 in register L to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0x8D))
	},
	OpCode.word(0x8E): Instruction.atomic(cycles: 4) { cpu in
		// RES 1, (HL)
		//
		// Cycles: 4
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 1 in the memory location specified by register pair HL to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0x8E))
	},
	OpCode.word(0x8F): Instruction.atomic(cycles: 2) { cpu in
		// RES 1, A
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 1 in register A to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0x8F))
	},
	OpCode.word(0x90): Instruction.atomic(cycles: 2) { cpu in
		// RES 2, B
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 2 in register B to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0x90))
	},
	OpCode.word(0x91): Instruction.atomic(cycles: 2) { cpu in
		// RES 2, C
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 2 in register C to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0x91))
	},
	OpCode.word(0x92): Instruction.atomic(cycles: 2) { cpu in
		// RES 2, D
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 2 in register D to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0x92))
	},
	OpCode.word(0x93): Instruction.atomic(cycles: 2) { cpu in
		// RES 2, E
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 2 in register E to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0x93))
	},
	OpCode.word(0x94): Instruction.atomic(cycles: 2) { cpu in
		// RES 2, H
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 2 in register H to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0x94))
	},
	OpCode.word(0x95): Instruction.atomic(cycles: 2) { cpu in
		// RES 2, L
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 2 in register L to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0x95))
	},
	OpCode.word(0x96): Instruction.atomic(cycles: 4) { cpu in
		// RES 2, (HL)
		//
		// Cycles: 4
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 2 in the memory location specified by register pair HL to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0x96))
	},
	OpCode.word(0x97): Instruction.atomic(cycles: 2) { cpu in
		// RES 2, A
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 2 in register A to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0x97))
	},
	OpCode.word(0x98): Instruction.atomic(cycles: 2) { cpu in
		// RES 3, B
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 3 in register B to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0x98))
	},
	OpCode.word(0x99): Instruction.atomic(cycles: 2) { cpu in
		// RES 3, C
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 3 in register C to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0x99))
	},
	OpCode.word(0x9A): Instruction.atomic(cycles: 2) { cpu in
		// RES 3, D
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 3 in register D to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0x9A))
	},
	OpCode.word(0x9B): Instruction.atomic(cycles: 2) { cpu in
		// RES 3, E
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 3 in register E to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0x9B))
	},
	OpCode.word(0x9C): Instruction.atomic(cycles: 2) { cpu in
		// RES 3, H
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 3 in register H to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0x9C))
	},
	OpCode.word(0x9D): Instruction.atomic(cycles: 2) { cpu in
		// RES 3, L
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 3 in register L to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0x9D))
	},
	OpCode.word(0x9E): Instruction.atomic(cycles: 4) { cpu in
		// RES 3, (HL)
		//
		// Cycles: 4
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 3 in the memory location specified by register pair HL to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0x9E))
	},
	OpCode.word(0x9F): Instruction.atomic(cycles: 2) { cpu in
		// RES 3, A
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 3 in register A to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0x9F))
	},
	OpCode.word(0xA0): Instruction.atomic(cycles: 2) { cpu in
		// RES 4, B
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 4 in register B to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xA0))
	},
	OpCode.word(0xA1): Instruction.atomic(cycles: 2) { cpu in
		// RES 4, C
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 4 in register C to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xA1))
	},
	OpCode.word(0xA2): Instruction.atomic(cycles: 2) { cpu in
		// RES 4, D
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 4 in register D to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xA2))
	},
	OpCode.word(0xA3): Instruction.atomic(cycles: 2) { cpu in
		// RES 4, E
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 4 in register E to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xA3))
	},
	OpCode.word(0xA4): Instruction.atomic(cycles: 2) { cpu in
		// RES 4, H
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 4 in register H to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xA4))
	},
	OpCode.word(0xA5): Instruction.atomic(cycles: 2) { cpu in
		// RES 4, L
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 4 in register L to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xA5))
	},
	OpCode.word(0xA6): Instruction.atomic(cycles: 4) { cpu in
		// RES 4, (HL)
		//
		// Cycles: 4
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 4 in the memory location specified by register pair HL to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xA6))
	},
	OpCode.word(0xA7): Instruction.atomic(cycles: 2) { cpu in
		// RES 4, A
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 4 in register A to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xA7))
	},
	OpCode.word(0xA8): Instruction.atomic(cycles: 2) { cpu in
		// RES 5, B
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 5 in register B to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xA8))
	},
	OpCode.word(0xA9): Instruction.atomic(cycles: 2) { cpu in
		// RES 5, C
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 5 in register C to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xA9))
	},
	OpCode.word(0xAA): Instruction.atomic(cycles: 2) { cpu in
		// RES 5, D
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 5 in register D to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xAA))
	},
	OpCode.word(0xAB): Instruction.atomic(cycles: 2) { cpu in
		// RES 5, E
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 5 in register E to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xAB))
	},
	OpCode.word(0xAC): Instruction.atomic(cycles: 2) { cpu in
		// RES 5, H
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 5 in register H to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xAC))
	},
	OpCode.word(0xAD): Instruction.atomic(cycles: 2) { cpu in
		// RES 5, L
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 5 in register L to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xAD))
	},
	OpCode.word(0xAE): Instruction.atomic(cycles: 4) { cpu in
		// RES 5, (HL)
		//
		// Cycles: 4
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 5 in the memory location specified by register pair HL to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xAE))
	},
	OpCode.word(0xAF): Instruction.atomic(cycles: 2) { cpu in
		// RES 5, A
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 5 in register A to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xAF))
	},
	OpCode.word(0xB0): Instruction.atomic(cycles: 2) { cpu in
		// RES 6, B
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 6 in register B to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xB0))
	},
	OpCode.word(0xB1): Instruction.atomic(cycles: 2) { cpu in
		// RES 6, C
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 6 in register C to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xB1))
	},
	OpCode.word(0xB2): Instruction.atomic(cycles: 2) { cpu in
		// RES 6, D
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 6 in register D to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xB2))
	},
	OpCode.word(0xB3): Instruction.atomic(cycles: 2) { cpu in
		// RES 6, E
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 6 in register E to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xB3))
	},
	OpCode.word(0xB4): Instruction.atomic(cycles: 2) { cpu in
		// RES 6, H
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 6 in register H to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xB4))
	},
	OpCode.word(0xB5): Instruction.atomic(cycles: 2) { cpu in
		// RES 6, L
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 6 in register L to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xB5))
	},
	OpCode.word(0xB6): Instruction.atomic(cycles: 4) { cpu in
		// RES 6, (HL)
		//
		// Cycles: 4
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 6 in the memory location specified by register pair HL to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xB6))
	},
	OpCode.word(0xB7): Instruction.atomic(cycles: 2) { cpu in
		// RES 6, A
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 6 in register A to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xB7))
	},
	OpCode.word(0xB8): Instruction.atomic(cycles: 2) { cpu in
		// RES 7, B
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 7 in register B to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xB8))
	},
	OpCode.word(0xB9): Instruction.atomic(cycles: 2) { cpu in
		// RES 7, C
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 7 in register C to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xB9))
	},
	OpCode.word(0xBA): Instruction.atomic(cycles: 2) { cpu in
		// RES 7, D
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 7 in register D to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xBA))
	},
	OpCode.word(0xBB): Instruction.atomic(cycles: 2) { cpu in
		// RES 7, E
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 7 in register E to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xBB))
	},
	OpCode.word(0xBC): Instruction.atomic(cycles: 2) { cpu in
		// RES 7, H
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 7 in register H to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xBC))
	},
	OpCode.word(0xBD): Instruction.atomic(cycles: 2) { cpu in
		// RES 7, L
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 7 in register L to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xBD))
	},
	OpCode.word(0xBE): Instruction.atomic(cycles: 4) { cpu in
		// RES 7, (HL)
		//
		// Cycles: 4
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 7 in the memory location specified by register pair HL to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xBE))
	},
	OpCode.word(0xBF): Instruction.atomic(cycles: 2) { cpu in
		// RES 7, A
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Reset bit 7 in register A to 0.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xBF))
	},
	OpCode.word(0xC0): Instruction.atomic(cycles: 2) { cpu in
		// SET 0, B
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 0 in register B to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xC0))
	},
	OpCode.word(0xC1): Instruction.atomic(cycles: 2) { cpu in
		// SET 0, C
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 0 in register C to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xC1))
	},
	OpCode.word(0xC2): Instruction.atomic(cycles: 2) { cpu in
		// SET 0, D
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 0 in register D to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xC2))
	},
	OpCode.word(0xC3): Instruction.atomic(cycles: 2) { cpu in
		// SET 0, E
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 0 in register E to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xC3))
	},
	OpCode.word(0xC4): Instruction.atomic(cycles: 2) { cpu in
		// SET 0, H
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 0 in register H to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xC4))
	},
	OpCode.word(0xC5): Instruction.atomic(cycles: 2) { cpu in
		// SET 0, L
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 0 in register L to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xC5))
	},
	OpCode.word(0xC6): Instruction.atomic(cycles: 4) { cpu in
		// SET 0, (HL)
		//
		// Cycles: 4
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 0 in the memory location specified by register pair HL to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xC6))
	},
	OpCode.word(0xC7): Instruction.atomic(cycles: 2) { cpu in
		// SET 0, A
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 0 in register A to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xC7))
	},
	OpCode.word(0xC8): Instruction.atomic(cycles: 2) { cpu in
		// SET 1, B
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 1 in register B to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xC8))
	},
	OpCode.word(0xC9): Instruction.atomic(cycles: 2) { cpu in
		// SET 1, C
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 1 in register C to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xC9))
	},
	OpCode.word(0xCA): Instruction.atomic(cycles: 2) { cpu in
		// SET 1, D
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 1 in register D to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xCA))
	},
	OpCode.word(0xCB): Instruction.atomic(cycles: 2) { cpu in
		// SET 1, E
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 1 in register E to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xCB))
	},
	OpCode.word(0xCC): Instruction.atomic(cycles: 2) { cpu in
		// SET 1, H
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 1 in register H to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xCC))
	},
	OpCode.word(0xCD): Instruction.atomic(cycles: 2) { cpu in
		// SET 1, L
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 1 in register L to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xCD))
	},
	OpCode.word(0xCE): Instruction.atomic(cycles: 4) { cpu in
		// SET 1, (HL)
		//
		// Cycles: 4
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 1 in the memory location specified by register pair HL to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xCE))
	},
	OpCode.word(0xCF): Instruction.atomic(cycles: 2) { cpu in
		// SET 1, A
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 1 in register A to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xCF))
	},
	OpCode.word(0xD0): Instruction.atomic(cycles: 2) { cpu in
		// SET 2, B
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 2 in register B to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xD0))
	},
	OpCode.word(0xD1): Instruction.atomic(cycles: 2) { cpu in
		// SET 2, C
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 2 in register C to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xD1))
	},
	OpCode.word(0xD2): Instruction.atomic(cycles: 2) { cpu in
		// SET 2, D
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 2 in register D to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xD2))
	},
	OpCode.word(0xD3): Instruction.atomic(cycles: 2) { cpu in
		// SET 2, E
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 2 in register E to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xD3))
	},
	OpCode.word(0xD4): Instruction.atomic(cycles: 2) { cpu in
		// SET 2, H
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 2 in register H to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xD4))
	},
	OpCode.word(0xD5): Instruction.atomic(cycles: 2) { cpu in
		// SET 2, L
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 2 in register L to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xD5))
	},
	OpCode.word(0xD6): Instruction.atomic(cycles: 4) { cpu in
		// SET 2, (HL)
		//
		// Cycles: 4
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 2 in the memory location specified by register pair HL to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xD6))
	},
	OpCode.word(0xD7): Instruction.atomic(cycles: 2) { cpu in
		// SET 2, A
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 2 in register A to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xD7))
	},
	OpCode.word(0xD8): Instruction.atomic(cycles: 2) { cpu in
		// SET 3, B
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 3 in register B to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xD8))
	},
	OpCode.word(0xD9): Instruction.atomic(cycles: 2) { cpu in
		// SET 3, C
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 3 in register C to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xD9))
	},
	OpCode.word(0xDA): Instruction.atomic(cycles: 2) { cpu in
		// SET 3, D
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 3 in register D to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xDA))
	},
	OpCode.word(0xDB): Instruction.atomic(cycles: 2) { cpu in
		// SET 3, E
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 3 in register E to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xDB))
	},
	OpCode.word(0xDC): Instruction.atomic(cycles: 2) { cpu in
		// SET 3, H
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 3 in register H to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xDC))
	},
	OpCode.word(0xDD): Instruction.atomic(cycles: 2) { cpu in
		// SET 3, L
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 3 in register L to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xDD))
	},
	OpCode.word(0xDE): Instruction.atomic(cycles: 4) { cpu in
		// SET 3, (HL)
		//
		// Cycles: 4
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 3 in the memory location specified by register pair HL to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xDE))
	},
	OpCode.word(0xDF): Instruction.atomic(cycles: 2) { cpu in
		// SET 3, A
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 3 in register A to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xDF))
	},
	OpCode.word(0xE0): Instruction.atomic(cycles: 2) { cpu in
		// SET 4, B
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 4 in register B to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xE0))
	},
	OpCode.word(0xE1): Instruction.atomic(cycles: 2) { cpu in
		// SET 4, C
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 4 in register C to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xE1))
	},
	OpCode.word(0xE2): Instruction.atomic(cycles: 2) { cpu in
		// SET 4, D
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 4 in register D to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xE2))
	},
	OpCode.word(0xE3): Instruction.atomic(cycles: 2) { cpu in
		// SET 4, E
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 4 in register E to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xE3))
	},
	OpCode.word(0xE4): Instruction.atomic(cycles: 2) { cpu in
		// SET 4, H
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 4 in register H to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xE4))
	},
	OpCode.word(0xE5): Instruction.atomic(cycles: 2) { cpu in
		// SET 4, L
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 4 in register L to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xE5))
	},
	OpCode.word(0xE6): Instruction.atomic(cycles: 4) { cpu in
		// SET 4, (HL)
		//
		// Cycles: 4
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 4 in the memory location specified by register pair HL to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xE6))
	},
	OpCode.word(0xE7): Instruction.atomic(cycles: 2) { cpu in
		// SET 4, A
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 4 in register A to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xE7))
	},
	OpCode.word(0xE8): Instruction.atomic(cycles: 2) { cpu in
		// SET 5, B
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 5 in register B to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xE8))
	},
	OpCode.word(0xE9): Instruction.atomic(cycles: 2) { cpu in
		// SET 5, C
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 5 in register C to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xE9))
	},
	OpCode.word(0xEA): Instruction.atomic(cycles: 2) { cpu in
		// SET 5, D
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 5 in register D to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xEA))
	},
	OpCode.word(0xEB): Instruction.atomic(cycles: 2) { cpu in
		// SET 5, E
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 5 in register E to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xEB))
	},
	OpCode.word(0xEC): Instruction.atomic(cycles: 2) { cpu in
		// SET 5, H
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 5 in register H to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xEC))
	},
	OpCode.word(0xED): Instruction.atomic(cycles: 2) { cpu in
		// SET 5, L
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 5 in register L to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xED))
	},
	OpCode.word(0xEE): Instruction.atomic(cycles: 4) { cpu in
		// SET 5, (HL)
		//
		// Cycles: 4
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 5 in the memory location specified by register pair HL to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xEE))
	},
	OpCode.word(0xEF): Instruction.atomic(cycles: 2) { cpu in
		// SET 5, A
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 5 in register A to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xEF))
	},
	OpCode.word(0xF0): Instruction.atomic(cycles: 2) { cpu in
		// SET 6, B
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 6 in register B to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xF0))
	},
	OpCode.word(0xF1): Instruction.atomic(cycles: 2) { cpu in
		// SET 6, C
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 6 in register C to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xF1))
	},
	OpCode.word(0xF2): Instruction.atomic(cycles: 2) { cpu in
		// SET 6, D
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 6 in register D to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xF2))
	},
	OpCode.word(0xF3): Instruction.atomic(cycles: 2) { cpu in
		// SET 6, E
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 6 in register E to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xF3))
	},
	OpCode.word(0xF4): Instruction.atomic(cycles: 2) { cpu in
		// SET 6, H
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 6 in register H to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xF4))
	},
	OpCode.word(0xF5): Instruction.atomic(cycles: 2) { cpu in
		// SET 6, L
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 6 in register L to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xF5))
	},
	OpCode.word(0xF6): Instruction.atomic(cycles: 4) { cpu in
		// SET 6, (HL)
		//
		// Cycles: 4
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 6 in the memory location specified by register pair HL to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xF6))
	},
	OpCode.word(0xF7): Instruction.atomic(cycles: 2) { cpu in
		// SET 6, A
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 6 in register A to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xF7))
	},
	OpCode.word(0xF8): Instruction.atomic(cycles: 2) { cpu in
		// SET 7, B
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 7 in register B to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xF8))
	},
	OpCode.word(0xF9): Instruction.atomic(cycles: 2) { cpu in
		// SET 7, C
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 7 in register C to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xF9))
	},
	OpCode.word(0xFA): Instruction.atomic(cycles: 2) { cpu in
		// SET 7, D
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 7 in register D to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xFA))
	},
	OpCode.word(0xFB): Instruction.atomic(cycles: 2) { cpu in
		// SET 7, E
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 7 in register E to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xFB))
	},
	OpCode.word(0xFC): Instruction.atomic(cycles: 2) { cpu in
		// SET 7, H
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 7 in register H to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xFC))
	},
	OpCode.word(0xFD): Instruction.atomic(cycles: 2) { cpu in
		// SET 7, L
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 7 in register L to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xFD))
	},
	OpCode.word(0xFE): Instruction.atomic(cycles: 4) { cpu in
		// SET 7, (HL)
		//
		// Cycles: 4
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 7 in the memory location specified by register pair HL to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xFE))
	},
	OpCode.word(0xFF): Instruction.atomic(cycles: 2) { cpu in
		// SET 7, A
		//
		// Cycles: 2
		// Bytes: 2
		// Flags: - - - -
		//
		// Set bit 7 in register A to 1.
		//
		throw CPUError.instructionNotImplemented(OpCode.word(0xFF))
	},
]
