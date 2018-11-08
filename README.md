# Hex

## Package.swift

```swift
.package(url: "https://github.com/tris-foundation/hex.git", .branch("master"))
```

## Usage

```swift
_ = String(encodingToHex: [192, 1])
_ = String(encodingToHex: [192, 1], uppercase: true)

_ = [UInt8](decodingHexString: "c001")
_ = [UInt8](decodingHexString: "C001")
```
