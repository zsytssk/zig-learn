const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "zig-learn",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

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
