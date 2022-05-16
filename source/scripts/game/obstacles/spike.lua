import "scripts/game/obstacles/obstacle"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Spike').extends(Obstacle)

function Spike:init()
    Spike.super.init(self)
    local spikeImage = gfx.image.new("images/game/spike")
    self:setImage(spikeImage)

    local imageWidth, imageHeight = self:getSize()
    local collisionPadding = 2
    local collisionWidth = imageWidth - collisionPadding
    local collisionHeight = imageHeight - collisionPadding
    self:setCollideRect(collisionPadding, collisionPadding, collisionWidth, collisionHeight)
    self:setGroups(OBSTACLE_GROUP)
end