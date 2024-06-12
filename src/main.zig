const std = @import("std");
// const c = @import("./c.zig");
const point = @import("./point.zig");

pub fn main() anyerror!void {
    const p = point.new(12, 12);
    std.debug.print("{any}\n", .{p});
}
