//   - `[]const u8` -> runtime 确定大小
//   - `*const [5]u8` -> pointer for array
//   - `[*]const u8` -> pointer for array, 不知道 len
//   - `[:0]const u8` -> 和 c 交互的 array
const std = @import("std");

fn display(items: []const u8) void {
    for (0..items.len) |i| {
        std.debug.print("item {}: {}\n", .{ i, items[i] });
    }
}

pub fn main() void {
    const array = [_]u8{ 0, 1, 2, 4, 5, 0 };
    std.debug.print("{}\n", .{@TypeOf(array)});

    const slice1: []const u8 = array[0..];
    display(slice1);

    const slice2 = array[0..2];
    std.debug.print("{}\n", .{@TypeOf(slice2)});
    display(slice2);

    var start: usize = 1;
    _ = &start;
    const slice3 = array[start..2];
    std.debug.print("{}\n", .{@TypeOf(slice3)});
    display(slice3);

    const slice4: [:0]const u8 = array[0 .. array.len - 1 :0];
    std.debug.print("{}\n", .{@TypeOf(slice4)});
    display(slice4);
}
