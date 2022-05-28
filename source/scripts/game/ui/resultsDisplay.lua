-- Handles fading the background and initializing the height
-- dialog

import "scripts/game/ui/heightDialog"

local pd <const> = playdate
local gfx <const> = pd.graphics

-- I was struggling a lot with the performance of the fading
-- since I was taking a snapshot of the last frame of the game
-- and dynamically dithering it. I tried using both drawBlurred
-- and drawFaded, and they're both using dithering algorithms
-- which are pretty computationally expensive. My fix was to
-- precompute some dithered rects and overlay them on top of the
-- snapshot. My hunch is this is how the Playdate system menu
-- handles it. This entire precaching happens at the very start of
-- the game before anything loads, since it's outside of the class
local fadedRects = {}
for i=0,55,5 do
    local fadedRect = gfx.image.new(400, 240)
    gfx.pushContext(fadedRect)
        local solidRect = gfx.image.new(400, 240, gfx.kColorBlack)
        -- I'm essentially drawing faded images from values 0 to 0.55, but
        -- indexing with integers because I was getting some weird floating
        -- point issues with the indexing. Because floating point is sometimes
        -- imprecise, it's better to start off with an integer and divide it to
        -- get your decimals, instead of starting off with a decimal and multiplying
        -- it to get the integers
        solidRect:drawFaded(0, 0, i / 100, gfx.image.kDitherTypeBayer8x8)
    gfx.popContext()
    -- I use the fade amount as a key and the image as the value, so with just
    -- the fade amount, I can request the corresponding faded image relatively
    -- quickly (dictionary value access is an O(1) operation, as opposed to dithering
    -- algorithms which are at the very minimum O(n), but probably a lot higher)
    fadedRects[i] = fadedRect
end

class('ResultsDisplay').extends(gfx.sprite)

function ResultsDisplay:init(gameScene, height, snapshot)
    self.gameScene = gameScene
    self.height = height
    -- I'm passing in a screeshot that we got from gfx.getDisplayImage(), which
    -- grabs the last frame displayed on the screen
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
        -- The animator is giving values between 0 and 50, but those can be decimal
        -- values. I'm rounding those values down to the nearest multiple of 5 here
        -- using floor division (//) which is equivalent to math.floor(a / b)
        local fadedImageIndex = ((snapshotAnimatorValue // 5) * 5)
        -- We can then grab the appropriate faded image using the fade value, then
        -- draw it on top of our snapshot image
        local fadedRect = fadedRects[fadedImageIndex]
        if fadedRect then
            local fadedImage = gfx.image.new(400, 240)
            gfx.pushContext(fadedImage)
                self.snapshot:draw(0, 0)
                fadedRect:draw(0,0)
            gfx.popContext()
            self:setImage(fadedImage)
        end

        -- We're handling easing the height dialog position here
        local dialogPosition = self.dialogAnimator:currentValue()
        self.heightDialog:moveTo(self.heightDialog.x, dialogPosition)

        if self.snapshotAnimator:ended() then
            self.animatingIn = false
        end
    elseif self.animatingOut then
        -- Animating the background and dialog to move down
        self:moveTo(0, self.moveTimer:currentValue())

        local dialogPosition = self.dialogAnimator:currentValue()
        self.heightDialog:moveTo(self.heightDialog.x, dialogPosition)

        if self.moveTimer:ended() then
            self:remove()
            self.heightDialog:remove()
        end
    else
        -- If we press A when the display entering animation finishes,
        -- we create new animators to move the dialog and display out
        -- of the way. We also restart the game as well
        if pd.buttonJustPressed(pd.kButtonA) then
            self.moveTimer = gfx.animator.new(self.animateOutDuration, 0, 200, pd.easingFunctions.inOutCubic)
            self.dialogAnimator = gfx.animator.new(self.animateOutDuration, 120, 320, pd.easingFunctions.inOutCubic)
            self.animatingOut = true
            self.gameScene:setupGame()
            self.whooshSound:play()
        end
    end
end