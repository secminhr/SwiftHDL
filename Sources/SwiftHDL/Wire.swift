import Combine

public protocol Wire {
    associatedtype SubjectType: Subject where SubjectType.Output == Bit, SubjectType.Failure == Never
    var subjectContainer: SubjectContainer<SubjectType> { get }
}

extension Wire {
    public static func ~><W: Wire> (left: Self, right: W) -> AnyCancellable {
        left.subjectContainer.sink(receiveValue: right.subjectContainer.send)
    }
}

//Use wrapper class to avoid leaking subject out of module
public class SubjectContainer<S: Subject> where S.Output == Bit, S.Failure == Never {
    private var subject: S
    
    fileprivate init(_ subject: S) {
        self.subject = subject
    }
    
    fileprivate func sink(receiveValue receive: @escaping (Bit) -> Void) -> AnyCancellable {
        subject.sink(receiveValue: receive)
    }
    
    fileprivate func send(_ value: Bit) {
        subject.send(value)
    }
}

@propertyWrapper
public class Input: Wire {
    
    internal let subject = PassthroughSubject<Bit, Never>()
    public let subjectContainer: SubjectContainer<PassthroughSubject<Bit, Never>>
    
    public init() {
        subjectContainer = SubjectContainer(subject)
    }
    
    public var wrappedValue: Bit {
        set { subjectContainer.send(newValue) }
        get { fatalError("Should not get from input.") }
    }
    
    public var projectedValue: Input { self }
}


@propertyWrapper
public class Output: Wire {
    
    internal let subject: CurrentValueSubject<Bit, Never>
    public let subjectContainer: SubjectContainer<CurrentValueSubject<Bit, Never>>
    
    public convenience init () {
        self.init(wrappedValue: false)
    }
    
    public init(wrappedValue: Bit) {
        subject = CurrentValueSubject(wrappedValue)
        subjectContainer = SubjectContainer(subject)
    }
    
    public var wrappedValue: Bit {
        set { subjectContainer.send(newValue) }
        get { subjectContainer.value }
    }
    
    public var projectedValue: Output { self }
}

extension SubjectContainer where S == CurrentValueSubject<Bit, Never> {
    fileprivate var value: Bit { subject.value }
}
