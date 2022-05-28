-- The little UI element in the top left that displays
-- the current height

local pd <const> = playdate
local gfx <const> = pd.graphics

class('HeightDisplay').extends(gfx.sprite)

function HeightDisplay:init()
    self:setCenter(0, 0)
    self:moveTo(25, 8)
    -- Important, so you don't have it moving in
    -- the world space
    self:setIgnoresDrawOffset(true)
    self:setZIndex(100)
    self:add()
end

function HeightDisplay:update()
    local displayString = "Height: " .. GET_CURRENT_HEIGHT_IN_METERS() .. " m"
    -- Getting the width and height of the text to make sure the image
    -- will always fit the text
    local displayTextWidth, displayTextHeight = gfx.getTextSize(displayString)
    local displayImage = gfx.image.new(displayTextWidth, displayTextHeight)
    gfx.pushContext(displayImage)
        gfx.drawText(displayString, 0, 0)
    gfx.popContext()
    self:setImage(displayImage)
end