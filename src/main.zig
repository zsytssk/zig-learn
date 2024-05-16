const std = @import("std");

pub fn main() !void {
    std.debug.print("name:{any}\n", .{@typeInfo(@TypeOf(test1)) == .Fn});
    const args = std.meta.ArgsTuple(@TypeOf(test1));
    inline for (std.meta.fields(args)) |field| {
        std.debug.print("name:{s} | type:{any}\n", .{ field.name, field.type });
    }
}

fn test1(x: u8) u8 {
    return x;
}
