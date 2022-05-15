import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "scripts/signal"
import "scripts/game/player/player"
import "scripts/game/background/gameBackground"

local pd <const> = playdate
local gfx <const> = pd.graphics

PLAYER_GROUP = 1
WALL_GROUP = 2
OBSTACLE_GROUP = 3

SignalManager = Signal()

local function initialize()
    Player()
    GameBackground()
    -- local backgroundImage = gfx.image.new("images/background")
    -- gfx.sprite.setBackgroundDrawingCallback(
    --     function(x, y, width, height)
    --         gfx.setClipRect(x, y, width, height) -- let's only draw the part of the screen that's dirty
    --         backgroundImage:draw(0, 0)
    --         gfx.clearClipRect() -- clear so we don't interfere with drawing that comes after this
    --     end
    -- )
end

initialize()

function pd.update()
    gfx.sprite.update()
    pd.timer.updateTimers()
end
