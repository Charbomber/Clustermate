

require("data.tipoftheday")



selectedSprite = 0
currentFrame = 0
currentSprites = {}
currentAnim = "default"


---------------------
-- Background Grid --
---------------------

local gridLength = 2048
local gridHeight = 2048

gridSubdiv = 32

cameraX = (gridLength/2)-(love.graphics.getWidth()/2)
cameraY = (gridHeight/2)-(love.graphics.getHeight()/2)
camSpeed = 16


local bgCanvas = love.graphics.newCanvas(gridLength, gridHeight)
love.graphics.setCanvas(bgCanvas)
-- Vertical Lines
for i=0,gridLength/gridSubdiv do
  if i == (gridLength/gridSubdiv)/2 then
    love.graphics.setColor(0, 0, 1, 1)
  else
    love.graphics.setColor(0, 0, 0.5, 1)
  end
  love.graphics.line(i*gridSubdiv, 0, i*gridSubdiv, gridHeight)
end
-- Horizontal Lines
for i=0,gridHeight/gridSubdiv do
  if i == (gridHeight/gridSubdiv)/2 then
    love.graphics.setColor(0, 0, 1, 1)
  else
    love.graphics.setColor(0, 0, 0.5, 1)
  end
  love.graphics.line(0, i*gridSubdiv, gridLength, i*gridSubdiv)
end
love.graphics.setCanvas()

bg = loveframes.Create("image")
bg:SetImage(bgCanvas)
bg:SetState("project")
bg:SetPos(-(cameraX+(gridLength/2)), -(cameraY+(gridHeight/2)))
bg.Update = function(obj)
  obj:SetPos(-cameraX, -cameraY)
end

bg.regenCanvas = function(obj)
  local bgCanvas = love.graphics.newCanvas(gridLength, gridHeight)
  love.graphics.setCanvas(bgCanvas)
  -- Vertical Lines
  for i=0,gridLength/gridSubdiv do
    if i == (gridLength/gridSubdiv)/2 then
      love.graphics.setColor(0, 0, 1, 1)
    else
      love.graphics.setColor(0, 0, 0.5, 1)
    end
    love.graphics.line(i*gridSubdiv, 0, i*gridSubdiv, gridHeight)
  end
  -- Horizontal Lines
  for i=0,gridHeight/gridSubdiv do
    if i == (gridHeight/gridSubdiv)/2 then
      love.graphics.setColor(0, 0, 1, 1)
    else
      love.graphics.setColor(0, 0, 0.5, 1)
    end
    love.graphics.line(0, i*gridSubdiv, gridLength, i*gridSubdiv)
  end
  love.graphics.setCanvas()

  bg:SetImage(bgCanvas)
end



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
  if love.mouse.getX() < obj.x then
    obj:SetOpen(false)
  end
  if love.mouse.getX() > obj.x + obj.width then
    obj:SetOpen(false)
    if love.mouse.getY() < 32 then
      --toolbar[2]:SetOpen(true)
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








----------------
-- Da Sprites --
----------------

function genSprites()

  for i=#currentSprites,1,-1 do
    currentSprites[i]:Remove()
  end
  currentSprites = {}

  for i=1,#cluster[currentAnim].frames do

    local sprite = cluster[currentAnim].frames[currentFrame]
    print(sprite)

    currentSprites[i] = loveframes.Create("image")
    currentSprites[i]:SetImage(sprite.image)
    currentSprites[i]:SetState("project")
    --currentSprites[i]:SetPos(-(cameraX+(gridLength/2)), -(cameraY+(gridHeight/2)))
    currentSprites[i].Update = function(obj)
      obj:SetPos(256, 256)
    end
  end

end
--genSprites()




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
