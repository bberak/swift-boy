import Foundation

let cartridge = Cartridge(path: #fileLiteral(resourceName: "cpu_instrs.gb"), title: "Blargg CPU Test")
let mmu = MMU()
let cpu = CPU(mmu: mmu)

let actions = DynamicSequence<()->Void> { seq in
    seq.yield {
        print("You are in f1... :)")
        seq.yield {
            print("You are in f2... :)")
            seq.yield {
                print("You are in f3... :)")
            }
        }
    }
}

for a in actions {
    a()
}

let numbers = DynamicSequence<Int> { seq in
    seq.yield(1)
    seq.yield(2)
    seq.yield(3)
}

for n in numbers {
    print(n)
}

//try cpu.start()
