# swift-preference

Preference provides property wrapper for UserDefaults and custom Combine publisher that bind a stream for changes.

There are several data types already suppored by default such as `Bool`, `Int`, `Double`, `Float`, `String`, `URL`, `Data`, `Date`, `Array where Element: PreferenceRepresentable`, `Dictionary where Key == String, Value: PreferenceRepresentable`, `Optional where Wrapped: PreferenceRepresentable`

Also we have a default implementation of `PreferenceRepresentable where Self: RawRepresentable, Self.RawValue: PreferenceRepresentable`.

On Darwin platform, we support receiving interprocess notifications for UserDefaults changes.

## Usage

Define property using `Preference` property wrapper, that is.
If you want to store other types you should provide custom `PreferenceRepresentable` implementation for it.

```swift
@Preference("isFlagged") var isFlagged = false

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
.package(url: "https://github.com/hdtls/swift-preference", from: "1.2.0")
```

## License
Preference is available under the MIT license. See the LICENSE file for more info.
