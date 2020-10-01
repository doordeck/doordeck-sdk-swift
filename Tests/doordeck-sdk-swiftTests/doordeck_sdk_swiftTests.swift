import XCTest
@testable import doordeck_sdk_swift

final class doordeck_sdk_swiftTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(doordeck_sdk_swift().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
