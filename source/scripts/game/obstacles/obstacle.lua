local pd <const> = playdate
local gfx <const> = pd.graphics

class('Obstackle').extends(gfx.sprite)

function Obstacle:init(x, y)
    self.spawnHeight = y
    self:moveTo(x, y)
    self:add()
end

function Obstacle:update()
    
end