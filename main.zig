const std = @import("std");
const print = std.debug.print;

pub fn main() void {
    var x: u32 = 10;
    {
        defer print("{d}\n", .{x});
        defer x += 2;
    }
    print("{d}\n", .{x});
}

fn addFive(x: u32) u32 {
    return x + 5;
}

fn fic(n: u32) u32 {
    if (n == 0 or n == 1) return 1;
    return fic(n - 1) + fic(n - 2);
}
