-- The laser timer class I was using to shoot the
-- laser on a timer. It's not used anymore since
-- I switched the input method, but I might add
-- an option to use it for accessibility

local pd <const> = playdate
local gfx <const> = pd.graphics

class('LaserTimer').extends(gfx.sprite)

function LaserTimer:init(laserGunInstance)
    self.laserGun = laserGunInstance
    self:setIgnoresDrawOffset(true)
    self:setZIndex(100)

    self.timerWidth = 60
    self.timerHeight = 10
    self.lineWidth = 2
    self.cornerRadius = 2

    local timerMaxTime = 30
    self.timerMax = timerMaxTime
    self.timerValue = timerMaxTime
    self:setCenter(0, 0)
    self:moveTo(400 - self.timerWidth - 25, 10)
    self:add()
end

function LaserTimer:updateDisplay()
    local displayImage = gfx.image.new(self.timerWidth + self.cornerRadius * 2, self.timerHeight + self.cornerRadius * 2)
    gfx.pushContext(displayImage)
        gfx.setLineWidth(self.lineWidth)
        gfx.setColor(gfx.kColorWhite)
        gfx.fillRoundRect(self.cornerRadius, self.cornerRadius, self.timerWidth, self.timerHeight, self.cornerRadius)
        gfx.setColor(gfx.kColorBlack)
        gfx.drawRoundRect(self.cornerRadius, self.cornerRadius, self.timerWidth, self.timerHeight, self.cornerRadius)
        local timerPercent = self.timerValue/self.timerMax
        gfx.fillRoundRect(self.cornerRadius, self.cornerRadius, self.timerWidth * timerPercent, self.timerHeight, self.cornerRadius)
    gfx.popContext()
    self:setImage(displayImage)
end

function LaserTimer:update()
    self:updateDisplay()
    self.timerValue -= 1
    if self.timerValue <= 0 then
        self.timerValue = self.timerMax
        self.laserGun:shoot()
    end
end