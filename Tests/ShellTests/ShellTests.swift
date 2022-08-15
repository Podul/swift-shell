import XCTest
@testable import Shell

final class swift_shellTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        
        Shell().exec(["ls", "-all"])
        Shell().exec("ls -all ~/Desktop/t     t")
    }
}
