import XCTest
@testable import calc

class calcTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(calc().text, "Hello, World!")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
