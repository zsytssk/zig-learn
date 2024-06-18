const std = @import("std");

pub fn main() anyerror!void {
    var map = std.StringHashMap(u8).init(std.heap.page_allocator);
    try map.put("hell", 1);
    try map.putNoClobber("hell", 3);
    const a = map.get("hell") orelse 9;
    std.debug.print("{any}\n", .{a});
}
