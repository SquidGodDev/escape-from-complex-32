import "scripts/game/ui/heightDialog"

local pd <const> = playdate
local gfx <const> = pd.graphics



class('ResultsDisplay').extends(gfx.sprite)

function ResultsDisplay:init(gameScene, height, snapshot)
    self.gameScene = gameScene
    self.height = height
    self.snapshot = snapshot

    self.animatingIn = true
    self.animatingOut = false
    self.animateInDuration = 1000
    self.animateOutDuration = 1000
    self.snapshotAnimator = gfx.animator.new(self.animateInDuration, 1, 0.5, pd.easingFunctions.linear)
    self.lastDrawnBlurred = -1

    self.heightDialog = HeightDialog(height)
    self.dialogAnimator = gfx.animator.new(self.animateInDuration, self.heightDialog.y, 120, pd.easingFunctions.inOutCubic)

    self:setImage(self.snapshot)
    self:setZIndex(500)
    self:setCenter(0, 0)
    self:moveTo(0, 0)
    self:add()
end

function ResultsDisplay:update()
    if self.animatingIn then
        local snapshotAnimatorValue = self.snapshotAnimator:currentValue()
        -- local blurAmount = math.floor(snapshotAnimatorValue)
        -- if blurAmount ~= self.lastDrawnBlurred then
        --     print(blurAmount)
        --     self.lastDrawnBlurred = blurAmount
        --     local blurredImage = gfx.image.new(400, 240)
        --     gfx.pushContext(blurredImage)
        --         -- self.snapshot:drawBlurred(0, 0, blurAmount, 1, gfx.image.kDitherTypeFloydSteinberg)
        --     gfx.popContext()
        --     self:setImage(self.snapshot:vcrPauseFilterImage())
        -- end
        local fadedImage = gfx.image.new(400, 240)
        gfx.pushContext(fadedImage)
            self.snapshot:drawFaded(0, 0, snapshotAnimatorValue, gfx.image.kDitherTypeBayer8x8)
        gfx.popContext()
        self:setImage(fadedImage)

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
        end
    end
end