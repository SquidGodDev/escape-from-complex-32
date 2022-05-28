-- This script handles the walls you see on the left and right,
-- which includes the logic for the infinite scrolling and also
-- the collision boxes.

local pd <const> = playdate
local gfx <const> = pd.graphics

class('GameBackground').extends(gfx.sprite)

function GameBackground:init()
    local backgroundImage = gfx.image.new("images/game/tiledBackground")
    self:setImage(backgroundImage)
    -- I'm just using the addEmptyCollisionSprite function to add two collision
    -- rects on the left and right. I set their collision response to bounce.
    self.leftWall = gfx.sprite.addEmptyCollisionSprite(0, 0, 16, 480)
    self.rightWall = gfx.sprite.addEmptyCollisionSprite(384, 0, 16, 480)
    self.leftWall.collisionResponse = 'bounce'
    self.rightWall.collisionResponse = 'bounce'
    -- An example of me using the collision group constants I declare in globals.lua.
    -- Better than remembering "2" is arbitrarily the wall group eh?
    self.leftWall:setGroups(WALL_GROUP)
    self.rightWall:setGroups(WALL_GROUP)
    self:moveTo(200, 120)
    self:add()
end

function GameBackground:moveTo(x, y)
    GameBackground.super.moveTo(self, x, y)
    -- A nice trick to move any dependent sprites
    -- at the same time the parent sprite moves
    self.leftWall:moveTo(x - 200 + 8, y)
    self.rightWall:moveTo(x + 200 - 8, y)
end

function GameBackground:update()
    local drawOffsetX, drawOffsetY = gfx.getDrawOffset()
    -- The math.floor function is doing the magic here. By
    -- dividing drawOffsetY by 120 and taking the floor and
    -- multiplying it by 120, I'm effectively snapping the drawOffsetY
    -- to multiples of 120. Therefore, the walls only move in increments
    -- of 120, which is the interval at which the wall image I drew repeats
    local moveY = -math.floor(drawOffsetY / 120) * 120 + 120
    self:moveTo(200, moveY)
end