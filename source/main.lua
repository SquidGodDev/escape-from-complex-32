--[[
Hey Giant Squid patrons! Thanks for supporting me! I want to preface this by
noting that I think this is the best project architecture I've made so far. I
think it's pretty well organized, so I'm happy to be sharing it with you!

Each file has a description at the top of what it does, but I'll lay out the 
project structure first with short descriptions of each file.

    Scripts/
        Game/
            background/
                gameBackground - Manages the infinitly scrolling walls and it's collisions
            obstacles/
                floorSpikes.lua - The spikes that catch the player if they fall too far down
                gate.lua - The obstacle for the platform with the gap
                movingSpike.lua - The moving spike obstacle (extends spike.lua)
                obstacle.lua - The parent obstacle class which all obstacles extend from
                obstacleRect.lua - An invisible helper obstacle I used for gate.lua
                obstacleSpawner.lua - Manages the spawning of obstacles as the player moves up
                spike.lua - The stationary spike obstacle
            player/
                laserBeam.lua - The beam that shoots out from the player (it's purely cosmetic)
                laserGun.lua - The rotating laser gun
                laserTimer.lua - The currently unused timer to shoot the laser
                player.lua - The player (manages collisions, gravity, input, and more)
            ui/
                heightDialog.lua - UI element that displays the height and max height in resultsDisplay.lua
                heightDisplay.lua - UI element that appears while playing that displays your current height
                resultsDisplay.lua - UI element that handles displaying the result and fading the background
            gameScene.lua - Used by sceneManager.lua and loads everything related to the game scene
        Title/
            titleScene.lua - Used by sceneManager.lua and loads everything related to the title scene
        globals.lua - A helper file that contains functions/variables used across the game
        sceneManager.lua - Class that handles scene transitions
]]--

-- For this main file, my philosphy is that I wanted to keep it really clean. I only load
-- the title scene, initialize the scene manager, and load the saved max height data. There
-- were some other things here, but I threw them into globals.lua in much the same way as you
-- stuff things into the closet to hide it :D
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "scripts/globals"

import "scripts/sceneManager"
import "scripts/game/gameScene"
import "scripts/title/titleScene"

local pd <const> = playdate
local gfx <const> = pd.graphics

-- I just kept the max height as a global variable, since it
-- was simpler that way. I use globals very very sparingly, as
-- they can easily make your code really messy. LOAD_GAME_DATA
-- is located in globals.lua
MAX_HEIGHT = 0
LOAD_GAME_DATA()

-- I initalize the scene manager here, but there's actually only
-- one scene transition in the entire game which is from the title
-- screen to the game. You never go back to the title, so eventually
-- this scene manager is removed
SCENE_MANAGER = SceneManager()
-- Just initalizing the title screen
TitleScene()

function pd.update()
    gfx.sprite.update()
    pd.timer.updateTimers()
end

-- According to the documentation, these two functions are a good place
-- to store your data. GameWillTerminate gets called when you close the
-- game, and gameWillSleep gets called when the Playdate is low battery.
-- SAVE_GAME_DATA is located in globals.lua
function pd.gameWillTerminate()
    SAVE_GAME_DATA()
end

function pd.gameWillSleep()
    SAVE_GAME_DATA()
end