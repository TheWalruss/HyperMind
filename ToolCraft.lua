require 'Toolkit'
require 'Inventory'
require 'Common'
              
-- Inventory.parts and Inventory.tools


ToolCraft = {}

local nrCols = 1
local columnWidth = 100

local function updateColumnWidth()
  nrCols = #Toolkit.PartTypes
  columnWidth = Properties.WindowWidth / (nrCols + 1)
end

local function tablePos(row,col)
  return {x=5+(col*columnWidth), y=300+(row*15)} 
end

local function printTableEntry(row,col,entry)
  local pos = tablePos(row,col)
  love.graphics.print(entry, pos.x, pos.y)
end

function ToolCraft:draw()

  if not State.inventoryView then
    return
  end
  
  local colnr = 0
  local rownr = 0
  updateColumnWidth()
  
  for _,partType in ipairs(Toolkit.PartTypes) do
  -- header
    love.graphics.setColor(255,255,255,255)
    rownr = 0
    printTableEntry(rownr, colnr, partType)
  -- content
    local partList = Inventory.parts[partType]
    rownr = 1
    for _,part in ipairs(partList) do
      printTableEntry(rownr, colnr,tostring(part.value))
      rownr = rownr + 1
    end
    
    colnr = colnr + 1
  end
  
  --love.graphics.print(ts("parts",Inventory.parts),5,100)
  --love.graphics.print(ts("tools",Inventory.tools),5,400)
end
