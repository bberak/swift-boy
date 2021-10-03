//
//  ViewController.swift
//  Swift Boy
//
//  Created by Boris Berak on 10/9/21.
//  Copyright © 2021 Boris Berak. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cpuTestXX = Cartridge(path: #fileLiteral(resourceName: "cpu_instrs.gb"))
        let cpuTest01 = Cartridge(path: #fileLiteral(resourceName: "01-special.gb"))
        let cpuTest02 = Cartridge(path: #fileLiteral(resourceName: "02-interrupts.gb"))
        let cpuTest03 = Cartridge(path: #fileLiteral(resourceName: "03-op sp,hl.gb"))
        let cpuTest04 = Cartridge(path: #fileLiteral(resourceName: "04-op r,imm.gb"))
        let cpuTest05 = Cartridge(path: #fileLiteral(resourceName: "05-op rp.gb"))
        let cpuTest06 = Cartridge(path: #fileLiteral(resourceName: "06-ld r,r.gb"))
        let cpuTest07 = Cartridge(path: #fileLiteral(resourceName: "07-jr,jp,call,ret,rst.gb"))
        let cpuTest08 = Cartridge(path: #fileLiteral(resourceName: "08-misc instrs.gb"))
        let cpuTest09 = Cartridge(path: #fileLiteral(resourceName: "09-op r,r.gb"))
        let cpuTest10 = Cartridge(path: #fileLiteral(resourceName: "10-bit ops.gb"))
        let cpuTest11 = Cartridge(path: #fileLiteral(resourceName: "11-op a,(hl).gb"))
        let tetris = Cartridge(path: #fileLiteral(resourceName: "tetris.gb"))
        
        let mmu = MMU(cpuTest11)
        let ppu = PPU(mmu)
        let cpu = CPU(mmu, ppu)
        let timer = Timer(mmu)
        let clock = Clock(mmu, ppu, cpu, timer)

        clock.start()
        
        view.addSubview(ppu.lcd.view)
    }
}

