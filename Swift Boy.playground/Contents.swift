import Foundation
import PlaygroundSupport

let blargg = Cartridge(path: #fileLiteral(resourceName: "cpu_instrs.gb"))
let tetris = Cartridge(path: #fileLiteral(resourceName: "tetris.gb"))

let mmu = MMU(blargg)
let ppu = PPU(mmu)
let cpu = CPU(mmu, ppu)
let clock = Clock(mmu, ppu, cpu)

clock.start()

PlaygroundPage.current.setLiveView(ppu.lcd)






















































































