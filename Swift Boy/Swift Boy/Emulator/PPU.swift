import Foundation
import UIKit

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

public class LCD: UIViewController {
    private let imageView = UIImageView()
    private var displayLink: CADisplayLink?
    internal var bitmap = Bitmap(width: 160, height: 144, pixel: Pixel(r: 0, g: 0, b: 0))
    
    internal var enabled: Bool {
        get { return displayLink != nil ? displayLink!.isPaused == false : false }
        set {
            newValue ? on() : off()
        }
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        imageView.layer.magnificationFilter = .nearest
    }
    
    private func on() {
        if displayLink == nil {
            displayLink = CADisplayLink(target: self, selector: #selector(draw))
            displayLink!.add(to: .main, forMode: .common)
        }

        displayLink!.isPaused = false
    }
    
    private func off() {
        if displayLink != nil {
            displayLink?.isPaused = true
        }
    }
    
    @objc private func draw(_ displayLink: CADisplayLink) {
        imageView.image = UIImage(bitmap: bitmap)
    }
}

struct Sprite {
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
    public let lcd: LCD
    private let mmu: MMU
    private var queue: [Command] = []
    private var cycles: Int16 = 0
    private var windowTileMap: UInt8 = 0
    private var windowEnabled = false
    private var backgroundTileSet: UInt8 = 0
    private var backgroundTileMap: UInt8 = 0
    private var spriteSize: [UInt8] = [8, 8]
    private var spritesEnabled = false
    private var backgroundEnabled = false
    private var backgroundPalette = defaultPalette
    private var spritePalette0 = defaultPalette
    private var spritePalette1 = defaultPalette
    
    private var scx: UInt8 {
        get {
            return try! mmu.readByte(address: 0xFF43)
        }
        set {
            try! mmu.writeByte(address: 0xFF43, byte: newValue)
        }
    }
    
    private var scy: UInt8 {
        get {
            return try! mmu.readByte(address: 0xFF42)
        }
        set {
            try! mmu.writeByte(address: 0xFF42, byte: newValue)
        }
    }
    
    private var ly: UInt8 {
        get {
            return try! mmu.readByte(address: 0xFF44)
        }
        set {
            try! mmu.writeByte(address: 0xFF44, byte: newValue)
        }
    }
        
    public init(_ mmu: MMU) {
        self.lcd = LCD()
        self.mmu = mmu
        
        self.mmu.subscribe(address: 0xFF40) { byte in
            self.lcd.enabled = byte.bit(7)
            self.windowTileMap = byte.bit(6) ? 1 : 0
            self.windowEnabled = byte.bit(5)
            self.backgroundTileSet = byte.bit(4) ? 1 : 0
            self.backgroundTileMap = byte.bit(3) ? 1 : 0
            self.spriteSize = byte.bit(2) ? [8, 16] : [8, 8]
            self.spritesEnabled = byte.bit(1)
            self.backgroundEnabled = byte.bit(0)
        }
        
        self.mmu.subscribe(address: 0xFF47) { byte in
            self.backgroundPalette[0] = defaultPalette[byte.crumb(0)]
            self.backgroundPalette[1] = defaultPalette[byte.crumb(1)]
            self.backgroundPalette[2] = defaultPalette[byte.crumb(2)]
            self.backgroundPalette[3] = defaultPalette[byte.crumb(3)]
        }
        
        self.mmu.subscribe(address: 0xFF48) { byte in
            self.spritePalette0[0] = Pixel.transparent
            self.spritePalette0[1] = defaultPalette[byte.crumb(1)]
            self.spritePalette0[2] = defaultPalette[byte.crumb(2)]
            self.spritePalette0[3] = defaultPalette[byte.crumb(3)]
        }
        
        self.mmu.subscribe(address: 0xFF49) { byte in
            self.spritePalette1[0] = Pixel.transparent
            self.spritePalette1[1] = defaultPalette[byte.crumb(1)]
            self.spritePalette1[2] = defaultPalette[byte.crumb(2)]
            self.spritePalette1[3] = defaultPalette[byte.crumb(3)]
        }
        
        self.mmu.subscribe({ (a, b) in a == 0xFF02 && b == 0x81 }) { _ in
            let byte = try! self.mmu.readByte(address: 0xFF01)
            let scalar = UnicodeScalar(byte)
            let char = Character(scalar)
            print(char, terminator: "")
        }
    }
    
    func fetchNextCommand() -> Command {
        let ly = self.ly
        let scx = self.scx
        let scy = self.scy
        
        if ly < self.lcd.bitmap.height {
            // OAM Scan
            return Command(cycles: 40) {
                let bgY = scy &+ ly
                let bgTileMapRow = Int16(bgY / 8)
                let bgTileMapStartIndex = UInt16(bgTileMapRow * 32)
                let bgTileMapPointer: UInt16 = self.backgroundTileMap == 1 ? 0x9C00 : 0x9800
                let bgTileIndices: [UInt8] = try self.mmu.readBytes(address: bgTileMapPointer &+ bgTileMapStartIndex, count: 32 )
                let bgTileDataPointer: UInt16 = self.backgroundTileSet == 1 ? 0x8000 : 0x9000
                let bgTileData: [UInt16] = try bgTileIndices.map { idx in
                    if bgTileDataPointer == 0x9000 {
                        let delta = Int16(idx.toInt8()) * 16 + Int16(bgY % 8) * 2
                        let address = bgTileDataPointer.offset(by: delta)
                        return try self.mmu.readWord(address: address)
                    } else {
                        let offset = UInt16(idx) * 16 + UInt16(bgY % 8) * 2
                        let address = bgTileDataPointer &+ offset
                        return try self.mmu.readWord(address: address)
                    }
                }
                
//                let sprites = try self.mmu.readBytes(address: 0xFE00, count: 160).chunked(into: 4).map { arr in
//                    return Sprite(x: arr[1], y: arr[0], index: arr[2], attributes: arr[3])
//                }.filter { (s: Sprite) -> Bool in
//                    return bgY < s.y && Int(bgY) >= (Int(s.y) - 16)
//                }
//                let spritesWithTileData = try sprites.map ({ (s: Sprite) -> (sprite: Sprite, data: [UInt8])  in
//                    let offset = UInt16(s.index) * 16
//                    let address: UInt16 = 0x8000 &+ offset
//                    let data = try self.mmu.readBytes(address: address, count: UInt16(self.spriteSize[1]) * 2)
//                    return (sprite: s, data: data)
//                })
                
                // Drawing Pixels
                return Command(cycles: 144) {
                    var pixels = [Pixel]()

                    for data in bgTileData {
                        let arr = data.toBytes()
                        let lsb = arr[0]
                        let hsb = arr[1]

                        for idx in (0...7).reversed() {
                            let v1: UInt8 = lsb.bit(UInt8(idx)) ? 1 : 0
                            let v2: UInt8 = hsb.bit(UInt8(idx)) ? 2 : 0

                            pixels.append(self.backgroundPalette[v1 + v2]!)
                        }
                    }
                    
//                    for obj in spritesWithTileData {
//                        let spriteX = obj.sprite.x
//                        let spriteY = obj.sprite.y
//                        let sizeX = self.spriteSize[0]
//                        let sizeY = self.spriteSize[1]
//                        let palette = obj.sprite.attributes.bit(4) ? self.spritePalette1 : self.spritePalette0
//
//                        if bgY >= (spriteY - sizeY) && bgY < spriteY {
//                            let end = Int(self.spriteSize[1]) - 2
//                            let line = Int.random(in: 0...end) //(Int(sizeY) - (Int(spriteY) - Int(bgY))) * 2
//                            let lsb = obj.data[line]
//                            let hsb = obj.data[line + 1]
//
//                            for idx in (0...7).reversed() {
//                                let v1: UInt8 = lsb.bit(UInt8(idx)) ? 1 : 0
//                                let v2: UInt8 = hsb.bit(UInt8(idx)) ? 2 : 0
//                                let x = (idx + Int(spriteX)) % pixels.count
//
//                                pixels[x] = palette[v1 + v2]!
//                            }
//                        }
//                    }
                    
                    for col in 0..<self.lcd.bitmap.width {
                        let bgX = (Int(scx) + col) % pixels.count
                        self.lcd.bitmap[col, Int(ly)] = pixels[bgX]
                    }
                    
                    // Horizontal blank
                    return Command(cycles: 44) {
                        
                        // Increment ly
                        return Command(cycles: 0) {
                            self.ly = ly + 1
                            return nil
                        }
                    }
                }
            }
        } else {
            // Vertical blank
            return Command(cycles: 228) {
                
                // Increment or reset ly
                return Command(cycles: 0) {
                    self.ly = ly < 153 ? ly + 1 : 0
                    return nil
                }
            }
        }
    }
    
    public func run(for time: Int16) throws {
        if lcd.enabled {
            cycles = cycles + time
        
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
}