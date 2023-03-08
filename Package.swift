// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "SwiftFFmpeg",
  platforms: [.macOS(.v10_15), .iOS(.v12), .tvOS(.v11)],
  products: [
    .library(
      name: "SwiftFFmpeg",
      type: .dynamic,
      targets: ["SwiftFFmpeg"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/tylerjonesio/ffmpeg-kit-spm", branch: "min.v5.1.2.4")
  ],
  targets: [
    .target(
        name: "CFFmpeg",
        dependencies: [
            .product(name: "FFmpeg", package: "ffmpeg-kit-spm")
        ]
    ),
    .target(
      name: "SwiftFFmpeg",
      dependencies: ["CFFmpeg"]
    ),
    .executableTarget(
      name: "SwiftFFmpegExamples",
      dependencies: [.target(name: "SwiftFFmpeg")]
    ),
    .testTarget(
      name: "SwiftFFmpegTests",
      dependencies: ["SwiftFFmpeg"]
    ),
  ]
)
