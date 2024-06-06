const std = @import("std");

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

    const res1: []u8 = try concatArrayList(allocator, arrayList, ", ");
    // 打印数组内容
    std.debug.print("test1:>{s}\n", .{res1});

    var filterList = std.ArrayList([]const u8).init(allocator);
    // 打印数组内容
    for (arrayList.items) |item| {
        if (indexOf(item, "waha") != -1) {
            continue;
        }
        try filterList.append(item);
    }
    const res2: []u8 = try concatArrayList(allocator, filterList, ", ");
    std.debug.print("test2:>{s}\n", .{res2});
}

fn indexOf(s: []const u8, sub: []const u8) i32 {
    for (s, 0..) |_, i| {
        if (std.mem.startsWith(u8, s[i..], sub)) {
            return @intCast(i);
        }
    }
    return -1;
}

pub fn test1() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const arr = [_][]const u8{ "hello ", "world" };
    const s = try std.mem.concat(allocator, u8, &arr);
    defer allocator.free(s);
    std.debug.print("Index: {s}\n", .{s});
}

// string type convert  [*:0]const u8 -> []const u8 -> [*:0]const u8
pub fn test3() !void {
    const str1: [*:0]const u8 = "test";
    std.debug.print("st1:>{s}:{any}\n", .{ str1, @TypeOf(str1) });

    const str2: []const u8 = std.mem.span(str1);
    std.debug.print("st2:>{s}:{any}\n", .{ str1, @TypeOf(str2) });

    var str3: [128]u8 = undefined;
    @memcpy(str3[0..str2.len], str2);
    str3[str2.len] = 0;
    std.debug.print("str3:>{s}:{any}\n", .{ str3[0..str2.len], @TypeOf(str3) });

    const str4: [*:0]const u8 = str3[0..str2.len :0];
    std.debug.print("str4:>{s}:{any}\n", .{ str4, @TypeOf(str4) });
}

// std.ArrayList
pub fn test2() !void {
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

    const res: []u8 = try concatArrayList(allocator, arrayList, ", ");
    // 打印数组内容
    std.debug.print("{s}\n", .{res});
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
