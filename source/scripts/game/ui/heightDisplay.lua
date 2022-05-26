local pd <const> = playdate
local gfx <const> = pd.graphics

class('HeightDisplay').extends(gfx.sprite)

function HeightDisplay:init()
    self:setCenter(0, 0)
    self:moveTo(25, 8)
    self:setIgnoresDrawOffset(true)
    self:setZIndex(100)
    self:add()
end

function HeightDisplay:update()
    local displayString = "Height: " .. GET_CURRENT_HEIGHT_IN_METERS() .. " m"
    local displayTextWidth, displayTextHeight = gfx.getTextSize(displayString)
    local displayImage = gfx.image.new(displayTextWidth, displayTextHeight)
    gfx.pushContext(displayImage)
        gfx.drawText(displayString, 0, 0)
    gfx.popContext()
    self:setImage(displayImage)
end