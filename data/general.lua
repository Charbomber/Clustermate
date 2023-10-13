------------------
-- Error Window --
------------------

function makeErrorWindow(error, title, message, buttons, sizeX, sizeY)

  if buttons == true then
    buttons = {
      {"Continue", function(obj, x, y) obj:GetBaseParent():Remove() end},
      {"Quit", function(obj, x, y) love.event.quit() end},
    }
  else
    buttons = buttons or {{"Okay.", function(obj, x, y) obj:GetBaseParent():Remove() end}}
  end
  local sizeX = sizeX or 384
  local sizeY = sizeY or 128

  local errorWindow = loveframes.Create("frame")
  errorWindow:SetState(loveframes.GetState())
  errorWindow:SetSize(sizeX, sizeY)
  errorWindow:SetName(title)
  errorWindow:Center()

  local errorMessage = loveframes.Create("text", errorWindow)
  errorMessage:SetText("ERROR "..tostring(error).."\n"..message)
  errorMessage:CenterX()
  errorMessage:SetY(32)

  for i=1,#buttons do
    local errorButton = loveframes.Create("button", errorWindow)
    errorButton:SetSize(64, 16)
    errorButton:SetPos(i*64, errorWindow:GetHeight()-32, false)
    errorButton:SetText(buttons[i][1])
    errorButton.OnClick = buttons[i][2]
  end

end


makeErrorWindow(-15, "Test Lol", "This error is fake! It's just a test :]")
