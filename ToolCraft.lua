require 'Toolkit'
require 'Inventory'
require 'Common'
require 'Inventory'
              
-- Inventory.parts and Inventory.tools


ToolCraft = {}
local divider1Height = 150
local divider2Height = 600
local toolListHeight = divider1Height
local partListHeight = divider2Height - divider1Height
local toolDisplayHeight = Properties.WindowHeight - divider2Height

local nrCols = 1
local rowHeight = 15
local columnWidth = 100

local currentColumn = 1
local currentRow = 1

local currentTool = 1

local typeColumnMap = {}

local function updateColumns()
  nrCols = #Toolkit.PartTypes
  columnWidth = Properties.WindowWidth / (nrCols + 1)
  
  typeColumnMap = {}
  for index, type in ipairs(Toolkit.PartTypes) do
    typeColumnMap[type] = index
  end
end

local function partTablePos(row,col)
  row = row - 1
  col = col - 1
  return {x=5+(col*columnWidth), y=divider1Height+(row*rowHeight)} 
end

local function printPartTableEntry(row,col,entry)
  local pos = partTablePos(row,col)
  love.graphics.print(entry, pos.x, pos.y)
end

local function highlightRow(row)
  local pos = partTablePos(row+1,1)
  love.graphics.setColor(50,10,0,50)
  love.graphics.rectangle("fill",pos.x,pos.y,Properties.WindowWidth,rowHeight)
end

local function highlightColumn(column)
  local pos = partTablePos(2,column)
  love.graphics.setColor(50,10,0,50)
  love.graphics.rectangle("fill",pos.x,pos.y,columnWidth,partListHeight)
end

local function highlightTableEntry(row,column)
  local pos = partTablePos(row,column)
  love.graphics.setColor(200,255,200,150)
  love.graphics.rectangle("fill",pos.x,pos.y,columnWidth,rowHeight)
end

local function highlightCurrentTool()
  local ct = Inventory:getCurrentTool()
  print(ts('ct',ct))
  for _,part in ipairs(ct.parts) do
    local partList = Inventory.parts[part.partType]
    rownr = 2
    for _,listedPart in ipairs(partList) do
      if part.value == listedPart.value then
        highlightTableEntry(rownr, typeColumnMap[part.partType])
        break
      end
      rownr = rownr + 1
    end
  end
end

local function backgroundParts()
  local pos = partTablePos(0,0)
  love.graphics.setColor(50,10,0,50)
  love.graphics.rectangle("fill",pos.x,pos.y,Properties.WindowWidth,partListHeight)
end

local function partEntry(part)
  if part.partType == "Powermod" then
    return part.value.partType .. " * " ..tostring(part.value.value)
  else
    return tostring(part.value)
  end
end

function ToolCraft:draw()

  if not State.inventoryView then
    return
  end
  
  local colnr = 1
  local rownr = 1
  updateColumns()
  
  backgroundParts()
  
  highlightRow(currentRow)
  highlightColumn(currentColumn)
  highlightCurrentTool()
  
  for partType,colnr in pairs(typeColumnMap) do
  -- header
    love.graphics.setColor(255,255,255,255)
    rownr = 1
    printPartTableEntry(rownr, colnr, partType)
  -- content
    local partList = Inventory.parts[partType]
    rownr = 2
    for _,part in ipairs(partList) do
      printPartTableEntry(rownr, colnr, partEntry(part))
      rownr = rownr + 1
    end
  end
  
  --love.graphics.print(ts("parts",Inventory.parts),5,100)
  --love.graphics.print(ts("tools",Inventory.tools),5,400)
end

function ToolCraft:keypressed(key,isrepeat)
  if key == Properties.Keybindings.right then
    currentColumn = currentColumn + 1
    if currentColumn > nrCols then
      currentColumn = 1
    end
  elseif key == Properties.Keybindings.left then
    currentColumn = currentColumn - 1
    if currentColumn < 1 then
      currentColumn = nrCols
    end
  elseif key == Properties.Keybindings.aimup then
    currentRow = currentRow - 1
    if currentRow < 1 then	-- TODO: Loop cursor at rows
      currentRow = 1
    end
  elseif key == Properties.Keybindings.aimdown then
    currentRow = currentRow + 1
    --if currentRow < 1 then	-- TODO: Loop cursor at rows
      --currentRow = 1
    --end
  elseif key == Properties.Keybindings.nexttool then
    Inventory:nextTool()
  elseif key == Properties.Keybindings.prevtool then
    Inventory:previousTool()
  end
end