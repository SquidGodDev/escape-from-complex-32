-- The stationary spike obstacle. I think it's a pretty
-- self explanatory class

import "scripts/game/obstacles/obstacle"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Spike').extends(Obstacle)

function Spike:init(y)
    Spike.super.init(self, y)
    self.minX = 30
    self.maxX = 370
    local spikeImage = gfx.image.new("images/game/spike")
    self:setImage(spikeImage)

    local imageWidth, imageHeight = self:getSize()
    local collisionPadding = 4
    local collisionWidth = imageWidth - collisionPadding * 2
    local collisionHeight = imageHeight - collisionPadding * 2
    self:setCollideRect(collisionPadding, collisionPadding, collisionWidth, collisionHeight)
    self:setGroups(OBSTACLE_GROUP)

    -- Just randomly choosing an x position to spawn the spike
    local randX = math.random(self.minX, self.maxX)
    self:moveTo(randX, y)
end