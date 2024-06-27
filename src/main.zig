const std = @import("std");
const print = std.debug.print;

const protocol = @import("protocol.zig");

const S = packed struct {
    a: u3 = 0,
    b: u3 = 0,
    c: u2 = 0,
};

pub fn main() !void {
    const s1 = S{};
    layout(&s1);

    // // Simple bit cast example.
    const bits: u8 = 0b11_011_100; // c: 3, b: 3, a: 5
    const s2: S = @bitCast(bits);
    print("a: {[a]}, b: {[b]}, c: {[c]}\n", s2);
    print("\n", .{});

    // // Real-life packed struct / bit cast example.
    const h_original = protocol.Header{
        .version = 0,
        .code = .get,
        .index = 0,
        .total = 1,
    };
    print("original: {any}\n", .{h_original});

    var buf: [256]u8 = undefined;
    h_original.write(&buf);
    print("buf: {any}\n", .{buf});

    const h_received = protocol.Header.read(&buf);
    print("received: {any}\n", .{h_received});
}

fn layout(s: *const S) void {
    // Info about struct type S.
    print("Type:\t{}\n", .{S});
    print("\tsize:\t{}\n", .{@sizeOf(S)});
    print("\talign:\t{}\n", .{@alignOf(S)});
    print("\n", .{});

    // Info about struct type S fields.
    const info = @typeInfo(S);

    inline for (info.Struct.fields) |field| {
        print("Field:\t{s}\n", .{field.name});
        print("\tsize:\t{}\n", .{@sizeOf(field.type)});
        print("\toffset:\t{}\n", .{@offsetOf(S, field.name)});
        print("\talign:\t{}\n", .{field.alignment});
        print("\taddr:\t{*}\n", .{&@field(s, field.name)});
        print("\n", .{});
    }
}
