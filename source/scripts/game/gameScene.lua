import "scripts/game/player/player"
import "scripts/game/background/gameBackground"
import "scripts/game/background/heightDisplay"
import "scripts/game/background/maxHeightDisplay"
import "scripts/game/obstacles/obstacleSpawner"

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
    MaxHeightDisplay()
    ObstacleSpawner()
end

function GameScene:resetGame()
    gfx.setDrawOffset(0, 0)
    gfx.sprite.removeAll()
    self:setupGame()
end

function GameScene:stopGame()
    self:displayResults()
end

function GameScene:displayResults()
    
end