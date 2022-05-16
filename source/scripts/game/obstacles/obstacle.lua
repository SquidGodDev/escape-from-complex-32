local pd <const> = playdate
local gfx <const> = pd.graphics

class('Obstacle').extends(gfx.sprite)

function Obstacle:init(y)
    self.spawnHeight = y
    self:add()
end

function Obstacle:update()
    local drawOffsetX, curHeight = gfx.getDrawOffset()
    if self.spawnHeight + curHeight > 1000 then
        self:remove()
    end
end