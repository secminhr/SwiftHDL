public class And: Chip {
    @Input public var inA: Bit
    @Input public var inB: Bit
    @Output public var out: Bit
    
    public convenience init<WA: Wire, WB: Wire>(_ inA: WA, _ inB: WB) {
        self.init()
        store {
            inA ~> self.$inA
            inB ~> self.$inB
        }
    }
    
    public override func create() {
        connections {
            $inA.subject.combineLatest($inB.subject)
                .map { (a, b) in a && b }
                .assign(to: \.out, on: self)
        }
    }
}

public class Not: Chip {
    @Input public var input: Bit
    @Output public var output: Bit

    public convenience init<W: Wire>(_ input: W) {
        self.init()
        store {
            input ~> self.$input
        }
    }
    
    public override func create() {
        connections {
            $input.subject.map { !$0 }.assign(to: \.output, on: self)
        }
    }
}


public class Nand: Chip {
    @Input public var inA: Bit
    @Input public var inB: Bit
    @Output public var out: Bit
    
    public convenience init<W1: Wire, W2: Wire>(_ inA: W1, _ inB: W2) {
        self.init()
        store {
            inA ~> self.$inA
            inB ~> self.$inB
        }
    }
    
    public override func create() {
        connections {
            $inA.subject.combineLatest($inB.subject)
                .map { (a, b) in !(a && b) }
                .assign(to: \.out, on: self)
        }
    }
}
