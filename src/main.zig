const std = @import("std");
const httpz = @import("httpz");
const websocket = httpz.websocket;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var handler = Handler{};
    var server = try httpz.Server(*Handler).init(allocator, .{ .port = 9091, .request = .{ .max_form_count = 10 } }, &handler);
    var router = server.router(.{});
    router.post("/send", send, .{});
    router.get("/ws", ws, .{});
    try server.listen();
}

const Handler = struct {
    // App-specific data you want to pass when initializing
    // your WebSocketHandler
    const WebsocketContext = struct {};

    // See the websocket.zig documentation. But essentially this is your
    // Application's wrapper around 1 websocket connection
    pub const WebsocketHandler = struct {
        conn: *websocket.Conn,

        // ctx is arbitrary data you passs to httpz.upgradeWebsocket
        pub fn init(conn: *websocket.Conn, _: WebsocketContext) !WebsocketHandler {
            return .{
                .conn = conn,
            };
        }

        // echo back
        pub fn clientMessage(self: *WebsocketHandler, data: []const u8) !void {
            try self.conn.write(data);
        }
    };
};

// curl -X POST -d "msg=youtube|ddd|ddd|124" "127.0.0.1:9091/send"
fn send(_: *Handler, req: *httpz.Request, res: *httpz.Response) !void {
    const data = try req.formData();
    try res.json(.{
        .msg = data.get("msg"),
    }, .{});
}

fn ws(_: *Handler, req: *httpz.Request, res: *httpz.Response) !void {
    if (try httpz.upgradeWebsocket(Handler.WebsocketHandler, req, res, Handler.WebsocketContext{}) == false) {
        res.status = 400;
        res.body = "invalid websocket handshake";
        return;
    }
}
