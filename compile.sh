#!/bin/bash
# Compile Playdate project using Docker (avoids GLIBC issues on Ubuntu 22.04)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SDK_PATH="$HOME/sgoinfre/PlaydateSDK-3.0.2"

echo "🎮 Compiling Playdate project with Docker..."
echo ""

# Check if Docker is available
if ! command -v docker &> /dev/null; then
    echo "❌ Error: Docker is not installed or not in PATH"
    exit 1
fi

# Check if SDK exists
if [ ! -d "$SDK_PATH" ]; then
    echo "❌ Error: PlaydateSDK not found at $SDK_PATH"
    exit 1
fi

# Check if source directory exists
if [ ! -d "$SCRIPT_DIR/source" ]; then
    echo "❌ Error: source/ directory not found"
    exit 1
fi

echo "📦 Using Ubuntu 24.04 container (has GLIBC 2.39)..."
echo ""
echo "🔨 Compiling with pdc..."

# Use Ubuntu 24.04 which has GLIBC 2.39 (compatible with SDK)
# Install required libraries first, then compile
docker run --rm \
  -v "$SDK_PATH:/sdk:ro" \
  -v "$SCRIPT_DIR:/project" \
  -w /project \
  -e PLAYDATE_SDK_PATH=/sdk \
  ubuntu:24.04 \
  bash -c "apt-get update -qq && apt-get install -y -qq libpng16-16 > /dev/null 2>&1 && /sdk/bin/pdc source game.pdx"

if [ -d "$SCRIPT_DIR/game.pdx" ]; then
    echo ""
    echo "✅ Compilation complete! game.pdx created."
    echo ""
    echo "📊 Build info:"
    ls -lh game.pdx/ | grep -v "^total" | awk '{print "   " $9 " (" $5 ")"}'
    echo ""
    echo "📱 To test:"
    echo "   • Transfer game.pdx to Windows and run with PlaydateSimulator"
    echo "   • Sideload to Playdate device via USB"
    echo ""
else
    echo ""
    echo "❌ Compilation failed - game.pdx not created"
    exit 1
fi
