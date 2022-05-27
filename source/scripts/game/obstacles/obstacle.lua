local pd <const> = playdate
local gfx <const> = pd.graphics

local get_current_height = GET_CURRENT_HEIGHT

class('Obstacle').extends(gfx.sprite)

function Obstacle:init(y)
    self.spawnHeight = y
    self:add()
end

function Obstacle:update()
    local curHeight = get_current_height()
    if self.spawnHeight + curHeight > 1000 then
        self:remove()
    end
end