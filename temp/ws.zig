const std = @import("std");
const httpz = @import("httpz");
const websocket = httpz.websocket;
const net = std.net;

pub fn main() !void {
    const port = 9091;

    checkPortAvailable(port) catch |err| {
        std.debug.print("checked port={} error={}\n", .{ port, err });
        return;
    };

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var app = App{ .clients = std.SinglyLinkedList(App.WebsocketHandler){}, .allocator = allocator };
    var server = try httpz.Server(*App).init(allocator, .{ .port = port, .request = .{ .max_form_count = 10 } }, &app);
    defer {
        server.stop();
        server.deinit();
    }

    defer {
        var clients = app.clients;
        var client_op = clients.first;
        while (client_op) |client| {
            client.data.conn.closeSocket();
            clients.remove(client);
            client_op = client.next;
            client.data.conn.close(.{}) catch {
                continue;
            };
        }
    }

    var router = server.router(.{});
    router.post("/send", send, .{});
    router.get("/ws", ws, .{});
    try server.listen();
}

fn checkPortAvailable(port: u16) !void {
    const address = try net.Address.parseIp4("127.0.0.1", port);
    var server = try address.listen(.{});
    defer server.deinit();
}
const AllocationError = error{OutOfMemory};

const App = struct {
    allocator: std.mem.Allocator,
    clients: std.SinglyLinkedList(WebsocketHandler),
    pub fn broadcast(self: *App, msg: []const u8) !void {
        const clients = self.clients;
        var client_op = clients.first;
        while (client_op) |client| {
            try client.data.clientMessage(msg);
            client_op = client.next;
        }
    }
    // App-specific data you want to pass when initializing
    // your WebSocketHandler
    const WebsocketContext = struct { app: *App };

    // See the websocket.zig documentation. But essentially this is your
    // Application's wrapper around 1 websocket connection
    pub const WebsocketHandler = struct {
        conn: *websocket.Conn,
        context: ?WebsocketContext,
        // ctx is arbitrary data you passs to httpz.upgradeWebsocket
        pub fn init(conn: *websocket.Conn, context: WebsocketContext) !WebsocketHandler {
            std.debug.print("WebsocketHandler init\n", .{});
            const handler: WebsocketHandler = WebsocketHandler{
                .conn = conn,
                .context = context,
            };

            const node = try context.app.allocator.create(std.SinglyLinkedList(WebsocketHandler).Node);
            node.data = handler;

            std.debug.print("client init:> \n", .{});
            context.app.clients.prepend(node);

            return handler;
        }

        // echo back
        pub fn clientMessage(self: *WebsocketHandler, data: []const u8) !void {
            try self.conn.write(data);
        }

        pub fn close(self: *WebsocketHandler) void {
            // var allocator = self.context.?.app.allocator;
            var clients = &self.context.?.app.clients;
            var client_op = clients.first;

            std.debug.print("client closed:>0 {}\n", .{clients.len()});
            while (client_op) |client| {
                if (std.meta.eql(client.data, self.*)) {
                    // allocator.destroy(client.data);
                    std.debug.print("client closed:>1 \n", .{});
                    clients.remove(client);
                    self.context = null;
                    break;
                }
                client_op = client.next;
            }
            std.debug.print("client closed:>2 {}\n", .{clients.len()});
        }
    };
};

// curl -X POST -d "msg=youtube|ddd|ddd|124" "127.0.0.1:9091/send"
fn send(app: *App, req: *httpz.Request, _: *httpz.Response) !void {
    const data = try req.formData();
    std.debug.print("send {s}\n", .{data.get("msg").?});

    try app.broadcast(data.get("msg").?);
}

fn ws(app: *App, req: *httpz.Request, res: *httpz.Response) !void {
    if (try httpz.upgradeWebsocket(App.WebsocketHandler, req, res, App.WebsocketContext{ .app = app }) == false) {
        res.status = 400;
        res.body = "invalid websocket handshake";
        return;
    }
}
