const std = @import("std");
const fmt = std.fmt;
const heap = std.heap;
const mem = std.mem;
const print = std.debug.print;
const time = std.time;

const Trie = @import("trie.zig");

pub fn main() !void {
    var gpa = heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Alice in Wonderland text embedded as a static
    // string directly in the binary.
    const corpus = @embedFile("alice.txt");

    print("test:>{any}\n", .{@TypeOf(corpus)});
    // We split on space, skipping empty fields.
    var iter = mem.tokenizeScalar(u8, corpus, ' ');

    // Initialize the Trie and ensure its cleanup.
    var trie = Trie.init(allocator);
    defer trie.deinit();

    // A preliminary test.
    try trie.insert("caterpillar");
    try trie.insert("category");
    try trie.insert("cat");
    print("caterpillar: {} | ", .{trie.lookup("caterpillar")});
    print("category: {} | ", .{trie.lookup("category")});
    print("cat: {}\n\n", .{trie.lookup("cat")});

    // Some counters.
    var words: usize = 0;
    var found: usize = 0;

    // Prepare a timer to see how long these ops take.
    var timer = try std.time.Timer.start();

    // Insertions.
    while (iter.next()) |word| {
        try trie.insert(word);
        words += 1;
    }

    // Reset the iterator.
    iter.index = 0;

    // Now lookups.
    while (iter.next()) |word| {
        if (trie.lookup(word)) found += 1;
    }

    // Print summary stats. Note multi-line literal for format.
    print(
        \\words:    {}
        \\found:    {}
        \\took:     {}
        \\
    , .{
        words,
        found,
        fmt.fmtDuration(timer.lap()),
    });
}
