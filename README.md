# swift-preference

Preference provides property wrapper for UserDefaults and custom Combine publisher that bind a stream for changes.

There are several data types already suppored by default such as `Bool`, `Int`, `Double`, `Float`, `String`, `URL`, `Data`, `Array where Element: PreferenceRepresentable`, `Dictionary where Key == String, Value: PreferenceRepresentable`, `Optional where Wrapped: PreferenceRepresentable`

Also we have a default implementation of `PreferenceRepresentable where Self: RawRepresentable, Self.RawValue: PreferenceRepresentable`.

## Usage

### There are two types `String`, `UserDefaults.FieldKey` can be used as UserDefaults key field.

```swift
// Use String as key
@Preference("isFlagged") var isFlagged = false

...

extension UserDefaults.FieldKey {
    ...
    
    static let isFlagged: UserDefaults.FieldKey = "isFlagged"
}

// Use UserDefaults.FieldKey as key
@Preference(.isFlagged) var isFlagged = false
```

### Store enum type to UserDefaults

```swift
enum Fruit: String, PreferenceRepresentable {
    ...
    case apple
}

@Preference("fruit") var fruit = Fruit.apple
```

### Subscribe value changes for UserDefaults with specified key

```swift
@Preference("isFlagged") var isFlagged = false
...

$isFlagged.sink {
    print($0)
}
.store(in: &cancellable)
```

## Installation

### Swift Package Manager

Add the following dependency to your **Package.swift** file:

```swift
.package(url: "https://github.com/hdtls/swift-preference", from: "1.0.2")
```

## License
Preference is available under the MIT license. See the LICENSE file for more info.
