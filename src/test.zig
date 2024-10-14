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
    var app = App{ .clients = std.SinglyLinkedList(App.WebsocketHandler){}, .upgrade_res_list = std.SinglyLinkedList(*httpz.HTTPConn){}, .allocator = allocator };
    var server = try httpz.Server(*App).init(allocator, .{ .port = port, .request = .{ .max_form_count = 10 } }, &app);

    defer {
        server.stop();
        server.deinit();
        app.deinit();
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
    upgrade_res_list: std.SinglyLinkedList(*httpz.HTTPConn),

    pub fn broadcast(self: *App, msg: []const u8) !void {
        const clients = self.clients;
        var client_op = clients.first;
        while (client_op) |client| {
            try client.data.clientMessage(msg);
            client_op = client.next;
        }
    }
    pub fn bind_upgrade_res(self: *App, res: *httpz.Response) !void {
        const http_conn = res.conn;
        const node = try self.allocator.create(std.SinglyLinkedList(*httpz.HTTPConn).Node);
        node.data = http_conn;
        self.upgrade_res_list.prepend(node);
    }
    pub fn deinit(self: *App) void {
        var allocator = self.allocator;
        const list = self.upgrade_res_list;
        var node_op = list.first;
        while (node_op) |node| {
            const http_conn = node.data;
            const ws_worker: *websocket.server.Worker(WebsocketHandler) = @ptrCast(@alignCast(http_conn.ws_worker));
            const hc: *websocket.server.HandlerConn(WebsocketHandler) = @ptrCast(@alignCast(http_conn.handover.websocket));
            ws_worker.cleanupConn(hc);
            self.upgrade_res_list.remove(node);
            allocator.destroy(node);
            node_op = node.next;
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
        try app.bind_upgrade_res(res);
        return;
    }
}
