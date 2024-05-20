const std = @import("std");

pub fn main() !void {
    // Define a tuple typed constant.
    const tuple_a: struct { u8, bool } = .{ 42, true };
    std.debug.print("tuple_a: {any}, {}\n", .{ tuple_a, @TypeOf(tuple_a) });

    // You can index tuples.
    std.debug.print("tuple_a[0]: {}\n", .{tuple_a[0]});
    // They have a len field too.
    std.debug.print("tuple_a.len: {}\n", .{tuple_a.len});

    // You can access fields with @"".
    std.debug.print("tuple_a.@\"0\": {}\n", .{tuple_a.@"0"});
    // Side note: @"" can be used anywhere an identifier can.
    // It allows otherwise illegal identifiers.
    const @"123" = 123;
    _ = @"123";
    const @"while" = "a keyword!";
    _ = @"while";

    // You can concatenate tuples with other tuples...
    const tuple_b: struct { f16, i32 } = .{ 3.14, -42 };
    const tuple_c = tuple_a ++ tuple_b;
    std.debug.print("tuple_c: {any}\n", .{tuple_c});

    // If all fields are of the same type, you can concatenate
    // tuples with arrays too.
    const array: [3]u8 = .{ 1, 2, 3 }; // Note tuple coerced to array.
    const tuple_d = .{ 4, 5, 6 };
    const result = array ++ tuple_d;
    std.debug.print("result: {any}, {}\n", .{ result, @TypeOf(result) });

    // You can iterate tuples with inline for.
    inline for (tuple_c, 0..) |value, i| {
        std.debug.print("{}: {}, ", .{ i, value });
    }
    std.debug.print("\n", .{});

    // You can index a pointer to a tuple like a pointer to an array.
    const ptr = &tuple_c;
    std.debug.print("ptr[0]: {}\n", .{ptr[0]});
    std.debug.print("ptr.@\"0\": {}\n", .{ptr.@"0"});

    // ** repetition works on tuples too.
    const tuple_e = tuple_a ** 2;
    std.debug.print("tuple_e: {any}\n", .{tuple_e});

    // varargs in Zig functions can be done with tuples and comptime
    // type reflection.
    // varargsInZig(.{ 42, 3.14, false });
    // const S = struct {
    //     a: u8,
    //     b: bool,
    // };
    // const s = S{ .a = 42, .b = true };
    // varargsInZig(s);
    varargsInZig(42);
}

fn varargsInZig(x: anytype) void {
    // Get type info.
    const info = @typeInfo(@TypeOf(x));
    // Check if it's a tuple.
    if (info != .Struct) @panic("Not a tuple!");
    if (!info.Struct.is_tuple) @panic("Not a tuple!");
    // Do stuff...
    inline for (x) |field| std.debug.print("{}\n", .{field});
}
