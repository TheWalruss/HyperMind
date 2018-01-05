require 'Properties'
require 'Level'
require 'Camera'
require 'Common'

Dilator = {list = {}}

local function tag(c, strength, color, effectColor)
  local tag = {}
  
  Level:setPixel(c.x,c.y,
                 color.r,
                 color.g,
                 color.b,
                 color.a)
  tag.LifeTime = strength * Properties.FadeLengthFactor
  tag.TimeLeft = tag.LifeTime
  tag.Color = {r=effectColor.r,g=effectColor.g,b=effectColor.b} 
  tag.Pos = {x=c.x,y=c.y}
  table.insert(Dilator.list,tag)
end

function Dilator:tag(Dilatorthing)
  if not Dilatorthing.collisions then
    return
  end
  local c1 = Dilatorthing.collisions[1]
  local r,g,b,a = Level:getPixel(c1.x,c1.y)
  if a < Properties.CollisionAlpha then
    return
  end
  if (Dilatorthing.Effector == "Precision" ) or 
     ( Dilatorthing.OperationStrength >= Materials:getHardness(r,g,b,a) ) then
    local color = {r=r,g=g,b=b,a=a}
    for _,c in ipairs(Dilatorthing.collisions) do
      if not c.a then
        c.r, c.g, c.b, c.a = Level:getPixel(c.x, c.y)
      end
      if c.a < Properties.CollisionAlpha then
        tag(c,Dilatorthing.OperationStrength,color,Dilatorthing.Color)
      end
    end
  end
end

function Dilator:update(dt)
  
  for index = #Dilator.list,1,-1 do
    if Dilator.list[index].TimeLeft <= 0 then
      table.remove(Dilator.list,index)
    else
      Dilator.list[index].TimeLeft = Dilator.list[index].TimeLeft - dt
    end
  end
end

function Dilator:draw()
  for _,tag in ipairs(Dilator.list) do
    local cx, cy = Camera:worldToScreen(tag.Pos.x,tag.Pos.y)
    local fade = tag.TimeLeft / tag.LifeTime
    love.graphics.setColor(tag.Color.r,tag.Color.g,tag.Color.b,255*fade)
    love.graphics.points(cx,cy)
  end
end