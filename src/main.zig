const std = @import("std");

fn filterArrList1(allocator: std.mem.Allocator, comptime T: type) (fn (list: std.ArrayList([]const T), filter_fn: fn (item: []const T) bool) std.mem.Allocator.Error!std.ArrayList([]const T)) {
    return struct {
        fn run(list: std.ArrayList([]const T), filter_fn: fn (item: []const T) bool) std.mem.Allocator.Error!std.ArrayList([]const T) {
            var result = std.ArrayList([]const T).init(allocator);
            for (list.items) |item| {
                if (filter_fn(item)) {
                    try result.append(item);
                }
            }
            return result;
        }
    }.run;
}

fn filterStr(str: []const u8) bool {
    return indexOf(str, "world") == -1;
}

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    // 创建一个 ArrayList 来存储二维字节数组
    var arrayList = std.ArrayList([]const u8).init(allocator);
    defer arrayList.deinit();

    // 向 ArrayList 添加元素
    const a: []const u8 = "hello";
    const b: []const u8 = "world";
    const c: []const u8 = "wahaha";
    try arrayList.append(a);
    try arrayList.append(b);
    try arrayList.append(c);

    // const s = filterArrList1(allocator, u8);
    // std.debug.print("{any}", .{@TypeOf(concatArrayList)});

    const filterList = try filterArrList1(allocator, u8)(arrayList, filterStr);
    const res: []u8 = try concatArrayList(allocator, filterList, ", ");
    std.debug.print("test2:>{s}\n", .{res});
}

fn indexOf(s: []const u8, sub: []const u8) i32 {
    for (s, 0..) |_, i| {
        if (std.mem.startsWith(u8, s[i..], sub)) {
            return @intCast(i);
        }
    }
    return -1;
}

pub fn concatArrayList(allocator: std.mem.Allocator, arr: std.ArrayList([]const u8), splitor: []const u8) ![]u8 {
    var result: []u8 = "";
    // 打印数组内容
    for (arr.items, 0..) |slice, i| {
        result = try concatStr(allocator, result, slice);
        if (i != arr.items.len - 1) {
            result = try concatStr(allocator, result, splitor);
        }
    }
    return result;
}

pub fn concatStr(allocator: std.mem.Allocator, st1: []const u8, st2: []const u8) ![]u8 {
    const len = st1.len + st2.len;
    var result = try allocator.alloc(u8, len);
    @memcpy(result[0..st1.len], st1);
    @memcpy(result[st1.len..], st2);

    return result;
}
