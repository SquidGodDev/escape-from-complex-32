local pd <const> = playdate
local gfx <const> = pd.graphics

PLAYER_GROUP = 1
WALL_GROUP = 2
OBSTACLE_GROUP = 3

function GET_CURRENT_HEIGHT_IN_METERS()
    local cur_height = GET_CURRENT_HEIGHT()
    return GET_HEIGHT_IN_METERS(cur_height)
end

function GET_HEIGHT_IN_METERS(height)
    return math.floor(height / 100)
end

function GET_CURRENT_HEIGHT()
    local drawOffsetX, drawOffsetY = gfx.getDrawOffset()
    return drawOffsetY
end

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