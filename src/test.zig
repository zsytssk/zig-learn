const std = @import("std");

const NodeMap = std.AutoHashMap(u8, []const u8);

pub fn main() !void {
    _ = try std.time.Timer.start();
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var map = NodeMap.init(allocator);
    defer map.deinit();

    const item = try map.getOrPut(2);
    if (!item.found_existing) {
        std.debug.print("{any}\n", .{item.key_ptr.*});
        item.value_ptr.* = "test";
    }

    if (map.get(2)) |n| {
        std.debug.print("{s}\n", .{n});
    }
    std.debug.print("{d}\n", .{std.fmt.format});
}
