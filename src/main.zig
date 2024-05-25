const std = @import("std");

const Method = enum {
    get,
    post,
    put,

    // To print a struct with the default format specifier,
    // you must define this `format` method within it.
    // Typically, you only need to use the `writer` parameter,
    // aside from the struct instance itself.
    pub fn format(
        self: Method,
        comptime _: []const u8,
        _: std.fmt.FormatOptions,
        writer: anytype,
    ) !void {
        switch (self) {
            .get => try writer.writeAll("GET"),
            .post => try writer.writeAll("POST"),
            .put => try writer.writeAll("PUT"),
        }
    }
};

const Encoding = enum {
    brotli,
    deflate,
    gzip,

    pub fn format(
        self: Encoding,
        comptime _: []const u8,
        _: std.fmt.FormatOptions,
        writer: anytype,
    ) !void {
        switch (self) {
            .brotli => try writer.writeAll("br"),
            // inline else will fill in the rest of the options.
            // @tagName returns the string version of the enum tag.
            inline else => |enc| try writer.writeAll(@tagName(enc)),
        }
    }
};

const Version = enum {
    // Here we use the @"" syntax that allows
    // for characters that would normally be invalid
    // in an identifier.
    @"1.0",
    @"1.1",
    @"2",
    @"3",

    pub fn format(
        self: Version,
        comptime _: []const u8,
        _: std.fmt.FormatOptions,
        writer: anytype,
    ) !void {
        switch (self) {
            inline else => |ver| try writer.writeAll("HTTP/" ++ @tagName(ver)),
        }
    }
};

const Request = struct {
    accept: []const Encoding = &.{
        .deflate,
        .gzip,
        .brotli,
    },
    body: []const u8 = "Hello, World!\n",
    method: Method = .get,
    path: []const u8 = "/",
    version: Version = .@"1.1",

    pub fn format(
        self: Request,
        comptime _: []const u8,
        _: std.fmt.FormatOptions,
        writer: anytype,
    ) !void {
        // Multi-line strings can come in handy when preparing
        // complex format strings.
        const fmt_str_1 =
            \\{} {s} {}
            \\Accept-Encoding:
        ;
        _ = try writer.print(fmt_str_1, .{ self.method, self.path, self.version });

        // To print out a comma separated list, we loop over
        // the items of the accept slice.
        for (self.accept, 0..) |enc, i| {
            if (i != 0) try writer.writeAll(", ");
            _ = try writer.print("{}", .{enc});
        }

        const fmt_str_2 =
            \\
            \\
            \\{s}
        ;
        _ = try writer.print(fmt_str_2, .{self.body});
    }
};

pub fn main() !void {
    var req = Request{};
    std.debug.print("{}\n", .{req});

    req.method = .put;
    req.path = "/about.html";
    req.accept = &.{.gzip};
    req.body = "Bye!";
    std.debug.print("{}\n", .{req});
}
