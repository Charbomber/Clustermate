-- ______ _____   _______ _______ _______ _______ ______ _______ _______ _______ _______
--|      |     |_|   |   |     __|_     _|    ___|   __ \   |   |   _   |_     _|    ___|
--|   ---|       |   |   |__     | |   | |    ___|      <       |       | |   | |    ___|
--|______|_______|_______|_______| |___| |_______|___|__|__|_|__|___|___| |___| |_______|

-- The animation editing tool for games in the CF Story series


function love.load()

  loveframes = require("libs.loveframes")
  loveframes.SetState("start")

end





function love.update(dt)

    loveframes.update(dt)

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
