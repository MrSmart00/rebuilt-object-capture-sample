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
                "Reconstruction",
                "Common",
                "FileBrowser",
                "Viewer"
            ]
        ),
        .target(name: "Folder"),
        .target(
            name: "Capture",
            dependencies: ["Folder"]
        ),
        .target(
            name: "Reconstruction",
            dependencies: ["Folder"]
        ),
        .target(name: "Viewer"),
        .target(name: "Common"),
        .target(
            name: "FileBrowser",
            dependencies: ["Folder"]
        )
    ]
)
