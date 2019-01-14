typealias DecodeTable = [Int8]
private let table: DecodeTable = [
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 62, -1, -1, -1, 63,
    52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -1, -1, -1, -1, -1, -1,
    -1, 00, 01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 11, 12, 13, 14,
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -1, -1, -1, -1, 63,
    -1, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]

extension Array where Element == UInt8 {
    public init?(decodingBase64 bytes: UnsafeRawBufferPointer) {
        guard bytes.count.isEven else {
            return nil
        }
        var result = [UInt8]()
        for i in stride(from: 0, to: bytes.count, by: 4) {
            func decodeFirst() -> UInt8 {
                return table[bytes[i]] << 2 | table[bytes[i + 1]] >> 4
            }
            func decodeSecond() -> UInt8 {
                return ((table[bytes[i + 1]] << 4) & 0xf0)
                    | (table[bytes[i + 2]] >> 2)
            }
            func decodeThird() -> UInt8 {
                return ((table[bytes[i + 2]] << 6) & 0xc0)
                    | (table[bytes[i + 3]])
            }
            var oneBytePadding: Bool {
                return bytes[i + 2] != "="
                    && bytes[i + 3] == "="
            }
            var twoBytesPadding: Bool {
                return bytes[i + 2] == "="
                    && bytes[i + 3] == "="
            }

            guard bytes[i].isBase64 && bytes[i + 1].isBase64 else {
                return nil
            }
            result.append(decodeFirst())

            switch bytes.count {
            // 0 left
            case i + 2: break
            case i + 4 where twoBytesPadding: break
            // 1 left
            case i + 3: fallthrough
            case i + 4 where oneBytePadding:
                guard bytes[i + 2].isBase64 else {
                    return nil
                }
                result.append(decodeSecond())
            // 2 left
            default:
                guard bytes[i + 2].isBase64, bytes[i + 3].isBase64 else {
                    return nil
                }
                result.append(decodeSecond())
                result.append(decodeThird())
            }
        }
        self = result
    }
}

extension Array where Element == UInt8 {
    @inlinable
    public init?(decodingBase64 bytes: [UInt8]) {
        self.init(decodingBase64: UnsafeRawBufferPointer(
            start: bytes, count: bytes.count))
    }

    @inlinable
    public init?<T: StringProtocol>(decodingBase64 string: T) {
        let result = string.withCString { pointer in
            return [UInt8](decodingBase64: UnsafeRawBufferPointer(
                start: pointer, count: string.utf8.count))
        }
        guard let bytes = result else {
            return nil
        }
        self = bytes
    }
}

extension String {
    @inlinable
    public init?(decodingBase64 buffer: UnsafeRawBufferPointer) {
        guard let result = [UInt8](decodingBase64: buffer) else {
            return nil
        }
        self = String(decoding: result, as: UTF8.self)
    }

    @inlinable
    public init?(decodingBase64 bytes: [UInt8]) {
        self.init(decodingBase64: UnsafeRawBufferPointer(
            start: bytes, count: bytes.count))
    }

    @inlinable
    public init?<T: StringProtocol>(decodingBase64 string: T) {
        let result = string.withCString { pointer in
            return String(decodingBase64: UnsafeRawBufferPointer(
            start: pointer, count: string.utf8.count))
        }
        guard let string = result else {
            return nil
        }
        self = string
    }
}

// MARK: convenience

private extension BinaryInteger {
    var isEven: Bool {
        @inline(__always)
        get { return self & 1 == 0 }
    }
}

private extension UInt8 {
    var isBase64: Bool {
        @inline(__always)
        get { return table[Int(self)] != -1 }
    }

    @inline(__always)
    static func !=(lhs: UInt8, rhs: Unicode.Scalar) -> Bool {
        return lhs != UInt8(ascii: rhs)
    }

    @inline(__always)
    static func ==(lhs: UInt8, rhs: Unicode.Scalar) -> Bool {
        return lhs == UInt8(ascii: rhs)
    }
}

private extension Array where Element == Int8 {
    @inline(__always)
    subscript(_ index: UInt8) -> UInt8 {
        return UInt8(bitPattern: self[Int(index)])
    }
}
