// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UI",
    platforms: [
        .macOS("11"), .iOS("14"), .tvOS("14"), .watchOS("7")
    ],
    products: [
        .library(
            name: "UI",
            targets: ["UI"]),
    ],
    targets: [
        .target(
            name: "UI",
            dependencies: []),
        .testTarget(
            name: "UITests",
            dependencies: ["UI"]),
    ]
)
