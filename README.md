# Escape from Complex 32
Source code for my Playdate game "Escape from Complex 32, a vertically scrolling endless action game where you use the crank to control a giant laser to shoot yourself up and dodge obstacles. You can get the game on [Itch IO](https://squidgod.itch.io/escape-from-complex-32).

<img src="https://github.com/user-attachments/assets/30b803e0-a680-4aa5-b7d4-38edb592a7ac" width="400" height="240"/>
<img src="https://github.com/user-attachments/assets/b2f3e025-0d3a-4957-a9b4-9f2304fe32d3" width="400" height="240"/>
<img src="https://github.com/user-attachments/assets/be7ee96e-ee3d-401e-a75c-7c936aafff1e" width="400" height="240"/>
<img src="https://github.com/user-attachments/assets/e03414e6-a338-41b5-b33c-bb5a68d6569e" width="400" height="240"/>

## Project Structure
- `scripts/`
  - `game/`
    - `background/`
      - `gameBackground.lua` - Manages the infinitely scrolling walls and it's collisions
    - `obstacles/`
      - `floorSpikes.lua` - The spikes that catch the player if they fall too far down
      - `gate.lua` - The obstacle for the platform with the gap
      - `movingSpike.lua` - The moving spike obstacle (extends spike.lua)
      - `obstacle.lua` - The parent obstacle class which all obstacles extend from
      - `obstacleRect.lua` - An invisible helper obstacle I used for gate.lua
      - `obstacleSpawner.lua` - Manages the spawning of obstacles as the player moves up
      - `spike.lua` - The stationary spike obstacle
    - `player/`
      - `laserBeam.lua` - The beam that shoots out from the player (it's purely cosmetic)
      - `laserGun.lua` - The rotating laser gun
      - `laserTimer.lua` - The currently unused timer to shoot the laser
      - `player.lua` - The player (manages collisions, gravity, input, and more)
    - `ui/`
      - `heightDialog.lua` - UI element that displays the height and max height in resultsDisplay.lua
      - `heightDisplay.lua` - UI element that appears while playing that displays your current height
      - `resultsDisplay.lua` - UI element that handles displaying the result and fading the background
    - `gameScene.lua` - Used by sceneManager.lua and loads everything related to the game scene
  - `title/`
    - `titleScene.lua` - Used by sceneManager.lua and loads everything related to the title scene
  - `globals.lua` - A helper file that contains functions/variables used across the game
  - `sceneManager.lua` - Class that handles scene transitions

## License
All code is licensed under the terms of the MIT license.
