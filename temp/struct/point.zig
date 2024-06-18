const std = @import("std");
const Point = @This();

x: f32,
y: f32 = 1.0,

pub const step: f32 = 1.0;
pub const origin = Point{ .x = 0, .y = 0 };

pub fn new(x: f32, y: f32) Point {
    return .{ .x = x, .y = y };
}
pub fn add(a: *const Point, b: *const Point) Point {
    return .{
        .x = a.x + b.x,
        .y = a.y + b.y,
    };
}
pub fn increment(self: *Point) void {
    self.x += Point.step;
    self.y += Point.step;
}

pub fn format(self: Point, comptime fmt: []const u8, options: std.fmt.FormatOptions, writer: anytype) !void {
    _ = fmt;
    _ = options;
    try writer.print("Point{{.x ={[x]d:.2}, .y={[y]d:.2}}}", self);
}
