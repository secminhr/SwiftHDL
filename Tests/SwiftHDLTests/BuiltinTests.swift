import XCTest
import SwiftHDL

final class SwiftHDLTests: XCTestCase {
    
    @Input var andInA: Bit
    @Input var andInB: Bit
    func testAnd() {
        let and = And($andInA, $andInB)

        andInA = false
        andInB = false
        XCTAssertFalse(and.out)

        andInB = true
        XCTAssertFalse(and.out)

        andInA = true
        andInB = false
        XCTAssertFalse(and.out)

        andInB = true
        XCTAssertTrue(and.out)
    }

    @Input var notIn: Bit
    func testNot() {
        let not = Not($notIn)
        notIn = false
        XCTAssertTrue(not.output)

        notIn = true
        XCTAssertFalse(not.output)
    }

    @Input var nandInA: Bit
    @Input var nandInB: Bit
    func testNand() {
        let nand = Nand($nandInA, $nandInB)
        nandInA = false
        nandInB = false
        XCTAssertTrue(nand.out)

        nandInB = true
        XCTAssertTrue(nand.out)

        nandInA = true
        XCTAssertFalse(nand.out)

        nandInB = false
        XCTAssertTrue(nand.out)
    }
}
