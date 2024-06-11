const std = @import("std");
const iterator = @import("iterator.zig");
const Iterator = iterator.Iterator;
const Map = iterator.Map;
const Filter = iterator.Filter;
const Reduce = iterator.Reduce;

fn next(context: *std.ArrayList(usize)) ?usize {
    return context.popOrNull();
}

fn map(context: std.mem.Allocator, in: u64) []const u8 {
    return std.fmt.allocPrint(context, "{d}", .{in}) catch @panic("cannot convert");
}

fn filter(_: void, i: usize) bool {
    return i % 2 == 0;
}

fn reduce(context: std.mem.Allocator, lhs: []const u8, rhs: []const u8) []const u8 {
    return std.mem.join(context, "--", &.{ lhs, rhs }) catch @panic("reduce error");
}

pub fn main() !void {
    // Initialize a type.
    // Example:ArrayList is initialized with a sequence of 10 numbers
    var arr = try std.ArrayList(usize).initCapacity(std.heap.page_allocator, 5);
    for (0..10) |v| {
        try arr.append(v);
    }

    // Create an Iterator from the type and the way to iterate to next value followed by initialization of Iterator.
    // Example: next function iterates through array in reverse order and iterator is initialized by ArrayList value
    var si = Iterator(usize, std.ArrayList(usize), next){ .context = &arr };

    // Create mapper, filter and reducer with context for the type
    // Example: Refer to map + filter + reduce functions that operate on ArrayList type and context will be Allocator for map and reduce.
    const mapper = Map(std.mem.Allocator, usize, []const u8){ .c = std.heap.page_allocator, .m = &map };
    const filters = Filter(void, usize){ .c = {}, .f = &filter };
    const reducer = Reduce(std.mem.Allocator, []const u8){ .c = std.heap.page_allocator, .r = &reduce };

    // Chain the functions and pass the mapper, filter and reducer to operate on the intialized value
    // Example: filter: filters even numbers, map: converts to string i.e, []const u8 and concatenates rest of the array by -- with a starting token.
    const arra = si.filter(void, filters).map([]const u8, std.mem.Allocator, mapper).reduce(std.mem.Allocator, reducer, "<start>");

    // Print the value post all operations.
    std.debug.print("{s}", .{arra});
}
