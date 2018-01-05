require 'Properties'
require 'Level'
require 'Camera'
require 'Common'

Annihilator = {list = {}}

local function tag(c, strength, Annihilatorthing)
  local tag = {}
  
  local alpha = 0
  if Annihilatorthing.Special == "Neumann" then
    alpha = Annihilatorthing.SpecialPower
  end
  Level:setPixel(c.x,c.y,
                 c.r,
                 c.g,
                 c.b,
                 alpha)
  tag.LifeTime = strength * Properties.FadeLengthFactor
  tag.TimeLeft = tag.LifeTime
  tag.Color = {r=c.r,g=c.g,b=c.b}
  tag.Pos = {x=c.x,y=c.y}
  table.insert(Annihilator.list,tag)
end

function Annihilator:tag(Annihilatorthing)
  if not Annihilatorthing.collisions then
    return
  end
  for _,c in ipairs(Annihilatorthing.collisions) do
    c.r, c.g, c.b, c.a = Level:getPixel(c.x,c.y)
    if c.a >= Properties.CollisionAlpha then
      if (Annihilatorthing.Effector == "Precision" ) or 
         (Annihilatorthing.OperationStrength >= Materials:getHardness(c.r,c.g,c.b,c.a) ) then
        tag(c,Annihilatorthing.OperationStrength,Annihilatorthing)
      end
    end
  end
end

function Annihilator:update(dt)
  
  for index = #Annihilator.list,1,-1 do
    if Annihilator.list[index].TimeLeft <= 0 then
      table.remove(Annihilator.list,index)
    else
      Annihilator.list[index].TimeLeft = Annihilator.list[index].TimeLeft - dt
    end
  end
end

function Annihilator:draw()
  for _,tag in ipairs(Annihilator.list) do
    local cx, cy = Camera:worldToScreen(tag.Pos.x,tag.Pos.y)
    local fade = tag.TimeLeft / tag.LifeTime
    love.graphics.setColor(tag.Color.r,tag.Color.g,tag.Color.b,255*fade)
    love.graphics.points(cx,cy)
  end
end