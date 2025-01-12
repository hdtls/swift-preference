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

import XCTest

final class PreferenceRepresentableTests: XCTestCase {

  func testBoolPreferenceRepresentableConformance() {
    XCTAssertEqual(Bool(preferenceValue: false), false)
    XCTAssertEqual(Bool(preferenceValue: 0), false)
    XCTAssertEqual(Bool(preferenceValue: Float.zero), false)
    XCTAssertEqual(Bool(preferenceValue: Double.zero), false)
    XCTAssertEqual(Bool(preferenceValue: "NO"), false)
    XCTAssertEqual(Bool(preferenceValue: "false"), false)
    XCTAssertEqual(Bool(preferenceValue: "0"), false)
    XCTAssertEqual(Bool(preferenceValue: "YES"), true)
    XCTAssertEqual(Bool(preferenceValue: "true"), true)
    XCTAssertEqual(Bool(preferenceValue: "1"), true)
    XCTAssertEqual(Bool(preferenceValue: "2"), true)
    XCTAssertEqual(Bool(preferenceValue: "ABC"), false)

    XCTAssertNotNil(false.preferenceValue)
  }

  func testIntPreferenceRepresentableConformance() {
    XCTAssertEqual(Int(preferenceValue: false), 0)
    XCTAssertEqual(Int(preferenceValue: 0), 0)
    XCTAssertEqual(Int(preferenceValue: Float.zero), 0)
    XCTAssertEqual(Int(preferenceValue: Double.zero), 0)
    XCTAssertEqual(Int(preferenceValue: "NO"), 0)
    XCTAssertEqual(Int(preferenceValue: "false"), 0)
    XCTAssertEqual(Int(preferenceValue: "0"), 0)
    XCTAssertEqual(Int(preferenceValue: "YES"), 0)
    XCTAssertEqual(Int(preferenceValue: "true"), 0)
    XCTAssertEqual(Int(preferenceValue: "0.1"), 0)
    XCTAssertEqual(Int(preferenceValue: "0.7"), 0)
    XCTAssertEqual(Int(preferenceValue: "1.7"), 1)

    XCTAssertNotNil(0.preferenceValue)
  }

  func testFloatPreferenceRepresentableConformance() {
    XCTAssertEqual(Float(preferenceValue: false), 0)
    XCTAssertEqual(Float(preferenceValue: 0), 0)
    XCTAssertEqual(Float(preferenceValue: Float.zero), 0)
    XCTAssertEqual(Float(preferenceValue: Double.zero), 0)
    XCTAssertEqual(Float(preferenceValue: "NO"), 0)
    XCTAssertEqual(Float(preferenceValue: "false"), 0)
    XCTAssertEqual(Float(preferenceValue: "0"), 0)

    XCTAssertNotNil(Float.zero.preferenceValue)
  }

  func testDoublePreferenceRepresentableConformance() {
    XCTAssertEqual(Double(preferenceValue: false), 0)
    XCTAssertEqual(Double(preferenceValue: 0), 0)
    XCTAssertEqual(Double(preferenceValue: Float.zero), 0)
    XCTAssertEqual(Double(preferenceValue: Double.zero), 0)
    XCTAssertEqual(Double(preferenceValue: "NO"), 0)
    XCTAssertEqual(Double(preferenceValue: "false"), 0)
    XCTAssertEqual(Double(preferenceValue: "0"), 0)

    XCTAssertNotNil(Double.zero.preferenceValue)
  }

  func testStringPreferenceRepresentableConformance() {
    XCTAssertEqual(String(preferenceValue: false), "0")
    XCTAssertEqual(String(preferenceValue: 0), "0")
    #if canImport(Darwin)
      XCTAssertEqual(String(preferenceValue: Float.zero), "0")
      XCTAssertEqual(String(preferenceValue: Double.zero), "0")
    #else
      XCTAssertEqual(String(preferenceValue: Float.zero), "0.0")
      XCTAssertEqual(String(preferenceValue: Double.zero), "0.0")
    #endif
    XCTAssertEqual(String(preferenceValue: "NO"), "NO")
    XCTAssertEqual(String(preferenceValue: "false"), "false")
    XCTAssertEqual(String(preferenceValue: "0"), "0")

    XCTAssertNotNil("0".preferenceValue)
  }

  func testURLPreferenceRepresentableConformance() {
    XCTAssertNil(URL(preferenceValue: false))
    XCTAssertNil(URL(preferenceValue: 0))
    XCTAssertNil(URL(preferenceValue: Float.zero))
    XCTAssertNil(URL(preferenceValue: Double.zero))
    XCTAssertNotNil(URL(preferenceValue: "NO"))

    XCTAssertNotNil(URL(fileURLWithPath: "/").preferenceValue)
  }

  func testDataPreferenceRepresentableConformance() {
    XCTAssertNil(Data(preferenceValue: false))
    XCTAssertNil(Data(preferenceValue: 0))
    XCTAssertNil(Data(preferenceValue: Float.zero))
    XCTAssertNil(Data(preferenceValue: Double.zero))
    XCTAssertNil(Data(preferenceValue: "NO"))
    XCTAssertNil(Data(preferenceValue: "false"))
    XCTAssertNil(Data(preferenceValue: "0"))
    XCTAssertEqual(Data(preferenceValue: Data([0x01])), Data([0x01]))

    XCTAssertNotNil(Data([0x01]).preferenceValue)
  }

  func testDatePreferenceRepresentableConformance() {
    XCTAssertNil(Date(preferenceValue: false))
    XCTAssertEqual(Date(preferenceValue: 0), Date(timeIntervalSinceReferenceDate: 0))
    XCTAssertEqual(Date(preferenceValue: Float.zero), Date(timeIntervalSinceReferenceDate: 0))
    XCTAssertEqual(Date(preferenceValue: Double.zero), Date(timeIntervalSinceReferenceDate: 0))
    XCTAssertEqual(Date(preferenceValue: "NO"), Date(timeIntervalSinceReferenceDate: 0))
    XCTAssertEqual(Date(preferenceValue: "false"), Date(timeIntervalSinceReferenceDate: 0))
    XCTAssertEqual(Date(preferenceValue: "0"), Date(timeIntervalSinceReferenceDate: 0))

    XCTAssertNotNil(Date.distantPast.preferenceValue)
  }
}
