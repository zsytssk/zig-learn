const std = @import("std");
const meta = std.meta;

// std.meta is the comptime metaprogramming bag of tricks!

// Use meta.Tag to obtain the tag type for a tagged union.
const Number = union(enum) {
    int: i32,
    float: f32,

    fn is(self: Number, tag: std.meta.Tag(Number)) bool {
        return self == tag;
    }
};

pub fn main() !void {
    std.debug.print("\n", .{});

    // meta.Tag
    var num: Number = .{ .int = 42 };
    std.debug.print("num.is(.int): {}\n", .{num.is(.int)});
    num = .{ .float = 3.1415 };
    std.debug.print("num.is(.float): {}\n", .{num.is(.float)});

    // meta.activeTag lets you know which tag is active in a tagged union.
    std.debug.print("Which is active? {s}\n", .{@tagName(meta.activeTag(num))});

    // meta.stringToEnum turns a string into an enum field.
    // It's the inverse of @tagName.
    const NumberTagEnum = meta.Tag(Number);
    std.debug.print("Number.int == \"int\": {}\n", .{NumberTagEnum.int == meta.stringToEnum(NumberTagEnum, "int")});

    // meta.Child returns the type of the elements of anything that
    // can have elements or the payload type of anything that can have
    // a payload; i.e. slices, arrays, optionals.
    std.debug.print("Element type of []const u8 == {}\n", .{meta.Child([]const u8)});
    std.debug.print("Payload type of ?u8 == {}\n", .{meta.Child(?u8)});

    // Use meta.Sentinel to convert a non-sentinel type to a sentinel type.
    std.debug.print("[]const u8 -> {}\n", .{meta.Sentinel([]const u8, 0)});

    // meta.containerLayout returns the memory layout of a type.
    std.debug.print(
        "Memory layout of Zig struct: {s}\n",
        .{@tagName(meta.containerLayout(struct { a: u8 }))},
    );
    std.debug.print(
        "Memory layout of Extern struct: {s}\n",
        .{@tagName(meta.containerLayout(extern struct { a: u8 }))},
    );
    std.debug.print(
        "Memory layout of Packed struct: {s}\n",
        .{@tagName(meta.containerLayout(packed struct { a: u8 }))},
    );

    // meta.fields lets you iterate over the fields of a type like
    // structs, enums, unions, and error sets.
    const fields = meta.fields(struct { a: u8, b: u16, c: f32 });
    // Since this is type data only available at comptime, you
    // have to use and inline for loop.
    inline for (fields) |field| {
        std.debug.print("{s}: {}\n", .{ field.name, field.type });
    }

    // meta.tags returns an array with the enum or error set fields.
    const tags = meta.tags(enum { a, b, c });
    std.debug.print("tags[2] == .{s}\n", .{@tagName(tags[2])});

    // meta.FieldEnum creates an enum from the fields of a type.
    const FE = meta.FieldEnum(struct { a: u8, b: u16, c: f32 });
    std.debug.print("FE.b: {s}\n", .{@tagName(FE.b)});

    // meta.DeclEnum creates an enum from the public declarations of a type.
    const DE = meta.DeclEnum(struct {
        pub const a: u8 = 0;
        pub const b: u16 = 0;
        pub const c: f32 = 0;
    });
    std.debug.print("DE.b: {s}\n", .{@tagName(DE.b)});

    // meta.eql is a generic equality function.
    const S1 = struct { a: u8, b: bool };
    const s_1 = S1{ .a = 42, .b = true };
    const s_2 = S1{ .a = 42, .b = true };
    const s_3 = S1{ .a = 13, .b = false };
    std.debug.print("s_1 == s_2: {}\n", .{meta.eql(s_1, s_2)});
    std.debug.print("s_1 == s_3: {}\n", .{meta.eql(s_1, s_3)});

    // meta.fieldIndex gets the index of a field as
    // defined in the source code.
    std.debug.print("S1.b index: {?}\n", .{meta.fieldIndex(S1, "a")});

    // meta.Int creates an integer type of the specified signedness and bits.
    const bits = comptime std.math.log2_int_ceil(usize, 1_140_000);
    std.debug.print("bits needed to represent 1 million: {}\n", .{bits});
    std.debug.print("int type to hold 1 million: {}\n", .{meta.Int(.unsigned, bits)});

    // meta.isError tells you if an error union is an error.
    var maybe_error: anyerror!u8 = error.NotANumber;
    std.debug.print("Is it an error? {}\n", .{meta.isError(maybe_error)});
    maybe_error = 42;
    std.debug.print("Is it an error? {}\n", .{meta.isError(maybe_error)});
}
