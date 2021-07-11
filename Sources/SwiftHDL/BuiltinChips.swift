public class Or: Chip {
    @Input public var a: Bit
    @Input public var b: Bit
    @Output public var out: Bit
    
    public convenience init<WA: Wire, WB: Wire>(a: WA, b: WB) {
        self.init()
        store {
            a ~> self.$a
            b ~> self.$b
        }
    }
    
    public override func create() {
        connections {
            $a.subject.combineLatest($b.subject)
                .map { (a, b) in a || b }
                .assign(to: \.out, on: self)
        }
    }
}

public class And: Chip {
    @Input public var a: Bit
    @Input public var b: Bit
    @Output public var out: Bit
    
    public convenience init<WA: Wire, WB: Wire>(a: WA, b: WB) {
        self.init()
        store {
            a ~> self.$a
            b ~> self.$b
        }
    }
    
    public override func create() {
        connections {
            $a.subject.combineLatest($b.subject)
                .map { (a, b) in a && b }
                .assign(to: \.out, on: self)
        }
    }
}

public class Not: Chip {
    @Input public var `in`: Bit
    @Output public var out: Bit

    public convenience init<W: Wire>(in: W) {
        self.init()
        store {
            `in` ~> self.$in
        }
    }
    
    public override func create() {
        connections {
            $in.subject.map { !$0 }.assign(to: \.out, on: self)
        }
    }
}


public class Nand: Chip {
    @Input public var a: Bit
    @Input public var b: Bit
    @Output public var out: Bit
    
    public convenience init<W1: Wire, W2: Wire>(a: W1, b: W2) {
        self.init()
        store {
            a ~> self.$a
            b ~> self.$b
        }
    }
    
    public override func create() {
        connections {
            $a.subject.combineLatest($b.subject)
                .map { (a, b) in !(a && b) }
                .assign(to: \.out, on: self)
        }
    }
}
