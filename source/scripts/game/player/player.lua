-- The player script which handles all the movement physics,
-- moving the screen offset based on the player position, and
-- the button input

import "scripts/game/player/laserGun"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Player').extends(gfx.sprite)

function Player:init(gameScene)
    -- I take in the game scene here so we can call
    -- displayResults later, which exists on the scene
    self.gameScene = gameScene
    self.playerYOffset = 180

    self.dead = false

    self.destroyedSound = pd.sound.sampleplayer.new("sounds/destroyed")
    self.bounceSound = pd.sound.sampleplayer.new("sounds/bounce")

    -- Just drawing our happy little circle
    local playerRadius = 16
    local playerImage = gfx.image.new(playerRadius * 2, playerRadius * 2)
    gfx.pushContext(playerImage)
        gfx.drawCircleAtPoint(playerRadius, playerRadius, playerRadius)
    gfx.popContext()
    self:setImage(playerImage)

    -- I gave the player collision box some padding as well, to give the player
    -- more leeway during close calls
    local padding = 4
    local playerWidth, playerHeight = self:getSize()
    self:setCollideRect(padding, padding, playerWidth - padding * 2, playerHeight - padding * 2)
    self:setGroups(PLAYER_GROUP)
    self:setCollidesWithGroups({WALL_GROUP, OBSTACLE_GROUP})
    self:moveTo(200, self.playerYOffset)
    gfx.setDrawOffset(0, 0)
    self:add()

    -- Keeping track of the velocity here
    self.yVelocity = 0
    self.xVelocity = 0
    -- This is max falling velocity (i.e. terminal velocity)
    self.maxVelocity = 50
    -- This is the amount the x velocity decreases by every
    -- frame. You can imagine it like kind of air resistance,
    -- but sideways? It's a value I just messed around with, and
    -- without it, it felt weird because you would move sideways
    -- linearally
    self.xDamping = 0.18
    -- How much the player y velocity gets increased by when you
    -- do a wall bounce
    self.wallBoost = 5

    -- How much the player y velocity gets set to when you shoot
    -- the laser
    self.launchStrength = 10

    self.laserGun = LaserGun(self.x, self.y, self)

    -- This is to give the player some starting upward momentum at
    -- the start of the game so you don't immediately start falling
    self:launch(180)
end

function Player:launch(angle)
    -- Calculating which way to launch the player based on the angle of
    -- the laser gun. Then, we just set the velocities. Notice, that it's
    -- not adding velocity, it's setting it, so the player can never go
    -- faster than however much the launch strength is
    local xLaunch = -math.cos(math.rad(angle - 90)) * self.launchStrength
    local yLaunch = -math.sin(math.rad(angle - 90)) * self.launchStrength
    self.xVelocity = xLaunch
    self.yVelocity = yLaunch
end

function Player:update()
    -- This is to make sure after the run ends, nothing weird can happen
    if self.dead then
        return
    end

    if pd.buttonJustPressed(pd.kButtonUp) or pd.buttonJustPressed(pd.kButtonDown) or pd.buttonJustPressed(pd.kButtonB) or pd.buttonJustPressed(pd.kButtonA) then
        self.laserGun:shoot()
    end

    -- Gravity constant is 9.8 meters per second, but, we're running at around 30
    -- frames per second, so divide by 30. I'm using frame based physics here, which
    -- is technically not ideal since if the frame rate changes the game will speed up/slow down,
    -- so you're "supposed" to use something called delta time and make it time based. But,
    -- the game runs pretty smoothly and everyone has the same hardware, so it doesn't matter
    -- that much
    self.yVelocity += 9.8/30
    if self.yVelocity >= self.maxVelocity then
        self.yVelocity = self.maxVelocity
    end
    if math.abs(self.xVelocity) < 0.05 then
        -- If the x velocity is really small, I just coerce it to
        -- become 0. This is so when you're moving sideways and the damping
        -- occurs, you don't get into this weird state where you're oscillating
        -- a tiny distance side to side
        self.xVelocity = 0
    elseif self.xVelocity > 0 then
        -- This is the horizontal damping I was referring to. Simple - just
        -- decreasing the velocity every frame
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
            -- This is why I extended all the obstacles from one
            -- parent class, so we can have this simple check to
            -- see if we hit an obstacle
            if collidedObject:isa(Obstacle) then
                hitObstacle = true
            end
        end

        if hitObstacle then
            -- If we hit an obstacle, we should display the results
            self.gameScene:displayResults()
            self.dead = true
            self.destroyedSound:play()
            return
        else
            -- Otherwise, the only other thing we could have hit was
            -- a wall. So, we reverse the x velocity and give the player
            -- a boost
            self.xVelocity *= -1
            self.yVelocity -= self.wallBoost
            self.bounceSound:play()
        end
    end

    -- This is where we set the draw offset. Since it's based
    -- directly on the player height, we can also just use the
    -- offset as a measure of the height the player is at.
    -- self.playerYOffset makes it so the player appears lower
    -- on the screen
    local newHeight = -math.floor(self.y) + self.playerYOffset
    gfx.setDrawOffset(0, newHeight)
end

-- Boing!
function Player:collisionResponse(other)
    return 'bounce'
end