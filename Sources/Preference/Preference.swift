//
// MIT License
//
// Copyright (c) 2022 Junfeng Zhang and the Preference project authors
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import Foundation

#if canImport(Combine)
  @_exported import Combine
#else
  @_exported import OpenCombine
#endif

@available(
  *, deprecated,
  message: "This will be removed in the next major version, please use String instead"
)
extension UserDefaults {

  /// UserDefaults field key.
  @available(
    *, deprecated,
    message: "This will be removed in the next major version, please use String instead"
  )
  public struct FieldKey: RawRepresentable {

    public typealias RawValue = String

    public var rawValue: String

    public init(rawValue: String) {
      self.rawValue = rawValue
    }
  }

  /// UserDefaults DefaultName
  @available(
    *, deprecated, renamed: "FieldKey",
    message: "This will be removed in the next major version, please use String instead"
  )
  public typealias DefaultName = FieldKey
}

@available(
  *, deprecated,
  message: "This will be removed in the next major version, please use String instead"
)
extension UserDefaults.FieldKey: ExpressibleByStringLiteral {

  @available(
    *, deprecated,
    message: "This will be removed in the next major version, please use String instead"
  )
  public init(stringLiteral value: StringLiteralType) {
    self.init(rawValue: value)
  }
}

#if swift(>=5.5) && canImport(_Concurrency)
  @available(
    *, deprecated,
    message: "This will be removed in the next major version, please use String instead"
  )
  extension UserDefaults.FieldKey: Sendable {}
#endif

/// A property wrapper type that reflects a value from `UserDefaults`
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@propertyWrapper public struct Preference<Value> where Value: PreferenceRepresentable {

  private let publisher: Publisher<Value>

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
  @available(
    *, deprecated,
    message:
      "This will be removed in the next major version, please use init(wrappedValue:_:store:) with String key instead"
  )
  public init(wrappedValue: Value, _ key: UserDefaults.FieldKey, store: UserDefaults? = nil) {
    self.init(wrappedValue: wrappedValue, key.rawValue, store: store)
  }

  public var wrappedValue: Value {
    get { publisher.value }
    set { publisher.value = newValue }
  }

  #if canImport(Combine)
    public var projectedValue: some Combine.Publisher<Value, Never> { publisher }
  #else
    public var projectedValue: some OpenCombine.Publisher<Value, Never> { publisher }
  #endif
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
  @available(
    *, deprecated,
    message:
      "This will be removed in the next major version, please use init(_:store:) with String key instead"
  )
  public init<O>(_ key: UserDefaults.FieldKey, store: UserDefaults? = nil) where Value == O? {
    self.init(key.rawValue, store: store)
  }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Preference {

  @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
  final class Publisher<Output>: NSObject where Output: PreferenceRepresentable {

    public typealias Failure = Never

    private let key: String
    private let store: UserDefaults
    private let subject: CurrentValueSubject<Output, Failure>
    private let wrappedValue: Output

    public var value: Output {
      get { subject.value }
      set {
        store.set(newValue.preferenceValue, forKey: key)
        // Non Darwin platform does not support KVO, so we direct update subject value.
        #if !canImport(Darwin)
          subject.value = newValue
        #endif
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
    public init(wrappedValue: Output, _ key: String, store: UserDefaults? = nil) {
      assert(
        !key.contains("."), "Do not use keys containing dots for UserDefaults KVO to work properly."
      )

      self.key = key
      self.store = store ?? .standard
      self.wrappedValue = wrappedValue

      if let val = self.store.object(forKey: key) {
        self.subject = .init(Output(preferenceValue: val) ?? wrappedValue)
      } else {
        self.subject = .init(wrappedValue)
      }

      super.init()
      #if canImport(Darwin)
        self.store.addObserver(self, forKeyPath: key, options: .new, context: nil)
      #endif
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
    @available(
      *, deprecated,
      message:
        "This will be removed in the next major version, please use init(wrappedValue:_:store:) with String key instead"
    )
    public convenience init(
      wrappedValue: Output, _ key: UserDefaults.FieldKey, store: UserDefaults? = nil
    ) {
      self.init(wrappedValue: wrappedValue, key.rawValue, store: store)
    }

    /// Creates a publisher that publish the current value for a user default.
    ///
    /// - Parameters:
    ///   - key: The key to read and write the value to in the user defaults
    ///     store.
    ///   - store: The user defaults store to read and write to. A value
    ///     of `nil` will use the user default store from the environment.
    public init<O>(_ key: String, store: UserDefaults? = nil) where Output == O? {
      assert(
        !key.contains("."), "Do not use keys containing dots for UserDefaults KVO to work properly."
      )

      self.key = key
      self.store = store ?? .standard
      self.wrappedValue = nil

      if let val = self.store.object(forKey: key) {
        self.subject = .init(O(preferenceValue: val))
      } else {
        self.subject = .init(wrappedValue)
      }

      super.init()
      #if canImport(Darwin)
        self.store.addObserver(self, forKeyPath: key, options: .new, context: nil)
      #endif
    }

    /// Creates a publisher that publish the current value for a user default.
    ///
    /// - Parameters:
    ///   - key: The key to read and write the value to in the user defaults
    ///     store.
    ///   - store: The user defaults store to read and write to. A value
    ///     of `nil` will use the user default store from the environment.
    @available(
      *, deprecated,
      message:
        "This will be removed in the next major version, please use init(_:store:) with String key instead"
    )
    public convenience init<O>(_ key: UserDefaults.FieldKey, store: UserDefaults? = nil)
    where Output == O? {
      self.init(key.rawValue, store: store)
    }

    #if canImport(Darwin)
      deinit {
        store.removeObserver(self, forKeyPath: key)
      }

      public override func observeValue(
        forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?,
        context: UnsafeMutableRawPointer?
      ) {
        guard keyPath == key else {
          super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
          return
        }

        // If value changed to nil fallback to default value.
        guard let object = change?[.newKey] else {
          self.subject.value = wrappedValue
          return
        }
        let newValue = Output(preferenceValue: object)

        subject.value = newValue ?? wrappedValue
      }
    #endif
  }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Preference.Publisher: Publisher {

  func receive<S>(
    subscriber: S
  ) where S: Subscriber, Failure == S.Failure, Output == S.Input {
    // Remove duplicated elements
    switch Output.self {
    case is Bool.Type, is Bool?.Type:
      subject.removeDuplicates { lhs, rhs in
        (lhs as? Bool) == (rhs as? Bool)
      }
      .receive(subscriber: subscriber)
    case is Int.Type, is Int?.Type:
      subject.removeDuplicates { lhs, rhs in
        (lhs as? Int) == (rhs as? Int)
      }
      .receive(subscriber: subscriber)
    case is Double.Type, is Double?.Type:
      subject.removeDuplicates { lhs, rhs in
        (lhs as? Double) == (rhs as? Double)
      }
      .receive(subscriber: subscriber)
    case is Float.Type, is Float?.Type:
      subject.removeDuplicates { lhs, rhs in
        (lhs as? Float) == (rhs as? Float)
      }
      .receive(subscriber: subscriber)
    case is String.Type, is String?.Type:
      subject.removeDuplicates { lhs, rhs in
        (lhs as? String) == (rhs as? String)
      }
      .receive(subscriber: subscriber)
    case is URL.Type, is URL?.Type:
      subject.removeDuplicates { lhs, rhs in
        (lhs as? URL) == (rhs as? URL)
      }
      .receive(subscriber: subscriber)
    case is Data.Type, is Data?.Type:
      subject.removeDuplicates { lhs, rhs in
        (lhs as? Data) == (rhs as? Data)
      }
      .receive(subscriber: subscriber)
    case is Date.Type, is Date?.Type:
      subject.removeDuplicates { lhs, rhs in
        (lhs as? Date) == (rhs as? Date)
      }
      .receive(subscriber: subscriber)
    default:
      subject.receive(subscriber: subscriber)
    }
  }
}

#if swift(>=5.5) && canImport(_Concurrency)
  @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
  extension Preference: @unchecked Sendable where Value: Sendable {}

  @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
  extension Preference.Publisher: @unchecked Sendable where Value: Sendable {}
#endif
