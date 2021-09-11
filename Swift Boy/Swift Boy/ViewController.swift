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

        let blargg = Cartridge(path: #fileLiteral(resourceName: "cpu_instrs.gb"))
        let bitOps = Cartridge(path: #fileLiteral(resourceName: "10-bit ops.gb"))
        let sphl = Cartridge(path: #fileLiteral(resourceName: "03-op sp,hl.gb"))
        let tetris = Cartridge(path: #fileLiteral(resourceName: "tetris.gb"))
        
        let mmu = MMU(sphl)
        let ppu = PPU(mmu)
        let cpu = CPU(mmu, ppu)
        let clock = Clock(mmu, ppu, cpu)

        //clock.printFrameDuration = true
        clock.start()
        
        view.addSubview(ppu.lcd.view)
    }
}

