const std = @import("std");

pub fn main() !void {
    const str1: [*:0]const u8 = "test";
    std.debug.print("st1:>{s}:{any}\n", .{ str1, @TypeOf(str1) });

    const str2: []const u8 = std.mem.span(str1);
    std.debug.print("st2:>{s}:{any}\n", .{ str1, @TypeOf(str2) });

    const str3: [:0]const u8 = undefined;
    @memcpy(str3[0..str2.len], str2[0..]);
    str3[str2.len] = 0;
    std.debug.print("str3:>{s}:{any}\n", .{ std.mem.span(str3), @TypeOf(str3) });

    // const str4: [*:0]const u8 = "yes";
    // @memcpy(str3[0..str4.len], str4[0..]);
    // std.debug.print("str3:>{s}:{any}\n", .{ str3[0..str2.len], @TypeOf(str3) });
}
