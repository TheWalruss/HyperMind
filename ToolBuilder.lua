require 'Toolkit'

ToolBuilder = {}

local function makeName(tool)
  local str = ""
  for index, powermod in ipairs(Toolkit.Powermod) do
    if tool.Powermod == powermod then
      str = Toolkit.HardwareCompanies[index]
      break
    end
  end
  print(ts('makename',tool))
  str = str .. " "
  local powerletters = tool.OperationStrength and 1 + (tool.OperationStrength % 4) or 0
  local nr = 0
  if powerletters > 0 then
    for index, powermod in ipairs(Toolkit.Powermod) do
      print (ts('index,powermod',{i=index,p=powermod}))
      if not tool[powermod] then
        print ('hmm, not '..powermod)
        break
      end
      if nr < powerletters then
        nr = nr + 1
        str = str .. string.char(64+tool[powermod]*2) --  B D F H J L N P R T V X  
                               --63+tool[powermod]*2  -- A C E G I K M O Q S U W Y 
      elseif nr == powerletters then
        nr = nr + 1
        str = str .. tostring(tool[powermod]) -- dont start with 0!
      else
        str = str .. tostring(tool[powermod]-1) -- 1 through 9
      end
    end
  end
  str = str .. " " .. tostring(tool.Reloadperiod)
  str = str .. " " .. tostring(tool.Firemode)
  str = str .. " " .. tostring(tool.Special)
  str = str .. " " .. tostring(tool.VehicleAttribute)
  str = str .. " " .. tostring(tool.Effector)
  str = str .. " " .. tostring(tool.Vehicle)
  str = str .. " " .. tostring(tool.Operation)
  print('makename result:'..str)
  return str
end

function makeColor(tool)
  local operationIndex = 1
  for opIndex = 1, #Toolkit.Operation do
    if tool.Operation == Toolkit.Operation[opIndex] then
      operationIndex = opIndex
      break
    end
  end
  
  return {r=(operationIndex * 123)%256,g=(operationIndex * 21)%256,b=(operationIndex * -42)%256,a=255}  
end

function ToolBuilder:CreateRandomToolPartOfType(partType)
  
  local part = {partType=partType, 
                value=Toolkit[partType][math.random(#Toolkit[partType])]}
  return part
end

function ToolBuilder:CreateBasicToolPartOfType(partType)
  
  local part = {partType=partType, 
                value=Toolkit[partType][1]}
  return part
end

function ToolBuilder:CreateRandomToolPart()
  local partType = Toolkit.PartTypes[math.random(#Toolkit.PartTypes)]
  return ToolBuilder:CreateRandomToolPartOfType(partType)
end

function ToolBuilder:ValidateTool(tool)
  --todo ValidateTool
  return true
end

function ToolBuilder:CreateToolFromParts(parts)
  print(ts('CreateToolFromParts parts',parts))
  local tool = {}
  for _, part in ipairs(parts) do
    tool[part.partType] = part.value
  end
  
  print(ts('CreateToolFromParts tool',tool))
  tool.Name = makeName(tool)
  tool.Color = makeColor(tool)
  tool.parts = parts
  
  tool.readyToUse = ToolBuilder:ValidateTool(tool)
  
  print(ts('CreateToolFromParts tool complete',tool))
  return tool
end

function ToolBuilder:CreateRandomTool()
  local parts = {}
  for _,partType in ipairs(Toolkit.PartTypes) do
    table.insert(parts, ToolBuilder:CreateRandomToolPartOfType(partType))
  end
  
  return ToolBuilder:CreateToolFromParts(parts)
end

function ToolBuilder:CreateBasicTool()
  local parts = {}
  for _,partType in ipairs(Toolkit.PartTypes) do
    table.insert(parts, ToolBuilder:CreateBasicToolPartOfType(partType))
  end
  
  return ToolBuilder:CreateToolFromParts(parts)
end

function ToolBuilder:UpdateTool(tool)  
  tool = ToolBuilder:CreateToolFromParts(tool.parts)
  return tool
end

function ToolBuilder:NewTool()
  local parts = {}
  
  return ToolBuilder:CreateToolFromParts(parts)
end

function ToolBuilder:CreateFullPartSet()
  local parts = {}
  for _,partType in ipairs(Toolkit.PartTypes) do
    for _,part in ipairs(Toolkit[partType]) do
      table.insert(parts, {partType=partType,value=part})
    end
  end
  return parts
end

--[[
function ToolBuilder:CreateToolFromParts(parts)
  local tool = {}
  for attributeName, attribute in pairs(Toolkit) do
    tool[attributeName] = attribute[1]
  end
  for _,attribute in ipairs(Toolkit.Powermod) do
    tool[attribute] = 1
  end
  tool.Reloadperiod = Toolkit.Reloadperiod[2]
  
  tool.Name = makeName(tool)
  tool.Color = makeColor(tool)
  tool.readyToUse = true
  return tool
end
--]]