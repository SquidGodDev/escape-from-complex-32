local pd <const> = playdate
local gfx <const> = pd.graphics

class('LaserBeam').extends(gfx.sprite)

function LaserBeam:init(x1, y1, angle)
    self.beamLength = 200
    self.beamWidth = 10
    self.beamDuration = 300
    self.angle = angle
    self.beamTimer = pd.timer.new(self.beamDuration, self.beamWidth, 0, pd.easingFunctions.outCubic)
    self.beamTimer.timerEndedCallback = function()
        self:remove()
    end

    self:moveTo(x1, y1)
    self:add()
end

function LaserBeam:drawBeam()
    print(self.angle)
    local x2 = math.ceil(math.cos(math.rad(self.angle - 90)) * self.beamLength)
    local y2 = math.ceil(math.sin(math.rad(self.angle - 90)) * self.beamLength)
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
    self.beamWidth = self.beamTimer.value
end