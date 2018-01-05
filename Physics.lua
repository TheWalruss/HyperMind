require 'trace'
require 'level'
require 'properties'

Physics = {}

local needRefresh = false
local pixDt = 0
local currentChunk = nil
local x0, y0 = 0, 0

local function physicsUpdateFunction(x, y, r, g, b, a)
  local changed = false
  local ox, oy = x0+x, y0+y
  
  if a > 0 and a < Properties.CollisionAlpha then
    a = a -1
    -- Annihilator neumann
    local neighborhood = Level:getNeighborhoodTable(ox,oy)
    for _,px in ipairs(neighborhood) do
      if neighborhood.a > Properties.CollisionAlpha then
        Level:setPixel(neighborhood.Pos.x,neighborhood.Pos.y, neighborhood.r, neighborhood.g, neighborhood.b, a)
        changed = true
      end
    end
  end
  
  if a >= Properties.CollisionAlpha then
    a = a -1
    -- Converter neumann
    local neighborhood = Level:getNeighborhoodTable(ox,oy)
    for _,px in ipairs(neighborhood) do
      if neighborhood.a == Properties.CollisionAlpha then
        Level:setPixel(neighborhood.Pos.x,neighborhood.Pos.y, r, g, b, a)
        changed = true
      end
    end
  end
  
  if changed then
    needRefresh = true
  end
  return r, g, b, a
end

function Physics:update(x,y,dt)
  pixDt = dt
  currentChunk = Level:getChunk(bx,by)
  if not currentChunk then
    return
  end
  x0 = x * Properties.ChunkSize.x
  y0 = y * Properties.ChunkSize.y
  needRefresh = false
  chunkData:mapPixel(physicsUpdateFunction)
  
  if needRefresh then
    currentChunk.needRefresh = true
  end
end