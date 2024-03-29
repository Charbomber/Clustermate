-- ______ _____   _______ _______ _______ _______ ______ _______ _______ _______ _______
--|      |     |_|   |   |     __|_     _|    ___|   __ \   |   |   _   |_     _|    ___|
--|   ---|       |   |   |__     | |   | |    ___|      <       |       | |   | |    ___|
--|______|_______|_______|_______| |___| |_______|___|__|__|_|__|___|___| |___| |_______|

-- The animation editing tool for games in the CF Story series

-- The whole current cluster. AKA the project. This contains every animation.
cluster = { -- There's a reason it's called a "cluster".
  ---------------------------
  ---- Default animation ----
  ---------------------------
  {
    name = "New Animation",
    frames = {
      { -- frame 1
        sprites = {
          {
            id = "testSprite",
            image = "spr_test",
            -- image_base = "spr_test"
            -- image_after = "elemental"
            x = 0,
            y = 0,
            scalex = 1,
            scaley = 1,
            actions = {["scaleIncreaseOverTime"] = {2, 0, 0, 0, 0, 0, 0}}
          }
        },
      },

      { -- frame 2
        sprites = {
          {
            id = "testSprite",
            image = "spr_test",
            x = 64,
            y = 0,
            scalex = "noChange",
            scaley = "noChange",
            actions = {}
          }
        },
      },

      { -- frame 3
        sprites = {
          {
            id = "testSprite",
            image = "spr_test",
            x = -64,
            y = 0,
            scalex = "noChange",
            scaley = "noChange",
            actions = {}
          }
        },
      },

      { -- frame 4
        sprites = {
          {
            id = "testSprite",
            image = "spr_test",
            x = 0,
            y = 0,
            scalex = "noChange",
            scaley = "noChange",
            actions = {["scaleIncreaseOverTime"] = {0, 0, 0, 0, 0, 0, 0}}
          }
        },
      },

    },
  },
}

console = {}

function debugConsole(message)
  console[#console+1] = message
end

function love.load()

  -- [VERSION] --
  VERSION = "0.0.1"
  VERSION_TITLE = "Nesh"
  -- [LIBS] --
  loveframes = require("libs.loveframes")
  loveframes.SetState("start")
  if love.system.getOS() == "OS X" then
    debugConsole("Cannot Load LoveFS (ffs)")
  else
    require 'libs/lovefs/lovefs'
    require 'libs/lovefs/loveframesDialog'
    fsload = lovefs()
  	fssave = lovefs()
  end
  json = require("libs.json")

  debugConsole("Clustermate Init")

  love.graphics.setBackgroundColor(0.1, 0.1, 0.1, 1)

  require("reqs")

  --updateCallbacks = {}

  --genSprites()

  local savedState = "start"
end

function love.update(dt)

    loveframes.update(dt)


    --for i=0,#updateCallbacks do
    --  updateCallbacks[i]()
    --end

    if loveframes.GetState() == "project" then
      --- Project Update ---
      -- Cam Movement
      if love.keyboard.isDown('up') then
        cameraY = cameraY - camSpeed
      end
      if love.keyboard.isDown('down') then
        cameraY = cameraY + camSpeed
      end
      if love.keyboard.isDown('left') then
        cameraX = cameraX - camSpeed
      end
      if love.keyboard.isDown('right') then
        cameraX = cameraX + camSpeed
      end

      moveSpritesHeld()
      spritesMouse()

    end

end

function love.draw()

    loveframes.draw()

    consoleDraw()
    drawSelection()

end

function love.mousepressed(x, y, button)

    loveframes.mousepressed(x, y, button)

end

function love.mousereleased(x, y, button)

    loveframes.mousereleased(x, y, button)

end

function love.keypressed(key, scancode, isrepeat)

    loveframes.keypressed(key, isrepeat)
    if loveframes.GetState() == "project" then
      -- Increase Cam Speed
      if key == '=' then
        if camSpeed < 64 then
          camSpeed = camSpeed + 8
        end
      end
      -- Decrease Cam Speed
      if key == '-' then
        if camSpeed > 8 then
          camSpeed = camSpeed - 8
        end
      end
      -- Reset Cam Speed
      if key == '0' then
        camSpeed = 16
      end

      -- Increase Grid Subdivs
      if key == ']' then
        if gridSubdiv < 256 then
          gridSubdiv = gridSubdiv * 2
          bg:regenCanvas()
        end
      end
      -- Decrease Grid Subdivs
      if key == '[' then
        if gridSubdiv > 8 then
          gridSubdiv = gridSubdiv / 2
          bg:regenCanvas()
        end
      end
      -- Reset Grid Subdivs
      if key == '\\' then
        gridSubdiv = 32
        bg:regenCanvas()
      end

      -- Debug Cam Return
      if love.keyboard.isDown('lctrl') and key == 'r' then
        cameraX = (gridLength/2)-(love.graphics.getWidth()/2)
        cameraY = (gridHeight/2)-(love.graphics.getHeight()/2)
      end

      moveSpritesPressed(key)

    end


    if love.keyboard.isDown('lctrl') and key == 'escape' then
      -- whoopsies
      love.event.quit()
    end

    if love.keyboard.isDown('lctrl') and key == 'f' then
      love.window.setFullscreen(not love.window.getFullscreen())
    end

    if love.keyboard.isDown('lctrl') and key == 'c' then
      if loveframes.GetState() ~= "console" then
        savedState = loveframes.GetState()
        loveframes.SetState("console")
      else
        loveframes.SetState(savedState)
      end
      if savedState == "console" then
        savedState = "project"
      end
    end

    -- this is dumb
    if loveframes.GetState() == "console" then
      if key == "backspace" then
        consoleString = consoleString:sub(1, -2)
      end
      if key == "return" then
        processConsole()
      end
      if love.keyboard.isDown('lctrl') and key == 'v' then
        consoleString = consoleString..love.system.getClipboardText()
      end
    end

end

function love.textinput(text)
  loveframes.textinput(text)
  if loveframes.GetState() == "console" and not love.keyboard.isDown('lctrl') then

    consoleString = consoleString..text

  end
end

function love.keyreleased(key)

    loveframes.keyreleased(key)

end
