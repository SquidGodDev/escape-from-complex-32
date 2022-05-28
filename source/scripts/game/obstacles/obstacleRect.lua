-- Helper script to create an invisible collision rect. I
-- think these short helper scripts are really useful and
-- a great way to utilize abstraction to simply your code

import "scripts/game/obstacles/obstacle"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('ObstacleRect').extends(Obstacle)

function ObstacleRect:init(x, y, width, height, padding)
    Gate.super.init(self, y)
    self:setGroups(OBSTACLE_GROUP)
    self:setCenter(0, 0)
    self:moveTo(x, y)
    -- The padding is to make the collision rect a little smaller to
    -- make the player not feel as cheated if they have a close call
    self:setCollideRect(padding, padding, width - padding * 2, height - padding * 2)
end