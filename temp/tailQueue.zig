const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    var list = std.TailQueue(u8){};
    defer while (list.pop()) |item| {
        allocator.destroy(item);
    };

    const node1 = try allocator.create(std.TailQueue(u8).Node);
    errdefer allocator.destroy(node1);
    node1.data = 1;
    list.append(node1);

    const node2 = try allocator.create(std.TailQueue(u8).Node);
    errdefer allocator.destroy(node2);
    node2.data = 2;
    list.append(node2);

    std.debug.print("len: {d}\n", .{list.len});
    var it = list.first;
    while (it) |item| : (it = item.next) {
        std.debug.print("item: {}\n", .{it.?.data});
    }
}
