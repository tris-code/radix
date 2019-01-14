import Test
@testable import Hex

class HexTests: TestCase {
    func testEncode() {
        let bytes: [UInt8] = [192, 1]
        assertEqual(String(encodingToHex: bytes), "c001")
        assertEqual(String(encodingToHex: bytes, format: .uppercase), "C001")

        assertEqual(String(
            encodingToHex: [], format: .array),
            "[]")
        assertEqual(String(
            encodingToHex: bytes, format: .array),
            "[0xc0, 0x01]")
        assertEqual(String(
            encodingToHex: bytes, format: [.uppercase, .array]),
            "[0xC0, 0x01]")
    }

    func testDecode() {
        let expected: [UInt8] = [192, 1]
        assertEqual([UInt8](decodingHexString: "c001"), expected)
        assertEqual([UInt8](decodingHexString: "C001"), expected)
    }
}
