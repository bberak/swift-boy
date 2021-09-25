//
//  ViewController.swift
//  Swift Boy
//
//  Created by Boris Berak on 10/9/21.
//  Copyright © 2021 Boris Berak. All rights reserved.
//

import UIKit

func testSUB(_ a: UInt8, _ b: UInt8, _ expected: String) {
    let result = sub(a, b);
    let resultString = "A←\(result.value.toHexString())h,Z←\(result.zero ? 1 : 0),H←\(result.halfCarry ? 1 : 0),N←\(result.subtract ? 1 : 0),CY←\(result.carry ? 1 : 0)"
    let passed = expected == resultString
    
    print("sub \(a.toHexString()),\(b.toHexString()): \(passed ? "passed" : "expected \(expected), got \(resultString)")")
}

func testSBC(_ a: UInt8, _ b: UInt8, _ carry: Bool, _ expected: String) {
    let result = sub(a, b, carry: carry)
    let resultString = "A←\(result.value.toHexString())h,Z←\(result.zero ? 1 : 0),H←\(result.halfCarry ? 1 : 0),N←\(result.subtract ? 1 : 0),CY←\(result.carry ? 1 : 0)"
    let passed = expected == resultString
    
    print("sbc \(a.toHexString()),\(b.toHexString()): \(passed ? "passed" : "expected \(expected), got \(resultString)")")
}

func testCP(_ a: UInt8, _ b: UInt8, _ expected: String) {
    let result = sub(a, b);
    let resultString = "Z←\(result.zero ? 1 : 0),H←\(result.halfCarry ? 1 : 0),N←\(result.subtract ? 1 : 0),CY←\(result.carry ? 1 : 0)"
    let passed = expected == resultString
    
    print("cp \(a.toHexString()),\(b.toHexString()): \(passed ? "passed" : "expected \(expected), got \(resultString)")")
}

func testADD(_ a: UInt8, _ b: UInt8, _ expected: String) {
    let result = add(a, b, carry: false);
    let resultString = "A←\(result.value.toHexString())h,Z←\(result.zero ? 1 : 0),H←\(result.halfCarry ? 1 : 0),N←\(result.subtract ? 1 : 0),CY←\(result.carry ? 1 : 0)"
    let passed = expected == resultString
    
    print("add \(a.toHexString()),\(b.toHexString()): \(passed ? "passed" : "expected \(expected), got \(resultString)")")
}

func testADC(_ a: UInt8, _ b: UInt8, _ carry: Bool, _ expected: String) {
    let result = add(a, b, carry: carry)
    let resultString = "A←\(result.value.toHexString())h,Z←\(result.zero ? 1 : 0),H←\(result.halfCarry ? 1 : 0),N←\(result.subtract ? 1 : 0),CY←\(result.carry ? 1 : 0)"
    let passed = expected == resultString
    
    print("adc \(a.toHexString()),\(b.toHexString()): \(passed ? "passed" : "expected \(expected), got \(resultString)")")
}

func testADD_SP(_ sp: UInt16, _ offset: Int8, _ expected: String) {
    let value = sp.offset(by: offset)
    let zero = false
    let subtract = false
    let halfCarry = checkCarry(sp, UInt16(offset.toUInt8()), carryBit: 3)
    let carry = checkCarry(sp, UInt16(offset.toUInt8()), carryBit: 7)
    let resultString = "SP←\(value.toHexString())h,Z←\(zero ? 1 : 0),H←\(halfCarry ? 1 : 0),N←\(subtract ? 1 : 0),CY←\(carry ? 1 : 0)"
    let passed = expected == resultString

    print("add sp \(sp.toHexString()),\(offset.toUInt8().toHexString()): \(passed ? "passed" : "expected \(expected), got \(resultString)")")
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
                
        testSUB(0x3E, 0x3E, "A←00h,Z←1,H←0,N←1,CY←0")
        testSUB(0x3E, 0x0F, "A←2Fh,Z←0,H←1,N←1,CY←0")
        testSUB(0x3E, 0x40, "A←FEh,Z←0,H←0,N←1,CY←1")
        print("")
        
        testSBC(0x3B, 0x2A, true, "A←10h,Z←0,H←0,N←1,CY←0")
        testSBC(0x3B, 0x3A, true, "A←00h,Z←1,H←0,N←1,CY←0")
        testSBC(0x3B, 0x4F, true, "A←EBh,Z←0,H←1,N←1,CY←1")
        print("")
        
        testCP(0x3C, 0x2F, "Z←0,H←1,N←1,CY←0")
        testCP(0x3C, 0x3C, "Z←1,H←0,N←1,CY←0")
        testCP(0x3C, 0x40, "Z←0,H←0,N←1,CY←1")
        print("")

        testADD(0x3A, 0xC6, "A←00h,Z←1,H←1,N←0,CY←1")
        testADD(0x3C, 0xFF, "A←3Bh,Z←0,H←1,N←0,CY←1")
        testADD(0x3C, 0x12, "A←4Eh,Z←0,H←0,N←0,CY←0")
        print("")
        
        testADC(0xE1, 0x0F, true, "A←F1h,Z←0,H←1,N←0,CY←0")
        testADC(0xE1, 0x3B, true, "A←1Dh,Z←0,H←0,N←0,CY←1")
        testADC(0xE1, 0x1E, true, "A←00h,Z←1,H←1,N←0,CY←1")
        print("")
        
        testADD_SP(0xFFF8, 2, "SP←FFFAh,Z←0,H←0,N←0,CY←0")
        testADD_SP(0xFFF8, -2, "SP←FFF6h,Z←0,H←0,N←0,CY←0")
        testADD_SP(0xFFF8, 0, "SP←FFF8h,Z←0,H←0,N←0,CY←0")
        print("")
        
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
        
        let mmu = MMU(cpuTest03)
        let ppu = PPU(mmu)
        let cpu = CPU(mmu, ppu)
        let clock = Clock(mmu, ppu, cpu)

        clock.start()
        
        view.addSubview(ppu.lcd.view)
    }
}

