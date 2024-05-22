const std = @import("std");

const ziglyph = @import("ziglyph");
const letter = ziglyph.letter;
const number = ziglyph.number;

pub fn main() !void {
    std.debug.print("{}", .{ziglyph.isLetter('z')});
}
