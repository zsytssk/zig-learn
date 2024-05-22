const std = @import("std");

// Import the module containing passed-in build
// command line options.
const config = @import("config");
// Import the fibonacci module selected via
// build command line option.
const fib = @import("fibonacci").fib;

pub fn main() !void {
    // Executable command line args processing.
    // These are the ones after the `--`.
    var args_iter = std.process.args();
    _ = args_iter.next(); // program name

    // Let's get the actual number.
    const n: usize = if (args_iter.next()) |arg|
        try std.fmt.parseInt(usize, arg, 10) // Parse the arg as an usize, base 10.
    else
        7; // Default to 7 if no arg provided.

    // Use the build command line option via the `config` module.
    const fib_type: []const u8 = if (config.use_loop) "loop" else "recursive";
    // Print the nth Fibonacci number.
    std.debug.print("\n\n {}th fibonacci ({s}): {} \n\n", .{
        n,
        fib_type,
        fib(n),
    });
}
