const fs = require("fs");
const _ = require("lodash");
const inputPath = "generated.swift"
const outputPath = "formatted.swift";

const text = fs.readFileSync(inputPath, "utf8");
const all = text.split("\n");

const result = all.reduce((acc, line) => {
	const trimmed = _.trim(line);

	if (trimmed.startsWith("OpCode.byte") || trimmed.startsWith("OpCode.word")) {
		acc.sourceBlocks.push([line])
		acc.commentBlocks.push([])
	} else if (trimmed.startsWith("//")) {
		const block = _.last(acc.commentBlocks)
		block.push(line)
	} else {
		const block = _.last(acc.sourceBlocks)
		if (block)
			block.push(line)
	}

	return acc;
}, { sourceBlocks: [], commentBlocks: [] });

const writeLine = (line) => {
	fs.appendFileSync(outputPath, `${line}\n`);
};

if (fs.existsSync(outputPath)) 
	fs.unlinkSync(outputPath);

result.sourceBlocks.forEach((sb, index) => {
	const cb = result.commentBlocks[index];

	cb.map(_.trim).map(x => "\t" + x).forEach((line, idx) => {
		if (idx == (cb.length -1) && line == "\t//") {
			//-- Ignore unecessary spacers
		} else {
			writeLine(line)
		}
	})
	sb.forEach(writeLine)
})