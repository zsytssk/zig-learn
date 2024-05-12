const std = @import("std");
const print = std.debug.print;

pub fn main() !void {
    var array = [_]u8{ 1, 2, 3, 4, 5 };
    var d_ptr: [*]u8 = &array;
    d_ptr[1] += 1;
    print("d_ptr: {*}, array:{any} \n", .{ d_ptr, @TypeOf(d_ptr) });

    // ---
    const c_ptr = &array;
    c_ptr[0] += 2;
    print("c_ptr[0]: {}, array:{any}， len:{any}\n", .{ c_ptr[0], @TypeOf(c_ptr), c_ptr.len });

    array[3] = 0;
    const f_ptr: [*:0]const u8 = array[0..3 :0];
    print("f_ptr[0]: {any}, array:{any}\n", .{ f_ptr[0], @TypeOf(f_ptr) });

    const adress = @intFromPtr(f_ptr);
    const g_ptr: [*:0]const u8 = @ptrFromInt(adress);
    print("adress:{}, g_ptr[0]: {any}, array:{any}\n", .{ adress, g_ptr[0], @TypeOf(g_ptr) });

    var h_ptr: ?*const usize = null;
    print("h_ptr: {any}, h_ptr type:{any}\n", .{ h_ptr, @TypeOf(h_ptr) });
    h_ptr = &adress;
    print("h_ptr: {}, h_ptr type:{any}\n", .{ h_ptr.?.*, @TypeOf(h_ptr) });
}
