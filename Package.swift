// swift-tools-version:5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "SwiftFFmpeg",
  platforms: [.macOS(.v12), .iOS(.v15), .tvOS(.v15)],
  products: [
    .library(
      name: "SwiftFFmpeg",
      type: .dynamic,
      targets: ["SwiftFFmpeg"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/tylerjonesio/ffmpeg-libav-spm", branch: "min.v7.1.1.2")
  ],
  targets: [
    .target(
        name: "CFFmpeg",
        dependencies: [
            .product(name: "FFmpeg", package: "ffmpeg-libav-spm")
        ]
    ),
    .target(
      name: "SwiftFFmpeg",
      dependencies: ["CFFmpeg"]
    ),
    .executableTarget(
      name: "Examples",
      dependencies: ["SwiftFFmpeg"]
    ),
    .testTarget(
      name: "Tests",
      dependencies: ["SwiftFFmpeg"]
    ),
  ]
)
