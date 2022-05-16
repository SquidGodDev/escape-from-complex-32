local pd <const> = playdate
local gfx <const> = pd.graphics

class('MaxHeightDisplay').extends(gfx.sprite)

function MaxHeightDisplay:init()
    self:setCenter(0, 0)
    self:moveTo(25, 28)
    self:setIgnoresDrawOffset(true)
    self:setZIndex(100)
    self:add()

    local displayString = "Max Height: " .. math.floor(MAX_HEIGHT / 100) .. " m"
    local displayTextWidth, displayTextHeight = gfx.getTextSize(displayString)
    local displayImage = gfx.image.new(displayTextWidth, displayTextHeight)
    gfx.pushContext(displayImage)
        gfx.drawText(displayString, 0, 0)
    gfx.popContext()
    self:setImage(displayImage)
end