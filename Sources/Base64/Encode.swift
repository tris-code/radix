typealias EncodeTable = [UInt8]
private var table: EncodeTable = .init((
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ" +
    "abcdefghijklmnopqrstuvwxyz" +
    "0123456789+/")
    .utf8)

extension Array where Element == UInt8 {
    public init(encodingToBase64 bytes: UnsafeRawBufferPointer) {
        var result = [UInt8]()
        for i in stride(from: 0, to: bytes.count, by: 3) {
            result.append((table[x3f: bytes[i] >> 2]))
            switch bytes.count {
            case i + 1:
                result.append(table[x3f: bytes[i] << 4])
                result.append(ascii: "=")
                result.append(ascii: "=")
            case i + 2:
                result.append(table[x3f: bytes[i] << 4 + (bytes[i + 1] >> 4)])
                result.append(table[x3f: bytes[i + 1] << 2])
                result.append(ascii: "=")
            default:
                result.append(table[x3f: bytes[i] << 4 + (bytes[i + 1] >> 4)])
                result.append(table[x3f: bytes[i + 1] << 2 + bytes[i + 2] >> 6])
                result.append(table[x3f: bytes[i + 2]])
            }
        }
        self = result
    }
}

extension Array where Element == UInt8 {
    @inlinable
    public init(encodingToBase64 bytes: [UInt8]) {
        self.init(encodingToBase64: UnsafeRawBufferPointer(
            start: bytes, count: bytes.count))
    }
}

// MARK: public api

extension String {
    @inlinable
    public init(encodingToBase64 buffer: UnsafeRawBufferPointer) {
        let result = [UInt8](encodingToBase64: buffer)
        self = String(decoding: result, as: UTF8.self)
    }

    @inlinable
    public init(encodingToBase64 bytes: [UInt8]) {
        self.init(encodingToBase64: UnsafeRawBufferPointer(
            start: bytes, count: bytes.count))
    }

    @inlinable
    public init<T: StringProtocol>(encodingToBase64 string: T) {
        self = string.withCString { pointer in
            return String(encodingToBase64: UnsafeRawBufferPointer(
            start: pointer, count: string.utf8.count))
        }
    }
}

// MARK: convenience

private extension Array where Element == UInt8 {
    @inline(__always)
    subscript (x3f index: UInt8) -> UInt8 {
        return self[Int(index & 0x3f)]
    }

    @inline(__always)
    mutating func append(ascii scalar: Unicode.Scalar) {
        self.append(UInt8(ascii: scalar))
    }
}
