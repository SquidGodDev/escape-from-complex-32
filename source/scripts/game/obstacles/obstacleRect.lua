import "scripts/game/obstacles/obstacle"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('ObstacleRect').extends(Obstacle)

function ObstacleRect:init(x, y, width, height, padding)
    Gate.super.init(self, y)
    self:setGroups(OBSTACLE_GROUP)
    self:setCenter(0, 0)
    self:moveTo(x, y)
    self:setCollideRect(padding, padding, width - padding * 2, height - padding * 2)
end