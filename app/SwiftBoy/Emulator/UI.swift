import Foundation
import SwiftUI

struct PressableView<C: View> : View {
    @State private var pressed = false
    
    private let getChildView: (Bool) -> C
    private var haptics: UIImpactFeedbackGenerator  = UIImpactFeedbackGenerator(style: .medium)
    private var onPressedCallback: (() -> Void)?
    private var onReleasedCallback: (() -> Void)?
    
    init (_ getChildView: @escaping (Bool) -> C) {
        self.getChildView = getChildView
    }
    
    var body: some View {
        self.getChildView(self.pressed)
            .gesture(DragGesture( minimumDistance: 0, coordinateSpace: .local)
            .onChanged { _ in
                if !self.pressed {
                    self.pressed = true
                    self.haptics.impactOccurred(intensity: 1.0);
                    if let cb = self.onPressedCallback {
                        cb()
                    }
                }
            }
            .onEnded { _ in
                if self.pressed {
                    self.pressed = false
                    self.haptics.impactOccurred(intensity: 0.5);
                    if let cb = self.onReleasedCallback {
                        cb()
                    }
                }
            })
    }
    
    func impact(_ strength: UIImpactFeedbackGenerator.FeedbackStyle) -> Self {
        var next = self;
        next.haptics = UIImpactFeedbackGenerator(style: strength);
        
        return next;
    }
    
    func onPressed(_ onPressedCallback: @escaping () -> Void) -> Self {
        var next = self
        next.onPressedCallback = onPressedCallback
        
        return next;
    }
    
    func onReleased(_ onReleasedCallback: @escaping () -> Void) -> Self {
        var next = self
        next.onReleasedCallback = onReleasedCallback
        
        return next;
    }
}

struct GameButtonView<S>: View where S : Shape {
    var shape: S
    var label: String?
    var width: CGFloat = 50
    var height: CGFloat = 50
    var onPressed: () -> Void
    var onReleased: () -> Void
    
    var body: some View {
        VStack {
            PressableView { pressed in
                shape
                    .fill(pressed ? .cyan : .white)
                    .frame(width: width, height: height)
                    .scaleEffect(pressed ? 1.2 : 1)
                    .animation(.spring().speed(4), value: pressed)
            }
            .onPressed(onPressed)
            .onReleased(onReleased)
            
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
                GameButtonView(shape: Circle(), onPressed: { buttons.up = true  }, onReleased: { buttons.up = false })
                Spacer()
            }.offset(x: 0, y: 10)
            HStack {
                GameButtonView(shape: Circle(), onPressed: { buttons.left = true }, onReleased: { buttons.left = false })
                Spacer()
                GameButtonView(shape: Circle(), onPressed: { buttons.right = true }, onReleased: { buttons.right = false })
            }
            HStack {
                Spacer()
                GameButtonView(shape: Circle(), onPressed: { buttons.down = true }, onReleased: { buttons.down = false })
                Spacer()
            }.offset(x: 0, y: -10)
        }.frame(width: 150)
    }
}

struct ABView: View {
    @StateObject var buttons: Buttons
    
    var body: some View {
        HStack {
            GameButtonView(shape: Circle(), label: "B", onPressed: { buttons.b = true }, onReleased: { buttons.b = false }).offset(x: 0, y: 30)
            GameButtonView(shape: Circle(), label: "A", onPressed: { buttons.a = true }, onReleased: { buttons.a = false })
        }
    }
}

struct StartSelectView: View {
    @StateObject var buttons: Buttons
    
    var body: some View {
        HStack {
            GameButtonView(shape: RoundedRectangle(cornerRadius: 5), label: "START", width: 45, height: 10, onPressed: { buttons.start = true }, onReleased: { buttons.start = false }).padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
            GameButtonView(shape: RoundedRectangle(cornerRadius: 5), label: "SELECT", width: 45, height: 10, onPressed: { buttons.select = true }, onReleased: { buttons.select = false }).padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
        }
    }
}

struct TitleView: View {
    @State var title: String
    var onPressed: () -> Void
    
    var body: some View {
        let shearValue = CGFloat(-0.3)
        let shearTransform = CGAffineTransform(a: 1, b: 0, c: shearValue, d: 1, tx: 0, ty: 0)
        
        PressableView { pressed in
            Text("\(title)  →")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
                .background(Rectangle()
                    .fill(pressed ? .cyan : .white)
                    .transformEffect(shearTransform))
                .scaleEffect(pressed ? 1.2 : 1)
                .animation(.spring().speed(4), value: pressed)
        }.onPressed(onPressed)
    }
}

struct GameBoyView: View {
    var lcd: LCDBitmapView
    @State var title: String
    @State var showGames: Bool = false
    @EnvironmentObject var buttons: Buttons
    
    var body: some View {
        GeometryReader{ geometry in
            if geometry.size.width > geometry.size.height {
                HStack {
                    DPadView(buttons: buttons)
                    VStack {
                        TitleView(title: title) {
                            showGames = true
                        }
                        lcd
                    }
                    VStack {
                        Spacer()
                        ABView(buttons: buttons)
                        Spacer()
                        StartSelectView(buttons: buttons)
                    }
                }
            } else {
                VStack{
                    TitleView(title: title) {
                        showGames = true
                    }
                    lcd.frame(height: geometry.size.height * 0.5)
                    VStack{
                        HStack {
                            DPadView(buttons: buttons)
                            Spacer()
                            ABView(buttons: buttons)
                        }
                        StartSelectView(buttons: buttons).offset(x: 0, y: 30)
                    }
                    .padding()
                    .frame(height: geometry.size.height * 0.5)
                }
            }
        }
        .background(.black)
    }
}
