
local newButton = loveframes.Create("button")

newButton:SetState("start")
newButton:SetWidth(256)
newButton:SetPos(32, 128, false)
newButton:SetText("New Cluster")
newButton.OnClick = function(obj, x, y)
    obj:SetText("Doesn't work yet lol")
end


local loadButton = loveframes.Create("button")

loadButton:SetState("start")
loadButton:SetWidth(256)
loadButton:SetPos(32, 128+32, false)
loadButton:SetText("Load Cluster")
loadButton.OnClick = function(obj, x, y)
    obj:SetText("Doesn't work yet lol")
end
