import XCTest
import SwiftHDL

final class SwiftHDLTests: XCTestCase {
    
    func testAnd() {
        let and = And()

        and.inA = .zero
        and.inB = .zero
        assert(and.out == .zero)

        and.inB = .one
        assert(and.out == .zero)

        and.inA = .one
        and.inB = .zero
        assert(and.out == .zero)

        and.inB = .one
        assert(and.out == .one)
    }

    func testNot() {
        let not = Not()
        not.input = .zero
        assert(not.output == .one)

        not.input = .one
        assert(not.output == .zero)
    }

    func testNand() {
        let nand = Nand()
        nand.inA = .zero
        nand.inB = .zero
        assert(nand.out == .one)

        nand.inB = .one
        assert(nand.out == .one)

        nand.inA = .one
        assert(nand.out == .zero)

        nand.inB = .zero
        assert(nand.out == .one)
    }
}
