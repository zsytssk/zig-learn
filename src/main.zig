const std = @import("std");
const httpz = @import("httpz");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var server = try httpz.Server(void).init(allocator, .{ .port = 9091, .request = .{ .max_form_count = 10 } }, {});
    var router = server.router(.{});
    router.post("/send", send, .{});
    router.post("/ws", send, .{});
    try server.listen();
}

// curl -X POST -d "msg=youtube|ddd|ddd|124" "127.0.0.1:9091/send"
fn send(req: *httpz.Request, res: *httpz.Response) !void {
    const data = try req.formData();
    try res.json(.{
        .msg = data.get("msg"),
    }, .{});
}
