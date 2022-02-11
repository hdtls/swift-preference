//
//  PreferenceRepresentable.swift
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

import Foundation

/// A type that can be converted to and from an associated preference value.
public protocol PreferenceRepresentable {
    
    /// Initialize an `PreferenceRepresentable` instance with specified preference value.
    ///
    /// If there is no value of the type that corresponds with the specified preference value,
    /// this initializer returns `nil`. For example:
    ///
    ///     print(Bool(preferenceValue: ["Illegal"]))
    ///     // Prints "nil"
    init?(preferenceValue: Any)
    
    /// The corresponding value of the preference type.
    var preferenceValue: Any? { get }
}

extension Bool: PreferenceRepresentable {
    
    public init?(preferenceValue: Any) {
        switch preferenceValue {
            case let val as Bool:
                self = val
            case let val as Int:
                self = val != 0
            case let val as Float:
                self = val != 0
            case let val as Double:
                self = val != 0
            case let val as String:
                self = NSString(string: val).boolValue
            default:
                return nil
        }
    }
    
    public var preferenceValue: Any? {
        self
    }
}

extension Int: PreferenceRepresentable {
    
    public init?(preferenceValue: Any) {
        switch preferenceValue {
            case let val as Int:
                self = val
            case let val as String:
                self = NSString(string: val).integerValue
            default:
                return nil
        }
    }
    
    public var preferenceValue: Any? {
        self
    }
}

extension Double: PreferenceRepresentable {
    
    public init?(preferenceValue: Any) {
        switch preferenceValue {
            case let val as Double:
                self = val
            case let val as String:
                self = NSString(string: val).doubleValue
            default:
                return nil
        }
    }
    
    public var preferenceValue: Any? {
        self
    }
}

extension Float: PreferenceRepresentable {
    
    public init?(preferenceValue: Any) {
        switch preferenceValue {
            case let val as Float:
                self = val
            case let val as String:
                self = NSString(string: val).floatValue
            default:
                return nil
        }
    }
    
    public var preferenceValue: Any? {
        self
    }
}

extension String: PreferenceRepresentable {
    
    public init?(preferenceValue: Any) {
        guard let val = preferenceValue as? String else { return nil }
        self = val
    }
    
    public var preferenceValue: Any? {
        self
    }
}

extension URL: PreferenceRepresentable {
    
    public init?(preferenceValue: Any) {
        switch preferenceValue {
            case let val as URL:
                self = val
            case let val as String:
                self = URL(fileURLWithPath: NSString(string: val).expandingTildeInPath)
            case let val as Data:
                if #available(iOS 11.0, macOS 10.13, tvOS 11.0, watchOS 4.0, *) {
                    guard let url = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSURL.self, from: val) else {
                        return nil
                    }
                    self = url as URL
                } else {
                    // Fallback on earlier versions
                    guard let url = NSKeyedUnarchiver.unarchiveObject(with: val) as? URL else {
                        return nil
                    }
                    self = url
                }
            default:
                return nil
        }
    }
    
    public var preferenceValue: Any? {
        self.absoluteURL.path
    }
}

extension Data: PreferenceRepresentable {
    
    public init?(preferenceValue: Any) {
        guard let val = preferenceValue as? Data else {
            return nil
        }
        self = val
    }
    
    public var preferenceValue: Any? {
        self
    }
}

extension Array: PreferenceRepresentable where Element: PreferenceRepresentable {
    
    public init?(preferenceValue: Any) {
        guard let val = preferenceValue as? [Any] else {
            return nil
        }
        
        self = val.compactMap {
            Element(preferenceValue: $0)
        }
    }
    
    public var preferenceValue: Any? {
        self.compactMap {
            $0.preferenceValue
        }
    }
}

extension Dictionary: PreferenceRepresentable where Key == String, Value: PreferenceRepresentable {
    
    public init?(preferenceValue: Any) {
        guard let val = preferenceValue as? [String : Any] else {
            return nil
        }
        
        self = val.compactMapValues {
            Value(preferenceValue: $0)
        }
    }
    
    public var preferenceValue: Any? {
        compactMapValues {
            $0.preferenceValue
        }
    }
}

extension Optional: PreferenceRepresentable where Wrapped: PreferenceRepresentable {
    
    public init?(preferenceValue: Any) {
        if let val = Wrapped(preferenceValue: preferenceValue) {
            self = .some(val)
        } else {
            self = .none
        }
    }
    
    public var preferenceValue: Any? {
        switch self {
            case .none:
                return nil
            case .some(let wrapped):
                return wrapped.preferenceValue
        }
    }
}

extension PreferenceRepresentable where Self: RawRepresentable, Self.RawValue: PreferenceRepresentable {
    
    public init?(preferenceValue: Any) {
        guard let rawValue = RawValue(preferenceValue: preferenceValue) else {
            return nil
        }
        self.init(rawValue: rawValue)
    }
    
    public var preferenceValue: Any? {
        self.rawValue.preferenceValue
    }
}
