import "scripts/game/obstacles/spike"
import "scripts/game/obstacles/movingSpike"
import "scripts/game/obstacles/gate"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('ObstacleSpawner').extends(gfx.sprite)

function ObstacleSpawner:init()
    self.lastSpawnHeight = 0
    self.spawnGap = 150
    self.spawnOffset = 50
    self:add()
end

function ObstacleSpawner:update()
    local drawOffsetX, curHeight = gfx.getDrawOffset()
    local spawnHeight = math.floor(curHeight / self.spawnGap)
    if spawnHeight > self.lastSpawnHeight then
        self.lastSpawnHeight = spawnHeight
        local obstacleHeight = -curHeight - self.spawnOffset
        local randVal = math.random(0, 2)
        if randVal == 0 then
            Spike(obstacleHeight)
        elseif randVal == 1 then
            MovingSpike(obstacleHeight)
        elseif randVal == 2 then
            Gate(obstacleHeight)
        end
    end
end