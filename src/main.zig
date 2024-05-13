const std = @import("std");
const print = std.debug.print;

pub fn main() !void {
    var array = [_]u8{ 0, 1, 2, 3, 4, 5 };
    for (array) |item| {
        print("{d} ", .{item});
    }
    print("\n", .{});

    for (array, 0..) |item, i| {
        print("{d}:{d} ", .{ i, item });
    }
    print("\n", .{});

    for (0..10) |item| {
        print("{d}", .{item});
    }

    print("\n", .{});

    var sum: u8 = 0;
    for (array) |item| {
        if (item == 2) continue;
        if (item == 4) break;
        sum += item;
    }
    print("sum:{d}", .{sum});

    print("\n", .{});

    const array2: *[6]u8 = &array;

    for (array2) |*item| {
        // item.* += 1;
        print("{d}", .{item});
    }
    print("array:{any}", .{array});
}
