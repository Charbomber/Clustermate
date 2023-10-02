

local startGUI = {}

startGUI[1] = loveframes.Create("button")

startGUI[1]:SetState("start")
startGUI[1]:SetWidth(256)
startGUI[1]:SetPos(32, 128, false)
startGUI[1]:SetText("New Cluster")
startGUI[1].OnClick = function(obj, x, y)
    obj:SetText("Doesn't work yet lol")
end


startGUI[2] = loveframes.Create("button")

startGUI[2]:SetState("start")
startGUI[2]:SetWidth(256)
startGUI[2]:SetPos(32, 128+32, false)
startGUI[2]:SetText("Load Cluster")
startGUI[2].OnClick = function(obj, x, y)
    obj:SetText("Doesn't work yet lol")
end
