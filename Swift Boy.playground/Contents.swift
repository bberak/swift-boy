import Foundation
import PlaygroundSupport

let cart = Cartridge(path: #fileLiteral(resourceName: "cpu_instrs.gb"), title: "Blargg CPU Test")
let mmu = MMU()
let ppu = PPU(mmu)
let cpu = CPU(mmu, ppu)

try? cpu.run()

PlaygroundPage.current.setLiveView(ppu.screen)






































