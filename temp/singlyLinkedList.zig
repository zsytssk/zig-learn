const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    var list = std.SinglyLinkedList(u8){};
    defer while (list.popFirst()) |item| {
        allocator.destroy(item);
    };

    const node = try allocator.create(std.SinglyLinkedList(u8).Node);
    errdefer allocator.destroy(node);
    list.prepend(node);
    std.debug.print("{d}\n", .{list.len()});
}
