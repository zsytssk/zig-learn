const std = @import("std");

pub fn build(b: *std.Build) void {
    // Allow specifying target triple with the
    // -Dtarget=<triple> flag to zig build.
    const target = b.standardTargetOptions(.{});

    // Allow specifying optimization level with the
    // -Doptimize=<level> flag to zig build.
    const optimize = b.standardOptimizeOption(.{});

    // Build an executable program binary file.
    const exe = b.addExecutable(.{
        .name = "main",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    // exe.addCSourceFiles(.{ .files = &.{"src/main.c"} });

    // Put the binary in zig-out or prefix specified
    // with -p or --prefix flag to zig build.
    b.installArtifact(exe);

    // Allow running of the binary executable compiled
    // above.
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    // Add a run step so that it can be invoked via
    // zig build run.
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
