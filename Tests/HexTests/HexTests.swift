/******************************************************************************
 *                                                                            *
 * Tris Foundation disclaims copyright to this source code.                   *
 * In place of a legal notice, here is a blessing:                            *
 *                                                                            *
 *     May you do good and not evil.                                          *
 *     May you find forgiveness for yourself and forgive others.              *
 *     May you share freely, never taking more than you give.                 *
 *                                                                            *
 ******************************************************************************/

import Test
@testable import Hex

class HexTests: TestCase {
    func testEncode() {
        let bytes: [UInt8] = [192, 1]
        assertEqual(String(encodingToHex: bytes), "c001")
        assertEqual(String(encodingToHex: bytes, uppercase: true), "C001")
    }

    func testDecode() {
        let expected: [UInt8] = [192, 1]
        assertEqual([UInt8](decodingHexString: "c001"), expected)
        assertEqual([UInt8](decodingHexString: "C001"), expected)
    }
}
