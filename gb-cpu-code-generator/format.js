const fs = require("fs");
const _ = require("lodash");
const path = "out.swift";

const source = fs.readFileSync(path, "utf8");
const lines = source.split("\n")

console.log(lines.length)