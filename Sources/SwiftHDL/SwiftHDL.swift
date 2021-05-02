import Combine
import Foundation

public typealias Bit = Bool

open class Chip {
    var cancellables: [AnyCancellable] = []
    public init() {
        create()
    }
    open func create() {}
    
    public func connections(@ConnectionBuilder _ connect: () -> [AnyCancellable]) {
        store(connect)
    }
    
    func store(@ConnectionBuilder _ connections: () -> [AnyCancellable]) {
        cancellables += connections()
    }
}

public class And: Chip {
    @Input public var inA: Bit
    @Input public var inB: Bit
    @Output public var out: Bit
    
    public override init() {
        super.init()
    }
    
    var nand: Nand!
    var not: Not!
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

    public override init() {
        super.init()
    }
    
    public init(_ input: Output) {
        super.init()
        store {
            input ~> self.$input
        }
    }
    
    var nand: Nand!
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
    
    public init(_ inA: Input, _ inB: Input) {
        super.init()
        store {
            inA ~> self.$inA
            inB ~> self.$inB
        }
    }
    
    override public init() {
        super.init()
    }
    
    public override func create() {
        connections {
            $inA.subject.combineLatest($inB.subject)
                .map { (a, b) -> Bit in !(a && b) }
                .assign(to: \.out, on: self)
        }
    }
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
    
    public static func ~> (left: Input, right: Input) -> AnyCancellable {
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
        self.init(wrappedValue: false)
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
    
    public static func ~> (left: Output, right: Output) -> AnyCancellable {
        left.subject.sink(receiveValue: right.subject.send)
    }
    
    public static func ~> (left: Output, right: Input) -> AnyCancellable {
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

@resultBuilder
public struct ConnectionBuilder {
    public static func buildBlock(_ cancellables: AnyCancellable...) -> [AnyCancellable] {
        return cancellables
    }
}
