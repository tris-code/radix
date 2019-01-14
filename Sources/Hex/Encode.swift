typealias EncodeTable = [UInt8]
private let table: EncodeTable = .init(("0123456789abcdef").utf8)

@inline(__always)
private func encode(_ byte: UInt8, _ uppercase: Bool) -> (UInt8, UInt8) {
    var highByte = table[Int(byte >> 4)]
    var lowByte = table[Int(byte & 0b0000_1111)]
    if uppercase {
        if highByte >= UInt8(ascii: "a") { highByte ^= 0b0010_0000 }
        if lowByte >= UInt8(ascii: "a") { lowByte ^= 0b0010_0000 }
    }
    return (highByte, lowByte)
}

public struct Format: OptionSet {
    public let rawValue: UInt8

    public init(rawValue: UInt8) {
        self.rawValue = rawValue
    }

    public static let none: Format = Format(rawValue: 0)
    public static let uppercase: Format = Format(rawValue: 1 << 0)
    public static let array: Format = Format(rawValue: 1 << 1)
}

extension String {
    private init(
        encodingToHexString bytes: UnsafeRawBufferPointer,
        uppercase: Bool = false)
    {
        let count = bytes.count.twice
        let result = UnsafeMutablePointer<UInt8>.allocate(capacity: count + 1)
        for i in 0..<bytes.count {
            let (highByte, lowByte) = Hex.encode(bytes[i], uppercase)
            result.advanced(by: i.twice).pointee = highByte
            result.advanced(by: i.twice + 1).pointee = lowByte
        }
        result.advanced(by: count).pointee = 0
        self.init(cString: result)
        result.deallocate()
    }

    private init(
        encodingToHexArray bytes: UnsafeRawBufferPointer,
        uppercase: Bool = false)
    {
        guard !bytes.isEmpty else {
            self.init("[]")
            return
        }
        // "0x00, ".count == 6
        // 2 extra bytes are used for '[]'
        let count = bytes.count * 6
        let result = UnsafeMutablePointer<UInt8>.allocate(capacity: count + 1)
        result.pointee = UInt8(ascii: "[")
        for i in 0..<bytes.count {
            let (highByte, lowByte) = Hex.encode(bytes[i], uppercase)
            let base = i * 6
            result.advanced(by: base + 1).pointee = UInt8(ascii: "0")
            result.advanced(by: base + 2).pointee = UInt8(ascii: "x")
            result.advanced(by: base + 3).pointee = highByte
            result.advanced(by: base + 4).pointee = lowByte
            // never out of bounds because of extra bytes for ']' and '\0'
            result.advanced(by: base + 5).pointee = UInt8(ascii: ",")
            result.advanced(by: base + 6).pointee = UInt8(ascii: " ")
        }
        result.advanced(by: count - 1).pointee = UInt8(ascii: "]")
        result.advanced(by: count).pointee = 0
        self.init(cString: result)
        result.deallocate()
    }
}

extension String {
    public init(
        encodingToHex bytes: UnsafeRawBufferPointer,
        format: Format = .none)
    {
        switch format.contains(.array) {
        case true:
            self.init(
                encodingToHexArray: bytes,
                uppercase: format.contains(.uppercase))
        case false:
            self.init(
                encodingToHexString: bytes,
                uppercase: format.contains(.uppercase))
        }
    }

    public init(encodingToHex bytes: [UInt8], format: Format = .none) {
        let bytes = UnsafeRawBufferPointer(start: bytes, count: bytes.count)
        self.init(encodingToHex: bytes, format: format)
    }

    @available(*, deprecated, message: "use format: .uppercase")
    public init(encodingToHex bytes: [UInt8], uppercase: Bool) {
        switch uppercase {
        case true: self.init(encodingToHex: bytes, format: .uppercase)
        case false: self.init(encodingToHex: bytes, format: .none)
        }
    }
}
