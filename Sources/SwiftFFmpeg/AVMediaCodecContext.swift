//
//  AVMediaCodecContext.swift
//  SwiftFFmpeg
//
//  Created by Tyler Jones on 3/21/26.
//

import CFFmpeg

typealias CAVMediaCodecContext = CFFmpeg.AVMediaCodecContext

@available(iOS, unavailable)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public final class AVMediaCodecContext {
    var native: UnsafeMutablePointer<CAVMediaCodecContext>!
    var codecContext: AVCodecContext
    
    public init(codecContext: AVCodecContext, surface: UnsafeMutableRawPointer) throws {
        self.native = av_mediacodec_alloc_context()
        try throwIfFail(av_mediacodec_default_init(codecContext.native, native, surface))
        self.codecContext = codecContext
    }
    
    deinit {
        av_mediacodec_default_free(codecContext.native)
    }
    
    public static func setJVM(_ jvm: UnsafeMutableRawPointer) throws {
        try throwIfFail(av_jni_set_java_vm(jvm, nil))
    }
    
    public static func releaseBuffer(_ buffer: OpaquePointer, render: Bool = true) {
        av_mediacodec_release_buffer(buffer, render ? 1 : 0)
    }
}
