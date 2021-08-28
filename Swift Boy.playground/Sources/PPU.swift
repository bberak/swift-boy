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

enum Mode {
    case oamSearch
    case activePicture
    case horizontalBlanking
    case verticalBlanking
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
    private var spriteSize = [8, 8]
    private var spritesEnabled = false
    private var backgroundEnabled = false
    private var scrollX: UInt8 = 0
    private var scrollY: UInt8 = 0
    private var backgroundPalette = defaultPalette
    private var spritePalette0 = defaultPalette
    private var spritePalette1 = defaultPalette
    private var state: [Mode: UInt16] = [
        Mode.oamSearch: 0,
        Mode.activePicture: 0,
        Mode.horizontalBlanking: 0,
        Mode.verticalBlanking: 0
    ]
        
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
        self.mmu.subscribe(address: 0xFF42) { byte in
            self.scrollY = byte
        }
        self.mmu.subscribe(address: 0xFF43) { byte in
            self.scrollX = byte
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
    }
    
    func fetchNextCommand() -> Command {
        return Command(cycles: 2) {
            let x = Int.random(in: 0..<self.lcd.bitmap.width)
            let y = Int.random(in: 0..<self.lcd.bitmap.height)
            self.lcd.bitmap[x, y] = Pixel(r: UInt8.random(in: 0...255), g: UInt8.random(in: 0...255), b: UInt8.random(in: 0...255))
            return nil
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
