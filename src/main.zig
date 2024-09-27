const std = @import("std");
const httpz = @import("httpz");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var server = try httpz.Server().init(allocator, .{ .port = 5882 });

    // overwrite the default notFound handler
    server.notFound(notFound);

    // overwrite the default error handler
    server.errorHandler(errorHandler);

    var router = server.router(.{});

    // use get/post/put/head/patch/options/delete
    // you can also use "all" to attach to all methods
    router.get("/api/user/:id", getUser, .{});

    // start the server in the current thread, blocking.
    try server.listen();
}

fn getUser(req: *httpz.Request, res: *httpz.Response) !void {
    // status code 200 is implicit.

    // The json helper will automatically set the res.content_type = httpz.ContentType.JSON;
    // Here we're passing an inferred anonymous structure, but you can pass anytype
    // (so long as it can be serialized using std.json.stringify)

    try res.json(.{ .id = req.param("id").?, .name = "Teg" }, .{});
}

fn notFound(_: *httpz.Request, res: *httpz.Response) !void {
    res.status = 404;

    // you can set the body directly to a []u8, but note that the memory
    // must be valid beyond your handler. Use the res.arena if you need to allocate
    // memory for the body.
    res.body = "Not Found";
}

// note that the error handler return `void` and not `!void`
fn errorHandler(req: *httpz.Request, res: *httpz.Response, err: anyerror) void {
    res.status = 500;
    res.body = "Internal Server Error";
    std.log.warn("httpz: unhandled exception for request: {s}\nErr: {}", .{ req.url.raw, err });
}
