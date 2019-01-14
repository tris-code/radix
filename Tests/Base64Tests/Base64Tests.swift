import Test
@testable import Base64

class Base64Tests: TestCase {
    func testEncode() {
        assertEqual(String(encodingToBase64: "tris"), "dHJpcw==")
        assertEqual(String(encodingToBase64: "tris."), "dHJpcy4=")
        assertEqual(String(encodingToBase64: "tris.."), "dHJpcy4u")
    }

    func testDecode() {
        assertEqual(String(decodingBase64: "dHJpcw=="), "tris")
        assertEqual(String(decodingBase64: "dHJpcy4="), "tris.")
        assertEqual(String(decodingBase64: "dHJpcy4u"), "tris..")
    }
}
