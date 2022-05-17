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
    local gatePos = math.random(5, self.gateWidth - self.gateGapSize - 5)
    local gateImage = gfx.image.new(self.gateWidth, self.gateHeight)
    gfx.pushContext(gateImage)
        gfx.setLineWidth(1)
        gfx.drawRect(0, 0, gatePos, self.gateHeight)
        gfx.drawRect(gatePos + self.gateGapSize, 0, self.gateWidth, self.gateHeight)
    gfx.popContext()
    ObstacleRect(self.gateX, y, gatePos, self.gateHeight, 4)
    ObstacleRect(self.gateX + gatePos + self.gateGapSize, y, self.gateWidth, self.gateHeight, 4)
    self:setImage(gateImage)
    self:setCenter(0, 0)
    self:moveTo(self.gateX, y)
end