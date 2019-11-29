import XCTest
@testable import hanako

final class hanakoTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(hanako().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
