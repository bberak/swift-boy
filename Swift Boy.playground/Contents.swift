import Foundation
import PlaygroundSupport

let cart = Cartridge(path: #fileLiteral(resourceName: "cpu_instrs.gb"), title: "Blargg's CPU Test")
let mmu = MMU()
let ppu = PPU(mmu)
let cpu = CPU(mmu, ppu)
let clock = Clock(cpu, ppu)

clock.start()

PlaygroundPage.current.setLiveView(ppu.lcd)



































































