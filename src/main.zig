const std = @import("std");

const List = @import("list.zig").List;

pub fn main() !void {
    // Our good old GPA.
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer std.debug.print("GPA result: {}\n", .{gpa.deinit()});
    var logging_alloc = std.heap.loggingAllocator(gpa.allocator());
    const allocator = logging_alloc.allocator();

    var list = try List(u8).init(allocator, 42);
    defer list.deinit();
    try list.append(13);
    try list.append(99);

    std.log.info("log.info {?}", .{list.lookup(13)});
    std.debug.print("debug.print {?}\n", .{list.lookup(33)});
}
