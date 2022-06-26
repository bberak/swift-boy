// TODO: self.objectsEnabled is not currently being used anywhere
// TODO: Handle sprite priority: https://youtu.be/HyzD8pNlpwI?t=2179
// TODO: Handle transparent pixel: https://youtu.be/HyzD8pNlpwI?t=3308
// TODO: Double-break code in pixelTransfer() function is horrible - even for my standards..
// TODO: Need a helper function like: let pixels =  fill(pallete, lsb: [0,1,2,3], hsb: [0,1,2,3])
// TODO: And another: let pixels = mix(base: pixels1, with: pixels2, from: someIndex)

import Foundation
import UIKit
import SwiftUI

public struct Pixel {
    public var r, g, b, a: UInt8
    
    public init(r: UInt8, g: UInt8, b: UInt8, a: UInt8 = 255) {
        self.r = r
        self.g = g
        self.b = b
        self.a = a
    }
    
    public static let white = Pixel(r: 255, g: 255, b: 255)
    public static let lightGray = Pixel(r: 192, g: 192, b: 192)
    public static let darkGray = Pixel(r: 96, g: 96, b: 96)
    public static let black = Pixel(r: 0, g: 0, b: 0)
    public static let transparent = Pixel(r: 0, g: 0, b: 0, a: 0)
    
    public static func random() -> Pixel {
        return Pixel(r: UInt8.random(in: 0...255), g: UInt8.random(in: 0...255), b: UInt8.random(in: 0...255))
    }
}

public struct Bitmap {
    public private(set) var pixels: [Pixel]
    public let width: Int
    public var height: Int {
        return pixels.count / width
    }
    
    public init(width: Int, pixels: [Pixel]) {
        self.width = width
        self.pixels = pixels
    }
    
    public init(width: Int, height: Int, pixel: Pixel) {
        self.pixels = Array(repeating: pixel, count: width * height)
        self.width = width
    }
    
    subscript(x: Int, y: Int) -> Pixel {
        get { return pixels[y * width + x] }
        set { pixels[y * width + x] = newValue }
    }
}

extension UIImage {
    convenience init?(bitmap: Bitmap) {
        let alphaInfo = CGImageAlphaInfo.premultipliedLast
        let bytesPerPixel = MemoryLayout<Pixel>.size
        let bytesPerRow = bitmap.width * bytesPerPixel
        
        guard let providerRef = CGDataProvider(data: Data(
            bytes: bitmap.pixels, count: bitmap.height * bytesPerRow
        ) as CFData) else {
            return nil
        }
        
        guard let cgImage = CGImage(
            width: bitmap.width,
            height: bitmap.height,
            bitsPerComponent: 8,
            bitsPerPixel: bytesPerPixel * 8,
            bytesPerRow: bytesPerRow,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGBitmapInfo(rawValue: alphaInfo.rawValue),
            provider: providerRef,
            decode: nil,
            shouldInterpolate: true,
            intent: .defaultIntent
        ) else {
            return nil
        }
        
        self.init(cgImage: cgImage)
    }
}

public class LCDBitmap: UIView {
    private let imageView = UIImageView()
    private var displayLink: CADisplayLink?
    internal var bitmap = Bitmap(width: 160, height: 144, pixel: Pixel(r: 0, g: 0, b: 0))
    
    internal var enabled: Bool {
        get { return displayLink != nil ? displayLink!.isPaused == false : false }
        set {
            newValue ? on() : off()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        didLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        didLoad()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    func didLoad() {
        addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .none
        imageView.layer.magnificationFilter = .nearest
    }
    
    private func on() {
        if displayLink == nil {
            displayLink = CADisplayLink(target: self, selector: #selector(refresh))
            displayLink!.add(to: .main, forMode: .common)
        }
        
        displayLink!.isPaused = false
    }
    
    private func off() {
        if displayLink != nil {
            displayLink?.isPaused = true
        }
    }
    
    @objc private func refresh(_ displayLink: CADisplayLink) {
        imageView.image = UIImage(bitmap: bitmap)
    }
}

public struct LCDBitmapView: UIViewRepresentable {
    var child: LCDBitmap
    
    public func makeUIView(context: Context) -> UIView {
        child
    }

    public func updateUIView(_ uiView: UIView, context: Context) { }
}

struct Object {
    let x: UInt8
    let y: UInt8
    let index: UInt8
    let attributes: UInt8
}

let defaultPalette: [UInt8: Pixel] = [
    0: Pixel.white,
    1: Pixel.lightGray,
    2: Pixel.darkGray,
    3: Pixel.black
]

public class PPU {
    public let view: LCDBitmapView
    private let mmu: MMU
    private var queue: [Command] = []
    private var cycles: Int16 = 0
    private var windowTileMap: UInt8 = 0
    private var windowEnabled = false
    private var backgroundTileSet: UInt8 = 0
    private var backgroundTileMap: UInt8 = 0
    private var backgroundEnabled = false
    private var bgPalette = defaultPalette
    private var obj0Palette = defaultPalette
    private var obj1Palette = defaultPalette
    private var objSize: [UInt8] = [8, 8]
    private var objectsEnabled = false
    private var objectsMemo = Memo<[Object]>()
    private var objectsTileDataMemo = Memo<[[UInt8]]>()
    
    public init(_ mmu: MMU) {
        self.view = LCDBitmapView(child: LCDBitmap())
        self.mmu = mmu
        
        self.mmu.lcdControl.subscribe { byte in
            self.view.child.enabled = byte.bit(7)
            self.windowTileMap = byte.bit(6) ? 1 : 0
            self.windowEnabled = byte.bit(5)
            self.backgroundTileSet = byte.bit(4) ? 1 : 0
            self.backgroundTileMap = byte.bit(3) ? 1 : 0
            self.objSize = byte.bit(2) ? [8, 16] : [8, 8]
            self.objectsEnabled = byte.bit(1)
            self.backgroundEnabled = byte.bit(0)
        }
        
        self.mmu.lcdY.subscribe { ly in
            let lyc = self.mmu.lcdYCompare.read()
            self.setLYEqualsLYC(ly == lyc)
        }
        
        self.mmu.lcdYCompare.subscribe { lyc in
            let ly = self.mmu.lcdY.read()
            self.setLYEqualsLYC(ly == lyc)
        }
        
        self.mmu.bgPalette.subscribe { byte in
            self.bgPalette[0] = defaultPalette[byte.crumb(0)]
            self.bgPalette[1] = defaultPalette[byte.crumb(1)]
            self.bgPalette[2] = defaultPalette[byte.crumb(2)]
            self.bgPalette[3] = defaultPalette[byte.crumb(3)]
        }
        
        self.mmu.obj0Palette.subscribe { byte in
            self.obj0Palette[0] = Pixel.transparent
            self.obj0Palette[1] = defaultPalette[byte.crumb(1)]
            self.obj0Palette[2] = defaultPalette[byte.crumb(2)]
            self.obj0Palette[3] = defaultPalette[byte.crumb(3)]
        }
        
        self.mmu.obj1Palette.subscribe { byte in
            self.obj1Palette[0] = Pixel.transparent
            self.obj1Palette[1] = defaultPalette[byte.crumb(1)]
            self.obj1Palette[2] = defaultPalette[byte.crumb(2)]
            self.obj1Palette[3] = defaultPalette[byte.crumb(3)]
        }
        
        self.mmu.serialDataControl.subscribe({ (b) in b == 0x81 }) { _ in
            let byte = self.mmu.serialDataTransfer.read()
            let scalar = UnicodeScalar(byte)
            let char = Character(scalar)
            print(char, terminator: "")
        }
    }
    
    func setLYEqualsLYC(_ equal: Bool) {
        var stat = mmu.lcdStatus.read()
        var flags = mmu.interruptFlags.read()
        
        defer {
            mmu.lcdStatus.write(stat)
            mmu.interruptFlags.write(flags)
        }
        
        stat[2] = equal
        
        if stat.bit(6) && stat.bit(2) {
            flags[Interrupts.lcdStat.bit] = true
        }
    }
    
    func setMode(_ mode: UInt8) {
        var stat = mmu.lcdStatus.read()
        var flags = mmu.interruptFlags.read()
        
        defer {
            mmu.lcdStatus.write(stat)
            mmu.interruptFlags.write(flags)
        }
        
        stat[0] = mode[0]
        stat[1] = mode[1]
        
        if mode == 1 {
            flags[Interrupts.vBlank.bit] = true
        }
        
        if stat.bit(3) && mode == 0 {
            flags[Interrupts.lcdStat.bit] = true
        }
        
        if stat.bit(4) && mode == 1 {
            flags[Interrupts.lcdStat.bit] = true
        }
        
        if stat.bit(5) && mode == 2 {
            flags[Interrupts.lcdStat.bit] = true
        }
    }
    
    struct OamScanData {
        let bgTileData: [UInt16]
        let winTileData: [UInt16]?
        let wy: UInt8
        let wx: UInt8
        let objectsWithTileData: [(object: Object, data: [UInt8])]
        let bgy: UInt8
        let objSizeY: Int
    }
    
    func oamScan(ly: UInt8, scx: UInt8, scy: UInt8, continuation: @escaping (OamScanData) -> Command) -> Command {
        return Command(cycles: 40) {
            self.setMode(2)
            
            let bgy = scy &+ ly
            let bgTileMapRow = Int16(bgy / 8)
            let bgTileMapStartIndex = UInt16(bgTileMapRow * 32)
            let bgTileMapPointer: UInt16 = self.backgroundTileMap == 1 ? 0x9C00 : 0x9800
            let bgTileIndices: [UInt8] = try self.mmu.vramTileMaps.readBytes(address: bgTileMapPointer &+ bgTileMapStartIndex, count: 32 )
            let bgTileDataPointer: UInt16 = self.backgroundTileSet == 1 ? 0x8000 : 0x9000
            let bgTileData: [UInt16] = try bgTileIndices.map { idx in
                if bgTileDataPointer == 0x9000 {
                    let delta = Int16(idx.toInt8()) * 16 + Int16(bgy % 8) * 2
                    let address = bgTileDataPointer &+ delta.toUInt16()
                    return try self.mmu.vramTileData.readWord(address: address)
                } else {
                    let offset = UInt16(idx) * 16 + UInt16(bgy % 8) * 2
                    let address = bgTileDataPointer &+ offset
                    return try self.mmu.vramTileData.readWord(address: address)
                }
            }
            
            let wy = self.mmu.windowY.read()
            let wx = self.mmu.windowX.read()
            var winTileData: [UInt16]? = nil
            
            if self.windowEnabled && ly >= wy && wy.isBetween(0, 143) && wx.isBetween(0, 166) {
                let wly = ly - wy
                let winTileMapRow = Int16(wly / 8)
                let winTileMapStartIndex = UInt16(winTileMapRow * 20)
                let winTileMapPointer: UInt16 = self.windowTileMap == 1 ? 0x9C00 : 0x9800
                let winTileIndices: [UInt8] = try self.mmu.vramTileMaps.readBytes(address: winTileMapPointer &+ winTileMapStartIndex, count: 20 )
                let winTileDataPointer: UInt16 = self.backgroundTileSet == 1 ? 0x8000 : 0x9000
                winTileData = try winTileIndices.map { idx in
                    if winTileDataPointer == 0x9000 {
                        let delta = Int16(idx.toInt8()) * 16 + Int16(wly % 8) * 2
                        let address = winTileDataPointer &+ delta.toUInt16()
                        return try self.mmu.vramTileData.readWord(address: address)
                    } else {
                        let offset = UInt16(idx) * 16 + UInt16(wly % 8) * 2
                        let address = winTileDataPointer &+ offset
                        return try self.mmu.vramTileData.readWord(address: address)
                    }
                }
            }
            
            let allObjects = self.objectsMemo.get(deps: [self.mmu.oam.version]) {
                return try! self.mmu.oam.readBytes(address: 0xFE00, count: 160).chunked(into: 4).map { arr in
                    return Object(x: arr[1], y: arr[0], index: arr[2], attributes: arr[3])
                }
            }
            let objSizeY = Int(self.objSize[1])
            let visibleObjects = allObjects.filter { (o: Object) -> Bool in
                let dy = Int16(o.y) - Int16(bgy)
                return (dy).isBetween(17 - objSizeY, 16) && o.x > 0
            }.prefix(10)
            var deps: [AnyHashable] = visibleObjects.map { $0.index }
            deps.append(objSizeY)
            deps.append(self.mmu.vramTileData.version)
            let objTileData = self.objectsTileDataMemo.get(deps: deps) {
                return visibleObjects.map ({ (o: Object) -> [UInt8]  in
                    let offset = UInt16(o.index) * 16
                    let address: UInt16 = 0x8000 &+ offset
                    let data = try! self.mmu.vramTileData.readBytes(address: address, count: UInt16(objSizeY) * 2)
                    return data
                })
            }
            let objectsWithTileData = Array(zip(visibleObjects, objTileData))
            
            return continuation(OamScanData(bgTileData: bgTileData, winTileData: winTileData, wy: wy, wx: wx, objectsWithTileData: objectsWithTileData, bgy: bgy, objSizeY: objSizeY))
        }
    }
    
    func pixelTransfer(ly: UInt8, scx: UInt8, data: OamScanData, continuation: @escaping () -> Command) -> Command {
        return Command(cycles: 144) {
            self.setMode(3)
            
            var pixels = self.backgroundEnabled ? [Pixel]() : [Pixel](repeating: Pixel.white, count: 256)
            
            if self.backgroundEnabled {
                for data in data.bgTileData {
                    let arr = data.toBytes()
                    let lsb = arr[0]
                    let hsb = arr[1]
                    
                    for idx in (0...7).reversed() {
                        let bit = UInt8(idx) // Bit 7 represents the most leftmost pixel (idx=0)
                        let v1: UInt8 = lsb.bit(bit) ? 1 : 0
                        let v2: UInt8 = hsb.bit(bit) ? 2 : 0
                        
                        pixels.append(self.bgPalette[v1 + v2]!)
                    }
                }
                
                if data.winTileData != nil {
                    var x = Int(data.wx) - 7
                    
                    for data in data.winTileData! {
                        let arr = data.toBytes()
                        let lsb = arr[0]
                        let hsb = arr[1]
                        
                        for idx in (0...7).reversed() {
                            let bit = UInt8(idx) // Bit 7 represents the most leftmost pixel (idx=0)
                            let v1: UInt8 = lsb.bit(bit) ? 1 : 0
                            let v2: UInt8 = hsb.bit(bit) ? 2 : 0
                            
                            pixels[(x + Int(scx)) % pixels.count] = self.bgPalette[v1 + v2]!
                            x = x + 1
                            
                            if x >= pixels.count {
                                break
                            }
                        }
                        
                        if x >= pixels.count {
                            break
                        }
                    }
                }
            }
            
            for obj in data.objectsWithTileData {
                let palette = obj.object.attributes.bit(4) ? self.obj1Palette : self.obj0Palette
                let flipY = obj.object.attributes.bit(6)
                let flipX = obj.object.attributes.bit(5)
                let line = Int(data.bgy) - Int(obj.object.y) + 16 // Why does this work?
                let lineIndex = Int(flipY ? data.objSizeY - line - 1 : line)
                let lsb = obj.data[lineIndex * 2]
                let hsb = obj.data[lineIndex * 2 + 1]
                
                for idx in (0...7) {
                    let x = idx + Int(obj.object.x) - 8
                    
                    if x >= 0 {
                        let bit = UInt8(flipX ? idx : 7 - idx) // Bit 7 represents the most leftmost pixel (idx=0)
                        let v1: UInt8 = lsb.bit(bit) ? 1 : 0
                        let v2: UInt8 = hsb.bit(bit) ? 2 : 0
                        let p = v1 + v2
                        if p > 0 {
                            pixels[(x + Int(scx)) % pixels.count] = palette[p]!
                        }
                    }
                }
            }
            
            for col in 0..<self.view.child.bitmap.width {
                let bgX = (Int(scx) + col) % pixels.count
                self.view.child.bitmap[col, Int(ly)] = pixels[bgX]
            }
            
            return continuation()
        }
    }
    
    func hBlank(ly: UInt8) -> Command {
        return Command(cycles: 44) {
            self.setMode(0)
            
            // Increment ly at the end of the blanking period
            return Command(cycles: 0) {
                self.mmu.lcdY.write(ly + 1)
                return nil
            }
        }
    }
    
    func vBlank(ly: UInt8) -> Command {
        return Command(cycles: 228) {
            if ly == 144 {
                self.setMode(1)
            }
            
            // Increment or reset ly at the end of the blanking period
            return Command(cycles: 0) {
                self.mmu.lcdY.write(ly < 153 ? ly + 1 : 0)
                return nil
            }
        }
    }
    
    func fetchNextCommand() -> Command {
        let ly = mmu.lcdY.read()
        let scx = mmu.scrollX.read()
        let scy = mmu.scrollY.read()
        
        if ly < view.child.bitmap.height {
            return self.oamScan(ly: ly, scx: scx, scy: scy) { data in
                return self.pixelTransfer(ly: ly, scx: scx, data: data) {
                    return self.hBlank(ly: ly);
                }
            }
        } else {
            return self.vBlank(ly: ly)
        }
    }
    
    public func run(ppuCycles: Int16) throws {
        if view.child.enabled {
            cycles = cycles + ppuCycles
            
            while cycles > 0 {
                let cmd = queue.count > 0 ? queue.removeFirst() : fetchNextCommand()
                let next = try cmd.run()
                
                cycles = cycles - Int16(cmd.cycles)
                
                if next != nil {
                    queue.insert(next!, at: 0)
                }
            }
        }
    }
    
    public func reset() {
        cycles = 0
        queue.removeAll()
        objectsMemo.invalidate()
        objectsTileDataMemo.invalidate()
    }
}
