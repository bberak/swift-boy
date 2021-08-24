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

public class Screen: UIViewController {
    private let imageView = UIImageView()
    internal var bitmap = Bitmap(width: 160, height: 144, pixel: Pixel(r: 0, g: 0, b: 255))
    
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
    
    func draw() {
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
    public let screen: Screen
    private let mmu: MMU
    private var state: [Mode: UInt16]
    private var cycles: Int16
    
    public init(_ mmu: MMU) {
        self.screen = Screen()
        self.mmu = mmu
        self.state = [
            Mode.one: 0,
            Mode.two: 0,
            Mode.three: 0,
            Mode.four: 0
        ]
        self.cycles = 0
        self.mmu.subscribe(address: 0xFF40) { byte in
            print("LCD control:", byte.toHexString())
            self.screen.bitmap[0, 0] = Pixel(r: 255, g: 0, b: 0)
            self.screen.bitmap[1, 1] = Pixel(r: 255, g: 0, b: 0)
            self.screen.bitmap[2, 2] = Pixel(r: 255, g: 0, b: 0)
            self.screen.bitmap[3, 3] = Pixel(r: 255, g: 0, b: 0)
            self.screen.bitmap[4, 4] = Pixel(r: 255, g: 0, b: 0)
        }
        self.mmu.subscribe(address: 0xFF42) { byte in
            print("Vertical scroll register:", byte.toHexString())
            self.screen.bitmap[20, 20] = Pixel(r: 255, g: 0, b: 0)
            self.screen.bitmap[20, 21] = Pixel(r: 255, g: 0, b: 0)
            self.screen.bitmap[20, 22] = Pixel(r: 255, g: 0, b: 0)
            self.screen.bitmap[20, 23] = Pixel(r: 255, g: 0, b: 0)
            self.screen.bitmap[20, 24] = Pixel(r: 255, g: 0, b: 0)
        }
    }
    
    func fetchNextCommand() -> Command {
        return Command(cycles: 2) {
            return nil
        }
    }
    
    public func run(for time: Int16) throws {
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
