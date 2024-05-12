const std = @import("std");
const print = std.debug.print;

pub fn main() !void {
    const a: u8 = 1;
    const b: *const u8 = &a;
    const c = &b;
    print("value: {any}\n", .{c});
}
// pub fn main() !void {
//     const a: u8 = 1;
//     const b: ?*const u8 = &a;
//     print("value: {any}\n", .{b});

//     if (b) |*c| {
//         print("value: {}, refer: {}\n", .{ c, c.* });
//     }
//     if (b) |c| {
//         print("value: {}, refer: {}\n", .{ c, c.* });
//     }
// }
