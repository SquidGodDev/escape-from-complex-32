-- This is my scene manager class. It's a sprite that draws the
-- transitioning out animation, the initalizes the next scene, and then
-- draws the transitioning in animation. Pretty slick. In this game,
-- I only use this once, and eventually it gets removed. One quirk
-- of this approach is that I assume that everything related to each scene
-- is stored in a sprite, so to clear everything from the last scene, it
-- uses gfx.sprite.removeAll(). That might not be the case in your game.
-- It is also a sprite itself, so if you use removeAll somewhere else, the
-- scene manager will also be removed.

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

    self.transitionInSound = pd.sound.sampleplayer.new("sounds/transitionIn")
    self.transitionOutSound = pd.sound.sampleplayer.new("sounds/transitionOut")
end

-- Since functions are first class in Lua, I take in a function as "scene" and
-- store it into self.newScene, expecting to call it later.
function SceneManager:switchScene(scene)
    -- This is to stop multiple scene transitions from happening at once (e.g. 
    -- if a button press switches the scene and someone spams the button)
    if self.transitioningIn then
        return
    end
    -- Using easing functions to make the animation smooth and satisfying
    self.transitionAnimator = gfx.animator.new(self.transitionTime, self.maskCircleRadius, 0, pd.easingFunctions.outCubic)
    self.transitioningIn = true
    self.transitionInSound:play()
    self.newScene = scene
    self:add()
end

function SceneManager:loadNewScene()
    -- As I mentioned before, I expect everything in a scene to be all stored in sprites, so
    -- removing all sprites effectively clears the last scene.
    gfx.sprite.removeAll()
    -- Since the scene manager itself is a sprite, it removes itself, so you can just add it back
    -- right after.
    self:add()
    -- Initalizing the animator with the start and end values reversed to have the opposite transition
    -- animation
    self.transitionAnimator = gfx.animator.new(self.transitionTime, 0, self.maskCircleRadius, pd.easingFunctions.inCubic)
    self.transitioningIn = false
    -- newScene should hold a function that initializes the next scene, so I just call it here
    self.newScene()
end

function SceneManager:update()
    if self.transitionAnimator then
        -- To draw the circle animation, I basically get a solid black rectangle
        -- the size of the screen. Then, I draw a clear circle with a radius equal
        -- to the animator value
        local filledScreenRect = self:getFilledScreenRect()
        gfx.pushContext(filledScreenRect)
            local curRadius = self.transitionAnimator:currentValue()
            gfx.setColor(gfx.kColorClear)
            gfx.fillCircleAtPoint(200, 120, curRadius)
        gfx.popContext()
        self:setImage(filledScreenRect)
        if self.transitioningIn and self.transitionAnimator:ended() then
            -- This is when the scene is being transitioned out of, with the
            -- circle closing in. Yeah, the naming convention is a little
            -- confusing. I load the new scene here, so basically when the
            -- circle has closed all the way
            self:loadNewScene()
            self.transitionOutSound:play()
        elseif self.transitionAnimator:ended() then
            -- This is when the entire scene transition animation has ended
            self.transitionAnimator = nil
        end
    end
end

-- A helper function to get an image the size of
-- the screen that's a filled black rectangle
function SceneManager:getFilledScreenRect()
    local filledScreenRect = gfx.image.new(400, 240)
    gfx.pushContext(filledScreenRect)
        gfx.fillRect(0, 0, 400, 240)
    gfx.popContext()
    return filledScreenRect
end