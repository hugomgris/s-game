import "CoreLibs/graphics"
import "CoreLibs/sprites"

-- Shortcuts
local gfx <const> = playdate.graphics

-- Configuration
local SPRITE_COUNT = 16							-- Number of rotation frames
local CRANK_SENSITIVITY = 22.5					-- Degrees per sprite (360/16)
local SPRITE_PATH = "sprites/hand/dithered/"	-- Path to hand sprites

-- Game state
local handSprite = nil		-- The hand sprite object
local spriteFrames = {}		-- Array of loaded images
local currentFrame = 1		-- Current frame index (1-16)
local crankAccumulator = 0 	-- Accumulated crank rotation

-- Load all sprite frames
function loadSpriteFrames()
    local frames = {}
    
    for i = 1, SPRITE_COUNT do
        local frameName = string.format("%shand_%02d", SPRITE_PATH, i)
        local frameImage = gfx.image.new(frameName)
        
        if frameImage == nil then
            print("ERROR: Could not load " .. frameName)
            return nil
        end
        
        frames[i] = frameImage
    end
    
    print("Successfully loaded all " .. SPRITE_COUNT .. " frames!")
    return frames
end

-- Update hand sprite frame based on crank input
function updateHandRotation()
    -- Get crank change in degrees
    local crankChange
	local acceleratedChange = playdate.getCrankChange()
    
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
    gfx.clear()
    
    updateHandRotation()
    
    -- Update and draw all sprites
    gfx.sprite.update()
    
    -- Draw debug info
    playdate.drawFPS(0, 0)
    gfx.drawText("Frame: " .. currentFrame .. "/" .. SPRITE_COUNT, 5, 220)
    
    -- Show crank indicator if undocked
    if not playdate.isCrankDocked() then
        gfx.drawText("GO!", 370, 220)
    end
end

-- Initialize the game (second call at bottom is the real one)
function initialize()
    gfx.setImageDrawMode(gfx.kDrawModeCopy)

    spriteFrames = loadSpriteFrames()
    
    if spriteFrames == nil then
        print("FATAL: Failed to load sprite frames!")
        return
    end
    
    -- Create the hand sprite
    handSprite = gfx.sprite.new(spriteFrames[1])
    handSprite:moveTo(120, 120)
    handSprite:add()
end

-- Start the game
initialize()