
----------------
-- Da Console --
----------------


consoleString = ""


function stringConsole()
  local finalString = ""
  local starter = 1
  if #console > 32 then
    starter = #console-32
  end

  for i=#console,starter,-1 do
    finalString = finalString..console[i]
    if i > starter then
      finalString = finalString.."\n"
    end
  end

  return finalString
end

function consoleDraw()

  if loveframes.GetState() == "console" then
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.print("Clustermate v"..VERSION.." (Version "..VERSION_TITLE..") Console:", 16, 16)
    love.graphics.print(stringConsole(), 0, 64)
  end

end

--function love.textinput(text)

--end
