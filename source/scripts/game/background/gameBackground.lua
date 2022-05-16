local pd <const> = playdate
local gfx <const> = pd.graphics

class('GameBackground').extends(gfx.sprite)

function GameBackground:init()
    local backgroundImage = gfx.image.new("images/game/tiledBackground")
    self:setImage(backgroundImage)
    -- self:setCollideRect(0, 0, 400, 480)
    -- self:setGroups(WALL_GROUP)
    self.leftWall = gfx.sprite.addEmptyCollisionSprite(0, 0, 16, 480)
    self.rightWall = gfx.sprite.addEmptyCollisionSprite(384, 0, 16, 480)
    self.leftWall.collisionResponse = 'bounce'
    self.rightWall.collisionResponse = 'bounce'
    self.leftWall:setGroups(WALL_GROUP)
    self.rightWall:setGroups(WALL_GROUP)
    self:moveTo(200, 120)
    self:add()
end

function GameBackground:moveTo(x, y)
    GameBackground.super.moveTo(self, x, y)
    self.leftWall:moveTo(x - 200 + 8, y)
    self.rightWall:moveTo(x + 200 - 8, y)
end

function GameBackground:update()
    local drawOffsetX, drawOffsetY = gfx.getDrawOffset()
    local moveY = -math.floor(drawOffsetY / 120) * 120 + 120
    self:moveTo(200, moveY)
    print(drawOffsetY)
end