require 'Properties'
require 'Materials'
require 'Camera'
require 'Common'

Probe = {list = {}}

local function tag(c,strength)
  local tag = {}
  
  tag.Material = Materials:GetMaterial(c.r,
                                       c.g,
                                       c.b,
                                       c.a)
  if not tag.Material then
    return
  end
  tag.LifeTime = strength
  tag.TimeLeft = tag.LifeTime
  tag.Pos = {x=c.x,y=c.y}
  table.insert(Probe.list,tag)
end

function Probe:tag(probething)
  if not probething.collisions then
    return
  end
  for _,c in ipairs(probething.collisions) do
    tag(c,probething.OperationStrength)
  end
end

function Probe:update(dt)
  
  for index = #Probe.list,1,-1 do
    if Probe.list[index].TimeLeft <= 0 then
      table.remove(Probe.list,index)
    else
      Probe.list[index].TimeLeft = Probe.list[index].TimeLeft - dt
    end
  end
end

function Probe:draw()
  for _,tag in ipairs(Probe.list) do
    local cx, cy = Camera:worldToScreen(tag.Pos.x,tag.Pos.y)
    local fade = tag.TimeLeft / tag.LifeTime
    love.graphics.setColor(255,255,255,155*fade)
    love.graphics.print(tag.Material.name,cx+Properties.DropShadow,cy+Properties.DropShadow)
    love.graphics.setColor(0,0,0,255*fade)
    love.graphics.print(tag.Material.name,cx,cy)
  end
end