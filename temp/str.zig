const std = @import("std");

pub fn main() !void {
    try test5();
}

fn test5() !void {
    const allocator = std.heap.page_allocator;
    const a = [_][]const u8{ "hello", "wrold", "hhaa" };

    var res: []u8 = "";
    for (a) |item| {
        res = std.fmt.allocPrint(allocator, "{s} {s}", .{ res, item }) catch |err| {
            std.debug.print("{s}:{any}", .{
                item,
                err,
            });
            return;
        };
    }

    std.debug.print("{s}", .{res});
}

fn test4() !void {
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

    const res1: []u8 = try concatArrayList(u8, allocator, arrayList, ", ");
    // 打印数组内容
    std.debug.print("test1:>{s}\n", .{res1});

    var filterList1 = std.ArrayList([]const u8).init(allocator);
    // 打印数组内容
    for (arrayList.items) |item| {
        if (indexOf(item, "waha") != -1) {
            continue;
        }
        try filterList1.append(item);
    }
    const res2: []u8 = try concatArrayList(u8, allocator, filterList1, ", ");
    std.debug.print("test2:>{s}\n", .{res2});

    const filterList2 = try filterArrList(u8, allocator, arrayList, filterStr);
    const res: []u8 = try concatArrayList(u8, allocator, filterList2, ", ");
    std.debug.print("test3:>{s}\n", .{res});
}

fn filterStr(str: []const u8) bool {
    return indexOf(str, "waha") == -1;
}

fn ArrList(comptime T: type) type {
    return std.ArrayList([]const T);
}
fn Arr(comptime T: type) type {
    return []const T;
}
fn filterArrList(T: type, allocator: std.mem.Allocator, list: ArrList(T), filter_fn: fn (item: Arr(T)) bool) std.mem.Allocator.Error!ArrList(T) {
    var result = ArrList(T).init(allocator);
    for (list.items) |item| {
        if (filter_fn(item)) {
            try result.append(item);
        }
    }
    return result;
}

fn indexOf(s: []const u8, sub: []const u8) i32 {
    for (s, 0..) |_, i| {
        if (std.mem.startsWith(u8, s[i..], sub)) {
            return @intCast(i);
        }
    }
    return -1;
}

pub fn concatArrayList(T: type, allocator: std.mem.Allocator, arr: std.ArrayList([]const T), splitor: []const T) ![]T {
    var result: []T = "";
    // 打印数组内容
    for (arr.items, 0..) |slice, i| {
        result = try concatStr(T, allocator, result, slice);
        if (i != arr.items.len - 1) {
            result = try concatStr(T, allocator, result, splitor);
        }
    }
    return result;
}

pub fn concatStr(T: type, allocator: std.mem.Allocator, st1: []const T, st2: []const T) ![]T {
    const len = st1.len + st2.len;
    var result = try allocator.alloc(T, len);
    @memcpy(result[0..st1.len], st1);
    @memcpy(result[st1.len..], st2);

    return result;
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

    const res: []u8 = try concatArrayList(u8, allocator, arrayList, ", ");
    // 打印数组内容
    std.debug.print("{s}\n", .{res});
}

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
