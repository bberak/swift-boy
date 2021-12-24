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

struct PressActions: ViewModifier {
    var onPress: () -> Void
    var onRelease: () -> Void
    
    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged({ _ in
                        onPress()
                    })
                    .onEnded({ _ in
                        onRelease()
                    })
            )
    }
}

struct GameButton: View {
    var label: String
    var onPress: () -> Void
    var onRelease: () -> Void
    
    var body: some View {
        Button(label) {
            // Unused press action
        }.modifier(PressActions(onPress: onPress, onRelease: onRelease))
    }
}

struct GameControllerView: View {
    @ObservedObject var buttons: Buttons
    
    var body: some View {
        VStack {
            GameButton(label: "Up", onPress: { buttons.up = true }, onRelease: { buttons.up = false })
            GameButton(label: "Down", onPress: { buttons.down = true }, onRelease: { buttons.down = false })
            GameButton(label: "Left", onPress: { buttons.left = true }, onRelease: { buttons.left = false })
            GameButton(label: "Right", onPress: { buttons.right = true }, onRelease: { buttons.right = false })
            GameButton(label: "A", onPress: { buttons.a = true }, onRelease: { buttons.a = false })
            GameButton(label: "B", onPress: { buttons.b = true }, onRelease: { buttons.b = false })
            GameButton(label: "Start", onPress: { buttons.start = true }, onRelease: { buttons.start = false })
            GameButton(label: "Select", onPress: { buttons.select = true }, onRelease: { buttons.select = false })
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
