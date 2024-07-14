const std = @import("std");
const mem = std.mem;
const log = std.log;

pub fn Stack(comptime T: type) type {
    return struct {
        allocator: mem.Allocator,
        items: []T = &.{},
        len: usize = 0,
        cap: usize = 0,

        const Self = @This();
        const growth_factor = 2;

        pub fn freeAndReset(self: *Self) void {
            if (self.cap == 0) {
                return;
            }
            self.allocator.free(self.items.ptr[0..self.cap]);
            self.items = &.{};
            self.len = 0;
            self.cap = 0;
        }

        pub fn push(self: *Self, item: T) !void {
            if (self.len + 1 > self.cap) {
                try self.grow();
            }
            self.items.ptr[self.len] = item;
            self.len += 1;
        }
        pub fn pop(self: *Self) ?T {
            if (self.len == 0) {
                return null;
            }
            self.len -= 1;
            return self.items.ptr[self.len];
        }
        pub fn grow(self: *Self) !void {
            const old_cap = self.cap;
            const new_cap = if (self.cap == 0) 8 else growth_factor * old_cap;
            self.items = try self.allocator.realloc(self.items.ptr[0..self.cap], new_cap);
            log.debug("Grew {} -> {}\n", .{ self.cap, new_cap });
            self.cap = new_cap;
        }

        pub fn format(self: Self, comptime _: []const u8, _: std.fmt.FormatOptions, writer: anytype) !void {
            try writer.writeAll("Stack{ ");
            for (0..self.len) |i| {
                if (i != 0) {
                    try writer.writeAll(", ");
                }
                const item = self.items[i];
                try writer.print("{d}", .{item});
            }
            try writer.writeAll(" }");
        }
    };
}
