// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Backend",
    platforms: [
        .macOS("10.16"), .iOS("14"), .tvOS("14"), .watchOS("7")
    ],
    products: [
        .library(
            name: "Backend",
            targets: ["Backend"]),
    ],
    targets: [
        .target(
            name: "Backend",
            dependencies: []),
        .testTarget(
            name: "BackendTests",
            dependencies: ["Backend"]),
    ]
)
