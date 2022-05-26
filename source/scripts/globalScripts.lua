local pd <const> = playdate
local gfx <const> = pd.graphics

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