// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "Radix",
    products: [
        .library(name: "Hex", targets: ["Hex"]),
        .library(name: "Base64", targets: ["Base64"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/tris-foundation/test.git",
            .branch("master"))
    ],
    targets: [
        .target(
            name: "Hex",
            dependencies: []),
        .target(
            name: "Base64",
            dependencies: []),
        .testTarget(
            name: "HexTests",
            dependencies: ["Test", "Hex"]),
        .testTarget(
            name: "Base64Tests",
            dependencies: ["Test", "Base64"]),
    ]
)
