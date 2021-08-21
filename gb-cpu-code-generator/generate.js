const fetch = require("node-fetch");
const fs = require("fs");
const _ = require("lodash");
const outputPath = "generated.swift";

if (fs.existsSync(outputPath)) 
	fs.unlinkSync(outputPath);

fetch("https://gist.githubusercontent.com/bberak/ca001281bb8431d2706afd31401e802b/raw/118ac680ac43cc3153c3c33344a692d37d2fd5a7/gb-instructions-db.json")
	.then((res) => res.json())
	.then((arr) => {
		const byteOps = _.sortBy(arr.filter((x) => x.opCode.length == 2), (x) => x.opCode);
		const wordOps = _.sortBy(arr.filter((x) => x.opCode.length == 4), (x) => x.opCode);
		writeLine("let instructions: [OpCode: Instruction] = [");
		[...byteOps, ...wordOps].forEach(writeInstruction);
		writeLine("]");
	});

const writeLine = (line) => {
	fs.appendFileSync(outputPath, `${line}\n`);
};

const writeInstruction = (op) => {
	const cycles = op.cycles.length === 1 ? op.cycles : _.last(op.cycles.split("/"));

	writeLine(`\t// ${op.mnemonic}`);
	writeLine(`\t//`);
	writeLine(`\t// Cycles: ${op.cycles}`);
	writeLine(`\t// Bytes: ${op.bytes}`);
	writeLine(`\t// Flags: ${sanitizeFlags(op.flags)}`);
	writeLine(`\t//`);

	(op.description || "").split("\n").forEach((x) => writeLine(`\t// ${_.trim(x)}`));

	if (op.opCode.length === 2)
		writeLine(`\tOpCode.byte(0x${op.opCode}): Instruction.atomic(cycles: ${cycles}) { cpu in`);
	else 
		writeLine(`\tOpCode.word(0x${op.opCode.replace("CB", "")}): Instruction.atomic(cycles: ${cycles}) { cpu in`);


	if (op.mnemonic.startsWith("LD")) {
		writeLD(op);
		writeNotImplementedError(op);
	}
	else if (op.mnemonic.startsWith("BIT")) {
		writeBIT(op);
		//-- Pretty confident these instruction are generated correctly..
	}
	else if (op.mnemonic.startsWith("RES")) {
		writeRES(op);
		//-- Pretty confident these instruction are generated correctly..
	}
	else {
		writeFlags(op.flags);
		writeNotImplementedError(op);
	}

	writeLine(`\t},`);
};

const writeLD = (op) => {
	/*
	d8 - 8-bit immediate data value
	d16 - 16-bit immediate data value
	a8 - 8-bit immediate value specifying an address in the range 0xFF00 - 0xFFFF
	a16 - 16-bit immediate address value
	s8 - 8-bit signed immediate data value
	*/
	const operands = op.mnemonic.replace(",", "").split(" ");

	if (operands.length === 3) {
		const destination = operands[1];
		const wordOperation = countLetters(destination) == 2;
		const source = operands[2];

		if (source === "d8") writeLine("\t\t//let data = try cpu.readNextByte()");

		if (source === "d16") writeLine("\t\t//let data = try cpu.readNextWord()");

		if (source === "a8") {
			writeLine("\t\t//let address = UInt16(try cpu.readNextByte() + 0xFF00)");

			if (wordOperation) writeLine("\t\t//let data = try cpu.mmu.readWord(address: address)");
			else writeLine("\t\t//let data = try cpu.mmu.readWord(address: address)");
		}

		if (source === "a16") {
			writeLine("\t\t//let address = try cpu.readNextWord()");

			if (wordOperation) writeLine("\t\t//let data = try cpu.mmu.readWord(address: address)");
			else writeLine("\t\t//let data = try cpu.mmu.readWord(address: address)");
		}

		if (source === "A")
			writeLine("\t\t//let data = cpu.a")

		if (source === "F")
			writeLine("\t\t//let data = cpu.f")

		if (source === "AF")
			 writeLine("\t\t//let data = cpu.af");

		if (source === "(AF)") {
			if (wordOperation) writeLine("\t\t//let data = try cpu.mmu.readWord(address: cpu.af)");
			else writeLine("\t\t//let data = try cpu.mmu.readByte(address: cpu.af)");
		}

		if (source === "B")
			writeLine("\t\t//let data = cpu.b")

		if (source === "C")
			writeLine("\t\t//let data = cpu.c")

		if (source === "BC")
			 writeLine("\t\t//let data = cpu.bc");

		if (source === "(BC)") {
			if (wordOperation) writeLine("\t\t//let data = try cpu.mmu.readWord(address: cpu.bc)");
			else writeLine("\t\t//let data = try cpu.mmu.readByte(address: cpu.bc)");
		}

		if (source === "D")
			writeLine("\t\t//let data = cpu.d")

		if (source === "E")
			writeLine("\t\t//let data = cpu.e")

		if (source === "DE")
			 writeLine("\t\t//let data = cpu.de");

		if (source === "(DE)") {
			if (wordOperation) writeLine("\t\t//let data = try cpu.mmu.readWord(address: cpu.de)");
			else writeLine("\t\t//let data = try cpu.mmu.readByte(address: cpu.de)");
		}

		if (source === "H")
			writeLine("\t\t//let data = cpu.h")

		if (source === "L")
			writeLine("\t\t//let data = cpu.l")

		if (source === "HL")
			 writeLine("\t\t//let data = cpu.hl");

		if (source === "(HL)") {
			if (wordOperation) writeLine("\t\t//let data = try cpu.mmu.readWord(address: cpu.hl)");
			else writeLine("\t\t//let data = try cpu.mmu.readByte(address: cpu.hl)");
		}

		if (destination.indexOf("(") !== -1) {
			if (wordOperation) writeLine(`\t\t//try cpu.mmu.writeWord(address: cpu.${sanitizeRegister(destination)}, word: data)`)
			else writeLine(`\t\t//try cpu.mmu.writeByte(address: cpu.${sanitizeRegister(destination)}, byte: data)`)
		}
		else
			writeLine(`\t\t//cpu.${sanitizeRegister(destination)} = data`)
	}

	writeFlags(op.flags);
};

const writeBIT = (op) => {
	const operands = op.mnemonic.replace(",", "").split(" ");

	if (operands.length === 3) {
		const bit = operands[1];
		const source = operands[2];

		if (source === "A")
			writeLine("\t\tlet data = cpu.a")

		if (source === "F")
			writeLine("\t\tlet data = cpu.f")

		if (source === "AF")
			 writeLine("\t\tlet data = cpu.af");

		if (source === "(AF)")
			writeLine("\t\tlet data = try cpu.mmu.readByte(address: cpu.af)");

		if (source === "B")
			writeLine("\t\tlet data = cpu.b")

		if (source === "C")
			writeLine("\t\tlet data = cpu.c")

		if (source === "BC")
			 writeLine("\t\tlet data = cpu.bc");

		if (source === "(BC)")
			writeLine("\t\tlet data = try cpu.mmu.readByte(address: cpu.bc)");

		if (source === "D")
			writeLine("\t\tlet data = cpu.d")

		if (source === "E")
			writeLine("\t\tlet data = cpu.e")

		if (source === "DE")
			 writeLine("\t\tlet data = cpu.de");

		if (source === "(DE)")
			writeLine("\t\tlet data = try cpu.mmu.readByte(address: cpu.de)");

		if (source === "H")
			writeLine("\t\tlet data = cpu.h")

		if (source === "L")
			writeLine("\t\tlet data = cpu.l")

		if (source === "HL")
			 writeLine("\t\tlet data = cpu.hl");

		if (source === "(HL)")
			writeLine("\t\tlet data = try cpu.mmu.readByte(address: cpu.hl)");

		writeLine(`\t\tcpu.flags.carry = !data.bit(${bit})`);
		writeLine("\t\tcpu.flags.subtract = false");
		writeLine("\t\tcpu.flags.halfCarry = true");
	} else {
		writeFlags(op.flags);
	}
};

const writeRES = (op) => {
	const operands = op.mnemonic.replace(",", "").split(" ");

	if (operands.length === 3) {
		const bit = operands[1];
		const source = operands[2];

		if (source === "A")
			writeLine("\t\tvar data = cpu.a")

		if (source === "F")
			writeLine("\t\tvar data = cpu.f")

		if (source === "AF")
			 writeLine("\t\tvar data = cpu.af");

		if (source === "(AF)")
			writeLine("\t\tvar data = try cpu.mmu.readByte(address: cpu.af)");

		if (source === "B")
			writeLine("\t\tvar data = cpu.b")

		if (source === "C")
			writeLine("\t\tvar data = cpu.c")

		if (source === "BC")
			 writeLine("\t\tvar data = cpu.bc");

		if (source === "(BC)")
			writeLine("\t\tvar data = try cpu.mmu.readByte(address: cpu.bc)");

		if (source === "D")
			writeLine("\t\tvar data = cpu.d")

		if (source === "E")
			writeLine("\t\tvar data = cpu.e")

		if (source === "DE")
			 writeLine("\t\tvar data = cpu.de");

		if (source === "(DE)")
			writeLine("\t\tvar data = try cpu.mmu.readByte(address: cpu.de)");

		if (source === "H")
			writeLine("\t\tvar data = cpu.h")

		if (source === "L")
			writeLine("\t\tvar data = cpu.l")

		if (source === "HL")
			 writeLine("\t\tvar data = cpu.hl");

		if (source === "(HL)")
			writeLine("\t\tvar data = try cpu.mmu.readByte(address: cpu.hl)");

		writeLine(`\t\tdata = data.reset(${bit})`);

		if (source.indexOf("(") !== -1)
			writeLine(`\t\ttry cpu.mmu.writeByte(address: cpu.${sanitizeRegister(source)}, byte: data)`)
		else 
			writeLine(`\t\tcpu.${sanitizeRegister(source)} = data`)
	}
};

const writeFlags = (flags) => {
	if (flags.Z) writeLine("\t\t//cpu.flags.zero = result.zero");
	if (flags.N) writeLine("\t\t//cpu.flags.subtract = result.subtract");
	if (flags.H) writeLine("\t\t//cpu.flags.halfCarry = result.halfCarry");
	if (flags.CY) writeLine("\t\t//cpu.flags.carry = result.carry");
};

const writeNotImplementedError = (op) => {
	if (op.opCode.length === 2)
		writeLine(`\t\tthrow CPUError.instructionNotImplemented(OpCode.byte(0x${op.opCode}))`);
	else 
		writeLine(`\t\tthrow CPUError.instructionNotImplemented(OpCode.word(0x${op.opCode.replace("CB", "")}))`);
};

const sanitizeFlags = (flags) => {
	let result = "";

	if (flags.Z) result += flags.Z;
	else result += "-";

	result += " ";

	if (flags.N) result += flags.N;
	else result += "-";

	result += " ";

	if (flags.H) result += flags.H;
	else result += "-";

	result += " ";

	if (flags.CY) result += flags.CY;
	else result += "-";

	return result;
};

const countLetters = (destination) => {
	return (destination.match(/is/g) || []).length;
};

const sanitizeRegister = (destination) => {
	let result = destination
	let arr = ["+", "-", "(", ")"]
	
	arr.forEach(x => {
		result = result.replace(x, "")
	})

	return result.toLowerCase()
};
