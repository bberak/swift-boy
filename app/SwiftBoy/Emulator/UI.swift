import Foundation
import SwiftUI

struct PressableView<C: View> : View {
    @Binding var pressedBinding: Bool
    @State var pressed = false {
        didSet {
            pressedBinding = pressed
            haptics.impactOccurred(intensity: 0.5);
            if let cb = pressed ? onPressedCallback : onReleasedCallback {
                cb()
            }
        }
    }
    
    private let getChildView: (Bool) -> C
    private var haptics: UIImpactFeedbackGenerator  = UIImpactFeedbackGenerator(style: .medium)
    private var onPressedCallback: (() -> Void)?
    private var onReleasedCallback: (() -> Void)?
    
    var body: some View {
        getChildView(pressed)
            .gesture(dragGesture)
    }
    
    private var dragGesture: some Gesture {
        DragGesture( minimumDistance: 0, coordinateSpace: .local)
            .onChanged { _ in
                if !pressed {
                    pressed = true
                }
            }
            .onEnded { _ in
                if pressed {
                    pressed = false
                }
            }
    }
}

extension PressableView {
    init (_ getChildView: @escaping (Bool) -> C) {
        self._pressedBinding = Binding.constant(false)
        self.getChildView = getChildView
    }
    
    init (_ pressed: Binding<Bool>, _ getChildView: @escaping (Bool) -> C) {
        self._pressedBinding = pressed
        self.getChildView = getChildView
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

struct DraggableView<C: View> : View {
    @State private var prevDragTranslation = CGSize.zero
    @Binding var dragOffsetBinding: CGFloat
    @State var dragOffset = CGFloat(0) {
        didSet {
            dragOffsetBinding = dragOffset
            if let cb = onDraggedCallback {
                cb(dragOffset)
            }
        }
    }
    @Binding var draggingBinding: Bool
    @State var dragging = false
    
    private let getChildView: (CGFloat, Bool) -> C
    private var onDraggedCallback: ((CGFloat) -> Void)?
    private var onReleasedCallback: ((CGFloat) -> Void)?
    
    var body: some View {
        getChildView(dragOffset, dragging)
            .gesture(dragGesture)
    }
    
    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged { val in
                let dragAmount = val.translation.height - prevDragTranslation.height
                dragOffset += dragAmount
                prevDragTranslation = val.translation
                if !dragging {
                    dragging = true
                }
            }
            .onEnded { val in
                prevDragTranslation = .zero
                if let cb = onReleasedCallback {
                    cb(dragOffset)
                }
                dragOffset = 0
                if dragging {
                    dragging = false
                }
            }
    }
}

extension DraggableView {
    init (_ dragOffsetBinding: Binding<CGFloat>, _ draggingBinding: Binding<Bool>, _ getChildView: @escaping (CGFloat, Bool) -> C) {
        self._dragOffsetBinding = dragOffsetBinding
        self._draggingBinding = draggingBinding
        self.getChildView = getChildView
    }
    
    init (_ dragOffsetBinding: Binding<CGFloat>,  _ getChildView: @escaping (CGFloat, Bool) -> C) {
        self.init(dragOffsetBinding, Binding.constant(false), getChildView)
    }
    
    init (_ getChildView: @escaping (CGFloat, Bool) -> C) {
        self.init(Binding.constant(CGFloat(0)), getChildView)
    }
    
    func onDragged(_ onDraggedCallback: @escaping (CGFloat) -> Void) -> Self {
        var next = self
        next.onDraggedCallback = onDraggedCallback
        
        return next;
    }
    
    func onReleased(_ onReleasedCallback: @escaping (CGFloat) -> Void) -> Self {
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
        PressableView { pressed in
            Text("\(title)  →")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(pressed ? .cyan : .white)
                .padding(.vertical, 5)
                .scaleEffect(pressed ? 1.2 : 1)
                .animation(.spring().speed(4), value: pressed)
        }.onPressed(onPressed)
    }
}

struct GameLibraryModalView: View {
    @Binding var visible: Bool
    @State var paddingTop: CGFloat = 140
    @State var maxDragOffset: CGFloat = 300
    @State var dragOffset: CGFloat = 0
    @EnvironmentObject var gameState: GameState
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if visible {
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        visible = false
                    }
                
                listView
                    .transition(.move(edge: .bottom))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .animation(.easeInOut, value: visible)
    }
    
    var listView: some View {
        VStack {
            VStack {
                DraggableView($dragOffset) { _, isDragging in
                    ZStack {
                        Capsule()
                            .frame(width: 40, height: 6)
                            .foregroundColor(isDragging ? .cyan : .black)
                    }
                    .frame(height: 40)
                    .frame(maxWidth: .infinity)
                    .background(Color.white.opacity(0.00001))
                }.onReleased { _ in
                    if dragOffset > maxDragOffset {
                        visible = false
                    }
                }
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20) {
                        ForEach(gameState.gameLibrary.sorted(by: { x, y in x.title < y.title })) { game in
                            VStack {
                                Text(game.title.isNotEmpty ? game.title : "Untitled")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .textCase(.uppercase)
                                    .foregroundColor(gameState.currentlyPlaying === game ? .cyan : .black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Text(game.type == .unsupported ? "Not Supported ❌" : "Supported")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .textCase(.uppercase)
                                    .foregroundColor(.black.opacity(0.4))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    
                            }
                            .padding([.leading, .trailing])
                        }
                    }
                }
                .frame(maxHeight: .infinity)
            }
            .frame(maxHeight: .infinity)
            .frame(maxWidth: .infinity)
            .background(.white)
        }
        .padding(.top, paddingTop + dragOffset.clamp(min: 0, max: .infinity))
    }
}

struct GameBoyView: View {
    var lcd: LCDBitmapView
    @State var showGames: Bool = false
    @EnvironmentObject var buttons: Buttons
    @EnvironmentObject var gameState: GameState
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                if geometry.size.width > geometry.size.height {
                    HStack {
                        DPadView(buttons: buttons)
                        VStack {
                            TitleView(title: gameState.currentlyPlaying.title) {
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
                    GameLibraryModalView(visible: $showGames, paddingTop: 80, maxDragOffset: geometry.size.height - 80 * 2)
                } else {
                    VStack{
                        TitleView(title: gameState.currentlyPlaying.title) {
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
                    GameLibraryModalView(visible: $showGames)
                }
            }
            .background(.black)
            
        }
        .frame(width: .infinity, height: .infinity)
    }
}
