const std = @import("std");
const Build = std.Build;
const CompileStep = std.Build.Step.Compile;

/// set this to true to link libc
const should_link_libc = false;

fn linkObject(b: *Build, obj: *CompileStep) void {
    if (should_link_libc) obj.linkLibC();
    _ = b;

    // Add linking for packages or third party libraries here
}

pub fn build(b: *Build) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardOptimizeOption(.{});

    const install_all = b.step("install_all", "Install all days");
    const run_all = b.step("run_all", "Run all days");

    // Set up an exe for each day
    var day: u32 = 1;
    while (day <= 25) : (day += 1) {
        const dayString = b.fmt("day{:0>2}", .{day});
        const zigFile = b.fmt("src/{s}.zig", .{dayString});

        _ = std.fs.cwd().statFile(zigFile) catch |err| {
            std.debug.print("Skipping {s}: {}\n", .{ dayString, err });
            continue;
        };

        const exe = b.addExecutable(.{
            .name = dayString,
            .root_source_file = .{ .path = zigFile },
            .target = target,
            .optimize = mode,
        });
        linkObject(b, exe);

        const install_cmd = b.addInstallArtifact(exe, .{});

        const build_test = b.addTest(.{
            .root_source_file = .{ .path = zigFile },
            .target = target,
            .optimize = mode,
        });
        linkObject(b, build_test);

        const run_test = b.addRunArtifact(build_test);

        {
            const step_key = b.fmt("install_{s}", .{dayString});
            const step_desc = b.fmt("Install {s}.exe", .{dayString});
            const install_step = b.step(step_key, step_desc);
            install_step.dependOn(&install_cmd.step);
            install_all.dependOn(&install_cmd.step);
        }

        {
            const step_key = b.fmt("test_{s}", .{dayString});
            const step_desc = b.fmt("Run tests in {s}", .{zigFile});
            const step = b.step(step_key, step_desc);
            step.dependOn(&run_test.step);
        }

        const run_cmd = b.addRunArtifact(exe);
        if (b.args) |args| {
            run_cmd.addArgs(args);
        }

        const run_desc = b.fmt("Run {s}", .{dayString});
        const run_step = b.step(dayString, run_desc);
        run_step.dependOn(&run_cmd.step);
        run_all.dependOn(&run_cmd.step);
    }

    // Set up tests for utils.zig
    {
        const test_util = b.step("test_utils", "Run tests in utils.zig");
        const test_cmd = b.addTest(.{
            .root_source_file = .{ .path = "src/utils.zig" },
            .target = target,
            .optimize = mode,
        });
        linkObject(b, test_cmd);
        test_util.dependOn(&test_cmd.step);
    }
}
