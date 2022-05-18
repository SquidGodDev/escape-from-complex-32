import "scripts/game/player/laserBeam"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('LaserGun').extends(gfx.sprite)

function LaserGun:init(x, y, playerInstance)
    self.player = playerInstance

    self.laserGunWidth = 10
    self.laserGunLength = 25
    self:moveTo(x, y)
    self:add()

    self.drawPadding = 4
    self.curAngle = -1
    self.gunPointX = 0
    self.gunPointY = 0
    self.minAngle = 110
    self.maxAngle = 250
end

function LaserGun:update()
    local crankAngle = pd.getCrankPosition()
    -- if crankAngle <= self.minAngle then
    --     crankAngle = self.minAngle
    -- elseif crankAngle >= self.maxAngle then
    --     crankAngle = self.maxAngle
    -- end
    if crankAngle ~= self.curAngle then
        self.curAngle = crankAngle
        local x2, y2 = self:getLineAtAngle(crankAngle, self.laserGunLength)
        local laserGunImage = gfx.image.new(self.laserGunLength * 2 + self.drawPadding * 2, self.laserGunLength * 2 + self.drawPadding * 2)
        local x1 = self.laserGunLength + self.drawPadding
        local y1 = self.laserGunLength + self.drawPadding
        self.gunPointX = x2
        self.gunPointY = y2
        x2 += x1
        y2 += y1
        gfx.pushContext(laserGunImage)
            gfx.setLineCapStyle(gfx.kLineCapStyleRound)
            gfx.setLineWidth(self.laserGunWidth)
            gfx.drawLine(x1, y1, x2, y2)
        gfx.popContext()
        self:setImage(laserGunImage)
    end
end

function LaserGun:moveTo(x, y)
    LaserGun.super.moveTo(self, x, y)
    if self.laserBeam then
        self.laserBeam:moveTo(self.laserBeam.x, y + self.gunPointY)
    end
end

function LaserGun:shoot()
    local randLaserSound = math.random(0, 4)
    local laserSoundPath = "sounds/laser" .. randLaserSound
    local laserSound = pd.sound.sampleplayer.new(laserSoundPath)
    laserSound:play()
    self.player:launch(self.curAngle)
    self.laserBeam = LaserBeam(self.x, self.y, self.curAngle)
end

function LaserGun:getLineAtAngle(angle, length)
    local x2 = math.ceil(math.cos(math.rad(angle - 90)) * length)
    local y2 = math.ceil(math.sin(math.rad(angle - 90)) * length)
    return x2, y2
end