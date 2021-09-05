import Foundation
import PlaygroundSupport

let cart = Cartridge(path: #fileLiteral(resourceName: "cpu_instrs.gb"), title: "Blargg's CPU Test")
let mmu = MMU(cart)
let ppu = PPU(mmu)
let cpu = CPU(mmu, ppu)
let clock = Clock(mmu, ppu, cpu)

clock.start()

PlaygroundPage.current.setLiveView(ppu.lcd)
















































































