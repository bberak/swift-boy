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
}

public struct Bitmap {
    public private(set) var pixels: [Pixel]
    public let width: Int
    
    public init(width: Int, pixels: [Pixel]) {
        self.width = width
        self.pixels = pixels
    }
}

public extension Bitmap {
    var height: Int {
        return pixels.count / width
    }
    
    subscript(x: Int, y: Int) -> Pixel {
        get { return pixels[y * width + x] }
        set { pixels[y * width + x] = newValue }
    }

    init(width: Int, height: Int, pixel: Pixel) {
        self.pixels = Array(repeating: pixel, count: width * height)
        self.width = width
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
    
    func on() {
        if displayLink == nil {
            displayLink = CADisplayLink(target: self, selector: #selector(draw))
            displayLink!.add(to: .main, forMode: .common)
        }
        
        displayLink!.isPaused = false
    }
    
    func off() {
        if displayLink != nil {
            displayLink?.isPaused = true
        }
    }
    
    @objc func draw(_ displayLink: CADisplayLink) {
        imageView.image = UIImage(bitmap: bitmap)
    }
}

enum Mode {
    case one
    case two
    case three
    case four
}

public class PPU {
    public let lcd: LCD
    private let mmu: MMU
    private var state: [Mode: UInt16]
    private var cycles: Int16 = 0
    private var windowTileMapRange: ClosedRange<UInt16> = 0...0
    private var windowEnabled: Bool = false
    private var bgAndWindowTileDataRange: ClosedRange<UInt16> = 0...0
    private var bgTileMapRange: ClosedRange<UInt16> = 0...0
    private var objSize: [UInt16] = [0, 0]
    private var objEnabled: Bool = false
    private var bgAndWindowPriorityEnabled: Bool = false
    private var _enabled = false
    private var enabled: Bool {
        get { return _enabled }
        set {
            _enabled = newValue
            _enabled ? lcd.on() : lcd.off()
        }
    }
    
    public init(_ mmu: MMU) {
        self.lcd = LCD()
        self.mmu = mmu
        self.state = [
            Mode.one: 0,
            Mode.two: 0,
            Mode.three: 0,
            Mode.four: 0
        ]
        self.mmu.subscribe(address: 0xFF40) { byte in
            self.enabled = byte.bit(7)
            self.windowTileMapRange = byte.bit(6) ? 0x9C00...0x9FFF : 0x9800...0x9BFF
            self.windowEnabled = byte.bit(5)
            self.bgAndWindowTileDataRange = byte.bit(4) ? 0x8000...0x8FFF : 0x8800...0x97FF
            self.bgTileMapRange = byte.bit(3) ? 0x9C00...0x9FFF : 0x9800...0x9BFF
            self.objSize = byte.bit(2) ? [8, 16] : [8, 8]
            self.objEnabled = byte.bit(1)
            self.bgAndWindowPriorityEnabled = byte.bit(0)
        }
        self.mmu.subscribe(address: 0xFF42) { byte in
            //-- Scroll y register
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
        if enabled {
            cycles = cycles + time
            
            while cycles > 0 {
                var cmd: Command? = fetchNextCommand()
                
                while cmd != nil {
                   let next = try cmd!.run()
                   cycles = cycles - Int16(cmd!.cycles)
                   cmd = next
                }
            }
        }
    }
}
