import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "scripts/signal"
import "scripts/game/player/player"
import "scripts/game/background/gameBackground"
import "scripts/game/background/heightDisplay"
import "scripts/game/background/maxHeightDisplay"
import "scripts/game/obstacles/obstacleSpawner"

local pd <const> = playdate
local gfx <const> = pd.graphics

PLAYER_GROUP = 1
WALL_GROUP = 2
OBSTACLE_GROUP = 3

SignalManager = Signal()

MAX_HEIGHT = 0

local function initialize()
    math.randomseed(pd.getSecondsSinceEpoch())
    Player()
    GameBackground()
    HeightDisplay()
    MaxHeightDisplay()
    ObstacleSpawner()
    -- local backgroundImage = gfx.image.new("images/background")
    -- gfx.sprite.setBackgroundDrawingCallback(
    --     function(x, y, width, height)
    --         gfx.setClipRect(x, y, width, height) -- let's only draw the part of the screen that's dirty
    --         backgroundImage:draw(0, 0)
    --         gfx.clearClipRect() -- clear so we don't interfere with drawing that comes after this
    --     end
    -- )
end

function resetGame()
    gfx.setDrawOffset(0, 0)
    gfx.sprite.removeAll()
    initialize()
end

initialize()

function pd.update()
    gfx.sprite.update()
    pd.timer.updateTimers()
end
