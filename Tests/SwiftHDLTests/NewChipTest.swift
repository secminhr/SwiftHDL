import Foundation
import XCTest
import SwiftHDL

class NewChipTest: XCTestCase {
    
    class And: Chip {
        @Input var inA: Bit
        @Input var inB: Bit
        @Output var out: Bit
        
        var nand: Nand!
        var not: Not!
        public override func create() {
            nand = Nand($inA, $inB)
            not = Not(nand.$out)
            connections {
                not.$output ~> $out
            }
        }
    }
    
    func testNewAnd() {
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
}
