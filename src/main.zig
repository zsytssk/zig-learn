const std = @import("std");

const Num = union(enum) {
    Int,
    Float: void,
    PI: f64,
    fn is(self: Num, tag: std.meta.Tag(Num)) bool {
        return self == tag;
    }
    fn isSame(self: *Num, tag: std.meta.Tag(Num)) bool {
        return self == tag;
    }
};

pub const Action = union(enum) {
    move: void,
    resize: void,
    command: []const [:0]const u8,
};

// stringToEnum(meta.Tag(Config.AttachMode), args[1])
pub fn main() anyerror!void {
    const a: Num = .Int;
    std.debug.print("{any}\n", .{a});
    const b = std.meta.stringToEnum(std.meta.Tag(Num), "Int");
    if (b) |_| {
        std.debug.print("{any}\n", .{b == a});
    }
    std.debug.print("{any}\n", .{b == .Int});

    // switch (a) {
    //     inline b => std.debug.print("hello", .{}),
    //     else => std.debug.print("world", .{}),
    // }
    // std.debug.print("{}", .{a == std.meta.Tag(Num)});
}
