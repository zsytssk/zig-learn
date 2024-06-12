x: i32,
y: i32,

const Point = @This();

pub fn new(x: i32, y: i32) Point {
    return .{ .x = x, .y = y };
}
