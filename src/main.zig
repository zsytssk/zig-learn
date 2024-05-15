const std = @import("std");
const Point = @import("point.zig");

pub fn main() !void {
    var p1 = Point.new(10, 10);
    const p2 = Point.new(12, 12);

    std.debug.print("{d:.2}\n", .{p1.distance(p2)});
    std.debug.print("{}\n", .{@TypeOf(Point)});
}
