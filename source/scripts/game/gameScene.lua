-- The class that handles initializing everything regarding
-- the actual game scene

import "scripts/game/player/player"
import "scripts/game/background/gameBackground"
import "scripts/game/obstacles/obstacleSpawner"
import "scripts/game/obstacles/floorSpikes"
import "scripts/game/ui/heightDisplay"
import "scripts/game/ui/resultsDisplay"

local pd <const> = playdate
local gfx <const> = pd.graphics

-- Not extending a sprite here since we don't need the update functionality,
-- and also we don't want it to disappear when gfx.sprite.removeAll() is called
class('GameScene').extends()

function GameScene:init()
    math.randomseed(pd.getSecondsSinceEpoch())
    self:setupGame()
end

-- Having all these classes is nice, since we can
-- create the entire scene with just class init
-- function calls!
function GameScene:setupGame()
    Player(self)
    GameBackground()
    HeightDisplay()
    ObstacleSpawner()
    FloorSpikes()
end

function GameScene:displayResults()
    local curHeight = GET_CURRENT_HEIGHT()
    -- Taking a screenshot of the last frame of the game
    -- to have that nice fade effect
    local snapshot = gfx.getDisplayImage()
    -- Remembering to reset the draw offset, and therefore
    -- the height!
    gfx.setDrawOffset(0, 0)
    -- We can get rid of everything related to the game
    -- just by calling this, since everything is a sprite.
    -- Nice!
    gfx.sprite.removeAll()
    ResultsDisplay(self, curHeight, snapshot)
end