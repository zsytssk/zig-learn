const std = @import("std");

pub fn main() !void {
    const array1 = [_]u8{ 1, 2, 3 };
    const array2: [3]u8 = .{ 1, 2, 3 };

    var array3: [3]u8 = undefined;
    // array3[0] = 1;
    // array3[1] = 2;
    // array3[2] = 3;

    array3[0], array3[1], array3[2] = .{ 1, 2, 3 };

    std.debug.print("{any} {any} {any}\n", .{ @TypeOf(array1), array2, array3 });
    std.debug.print("array1.len: {d}\n", .{array1.len});

    const grid3x3 = [_][3]u8{
        .{ 1, 2, 3 },
        .{ 4, 5, 6 },
        .{ 7, 8, 9 },
    };

    std.debug.print("grid3x3: {any}\n", .{grid3x3});
}
