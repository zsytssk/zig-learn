const std = @import("std");
const debug = std.debug;
const fmt = std.fmt;
const fs = std.fs;
const heap = std.heap;
const io = std.io;

fn populate(dir: *fs.Dir) !void {
    for (0..3) |i| {
        // Format file name.
        var buf: [8]u8 = undefined;
        const filename = try fmt.bufPrint(&buf, "file_{}", .{i});
        // Create a file.
        var file = try dir.createFile(filename, .{});
        // Close on exit.
        defer file.close();
        // Buffer the writes for much better performance.
        var buf_writer = io.bufferedWriter(file.writer());
        // The Writer interface of std.io.
        const writer = buf_writer.writer();
        // Use print for formatted output.
        _ = try writer.print("This is file_{}\n", .{i});
        // Don't forget to flush!
        try buf_writer.flush();
    }
}

pub fn main() !void {
    // Create and open a directory path.
    var sub_2 = try fs.cwd().makeOpenPath("test_dir/sub_1/sub_2", .{});
    // Clean up on exit.
    defer fs.cwd().deleteTree("test_dir") catch |err| {
        std.debug.print("error deleting directory tree: {}", .{err});
    };
    // Close directory resouce when finished.
    defer sub_2.close();
    // Populate with some files.
    try populate(&sub_2);

    // Open another directory.
    var sub_1 = try fs.cwd().openDir("test_dir/sub_1", .{});
    defer sub_1.close();
    // Populate with some files.
    try populate(&sub_1);

    // One more time.
    var test_dir = try fs.cwd().openDir("test_dir", .{});
    defer test_dir.close();
    try populate(&test_dir);

    // We need an allocator to walk the tree.
    var gpa = heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Let's walk the whole tree.
    // First we need an iterable version of the
    // directory we want to walk.
    var iterable = try fs.cwd().openDir(
        "test_dir",
        .{ .iterate = true },
    );
    defer iterable.close();
    // Now we obtain a `Walker` that will walk the
    // full tree, entering into sub-directories for us.
    var walker = try iterable.walk(allocator);
    defer walker.deinit();

    while (try walker.next()) |entry| {
        std.debug.print("Entry: {s}; Kind: {s}: ", .{ entry.path, @tagName(entry.kind) });

        if (entry.kind == .file) {
            // Open the file via its parent directory.
            var file = try entry.dir.openFile(entry.basename, .{});
            defer file.close();
            // Buffer the reads for better performance.
            var buf_reader = io.bufferedReader(file.reader());
            // The Reader interface of std.io.
            const reader = buf_reader.reader();

            var buf: [4096]u8 = undefined;
            while (try reader.readUntilDelimiterOrEof(&buf, '\n')) |line| {
                std.debug.print("{s}", .{line});
            }
        }

        std.debug.print("\n", .{});
    }
}
