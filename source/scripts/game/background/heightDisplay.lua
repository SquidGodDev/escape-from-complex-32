local pd <const> = playdate
local gfx <const> = pd.graphics

class('HeightDisplay').extends(gfx.sprite)

function HeightDisplay:init()
    self:setCenter(0, 0)
    self:moveTo(25, 8)
    self:setIgnoresDrawOffset(true)
    self:add()
end

function HeightDisplay:update()
    local drawOffsetX, drawOffsetY = gfx.getDrawOffset()
    local displayString = "Height: " .. math.floor(drawOffsetY / 100) .. " m"
    local displayTextWidth, displayTextHeight = gfx.getTextSize(displayString)
    local displayImage = gfx.image.new(displayTextWidth, displayTextHeight)
    gfx.pushContext(displayImage)
        gfx.drawText(displayString, 0, 0)
    gfx.popContext()
    self:setImage(displayImage)
end