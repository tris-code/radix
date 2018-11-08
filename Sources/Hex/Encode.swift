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

typealias EncodeTable = [UInt8]
private let table: EncodeTable =
    [UInt8(ascii: "0"), UInt8(ascii: "1"), UInt8(ascii: "2"),
     UInt8(ascii: "3"), UInt8(ascii: "4"), UInt8(ascii: "5"),
     UInt8(ascii: "6"), UInt8(ascii: "7"), UInt8(ascii: "8"),
     UInt8(ascii: "9"), UInt8(ascii: "a"), UInt8(ascii: "b"),
     UInt8(ascii: "c"), UInt8(ascii: "d"), UInt8(ascii: "e"),
     UInt8(ascii: "f")]

extension String {
    public init(
        encodingToHex bytes: UnsafeRawBufferPointer,
        uppercase: Bool = false)
    {
        let count = bytes.count << 1
        let result = UnsafeMutablePointer<UInt8>.allocate(capacity: count + 1)
        for i in 0..<bytes.count {
            var highByte = table[Int(bytes[i] >> 4)]
            var lowByte = table[Int(bytes[i] & 0b0000_1111)]
            if uppercase {
                if highByte >= UInt8(ascii: "a") { highByte ^= 0b0010_0000 }
                if lowByte >= UInt8(ascii: "a") { lowByte ^= 0b0010_0000 }
            }
            let position = i << 1
            result.advanced(by: position).pointee = highByte
            result.advanced(by: position + 1).pointee = lowByte
        }
        result.advanced(by: count).pointee = 0
        self.init(cString: result)
        result.deallocate()
    }
}

extension String {
    public init(encodingToHex bytes: [UInt8], uppercase: Bool = false) {
        let bytes = UnsafeRawBufferPointer(start: bytes, count: bytes.count)
        self.init(encodingToHex: bytes, uppercase: uppercase)
    }
}
