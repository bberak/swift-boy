import Foundation
import SwiftUI
import UniformTypeIdentifiers

// Source: https://github.com/markrenaud/FilePicker/blob/main/Sources/FilePicker/FilePickerUIRepresentable.swift
public struct FilePickerUIRepresentable: UIViewControllerRepresentable {
    public typealias UIViewControllerType = UIDocumentPickerViewController
    public typealias PickedURLsCompletionHandler = (_ urls: [URL]) -> Void
    
    @Environment(\.dismiss) var dismiss
    
    public let types: [UTType]
    public let allowMultiple: Bool
    public let pickedCompletionHandler: PickedURLsCompletionHandler
    
    public init(types: [UTType], allowMultiple: Bool, onPicked completionHandler: @escaping PickedURLsCompletionHandler) {
        self.types = types
        self.allowMultiple = allowMultiple
        self.pickedCompletionHandler = completionHandler
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    public func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: types, asCopy: true)
        picker.delegate = context.coordinator
        picker.allowsMultipleSelection = allowMultiple
        return picker
    }
    
    public func updateUIViewController(_ controller: UIDocumentPickerViewController, context: Context) {}
    
    public class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: FilePickerUIRepresentable
        
        init(parent: FilePickerUIRepresentable) {
            self.parent = parent
        }
        
        public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            parent.pickedCompletionHandler(urls)
            parent.dismiss()
        }
    }
}

struct PressableView<C: View> : View {
    @Binding var pressedBinding: Bool
    @State private var pressed = false {
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
    @Binding var dragOffsetBinding: CGFloat
    @Binding var draggingBinding: Bool
    
    @State private var dragging = false
    @State private var prevDragTranslation = CGSize.zero
    @State private var dragOffset = CGFloat(0) {
        didSet {
            dragOffsetBinding = dragOffset
            if let cb = onDraggedCallback {
                cb(dragOffset)
            }
        }
    }
    
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
                    .fill(.white)
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
        }
        .rotation3DEffect(Angle(degrees: -30), axis: (x: 0, y: 0, z: 1))
    }
}

struct DPadView: View {
    @EnvironmentObject private var buttons: Buttons
    
    var body: some View {
        VStack {
            GameButtonView(shape: Circle(), onPressed: { buttons.up = true  }, onReleased: { buttons.up = false })
                .offset(x: 0, y: 10)
            HStack(spacing: 40) {
                GameButtonView(shape: Circle(), onPressed: { buttons.left = true }, onReleased: { buttons.left = false })
                GameButtonView(shape: Circle(), onPressed: { buttons.right = true }, onReleased: { buttons.right = false })
            }
            GameButtonView(shape: Circle(), onPressed: { buttons.down = true }, onReleased: { buttons.down = false })
                .offset(x: 0, y: -10)
        }
    }
}

struct ABView: View {
    @EnvironmentObject private var buttons: Buttons
    
    var body: some View {
        HStack {
            GameButtonView(shape: Circle(), label: "B", onPressed: { buttons.b = true }, onReleased: { buttons.b = false })
                .offset(x: 0, y: 30)
            GameButtonView(shape: Circle(), label: "A", onPressed: { buttons.a = true }, onReleased: { buttons.a = false })
        }
    }
}

struct StartSelectView: View {
    @EnvironmentObject private var buttons: Buttons
    
    var body: some View {
        HStack {
            GameButtonView(
                shape: RoundedRectangle(cornerRadius: 5),
                label: "START",
                width: 45,
                height: 10,
                onPressed: { buttons.start = true },
                onReleased: { buttons.start = false }
            )
            .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
            GameButtonView(
                shape: RoundedRectangle(cornerRadius: 5),
                label: "SELECT",
                width: 45,
                height: 10,
                onPressed: { buttons.select = true },
                onReleased: { buttons.select = false }
            )
            .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
        }
    }
}

struct TitleView: View {
    var title: String
    var onReleased: () -> Void
    
    var body: some View {
        PressableView { pressed in
            Text(title)
                .fontWeight(.bold)
                .textCase(.uppercase)
                .foregroundColor(pressed ? .black : .white)
                .padding(.vertical, 5)
                .background(Rectangle().fill(pressed ? .white : .white.opacity(0)))
        }
        .onReleased(onReleased)
    }
}

struct GameLibraryItemView: View {
    var game: Cartridge
    @State private var confirmDelete = false
    @EnvironmentObject private var gameLibraryManager: GameLibraryManager
    @Environment(\.dismiss) private var dismissLibraryView
    
    private func delay(numSeconds: Double, cb: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + numSeconds) {
            cb()
        }
    }
    
    func shouldHighlight(_ pressed: Bool) -> Bool {
        return gameLibraryManager.inserted === game || pressed
    }
    
    var body: some View {
        HStack (alignment: .top) {
            VStack {
                PressableView { pressed in
                    Text(game.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .textCase(.uppercase)
                        .lineLimit(1)
                        .foregroundColor(shouldHighlight(pressed) ? .white : .black)
                        .background(Rectangle().fill(shouldHighlight(pressed) ? .black : .black.opacity(0)))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.trailing, 20)
                }
                .onReleased {
                    gameLibraryManager.insertCartridge(game)
                    dismissLibraryView()
                }
                Text(game.type == .unsupported ? "Not Supported ❌" : "Supported")
                    .font(.caption)
                    .fontWeight(.bold)
                    .textCase(.uppercase)
                    .foregroundColor(.black.opacity(0.4))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            Button(role: .none, action: {
                if confirmDelete {
                    gameLibraryManager.deleteCartridge(game)
                } else {
                    confirmDelete = true
                    delay(numSeconds: 5) {
                        confirmDelete = false
                    }
                }
            }) {
                Label(confirmDelete ? "Confirm" : "", systemImage: "trash")
                    .foregroundColor(confirmDelete ? .red : .black.opacity(0.4))
            }
            .padding(.top, 5)
            .animation(.easeInOut, value: confirmDelete)
        }
        .padding([.leading, .trailing])
    }
}

struct GameLibraryModalView: View {
    var landscape = false
    @State private var showFilePicker = false
    @EnvironmentObject private var gameLibraryManager: GameLibraryManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 20) {
                    ForEach(gameLibraryManager.library) { game in
                        GameLibraryItemView(game: game)
                    }
                }
            }
            .padding(.top, 20)
            .frame(maxHeight: .infinity)
            .animation(.easeInOut, value: gameLibraryManager.library.count)
            
            HStack (spacing: 10) {
                PressableView { pressed in
                    Text("Import Game")
                        .fontWeight(.bold)
                        .textCase(.uppercase)
                        .foregroundColor(pressed ? .black : .white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .background(
                            pressed ?
                            AnyView(RoundedRectangle(cornerRadius: 10).stroke(.black, lineWidth: 4)) :
                            AnyView(RoundedRectangle(cornerRadius: 10).fill(.black))
                        )
                }
                .onReleased {
                    showFilePicker = true
                }
                .sheet(isPresented: $showFilePicker) {
                    FilePickerUIRepresentable(types: [UTType("com.swiftboy.gameboyfile")!], allowMultiple: true) { urls in
                        gameLibraryManager.importURLs(urls: urls)
                    }
                    .ignoresSafeArea()
                }
                
                if landscape {
                    PressableView { pressed in
                        Text("Close")
                            .fontWeight(.bold)
                            .textCase(.uppercase)
                            .foregroundColor(pressed ? .black : .white)
                            .frame(maxWidth: 200)
                            .frame(height: 40)
                            .background(
                                pressed ?
                                AnyView(RoundedRectangle(cornerRadius: 10).stroke(.black, lineWidth: 4)) :
                                AnyView(RoundedRectangle(cornerRadius: 10).fill(.black))
                            )
                    }
                    .onReleased {
                        dismiss()
                    }
                }
            }
            .padding()
        }
        .frame(maxHeight: .infinity)
        .frame(maxWidth: .infinity)
        .background(.white)
    }
}

struct GameBoyView: View {
    private var lcd: LCDBitmapView
    @State private var showGameLibrary: Bool = false
    @EnvironmentObject private var gameLibraryManager: GameLibraryManager
    
    init(lcd: LCDBitmapView) {
        self.lcd = lcd
    }
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Group {
                    if geometry.size.width > geometry.size.height {
                        HStack {
                            VStack {
                                Spacer()
                                DPadView()
                                Spacer()
                            }
                            .padding(.trailing, 20)
                            .frame(width: geometry.size.width * 0.2)
                            lcd
                            VStack {
                                Spacer()
                                ABView()
                                Spacer()
                                StartSelectView()
                            }
                            .frame(width: geometry.size.width * 0.2)
                        }
                    } else {
                        VStack{
                            TitleView(title: gameLibraryManager.inserted.title) {
                                showGameLibrary = true
                            }
                            .padding(.top, 20)
                            lcd.frame(height: geometry.size.height * 0.5)
                            VStack {
                                Spacer()
                                HStack {
                                    DPadView()
                                    Spacer()
                                    ABView()
                                }
                                Spacer()
                                StartSelectView()
                            }
                            .padding()
                        }
                    }
                }
                .sheet(isPresented: $showGameLibrary) {
                    GameLibraryModalView(landscape: geometry.size.width > geometry.size.height)
                }
            }
            .background(.black)
        }
        .frame(width: .infinity, height: .infinity)
        .sheet(isPresented: $showGameLibrary) {
            GameLibraryModalView()
        }
    }
}
