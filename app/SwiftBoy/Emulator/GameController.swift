//
//  GameController.swift
//  SwiftBoy
//
//  Created by Boris Berak on 23/12/2021.
//  Copyright © 2021 Boris Berak. All rights reserved.
//

import Foundation
import SwiftUI

class Buttons: ObservableObject {
    @Published var up = false
    @Published var down = false
    @Published var left = false
    @Published var right = false
    @Published var a = false
    @Published var b = false
    @Published var start = false
    @Published var select = false
}

struct GameControllerView: View {
    @ObservedObject var buttons: Buttons
    
    var body: some View {
        VStack {
            Button("Up \(buttons.up ? "1" : "0")") {
                buttons.up.toggle()
            }
            Button("Down \(buttons.down ? "1" : "0")") {
                buttons.down.toggle()
            }
            Button("Left \(buttons.left ? "1" : "0")") {
                buttons.left.toggle()
            }
            Button("Right \(buttons.right ? "1" : "0")") {
                buttons.right.toggle()
            }
            Button("A \(buttons.a ? "1" : "0")") {
                buttons.a.toggle()
            }
            Button("B \(buttons.b ? "1" : "0")") {
                buttons.b.toggle()
            }
            Button("Start \(buttons.start ? "1" : "0")") {
                buttons.start.toggle()
            }
            Button("Select \(buttons.select ? "1" : "0")") {
                buttons.select.toggle()
            }
        }
    }
}

// var stat = mmu.lcdStatus.read()
// var flags = mmu.interruptFlags.read()
//
// defer {
//     mmu.lcdStatus.write(stat)
//     mmu.interruptFlags.write(flags)
// }
//
// stat[0] = mode[0]
// stat[1] = mode[1]
//
// if mode == 1 {
//     flags[Interrupts.vBlank.bit] = true
// }
//
// if stat.bit(3) && mode == 0 {
//     flags[Interrupts.lcdStat.bit] = true
// }
//
// if stat.bit(4) && mode == 1 {
//     flags[Interrupts.lcdStat.bit] = true
// }
//
// if stat.bit(5) && mode == 2 {
//     flags[Interrupts.lcdStat.bit] = true
// }

public class GameController {
    private let mmu: MMU
    private let buttons: Buttons
    
    let ui: UIHostingController<GameControllerView>
    
    init(_ mmu: MMU) {
        self.mmu = mmu
        self.buttons = Buttons()
        self.ui = UIHostingController(rootView: GameControllerView(buttons: self.buttons))
        
        // TODO:
        // Need integrate joypad interrupts
        self.mmu.joypad.subscribe { input in
            var result = input
            
            if !result[4] {
                result[0] = !self.buttons.right
                result[1] = !self.buttons.left
                result[2] = !self.buttons.up
                result[3] = !self.buttons.down
                
                if input > result {
                    var flags = self.mmu.interruptFlags.read()
                    flags[Interrupts.joypad.bit] = true
                    self.mmu.interruptFlags.write(flags)
                }
            } else if !result[5] {
                result[0] = !self.buttons.a
                result[1] = !self.buttons.b
                result[2] = !self.buttons.select
                result[3] = !self.buttons.start
                
                if input > result {
                    var flags = self.mmu.interruptFlags.read()
                    flags[Interrupts.joypad.bit] = true
                    self.mmu.interruptFlags.write(flags)
                }
            } else {
                result = 0xFF
            }
            
            self.mmu.joypad.write(result, publish: false)
        }
    }
}
