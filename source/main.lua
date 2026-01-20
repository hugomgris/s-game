-- Proyecto Sombra - Main Entry Point
-- Simple cube sprite test

import "CoreLibs/graphics"
import "CoreLibs/sprites"

-- Shortcuts for commonly used modules
local gfx <const> = playdate.graphics

-- Game state
local cubeSprite = nil

-- Initialize the game
function playdate.update()
    -- Clear the screen
    gfx.clear()
    
    -- Update and draw all sprites
    gfx.sprite.update()
    
    -- Draw FPS counter for debugging
    playdate.drawFPS(0, 0)
end

-- Load function - called once when game starts
function initialize()
    -- Load the cube image
    local cubeImage = gfx.image.new("sprites/cube_360/cube_01")
    
    if cubeImage == nil then
        print("ERROR: Could not load cube_01 sprite!")
        print("Make sure sprites/cube_01.png exists and is 64x64 pixels")
        return
    end
    
    -- Create a sprite with the cube image
    cubeSprite = gfx.sprite.new(cubeImage)
    
    -- Position the sprite in the center of the screen
    -- Playdate screen is 400x240
    cubeSprite:moveTo(200, 120)
    
    -- Add the sprite to the display list so it gets drawn
    cubeSprite:add()
    
    print("Cube sprite loaded successfully!")
    print("Sprite size: " .. cubeImage.width .. "x" .. cubeImage.height)
end

-- Call initialize when the game loads
initialize()
