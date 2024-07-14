const std = @import("std");
const Stack = @import("./stack1.zig").Stack;
const mem = std.mem;
const heap = std.heap;

pub fn main() !void {
    var gpa = heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var stack = Stack(i32){ .allocator = allocator };
    defer stack.freeAndReset();

    for (0..10) |i| {
        try stack.push(@intCast(i));
        std.debug.print("{}\n", .{stack});
    }

    while (stack.pop()) |item| {
        std.debug.print("item: {}\n", .{item});
        std.debug.print("{}\n", .{stack});
    }

    for (0..10) |i| {
        try stack.push(@intCast(i + 10));
        std.debug.print("{}\n", .{stack});
    }
}
