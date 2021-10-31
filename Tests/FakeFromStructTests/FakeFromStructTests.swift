import XCTest
@testable import FakeFromStruct

final class FakeFromStructTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
//        let target = FakeFromStruct<type(of: TestTargetStruct)>()
        let mirror = Mirror(reflecting: TestTargetStruct.self)
        print(mirror.children)
        var result: [String: Any] = [:]
        for (labelMaybe, valueMaybe) in mirror.children {
            guard let label = labelMaybe else {
                continue
            }
            
            result[label] = type(of: valueMaybe)
        }
        print(result)

        
        print("=============")
        let target = FakeFromStruct.withFakeValues(of: TestTargetStruct.self)

        print(target)
//        XCTAssertEqual(target.name, "Hello, World!")
    }
}

struct TestTargetStruct: Codable {
    var name: String
}
