# Hex

## Package.swift

```swift
.package(url: "https://github.com/tris-foundation/radix.git", .branch("master"))
```

## Usage

### Hex

```swift
"c001" == String(encodingToHex: [192, 1])
"C001" == String(encodingToHex: [192, 1], format: .uppercase)
"[0xc0, 0x01]" == String(encodingToHex: [192, 1], format: .array)
"[0xC0, 0x01]" == String(encodingToHex: [192, 1], format: [.uppercase, .array])

_ = [UInt8](decodingHexString: "c001")
_ = [UInt8](decodingHexString: "C001")
```

### Base64

```swift
_ = String(encodingToBase64: "string")
_ = String(encodingToBase64: [UInt8]("or bytes".utf8))

_ = String(decodingBase64: "c3RyaW5n")
_ = String(decodingBase64: [UInt8]("b3IgYnl0ZXM=".utf8))
```

```swift
_ = [UInt8](encodingToBase64: "string")
_ = [UInt8](encodingToBase64: [UInt8]("or bytes".utf8))

_ = [UInt8](decodingBase64: "c3RyaW5n")
_ = [UInt8](decodingBase64: [UInt8]("b3IgYnl0ZXM=".utf8))
```
