pub fn Point(comptime T: type) type {
    return struct {
        x: T,
        y: T,

        const Self = @This();

        pub fn new(x: T, y: T) Self {
            return .{ .x = x, .y = y };
        }
        pub fn distance(self: Self, other: Self) f64 {
            // const distx = other.x - self.x;
            // const disty = other.y - self.y;
            const diffx: f64 = switch (@typeInfo(T)) {
                .Int => @floatFromInt(other.x - self.x),
                .Float => other.x - self.x,
                else => @compileError("Only int and float are supported"),
            };
            const diffy: f64 = switch (@typeInfo(T)) {
                .Int => @floatFromInt(other.y - self.y),
                .Float => other.y - self.y,
                else => @compileError("Only int and float are supported"),
            };

            return @sqrt(diffx * diffx + diffy * diffy);
        }
    };
}
