x: f32,
y: f32,

const Point = @This();

pub fn new(x: f32, y: f32) Point {
    return .{ .x = x, .y = y };
}
pub fn distance(self: Point, other: Point) f32 {
    const distx = other.x - self.x;
    const disty = other.y - self.y;
    return @sqrt(distx * distx + disty * disty);
}
