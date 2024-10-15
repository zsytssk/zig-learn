const std = @import("std");
const httpz = @import("httpz");
const websocket = httpz.websocket;
const net = std.net;
const os = std.os;

var appTop: ?App = null;
var serverTop: ?httpz.Server(*App) = null;
pub fn main() !void {
    // const port = 60829;
    const port = 9091;

    checkPortAvailable(port) catch |err| {
        std.debug.print("checked port={} error={}\n", .{ port, err });
        return;
    };

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    appTop = App{ .clients = std.SinglyLinkedList(App.WebsocketHandler){}, .upgrade_res_list = std.SinglyLinkedList(*httpz.HTTPConn){}, .allocator = allocator };
    serverTop = try httpz.Server(*App).init(allocator, .{ .port = port, .request = .{ .max_form_count = 10 } }, &appTop.?);

    defer {
        appTop.?.deinit();
        serverTop.?.stop();
        serverTop.?.deinit();
    }

    const act = os.linux.Sigaction{
        .handler = .{ .handler = sigintHandler },
        .mask = os.linux.empty_sigset,
        .flags = 0,
    };

    if (os.linux.sigaction(os.linux.SIG.INT, &act, null) != 0) {
        return error.SignalHandlerError;
    }

    var router = serverTop.?.router(.{});
    router.post("/send", send, .{});
    router.get("/ws", ws, .{});
    std.debug.print("WebsocketHandler end\n", .{});
    try serverTop.?.listen();
}

fn sigintHandler(_: c_int) callconv(.C) void {
    std.debug.print("SIGINT received\n", .{});
}

fn checkPortAvailable(port: u16) !void {
    const address = try net.Address.parseIp4("127.0.0.1", port);
    var server = try address.listen(.{});
    defer server.deinit();
}
const AllocationError = error{OutOfMemory};
var TempMsg: []const u8 = "";

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
        pub fn afterInit(self: *WebsocketHandler) !void {
            try self.conn.write(TempMsg);
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
    TempMsg = data.get("msg").?;
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
