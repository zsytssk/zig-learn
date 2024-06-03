const std = @import("std");

pub fn main() !void {
    const bytes align(@alignOf(u32)) = [_]u8{ 0x12, 0x12, 0x12, 0x12 };
    const u32_ptr: *const u32 = @ptrCast(&bytes);
    std.debug.print("{any}", .{u32_ptr.*});
}
