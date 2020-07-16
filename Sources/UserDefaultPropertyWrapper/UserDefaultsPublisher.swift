import Foundation
import Combine
import UserDefaultCompatible

extension UserDefaults {
    public class Publisher<Output>: NSObject, Combine.Publisher where Output: UserDefaultCompatible, Output: Equatable {
        public typealias Failure = Never
        
        private let key: String
        private let defaultValue: Output
        private let userDefaults: UserDefaultsProtocol
        private let subject: CurrentValueSubject<Output, Never>

        public var value: Output {
            get { subject.value }
            set {
                if newValue != subject.value {
                    subject.value = newValue
                    userDefaults.setValue(newValue, forKey: key)
                }
            }
        }

        public init(key: String, default defaultValue: Output, userDefaults: UserDefaultsProtocol = UserDefaults.standard) {
            self.key = key
            self.defaultValue = defaultValue
            self.userDefaults = userDefaults
            self.subject = .init(userDefaults.value(type: Output.self, forKey: key, default: defaultValue))
            super.init()
            userDefaults.addObserver(self, forKeyPath: key, options: .new, context: nil)
        }
        
        deinit {
            userDefaults.removeObserver(self, forKeyPath: key)
        }
        
        public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
            if keyPath == key {
                let newValue = change?[.newKey]
                    .flatMap(Output.init(userDefaultObject:))
                    ?? defaultValue
                if newValue != subject.value {
                    subject.value = newValue
                }
            }
        }

        public func receive<S>(
            subscriber: S
        ) where S: Combine.Subscriber, Failure == S.Failure, Output == S.Input {
            subject.receive(subscriber: subscriber)
        }
    }
}
