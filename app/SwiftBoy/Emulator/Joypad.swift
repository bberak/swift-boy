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

public class Joypad {
    private let mmu: MMU
    private let buttons: Buttons
    
    let dPad: DPadView
    let ab: ABView
    let startSelect: StartSelectView
    
    init(_ mmu: MMU) {
        self.mmu = mmu
        self.buttons = Buttons()
        self.dPad = DPadView(buttons: self.buttons)
        self.ab = ABView(buttons: self.buttons)
        self.startSelect = StartSelectView(buttons: self.buttons)
        
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
