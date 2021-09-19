# Swift Boy

> A Game Boy emulator for Swift (XCode) Playgrounds

Test results:

```
let test01 = Cartridge(path: #fileLiteral(resourceName: "01-special.gb"))

01-special


Passed

let test02 = Cartridge(path: #fileLiteral(resourceName: "02-interrupts.gb"))

let test03 = Cartridge(path: #fileLiteral(resourceName: "03-op sp,hl.gb"))

03-op sp,hl

E8 E8 F8 F8 
Failed

let test04 = Cartridge(path: #fileLiteral(resourceName: "04-op r,imm.gb"))

04-op r,imm


Passed

let test05 = Cartridge(path: #fileLiteral(resourceName: "05-op rp.gb"))

05-op rp


Passed

let test06 = Cartridge(path: #fileLiteral(resourceName: "06-ld r,r.gb"))

06-ld r,r


Passed

let test07 = Cartridge(path: #fileLiteral(resourceName: "07-jr,jp,call,ret,rst.gb"))

07-jr,jp,call,ret,rst

Interrupt Enable (R/W): 00
Interrupt Enable (R/W): 00
Interrupt Enable (R/W): 00
Interrupt Enable (R/W): 00
Interrupt Enable (R/W): 00
Interrupt Enable (R/W): 00
Interrupt Enable (R/W): 00
Interrupt Enable (R/W): 00
Interrupt Enable (R/W): 00
Interrupt Enable (R/W): 00
Interrupt Enable (R/W): 00
Interrupt Enable (R/W): 00
Interrupt Enable (R/W): 00
Interrupt Enable (R/W): 00
Interrupt Enable (R/W): 00
Interrupt Enable (R/W): 00
Interrupt Enable (R/W): 00
Interrupt Enable (R/W): 00
Interrupt Enable (R/W): 00
Interrupt Enable (R/W): 00
Interrupt Enable (R/W): 00
Interrupt Enable (R/W): 00
Fatal error: 'try!' expression unexpectedly raised an error: Swift_Boy.CPUError.instructionNotImplemented(0x76): file /Users/Boris/Dev/iOS/swift-boy/Swift Boy/Swift Boy/Emulator/Clock.swift, line 25
2021-09-19 19:19:48.500472+1000 Swift Boy[35973:2243086] Fatal error: 'try!' expression unexpectedly raised an error: Swift_Boy.CPUError.instructionNotImplemented(0x76): file /Users/Boris/Dev/iOS/swift-boy/Swift Boy/Swift Boy/Emulator/Clock.swift, line 25

let test08 = Cartridge(path: #fileLiteral(resourceName: "08-misc instrs.gb"))

08-misc instrs


Passed

let test09 = Cartridge(path: #fileLiteral(resourceName: "09-op r,r.gb"))

09-op r,r


Passed

let test10 = Cartridge(path: #fileLiteral(resourceName: "10-bit ops.gb"))

10-bit ops


Passed

let test11 = Cartridge(path: #fileLiteral(resourceName: "11-op a,(hl).gb"))

11-op a,(hl)


Passed
```