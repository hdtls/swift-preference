//
//  Preference.swift
//
//  Copyright (c) 2022 Junfeng Zhang
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Combine
import Foundation

extension UserDefaults {
    
    /// UserDefaults DefaultName
    public struct DefaultName: RawRepresentable {
        
        public typealias RawValue = String
        
        public var rawValue: String
        
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
    }
}

extension UserDefaults.DefaultName: ExpressibleByStringLiteral {
    
    public init(stringLiteral value: StringLiteralType) {
        self.init(rawValue: value)
    }
}

/// A property wrapper type that reflects a value from `UserDefaults`
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@propertyWrapper
public struct Preference<Value> where Value: PreferenceRepresentable {
    
    private let publisher: Publisher
    
    /// Creates a property that can read and write to a raw representable user default.
    ///
    /// - Parameters:
    ///   - wrappedValue: The default value if  value is not specified
    ///     for the given key.
    ///   - key: The key to read and write the value to in the user defaults
    ///     store.
    ///   - store: The user defaults store to read and write to. A value
    ///     of `nil` will use the user default store from the environment.
    public init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil) {
        publisher = .init(wrappedValue: wrappedValue, key, store: store)
    }
    
    /// Creates a property that can read and write to a raw representable user default.
    ///
    /// - Parameters:
    ///   - wrappedValue: The default value if  value is not specified
    ///     for the given key.
    ///   - key: The key to read and write the value to in the user defaults
    ///     store.
    ///   - store: The user defaults store to read and write to. A value
    ///     of `nil` will use the user default store from the environment.
    public init(wrappedValue: Value, _ key: UserDefaults.DefaultName, store: UserDefaults? = nil) {
        publisher = .init(wrappedValue: wrappedValue, key.rawValue, store: store)
    }
    
    public var wrappedValue: Value {
        get { publisher.value }
        nonmutating set { publisher.value = newValue }
    }
    
    public var projectedValue: Publisher { publisher }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Preference where Value: ExpressibleByNilLiteral {
    
    /// Creates a property that can read and write to a raw representable user default.
    ///
    /// - Parameters:
    ///   - key: The key to read and write the value to in the user defaults
    ///     store.
    ///   - store: The user defaults store to read and write to. A value
    ///     of `nil` will use the user default store from the environment.
    public init<O>(_ key: String, store: UserDefaults? = nil) where Value == O? {
        publisher = .init(key, store: store)
    }
    
    /// Creates a property that can read and write to a raw representable user default.
    ///
    /// - Parameters:
    ///   - key: The key to read and write the value to in the user defaults
    ///     store.
    ///   - store: The user defaults store to read and write to. A value
    ///     of `nil` will use the user default store from the environment.
    public init<O>(_ key: UserDefaults.DefaultName, store: UserDefaults? = nil) where Value == O? {
        publisher = .init(key.rawValue, store: store)
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Preference {
    
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public class Publisher: NSObject, Combine.Publisher {
        
        public typealias Output = Value
        public typealias Failure = Never
        
        private let key: String
        private let store: UserDefaults
        private let subject: CurrentValueSubject<Output, Failure>
        private let wrappedValue: Value
        
        public var value: Value {
            get { subject.value }
            set {
                subject.value = newValue
                store.set(newValue.preferenceValue, forKey: key)
            }
        }
        
        /// Creates a publisher that publish the current value for a user default.
        ///
        /// - Parameters:
        ///   - wrappedValue: The default value if a value is not specified
        ///     for the given key.
        ///   - key: The key to read and write the value to in the user defaults
        ///     store.
        ///   - store: The user defaults store to read and write to. A value
        ///     of `nil` will use the user default store from the environment.
        public init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil) {
            self.key = key
            self.store = store ?? .standard
            self.wrappedValue = wrappedValue
            
            if let val = self.store.object(forKey: key) {
                self.subject = .init(Value(preferenceValue: val) ?? wrappedValue)
            } else {
                self.subject = .init(wrappedValue)
            }
            
            super.init()
            self.store.addObserver(self, forKeyPath: key, options: .new, context: nil)
        }
        
        /// Creates a publisher that publish the current value for a user default.
        ///
        /// - Parameters:
        ///   - wrappedValue: The default value if a value is not specified
        ///     for the given key.
        ///   - key: The key to read and write the value to in the user defaults
        ///     store.
        ///   - store: The user defaults store to read and write to. A value
        ///     of `nil` will use the user default store from the environment.
        public init(wrappedValue: Value, _ key: UserDefaults.DefaultName, store: UserDefaults? = nil) {
            self.key = key.rawValue
            self.store = store ?? .standard
            self.wrappedValue = wrappedValue
            
            if let val = self.store.object(forKey: key.rawValue) {
                self.subject = .init(Value(preferenceValue: val) ?? wrappedValue)
            } else {
                self.subject = .init(wrappedValue)
            }
            
            super.init()
            self.store.addObserver(self, forKeyPath: key.rawValue, options: .new, context: nil)
        }
        
        /// Creates a publisher that publish the current value for a user default.
        ///
        /// - Parameters:
        ///   - key: The key to read and write the value to in the user defaults
        ///     store.
        ///   - store: The user defaults store to read and write to. A value
        ///     of `nil` will use the user default store from the environment.
        public init<O>(_ key: String, store: UserDefaults? = nil) where Value == O? {
            self.key = key
            self.store = store ?? .standard
            self.wrappedValue = nil
            
            if let val = self.store.object(forKey: key) {
                self.subject = .init(O(preferenceValue: val))
            } else {
                self.subject = .init(wrappedValue)
            }
            
            super.init()
            self.store.addObserver(self, forKeyPath: key, options: .new, context: nil)
        }
        
        /// Creates a publisher that publish the current value for a user default.
        ///
        /// - Parameters:
        ///   - key: The key to read and write the value to in the user defaults
        ///     store.
        ///   - store: The user defaults store to read and write to. A value
        ///     of `nil` will use the user default store from the environment.
        public init<O>(_ key: UserDefaults.DefaultName, store: UserDefaults? = nil) where Value == O? {
            self.key = key.rawValue
            self.store = store ?? .standard
            self.wrappedValue = nil
            
            if let val = self.store.object(forKey: key.rawValue) {
                self.subject = .init(O(preferenceValue: val))
            } else {
                self.subject = .init(wrappedValue)
            }
            
            super.init()
            self.store.addObserver(self, forKeyPath: key.rawValue, options: .new, context: nil)
        }
        
        deinit {
            store.removeObserver(self, forKeyPath: key)
        }
        
        public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            guard keyPath == key else {
                super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
                return
            }
            
            // If value changed to nil fallback to default value.
            guard let object = change?[.newKey] else {
                self.subject.value = wrappedValue
                return
            }
            
            self.subject.value = Value(preferenceValue: object) ?? wrappedValue
        }
        
        public func receive<S>(
            subscriber: S
        ) where S: Combine.Subscriber, Failure == S.Failure, Output == S.Input {
            subject.receive(subscriber: subscriber)
        }
    }
}
