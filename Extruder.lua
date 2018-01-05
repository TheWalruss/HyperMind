require 'Properties'
require 'Level'
require 'Camera'
require 'Common'

Extruder = {list = {}}

local function tag(c,strength)
  local tag = {}
  
  -- TODO
  
  Level:setPixel(c.x,c.y,c.r,
                         c.g,
                         c.b,
                         0)
  tag.LifeTime = strength * Properties.FadeLengthFactor
  tag.TimeLeft = tag.LifeTime
  tag.Color = {r=c.r,g=c.g,b=c.b}
  tag.Pos = {x=c.x,y=c.y}
  table.insert(Extruder.list,tag)
end

function Extruder:tag(Extruderthing)
  if not Extruderthing.collisions then
    return
  end
  for _,c in ipairs(Extruderthing.collisions) do
    tag(c,Extruderthing.OperationStrength)
  end
end

function Extruder:update(dt)
  
  for index = #Extruder.list,1,-1 do
    if Extruder.list[index].TimeLeft <= 0 then
      table.remove(Extruder.list,index)
    else
      Extruder.list[index].TimeLeft = Extruder.list[index].TimeLeft - dt
    end
  end
end

function Extruder:draw()
  for _,tag in ipairs(Extruder.list) do
    local cx, cy = Camera:worldToScreen(tag.Pos.x,tag.Pos.y)
    local fade = tag.TimeLeft / tag.LifeTime
    love.graphics.setColor(tag.Color.r,tag.Color.g,tag.Color.b,255*fade)
    love.graphics.points(cx,cy)
  end
end