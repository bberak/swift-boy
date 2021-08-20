import Foundation

let cartridge = Cartridge(path: #fileLiteral(resourceName: "cpu_instrs.gb"), title: "Blargg CPU Test")
let mmu = MMU()
let cpu = CPU(mmu: mmu)

try cpu.start()







