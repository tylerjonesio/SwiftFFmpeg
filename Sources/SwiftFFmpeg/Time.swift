//
//  Time.swift
//  SwiftFFmpeg
//
//  Created by Tyler Jones on 4/11/26.
//

import CFFmpeg

public struct AVTime {
    
    /// Get the current time in microseconds.
    /// - Returns: `Int64` of microseconds
    public static func getTime() -> Int64 {
        av_gettime()
    }
    
    /// Get the current time in microseconds since some unspecified starting point.
    /// 
    /// On platforms that support it, the time comes from a monotonic clock This property makes this time source ideal for measuring relative time. The returned values may not be monotonic on platforms where a monotonic clock is not available.
    /// - Returns: `Int64` of microseconds
    public static func getRelativeTime() -> Int64 {
        av_gettime_relative()
    }
    
    /// Sleep for a period of time.
    /// - Parameter microseconds: the duration in which to sleep
    public static func sleep(for microseconds: Int64) throws {
        guard microseconds > 0, microseconds <= UInt32.max else { return }
        try throwIfFail(av_usleep(UInt32(microseconds)))
    }
}
