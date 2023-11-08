

require("data.tipoftheday")



selectedSprite = 0
mouseSelected = false
timeSinceSelected = 0
currentFrame = 1
currentSprites = {}
currentSpriteButtons = {}
frameButtons = {}
currentAnim = "default"


---------------------
-- Background Grid --
---------------------

gridLength = 2048
gridHeight = 2048

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
filePanel:SetSize(32, 48)

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

local saveButtonFile = loveframes.Create("button", filePanel)
saveButtonFile:SetSize(40, 16)
saveButtonFile:SetPos(0, 32, false)
saveButtonFile:SetText("Save")
saveButtonFile.OnClick = function(obj, x, y)
    local save = json.encode(cluster)
    if love.system.getOS() == "OS X" then
      makeErrorWindow(40, "OS X Moment:tm:", "You get the drill.\nMac system, copying JSON to clipboard,\nsave in a file elsewhere.", false, true)
      love.system.setClipboardText(save)
    else
      fssave:saveDialog(loveframes)
    end
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

function getSprite(id)
  return cluster[currentAnim].frames[currentFrame].sprites[id]
end


function genSprites()

  for i=#currentSprites,1,-1 do
    currentSprites[i]:Remove()
    debugConsole("Removed Sprite")
  end
  currentSprites = {}

  for i=1,#cluster[currentAnim].frames[currentFrame].sprites do

    local sprite = getSprite(i)
    --debugConsole(sprite.image)

    currentSprites[i] = loveframes.Create("image")
    currentSprites[i].sprite = sprite
    currentSprites[i].spriteID = sprite.id
    currentSprites[i].localID = i
    currentSprites[i]:SetImage("sprites/"..sprite.image..".png")
    currentSprites[i]:SetState("project")
    currentSprites[i]:SetPos(-(cameraX+(gridLength/2)), -(cameraY+(gridHeight/2)))
    currentSprites[i].Update = function(obj)

      if type(obj.sprite.x) == "number" and type(obj.sprite.y) == "number" then
        obj:SetPos(obj.sprite.x+(gridLength/2)-(obj:GetImage():getWidth()/2)-cameraX, obj.sprite.y+(gridHeight/2)-(obj:GetImage():getHeight()/2)-cameraY)
      elseif type(obj.sprite.x) == "string" or type(obj.sprite.y) == "string" then
        if obj.sprite.x:match("^%-?%d+$") then
          obj:SetPos(tonumber(obj.sprite.x)+(gridLength/2)-(obj:GetImage():getWidth()/2)-cameraX, tonumber(obj.sprite.y)+(gridHeight/2)-(obj:GetImage():getHeight()/2)-cameraY)
        elseif currentFrame > 0 then

        else
          obj:SetPos((gridLength/2)-(obj:GetImage():getWidth()/2)-cameraX, (gridHeight/2)-(obj:GetImage():getHeight()/2)-cameraY)
        end
      end



    end

  end

end



function drawSelection()
  if selectedSprite ~= 0 then
    local obj = currentSprites[selectedSprite]
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("line", obj:GetX()-8-timeSinceSelected, obj:GetY()-8-timeSinceSelected, (obj:GetImage():getWidth()*obj:GetScaleX())+16+(timeSinceSelected*2), (obj:GetImage():getHeight()*obj:GetScaleY())+16+(timeSinceSelected*2))
  end
  if timeSinceSelected > 0 then timeSinceSelected = timeSinceSelected-16 end
end

function moveSpritesPressed(key)
  if selectedSprite ~= 0 and not (love.keyboard.isDown('lshift') or love.keyboard.isDown('rshift')) then
    local currentSelected = currentSprites[selectedSprite]
    if key == "w" then
      currentSelected.sprite.y = math.floor(currentSelected.sprite.y/gridSubdiv)*gridSubdiv - gridSubdiv
    elseif key == "a" then
      currentSelected.sprite.x = math.floor(currentSelected.sprite.x/gridSubdiv)*gridSubdiv - gridSubdiv
    elseif key == "s" then
      currentSelected.sprite.y = math.floor(currentSelected.sprite.y/gridSubdiv)*gridSubdiv + gridSubdiv
    elseif key == "d" then
      currentSelected.sprite.x = math.floor(currentSelected.sprite.x/gridSubdiv)*gridSubdiv + gridSubdiv
    end
  end
end

function moveSpritesHeld()
  if selectedSprite ~= 0 and (love.keyboard.isDown('lshift') or love.keyboard.isDown('rshift')) then
    local currentSelected = currentSprites[selectedSprite]
    if love.keyboard.isDown('w') then
      currentSelected.sprite.y = currentSelected.sprite.y - 1
    elseif love.keyboard.isDown('a') then
      currentSelected.sprite.x = currentSelected.sprite.x - 1
    elseif love.keyboard.isDown('s') then
      currentSelected.sprite.y = currentSelected.sprite.y + 1
    elseif love.keyboard.isDown('d') then
      currentSelected.sprite.x = currentSelected.sprite.x + 1
    end

  end
end

function spritesMouse()
  if love.mouse.isDown(1) then
    if love.keyboard.isDown('lshift') or love.keyboard.isDown('rshift') then
      -- Shift
      if selectedSprite ~= 0 then
        local currentSelected = currentSprites[selectedSprite]
        currentSelected.sprite.x = (cameraX-(gridLength/2)) + love.mouse.getX()
        currentSelected.sprite.y = (cameraY-(gridHeight/2)) + love.mouse.getY()
      end
    else
      -- No Shift (temporarily disabled)
      --selectedSprite = 0
      --if editSpriteWindow then
      --  editSpriteWindow:Remove()
      --  editSpriteWindow = nil
      --end
    end
  end
end



--------------------
-- Sprites Window --
--------------------

local spriteWindow = loveframes.Create("frame")
spriteWindow:SetState("project")
spriteWindow:SetName("Sprites")
spriteWindow:SetPos(love.graphics.getWidth()-64, 0)
spriteWindow:SetWidth(64)
spriteWindow:SetHeight(love.graphics.getHeight())
spriteWindow:SetDraggable(false)
spriteWindow:ShowCloseButton(false)

spriteWindow.generateList = function(obj)

  for i=#currentSpriteButtons,1,-1 do
    currentSpriteButtons[i]:Remove()
    debugConsole("Removed Sprite Button")
  end
  currentSpriteButtons = {}

  for i=1,#currentSprites do
    currentSpriteButtons[i] = loveframes.Create("button", spriteWindow)
    currentSpriteButtons[i]:SetHeight(16)
    currentSpriteButtons[i]:SetWidth(64)
    currentSpriteButtons[i]:SetPos(0, (i*16)+16)
    currentSpriteButtons[i].id = i
    currentSpriteButtons[i]:SetText(string.format("%03d", i))
    currentSpriteButtons[i].OnClick = function(obj, x, y)
        selectedSprite = obj.id
        timeSinceSelected = 64
        makeEditSpriteWindow()
    end
  end

  if addSpriteButton then
    addSpriteButton:Remove()
    addSpriteButton = nil
    debugConsole("Removed Add Sprite Button")
  end

  local addSpriteButton = loveframes.Create("button", spriteWindow)
  addSpriteButton:SetHeight(16)
  addSpriteButton:SetWidth(64)
  addSpriteButton:SetPos(0, (#currentSprites*16)+32)
  addSpriteButton:SetText("+")
  addSpriteButton.OnClick = function(obj, x, y)
    if #cluster[currentAnim].frames[currentFrame].sprites >= 999 then
      makeErrorWindow(999, "Really? Over 999?", "If you need more than 999 sprites,\nyou have a problem.")
    else
      cluster[currentAnim].frames[currentFrame].sprites[#cluster[currentAnim].frames[currentFrame].sprites+1] = {
        id = "testSprite",
        image = "spr_test",
        x = 0,
        y = 0,
        scalex = "noChange",
        scaley = "noChange",
        actions = {}
      }
      genSprites()
      spriteWindow:generateList()
    end
  end

end




------------------
-- Frame Window --
------------------

local frameWindow = loveframes.Create("frame")
frameWindow:SetState("project")
frameWindow:SetName("Frames")
frameWindow:SetPos(0, love.graphics.getHeight()-64)
frameWindow:SetWidth(love.graphics.getWidth()-64)
frameWindow:SetHeight(64)
frameWindow:SetDraggable(false)
frameWindow:ShowCloseButton(false)



function genFrames()

  for i=#frameButtons,1,-1 do
    frameButtons[i]:Remove()
    debugConsole("Removed Frame Button")
  end
  frameButtons = {}

  for i=1,#cluster[currentAnim].frames do

    frameButtons[i] = loveframes.Create("imagebutton", frameWindow)
    frameButtons[i].localID = i
    frameButtons[i]:SetText("")
    frameButtons[i]:SetPos(i*16, 32)
    frameButtons[i]:SetImage("graphics/frameEmpty.png")
    frameButtons[i]:SizeToImage()
    frameButtons[i].Update = function(obj)

      if #cluster[currentAnim].frames[obj.localID].sprites > 0 then
        if currentFrame == obj.localID then
          obj:SetImage("graphics/frameNormalSelected.png")
        else
          obj:SetImage("graphics/frameNormal.png")
        end
      else
        if currentFrame == obj.localID then
          obj:SetImage("graphics/frameEmptySelected.png")
        else
          obj:SetImage("graphics/frameEmpty.png")
        end
      end

    end
    frameButtons[i].OnClick = function(obj)
      currentFrame = obj.localID
      fullRegenSprites()
    end

  end

  if addFrameButton then
    addFrameButton:Remove()
    addFrameButton = nil
    debugConsole("Removed Add Frame Button")
  end

  addFrameButton = loveframes.Create("imagebutton", frameWindow)
  addFrameButton:SetText("")
  addFrameButton:SetPos((#cluster[currentAnim].frames+1)*16, 32)
  addFrameButton:SetImage("graphics/frameAdd.png")
  addFrameButton:SizeToImage()
  addFrameButton.OnClick = function(obj)
    cluster[currentAnim].frames[#cluster[currentAnim].frames+1] = makeNewFrame()
    addFrameButton:SetPos((#cluster[currentAnim].frames+1)*16, 32)
    currentFrame = #cluster[currentAnim].frames
    regenProject()
  end

end

function makeNewFrame()
  local tempTable = { -- new frame
    sprites = {
    },
  }
  return tempTable
end




------------------------
-- Edit Sprite Window --
------------------------

function makeEditSpriteWindow()

  if editSpriteWindow then
    editSpriteWindow:Remove()
  end

  editSpriteWindow = loveframes.Create("frame")
  editSpriteWindow:SetState("project")
  editSpriteWindow:SetPos(64, 64)
  editSpriteWindow:SetName("Edit Selected Sprite")
  editSpriteWindow:SetWidth(256)
  editSpriteWindow:SetHeight(256)

  editSpriteWindow.sprite = cluster[currentAnim].frames[currentFrame].sprites[selectedSprite]

  local xInput = loveframes.Create("textinput", editSpriteWindow)
  xInput:SetPos(64, 32)
  xInput:SetWidth(64)
  xInput:SetText(tostring(cluster[currentAnim].frames[currentFrame].sprites[selectedSprite].x))
  xInput.Update = function(obj)
    xInput:SetText(tostring(cluster[currentAnim].frames[currentFrame].sprites[selectedSprite].x))
  end
  xInput.UpdateSprite = function(obj, text)
    if text == "u" then
      obj:GetBaseParent().sprite.x = 0
    elseif text:match("^%-?%d+$") then
      obj:GetBaseParent().sprite.x = tonumber(obj:GetText())
    else
      obj:GetBaseParent().sprite.x = 0
    end
  end
  xInput.OnEnter = function(obj, text)
    xInput:UpdateSprite(text)
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

local trashySays = loveframes.Create("image", tipWindow)
trashySays:SetImage("graphics/trashySays.png")
trashySays:SetPos(0, 24)

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


-------------
-- Helpers --
-------------

function regenProject()
  genFrames()
  genSprites()
  spriteWindow:generateList()
end

function fullRegenSprites()
  genSprites()
  spriteWindow:generateList()
end


debugConsole("project.lua Loaded")
