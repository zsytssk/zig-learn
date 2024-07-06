const std = @import("std");
const fmt = std.fmt;
const mem = std.mem;

//  1280 byte max non-fragment IP packet
//    60 byte IP header
// -   8 byte UDP header
//  ----
//  1212 total available UDP payload bytes
pub const udp_payload_len = 1212;
pub const data_len = udp_payload_len - Header.len;

/// Message type codes.
pub const Code = enum(u4) {
    /// Test connectivity.
    ping,

    /// Request a resource.
    get,
};

/// The payload header. This is not the IP or UDP header.
/// It's our own header at the start of the UDP payload segment.
pub const Header = packed struct {
    //    4 bit version
    //    4 bit code
    //   28 bit datagram sequence index
    // + 28 bit total datagrams
    //   --
    //   64 bits (8 bytes)

    // Integer type for encoded header.
    pub const Type = u64;
    pub const len = @sizeOf(Type);

    /// 4 bit version number (0-15).
    version: u4 = 0,

    /// 4 bit message type.
    code: Code = .get,

    /// Total UDP datagrams required.
    total: u28 = 1,

    /// Sequence index of this datagram.
    index: u28 = 0,

    /// Read and decode a header from the start of `buf`.
    pub fn read(buf: []const u8) Header {
        return @bitCast(mem.readInt(Type, buf[0..len], .big));
    }

    /// Encode and write a header to the start of `buf`.
    pub fn write(self: Header, buf: []u8) void {
        mem.writeInt(Type, buf[0..len], @bitCast(self), .big);
    }
};
