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


@resultBuilder
public struct ConnectionBuilder {
    public static func buildBlock(_ cancellables: AnyCancellable...) -> [AnyCancellable] {
        return cancellables
    }
}
