-- FloorSpikes are the spikes you see if you fall too far down.
-- This stops the player from falling infinetly. The floor follows
-- the player up, but when the player moves down, it stays at the
-- max position it has reached.

import "scripts/game/obstacles/obstacle"

local pd <const> = playdate
local gfx <const> = pd.graphics

local get_current_height = GET_CURRENT_HEIGHT

class('FloorSpikes').extends(Obstacle)

function FloorSpikes:init()
    local floorSpikesImage = gfx.image.new("images/game/floorSpikes")
    self:setImage(floorSpikesImage)
    -- This "floorOffset" is how far the spikes are below the player
    self.floorOffset = 800
    self.currentMaxHeight = self.floorOffset
    self.leftPadding = 16
    self:setCenter(0, 0)
    self:moveTo(self.leftPadding, self.currentMaxHeight)

    self:setCollideRect(0, 0, self:getSize())
    self:setGroups(OBSTACLE_GROUP)

    self:add()
end

-- So, if you check obstacle.lua, which this class extends,
-- it implements an update function that automatically removes
-- obstacles as the player moves up. However, I'm overriding that
-- behavior as I don't want it to disappear. I do want to still
-- extend the obstacle class, however, as the player checks if what
-- it collides with is of the obstacle class to see if it should
-- end the run
function FloorSpikes:update()
    local curHeight = get_current_height()
    local newFloorPos = -curHeight + self.floorOffset
    -- Basically, if the new floor position, which is 800
    -- below the current height, is higher than what the
    -- current max height of the floor is, then we should
    -- set a new max height and move the floor spikes up
    -- to that position
    if newFloorPos < self.currentMaxHeight then
        self.currentMaxHeight = newFloorPos
        self:moveTo(self.leftPadding, newFloorPos)
    end
end