const std = @import("std");
const fs = std.fs;
const raylib_sdk = @import("raylib/src/build.zig");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});

    const optimize = b.standardOptimizeOption(.{});
    if (target.query.cpu_arch == .wasm32) {
        const lib = b.addStaticLibrary(.{
            .name = "zig-raylib-wasm",
            .root_source_file = .{ .path = "src/main.zig" },
            .target = target,
            .optimize = optimize,
        });

        const raylib = raylib_sdk.addRaylib(b, target, optimize, .{});
        lib.addIncludePath(.{ .path = "raylib/src" });
        lib.linkLibrary(raylib);

        b.installArtifact(lib);
        b.installArtifact(raylib);

        const emcc_path = try fs.path.join(b.allocator, &.{ b.sysroot.?, "emcc" });
        defer b.allocator.free(emcc_path);
        try fs.cwd().makePath("zig-out/web");

        const emcc = b.addSystemCommand(&.{ emcc_path, "-ozig-out/web/index.html", "zig-out/lib/libzig-raylib-wasm.a", "zig-out/lib/libraylib.a", "-sASYNCIFY", "-sUSE_GLFW=3", "-sGL_ENABLE_GET_PROC_ADDRESS", "--shell-file", "minshell" });

        emcc.step.dependOn(&lib.step);

        b.getInstallStep().dependOn(&emcc.step);
    } else {
        const exe = b.addExecutable(.{
            .name = "zig-raylib-wasm",
            .root_source_file = .{ .path = "src/main.zig" },
            .target = target,
            .optimize = optimize,
        });

        const raylib = raylib_sdk.addRaylib(b, target, optimize, .{});
        exe.addIncludePath(.{ .path = "raylib/src" });
        exe.linkLibrary(raylib);

        b.installArtifact(exe);

        const run_cmd = b.addRunArtifact(exe);

        run_cmd.step.dependOn(b.getInstallStep());

        const run_step = b.step("run", "Run the app");
        run_step.dependOn(&run_cmd.step);
    }
}
