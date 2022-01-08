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

struct GameButton<S>: View where S : Shape {
    var shape: S
    var width: CGFloat = 50
    var height: CGFloat = 50
    var label: String?
    var onPress: () -> Void
    var onRelease: () -> Void
    var haptics = UIImpactFeedbackGenerator(style: .medium)
    
    @State var pressed = false
    
    var pressInOut: some Gesture {
        DragGesture( minimumDistance: 0, coordinateSpace: .local)
            .onChanged { _ in
                if !pressed {
                    pressed = true
                    onPress();
                    haptics.impactOccurred(intensity: 1.0);
                }
            }
            .onEnded { _ in
                if pressed {
                    pressed = false
                    onRelease();
                    haptics.impactOccurred(intensity: 0.5);
                }
            }
    }
    
    var body: some View {
        VStack {
            shape
                .fill(pressed ? .cyan : .white)
                .frame(width: width, height: height)
                .gesture(pressInOut)
                .scaleEffect(pressed ? 1.2 : 1)
                .animation(.spring().speed(4), value: pressed)
            
            if label != nil {
                Text(label!)
                    .font(.footnote)
                    .foregroundColor(.white)
            }
        }.rotation3DEffect(Angle(degrees: -30), axis: (x: 0, y: 0, z: 1))
    }
}

struct DPadView: View {
    @ObservedObject var buttons: Buttons
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                GameButton(shape: Circle(), onPress: { buttons.up = true }, onRelease: { buttons.up = false })
                Spacer()
            }.offset(x: 0, y: 10)
            HStack {
                GameButton(shape: Circle(), onPress: { buttons.left = true }, onRelease: { buttons.left = false })
                Spacer()
                GameButton(shape: Circle(), onPress: { buttons.right = true }, onRelease: { buttons.right = false })
            }
            HStack {
                Spacer()
                GameButton(shape: Circle(), onPress: { buttons.down = true }, onRelease: { buttons.down = false })
                Spacer()
            }.offset(x: 0, y: -10)
        }.frame(width: 150)
    }
}

struct ABView: View {
    @ObservedObject var buttons: Buttons
    
    var body: some View {
        HStack {
            GameButton(shape: Circle(), label: "B", onPress: { buttons.b = true }, onRelease: { buttons.b = false }).offset(x: 0, y: 30)
            GameButton(shape: Circle(), label: "A", onPress: { buttons.a = true }, onRelease: { buttons.a = false })
        }
    }
}

struct StartSelectView: View {
    @ObservedObject var buttons: Buttons
    
    var body: some View {
        HStack {
            GameButton(shape: RoundedRectangle(cornerRadius: 5), width: 45, height: 10, label: "START", onPress: { buttons.start = true }, onRelease: { buttons.start = false }).padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
            GameButton(shape: RoundedRectangle(cornerRadius: 5), width: 45, height: 10, label: "SELECT", onPress: { buttons.select = true }, onRelease: { buttons.select = false }).padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
        }
    }
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
