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
        let controller = GameController(mmu)
        let clock = Clock(mmu, ppu, cpu, timer)
        
        clock.start()
        
        let stack = UIStackView();
        let lower = UIViewController()
        
        view.addSubview(stack)
        view.backgroundColor = .black
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = .systemPurple
        stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        stack.alignment = .fill
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.addArrangedSubview(ppu.lcd.view)
        stack.addArrangedSubview(lower.view)
        
        lower.view.translatesAutoresizingMaskIntoConstraints = false
        lower.view.backgroundColor = .blue
        lower.addChild(controller.ui)
        lower.view.addSubview(controller.ui.view)
        
        controller.ui.view.translatesAutoresizingMaskIntoConstraints = false
        controller.ui.view.topAnchor.constraint(equalTo: lower.view.topAnchor).isActive =  true
        controller.ui.view.leadingAnchor.constraint(equalTo: lower.view.leadingAnchor).isActive =  true
        controller.ui.view.trailingAnchor.constraint(equalTo: lower.view.trailingAnchor).isActive =  true
        controller.ui.view.bottomAnchor.constraint(equalTo: lower.view.bottomAnchor).isActive =  true
    }
}
