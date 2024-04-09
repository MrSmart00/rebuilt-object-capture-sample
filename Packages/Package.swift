// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Packages",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "AppFeature",
            targets: ["App"]),
    ],
    targets: [
        .target(
            name: "App",
            dependencies: ["Capture"]
        ),
        .target(name: "Capture")
    ]
)
