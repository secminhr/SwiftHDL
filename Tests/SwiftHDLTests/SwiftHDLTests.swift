import XCTest
@testable import SwiftHDL

final class SwiftHDLTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SwiftHDL().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
