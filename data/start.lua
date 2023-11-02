
local newButtonStart = loveframes.Create("button")

newButtonStart:SetState("start")
newButtonStart:SetWidth(256)
newButtonStart:SetPos(32, 128, false)
newButtonStart:SetText("New Cluster")
newButtonStart.OnClick = function(obj, x, y)
    loveframes.SetState("project")
    regenProject()
end


local loadButtonStart = loveframes.Create("button")

loadButtonStart:SetState("start")
loadButtonStart:SetWidth(256)
loadButtonStart:SetPos(32, 128+32, false)
loadButtonStart:SetText("Load Cluster")
loadButtonStart.OnClick = function(obj, x, y)

    loveframes.SetState("project")

    if love.system.getOS() == "OS X" then
      makeErrorWindow(38, "OS X Moment:tm:", "It appears that you are on a Mac.\nA required library for file navigation does not work with Mac.\nThus: the program will just take the JSON from your clipboard.\nFuck you LoveFS.", false, true, 384, 160)

      try(
        function()
          cluster = json.decode(love.system.getClipboardText())
        end,
        function()
          makeErrorWindow(39, "JSON Can't Be Read", "JSON can't be read from clipboard.", true, false)
        end
      )
    else
      fsload:loadDialog(loveframes, nil, {'JSON | *.json', 'All | *.*'})
    end
    regenProject()
end


debugConsole("start.lua Loaded")
