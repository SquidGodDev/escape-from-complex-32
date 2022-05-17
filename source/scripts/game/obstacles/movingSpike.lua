import "scripts/game/obstacles/spike"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('MovingSpike').extends(Spike)

function MovingSpike:init(y)
    MovingSpike.super.init(self, y)
    self.moveSpeed = 2
    local randVal = math.random(0, 1)
    if randVal == 0 then
        self.movingRight = true
    else
        self.movingRight = false
    end
end

function MovingSpike:update()
    MovingSpike.super.update(self)
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