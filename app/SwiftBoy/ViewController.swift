import UIKit
import SwiftUI

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mmu = MMU()
        let ppu = PPU(mmu)
        let cpu = CPU(mmu)
        let apu = APU(mmu)
        let timer = Timer(mmu)
        let joypad = Joypad(mmu)
        let clock = Clock(mmu, ppu, cpu, apu, timer)
        let glm = GameLibraryManager(clock)
        
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


