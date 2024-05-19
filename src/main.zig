const std = @import("std");

// const List = @import("list.zig").List;
const List = @import("list_arena.zig").List;

pub fn main() !void {
    // Our good old GPA.
    // var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    // defer std.debug.print("GPA result: {}\n", .{gpa.deinit()});

    // Logs all allocations and frees.

    // For the arena.
    var logging_alloc = std.heap.loggingAllocator(std.heap.page_allocator);

    const allocator = logging_alloc.allocator();

    // Let's allocate!
    var list = try List(u8).init(allocator, 42); // 1
    defer list.deinit(); // free at scope exit
    try list.append(13); // 2
    try list.append(99); // 3

    // When integrating with C, use
    // std.heap.c_allocator;

    // When targetting WASM, use
    // std.heap.wasm_allocator;
}

test "Allocation failure" {
    const allocator = std.testing.failing_allocator;
    const list = List(u8).init(allocator, 42);
    try std.testing.expectError(error.OutOfMemory, list);
}

// Use a memory pool when all the objects being allocated have the same type.
// This is more efficient since previously allocated slots can be re-used
// instead of allocating new ones.
test "memory pool: basic" {
    const MemoryPool = std.heap.MemoryPool;

    var pool = MemoryPool(u32).init(std.testing.allocator);
    defer pool.deinit();

    const p1 = try pool.create();
    const p2 = try pool.create();
    const p3 = try pool.create();

    // Assert uniqueness
    try std.testing.expect(p1 != p2);
    try std.testing.expect(p1 != p3);
    try std.testing.expect(p2 != p3);

    pool.destroy(p2);
    const p4 = try pool.create();

    // Assert memory reuse
    try std.testing.expect(p2 == p4);
}
