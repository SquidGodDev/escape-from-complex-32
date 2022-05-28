-- Script for moving spike obstacle

import "scripts/game/obstacles/spike"

local pd <const> = playdate
local gfx <const> = pd.graphics

-- Note, we're actually extending the spike class,
-- note Obstacle, so it really is just the stationary
-- spike, but we add some movement to it
class('MovingSpike').extends(Spike)

function MovingSpike:init(y)
    -- Calling the spike.lua constructor
    MovingSpike.super.init(self, y)
    self.moveSpeed = 2
    -- Originally, I had it where it would move right
    -- if it was closer to the right and move left
    -- if it was closer to the left, but it looked kinda
    -- weird, so I just made it random which direction it
    -- starts off moving
    local randVal = math.random(0, 1)
    if randVal == 0 then
        self.movingRight = true
    else
        self.movingRight = false
    end
end

function MovingSpike:update()
    -- Notice here that I'm calling the parent update function
    -- here, unlike floorSpike.lua, because this is something I
    -- want to disappear after the player moves up.
    MovingSpike.super.update(self)
    -- The movement left and right is pretty self explanatory I hope
    if self.movingRight then
        self:moveBy(self.moveSpeed, 0)
        if self.x >= self.maxX then
            self.movingRight = false
        end
    else
        self:moveBy(-self.moveSpeed, 0)
        if self.x <= self.minX then
            self.movingRight = true
        end
    end
end