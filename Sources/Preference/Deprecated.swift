//
// MIT License
//
// Copyright (c) 2025 Junfeng Zhang and the Preference project authors
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

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Preference {

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
extension Preference.Publisher {

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
  @available(
    *, deprecated,
    message:
      "This will be removed in the next major version, please use init(_:store:) with String key instead"
  )
  public convenience init<O>(_ key: UserDefaults.FieldKey, store: UserDefaults? = nil)
  where Output == O? {
    self.init(key.rawValue, store: store)
  }
}
