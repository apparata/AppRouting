// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "AppRouting",
    platforms: [
        .iOS(.v17), .macOS(.v14), .tvOS(.v17), .visionOS(.v1)
    ],
    products: [
        .library(name: "AppRouting", targets: ["AppRouting"])
    ],
    targets: [
        .target(name: "AppRouting"),
        .testTarget(name: "AppRoutingTests", dependencies: ["AppRouting"]),
    ]
)
