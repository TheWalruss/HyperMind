-- Example: Loading an Image and displaying it
require 'Chunk'
require 'Properties'
require 'Camera'
require 'Materials'

Level = {}

Level.bx = 0
Level.by = 0
Level.initialized = false
local worldchannel = love.thread.getChannel("world")
Level.cache = {}
-- Utilities
function Level:initialize()
  Level.timestamp = 0
  if Level.initialized then return end
  
  love.filesystem.createDirectory("levels")
  
  Level.bx = 0
  Level.by = 0
  Level.updateTasks = {}
  physicsChannel = love.thread.getChannel("physics")
  
  print("Starting "..tostring(Properties.MaximumSimulationChunks).."^2 physics threads.")
  for x = 1, Properties.MaximumSimulationChunks do
  
    Level.updateTasks[x] = {}
    for y = 1, Properties.MaximumSimulationChunks do
  print("Starting thread "..tostring(x)..","..tostring(y)..".")
      Level.updateTasks[x][y] = {}
      Level.updateTasks[x][y].task = love.thread.newThread('PhysicsTask.lua')
      Level.updateTasks[x][y].task:start()
    end
  end
  Level.initialized = true
end

function Level:filename(bx,by)
  local lx,ly = bx,by
  if lx == nil then
    lx,ly = Level.bx,Level.by
  end
  return Chunk:filename(lx,ly)
end

function Level:exists(bx,by)
  local lx,ly = bx,by
  if lx == nil then
    lx,ly = Level.bx,Level.by
  end
  return Chunk:exists(lx,ly)
end

-- Loading/saving
function Level:load(bx,by)
  local lx,ly = bx,by
  if lx == nil then
    lx,ly = Level.bx,Level.by
  end
  if tostring(lx) == "nan" then
  --print("shite, nan!")
    return false
  end
  print("loaded "..tostring(lx)..","..tostring(ly)..Level:filename(lx,ly))
  if not Level:exists(lx,ly) then
    Chunk:generate(lx,ly)
  end
  local image = love.graphics.newImage(Level:filename(lx,ly))
  
  if not Level.cache[lx] then
    Level.cache[lx] = {}
  end
  Level.cache[lx][ly] = {image = image, data = image:getData()}
  print("address "..tostring(Level.cache[lx][ly])..","..tostring(Level.cache[lx][ly].image))

  worldchannel:push({x = lx, y = ly})
  return true
end

function Level:save(bx,by)
  local lx,ly = bx,by
  if lx == nil then
    lx,ly = Level.bx,Level.by
  end
  if Level:exists(lx,ly) then
    Level.cache[lx][ly].data:encode("png",Level:filename())
    return true
  end
  return false
end

function Level:right()
  Level.bx = Level.bx + 1
  Level:load()
  return true
end

function Level:left()
  Level.bx = Level.bx - 1
  Level:load()
  return true
end
function Level:up()
  Level.by = Level.by - 1
  Level:load()
  return true
end
function Level:down()
  Level.by = Level.by + 1
  Level:load()
  return true
end
local function checkCache(bx,by)
  if Level.cache[bx] and Level.cache[bx][by] then 
    return true 
  end
  
  return Level:load(bx,by)
end


function Level:getChunk(bx,by)
  if checkCache(bx,by) then
    return Level.cache[bx][by]
  else
    return nil
  end
end
local function drawChunk(bx,by,xOffset,yOffset)
  if not checkCache(bx,by) then
    return
  end
  if Level.cache[bx][by].needRefresh then
    Level.cache[bx][by].image:refresh()
    Level.cache[bx][by].needRefresh = false
  end
  love.graphics.draw(Level.cache[bx][by].image, xOffset, yOffset)  
  --love.graphics.print(string.format("(%d, %d) %s",bx,by,tostring(Level.cache[bx][by].image)),xOffset + Properties.ChunkSize.x/2 + 50, yOffset + Properties.ChunkSize.y/2 + 50)
end

local function translate(x,y)
  local bx,by  = math.floor(x / Properties.ChunkSize.x), math.floor(y / Properties.ChunkSize.y)
  local px,py = x - (bx * Properties.ChunkSize.x), y - (by * Properties.ChunkSize.y)
  
  return bx,by,px,py
end
function Level:getPixelTable(x,y)
  local bx,by,px,py  = translate(x,y)
  if not checkCache(bx,by) then
    return {0,0,0,0}  -- TODO: better behavior here
  end
  local r,g,b,a = Level.cache[bx][by].data:getPixel(math.floor(px),math.floor(py))
  return {r=r,g=g,b=b,a=a}
end
function Level:getPixel(x,y)
  local bx,by,px,py  = translate(x,y)
  if not checkCache(bx,by) then
    return 0,0,0,0  -- TODO: better behavior here
  end
  return Level.cache[bx][by].data:getPixel(math.floor(px),math.floor(py))
end
function Level:setPixel(x,y,r,g,b,a)
  local bx,by,px,py  = translate(x,y)
  if not checkCache(bx,by) then
    return
  end
  Level.cache[bx][by].needRefresh = true
  return Level.cache[bx][by].data:setPixel(math.floor(px),math.floor(py),r,g,b,a)
end

function Level:getNeighborhoodTable(ox,oy)
  local px = {}
  table.insert(px, {Pos = {ox,oy+1}, Level:getPixelTable(ox,oy+1)})
  table.insert(px, {Pos = {ox+1,oy}, Level:getPixelTable(ox+1,oy)})
  table.insert(px, {Pos = {ox,oy-1}, Level:getPixelTable(ox,oy-1)})
  table.insert(px, {Pos = {ox-1,oy}, Level:getPixelTable(ox-1,oy)})
  table.insert(px, {Pos = {ox+1,oy+1}, Level:getPixelTable(ox+1,oy+1)})
  table.insert(px, {Pos = {ox-1,oy+1}, Level:getPixelTable(ox-1,oy+1)})
  table.insert(px, {Pos = {ox+1,oy-1}, Level:getPixelTable(ox+1,oy-1)})
  table.insert(px, {Pos = {ox-1,oy-1}, Level:getPixelTable(ox-1,oy-1)})
  return px
end

function Level:getMaterial(x,y)
  return Materials:GetMaterial(Level:getPixel(x,y))
end
-- Drawing/updating

function Level:shift(x,y)
  local bx,by,px,py  = translate(x,y)
  if  px < 0 then
    Level:left()
    return true
  elseif py < 0 then
    Level:up()
    return true
  elseif px > Properties.ChunkSize.x then
    Level:right()
    return true
  elseif py > Properties.ChunkSize.y then
    Level:down()
    return true
  end
  return false
end
function Level:draw()
  local x,y = Camera.Pos.x, Camera.Pos.y
  
  local bx0,by0,px,py  = translate(x,y)
  love.graphics.setColor(255,255,255,255)
  
  for x = 0, Properties.NrChunkWide do
    for y = 0, Properties.NrChunkHigh do
      drawChunk(bx0 + x,by0 + y,-px + x*Properties.ChunkSize.x,-py + y*Properties.ChunkSize.y)
    end
  end
end

function Level:update(dt,x,y)
  Level.timestamp = Level.timestamp + dt
  local x,y = Camera.Pos.x, Camera.Pos.y
  
  local bx0,by0,px,py  = translate(x,y)
  bx0,by0 = math.floor(bx0 - Properties.MaximumSimulationChunks / 2), math.floor(by0 - Properties.MaximumSimulationChunks / 2)
  for x = 1, Properties.MaximumSimulationChunks do
    for y = 1, Properties.MaximumSimulationChunks do
      physicsChannel:push({x=bx0+x,y=by0+y,dt=dt,timestamp=Level.timestamp})
    end
  end
end


