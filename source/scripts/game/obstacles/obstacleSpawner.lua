import "scripts/game/obstacles/spike"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('ObstacleSpawner').extends(gfx.sprite)

function ObstacleSpawner:init()
    self.lastSpawnHeight = 0
    self.spawnGap = 100
    self:add()
end

function ObstacleSpawner:update()
    local drawOffsetX, curHeight = gfx.getDrawOffset()
    local spawnHeight = math.floor(curHeight / self.spawnGap)
    if spawnHeight > self.lastSpawnHeight then
        self.lastSpawnHeight = spawnHeight
        Spike(-curHeight)
    end
end