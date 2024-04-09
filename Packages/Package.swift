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
        .library(
            name: "CommonFeature",
            targets: ["Common"]),
    ],
    targets: [
        .target(
            name: "App",
            dependencies: [
                "Capture",
                "Common"
            ]
        ),
        .target(name: "Capture"),
        .target(name: "Common")
    ]
)
