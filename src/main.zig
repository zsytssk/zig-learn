const std = @import("std");

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    const a = [_][]const u8{ "test", "test2" };

    var res: []u8 = "";
    for (a) |item| {
        res = std.fmt.allocPrint(allocator, "{s} {s}", .{ res, item }) catch |err| {
            std.debug.print("{s}:{any}", .{
                item,
                err,
            });
            return;
        };
    }

    std.debug.print("{s}", .{res});
}
