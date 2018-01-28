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
  table.insert(Inventory.parts[part.partType],part)
end

function Inventory:addPartSet(parts)
  for _,part in ipairs(parts) do
    Inventory:addPart(part)
  end
end

function Inventory:addTool(tool)
  table.insert(Inventory.tools,tool)
  Inventory.currentToolIndex = #Inventory.tools
  
  for _,part in ipairs(tool.parts) do
    Inventory:addPart(part)
  end
end

function Inventory:getCurrentTool()
  return Inventory.tools[Inventory.currentToolIndex]
end

function Inventory:setCurrentTool(tool)
  Inventory.tools[Inventory.currentToolIndex] = tool
end

function Inventory:nextTool()
  Inventory.currentToolIndex = Inventory.currentToolIndex and wrap(Inventory.currentToolIndex + 1,#Inventory.tools) or 0
  return Inventory:getCurrentTool()
end

function Inventory:previousTool()
  Inventory.currentToolIndex = Inventory.currentToolIndex and wrap(Inventory.currentToolIndex - 1,#Inventory.tools) or 0
  return Inventory:getCurrentTool()
end

function Inventory:throwCurrentTool()
  local thrownTool = table.remove(Inventory.tools,Inventory.currentToolIndex)
  Inventory.currentToolIndex = Inventory.currentToolIndex - 1
  Inventory:nextTool()
  return thrownTool
end

function Inventory:discardCurrentTool()
  print("Inventory:discardCurrentTool")
  table.remove(Inventory.tools,Inventory.currentToolIndex)
  Inventory.currentToolIndex = Inventory.currentToolIndex - 1
  Inventory:nextTool()
end

function Inventory:draw()

  if State.inventoryView then
   -- return
  end
  
  -- means we dont have any tools at all.
  if not Inventory:getCurrentTool() then
    love.graphics.setColor(50,0,0,155)
    love.graphics.print("ERROR::NO_TOOL",5+Properties.DropShadow,50+Properties.DropShadow)
    love.graphics.setColor(255,10,10,255)
    love.graphics.print("ERROR::NO_TOOL",5,50)
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
