
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
    love.graphics.print(consoleString.."⎕", 0, 32)
  end

end

function processConsole()

  debugConsole(consoleString)
  if consoleString:find("^dcr") then
    debugConsole(loadstring("return "..consoleString:sub(4))())
  elseif consoleString:find("^dcs") then
    debugConsole(consoleString:sub(4))
  else
    try(loadstring(consoleString),
    function()
      debugConsole("Invalid Command: "..consoleString)
    end)

  end
  consoleString = ""

end
