// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftRandom",
    platforms: [.macOS(.v15), .iOS(.v18), .watchOS(.v11)], // Due to the use of Int128 and UInt128
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwiftRandom",
            targets: ["SwiftRandom"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SwiftRandom"),
        .testTarget(
            name: "SwiftRandomTests",
            dependencies: ["SwiftRandom"]
        ),
    ]
)
