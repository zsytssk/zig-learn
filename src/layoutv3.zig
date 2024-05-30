const std = @import("std");
const posix = std.posix;
const client = @import("wayland.zig").client;
const common = @import("common.zig");

pub const LayoutManagerV3 = opaque {
    pub const generated_version = 2;
    pub const getInterface = common.river.layout_manager_v3.getInterface;
    pub fn setQueue(_layout_manager_v3: *LayoutManagerV3, _queue: *client.wl.EventQueue) void {
        const _proxy: *client.wl.Proxy = @ptrCast(_layout_manager_v3);
        _proxy.setQueue(_queue);
    }
    pub fn destroy(_layout_manager_v3: *LayoutManagerV3) void {
        const _proxy: *client.wl.Proxy = @ptrCast(_layout_manager_v3);
        _proxy.marshal(0, null);
        _proxy.destroy();
    }
    pub fn getLayout(_layout_manager_v3: *LayoutManagerV3, _output: *client.wl.Output, _namespace: [*:0]const u8) !*client.river.LayoutV3 {
        const _proxy: *client.wl.Proxy = @ptrCast(_layout_manager_v3);
        var _args = [_]common.Argument{
            .{ .o = null },
            .{ .o = @ptrCast(_output) },
            .{ .s = _namespace },
        };
        return @ptrCast(try _proxy.marshalConstructor(1, &_args, client.river.LayoutV3.getInterface()));
    }
};
pub const LayoutV3 = opaque {
    pub const generated_version = 2;
    pub const getInterface = common.river.layout_v3.getInterface;
    pub const Error = common.river.layout_v3.Error;
    pub fn setQueue(_layout_v3: *LayoutV3, _queue: *client.wl.EventQueue) void {
        const _proxy: *client.wl.Proxy = @ptrCast(_layout_v3);
        _proxy.setQueue(_queue);
    }
    pub const Event = union(enum) {
        namespace_in_use: void,
        layout_demand: struct {
            view_count: u32,
            usable_width: u32,
            usable_height: u32,
            tags: u32,
            serial: u32,
        },
        user_command: struct {
            command: [*:0]const u8,
        },
        user_command_tags: struct {
            tags: u32,
        },
    };
    pub inline fn setListener(
        _layout_v3: *LayoutV3,
        comptime T: type,
        _listener: *const fn (layout_v3: *LayoutV3, event: Event, data: T) void,
        _data: T,
    ) void {
        const _proxy: *client.wl.Proxy = @ptrCast(_layout_v3);
        const _mut_data: ?*anyopaque = @ptrFromInt(@intFromPtr(_data));
        _proxy.addDispatcher(common.Dispatcher(LayoutV3, T).dispatcher, _listener, _mut_data);
    }
    pub fn destroy(_layout_v3: *LayoutV3) void {
        const _proxy: *client.wl.Proxy = @ptrCast(_layout_v3);
        _proxy.marshal(0, null);
        _proxy.destroy();
    }
    pub fn pushViewDimensions(_layout_v3: *LayoutV3, _x: i32, _y: i32, _width: u32, _height: u32, _serial: u32) void {
        const _proxy: *client.wl.Proxy = @ptrCast(_layout_v3);
        var _args = [_]common.Argument{
            .{ .i = _x },
            .{ .i = _y },
            .{ .u = _width },
            .{ .u = _height },
            .{ .u = _serial },
        };
        _proxy.marshal(1, &_args);
    }
    pub fn commit(_layout_v3: *LayoutV3, _layout_name: [*:0]const u8, _serial: u32) void {
        const _proxy: *client.wl.Proxy = @ptrCast(_layout_v3);
        var _args = [_]common.Argument{
            .{ .s = _layout_name },
            .{ .u = _serial },
        };
        _proxy.marshal(2, &_args);
    }
};
