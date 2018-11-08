import XCTest

extension HexTests {
    static let __allTests = [
        ("testDecode", testDecode),
        ("testEncode", testEncode)
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(HexTests.__allTests),
    ]
}
#endif
