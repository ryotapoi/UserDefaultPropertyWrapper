import XCTest
import Combine
@testable import UserDefaultPropertyWrapper

struct Settings {
    @UserDefault("int")
    var int: Int = 5
}

struct Other {
    @UserDefault("int")
    var int: Int = 5
}

final class UserDefaultPropertyWrapperTests: XCTestCase {

    var ud: UserDefaults!
    var settings: Settings!
    var other: Other!

    override func setUpWithError() throws {
        ud = UserDefaults.standard
        ud.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        settings = Settings()
        other = Other()
    }
    
    func testInitialValue() {
        XCTAssertEqual(settings.int, 5)
        XCTAssertEqual(settings.int, other.int)
    }
    
    func testSynchronized() {
        settings.int = 10
        XCTAssertEqual(settings.int, 10)
        XCTAssertEqual(settings.int, other.int)
    }

    func testPublisher() {
        var anyCancellables = Set<AnyCancellable>()
        
        var settingsValues = [Int]()
        let settingsExp = expectation(description: "settings")
        settingsExp.expectedFulfillmentCount = 3
        settings.$int.sink { (value) in
            settingsExp.fulfill()
            settingsValues.append(value)
        }
        .store(in: &anyCancellables)

        var otherValues = [Int]()
        let otherExp = expectation(description: "settings")
        otherExp.expectedFulfillmentCount = 3
        other.$int.sink { (value) in
            otherExp.fulfill()
            otherValues.append(value)
        }
        .store(in: &anyCancellables)

        settings.int = 10
        other.int = 20

        wait(for: [settingsExp, otherExp], timeout: 0.1)
        XCTAssertEqual(settingsValues, [5, 10, 20])
        XCTAssertEqual(settingsValues, otherValues)
    }
    
    func testRemoveDuplicates() {
        var anyCancellables = Set<AnyCancellable>()
        
        var settingsValues = [Int]()
        let settingsExp = expectation(description: "settings")
        settingsExp.expectedFulfillmentCount = 3
        settings.$int.sink { (value) in
            settingsExp.fulfill()
            settingsValues.append(value)
        }
        .store(in: &anyCancellables)

        settings.int = 10
        settings.int = 10
        settings.int = 20
        settings.int = 20

        wait(for: [settingsExp], timeout: 0.1)
        XCTAssertEqual(settingsValues, [5, 10, 20])
    }

    static var allTests = [
        ("testInitialValue", testInitialValue),
        ("testSynchronized", testSynchronized),
        ("testPublisher", testPublisher),
        ("testRemoveDuplicates", testRemoveDuplicates),
    ]
}
