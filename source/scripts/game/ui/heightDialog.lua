-- The UI popup that slides down when the results are
-- being displayed to show the current height and max
-- height

local pd <const> = playdate
local gfx <const> = pd.graphics

class('HeightDialog').extends(gfx.sprite)

function HeightDialog:init(height)
    self.dialogWidth = 240
    self.dialogHeight = 140
    self.leftPadding = 30

    -- It's good practice to have these "magic numbers"
    -- be stored into a variable with a name for better
    -- readability
    self.borderWidth = 3
    self.cornerRadius = 3

    -- Making sure this sits on top of everything else
    self:setZIndex(600)

    local dialogImage = gfx.image.new(self.dialogWidth, self.dialogHeight)
    gfx.pushContext(dialogImage)
        gfx.setColor(gfx.kColorBlack)
        gfx.fillRoundRect(0, 0, self.dialogWidth, self.dialogHeight, self.cornerRadius)
        gfx.setColor(gfx.kColorWhite)
        gfx.fillRoundRect(self.borderWidth, self.borderWidth, self.dialogWidth - self.borderWidth * 2, self.dialogHeight  - self.borderWidth * 2, self.cornerRadius)
        gfx.setColor(gfx.kColorBlack)
        local heightInMeters = GET_HEIGHT_IN_METERS(height)
        local heightScoreText = "Height: " .. heightInMeters .. " m"
        local newHighScore = false
        -- Here, I check if the height we're at is greater than the current
        -- max height. Then, I make sure to update it
        if height > MAX_HEIGHT then
            MAX_HEIGHT = height
            newHighScore = true
        end
        local maxHeightInMeters = GET_HEIGHT_IN_METERS(MAX_HEIGHT)
        local maxHeightScoreText = "Max Height: " .. maxHeightInMeters .. " m"
        if newHighScore then
            maxHeightScoreText = maxHeightScoreText .. " - *NEW*"
        end
        gfx.drawTextAligned("*ESCAPE FAILED*", self.dialogWidth / 2, 10, kTextAlignment.center)
        gfx.drawText(heightScoreText, self.leftPadding, 45)
        gfx.drawText(maxHeightScoreText, self.leftPadding, 75)
        gfx.drawTextAligned("_Press_ *A* _to restart_", self.dialogWidth / 2, 110, kTextAlignment.center)
    gfx.popContext()
    self:setImage(dialogImage)

    self:moveTo(200, -self.dialogHeight / 2)
    self:add()
end