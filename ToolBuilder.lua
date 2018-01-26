require 'Toolkit'

ToolBuilder = {}

local function makeName(tool)
  local str = ""
  for index, powermod in ipairs(Toolkit.Powermod) do
    if tool.Powermod == powermod then
      str = HardwareCompanies[index]
      break
    end
  end
  print(ts('makename',tool))
  str = str .. " "
  local powerletters = 1 + (tool.OperationStrength % 4)
  local nr = 0
  for index, powermod in ipairs(Toolkit.Powermod) do
    print (ts('index,powermod',{i=index,p=powermod}))
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
  str = str .. " " .. tool.Reloadperiod
  str = str .. " " .. tool.Firemode
  str = str .. " " .. tool.Special
  str = str .. " " .. tool.VehicleAttribute
  str = str .. " " .. tool.Effector
  str = str .. " " .. tool.Vehicle
  str = str .. " " .. tool.Operation
  
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

function ToolBuilder:CreatePowerModule(modName)
  return {partType=modName,
                   value = math.random(10)}
end
function ToolBuilder:CreateRandomPowerModule()
  return ToolBuilder:CreatePowerModule(Toolkit.Powermod[math.random(#Toolkit.Powermod)])
end
function ToolBuilder:CreateBasicPowerModule(modName)
  return {partType=modName,
                   value = 1}
end
function ToolBuilder:CreateBasicPowerModSet()
  local parts = {}
  for _,mod in ipairs(Toolkit.Powermod) do
    table.insert(parts, ToolBuilder:CreateBasicPowerModule(mod))
  end
  return unpack(parts)
end
function ToolBuilder:InsertBasicPowerModSet(parts)
  for _,mod in ipairs(Toolkit.Powermod) do
    table.insert(parts, ToolBuilder:CreateBasicPowerModule(mod))
  end
end
function ToolBuilder:CreateRandomPowerModSet()
  local parts = {}
  for _,mod in ipairs(Toolkit.Powermod) do
    table.insert(parts, ToolBuilder:CreatePowerModule(mod))
  end
  return unpack(parts)
end
function ToolBuilder:CreateRandomToolPartOfType(partType)
  if partType == "Powermod" then
    return {partType=partType, value=ToolBuilder:CreateRandomPowerModule()}
  end
  
  local part = {partType=partType, 
                value=Toolkit[partType][math.random(#Toolkit[partType])]}
  return part
end
function ToolBuilder:CreateBasicToolPartOfType(partType)
  if partType == "Powermod" then
    return ToolBuilder:CreateBasicPowerModSet()
  end
  
  local part = {partType=partType, 
                value=Toolkit[partType][1]}
  return part
end

function ToolBuilder:CreateRandomToolPart()
  local partType = Toolkit.PartTypes[math.random(#Toolkit.PartTypes)]
  return ToolBuilder:CreateRandomToolPartOfType(partType)
end

function ToolBuilder:ValidateTool(tool)
  --todo
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
  tool.readyToUse = true
  tool.parts = parts
  
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
  print('wtf')
  print(ts('Toolkit',Toolkit))
  for _,partType in ipairs(Toolkit.PartTypes) do
  print(ts('CreateBasicTool',parts))
    if partType == "Powermod" then
      ToolBuilder:InsertBasicPowerModSet(parts)
    else
      table.insert(parts, ToolBuilder:CreateBasicToolPartOfType(partType))
    end
  end
  
  return ToolBuilder:CreateToolFromParts(parts)
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