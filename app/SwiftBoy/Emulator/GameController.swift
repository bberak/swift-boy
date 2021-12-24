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
        self.mmu.joypad.subscribe { byte in
    
            var input = byte
            
            if !input[4] {
                input[0] = !self.buttons.right
                input[1] = !self.buttons.left
                input[2] = !self.buttons.up
                input[3] = !self.buttons.down
            } else if !input[5] {
                input[0] = !self.buttons.a
                input[1] = !self.buttons.b
                input[2] = !self.buttons.select
                input[3] = !self.buttons.start
            } else {
                input = 0xFF
            }
            
            self.mmu.joypad.write(input, publish: false)
        }
    }
}
