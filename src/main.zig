const std = @import("std");
// const c = @import("./c.zig");

pub fn main() anyerror!void {
    const a = 1;
    const b = brk: {
        if (a > 1) {
            break :brk 10;
        }
        break :brk 20;
    };

    std.debug.print("{?}\n", .{b});
}
