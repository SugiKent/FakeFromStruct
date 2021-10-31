import Fakery

public struct FakeFromStruct<TargetStruct> {
    let faker = Faker(locale: "ja")
    public private(set) var text = "Hello, World!"
    
//    public init(target: TargetStruct) {
//        print(faker.name.firstName())
//        let typeOfProperties = try! allTypeOfProperties(target: target)
//        print(target)
//    }
    
    static func withFakeValues(of target: TargetStruct) -> TargetStruct {
        print("static func fakeValues(target: TargetStruct) -> TargetStruct")
        dump(target)
        print(type(of: target))
        
        let mirror = Mirror(reflecting: target)
        print(mirror.displayStyle)
        print(mirror.children)
        
        let _ = try! allTypeOfProperties(target: target)
        
        return target
//        TargetStruct()
    }
    
    static func allTypeOfProperties(target: TargetStruct) throws -> [String: Any] {
        print("static func allTypeOfProperties(target: TargetStruct) throws -> [String: Any]")
        var result: [String: Any] = [:]
        
        let mirror = Mirror(reflecting: target)
        
        print(mirror.displayStyle == .struct)
        guard mirror.displayStyle == .struct else {
            throw FakeFromStructError.isNotStruct
        }
        
        for (labelMaybe, valueMaybe) in mirror.children {
            guard let label = labelMaybe else {
                continue
            }
            
            result[label] = type(of: valueMaybe)
        }
        print(result)
        return result
    }
    
    func assignFakeValue(target: Codable, typeOfProperties: [String: Any]) {
        print(target)
    }
}

enum FakeFromStructError: Error {
    case isNotStruct
}
