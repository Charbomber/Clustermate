

require("data.tipoftheday")



----------------
-- Background --
----------------
-- ...Does this even need a big comment like this?
local bg = loveframes.Create("image")
bg:SetState("project")
bg:SetImage("graphics/tempGrid.png")
bg:SetPos(0, 0)
bg:SetSize(love.graphics.getDimensions())




-------------
-- Toolbar --
-------------

local inToolbar = false

-- (Dropdowns)
local filePanel = loveframes.Create("panel")
filePanel:SetState("project")
filePanel:SetSize(32, 32)

local newButtonFile = loveframes.Create("button", filePanel)
newButtonFile:SetSize(40, 16)
newButtonFile:SetPos(0, 0, false)
newButtonFile:SetText("New")
newButtonFile.OnClick = function(obj, x, y)
    --loveframes.SetState("project")
end

local loadButtonFile = loveframes.Create("button", filePanel)
loadButtonFile:SetSize(40, 16)
loadButtonFile:SetPos(0, 16, false)
loadButtonFile:SetText("Load")
loadButtonFile.OnClick = function(obj, x, y)
    --loveframes.SetState("project")
end







-- actual toolbar
local toolbar = {}
toolbar[1] = loveframes.Create("collapsiblecategory")
toolbar[1]:SetState("project")
toolbar[1]:SetPos(0, 0)
toolbar[1]:SetSize(48, 32)
toolbar[1]:SetText("File")
toolbar[1]:SetObject(filePanel)

toolbar[1].OnMouseExit = function(obj)
  if love.getMouseX() < obj.x then
    obj:setOpen(false)
  end
  if love.getMouseX() > obj.x + obj.y then
    obj:setOpen(false)
    if love.getMouseY() < 32 then
      toolbar[2]:setOpen(true)
    end
  end

end
toolbar[1].OnOpenedClosed = function(obj)
  if obj:GetOpen() then
    -- opened
    inToolbar = true
  else
    -- closed
    inToolbar = false
  end
end




















--------------------
-- Tip Of The Day --
--------------------
local tipWindow = loveframes.Create("frame")
tipWindow:SetState("project")
tipWindow:SetName("Tip of The Day!")
tipWindow:CenterWithinArea(0, 0, love.graphics.getDimensions())
tipWindow:SetWidth(256)
tipWindow:SetHeight(256)

local tipText = loveframes.Create("text", tipWindow)
tipText:SetMaxWidth(200)
tipText:SetText(TipOfDay())
tipText:CenterX()
tipText:SetY(176)

local tipConfirm = loveframes.Create("button", tipWindow)
tipConfirm:SetWidth(200)
tipConfirm:CenterX()
tipConfirm:SetY(224)
tipConfirm:SetText("Got it!")
tipConfirm.OnClick = function(obj, x, y)
    tipWindow:Remove()
end
