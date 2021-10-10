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
    private var bgPalette = defaultPalette
    private var obj0Palette = defaultPalette
    private var obj1Palette = defaultPalette
            
    public init(_ mmu: MMU) {
        self.lcd = LCD()
        self.mmu = mmu
        
        self.mmu.lcdControl.subscribe { byte in
            self.lcd.enabled = byte.bit(7)
            self.windowTileMap = byte.bit(6) ? 1 : 0
            self.windowEnabled = byte.bit(5)
            self.backgroundTileSet = byte.bit(4) ? 1 : 0
            self.backgroundTileMap = byte.bit(3) ? 1 : 0
            self.spriteSize = byte.bit(2) ? [8, 16] : [8, 8]
            self.spritesEnabled = byte.bit(1)
            self.backgroundEnabled = byte.bit(0)
        }
                
        self.mmu.lcdY.subscribe { ly in
            let lyc = self.mmu.lcdYCompare.read()
            try! self.setLYEqualsLYC(ly == lyc)
        }
        
        self.mmu.lcdYCompare.subscribe { lyc in
            let ly = self.mmu.lcdY.read()
            try! self.setLYEqualsLYC(ly == lyc)
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
    
    func setLYEqualsLYC(_ equal: Bool) throws {
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
    
    func setMode(_ mode: UInt8) throws {
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
    
    func fetchNextCommand() -> Command {
        let ly = mmu.lcdY.read()
        let scx = mmu.scrollX.read()
        let scy = mmu.scrollY.read()
        
        if ly < lcd.bitmap.height {
            // OAM Scan
            return Command(cycles: 40) {
                try self.setMode(2)
                
                let bgY = scy &+ ly
                let bgTileMapRow = Int16(bgY / 8)
                let bgTileMapStartIndex = UInt16(bgTileMapRow * 32)
                let bgTileMapPointer: UInt16 = self.backgroundTileMap == 1 ? 0x9C00 : 0x9800
                let bgTileIndices: [UInt8] = try self.mmu.readBytes(address: bgTileMapPointer &+ bgTileMapStartIndex, count: 32 )
                let bgTileDataPointer: UInt16 = self.backgroundTileSet == 1 ? 0x8000 : 0x9000
                let bgTileData: [UInt16] = try bgTileIndices.map { idx in
                    if bgTileDataPointer == 0x9000 {
                        let delta = Int16(idx.toInt8()) * 16 + Int16(bgY % 8) * 2
                        let address = bgTileDataPointer &+ delta.toUInt16()
                        return try self.mmu.readWord(address: address)
                    } else {
                        let offset = UInt16(idx) * 16 + UInt16(bgY % 8) * 2
                        let address = bgTileDataPointer &+ offset
                        return try self.mmu.readWord(address: address)
                    }
                }
                
                // let sprites = try self.mmu.readBytes(address: 0xFE00, count: 160).chunked(into: 4).map { arr in
                //     return Sprite(x: arr[1], y: arr[0], index: arr[2], attributes: arr[3])
                // }.filter { (s: Sprite) -> Bool in
                //     return bgY < s.y && Int(bgY) >= (Int(s.y) - 16)
                // }
                
                // let spritesWithTileData = try sprites.map ({ (s: Sprite) -> (sprite: Sprite, data: [UInt8])  in
                //     let offset = UInt16(s.index) * 16
                //     let address: UInt16 = 0x8000 &+ offset
                //     let data = try self.mmu.readBytes(address: address, count: UInt16(self.spriteSize[1]) * 2)
                //     return (sprite: s, data: data)
                // })
                
                // Drawing Pixels
                return Command(cycles: 144) {
                    try self.setMode(3)
                    
                    var pixels = [Pixel]()

                    for data in bgTileData {
                        let arr = data.toBytes()
                        let lsb = arr[0]
                        let hsb = arr[1]

                        for idx in (0...7).reversed() {
                            let v1: UInt8 = lsb.bit(UInt8(idx)) ? 1 : 0
                            let v2: UInt8 = hsb.bit(UInt8(idx)) ? 2 : 0

                            pixels.append(self.bgPalette[v1 + v2]!)
                        }
                    }
                    
                    // for obj in spritesWithTileData {
                    //     let spriteX = obj.sprite.x
                    //     let spriteY = obj.sprite.y
                    //     let sizeX = self.spriteSize[0]
                    //     let sizeY = self.spriteSize[1]
                    //     let palette = obj.sprite.attributes.bit(4) ? self.spritePalette1 : self.spritePalette0

                    //     if bgY >= (spriteY - sizeY) && bgY < spriteY {
                    //         let end = Int(self.spriteSize[1]) - 2
                    //         let line = Int.random(in: 0...end) //(Int(sizeY) - (Int(spriteY) - Int(bgY))) * 2
                    //         let lsb = obj.data[line]
                    //         let hsb = obj.data[line + 1]

                    //         for idx in (0...7).reversed() {
                    //             let v1: UInt8 = lsb.bit(UInt8(idx)) ? 1 : 0
                    //             let v2: UInt8 = hsb.bit(UInt8(idx)) ? 2 : 0
                    //             let x = (idx + Int(spriteX)) % pixels.count

                    //             pixels[x] = palette[v1 + v2]!
                    //         }
                    //     }
                    // }
                    
                    for col in 0..<self.lcd.bitmap.width {
                        let bgX = (Int(scx) + col) % pixels.count
                        self.lcd.bitmap[col, Int(ly)] = pixels[bgX]
                    }
                    
                    // Horizontal blank
                    return Command(cycles: 44) {
                        try self.setMode(0)
                        
                        // Increment ly at the end of the blanking period
                        return Command(cycles: 0) {
                            self.mmu.lcdY.write(ly + 1)
                            return nil
                        }
                    }
                }
            }
        } else {
            // Vertical blank per line
            return Command(cycles: 228) {
                if ly == 144 {
                    try self.setMode(1)
                }
                
                // Increment or reset ly at the end of the blanking period
                return Command(cycles: 0) {
                    self.mmu.lcdY.write(ly < 153 ? ly + 1 : 0)
                    return nil
                }
            }
        }
    }
    
    public func run(for time: UInt8) throws {
        if lcd.enabled {
            cycles = cycles + Int16(time)
        
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
