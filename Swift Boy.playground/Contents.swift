import Foundation

let cartridge = Cartridge(path: #fileLiteral(resourceName: "cpu_instrs.gb"), title: "Blargg CPU Test")
let mmu = MMU(cartridge: cartridge)
let cpu = CPU(mmu: mmu)

try cpu.run()


