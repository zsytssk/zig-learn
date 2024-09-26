const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var map = std.StringHashMap(i32).init(allocator);
    defer map.deinit();

    try map.put("key1", 42);
    try map.put("key2", 100);

    const value1 = map.get("key1") orelse unreachable;
    const value2 = map.get("key2") orelse unreachable;

    std.debug.print("key1: {}\n", .{value1});
    std.debug.print("key2: {}\n", .{value2});
}
