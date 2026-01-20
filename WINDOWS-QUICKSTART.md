# Windows Development Quick Start

## What's Ready

✅ **Clean project structure**
- `source/` - Game code ready to compile
- `Blender/` - 3D assets for sprite generation
- `docs/` - Your devlog

✅ **Working code**
- `main.lua` - Basic sprite display
- `pdxinfo` - Game metadata
- `cube_01.png` - 64x64 test sprite

✅ **Version control**
- Git repo initialized
- `.gitignore` configured

## First Steps on Windows

### 1. Download Playdate SDK
- Go to https://play.date/dev/
- Download Windows SDK installer
- Run installer (defaults to `Documents\PlaydateSDK`)

### 2. Test Compilation
Open PowerShell or Command Prompt:

```powershell
# Navigate to project
cd path\to\s-game

# Compile
pdc source game.pdx

# Run
PlaydateSimulator game.pdx
```

Or simply drag `source` folder onto Playdate Simulator!

### 3. Expected Result
- White screen
- Cube sprite centered at (200, 120)
- FPS counter in top-left
- Console output: "Cube sprite loaded successfully!"

## If Compilation Fails

**Error: "pdc not found"**
- Add SDK to PATH: `C:\Users\YourName\Documents\PlaydateSDK\bin`
- Or use full path: `C:\Users\YourName\Documents\PlaydateSDK\bin\pdc.exe`

**Error: "CoreLibs not found"**
- Set environment variable: `PLAYDATE_SDK_PATH=C:\Users\YourName\Documents\PlaydateSDK`
- Or compile from Simulator GUI

## Next: Phase 1 (Blender Workflow)

Your devlog checklist is ready to follow:

1. Open `Blender/BasicCube.blend`
2. Set up axonometric camera
3. Configure flat shading + strong light
4. Render 16 rotation frames (Y-axis, 360°)
5. Export as 64x64 PNGs: `cube_00.png` to `cube_15.png`
6. Copy to `source/sprites/`

Then move to Phase 2: Rotation system!

## Testing Options

**Option 1: Simulator (Fastest)**
- Instant feedback
- Console output visible
- Crank simulation with mouse

**Option 2: Device Sideloading (Most Accurate)**
- USB connection
- Enable "USB Disk" mode
- Copy `game.pdx` to `Games/` folder
- Real crank input!

## Project Status

- [x] Development environment (Linux) tested
- [x] Code structure established
- [x] First sprite prepared (64x64)
- [ ] Windows compilation (first task!)
- [ ] Blender pipeline (Phase 1)
- [ ] Rotation system (Phase 2)
- [ ] Multiple cubes (Phase 3)

## Questions?

Check:
- `README.md` - Full project overview
- `docs/devlog-01.md` - Detailed development plan
- [Playdate SDK Docs](https://sdk.play.date/)

---

**The project is clean and ready for Windows development! 🚀**
