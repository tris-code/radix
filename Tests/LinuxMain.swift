import XCTest

import Base64Tests
import HexTests

var tests = [XCTestCaseEntry]()
tests += Base64Tests.__allTests()
tests += HexTests.__allTests()

XCTMain(tests)
