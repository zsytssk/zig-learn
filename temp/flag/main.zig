const std = @import("std");
const flags = @import("flag.zig");
const fmt = std.fmt;

pub fn main() !void {
    const arg = [_][*:0]const u8{ "-h", "-version", "-view-padding", "10", "-outer-padding", "100" };
    const result = flags.parser([*:0]const u8, &[_]flags.Flag{
        .{ .name = "h", .kind = .boolean },
        .{ .name = "version", .kind = .boolean },
        .{ .name = "view-padding", .kind = .arg },
        .{ .name = "outer-padding", .kind = .arg },
        .{ .name = "main-location", .kind = .arg },
        .{ .name = "main-count", .kind = .arg },
        .{ .name = "main-ratio", .kind = .arg },
    }).parse(arg[0..]) catch {
        std.debug.print("dfsdf", .{});
        return;
    };

    std.debug.print("{any}", .{result.flags});

    if (result.flags.@"view-padding") |raw| {
        const view_padding = fmt.parseUnsigned(u31, raw, 10) catch {
            return;
        };
        std.debug.print("view_padding: {any} \n", .{view_padding});
    }
    if (result.flags.@"outer-padding") |raw| {
        const outer_padding = fmt.parseUnsigned(u31, raw, 10) catch {
            return;
        };
        std.debug.print("outer_padding: {any} \n", .{outer_padding});
    }

    std.debug.print("version: {any}", .{result.flags.version});
}
