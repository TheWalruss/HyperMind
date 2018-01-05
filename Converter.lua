require 'Properties'
require 'Level'
require 'Camera'
require 'Common'

Converter = {list = {}}

local function tag(c,strength,tocolor)
  local tag = {}
  Level:setPixel(c.x,c.y,tocolor.r,
                         tocolor.g,
                         tocolor.b,
                         tocolor.a)
  tag.LifeTime = strength * Properties.FadeLengthFactor
  tag.TimeLeft = tag.LifeTime
  tag.Color = {r=c.r,g=c.g,b=c.b}
  tag.Pos = {x=c.x,y=c.y}
  table.insert(Converter.list,tag)
end

local function operationStrengthToColor(strength)
  local polarity = strength > 5
  local r,g,b = 0,0,0
  
  r = clamp(0,strength % Properties.MaterialLevels,Properties.MaterialLevels - 1)
  g = clamp(0,strength-2 % Properties.MaterialLevels,Properties.MaterialLevels - 1)
  b = clamp(0,strength-4 % Properties.MaterialLevels,Properties.MaterialLevels - 1)
  if polarity then
    r = Properties.MaterialLevels - 1 - r
    g = Properties.MaterialLevels - 1 - g
    b = Properties.MaterialLevels - 1 - b
  end
  r = clamp0255(r * 128)
  g = clamp0255(g * 128)
  b = clamp0255(b * 128)
  return {r=r,g=g,b=b,a=255}
end

function Converter:tag(Converterthing)
  if not Converterthing.collisions then
    return
  end
  local tocolor = operationStrengthToColor(Converterthing.OperationStrength)
  for _,c in ipairs(Converterthing.collisions) do
    c.r, c.g, c.b, c.a = Level:getPixel(c.x,c.y)
    
    if ( c.a >= Properties.CollisionAlpha) then
      if (Converterthing.Effector == "Precision" ) or 
         (Converterthing.OperationStrength >= Materials:getHardness(c.r,c.g,c.b,c.a) ) then
         tag(c,Converterthing.OperationStrength,tocolor)
      end
    end
  end
end

function Converter:update(dt)
  
  for index = #Converter.list,1,-1 do
    if Converter.list[index].TimeLeft <= 0 then
      table.remove(Converter.list,index)
    else
      Converter.list[index].TimeLeft = Converter.list[index].TimeLeft - dt
    end
  end
end

function Converter:draw()
  for _,tag in ipairs(Converter.list) do
    local cx, cy = Camera:worldToScreen(tag.Pos.x,tag.Pos.y)
    local fade = tag.TimeLeft / tag.LifeTime
    love.graphics.setColor(tag.Color.r,tag.Color.g,tag.Color.b,255*fade)
    love.graphics.points(cx,cy)
  end
end