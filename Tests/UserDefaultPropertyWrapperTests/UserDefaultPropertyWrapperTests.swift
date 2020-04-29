import XCTest
@testable import UserDefaultPropertyWrapper

struct Settings {
    @UserDefault("int", default: 5)
    var int: Int
    @UserDefault("optionalInt", default: nil)
    var optionalInt: Int?
}

final class UserDefaultPropertyWrapperTests: XCTestCase {

    var ud: UserDefaults!
    var settings: Settings!

    override func setUpWithError() throws {
        ud = UserDefaults.standard
        let keys = ud.dictionaryRepresentation().keys
        keys.forEach(ud.removeObject(forKey:))
        settings = Settings()
    }

    func testUserDefault() {
        XCTAssertEqual(settings.int, 5)
        settings.int = 10
        XCTAssertEqual(settings.int, 10)
    }

    func testOptionalUserDefault() {
        XCTAssertEqual(settings.optionalInt, nil)
        settings.optionalInt = 10
        XCTAssertEqual(settings.optionalInt, 10)
    }

    static var allTests = [
        ("testUserDefault", testUserDefault),
        ("testOptionalUserDefault", testOptionalUserDefault),
    ]
}
