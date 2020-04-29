import Foundation
import UserDefaultCompatible

@propertyWrapper
public struct UserDefault<Value : UserDefaultCompatible> {
    private let key: String
    private let defaultValue: Value

    public init(_ key: String, default defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }

    public var wrappedValue: Value {
        get {
            UserDefaults.standard.value(type: Value.self, forKey: key, default: defaultValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: key)
        }
    }
}
