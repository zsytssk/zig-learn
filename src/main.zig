const std = @import("std");

pub fn main() void {
    const text: [*:0]const u8 = "Hello, world!";

    const span = std.mem.span(text);
    std.debug.print("Span: {any}\n", .{text.len});
    std.debug.print("Span: {any}\n", .{span.len});
}
