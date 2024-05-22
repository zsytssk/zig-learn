const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // This adds a command line option to zig build via the -D flag. i.e. -Dloop
    const use_loop = b.option(bool, "loop", "Use non-recursive Fibonacci") orelse false;
    // Now we can make a build decision based on that option.
    const fib_file: []const u8 = if (use_loop) "src/fib_loop.zig" else "src/fib_recurse.zig";
    const fibonacci = b.addModule("fibonacci", .{ .root_source_file = .{ .path = fib_file } });

    // To pass on this option to your program, use addOptions.
    const options = b.addOptions();
    options.addOption(bool, "use_loop", use_loop);

    const exe = b.addExecutable(.{
        .name = "34_build",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    exe.root_module.addOptions("config", options);
    exe.root_module.addImport("fibonacci", fibonacci);

    b.installArtifact(exe);

    // Add a step to run the built executable.
    const run_cmd = b.addRunArtifact(exe);
    // To run the app, you have to install it first.
    run_cmd.step.dependOn(b.getInstallStep());
    // Pass any command line args after `--` to the executable.
    if (b.args) |args| run_cmd.addArgs(args);
    // The actual run step.
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
