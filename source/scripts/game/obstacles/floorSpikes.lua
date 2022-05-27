import "scripts/game/obstacles/obstacle"

local pd <const> = playdate
local gfx <const> = pd.graphics

local get_current_height = GET_CURRENT_HEIGHT

class('FloorSpikes').extends(Obstacle)

function FloorSpikes:init()
    local floorSpikesImage = gfx.image.new("images/game/floorSpikes")
    self:setImage(floorSpikesImage)
    self.floorOffset = 800
    self.currentMaxHeight = self.floorOffset
    self.leftPadding = 16
    self:setCenter(0, 0)
    self:moveTo(self.leftPadding, self.currentMaxHeight)

    self:setCollideRect(0, 0, self:getSize())
    self:setGroups(OBSTACLE_GROUP)

    self:add()
end

function FloorSpikes:update()
    local curHeight = get_current_height()
    local newFloorPos = -curHeight + self.floorOffset
    if newFloorPos < self.currentMaxHeight then
        self.currentMaxHeight = newFloorPos
        self:moveTo(self.leftPadding, newFloorPos)
    end
end