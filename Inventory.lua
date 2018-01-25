require 'Toolkit'

              
local function generateEmptyPartsInv()
  local partsInv = {}
  for _,partType in ipairs(Toolkit.PartTypes) do
    partsInv[partType] = {}
  end
  return partsInv
end

Inventory = { tools = {},
              parts = generateEmptyPartsInv() }

local function wrap(index, maxIndex)
  if index < 1 then
    index = maxIndex
  elseif index > maxIndex then
    index = 1
  end
  return index
end
function Inventory:addPart(part)
print('inventory.lua'..tostring(Inventory.parts)..ts('parts',Inventory.parts))
  table.insert(Inventory.parts[part.partType],part)
  --Inventory.currentToolIndex = #Inventory.tools
end
function Inventory:addTool(tool)
  table.insert(Inventory.tools,tool)
  Inventory.currentToolIndex = #Inventory.tools
end

function minimalKit()
  if not Inventory.tools or #Inventory.tools == 0 then
    Inventory.tools = {}
    Inventory:addTool(Toolkit:createBasicTool())
  end
end

function Inventory:getCurrentTool()
  return Inventory.tools[Inventory.currentToolIndex]
end

function Inventory:nextTool()
  Inventory.currentToolIndex = wrap(Inventory.currentToolIndex + 1,#Inventory.tools)
  return Inventory:getCurrentTool()
end

function Inventory:previousTool()
  Inventory.currentToolIndex = wrap(Inventory.currentToolIndex - 1,#Inventory.tools)
  return Inventory:getCurrentTool()
end

function Inventory:throwCurrentTool()
  local thrownTool = table.remove(Inventory.currentToolIndex,Inventory.tools)
  minimalKit()
  Inventory.currentToolIndex = Inventory.currentToolIndex - 1
  Inventory:nextTool()
  return thrownTool
end

function Inventory:discardCurrentTool()
  table.remove(Inventory.currentToolIndex,Inventory.tools)
  minimalKit()
  Inventory.currentToolIndex = Inventory.currentToolIndex - 1
  Inventory:nextTool()
end

function Inventory:draw()

  if State.inventoryView then
    return
  end
  
  love.graphics.setColor(0,0,0,155)
  love.graphics.print(tostring(Inventory.currentToolIndex).."::"..Inventory:getCurrentTool().Name,5+Properties.DropShadow,50+Properties.DropShadow)
  love.graphics.setColor(255,255,255,255)
  love.graphics.print(tostring(Inventory.currentToolIndex).."::"..Inventory:getCurrentTool().Name,5,50)
  
  for toolNr = 2, math.min(#Inventory.tools,7) do
    local toolIndex = Inventory.currentToolIndex
    local up = false
    if toolNr % 2 == 0 then
      up = false
      toolNr = toolNr / 2
      toolIndex = toolIndex + toolNr
    else
      up = true
      toolNr = math.floor(toolNr/2)
      toolIndex = toolIndex - toolNr
    end
    
    toolIndex = wrap(toolIndex, #Inventory.tools)
    local x = 5 + (toolNr*toolNr)
    local y = 50 + (up and 15 * toolNr or (-15 * toolNr))
    love.graphics.setColor(0,0,0,255/toolNr)
    love.graphics.print(tostring(toolIndex).."::"..Inventory.tools[toolIndex].Name,x+Properties.DropShadow*toolNr,y+Properties.DropShadow*toolNr)
    love.graphics.setColor(255,255,255,255/toolNr)
    love.graphics.print(tostring(toolIndex).."::"..Inventory.tools[toolIndex].Name,x,y)
  end
end
