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
  if not ct then
    -- no tool to highlight
    return
  end
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
    return tostring(part.value)
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

local function setPart()
  print("setPart")
  local ct = Inventory:getCurrentTool()
  if not ct then
    -- no tool to set part on. Should create a new tool first.
    print("no")
    return
  end

  --find the highlighted part
  local partType = Toolkit.PartTypes[currentColumn]
  if partType then
    local part = Inventory.parts[partType][currentRow]
    if not part then
     return
    end
    part.assigned = ct
    print ('setpart:' .. ts('part',part))
    if not ct.parts then
      ct.parts={part}
    else
      local assigned = false
      for index,cpart in ipairs(ct.parts) do
        if cpart.partType == partType then
	  cpart.assigned = nil
	  ct.parts[index]=part
	  assigned = true
	end
      end
      if not assigned then
        table.insert(ct.parts,part)
      end
    end
  end
  print(ts('ps',{partType=partType,currentColumn=currentColumn,currentRow=currentRow}))
end

local function update()
  print("update")
  local ct = Inventory:getCurrentTool()
  if not ct then
    -- no tool to update
    return
  end

  ct = Inventory:setCurrentTool(ToolBuilder:UpdateTool(ct))
end

function ToolCraft:keypressed(key,isrepeat)
  print("keypressed"..key)
  print("newtool"..Properties.Keybindings.newtool)
  print("setpart"..Properties.Keybindings.setpart)
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
  elseif key == Properties.Keybindings.newtool then
    Inventory:addTool(ToolBuilder:NewTool())
  elseif key == Properties.Keybindings.discardtool then
    Inventory:discardCurrentTool()
  elseif key == Properties.Keybindings.setpart then
    setPart()
    update()
  end
end