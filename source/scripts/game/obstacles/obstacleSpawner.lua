-- Class that manages spawning the obstacles as the
-- player moves up

import "scripts/game/obstacles/spike"
import "scripts/game/obstacles/movingSpike"
import "scripts/game/obstacles/gate"

local pd <const> = playdate
local gfx <const> = pd.graphics

local get_current_height = GET_CURRENT_HEIGHT

-- Notice that I extend the sprite despite it not really
-- being a graphics object (no setImage). This might seem
-- weird, but remember, I'm putting all logic into sprites
-- so when you call gfx.sprite.removeAll(), you can effectively
-- clear out an entire scene, which is quite useful. Also,
-- I like that each sprite has a self contained update function
-- so you don't end up with a main update function that's really
-- cluttered - it's all abstracted away in each class
class('ObstacleSpawner').extends(gfx.sprite)

function ObstacleSpawner:init()
    self.lastSpawnHeight = 0
    -- SpawnGap is how much space to have between
    -- each obstacle
    self.spawnGap = 150
    -- SpawnOffset is how far above the player to
    -- spawn the obstacle. I spawn it right outside
    -- of the screen
    self.spawnOffset = 50
    self:add()
end

function ObstacleSpawner:update()
    local curHeight = get_current_height()
    -- Basically, we can coerce the current height
    -- into a multiple of spawnGap using the floor
    -- function and dividing. Then, we check if the
    -- spawn height is higher than the last spawn height
    -- to make sure we're not spawning multiple obstacles
    -- at the same height
    local spawnHeight = math.floor(curHeight / self.spawnGap)
    if spawnHeight > self.lastSpawnHeight then
        self.lastSpawnHeight = spawnHeight
        -- So, the reason we're taking the negative of the current
        -- height as the position is kind of weird. Basically, the draw
        -- offset, and therefore the height, is positive. But, above the
        -- player is actually more and more negative on the Y axis. So,
        -- we invert it
        local obstacleHeight = -curHeight - self.spawnOffset
        -- Just randomly picking whether to spawn a spike, a moving spike,
        -- or a gate
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