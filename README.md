# Proyecto Sombra

A shadow theater game prototype for Playdate.

## Project Structure

```
s-game/
├── Blender/           # 3D assets and renders
│   └── BasicCube.blend
├── docs/              # Development log and documentation
│   └── devlog-01.md
└── source/            # Game source code
    ├── main.lua       # Main game code
    ├── pdxinfo        # Game metadata
    └── sprites/       # Game sprites (64x64 PNG)
        └── cube_01.png
```

## Development Setup (Windows)

### 1. Install Playdate SDK
1. Download from [play.date/dev](https://play.date/dev/)
2. Install to default location (usually `C:\Users\YourName\Documents\PlaydateSDK`)
3. Add SDK to PATH or use Playdate Simulator directly

### 2. Compile the Game

**Option A: Using Playdate Simulator (GUI)**
1. Open Playdate Simulator
2. Drag the `source/` folder onto the simulator window
3. It will compile and run automatically

**Option B: Command Line**
```cmd
cd path\to\s-game
pdc source game.pdx
```

### 3. Run in Simulator
```cmd
PlaydateSimulator game.pdx
```

### 4. Sideload to Device
1. Connect Playdate via USB
2. Enable "USB Disk" mode on device (Settings → System)
3. Copy `game.pdx` folder to `Games/` directory
4. Eject device and play!

## Current Status

✅ Basic sprite display working  
⏳ Phase 1: Blender rotation sprites (16 frames)  
⏳ Phase 2: Rotation system with crank input  
⏳ Phase 3: Multiple cubes with selection

See `docs/devlog-01.md` for detailed development plan.

## What the Game Does (Currently)

- Displays a 64x64 cube sprite centered on screen
- Shows FPS counter
- Logs sprite loading status to console

## Next Steps

Per devlog Phase 1:
1. Set up Blender scene with axonometric camera
2. Render 16 rotation sprites (Y-axis, 64x64 PNG)
3. Name sprites: `cube_00.png` through `cube_15.png`
4. Import all sprites to `source/sprites/`
5. Implement crank-based rotation system

## Tech Stack

- **Engine:** Playdate SDK (Lua)
- **3D:** Blender 3.x+
- **Approach:** Pre-rendered sprites (pseudo-3D)
- **Input:** Crank + D-pad
- **Target:** Playdate (400x240, 1-bit display)

## Resources

- [Playdate SDK Docs](https://sdk.play.date/)
- [Lua API Reference](https://sdk.play.date/inside-playdate)
- Devlog: `docs/devlog-01.md`
