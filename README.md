# SwiftFFmpeg

A Swift wrapper for the FFmpeg API.

> Note: SwiftFFmpeg is still in development, and the API is not guaranteed to be stable. It's subject to change without warning.

## FFmpeg Sources

This fork relies on a multiplatform (iOS, macOS, & tvOS) prebuilt FFmpeg xcframework binary from the [FFmpeg Libav SPM repo](https://github.com/tylerjonesio/ffmpeg-libav-spm). The linked binaries do not include any GPL sources and are LGPL compatible. 

If you'd like to use your own FFmpeg binaries, check out the [upstream repository](https://github.com/sunlubo/SwiftFFmpeg) for instructions.

### Swift Package Manager

SwiftFFmpeg primarily uses [SwiftPM](https://swift.org/package-manager/) as its build tool, so we recommend using that as well. If you want to depend on SwiftFFmpeg in your own project, it's as simple as adding a `dependencies` clause to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/tylerjonesio/SwiftFFmpeg.git", from: "7.1.1")
]
```

## Documentation

- [API documentation](https://sunlubo.github.io/SwiftFFmpeg)

## Examples

For specific examples such as decoding, encoding, scaling, etc, check out the [SwiftFFmpegExamples project](Sources/SwiftFFmpegExamples/) in this package.

#### 
* [Video Decoding](Sources/SwiftFFmpegExamples/decode_video.swift)
* [Audio Decoding](Sources/SwiftFFmpegExamples/decode_audio.swift)
* [Video Encoding](Sources/SwiftFFmpegExamples/encode_video.swift)
* [Audio Encoding](Sources/SwiftFFmpegExamples/encode_audio.swift)
* [Demuxing/Decoding](Sources/SwiftFFmpegExamples/demuxing_decoding.swift)
* [Remuxing](Sources/SwiftFFmpegExamples/remuxing.swift)
* [Hardware Decoding](Sources/SwiftFFmpegExamples/hw_decode.swift)
* [Scaling Video](Sources/SwiftFFmpegExamples/scaling_video.swift)
* [Filtering Video](Sources/SwiftFFmpegExamples/filtering_video.swift)
* [Filtering Audio](Sources/SwiftFFmpegExamples/filtering_audio.swift)

## Options for nested I/O opens

`AVFormatContext(url:options:ioOpenOptions:)` and
`openInput(_:format:options:ioOpenOptions:)` accept a per-context options handler.
It runs before the initial input and subsequent native I/O opens, including HLS
playlists, segments, and encryption keys. Return the supplied dictionary with
any desired additions; this preserves request-specific options such as cookies,
headers, and byte ranges.

```swift
let tlsOptions = ["ca_file": caBundleURL.path, "tls_verify": "1"]
let context = try AVFormatContext(url: streamURL, options: tlsOptions,
                                 ioOpenOptions: { _, _, options in
  options.merging(tlsOptions) { _, configured in configured }
})
```

The hook delegates to FFmpeg's original `io_open`, retaining its interruption,
protocol restriction, and I/O close behavior. Its state lives until the format
context closes, including when an open fails. Handlers must be thread-safe and
should not capture the owning format context strongly. Installing the handler
reserves the native `AVFormatContext.opaque` field; do not overwrite it through
unsafe pointer access. Nested contexts share this field under FFmpeg's callback
contract. Configure the handler before opening, and do not mutate native callback
fields while the context is in use.
