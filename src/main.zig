const std = @import("std");

fn indexOf(s: []const u8, sub: []const u8) usize {
    for (s, 0..) |_, i| {
        if (std.mem.startsWith(u8, s[i..], sub)) {
            return i;
        }
    }
    return std.math.maxInt(usize);
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var arr: [][]const u8 = undefined;
    arr = arr ++ .{"ddd"};
    const s = try std.mem.concat(allocator, u8, &arr);
    defer allocator.free(s);
    std.debug.print("Index: {s}\n", .{s});
}
