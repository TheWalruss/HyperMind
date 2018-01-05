require 'Properties'
require 'Level'
require 'Camera'
require 'Common'

Fizzle = {list = {}}

local function tag(c,strength)
  local tag = {}
  
-- TODO: what is fizzle supposed to do anyway?
  tag.LifeTime = strength * Properties.FadeLengthFactor
  tag.TimeLeft = tag.LifeTime
  tag.Color = {r=c.r,g=c.g,b=c.b}
  tag.Pos = {x=c.x,y=c.y}
  table.insert(Fizzle.list,tag)
end

function Fizzle:tag(Fizzlething)
  if not Fizzlething.collisions then
    return
  end
  for _,c in ipairs(Fizzlething.collisions) do
    c.r, c.g, c.b, c.a = Level:getPixel(c.x,c.y)
    if c.a > Properties.CollisionAlpha and 
      Fizzlething.OperationStrength >= Materials:getHardness(c.r,c.g,c.b,c.a) then
      tag(c,Fizzlething.OperationStrength)
    end
  end
end

function Fizzle:update(dt)
  
  for index = #Fizzle.list,1,-1 do
    if Fizzle.list[index].TimeLeft <= 0 then
      table.remove(Fizzle.list,index)
    else
      Fizzle.list[index].TimeLeft = Fizzle.list[index].TimeLeft - dt
    end
  end
end

function Fizzle:draw()
  for _,tag in ipairs(Fizzle.list) do
    local cx, cy = Camera:worldToScreen(tag.Pos.x,tag.Pos.y)
    local fade = tag.TimeLeft / tag.LifeTime
    love.graphics.setColor(tag.Color.r,tag.Color.g,tag.Color.b,255*fade)
    love.graphics.points(cx,cy)
  end
end