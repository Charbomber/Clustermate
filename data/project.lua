

require("data.tipoftheday")



selectedSprite = 0
mouseSelected = false
timeSinceSelected = 0
currentFrame = 1
currentSprites = {}
currentSpriteButtons = {}
frameButtons = {}
animButtons = {}
currentAnim = 1

selectedAction = 0


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

  if editSpriteWindow then
    editSpriteWindow:Remove()
    editSpriteWindow = nil
  end
  selectedSprite = 0

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
      if editSpriteWindow then
        editSpriteWindow:UpdatePosText()
      end
    elseif key == "a" then
      currentSelected.sprite.x = math.floor(currentSelected.sprite.x/gridSubdiv)*gridSubdiv - gridSubdiv
      if editSpriteWindow then
        editSpriteWindow:UpdatePosText()
      end
    elseif key == "s" then
      currentSelected.sprite.y = math.floor(currentSelected.sprite.y/gridSubdiv)*gridSubdiv + gridSubdiv
      if editSpriteWindow then
        editSpriteWindow:UpdatePosText()
      end
    elseif key == "d" then
      currentSelected.sprite.x = math.floor(currentSelected.sprite.x/gridSubdiv)*gridSubdiv + gridSubdiv
      if editSpriteWindow then
        editSpriteWindow:UpdatePosText()
      end
    end
  end
end

function moveSpritesHeld()
  if selectedSprite ~= 0 and (love.keyboard.isDown('lshift') or love.keyboard.isDown('rshift')) then
    local currentSelected = currentSprites[selectedSprite]
    if love.keyboard.isDown('w') then
      currentSelected.sprite.y = currentSelected.sprite.y - 1
      if editSpriteWindow then
        editSpriteWindow:UpdatePosText()
      end
    elseif love.keyboard.isDown('a') then
      currentSelected.sprite.x = currentSelected.sprite.x - 1
      if editSpriteWindow then
        editSpriteWindow:UpdatePosText()
      end
    elseif love.keyboard.isDown('s') then
      currentSelected.sprite.y = currentSelected.sprite.y + 1
      if editSpriteWindow then
        editSpriteWindow:UpdatePosText()
      end
    elseif love.keyboard.isDown('d') then
      currentSelected.sprite.x = currentSelected.sprite.x + 1
      if editSpriteWindow then
        editSpriteWindow:UpdatePosText()
      end
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
        if editSpriteWindow then
          editSpriteWindow:UpdatePosText()
        end
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

local spriteWindowScroll = loveframes.Create("list", spriteWindow)
spriteWindowScroll:SetPos(0, 32)
spriteWindowScroll:SetSize(64, 512)
spriteWindowScroll:SetPadding(0)
spriteWindowScroll:SetSpacing(0)
spriteWindowScroll:SetDisplayType("vertical")
spriteWindowScroll:SetAutoScroll(true)

spriteWindow.Update = function(obj)

  spriteWindow:SetPos(love.graphics.getWidth()-64, 0)
  spriteWindow:SetHeight(love.graphics.getHeight())

end

spriteWindow.generateList = function(obj)

  spriteWindowScroll:Clear()
  --for i=#currentSpriteButtons,1,-1 do
  --  currentSpriteButtons[i]:Remove()
  --  debugConsole("Removed Sprite Button")
  --end
  --currentSpriteButtons = {}

  for i=1,#currentSprites do
    currentSpriteButtons[i] = loveframes.Create("button", spriteWindowScroll)
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
    spriteWindowScroll:AddItem(currentSpriteButtons[i])
  end

  --if addSpriteButton then
  --  addSpriteButton:Remove()
  --  addSpriteButton = nil
  --  debugConsole("Removed Add Sprite Button")
  --end

  local addSpriteButton = loveframes.Create("button", spriteWindowScroll)
  addSpriteButton:SetHeight(16)
  addSpriteButton:SetWidth(64)
  addSpriteButton:SetPos(0, (#currentSprites*16)+32)
  addSpriteButton:SetText("+")
  spriteWindowScroll:AddItem(addSpriteButton)
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


frameWindow.Update = function(obj)
  obj:SetPos(0, love.graphics.getHeight()-64)
  obj:SetWidth(love.graphics.getWidth()-64)
end


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

  editSpriteWindow.UpdatePosText = function(obj)
    local children = obj:GetChildren()

    for i=1,#children do
      if children[i].UpdateTextPos then
        children[i]:UpdateTextPos()
      end
    end
  end

  editSpriteWindow.OnClose = function(obj)
    selectedSprite = 0
  end

  local xText = loveframes.Create("text", editSpriteWindow)
  xText:SetText("X:")
  xText:SetPos(16, 32)

  local xInput = loveframes.Create("textinput", editSpriteWindow)
  xInput:SetPos(32, 32)
  xInput:SetWidth(48)
  xInput:SetHeight(16)
  xInput:SetText(tostring(cluster[currentAnim].frames[currentFrame].sprites[selectedSprite].x))
  xInput.UpdateTextPos = function(obj)
    xInput:SetText(tostring(cluster[currentAnim].frames[currentFrame].sprites[selectedSprite].x))
  end
  xInput.UpdateSprite = function(obj, text)
    if text == "u" then

      if currentFrame == 1 then
        obj:GetBaseParent().sprite.x = 0
      else
        -- TODO: unchanged sprite x/y
      end

    elseif text:match("^%-?%d+$") then
      obj:GetBaseParent().sprite.x = tonumber(obj:GetText())
    else
      obj:GetBaseParent().sprite.x = 0
    end
  end
  xInput.OnEnter = function(obj, text)
    obj:UpdateSprite(text)
  end

  local yText = loveframes.Create("text", editSpriteWindow)
  yText:SetText("Y:")
  yText:SetPos(96, 32)

  local yInput = loveframes.Create("textinput", editSpriteWindow)
  yInput:SetPos(112, 32)
  yInput:SetWidth(48)
  yInput:SetHeight(16)
  yInput:SetText(tostring(cluster[currentAnim].frames[currentFrame].sprites[selectedSprite].y))
  yInput.UpdateTextPos = function(obj)
    yInput:SetText(tostring(cluster[currentAnim].frames[currentFrame].sprites[selectedSprite].y))
  end
  yInput.UpdateSprite = function(obj, text)
    if text == "u" then

      if currentFrame == 1 then
        obj:GetBaseParent().sprite.y = 0
      else
        -- TODO: unchanged sprite x/y
      end

    elseif text:match("^%-?%d+$") then
      obj:GetBaseParent().sprite.y = tonumber(obj:GetText())
    else
      obj:GetBaseParent().sprite.y = 0
    end
  end
  yInput.OnEnter = function(obj, text)
    obj:UpdateSprite(text)
  end


  local imageText = loveframes.Create("text", editSpriteWindow)
  imageText:SetText("Image:")
  imageText:SetPos(16, 64)

  local imageInput = loveframes.Create("textinput", editSpriteWindow)
  imageInput:SetPos(64, 64)
  imageInput:SetWidth(96)
  imageInput:SetHeight(16)
  imageInput:SetText(cluster[currentAnim].frames[currentFrame].sprites[selectedSprite].image)
  imageInput.UpdateTextImage = function(obj)
    imageInput:SetText(cluster[currentAnim].frames[currentFrame].sprites[selectedSprite].image)
  end
  imageInput.UpdateSprite = function(obj, text)
    if love.filesystem.getInfo("sprites/"..obj:GetText()..".png") then
      obj:GetBaseParent().sprite.image = obj:GetText()
      genSprites()
    else
      makeErrorWindow(192, "No Sprite of That Name", "There's no sprite of that filename in that path.\nPath is sprites/"..obj:GetText()..".png", true)
    end
  end
  imageInput.OnEnter = function(obj, text)
    obj:UpdateSprite(text)
  end


  local actionsTable = loveframes.Create("columnlist", editSpriteWindow)
  actionsTable:SetPos(16, 256-96-16)
  actionsTable:SetSize(256-32, 96)
  actionsTable:SetColumnHeight(16)
  actionsTable:AddColumn("Action")
  actionsTable:AddColumn("Arg1")
  actionsTable:AddColumn("Arg2")
  actionsTable:AddColumn("Arg3")
  actionsTable:AddColumn("Arg4")
  actionsTable:AddColumn("Arg5")
  actionsTable:AddColumn("Arg6")
  actionsTable:AddColumn("Arg7")

  actionsTable:AddRow("-- + --")

  actionsTable.OnRowSelected = function(parent, row, data)
      if data[1] == "-- + --" then
        actionsTable:AddRow("nil", 0, 0, 0, 0, 0, 0, 0)
      else
        selectedAction = row
        makeEditActionWindow()
      end
  end
  --for i=1, 20 do
  --    actionsTable:AddRow("Row " ..i.. ", column 1", "Row " ..i.. ", column 2", "Row " ..i.. ", column 3", "Row " ..i.. ", column 4")
  --end

end



------------------------
-- Edit Action Window --
------------------------


function makeEditActionWindow()

  if editActionWindow then
    editActionWindow:Remove()
  end

  editActionWindow = loveframes.Create("frame")
  editActionWindow:SetState("project")
  editActionWindow:SetPos(128, 64)
  editActionWindow:SetName("Edit Action")
  editActionWindow:SetWidth(256)
  editActionWindow:SetHeight(64)

  local actionText = loveframes.Create("text", editActionWindow)
  actionText:SetText("Action:")
  actionText:SetPos(16, 32)

  local actionInput = loveframes.Create("textinput", editActionWindow)
  actionInput:SetPos(32, 32)
  actionInput:SetWidth(48)
  actionInput:SetHeight(16)
  actionInput:SetText(tostring(cluster[currentAnim].frames[currentFrame].sprites[selectedSprite].actions[selectedAction].action))
  actionInput.UpdateTextAction = function(obj)
    actionInput:SetText(tostring(cluster[currentAnim].frames[currentFrame].sprites[selectedSprite].actions[selectedAction].action))
  end
  actionInput.UpdateSprite = function(obj, text)
    if text:match("^%-?%d+$") then
      obj:GetBaseParent().sprite.actions[selectedAction] = tonumber(obj:GetText())
    else
      obj:GetBaseParent().sprite.actions[selectedAction] = 0
    end
  end
  actionInput.OnEnter = function(obj, text)
    obj:UpdateSprite(text)
  end



end


---------------------------------
-- Animation Navigation Window --
---------------------------------

animationWindow = loveframes.Create("frame")
animationWindow:SetState("project")
animationWindow:SetName("Animations")
animationWindow:SetX(32)
animationWindow:CenterY()
animationWindow:SetWidth(128)
animationWindow:SetHeight(256)
animationWindow:ShowCloseButton(false)
animationWindow.Update = function(obj)
  obj:MakeTop()
end

animationList = loveframes.Create("list", animationWindow)
animationList:SetPos(0, 32)
animationList:SetSize(animationWindow:GetWidth(), animationWindow:GetHeight()-64)


function genAnimations()

  for i=#animButtons,1,-1 do
    animButtons[i]:Remove()
    debugConsole("Removed Animation Button")
  end
  animButtons = {}

  for i=1,#cluster do

    animButtons[i] = loveframes.Create("button")
    animButtons[i].localID = i
    animButtons[i]:SetText(cluster[i].name)
    --animButtons[i]:SetPos(16, 16+(i*16))
    animButtons[i]:SetSize(96, 16)
    animButtons[i].OnClick = function(obj)
      currentAnim = obj.localID
      currentFrame = 1
      selectedSprite = 0
      regenProject()
    end
    --animButtons[i]:SetState("project")
    animationList:AddItem(animButtons[i])

  end

  if addAnimButton then
    addAnimButton:Remove()
    addAnimButton = nil
    debugConsole("Removed Add Animation Button")
  end

  addAnimButton = loveframes.Create("button")
  addAnimButton:SetText("+")
  --addAnimButton:SetPos(16, 16+((#cluster+1)*16))
  addAnimButton:SetSize(96, 16)
  addAnimButton.OnClick = function(obj)
    cluster[#cluster+1] = makeNewAnim()
    addAnimButton:SetPos(16, 16+((#cluster+1)*16))
    currentAnim = #cluster
    currentFrame = 1
    selectedSprite = 0
    regenProject()
  end
  --addAnimButton:SetState("project")
  animationList:AddItem(addAnimButton)

end


function makeNewAnim()
  local tempTable = { -- new anim
    name = "New Animation",
    frames = {
      {
        sprites={}
      }
    },
  }
  return tempTable
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
  genAnimations()
  spriteWindow:generateList()
end

function fullRegenSprites()
  genSprites()
  spriteWindow:generateList()
end


debugConsole("project.lua Loaded")
