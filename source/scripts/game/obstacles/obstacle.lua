local pd <const> = playdate
local gfx <const> = pd.graphics

class('Obstacle').extends(gfx.sprite)

function Obstacle:init(x, y)
    self.spawnHeight = y
    self:moveTo(x, y)
    self:add()
end

function Obstacle:update()
    local drawOffsetX, drawOffsetY = gfx.getDrawOffset()
    if drawOffsetY - self.spawnHeight > 500 then
        self:remove()
    end
end