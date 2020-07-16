import Foundation
import UserDefaultCompatible

@propertyWrapper
public struct UserDefault<Value> where Value: UserDefaultCompatible, Value: Equatable {
    private let publisher: UserDefaults.Publisher<Value>

    public init(wrappedValue defaultValue: Value, _ key: String, userDefaults: UserDefaultsProtocol = UserDefaults.standard) {
        publisher = .init(key: key, default: defaultValue, userDefaults: userDefaults)
    }

    public var wrappedValue: Value {
        get { publisher.value }
        set { publisher.value = newValue }
    }
    
    public var projectedValue: UserDefaults.Publisher<Value> { publisher }
}
