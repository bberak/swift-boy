import Foundation

enum MBC: UInt8 {
    case zero = 0x00
    case one = 0x01
}

public class Cartridge: MemoryAccessArray {
    public init(rom: Data) {
        let mbc = MBC(rawValue: rom[0x0147])!
        
        switch mbc {
        case .zero:
            let rom = MemoryBlock(range: 0x0000...0x7FFF, buffer: rom.map { $0 }, readOnly: true, enabled: true)
            let ram = MemoryBlock(range: 0xA000...0xBFFF, readOnly: false, enabled: true)
            
            super.init([rom, ram])

        case .one:
            let rom0 = MemoryBlock(range: 0x0000...0x3FFF, buffer: rom.extract(0x0000...0x3FFF), readOnly: true, enabled: true)
            let romBank = MemoryBlockBanked(range: 0x4000...0x7FFF, buffer: rom.extractFrom(0x4000), readOnly: true, enabled: true)
            let ramBank = MemoryBlock(range: 0xA000...0xBFFF, readOnly: false, enabled: false)
            
            super.init([rom0, romBank, ramBank])
            
            self.subscribe({ (a, _) in a <= 0x1FFF }) { byte in
                ramBank.enabled = (byte & 0x0A) == 0x0A
            }
            
            self.subscribe({ (a, _) in a >= 0x2000 && a <= 0x3FFF }) { bank in
                print("ROM Bank Number (Write Only)", bank)
                romBank.bankIndex = romBank.bankIndex & 0b11100000 + bank & 0b00011111
            }
            
            self.subscribe({ (a, _) in a >= 0x6000 && a <= 0x7FFF }) { mode in
                print("ROM/RAM Mode Select (Write Only)", mode)
            }
            
            self.subscribe({ (a, _) in a >= 0x4000 && a <= 0x5FFF }) { bank in
                print("RAM Bank Number or Upper Bits of ROM Bank Number (Write Only)", bank)
            }
        }
    }
    
    public convenience init(path: URL) {
        self.init(rom: readPath(path: path))
    }
}
