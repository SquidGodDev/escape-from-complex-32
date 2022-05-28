-- I use this file to organize all my globals,
-- which are things that are globally accessible
-- and are used across the project. I didn't have
-- this initally, but felt like it makes the code
-- cleaner.

local pd <const> = playdate
local gfx <const> = pd.graphics

-- These are the collision groups. I like doing
-- this since, for me, it's better than remembering
-- numbers for what collision group should be which.
-- These are the only global variables besides MAX_HEIGHT
-- in the entire game, if that's any indication of how
-- aggressively I try to circumvent requiring globals
PLAYER_GROUP = 1
WALL_GROUP = 2
OBSTACLE_GROUP = 3

-- So, I actually use the draw offset to keep track of the
-- height of the player, which I thought was a clever way
-- to do it. I display the height in meters, which is just the
-- yOffset divided by 100 (which btw is a completely arbitrary
-- amount. I just felt about 100 pixels seemed good for 1 meter).
-- Anyways, I found myself calling getDrawOffset() a lot in many
-- files, so for organization and to reduce code duplication I
-- made them global functions.
function GET_CURRENT_HEIGHT_IN_METERS()
    local cur_height = GET_CURRENT_HEIGHT()
    return GET_HEIGHT_IN_METERS(cur_height)
end

function GET_HEIGHT_IN_METERS(height)
    return math.floor(height / 100)
end

function GET_CURRENT_HEIGHT()
    -- Another reason I chose to abstract this into
    -- a function is that I didn't like how if a function
    -- returns two values and you only use one, you have to
    -- declare it, but just throw it away. Looks ugly and
    -- some linters would throw a warning/error (See ESLint
    -- no unused vars)
    local drawOffsetX, drawOffsetY = gfx.getDrawOffset()
    return drawOffsetY
end

-- Pretty straightforward. Store your game data into a table,
-- which in my case is just the max height, and write it. On
-- read, get the table and handle the values as relevant
function SAVE_GAME_DATA()
    local gameData = {
        maxHeight = MAX_HEIGHT
    }
    pd.datastore.write(gameData)
end

function LOAD_GAME_DATA()
    local gameData = pd.datastore.read()
    if gameData then
        MAX_HEIGHT = gameData.maxHeight
    end
end