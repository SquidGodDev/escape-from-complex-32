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

    self.wallsAnimator = gfx.animator.new(700, self.wallStartY, 0, pd.easingFunctions.inOutCubic)
    self.playerAnimator = gfx.animator.new(800, self.playerStartX, 0, pd.easingFunctions.inOutCubic, 300)
    self.spikesAnimator = gfx.animator.new(800, self.spikeStartX, 0, pd.easingFunctions.inOutCubic, 500)
    self.titleAnimator = gfx.animator.new(1300, self.titleStartY, 0, pd.easingFunctions.outBounce, 600)
    self.promptAnimator = gfx.animator.new(1000, self.promptStartY, 0, pd.easingFunctions.outExpo, 1600)

    self.animating = true
    self:add()
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
        local promptY = self.promptAnimator:currentValue()
        self.promptSprite:moveTo(0, promptY)

        if self.promptAnimator:ended() then
            self.animating = false
            self.promptBlinker = gfx.animation.blinker.new()
            self.promptBlinker.onDuration = 400
            self.promptBlinker.offDuration = 400
            self.promptBlinker:startLoop()
        end
    else
        self.promptBlinker:update()
        if self.promptBlinker.on then
            self.promptSprite:setVisible(true)
        else
            self.promptSprite:setVisible(false)
        end
        if pd.buttonJustPressed(pd.kButtonA) then
            SCENE_MANAGER:switchScene(GameScene)
        end
    end
end