const std = @import("std");

const Point = struct {
    x: i32,
    y: i32,
};

fn test1() void {}

pub fn main() void {
    // 使用 [2]u8
    var array1: [2]u8 = [2]u8{ 10, 20 };

    // 使用 const [2]u8
    const array2: []const u8 = array1[0..];
    const array3: *const [5]u8 = array1[0..] ++ .{ 1, 2, 3 };
    const array4: *const [2]u8 = array1[0..];
    array1[0] = 30; // 可以修改元素
    // const array5 = *array3;
    std.debug.print("{any} | {any} | {any} | {any} \n", .{ array1, array2, array3, array4.* });

    for (array4, 0..array1.len) |*item, i| {
        std.debug.print("array3Item:{}|{}\n", .{ i, item });
    }
    const a = &array1.len;
    std.debug.print("array1Item:{any}\n", .{a.*});

    // var p = Point{
    //     .x = 10,
    //     .y = 10,
    // };
    // @field(p, "x") = 20;
    // std.debug.print("{any}", .{p});

    // const fields: []const std.builtin.Type.StructField = &.{};
    // const typeInfo = .{ .Struct = .{
    //     .layout = .auto,
    //     .fields = fields,
    //     .decls = &.{},
    //     .is_tuple = false,
    // } };

    // _ = @Type(typeInfo);

    // const return_type = @typeInfo(@TypeOf(test1)).Fn.return_type;
    // std.debug.print("{any}\n", .{typeInfo.Struct.fields.len});
    // std.debug.print("{any}\n", .{@typeInfo(bool)});
    // std.debug.print("{any}\n", .{@Type(@typeInfo(bool))});

    // inline for (param) |field| {
    //     std.debug.print("{s}:{any}\n", .{ field.name, field.type });
    // }
}
