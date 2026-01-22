-- Proyecto Sombra - Main Entry Point
-- Single hand sprite rotation with crank control

import "CoreLibs/graphics"
import "CoreLibs/sprites"

-- Shortcuts
local gfx <const> = playdate.graphics

-- Configuration
local SPRITE_COUNT = 16  -- Number of rotation frames
local CRANK_SENSITIVITY = 22.5  -- Degrees per sprite (360/16)
local SPRITE_PATH = "sprites/hand/dithered/"  -- Path to hand sprites

-- Game state
local handSprite = nil  -- The hand sprite object
local spriteFrames = {}  -- Array of loaded images
local currentFrame = 1  -- Current frame index (1-16)
local crankAccumulator = 0  -- Accumulated crank rotation

-- Load all sprite frames
function loadSpriteFrames()
    print("Loading hand sprite frames...")
    local frames = {}
    
    for i = 1, SPRITE_COUNT do
        -- Format: hand_01.png, hand_02.png, etc.
        local frameName = string.format("%shand_%02d", SPRITE_PATH, i)
        local frameImage = gfx.image.new(frameName)
        
        if frameImage == nil then
            print("ERROR: Could not load " .. frameName)
            return nil
        end
        
        frames[i] = frameImage
        print("Loaded frame " .. i .. ": " .. frameName)
    end
    
    print("Successfully loaded all " .. SPRITE_COUNT .. " frames!")
    return frames
end

-- Update hand sprite frame based on crank input
function updateHandRotation()
    -- Get crank change in degrees
    local crankChange, acceleratedChange = playdate.getCrankChange()
    
    if crankChange ~= 0 then
        -- Accumulate crank rotation
        crankAccumulator = crankAccumulator + crankChange
        
        -- Calculate how many frames to move
        local framesToMove = math.floor(crankAccumulator / CRANK_SENSITIVITY)
        
        if framesToMove ~= 0 then
            -- Update current frame
            currentFrame = currentFrame + framesToMove
            
            -- Wrap around (1-16)
            while currentFrame > SPRITE_COUNT do
                currentFrame = currentFrame - SPRITE_COUNT
            end
            while currentFrame < 1 do
                currentFrame = currentFrame + SPRITE_COUNT
            end
            
            -- Update sprite image
            handSprite:setImage(spriteFrames[currentFrame])
            
            -- Reset accumulator
            crankAccumulator = crankAccumulator - (framesToMove * CRANK_SENSITIVITY)
        end
    end
end

-- Main update loop
function playdate.update()
    -- Clear screen
    gfx.clear()
    
    -- Update hand rotation based on crank
    updateHandRotation()
    
    -- Update and draw all sprites
    gfx.sprite.update()
    
    -- Draw debug info
    playdate.drawFPS(0, 0)
    gfx.drawText("Frame: " .. currentFrame .. "/" .. SPRITE_COUNT, 5, 220)
    
    -- Show crank indicator if undocked
    if not playdate.isCrankDocked() then
        gfx.drawText("🎮", 380, 220)
    end
end

-- Initialize the game (second call at bottom is the real one)
function initialize()
    print("=== Proyecto Sombra - Hand Rotation Prototype ===")
    print("Initializing...")
    
    -- Enable dithering for better grayscale rendering
    gfx.setImageDrawMode(gfx.kDrawModeCopy)
    
    -- Load all sprite frames
    spriteFrames = loadSpriteFrames()
    
    if spriteFrames == nil then
        print("FATAL: Failed to load sprite frames!")
        return
    end
    
    -- Create the hand sprite
    handSprite = gfx.sprite.new(spriteFrames[1])
    handSprite:moveTo(200, 120)  -- Center of screen (400x240)
    handSprite:add()
    
    print("Hand sprite created at center (200, 120)")
    print("Current frame: " .. currentFrame .. "/" .. SPRITE_COUNT)
    print("")
    print("Controls:")
    print("  🎮 Crank: Rotate hand")
    print("")
    print("Ready!")
end

-- Start the game
initialize()