# UserDefaultPropertyWrapper

Property Wrapper that provides read and write access to UserDefaults.

## Sample

```swift
import UserDefaultCompatible
import UserDefaultPropertyWrapper

struct User : Codable, UserDefaultCompatible {
    var name: String
}

class Record : NSObject, NSCoding, UserDefaultCompatible {
    var name: String? = "abc"

    init(name: String?) {
        self.name = name
    }
    required init?(coder: NSCoder) {
        name = coder.decodeObject(forKey: "name") as? String
    }

    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
    }
}

struct Settings {

    @UserDefault("user", default: User(name: "abc"))
    var user: User

    @UserDefault("userOptional", default: nil)
    var userOptional: User?

    @UserDefault("users", default: [])
    var users: [User]

    @UserDefault("userArrayOptional", default: nil)
    var userArrayOptional: [User]?

    @UserDefault("userDictionary", default: [:])
    var userDictionary: [String: User]

    @UserDefault("userDictionaryOptional", default: nil)
    var userDictionaryOptional: [String: User]?

    @UserDefault("int", default: 5)
    var int: Int

    @UserDefault("intOptional", default: nil)
    var intOptional: Int?

    @UserDefault("doubleValue", default: 23.56)
    var doubleValue: Double

    @UserDefault("doubleValueOptional", default: nil)
    var doubleValueOptional: Double?

    @UserDefault("floatValue", default: 1.23)
    var floatValue: Float

    @UserDefault("floatValueOptional", default: nil)
    var floatValueOptional: Float?

    @UserDefault("bool", default: true)
    var bool: Bool

    @UserDefault("boolOptional", default: nil)
    var boolOptional: Bool?

    @UserDefault("string", default: "defaultString")
    var string: String

    @UserDefault("stringOptional", default: nil)
    var stringOptional: String?

    @UserDefault("url", default: URL(string: "https://goocle.com")!)
    var url: URL

    @UserDefault("urlOptional", default: nil)
    var urlOptional: URL?

    @UserDefault("date", default: Date(timeIntervalSinceReferenceDate: 0))
    var date: Date

    @UserDefault("dateOptional", default: nil)
    var dateOptional: Date?

    @UserDefault("data", default: Data())
    var data: Data

    @UserDefault("dataOptional", default: nil)
    var dataOptional: Data?

    @UserDefault("record", default: Record(name: "default record name"))
    var record: Record

    @UserDefault("recordOptional", default: nil)
    var recordOptional: Record?

}

```
