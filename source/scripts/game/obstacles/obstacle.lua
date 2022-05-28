-- Parent class to all obstacles that handles adding to
-- the draw list and automatically getting removed when
-- the player moves up

local pd <const> = playdate
local gfx <const> = pd.graphics

local get_current_height = GET_CURRENT_HEIGHT

class('Obstacle').extends(gfx.sprite)

function Obstacle:init(y)
    -- Keeping track of where the obstacle was
    -- spawned to use later
    self.spawnHeight = y
    -- I call the add sprite method here so
    -- any child sprite doesn't need to do it
    self:add()
end

function Obstacle:update()
    -- Basically, I check if the player is ~10 meters
    -- above the obstacle. If so, I remove it. This is
    -- so if the player goes up really high, there won't
    -- be a bunch of obstacles loaded in memory to affect
    -- performance. Think Minecraft chunk loading, but super
    -- simple and not that cool
    local curHeight = get_current_height()
    if self.spawnHeight + curHeight > 1000 then
        self:remove()
    end
end