import Foundation

let cartridge = Cartridge(path: #fileLiteral(resourceName: "cpu_instrs.gb"), title: "Blargg CPU Test")
let mmu = MMU()
let cpu = CPU(mmu: mmu)

class DynamicIterator<T> : IteratorProtocol {
    private var items: [T] = []
    private var index = 0;
    
    init(generator: (DynamicIterator<T>) -> Void) {
        generator(self)
    }
    
    func yield(_ item: T) {
        self.items.append(item)
    }
    
    func next() -> T? {
        if index > (items.count-1) {
            return nil
        }
        
        let item = items[index]
        index+=1
        
        return item
    }
}

class DynamicSequence<T>: Sequence {
    let generator: (DynamicIterator<T>) -> Void
    
    init(generator: @escaping (DynamicIterator<T>) -> Void) {
        self.generator = generator
    }
    
    func makeIterator() -> DynamicIterator<T> {
        return DynamicIterator(generator: self.generator)
    }
}

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
