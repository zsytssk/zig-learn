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
    node.data = 10;
    errdefer allocator.destroy(node);
    list.prepend(node);

    var nd = list.first;
    while (nd) |n| {
        std.debug.print("{d}\n", .{n.data});
        nd = n.next;
    }
    std.debug.print("{d}\n", .{list.len()});
}
