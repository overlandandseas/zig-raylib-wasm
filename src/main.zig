const std = @import("std");
const rl = @cImport({
    @cInclude("raylib.h");
});

pub fn main() !void {
    rl.InitWindow(800, 450, "raylib [core] example - testing windoze!#@");

    while (!rl.WindowShouldClose()) {
        rl.BeginDrawing();
        rl.ClearBackground(rl.RAYWHITE);
        rl.DrawText("Hello From src/main.zig", 190, 200, 20, rl.LIGHTGRAY);
        rl.DrawText("Zig Builds", 190, 250, 20, rl.GREEN);
        rl.EndDrawing();
    }
    defer rl.CloseWindow();
}
