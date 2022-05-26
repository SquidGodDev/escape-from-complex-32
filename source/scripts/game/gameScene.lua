import "scripts/game/player/player"
import "scripts/game/background/gameBackground"
import "scripts/game/obstacles/obstacleSpawner"
import "scripts/game/ui/heightDisplay"
import "scripts/game/ui/resultsDisplay"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('GameScene').extends()

function GameScene:init()
    math.randomseed(pd.getSecondsSinceEpoch())
    self:setupGame()
end

function GameScene:setupGame()
    Player(self)
    GameBackground()
    HeightDisplay()
    ObstacleSpawner()
end

function GameScene:displayResults()
    local curHeight = GET_CURRENT_HEIGHT()
    local snapshot = gfx.getDisplayImage()
    gfx.setDrawOffset(0, 0)
    gfx.sprite.removeAll()
    ResultsDisplay(self, curHeight, snapshot)
end