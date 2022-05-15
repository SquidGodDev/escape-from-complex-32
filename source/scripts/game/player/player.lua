import "scripts/game/player/laserGun"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Player').extends(gfx.sprite)

function Player:init()
    local playerRadius = 16
    local playerImage = gfx.image.new(playerRadius * 2, playerRadius * 2)
    gfx.pushContext(playerImage)
        gfx.drawCircleAtPoint(playerRadius, playerRadius, playerRadius)
    gfx.popContext()
    self:setImage(playerImage)
    self:setCollideRect(0, 0, self:getSize())
    self:setGroups(PLAYER_GROUP)
    self:setCollidesWithGroups({WALL_GROUP, OBSTACLE_GROUP})
    self:moveTo(200, 120)
    gfx.setDrawOffset(0, 0)
    self:add()

    self.yVelocity = 0
    self.xVelocity = 0
    self.maxVelocity = 50
    self.xDamping = 0.18
    self.wallBoost = 5

    self.launchStrength = 15

    self.laserGun = LaserGun(self.x, self.y, self)

    self:launch(180)
end

function Player:launch(angle)
    local xLaunch = -math.cos(math.rad(angle - 90)) * self.launchStrength
    local yLaunch = -math.sin(math.rad(angle - 90)) * self.launchStrength
    self.xVelocity = xLaunch
    self.yVelocity = yLaunch
end

function Player:update()
    self.yVelocity += 9.8/30
    if self.yVelocity >= self.maxVelocity then
        self.yVelocity = self.maxVelocity
    end
    if math.abs(self.xVelocity) < 0.05 then
        self.xVelocity = 0
    elseif self.xVelocity > 0 then
        self.xVelocity -= self.xDamping
    elseif self.xVelocity < 0 then
        self.xVelocity += self.xDamping
    end

    local newX = self.x + self.xVelocity
    local newY = self.y + self.yVelocity
    self.laserGun:moveTo(newX, newY)
    local actualX, actualY, collisions, length = self:moveWithCollisions(newX, newY)
    if length > 0 then
        self.xVelocity *= -1
        self.yVelocity -= self.wallBoost
    end
    gfx.setDrawOffset(0, -math.floor(self.y) + 120)
end

function Player:collisionResponse(other)
    return 'bounce'
end