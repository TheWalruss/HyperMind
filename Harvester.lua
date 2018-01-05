require 'Properties'
require 'Level'
require 'Camera'
require 'Common'

Harvester = {list = {}}

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
  table.insert(Harvester.list,tag)
end

function Harvester:tag(Excavatorthing)
  if not Excavatorthing.collisions then
    return
  end
  for _,c in ipairs(Excavatorthing.collisions) do
    tag(c,Excavatorthing.OperationStrength)
  end
end

function Harvester:update(dt)
  
  for index = #Harvester.list,1,-1 do
    if Harvester.list[index].TimeLeft <= 0 then
      table.remove(Harvester.list,index)
    else
      Harvester.list[index].TimeLeft = Harvester.list[index].TimeLeft - dt
    end
  end
end

function Harvester:draw()
  for _,tag in ipairs(Harvester.list) do
    local cx, cy = Camera:worldToScreen(tag.Pos.x,tag.Pos.y)
    local fade = tag.TimeLeft / tag.LifeTime
    love.graphics.setColor(tag.Color.r,tag.Color.g,tag.Color.b,255*fade)
    love.graphics.points(cx,cy)
  end
end