import "CoreLibs/graphics"
import "CoreLibs/sprites"

-- Shortcuts
local gfx <const> = playdate.graphics

-- Configuration
local SPRITE_COUNT = 16							-- Number of rotation frames
local CRANK_SENSITIVITY = 22.5					-- Degrees per sprite (360/16)
local INDEX_SPRITE_PATH = "sprites/hand/index/dithered/"	-- Path to index finger sprites
local MIDDLE_SPRITE_PATH = "sprites/hand/middle/dithered/"	-- Path to middle finger sprites

-- Finger definitions
local FINGERS = {
    {name = "Index", path = INDEX_SPRITE_PATH},
    {name = "Middle", path = MIDDLE_SPRITE_PATH}
}

-- Game state
local baseSprite = nil			-- Hand base sprite object
local fingerSprites = {}		-- Array of finger sprite objects
local fingerFrames = {}			-- Array of arrays of loaded images
local fingerCurrentFrames = {}	-- Current frame for each finger
local selectedFingerIndex = 1	-- Which finger is currently controlled (1=Index, 2=Middle)
local crankAccumulator = 0 		-- Accumulated crank rotation

function loadBaseSprite()
    local baseImagePNG = gfx.image.new("sprites/hand/base_dithered")
    
    if baseImagePNG == nil then
        print("ERROR: Could not load base sprite")
    else
        print("Base sprite loaded successfully!")
    end
    
    return baseImagePNG
end

-- Load all sprite frames for a specific finger
function loadFingerFrames(spritePath, fingerName)
    local frames = {}
    
    for i = 1, SPRITE_COUNT do
        local frameName = string.format("%shand_%s_%02d", spritePath, string.lower(fingerName), i)
        local frameImage = gfx.image.new(frameName)
        
        if frameImage == nil then
            print("ERROR: Could not load " .. frameName)
            return nil
        end
        
        frames[i] = frameImage
    end
    
    print("Successfully loaded all " .. SPRITE_COUNT .. " frames for " .. fingerName .. " finger!")
    return frames
end

-- Update hand sprite frame based on crank input
function updateHandRotation()
    -- Safety check: ensure finger sprites exist
    if #fingerSprites == 0 then
        return
    end
    
    -- Get crank change in degrees
    local crankChange, acceleratedChange = playdate.getCrankChange()
    
    if crankChange ~= 0 then
        -- Accumulate crank rotation
        crankAccumulator = crankAccumulator + crankChange
        
        -- Calculate how many frames to move
        local framesToMove = math.floor(crankAccumulator / CRANK_SENSITIVITY)
        
        if framesToMove ~= 0 then
            -- Update current frame for selected finger
            local currentFrame = fingerCurrentFrames[selectedFingerIndex]
            currentFrame = currentFrame + framesToMove
            
            -- Clamp to valid range (1-16) instead of wrapping
            if currentFrame > SPRITE_COUNT then
                currentFrame = SPRITE_COUNT
                crankAccumulator = 0  -- Reset accumulator when clamped
            elseif currentFrame < 1 then
                currentFrame = 1
                crankAccumulator = 0  -- Reset accumulator when clamped
            else
                -- Only adjust accumulator if we're not at the limits
                crankAccumulator = crankAccumulator - (framesToMove * CRANK_SENSITIVITY)
            end
            
            -- Update the frame and sprite image
            fingerCurrentFrames[selectedFingerIndex] = currentFrame
            fingerSprites[selectedFingerIndex]:setImage(fingerFrames[selectedFingerIndex][currentFrame])
        end
    end
end

-- Main update loop
function playdate.update()
    gfx.clear()
    
    -- Handle D-pad input for finger selection
    if playdate.buttonJustPressed(playdate.kButtonLeft) then
        selectedFingerIndex = selectedFingerIndex - 1
        if selectedFingerIndex < 1 then
            selectedFingerIndex = #FINGERS
        end
        print("Selected finger: " .. FINGERS[selectedFingerIndex].name)
    elseif playdate.buttonJustPressed(playdate.kButtonRight) then
        selectedFingerIndex = selectedFingerIndex + 1
        if selectedFingerIndex > #FINGERS then
            selectedFingerIndex = 1
        end
        print("Selected finger: " .. FINGERS[selectedFingerIndex].name)
    end
    
    updateHandRotation()
    
    -- Update and draw all sprites
    gfx.sprite.update()
    
    -- Draw debug info
    playdate.drawFPS(0, 0)
    
    -- Draw selected finger indicator in top right corner
    local selectedFinger = FINGERS[selectedFingerIndex].name
    local textWidth = gfx.getTextSize(selectedFinger)
    gfx.drawText(selectedFinger, 400 - textWidth - 5, 5)
    
    -- Draw current frame info at bottom
    local currentFrame = fingerCurrentFrames[selectedFingerIndex]
    gfx.drawText("Frame: " .. currentFrame .. "/" .. SPRITE_COUNT, 5, 220)
    
    -- Show crank indicator if undocked
    if not playdate.isCrankDocked() then
        gfx.drawText("GO!", 370, 220)
    end
end

-- Initialize the game
function initialize()
    gfx.setImageDrawMode(gfx.kDrawModeCopy)

    -- Load base sprite first
    local baseImage = loadBaseSprite()
    
    if baseImage == nil then
        print("FATAL: Failed to load base sprite!")
        return
    end
    
    -- Create the base sprite (bottom layer)
    baseSprite = gfx.sprite.new(baseImage)
    baseSprite:moveTo(120, 120)
    baseSprite:add()
    
    -- Load and create all finger sprites
    for i, finger in ipairs(FINGERS) do
        -- Load frames for this finger
        local frames = loadFingerFrames(finger.path, finger.name)
        
        if frames == nil then
            print("FATAL: Failed to load sprite frames for " .. finger.name .. " finger!")
            return
        end
        
        fingerFrames[i] = frames
        
        -- Create sprite for this finger
        local sprite = gfx.sprite.new(frames[1])
        sprite:moveTo(120, 120)  -- Same position as base
        sprite:add()
        
        fingerSprites[i] = sprite
        fingerCurrentFrames[i] = 1
        
        print("Created " .. finger.name .. " finger sprite")
    end
    
    print("Initialization complete!")
    print("Use LEFT/RIGHT on D-pad to select finger")
    print("Turn the crank to curl/uncurl the selected finger")
end

-- Start the game
initialize()