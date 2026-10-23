import CFFmpeg

// Keep the native opener so FFmpeg retains ownership, interrupt handling,
// protocol restrictions, and its normal close behavior.
typealias AVFormatIOOpenCallback = @convention(c) (
  UnsafeMutablePointer<CAVFormatContext>?,
  UnsafeMutablePointer<UnsafeMutablePointer<CFFmpeg.AVIOContext>?>?,
  UnsafePointer<CChar>?,
  Int32,
  UnsafeMutablePointer<OpaquePointer?>?
) -> Int32

final class AVFormatIOOpenOptionsContext {
  let handler: AVFormatContext.IOOpenOptions
  let originalOpen: AVFormatIOOpenCallback?

  init(handler: @escaping AVFormatContext.IOOpenOptions, originalOpen: AVFormatIOOpenCallback?) {
    self.handler = handler
    self.originalOpen = originalOpen
  }
}

func avFormatIOOpenWithOptions(
  _ format: UnsafeMutablePointer<CAVFormatContext>?,
  _ io: UnsafeMutablePointer<UnsafeMutablePointer<CFFmpeg.AVIOContext>?>?,
  _ url: UnsafePointer<CChar>?,
  _ flags: Int32,
  _ options: UnsafeMutablePointer<OpaquePointer?>?
) -> Int32 {
  guard let format, let opaque = format.pointee.opaque, let url else {
    return swift_AVERROR(EINVAL)
  }
  let context = Unmanaged<AVFormatIOOpenOptionsContext>.fromOpaque(opaque).takeUnretainedValue()
  guard let originalOpen = context.originalOpen else { return swift_AVERROR(EINVAL) }
  let incoming = options?.pointee.map { toDictionary($0) } ?? [:]
  let values = context.handler(String(cString: url), AVIOContext.Flag(rawValue: flags), incoming)
  var modified: OpaquePointer?
  defer { av_dict_free(&modified) }
  for (key, value) in values {
    let result = av_dict_set(&modified, key, value, 0)
    if result < 0 { return result }
  }
  let result = originalOpen(format, io, url, flags, &modified)
  if let options {
    av_dict_free(options)
    options.pointee = modified
    modified = nil
  }
  return result
}
