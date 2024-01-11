# Zig Raylib Wasm
### Macos build
```sh
zig build -Dtarget=wasm32-emscripten --sysroot "/opt/homebrew/Cellar/emscripten/3.1.51/libexec" 
```

### Run in Browser
```sh
npx http-server zig-out/web
```
