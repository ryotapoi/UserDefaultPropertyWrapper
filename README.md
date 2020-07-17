# UserDefaultPropertyWrapper

@UserDefault automatically synchronizes the values of UserDefaults.
And it provides the `Combine.Publisher`.

## Swift Package Manager

```Package.swift
dependencies: [
    .package(url: "https://github.com/ryotapoi/UserDefaultPropertyWrapper.git", "2.0.0"..<"3.0.0"),
],
```

## Sample

```swift
import UserDefaultCompatible
import UserDefaultPropertyWrapper

// Codable
struct User: Codable, Equatable, UserDefaultCompatible {
    var name: String
}

// NSCoding
class Record: NSObject, NSCoding, UserDefaultCompatible {
    var name: String? = "abc"
    // ...
}

struct First {
    @UserDefault("number")
    var number: Int = 10

    @UserDefault("user")
    var user: User = User(name: "name")
    
    @UserDefault("record")
    var record: Record = Record(name: "name")

    @UserDefault("optionalNumber")
    var optionalNumber: Int? = nil

    @UserDefault("userArray")
    var userArray: [User] = [User(name: "first"), User(name: "second")]
    
    @UserDefault("recordDictionary")
    var recordDictionary: [String: Record] = ["key1": Record(name: "first"), "key2": Record(name: "second")]

}

struct Second {
    @UserDefault("number")
    var number: Int = 10
}

var first = First()
var second = Second()

// Combine.Publisher
first.$number.sink { print(#line, $0) }

// Synchronized
first.number = 20
first.number // => 20
second.number // => 20

second.number = 30
first.number // => 30
second.number // => 30

let publisher = Publishers.Sequence<[Int], Never>(sequence: [40, 50, 60])
let cancelable = publisher.assign(to: \.value, on: first.$number)
first.number // => 60
second.number // => 60
```
