import XCTest
@testable import UbicolorKit

final class UbicolorKitTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(UbicolorKit().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
