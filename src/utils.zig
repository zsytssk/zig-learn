pub fn eql(comptime T: type, a: []const T, b: []const T) bool {
    if (a.len != b.len) return false;
    if (a.ptr == b.ptr) return true;
    for (a, b) |a_elem, b_elem| {
        if (a_elem != b_elem) return false;
    }
    return true;
}

pub fn MsgStr(comptime ListSize: usize) type {
    return struct {
        list: [ListSize]u8,
        len: usize,
        const Self = @This();
        pub fn init() Self {
            return Self{ .list = undefined, .len = 0 };
        }
        pub fn set(self: *Self, str: []const u8) void {
            const max_len = @min(ListSize, str.len);
            @memcpy(self.list[0..max_len], str[0..max_len]);
            self.len = max_len;
        }

        pub fn get(self: *Self) []const u8 {
            return self.list[0..self.len];
        }
    };
}
