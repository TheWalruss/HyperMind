require 'trace'
require 'Materials'

Chunk = {}

local x0 = 0
local y0 = 0

local MaterialScale = {x=0.01,y=0.01}
local MaterialLevels = Properties.MaterialLevels
local AlphaLevels = 2
local AlphaScale = {x=0.005,y=0.01}
local ROffset = 123
local GOffset = 001
local BOffset = 83828
local AOffset = 37300
local RScaleOffset = 343
local GScaleOffset = 7334
local BScaleOffset = 3723
local AScaleOffset = 0
local RXScaleNoise = {x=0.00001,y=0.00001}
local RYScaleNoise = {x=0.00001,y=0.00001}
local GXScaleNoise = {x=0.00001,y=0.00001}
local GYScaleNoise = {x=0.00001,y=0.00001}
local BXScaleNoise = {x=0.00001,y=0.00001}
local BYScaleNoise = {x=0.00001,y=0.00001}
local AXScaleNoise = {x=0.00001,y=0.00001}
local AYScaleNoise = {x=0.00001,y=0.00001}
local RBiasNoise = {x=0.00001,y=0.00001}
local GBiasNoise = {x=0.00001,y=0.00001}
local BBiasNoise = {x=0.00001,y=0.00001}
local ABiasNoise = {x=0.00001,y=0.00001}
local RBiasOffset = 634234
local GBiasOffset = 7334
local BBiasOffset = -14154
local ABiasOffset = 0

local function clamp0255(val)
  return math.max(0,math.min(255,val))
end
local function basicSimplexFunction(x, y, r, g, b, a)
  local ox, oy = x0+x, y0+y
                                  
  local ax = ox * love.math.noise(AXScaleNoise.x*ox, AXScaleNoise.y*ox) + AOffset
  local ay = oy * love.math.noise(AXScaleNoise.x*oy, AXScaleNoise.y*oy) + AOffset
  
  local abias = love.math.noise(ABiasNoise.x * (ox + AOffset), ABiasNoise.y * (oy + AOffset)) - 0.5
  a = clamp0255(math.floor( (love.math.noise( AlphaScale.x * (ax), 
                                  AlphaScale.y * (ay)) + abias) * AlphaLevels) / (AlphaLevels-1) * 256)
  
  if a == 0 then
    r, g, b = 0, 0, 0
  else
  
    local rx = ox * love.math.noise(RXScaleNoise.x*ox, RXScaleNoise.y*ox) + ROffset
    local ry = oy * love.math.noise(RXScaleNoise.x*oy, RXScaleNoise.y*oy) + ROffset
    
    local rbias = love.math.noise(RBiasNoise.x * (ox + ROffset), RBiasNoise.y * (oy + ROffset)) - 0.5
    r = clamp0255(math.floor( (love.math.noise( MaterialScale.x * (rx), 
                                      MaterialScale.y * (ry)) + rbias) * MaterialLevels) / (MaterialLevels-1) * 256)
                                    
    local gx = ox * love.math.noise(GXScaleNoise.x*ox, GXScaleNoise.y*ox) + GOffset
    local gy = oy * love.math.noise(GXScaleNoise.x*oy, GXScaleNoise.y*oy) + GOffset
    
    local gbias = love.math.noise(GBiasNoise.x * (ox + GOffset), GBiasNoise.y * (oy + GOffset)) - 0.5
    g = clamp0255(math.floor( (love.math.noise( MaterialScale.x * (gx), 
                                    MaterialScale.y * (gy)) + gbias) * MaterialLevels) / (MaterialLevels-1) * 256)
                                    
    local bx = ox * love.math.noise(BXScaleNoise.x*ox, BXScaleNoise.y*ox) + BOffset
    local by = oy * love.math.noise(BXScaleNoise.x*oy, BXScaleNoise.y*oy) + BOffset
    
    local bbias = love.math.noise(BBiasNoise.x * (ox + BOffset), BBiasNoise.y * (oy + BOffset)) - 0.5
    b =clamp0255(math.floor( (love.math.noise( MaterialScale.x * (bx), 
                                    MaterialScale.y * (by)) + bbias) * MaterialLevels) / (MaterialLevels-1) * 256)
  end
  
  return r, g, b, a
end

function mark_borders(chunkdata)
  for y = 0, Properties.ChunkSize.y -1 do
    chunkdata:setPixel(0,y,255,255,255,Properties.CollisionAlpha - 1)
    chunkdata:setPixel(Properties.ChunkSize.x - 1,y,0,0,0,Properties.CollisionAlpha - 1)
  end
  for x = 0, Properties.ChunkSize.x -1 do
    chunkdata:setPixel(x,0,255,255,255,Properties.CollisionAlpha - 1)
    chunkdata:setPixel(x,Properties.ChunkSize.y - 1,0,0,0,Properties.CollisionAlpha - 1)
  end
end

function mark_TL_corner(chunkdata)
  chunkdata:setPixel(0,0,255,255,255,Properties.CollisionAlpha - 1)
end
function Chunk:filename(x,y)
  return string.format("levels/%x_%x.png",x,y)
end
function Chunk:exists(x,y)
  return love.filesystem.exists(Chunk:filename(x,y))
end
function Chunk:generate(x,y)
  if Chunk:exists(x,y) then
    return
  end
  x0 = x * (Properties.ChunkSize.x)
  y0 = y * (Properties.ChunkSize.y)
  chunkData = love.image.newImageData( Properties.ChunkSize.x, Properties.ChunkSize.y )
  chunkData:mapPixel(basicSimplexFunction)
  
  --mark_borders(chunkData)
  
  chunkData:encode("png",Chunk:filename(x,y))
end
