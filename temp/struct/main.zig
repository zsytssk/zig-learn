const std = @import("std");
// const c = @import("./c.zig");
const Point = @import("./point.zig");

pub fn main() anyerror!void {
    const p1 = Point.new(1.0, 1.0);
    const p2 = Point.new(2.0, 2.0);
    const p3 = p1.add(&p2);
    std.debug.print("{any}:{}\n", .{ @TypeOf(p3), p3 });

    var p4 = Point.origin;
    p4.increment();
    std.debug.print("{}\n", .{p4});
    std.debug.print("{}\n", .{Point.origin});
}
