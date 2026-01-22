-- Proyecto Sombra - Main Entry Point
-- Multi-cube rotation with crank control and D-pad selection

import "CoreLibs/graphics"
import "CoreLibs/sprites"

-- Shortcuts
local gfx <const> = playdate.graphics

-- Configuration
local SPRITE_COUNT = 16  -- Number of rotation frames
local CRANK_SENSITIVITY = 22.5  -- Degrees per sprite (360/16)
local SPRITE_SCALE = 1  -- Scale factor for all cubes

-- Cube definitions (axis, sprite path, position)
local CUBE_DEFS = {
    {axis = "X", path = "sprites/cube_X/dithered/", x = 70, y = 120},
    {axis = "Y", path = "sprites/cube_Y/dithered/", x = 200, y = 120},
    {axis = "Z", path = "sprites/cube_Z/dithered/", x = 330, y = 120}
}

-- Game state
local cubes = {}  -- Array of cube objects
local selectedCubeIndex = 2  -- Start with middle cube (Y-axis)
local crankAccumulator = 0

-- Load all sprite frames for a specific axis
function loadSpriteFrames(spritePath)
    print("Loading sprite frames from: " .. spritePath)
    local frames = {}
    
    for i = 1, SPRITE_COUNT do
        -- Format: cube_01, cube_02, etc.
        local frameName = string.format("%scube_%02d", spritePath, i)
        local frameImage = gfx.image.new(frameName)
        
        if frameImage == nil then
            print("ERROR: Could not load " .. frameName)
            return nil
        end
        
        -- Scale the image if scale factor is not 1.0
        if SPRITE_SCALE ~= 1.0 then
            local w, h = frameImage:getSize()
            local newW, newH = math.floor(w * SPRITE_SCALE), math.floor(h * SPRITE_SCALE)
            local scaledImage = gfx.image.new(newW, newH)
            gfx.pushContext(scaledImage)
            gfx.setImageDrawMode(gfx.kDrawModeCopy)
            frameImage:drawScaled(0, 0, SPRITE_SCALE)
            gfx.popContext()
            frames[i] = scaledImage
        else
            frames[i] = frameImage
        end
    end
    
    print("Loaded " .. SPRITE_COUNT .. " frames successfully!")
    return frames
end

-- Create a cube object
function createCube(axis, spritePath, x, y)
    local cube = {
        axis = axis,
        frames = loadSpriteFrames(spritePath),
        currentFrame = 1,
        sprite = nil,
        x = x,
        y = y
    }
    
    if cube.frames == nil then
        print("FATAL: Failed to load frames for " .. axis .. " axis")
        return nil
    end
    
    -- Create the sprite
    cube.sprite = gfx.sprite.new(cube.frames[1])
    cube.sprite:moveTo(x, y)
    cube.sprite:add()
    
    return cube
end

-- Update a cube's displayed frame
function updateCubeFrame(cube, frameIndex)
    cube.currentFrame = ((frameIndex - 1) % SPRITE_COUNT) + 1
    cube.sprite:setImage(cube.frames[cube.currentFrame])
end

-- Draw selection indicator for the active cube
function drawSelectionIndicator()
    local cube = cubes[selectedCubeIndex]
    if cube then
        -- Draw a frame around the selected cube
        local x, y = cube.x, cube.y
        local w, h = cube.sprite:getSize()
        local halfW, halfH = w / 2, h / 2
        
        -- Draw rectangle frame
        --gfx.setLineWidth(2)
        --gfx.drawRect(x - halfW - 4, y - halfH - 4, w + 8, h + 8)
        
        -- Draw axis label above the cube
        gfx.drawText("Axis: " .. cube.axis, x - 20, y - halfH - 20)
    end
end

-- Main update loop
function playdate.update()
    gfx.clear()
    
    -- Handle D-pad input for cube selection
    if playdate.buttonJustPressed(playdate.kButtonLeft) then
        selectedCubeIndex = selectedCubeIndex - 1
        if selectedCubeIndex < 1 then
            selectedCubeIndex = #cubes
        end
        print("Selected cube: " .. cubes[selectedCubeIndex].axis)
    elseif playdate.buttonJustPressed(playdate.kButtonRight) then
        selectedCubeIndex = selectedCubeIndex + 1
        if selectedCubeIndex > #cubes then
            selectedCubeIndex = 1
        end
        print("Selected cube: " .. cubes[selectedCubeIndex].axis)
    end
    
    -- Read crank input for the selected cube
    local crankChange, crankAcceleratedChange = playdate.getCrankChange()
    
    if crankChange ~= 0 then
        crankAccumulator = crankAccumulator + crankChange
        
        -- Calculate frame change
        local frameDelta = math.floor(crankAccumulator / CRANK_SENSITIVITY)
        
        if frameDelta ~= 0 then
            local selectedCube = cubes[selectedCubeIndex]
            updateCubeFrame(selectedCube, selectedCube.currentFrame + frameDelta)
            crankAccumulator = crankAccumulator % CRANK_SENSITIVITY
        end
    end
    
    -- Update and draw sprites
    gfx.sprite.update()
    
    -- Draw selection indicator
    drawSelectionIndicator()
    
    -- Debug info
    playdate.drawFPS(0, 200)
    local selectedCube = cubes[selectedCubeIndex]
    --gfx.drawText("Selected: " .. selectedCube.axis, 0, 20)
    gfx.drawText("Frame: " .. selectedCube.currentFrame, 5, 215)
end

-- Initialize the game
function initialize()
    -- Enable dithering for smoother grayscale rendering
    gfx.setImageDrawMode(gfx.kDrawModeCopy)
    
    -- Create all three cubes
    print("Creating cubes...")
    for i, def in ipairs(CUBE_DEFS) do
        local cube = createCube(def.axis, def.path, def.x, def.y)
        if cube == nil then
            print("FATAL: Failed to create cube for " .. def.axis .. " axis")
            return
        end
        table.insert(cubes, cube)
        print("Created " .. def.axis .. " axis cube at position (" .. def.x .. ", " .. def.y .. ")")
    end
    
    print("Initialization complete!")
    print("Use LEFT/RIGHT on D-pad to select cube")
    print("Turn the crank to rotate the selected cube")
end

-- Start the game
initialize()