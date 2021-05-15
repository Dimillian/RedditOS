// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Backend",
    platforms: [
        .macOS("11"), .iOS("14"), .tvOS("14"), .watchOS("7")
    ],
    products: [
        .library(
            name: "Backend",
            targets: ["Backend"]),
    ],
    dependencies: [
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess", from: "4.2.0"),
    ],
    targets: [
        .target(
            name: "Backend",
            dependencies: ["KeychainAccess"],
            resources: [.process("Resources")]),
        .testTarget(
            name: "BackendTests",
            dependencies: ["Backend"]),
    ]
)
