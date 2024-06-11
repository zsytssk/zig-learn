const std = @import("std");

pub fn Iterator(comptime T: type, comptime Context: type, comptime next: fn (context: *Context) ?T) type {
    return struct {
        context: *Context,
        const Self = @This();
        pub fn len(self: Self) usize {
            var counter: usize = 0;
            while (next(self.context)) |_| : (counter += 1) {}
            return counter;
        }
        fn _map(comptime B: type, comptime MapContext: type, comptime f: Map(MapContext, T, B)) type {
            return Iterator(B, Context, struct {
                fn inext(context: *Context) ?B {
                    if (next(context)) |value| {
                        return f.map(value);
                    }
                    return null;
                }
            }.inext);
        }
        pub fn map(self: Self, comptime B: type, comptime MapContext: type, comptime f: Map(MapContext, T, B)) _map(B, MapContext, f) {
            return .{ .context = self.context };
        }
        fn _filter(comptime FilterContext: type, comptime f: Filter(FilterContext, T)) type {
            return Iterator(T, Context, struct {
                fn inext(context: *Context) ?T {
                    if (next(context)) |value| {
                        if (f.filter(value)) {
                            return inext(context);
                        }
                        return value;
                    }
                    return null;
                }
            }.inext);
        }
        pub fn filter(self: Self, comptime FilterContext: type, comptime f: Filter(FilterContext, T)) _filter(FilterContext, f) {
            return .{ .context = self.context };
        }

        pub fn reduce(self: Self, comptime ReduceContext: type, comptime r: Reduce(ReduceContext, T), initial: T) T {
            var temp: T = initial;
            while (next(self.context)) |val| {
                temp = r.reduce(temp, val);
            }
            return temp;
        }
        pub fn toArray(self: Self, allocator: std.mem.Allocator) !std.ArrayList(T) {
            var arr = std.ArrayList(T).init(allocator);
            while (next(self.context)) |value| {
                try arr.append(value);
            }
            return arr;
        }
    };
}

pub fn Map(comptime Context: type, comptime i: type, comptime o: type) type {
    return struct {
        c: Context,
        m: *const fn (context: Context, in: i) o,
        fn map(self: @This(), in: i) o {
            return self.m(self.c, in);
        }
    };
}

pub fn Filter(comptime Context: type, comptime i: type) type {
    return struct {
        c: Context,
        f: *const fn (context: Context, in: i) bool,
        fn filter(self: @This(), in: i) bool {
            return self.f(self.c, in);
        }
    };
}

pub fn Reduce(comptime Context: type, comptime i: type) type {
    return struct {
        c: Context,
        r: *const fn (context: Context, lhs: i, rhs: i) i,
        fn reduce(self: @This(), lhs: i, rhs: i) i {
            return self.r(self.c, lhs, rhs);
        }
    };
}
