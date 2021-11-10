import XCTest
@testable import FakeFromStruct

final class FakeFromStructTests: XCTestCase {
    func testExample() throws {
        var targetStruct = TestTargetStruct()
        targetStruct = FakeFromStruct.withFakeValues(of: targetStruct)
        
        print(targetStruct)
        //        XCTAssertEqual(target.name, "Hello, World!")
    }
}

struct TestTargetStruct: Codable {
    var name: String = ""
    var code: Int = 0
    var price: Double = 0.0
    // TODO: 再帰的な処理が必要なプロパティをどうするか
    var members: [String] = []
    //    var child: TestChildTargetStruct = TestChildTargetStruct()
    //
    var nameNullable: String?
    var codeNullable: Int?
    var priceNullable: Double?
//    var membersNullable: [String]?
    //    var childNullable:TestChildTargetStruct?
}

struct TestChildTargetStruct: Codable {
    var address: String?
}
