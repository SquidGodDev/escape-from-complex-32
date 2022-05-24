import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "scripts/signal"

import "scripts/game/gameScene"

local pd <const> = playdate
local gfx <const> = pd.graphics

PLAYER_GROUP = 1
WALL_GROUP = 2
OBSTACLE_GROUP = 3

SignalManager = Signal()

MAX_HEIGHT = 0

GameScene()

function pd.update()
    gfx.sprite.update()
    pd.timer.updateTimers()
end
