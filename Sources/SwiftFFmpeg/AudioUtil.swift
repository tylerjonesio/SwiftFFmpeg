//
//  AudioUtil.swift
//  SwiftFFmpeg
//
//  Created by sunlubo on 2018/8/2.
//

import CFFmpeg
@_exported
import struct CFFmpeg.AVChannelLayout
@_exported
import let CFFmpeg.AVChannelLayoutMono
@_exported
import let CFFmpeg.AVChannelLayoutStereo
@_exported
import let CFFmpeg.AVChannelLayout2Point1
@_exported
import let CFFmpeg.AVChannelLayout2_1
@_exported
import let CFFmpeg.AVChannelLayoutSurround
@_exported
import let CFFmpeg.AVChannelLayout3Point1
@_exported
import let CFFmpeg.AVChannelLayout4Point0
@_exported
import let CFFmpeg.AVChannelLayout4Point1
@_exported
import let CFFmpeg.AVChannelLayout2_2
@_exported
import let CFFmpeg.AVChannelLayoutQuad
@_exported
import let CFFmpeg.AVChannelLayout5Point0
@_exported
import let CFFmpeg.AVChannelLayout5Point1
@_exported
import let CFFmpeg.AVChannelLayout5Point0Back
@_exported
import let CFFmpeg.AVChannelLayout5Point1Back
@_exported
import let CFFmpeg.AVChannelLayout6Point0
@_exported
import let CFFmpeg.AVChannelLayout6Point0Front
@_exported
import let CFFmpeg.AVChannelLayoutHexagonal
@_exported
import let CFFmpeg.AVChannelLayout6Point1
@_exported
import let CFFmpeg.AVChannelLayout6Point1Back
@_exported
import let CFFmpeg.AVChannelLayout6Point1Front
@_exported
import let CFFmpeg.AVChannelLayout7Point0
@_exported
import let CFFmpeg.AVChannelLayout7Point0Front
@_exported
import let CFFmpeg.AVChannelLayout7Point1
@_exported
import let CFFmpeg.AVChannelLayout7Point1Wide
@_exported
import let CFFmpeg.AVChannelLayout7Point1WideBack
@_exported
import let CFFmpeg.AVChannelLayoutOctagonal
@_exported
import let CFFmpeg.AVChannelLayoutHexadecagonal
@_exported
import let CFFmpeg.AVChannelLayoutStereoDownmix
@_exported
import let CFFmpeg.AVChannelLayout22Point2

extension AVChannelLayout {
  /// Initialize a channel layout from a given string description.
  ///
  /// The input string can be represented by:
  ///  - the formal channel layout name (returned by av_channel_layout_describe())
  ///  - single or multiple channel names (returned by av_channel_name(), eg. "FL",
  ///    or concatenated with "+", each optionally containing a custom name after
  ///    a "@", eg. "FL@Left+FR@Right+LFE")
  ///  - a decimal or hexadecimal value of a native channel layout (eg. "4" or "0x4")
  ///  - the number of channels with default layout (eg. "4c")
  ///  - the number of unordered channels (eg. "4C" or "4 channels")
  ///  - the ambisonic order followed by optional non-diegetic channels (eg.
  ///    "ambisonic 2+stereo")
  ///
  /// - Parameter name: string describing the channel layout
  public init?(name: String) {
    var cl = AVChannelLayout()
    let r = av_channel_layout_from_string(&cl, name)
    guard r != 0 else {
      return nil
    }
    self = cl
  }

  /// The number of channels in the channel layout.
  public var channelCount: Int {
    Int(nb_channels)
  }

  /// Get the index of a given channel in a channel layout.
  /// In case multiple channels are found, only the first match will be returned.
  public func index(for channel: AVChannel) -> Int? {
    let i = withUnsafePointer(to: self) { ptr in
      av_channel_layout_index_from_channel(ptr, channel)
    }
    return i >= 0 ? Int(i) : nil
  }

  /// Get the channel with the given index in a channel layout.
  public func channel(at index: Int) -> AVChannel? {
    let c = withUnsafePointer(to: self) { ptr in
      av_channel_layout_channel_from_index(ptr, UInt32(index))
    }
    return c != AV_CHAN_NONE ? c : nil
  }

  /// Get the default channel layout for a given number of channels.
  public static func `default`(for channelCount: Int) -> AVChannelLayout {
    var cl = AVChannelLayout()
    av_channel_layout_default(&cl, Int32(channelCount))
    return cl
  }
}

extension AVChannelLayout: @retroactive Equatable {

  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.u.mask == rhs.u.mask
  }
}

extension AVChannelLayout: @retroactive CustomStringConvertible {

  public var description: String {
    let buf = UnsafeMutablePointer<Int8>.allocate(capacity: 256)
    buf.initialize(to: 0)
    defer { buf.deallocate() }
    let r = withUnsafePointer(to: self) { p in
      av_channel_layout_describe(p, buf, 256)
    }
    return r >= 0 ? String(cString: buf) : "Invalid"
  }
}
