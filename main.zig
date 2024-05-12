const std = @import("std");
const print = std.debug.print;

pub fn main() !void {
    var a = "hello".*;
    a[0] = 'j';
    std.debug.print("{s}\n", .{a});
}
