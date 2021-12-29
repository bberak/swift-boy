import UIKit
import SwiftUI

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // let cpuTestAll = Cartridge(path: #fileLiteral(resourceName: "cpu_instrs.gb"))
        // let cpuTest01 = Cartridge(path: #fileLiteral(resourceName: "01-special.gb"))
        // let cpuTest02 = Cartridge(path: #fileLiteral(resourceName: "02-interrupts.gb"))
        // let cpuTest03 = Cartridge(path: #fileLiteral(resourceName: "03-op sp,hl.gb"))
        // let cpuTest04 = Cartridge(path: #fileLiteral(resourceName: "04-op r,imm.gb"))
        // let cpuTest05 = Cartridge(path: #fileLiteral(resourceName: "05-op rp.gb"))
        // let cpuTest06 = Cartridge(path: #fileLiteral(resourceName: "06-ld r,r.gb"))
        // let cpuTest07 = Cartridge(path: #fileLiteral(resourceName: "07-jr,jp,call,ret,rst.gb"))
        // let cpuTest08 = Cartridge(path: #fileLiteral(resourceName: "08-misc instrs.gb"))
        // let cpuTest09 = Cartridge(path: #fileLiteral(resourceName: "09-op r,r.gb"))
        // let cpuTest10 = Cartridge(path: #fileLiteral(resourceName: "10-bit ops.gb"))
        // let cpuTest11 = Cartridge(path: #fileLiteral(resourceName: "11-op a,(hl).gb"))
        let tetris = Cartridge(path: #fileLiteral(resourceName: "tetris.gb"))
        
        let mmu = MMU(tetris)
        let ppu = PPU(mmu)
        let cpu = CPU(mmu, ppu)
        let timer = Timer(mmu)
        let joypad = Joypad(mmu)
        let clock = Clock(mmu, ppu, cpu, timer)
        
        clock.start()
        
        let ui = UIHostingController(rootView: UI(lcd: ppu.view, dPad: joypad.dPad, ab: joypad.ab, startSelect: joypad.startSelect))
        
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

struct UI: View {
    var lcd: LCDBitmapView
    var dPad: DPadView
    var ab: ABView
    var startSelect: StartSelectView
    
    var body: some View {
        GeometryReader{ geometry in
            if geometry.size.width > geometry.size.height {
                HStack {
                    dPad
                    VStack {
                        lcd
                        startSelect.padding()
                    }
                    ab
                }
            } else {
                VStack{
                    lcd.frame(height: geometry.size.height * 0.5)
                    VStack{
                        HStack {
                            dPad
                            Spacer()
                            ab
                        }
                        startSelect.offset(x: 0, y: 30)
                    }
                    .padding()
                    .frame(height: geometry.size.height * 0.5)
                }
            }
        }
        .background(.black)
    }
}
