-- ______ _____   _______ _______ _______ _______ ______ _______ _______ _______ _______
--|      |     |_|   |   |     __|_     _|    ___|   __ \   |   |   _   |_     _|    ___|
--|   ---|       |   |   |__     | |   | |    ___|      <       |       | |   | |    ___|
--|______|_______|_______|_______| |___| |_______|___|__|__|_|__|___|___| |___| |_______|

-- The animation editing tool for games in the CF Story series


function love.load()

  math.randomseed(os.time())

  loveframes = require("libs.loveframes")
  loveframes.SetState("start")

  json = require("libs.json")


  require("reqs")

  -- The whole current cluster. AKA the project. This contains every animation.
  cluster = { -- There's a reason it's called a "cluster".
    ["default"] = { -- Default animation
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
              actions = {["scaleIncreaseOverTime"] = 2}
            }
          },
        },

        { -- frame 2
          sprites = {
            {
              id = "testSprite",
              image = "spr_test",
              x = 50,
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
              x = -50,
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
              actions = {["scaleIncreaseOverTime"] = 0}
            }
          },
        },

      },
    },
  }

end





function love.update(dt)

    loveframes.update(dt)

    if love.keyboard.isDown('lctrl') and love.keyboard.isDown('escape') then
      -- whoopsies
      love.event.quit()
    end

    if love.keyboard.isDown('lctrl') and love.keyboard.isDown('f') then
      love.window.setFullscreen(not love.window.getFullscreen())
    end

end

function love.draw()

    loveframes.draw()

end

function love.mousepressed(x, y, button)

    loveframes.mousepressed(x, y, button)

end

function love.mousereleased(x, y, button)

    loveframes.mousereleased(x, y, button)

end

function love.keypressed(key, scancode, isrepeat)

    loveframes.keypressed(key, isrepeat)

end

function love.keyreleased(key)

    loveframes.keyreleased(key)

end

function love.textinput(text)

    loveframes.textinput(text)

end
