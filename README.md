# Swift Boy

> A Game Boy emulator for Swift (XCode) Playgrounds

Test results:

```
let test01 = Cartridge(path: #fileLiteral(resourceName: "01-special.gb"))

01-special


Passed
Failed #10Ì

let test02 = Cartridge(path: #fileLiteral(resourceName: "02-interrupts.gb"))

let test03 = Cartridge(path: #fileLiteral(resourceName: "03-op sp,hl.gb"))

03-op sp,hl

>? >? ?? ?? 

let test04 = Cartridge(path: #fileLiteral(resourceName: "04-op r,imm.gb"))

04-op r,imm

?> == => 

let test05 = Cartridge(path: #fileLiteral(resourceName: "05-op rp.gb"))

05-op rp


Passed
Failed #10Ì

let test06 = Cartridge(path: #fileLiteral(resourceName: "06-ld r,r.gb"))

06-ld r,r


Passed
Failed #10Ì

let test07 = Cartridge(path: #fileLiteral(resourceName: "07-jr,jp,call,ret,rst.gb"))

07-jr,jp,call,ret,rst


let test08 = Cartridge(path: #fileLiteral(resourceName: "08-misc instrs.gb"))

08-misc instrs


Passed
Failed #10Ì

let test09 = Cartridge(path: #fileLiteral(resourceName: "09-op r,r.gb"))

09-op r,r

;? ;@ ;: ;; ;< ;= ;? @7 @8 @9 @: @; @< @> @? @@ @: @; @< @= @? 7< 7= 8< 8= 9< 9= := 

let test10 = Cartridge(path: #fileLiteral(resourceName: "10-bit ops.gb"))

10-bit ops


Passed
Failed #10Ì

let test11 = Cartridge(path: #fileLiteral(resourceName: "11-op a,(hl).gb"))

11-op a,(hl)

;> @= @> :< :; 
```