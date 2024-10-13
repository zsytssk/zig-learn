// const std = @import("std");

// pub fn main() !void {
//     var gpa = std.heap.GeneralPurposeAllocator(.{}){};
//     const allocator = gpa.allocator();

//     var b = App{};
//     const a = try allocator.create(std.SinglyLinkedList(*App).Node);
//     a.data = &b;
//     const c: ?*App = &b;

//     // a.data.init1();
//     // b.init1();
//     // c.eq(&b);

//     std.debug.print("init1:{}\n", .{c.?.isEq(&b)});
// }
// const App = struct {
//     pub fn isEq(self: *App, other: *App) bool {
//         std.debug.print("point:{}:{}\n", .{ @intFromPtr(self), @intFromPtr(other) });
//         return std.meta.eql(other, self);
//     }
// };

const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var b = App{};
    const a = try allocator.create(std.SinglyLinkedList(*App).Node);
    a.data = &b;
    var c: ?App = b;

    // a.data.init();
    // b.init();
    // _ = c.?.init(&b);
    std.debug.print("init1:{}\n", .{c.?.isEq(&b)});
}
const App = struct {
    pub fn isEq(self: *App, other: *App) bool {
        std.debug.print("point:{}:{}\n", .{ @intFromPtr(self), @intFromPtr(other) });
        return std.meta.eql(other.*, self.*);
    }
};
