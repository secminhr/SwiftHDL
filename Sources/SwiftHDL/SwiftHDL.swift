import Combine

public typealias Bit = Bool

open class Chip {
    private var cancellables: [AnyCancellable] = []
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

#if swift(>=5.4)
@resultBuilder
public struct ConnectionBuilder {
    public static func buildBlock(_ cancellables: AnyCancellable...) -> [AnyCancellable] {
        return cancellables
    }
}
#else
@_functionBuilder
public struct ConnectionBuilder {
    public static func buildBlock(_ cancellables: AnyCancellable...) -> [AnyCancellable] {
        return cancellables
    }
}
#endif
