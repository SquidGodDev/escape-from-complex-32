import "scripts/game/player/laserGun"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Player').extends(gfx.sprite)

function Player:init(gameScene)
    self.gameScene = gameScene
    self.playerYOffset = 180

    self.dead = false

    local playerRadius = 16
    local playerImage = gfx.image.new(playerRadius * 2, playerRadius * 2)
    gfx.pushContext(playerImage)
        gfx.drawCircleAtPoint(playerRadius, playerRadius, playerRadius)
    gfx.popContext()
    self:setImage(playerImage)

    local padding = 4
    local playerWidth, playerHeight = self:getSize()
    self:setCollideRect(padding, padding, playerWidth - padding * 2, playerHeight - padding * 2)
    self:setGroups(PLAYER_GROUP)
    self:setCollidesWithGroups({WALL_GROUP, OBSTACLE_GROUP})
    self:moveTo(200, self.playerYOffset)
    gfx.setDrawOffset(0, 0)
    self:add()

    self.yVelocity = 0
    self.xVelocity = 0
    self.maxVelocity = 50
    self.xDamping = 0.18
    self.wallBoost = 5

    self.launchStrength = 10

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
    if self.dead then
        return
    end

    if pd.buttonJustPressed(pd.kButtonUp) then
        self.laserGun:shoot()
    end

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
        local hitObstacle = false
        for index, collision in ipairs(collisions) do
            local collidedObject = collision['other']
            if collidedObject:isa(Obstacle) then
                hitObstacle = true
            end
        end

        if hitObstacle then
            self.gameScene:displayResults()
            self.dead = true
            return
        else
            self.xVelocity *= -1
            self.yVelocity -= self.wallBoost
        end
    end

    local newHeight = -math.floor(self.y) + self.playerYOffset
    gfx.setDrawOffset(0, newHeight)
end

function Player:collisionResponse(other)
    return 'bounce'
end