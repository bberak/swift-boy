import Foundation
import SwiftUI

class Touchable: ObservableObject {
    var onPress: () -> Void
    var onRelease: () -> Void
    var haptics: UIImpactFeedbackGenerator
    
    @Published var pressed = false
    
    init(onPress: @escaping () -> Void, onRelease: @escaping () -> Void, impact: UIImpactFeedbackGenerator.FeedbackStyle = .medium ) {
        self.onPress = onPress
        self.onRelease = onRelease
        self.haptics = UIImpactFeedbackGenerator(style: impact)
    }
    
    var gesture: some Gesture {
        DragGesture( minimumDistance: 0, coordinateSpace: .local)
            .onChanged { _ in
                if !self.pressed {
                    self.pressed = true
                    self.haptics.impactOccurred(intensity: 1.0);
                    self.onPress();
                }
            }
            .onEnded { _ in
                if self.pressed {
                    self.pressed = false
                    self.haptics.impactOccurred(intensity: 0.5);
                    self.onRelease();
                }
            }
    }
}



struct GameButtonView<S>: View where S : Shape {
    var shape: S
    var label: String?
    var width: CGFloat = 50
    var height: CGFloat = 50
    
    @StateObject var touchable: Touchable
    
    var body: some View {
        VStack {
            shape
                .fill(touchable.pressed ? .cyan : .white)
                .frame(width: width, height: height)
                .gesture(touchable.gesture)
                .scaleEffect(touchable.pressed ? 1.2 : 1)
                .animation(.spring().speed(4), value: touchable.pressed)
            
            if label != nil {
                Text(label!)
                    .font(.footnote)
                    .foregroundColor(.white)
            }
        }.rotation3DEffect(Angle(degrees: -30), axis: (x: 0, y: 0, z: 1))
    }
}

struct DPadView: View {
    @StateObject var buttons: Buttons
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                GameButtonView(shape: Circle(), touchable: Touchable(onPress: { buttons.up = true  }, onRelease: { buttons.up = false }))
                Spacer()
            }.offset(x: 0, y: 10)
            HStack {
                GameButtonView(shape: Circle(), touchable: Touchable(onPress: { buttons.left = true }, onRelease: { buttons.left = false }))
                Spacer()
                GameButtonView(shape: Circle(), touchable: Touchable(onPress: { buttons.right = true }, onRelease: { buttons.right = false }))
            }
            HStack {
                Spacer()
                GameButtonView(shape: Circle(), touchable: Touchable(onPress: { buttons.down = true }, onRelease: { buttons.down = false }))
                Spacer()
            }.offset(x: 0, y: -10)
        }.frame(width: 150)
    }
}

struct ABView: View {
    @StateObject var buttons: Buttons
    
    var body: some View {
        HStack {
            GameButtonView(shape: Circle(), label: "B", touchable: Touchable(onPress: { buttons.b = true }, onRelease: { buttons.b = false })).offset(x: 0, y: 30)
            GameButtonView(shape: Circle(), label: "A", touchable: Touchable(onPress: { buttons.a = true }, onRelease: { buttons.a = false }))
        }
    }
}

struct StartSelectView: View {
    @StateObject var buttons: Buttons
    
    var body: some View {
        HStack {
            GameButtonView(shape: RoundedRectangle(cornerRadius: 5), label: "START", width: 45, height: 10, touchable: Touchable(onPress: { buttons.start = true }, onRelease: { buttons.start = false })).padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
            GameButtonView(shape: RoundedRectangle(cornerRadius: 5), label: "SELECT", width: 45, height: 10, touchable: Touchable(onPress: { buttons.select = true }, onRelease: { buttons.select = false })).padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
        }
    }
}

struct TitleView: View {
    @State var title = ""
    @StateObject var touchable: Touchable
    
    var body: some View {
        let shearValue = CGFloat(-0.3)
        let shearTransform = CGAffineTransform(a: 1, b: 0, c: shearValue, d: 1, tx: 0, ty: 0)
        
        Text("\(title)  →")
            .font(.caption)
            .fontWeight(.bold)
            .foregroundColor(.black)
            .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
            .background(Rectangle()
                .fill(touchable.pressed ? .cyan : .white)
                .transformEffect(shearTransform))
            .gesture(touchable.gesture)
            .scaleEffect(touchable.pressed ? 1.2 : 1)
            .animation(.spring().speed(4), value: touchable.pressed)
    }
}

struct GameBoyView: View {
    var lcd: LCDBitmapView
    var dPad: DPadView
    var ab: ABView
    var startSelect: StartSelectView
    var titleView: TitleView
    
    var body: some View {
        GeometryReader{ geometry in
            if geometry.size.width > geometry.size.height {
                HStack {
                    dPad
                    VStack {
                        titleView
                        lcd
                    }
                    VStack {
                        Spacer()
                        ab
                        Spacer()
                        startSelect
                    }
                }
            } else {
                VStack{
                    titleView
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
