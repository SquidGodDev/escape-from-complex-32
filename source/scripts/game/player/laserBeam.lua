-- Class that handles the laser beam. Note, this is actually
-- purely cosmetic. It doesn't have any behavior other than
-- looking super cool 😎

local pd <const> = playdate
local gfx <const> = pd.graphics

class('LaserBeam').extends(gfx.sprite)

-- We take in an x and y position to spawn from, which is
-- the tip of the laser gun given to us by the laser gun
-- class, along with the angle the gun is pointed at
function LaserBeam:init(x1, y1, angle)
    self.beamLength = 400
    self.beamWidth = 10
    self.beamDuration = 300
    self.angle = angle
    -- I have a timer starting at the beam width down to 0, using the
    -- outCubic easing function. So, the timer will ease from the beam
    -- width down to 0 which we can use for a nice animation
    self.beamTimer = pd.timer.new(self.beamDuration, self.beamWidth, 0, pd.easingFunctions.outCubic)
    -- When the timer is finished, we can make the beam remove itself
    self.beamTimer.timerEndedCallback = function()
        self:remove()
    end

    self:moveTo(x1, y1)
    self:add()
end

function LaserBeam:drawBeam()
    -- I'm using the drawLine function to draw the laser beam. However, the drawLine
    -- function takes two sets of coordinates - the starting position and the ending
    -- position. We only have the starting position, the angle, and how long we want
    -- the beam to be. What in the world can we do??!! Trigonometry, of course! If you
    -- remember the unit circle, we can use the properties of cosine and sine to get
    -- basically a unit vector in the direction of the angle, and the multiply that
    -- by the beamLength. I then round it up to get a clean number
    local x2 = math.ceil(math.cos(math.rad(self.angle - 90)) * self.beamLength)
    local y2 = math.ceil(math.sin(math.rad(self.angle - 90)) * self.beamLength)
    -- I'm creating an image double the size of the beam length, because I actually
    -- want to start drawing the beam from the center and draw out, so the image
    -- encompasses the metaphorical "unit circle"
    local beamImage = gfx.image.new(self.beamLength * 2, self.beamLength * 2)
    gfx.pushContext(beamImage)
        gfx.setLineCapStyle(gfx.kLineCapStyleRound)
        gfx.setLineWidth(self.beamWidth)
        gfx.drawLine(self.beamLength, self.beamLength, self.beamLength + x2, self.beamLength + y2)
    gfx.popContext()
    self:setImage(beamImage)
end

function LaserBeam:update()
    self:drawBeam()
    -- Updating the beam width along with the timer
    self.beamWidth = self.beamTimer.value
end