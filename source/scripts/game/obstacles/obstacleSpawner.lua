import "scripts/game/obstacles/spike"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('ObstacleSpawner').extends(gfx.sprite)

function ObstacleSpawner:init()
    self:add()
end

function ObstacleSpawner:update()
    local drawOffsetX, drawOffsetY = gfx.getDrawOffset()
    local curHeight = drawOffsetY - 120
    if drawOffsetY - self.spawnHeight > 500 then
        self:remove()
    end
end