-- Script to spawn those platforms with gaps in them

import "scripts/game/obstacles/obstacle"
import "scripts/game/obstacles/obstacleRect"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Gate').extends(Obstacle)

function Gate:init(y)
    Gate.super.init(self, y)
    self.gateGapSize = 150
    self.gateHeight = 20
    self.gateWidth = 369
    self.gateX = 15
    -- By setting the gap size and the width of the entire platform, I
    -- can use some math to generate randomly where the gap should be, but,
    -- make sure it doesn't go too far to the left or right
    local gatePos = math.random(5, self.gateWidth - self.gateGapSize - 5)
    local gateImage = gfx.image.new(self.gateWidth, self.gateHeight)
    -- Just using two drawRect calls to programmatically draw the platforms
    -- based on the random gate position I generated
    gfx.pushContext(gateImage)
        gfx.setLineWidth(1)
        gfx.drawRect(0, 0, gatePos, self.gateHeight)
        gfx.drawRect(gatePos + self.gateGapSize, 0, self.gateWidth, self.gateHeight)
    gfx.popContext()
    -- A sprite can only have one collision rect attatched to it, so in order to have a
    -- gap in the collision rect, I created a helper class "ObstacleRect" to create two
    -- seperate invisible collision rects
    ObstacleRect(self.gateX, y, gatePos, self.gateHeight, 4)
    ObstacleRect(self.gateX + gatePos + self.gateGapSize, y, self.gateWidth, self.gateHeight, 4)
    self:setImage(gateImage)
    self:setCenter(0, 0)
    self:moveTo(self.gateX, y)
end