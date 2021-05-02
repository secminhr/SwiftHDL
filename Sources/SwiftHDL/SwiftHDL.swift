import Combine
import Foundation

public class Chip {
    var cancellables: [AnyCancellable] = []
    public init() {
        create()
    }
    func create() {}
    
    func connections(@ConnectionBuilder _ connect: () -> [AnyCancellable]) {
        cancellables = connect()
    }
}

public class And: Chip {
    @Input public var inA: Bit
    @Input public var inB: Bit
    @Output public var out: Bit
    
    public override init() {
        super.init()
    }
    
    var nand = Nand()
    let not = Not()
    
    override func create() {
//        nand = Nand($inA, $inB)
        connections {
            $inA ~> nand.$inA
            $inB ~> nand.$inB
            nand.$out ~> not.$input
            not.$output ~> $out
//            $inA.send(nand.$inA, onSend: { print("And.inA send to nand.inA") })
//            $inB.send(nand.$inB, onSend: { print("And.inB send to nand.inB") })
//            nand.$out.send(not.$input, onSend: { print("nand.out send to not.input: \($0)") })
//            not.$output.send($out, onSend: { print("not.output send to And.out: \($0)") })
        }
    }
}

public class Not: Chip {
    @Input public var input: Bit
    @Output public var output: Bit

    public override init() {
        super.init()
    }
    
    let nand = Nand()
    override func create() {
        connections {
            $input ~> nand.$inA
            $input ~> nand.$inB
            nand.$out ~> $output
        }
    }
}


public class Nand: Chip {
    @Input public var inA: Bit
    @Input public var inB: Bit
    @Output public var out: Bit
    
    private var cancellable: [AnyCancellable] = []
    
    public init(_ inA: Input, _ inB: Input) {
        super.init()
        cancellable += [
            inA.send(self.$inA, onSend: { print("construct inA send to Nand.inA: \($0)") }),
            inB.send(self.$inB, onSend: { print("construct inB send to Nand.inB: \($0)") })
        ]
        cancellable.append(connection())
    }
    
    override public init() {
        super.init()
        cancellable.append(connection())
    }
    
    private func connection() -> AnyCancellable {
        Publishers.CombineLatest($inA.subject, $inB.subject)
            .map { (a, b) -> Bit in
                return a == .one && b == .one ? .zero : .one
            }.sink {
                self.out = $0
            }
    }
}

public enum Bit: Int {
    case zero = 0
    case one = 1
}




@propertyWrapper
public class Input {
    fileprivate let subject: PassthroughSubject<Bit, Never>
    
    public init() {
        subject = PassthroughSubject()
    }
    
    public var wrappedValue: Bit {
        set { subject.send(newValue) }
        get { fatalError("Should not get from input.") }
    }
    
    public var projectedValue: Input {
        return self
    }
    
    static func ~> (left: Input, right: Input) -> AnyCancellable {
        left.subject.sink(receiveValue: right.subject.send)
    }
    
    
    func send(_ right: Input, onSend: @escaping (Bit) -> Void) -> AnyCancellable {
        return subject.sink {
            onSend($0)
            right.subject.send($0)
        }
    }
}

@propertyWrapper
public class Output {
    fileprivate let subject: CurrentValueSubject<Bit, Never>
    
    public convenience init () {
        self.init(wrappedValue: Bit.zero)
    }
    
    public init(wrappedValue: Bit) {
        subject = CurrentValueSubject(wrappedValue)
    }
    
    public var wrappedValue: Bit {
        set { subject.send(newValue) }
        get { subject.value }
    }
    
    public var projectedValue: Output {
        return self
    }
    
    static func ~> (left: Output, right: Output) -> AnyCancellable {
        left.subject.sink(receiveValue: right.subject.send)
    }
    
    static func ~> (left: Output, right: Input) -> AnyCancellable {
        left.subject.sink(receiveValue: right.subject.send)
    }
    
    func send(_ right: Output, onSend: @escaping (Bit) -> Void) -> AnyCancellable {
        return subject.sink {
            onSend($0)
            right.subject.send($0)
        }
    }
    
    func send(_ right: Input, onSend: @escaping (Bit) -> Void) -> AnyCancellable {
        return subject.sink {
            onSend($0)
            right.subject.send($0)
        }
    }
}

@_functionBuilder
struct ConnectionBuilder {
    static func buildBlock(_ cancellables: AnyCancellable...) -> [AnyCancellable] {
        return cancellables
    }
}
