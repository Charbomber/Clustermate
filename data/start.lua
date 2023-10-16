
local newButtonStart = loveframes.Create("button")

newButtonStart:SetState("start")
newButtonStart:SetWidth(256)
newButtonStart:SetPos(32, 128, false)
newButtonStart:SetText("New Cluster")
newButtonStart.OnClick = function(obj, x, y)
    loveframes.SetState("project")
end


local loadButtonStart = loveframes.Create("button")

loadButtonStart:SetState("start")
loadButtonStart:SetWidth(256)
loadButtonStart:SetPos(32, 128+32, false)
loadButtonStart:SetText("Load Cluster")
loadButtonStart.OnClick = function(obj, x, y)
    dialogue = loadDialog(fs, {'JSON | *.json', 'All | *.*'})
    fs.selectedFile

    loveframes.SetState("project")
end


debugConsole("start.lua Loaded")
