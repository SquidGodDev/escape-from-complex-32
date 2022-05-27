import "scripts/game/ui/heightDialog"

local pd <const> = playdate
local gfx <const> = pd.graphics

local fadedRects = {}
for i=0,55,5 do
    local fadedRect = gfx.image.new(400, 240)
    gfx.pushContext(fadedRect)
        local solidRect = gfx.image.new(400, 240, gfx.kColorBlack)
        solidRect:drawFaded(0, 0, i / 100, gfx.image.kDitherTypeBayer8x8)
    gfx.popContext()
    fadedRects[i] = fadedRect
end

class('ResultsDisplay').extends(gfx.sprite)

function ResultsDisplay:init(gameScene, height, snapshot)
    self.gameScene = gameScene
    self.height = height
    self.snapshot = snapshot

    self.animatingIn = true
    self.animatingOut = false
    self.animateInDuration = 600
    self.animateOutDuration = 500
    self.snapshotAnimator = gfx.animator.new(self.animateInDuration, 0, 50, pd.easingFunctions.linear)
    self.lastDrawnFaded = 1

    self.heightDialog = HeightDialog(height)
    self.dialogAnimator = gfx.animator.new(self.animateInDuration, self.heightDialog.y, 120, pd.easingFunctions.inOutCubic)
    local metalDoorSound = pd.sound.sampleplayer.new("sounds/metalDoorSliding")
    metalDoorSound:play()

    self.whooshSound = pd.sound.sampleplayer.new("sounds/whoosh")

    self:setImage(self.snapshot)
    self:setZIndex(500)
    self:setCenter(0, 0)
    self:moveTo(0, 0)
    self:add()
end

function ResultsDisplay:update()
    if self.animatingIn then
        local snapshotAnimatorValue = self.snapshotAnimator:currentValue()
        self.lastDrawnFaded = snapshotAnimatorValue
        local fadedImageIndex = ((snapshotAnimatorValue // 5) * 5)
        local fadedRect = fadedRects[fadedImageIndex]
        if fadedRect then
            local fadedImage = gfx.image.new(400, 240)
            gfx.pushContext(fadedImage)
                self.snapshot:draw(0, 0)
                fadedRect:draw(0,0)
            gfx.popContext()
            self:setImage(fadedImage)
        end

        local dialogPosition = self.dialogAnimator:currentValue()
        self.heightDialog:moveTo(self.heightDialog.x, dialogPosition)

        if self.snapshotAnimator:ended() then
            self.animatingIn = false
        end
    elseif self.animatingOut then
        self:moveTo(0, self.moveTimer:currentValue())

        local dialogPosition = self.dialogAnimator:currentValue()
        self.heightDialog:moveTo(self.heightDialog.x, dialogPosition)

        if self.moveTimer:ended() then
            self:remove()
            self.heightDialog:remove()
        end
    else
        if pd.buttonJustPressed(pd.kButtonA) then
            self.moveTimer = gfx.animator.new(self.animateOutDuration, 0, 200, pd.easingFunctions.inOutCubic)
            self.dialogAnimator = gfx.animator.new(self.animateOutDuration, 120, 320, pd.easingFunctions.inOutCubic)
            self.animatingOut = true
            self.gameScene:setupGame()
            self.whooshSound:play()
        end
    end
end