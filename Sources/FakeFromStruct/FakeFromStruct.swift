import Fakery
import Foundation

public struct FakeFromStruct<TargetStruct: Decodable> {
    static func withFakeValues(of target: TargetStruct) -> TargetStruct {
        print("====== static func withFakeValues(of target: TargetStruct) -> TargetStruct")
        
        let typeOfProperty = try! allTypeOfProperties(target: target)
        let newValue = dataForAssign(from: typeOfProperty)
        
        let decoder = JSONDecoder()
        guard let resultStruct: TargetStruct = try? decoder.decode(TargetStruct.self, from: newValue) else {
            fatalError("Failed to decode from JSON.")
        }
        
        return resultStruct
    }
    
    static func allTypeOfProperties(target: TargetStruct) throws -> [String: Any?] {
        print("====== static func allTypeOfProperties(target: TargetStruct) throws -> [String: Any]")
        var result: [String: Any?] = [:]
        
        let mirror = Mirror(reflecting: target)
        guard mirror.displayStyle == .struct else {
            throw FakeFromStructError.isNotStruct
        }
        
        for (labelMaybe, valueMaybe) in mirror.children {
            guard let label = labelMaybe else {
                continue
            }
            whichType(of: valueMaybe)
            result[label] = assignDefaultValueToOptional(value: valueMaybe, valueType: String(describing: type(of: valueMaybe)))
        }
        return result
    }
    
    static func whichType(of value: Any) -> String {
        print(">>>>>>>")
        print(value)
        let valueType = String(describing: type(of: value).self)
        print(valueType)
        switch valueType {
        case "String", "Optional<String>":
            print("this is String")
        case "Int", "Optional<Int>":
            print("this is Int")
        case "Double", "Optional<Double>":
            print("this is Double")
        default:
            print("default")
        }
        
        print("<<<<<<<<<")
        return "hoge"
    }
        
    static func assignDefaultValueToOptional(value: Any, valueType: String) -> Any? {
        switch valueType {
        case "Optional<String>":
            return ""
        case "Optional<Int>":
            return 0
        case "Optional<Double>":
            return 0.0
        default:
            return value
        }
    }
    
    static func dataForAssign(from typeOfProperties: [String: Any?]) -> Data {
        var result: Dictionary<String, Any?> = [:]
        let keys = typeOfProperties.keys
        for key in keys {
            result[key] = newValue(value: typeOfProperties[key] ?? nil)
        }
        
        let jsonData = try! JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
        return jsonData
    }
    
    static func newValue(value: Any?) -> Any? {
        // そのうち多言語サポートしたいが、各言語で対応にだいぶ幅がある。
        let faker = Faker(locale: "en")
        
        guard let value = value else {
            return nil
        }
        switch value {
        case is String:
            return faker.lorem.paragraph()
        case is Int:
            return 1234567890
        case is Double:
            return 12345.67890
        case is Array<Any>:
            let array = value as! Array<Any>
            return newValue(value: array.first)
        default:
            return nil
        }
    }
}

enum FakeFromStructError: Error {
    case isNotStruct
}
