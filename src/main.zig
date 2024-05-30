const std = @import("std");

const Window = opaque {
    fn test1() void {
        std.debug.print("hello world", .{});
    }
};
const Button = opaque {};

pub fn main() !void {
    const main_window = Window;
    main_window.test1();
}
