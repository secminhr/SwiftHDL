import Foundation
import XCTest
import SwiftHDL

class NewChipTest: XCTestCase {
    
    class And: Chip {
        @Input var a: Bit
        @Input var b: Bit
        @Output var out: Bit
        
        public override func create() {
            let nand = Nand(a: $a, b: $b)
            let not = Not(in: nand.$out)
            connections {
                not.$out ~> $out
            }
        }
    }
    
    func testNewAnd() {
        let and = And()

        and.a = false
        and.b = false
        XCTAssertFalse(and.out)

        and.b = true
        XCTAssertFalse(and.out)

        and.a = true
        and.b = false
        XCTAssertFalse(and.out)

        and.b = true
        XCTAssertTrue(and.out)
    }
    
    class Xor: Chip {
        @Input var a: Bit
        @Input var b: Bit
        @Output var out: Bit
        
        public override func create() {
            let notA = Not(in: $a)
            let notB = Not(in: $b)
            let w1 = SwiftHDL.And(a: $a, b: notB.$out)
            let w2 = SwiftHDL.And(a: notA.$out, b: $b)
            let or = Or(a: w1.$out, b: w2.$out)
            connections {
                or.$out ~> $out
            }
        }
    }
    
    func testXor() {
        let xor = Xor()

        xor.a = false
        xor.b = false
        XCTAssertFalse(xor.out)

        xor.b = true
        XCTAssertTrue(xor.out)

        xor.a = true
        xor.b = false
        XCTAssertTrue(xor.out)

        xor.b = true
        XCTAssertFalse(xor.out)
    }
//    
//    class Not4: Chip {
//        @Input private var in1: Bit
//        @Input private var in2: Bit
//        @Input private var in3: Bit
//        @Input private var in4: Bit
//        
//        @Output private var out1: Bit
//        @Output private var out2: Bit
//        @Output private var out3: Bit
//        @Output private var out4: Bit
//        
//        var inBus:[Input] = [$in1, $in2, $in3, $in4]
//        var outBus:[Output] = [out1, out2, out3, out4]
//        
//        override init() {
//            super.init()
//            
//        }
//        
//        override func create() {
//            
//        }
//    }
}
