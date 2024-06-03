const std = @import("std");

const AutoHashMapUnmanaged = std.AutoHashMapUnmanaged;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer std.debug.print("GPA result: {}\n", .{gpa.deinit()});
    const allocator = gpa.allocator();

    var map: AutoHashMapUnmanaged(i32, i32) = .{};
    defer map.deinit(allocator);

    // Insert key-value pairs
    try map.put(allocator, 1, 10);
    try map.put(allocator, 2, 20);
    try map.put(allocator, 3, 30);

    // Lookup values
    const value = map.get(1);
    _ = map.getOrPutValue(allocator, 4, 100) catch |e| {
        return e;
    };
    if (value) |v| {
        std.debug.print("Key 1 has value {}\n", .{v});
    } else {
        std.debug.print("Key 1 not found\n", .{});
    }

    std.debug.print("map.count {}\n", .{map.count()});
    // Remove a key-value pair
    _ = map.remove(2);
    std.debug.print("map.count {}\n", .{map.count()});

    // Iterate over the key-value pairs
    var it = map.iterator();
    while (it.next()) |entry| {
        std.debug.print("Key: {any}, value:{any}\n", .{ entry.key_ptr.*, entry.value_ptr.* });
    }
}
