const std = @import("std");
const Atomic = std.atomic.Atomic;
const time = std.time;
const Thread = std.Thread;

// Just an example; you don't have to do this because
// std.Thread.WaitGroup already exists!
const WaitGroup = struct {
    members: Atomic(usize),

    fn init() WaitGroup {
        return .{ .members = Atomic(usize).init(0) };
    }

    // New member joins the group.
    fn add(self: *WaitGroup) void {
        // Loads are usually .Acquire.
        _ = self.members.fetchAdd(1, .Acquire);
    }

    // Existing member leaves the group.
    fn done(self: *WaitGroup) void {
        // Stores are usually .Release.
        _ = self.members.fetchSub(1, .Release);
    }

    // Wait for all members to leave.
    fn wait(self: WaitGroup) void {
        // Use .Monotonic when ordering isn't that crucial.
        while (self.members.load(.Monotonic) > 0) time.sleep(500 * time.ns_per_ms);
    }
};

// A sample worker thread.
fn worker(id: usize, wg: *WaitGroup) void {
    // Signal we're leaving the wait group on exit.
    defer wg.done();

    std.debug.print("{} started\n", .{id});
    time.sleep(1 * time.ns_per_ms);
    std.debug.print("{} finished\n", .{id});
}

pub fn main() !void {
    // Create the wait group.
    var wg = WaitGroup.init();
    // Ensure we wait for all members of the
    // wait group to leave before exiting main.
    defer wg.wait();

    for (0..5) |i| {
        // Add a member to the wait group.
        wg.add();
        // Spawn the thread.
        const thread = Thread.spawn(.{}, worker, .{ i, &wg }) catch |err| {
            // Remove from wait group on error
            // so wg.wait() doesn't wait forever.
            wg.done();
            return err;
        };
        // No need to join, we'll wait via the wait group.
        thread.detach();
    }
}
