// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "swift-bezier",
    products: [
        .library(
            name: "SwiftBezier",
            targets: ["SwiftBezier"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-numerics.git", from: "1.0.0"),
        .package(url: "https://github.com/LuizZak/MiniP5Printer.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "SwiftBezier",
            dependencies: [],
            path: "Sources/swift-bezier"
        ),
        .testTarget(
            name: "SwiftBezierTests",
            dependencies: [
                .product(name: "Numerics", package: "swift-numerics"),
                .product(name: "MiniP5Printer", package: "MiniP5Printer"),
                "SwiftBezier",
            ],
            path: "Tests/swift-bezierTests"
        ),
    ]
)
