import XCTest
import SwiftHDL

final class SwiftHDLTests: XCTestCase {
    
    func testAnd() {
        let and = And()

        and.inA = false
        and.inB = false
        XCTAssertFalse(and.out)

        and.inB = true
        XCTAssertFalse(and.out)

        and.inA = true
        and.inB = false
        XCTAssertFalse(and.out)

        and.inB = true
        XCTAssertTrue(and.out)
    }

    func testNot() {
        let not = Not()
        not.input = false
        XCTAssertTrue(not.output)

        not.input = true
        XCTAssertFalse(not.output)
    }

    func testNand() {
        let nand = Nand()
        nand.inA = false
        nand.inB = false
        XCTAssertTrue(nand.out)

        nand.inB = true
        XCTAssertTrue(nand.out)

        nand.inA = true
        XCTAssertFalse(nand.out)

        nand.inB = false
        XCTAssertTrue(nand.out)
    }
}
