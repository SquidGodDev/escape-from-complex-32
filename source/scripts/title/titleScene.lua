-- The title scene. Yes, I manually animated everything with code.
-- But, the easing functions make it pretty easy!

import "CoreLibs/animation"

import "scripts/game/gameScene"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('TitleScene').extends(gfx.sprite)

function TitleScene:init()
    local wallsImage = gfx.image.new("images/title/walls")
    self.wallsSprite = gfx.sprite.new(wallsImage)
    self.wallsSprite:setCenter(0, 0)
    self.wallsSprite:add()
    local playerImage = gfx.image.new("images/title/player")
    self.playerSprite = gfx.sprite.new(playerImage)
    self.playerSprite:setCenter(0, 0)
    self.playerSprite:add()
    local spikesImage = gfx.image.new("images/title/spikes")
    self.spikesSprite = gfx.sprite.new(spikesImage)
    self.spikesSprite:setCenter(0, 0)
    self.spikesSprite:add()
    local titleImage = gfx.image.new("images/title/title")
    self.titleSprite = gfx.sprite.new(titleImage)
    self.titleSprite:setCenter(0, 0)
    self.titleSprite:add()
    local promptImage = gfx.image.new("images/title/prompt")
    self.promptSprite = gfx.sprite.new(promptImage)
    self.promptSprite:setCenter(0, 0)
    self.promptSprite:add()

    -- Basically, making sure to start each element off the screen
    self.wallStartY = -240
    self.playerStartX = -400
    self.spikeStartX = 400
    self.titleStartY = -240
    self.promptStartY = 240

    self.wallsSprite:moveTo(0, self.wallStartY)
    self.playerSprite:moveTo(self.playerStartX, 0)
    self.spikesSprite:moveTo(self.spikeStartX, 0)
    self.titleSprite:moveTo(0, self.titleStartY)
    self.promptSprite:moveTo(0, self.promptStartY)

    -- I just played around with the duration values to see what looked good. I relied on the
    -- last argument a lot to delay the animations to get the timings right
    self.wallsAnimator = gfx.animator.new(700, self.wallStartY, 0, pd.easingFunctions.inOutCubic)
    self.playerAnimator = gfx.animator.new(800, self.playerStartX, 0, pd.easingFunctions.inOutCubic, 300)
    self.spikesAnimator = gfx.animator.new(800, self.spikeStartX, 0, pd.easingFunctions.inOutCubic, 500)
    self.titleAnimator = gfx.animator.new(1300, self.titleStartY, 0, pd.easingFunctions.outBounce, 600)
    self.promptAnimator = gfx.animator.new(1000, self.promptStartY, 0, pd.easingFunctions.outExpo, 1600)

    -- This is to have the "Press A to start" prompt blink like classic arcade games
    self.promptBlinker = gfx.animation.blinker.new()
    self.promptBlinker.onDuration = 400
    self.promptBlinker.offDuration = 400

    self.animating = true
    self:add()

    local metalDoorSound = pd.sound.sampleplayer.new("sounds/metalDoorSliding")
    metalDoorSound:play()

    -- I use the playAt methods to delay the sound to match up with the animation.
    -- Just used trial and error to get it to match up - nothing sophisticated
    local laserSound = pd.sound.sampleplayer.new("sounds/laser1")
    laserSound:playAt(pd.sound.getCurrentTime() + .6)

    local whooshSound = pd.sound.sampleplayer.new("sounds/whoosh")
    whooshSound:playAt(pd.sound.getCurrentTime() + .8)

    local metalDropSound = pd.sound.sampleplayer.new("sounds/metalDrop")
    metalDropSound:playAt(pd.sound.getCurrentTime() + .9)

    self.blipSound = pd.sound.sampleplayer.new("sounds/blip")
end

function TitleScene:update()
    if self.animating then
        local wallY = self.wallsAnimator:currentValue()
        self.wallsSprite:moveTo(0, wallY)
        local playerX = self.playerAnimator:currentValue()
        self.playerSprite:moveTo(playerX, 0)
        local spikesX = self.spikesAnimator:currentValue()
        self.spikesSprite:moveTo(spikesX, 0)
        local titleY = self.titleAnimator:currentValue()
        self.titleSprite:moveTo(0, titleY)

        if self.titleAnimator:ended() then
            self.animating = false
        end
    else
        local promptY = self.promptAnimator:currentValue()
        self.promptSprite:moveTo(0, promptY)
        if self.promptAnimator:ended() and not self.promptBlinker.running then
            self.promptBlinker:startLoop()
        end

        self.promptBlinker:update()
        local promptIsVisible = self.promptSprite:isVisible()
        if self.promptBlinker.on and not promptIsVisible then
            self.blipSound:play()
            self.promptSprite:setVisible(true)
        elseif not self.promptBlinker.on and promptIsVisible then
            self.promptSprite:setVisible(false)
        end

        if pd.buttonJustPressed(pd.kButtonA) then
            -- Had to do this so the blip sound doesn't play
            -- during the transition sometimes
            self.promptBlinker:stop()
            -- Using our scene manager! Only used once this
            -- entire game 😂
            SCENE_MANAGER:switchScene(GameScene)
        end
    end
end