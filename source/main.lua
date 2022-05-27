import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "scripts/globalScripts"
import "scripts/signal"

import "scripts/sceneManager"
import "scripts/game/gameScene"
import "scripts/title/titleScene"

local pd <const> = playdate
local gfx <const> = pd.graphics

PLAYER_GROUP = 1
WALL_GROUP = 2
OBSTACLE_GROUP = 3

SignalManager = Signal()

MAX_HEIGHT = 0

LOAD_GAME_DATA()

SCENE_MANAGER = SceneManager()
TitleScene()

function pd.update()
    gfx.sprite.update()
    pd.timer.updateTimers()
end

function pd.gameWillTerminate()
    SAVE_GAME_DATA()
end

function pd.gameWillSleep()
    SAVE_GAME_DATA()
end