import UIKit
import SwiftUI

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let roms = FileSystem.listAbsolutePaths(inDirectory: Bundle.main.bundlePath, suffix: "tetris.gb")
        let carts = roms.map { Cartridge(path: URL(string: $0)!) }
                
        // let cart = Cartridge(path: #fileLiteral(resourceName: "cpu_instrs.gb"))
        // let cart = Cartridge(path: #fileLiteral(resourceName: "instr_timing.gb"))
        // let cart = Cartridge(path: #fileLiteral(resourceName: "interrupt_time.gb"))
        // let cart = Cartridge(path: #fileLiteral(resourceName: "mem_timing.gb"))
        // let cart = Cartridge(path: #fileLiteral(resourceName: "mem_timing-2.gb"))
        // let cart = Cartridge(path: #fileLiteral(resourceName: "dmg_sound.gb"))
        // let cart = Cartridge(path: #fileLiteral(resourceName: "01-special.gb"))
        // let cart = Cartridge(path: #fileLiteral(resourceName: "02-interrupts.gb"))
        // let cart = Cartridge(path: #fileLiteral(resourceName: "03-op sp,hl.gb"))
        // let cart = Cartridge(path: #fileLiteral(resourceName: "04-op r,imm.gb"))
        // let cart = Cartridge(path: #fileLiteral(resourceName: "05-op rp.gb"))
        // let cart = Cartridge(path: #fileLiteral(resourceName: "06-ld r,r.gb"))
        // let cart = Cartridge(path: #fileLiteral(resourceName: "07-jr,jp,call,ret,rst.gb"))
        // let cart = Cartridge(path: #fileLiteral(resourceName: "08-misc instrs.gb"))
        // let cart = Cartridge(path: #fileLiteral(resourceName: "09-op r,r.gb"))
        // let cart = Cartridge(path: #fileLiteral(resourceName: "10-bit ops.gb"))
        // let cart = Cartridge(path: #fileLiteral(resourceName: "11-op a,(hl).gb"))
        // let cart = Cartridge(path: #fileLiteral(resourceName: "deadeus.gb"))
        // let cart = Cartridge(path: #fileLiteral(resourceName: "super-mario-land.gb"))
        // let cart = Cartridge(path: #fileLiteral(resourceName: "tetris.gb"))
        
        let mmu = MMU()
        let ppu = PPU(mmu)
        let cpu = CPU(mmu)
        let apu = APU(mmu)
        let timer = Timer(mmu)
        let joypad = Joypad(mmu)
        let glm = GameLibraryManager(carts, mmu, ppu, cpu, timer)
        let clock = Clock(mmu, ppu, cpu, apu, timer)
        
        glm.insertCartridge()
        clock.start()
        
        let ui = UIHostingController(rootView: GameBoyView(lcd: ppu.view).environmentObject(joypad.buttons).environmentObject(glm))
        
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ui.view)
        
        ui.view.translatesAutoresizingMaskIntoConstraints = false
        ui.view.topAnchor.constraint(equalTo: view.topAnchor).isActive =  true
        ui.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive =  true
        ui.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive =  true
        ui.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive =  true
    }
}


