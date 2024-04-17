# Object Capture Sample Tweaks

<img src="https://img.shields.io/badge/-xcode-000000.svg?logo=Xcode&style=for-the-badge"> <img src="https://img.shields.io/badge/-swift-000000.svg?logo=Swift&style=for-the-badge">
  
![スクリーンショット 2024-04-12 21 53 23](https://github.com/MrSmart00/object-capture-sample-tweaks/assets/8654605/2c20bb0d-8ed6-4588-b058-61d66dbd1d56)


## Index

1. [About the Project](#about-the-project)
2. [Environments](#environments)
3. [Structures](#structures)


<!-- プロジェクトについて -->

## About the Project

This project involves breaking down the [sample project](https://developer.apple.com/documentation/RealityKit/guided-capture-sample) used in the Object Capture video presented at [WWDC23 video](https://developer.apple.com/videos/play/wwdc2023/10191/), simplifying its structure, and managing it using SwiftPM in a multi-package configuration. It separates concerns without using third-party tools.

WWDC23で紹介されたObject Captureの[動画](https://developer.apple.com/videos/play/wwdc2023/10191/)で使用していた[サンプルプロジェクト](https://developer.apple.com/documentation/RealityKit/guided-capture-sample)を分解し、よりシンプルな構成にしてマルチパッケージ構成にしてSwiftPMで管理するようにしたプロジェクトです。

3rdパーティーツールを用いずに関心の分離を行っています。

## Environments

<!-- 言語、フレームワーク、ミドルウェア、インフラの一覧とバージョンを記載 -->

| OS,Language,Tool  | Version |
| --------------------- | ---------- |
| OS                | OSX 14.2.1     |
| Xcode                | 15.3      |
| swift tool version | 5.10       |
| Traget iOS Version | 17.0~     |

## Structures

<pre>
.
├── LICENSE
├── ObjectCaptureSandbox.xcworkspace
├── Packages
│   ├── Package.swift
│   ├── Sources
│   │   ├── App
│   │   │   └── ContentView.swift
│   │   ├── Capture
│   │   │   ├── CaptureModelState.swift
│   │   │   ├── CaptureView.swift
│   │   │   ├── CapturingModel.swift
│   │   │   └── Orbit.swift
│   │   ├── Common
│   │   │   ├── CapsuleButtonStyle.swift
│   │   │   ├── CapturingOverlayView.swift
│   │   │   ├── CircleButtonStyle.swift
│   │   │   ├── CircularProgressView.swift
│   │   │   ├── DetectingOverlayView.swift
│   │   │   ├── FileOpenOverlayView.swift
│   │   │   ├── FinishedOverlayView.swift
│   │   │   └── StartingOverlayView.swift
│   │   ├── FileBrowser
│   │   │   └── DocumentBrowser.swift
│   │   ├── Folder
│   │   │   └── Folder.swift
│   │   ├── Reconstruction
│   │   │   ├── ReconstructionModel.swift
│   │   │   └── ReconstructionProgressView.swift
│   │   └── Viewer
│   │       └── ModelViewer.swift
│   └── Tests
│       └── PackagesTests
│           └── PackagesTests.swift
├── README.md
└── Sandbox
    ├── Sandbox
    │   ├── Assets.xcassets
    │   ├── Preview Content
    │   ├── SandboxApp.swift
    │   └── info.plist
    └── Sandbox.xcodeproj
</pre>
31 directories, 35 files
