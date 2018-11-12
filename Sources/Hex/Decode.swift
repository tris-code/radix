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

typealias DecodeTable = [Int8]
private let table: DecodeTable =
    [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
     -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
     -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
      0, 1, 2, 3, 4, 5, 6, 7, 8, 9,-1,-1,-1,-1,-1,-1,
     -1,10,11,12,13,14,15,-1,-1,-1,-1,-1,-1,-1,-1,-1,
     -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
     -1,10,11,12,13,14,15,-1,-1,-1,-1,-1,-1,-1,-1,-1,
     -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1]

extension UnsafeMutableRawBufferPointer {
    func initialize(decodingHex bytes: UnsafeRawBufferPointer) -> Bool {
        guard bytes.count.isEven, count.twice == bytes.count else {
            return false
        }
        for i in stride(from: 0, to: bytes.count, by: 2) {
            guard bytes[i] > 0, bytes[i + 1] > 0 else {
                return false
            }
            let high = table[Int(bytes[i])]
            let low = table[Int(bytes[i + 1])]
            guard high != -1, low != -1 else {
                return false
            }
            self[i.half] = UInt8(high) << 4 | UInt8(low)
        }
        return true
    }
}

extension Array where Element == UInt8 {
    public init?(decodingHexString string: String) {
        let count = string.count
        guard count.isEven else {
            return nil
        }
        var bytes = [UInt8](repeating: 0, count: count.half)
        let buffer = UnsafeMutableRawBufferPointer(
            start: &bytes, count: bytes.count)

        let result = string.withCString { bytes -> Bool in
            return buffer.initialize(decodingHex: .init(
                start: bytes, count: count))
        }
        guard result else {
            return nil
        }
        self = bytes
    }
}
