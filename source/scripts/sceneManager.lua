local pd <const> = playdate
local gfx <const> = playdate.graphics

class('SceneManager').extends(gfx.sprite)

function SceneManager:init()
    self.maskCircleRadius = 300

    self:setIgnoresDrawOffset(true)
    self:setCenter(0, 0)
    self:setZIndex(100)
    self.transitionTime = 700
    self.transitioningIn = false
end

function SceneManager:switchScene(scene)
    if self.transitioningIn then
        return
    end
    self.transitionAnimator = gfx.animator.new(self.transitionTime, self.maskCircleRadius, 0, pd.easingFunctions.outCubic)
    self.transitioningIn = true
    self.newScene = scene
    self:add()
end

function SceneManager:loadNewScene()
    gfx.sprite.removeAll()
    self:add()
    self.transitionAnimator = gfx.animator.new(self.transitionTime, 0, self.maskCircleRadius, pd.easingFunctions.inCubic)
    self.transitioningIn = false
    self.newScene()
end

function SceneManager:update()
    if self.transitionAnimator then
        local filledScreenRect = self:getFilledScreenRect()
        gfx.pushContext(filledScreenRect)
            local curRadius = self.transitionAnimator:currentValue()
            gfx.setColor(gfx.kColorClear)
            gfx.fillCircleAtPoint(200, 120, curRadius)
        gfx.popContext()
        self:setImage(filledScreenRect)
        if self.transitioningIn and self.transitionAnimator:ended() then
            self:loadNewScene()
        elseif self.transitionAnimator:ended() then
            self.transitionAnimator = nil
        end
    end
end

function SceneManager:getFilledScreenRect()
    local filledScreenRect = gfx.image.new(400, 240)
    gfx.pushContext(filledScreenRect)
        gfx.fillRect(0, 0, 400, 240)
    gfx.popContext()
    return filledScreenRect
end