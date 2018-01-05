require 'Properties'
require 'Level'
require 'Camera'
require 'Common'
require 'Vehicle'

Projection = { list = {}}

function Projection:fire(projector, sourcePos, aim, firePower)
  local stopped = false
  local endPos = {x=sourcePos.x,y=sourcePos.y}
  local collission = nil
  -- TODO: Max projection distance
  while not collission and distance(endPos,sourcePos) < Properties.MaximumSimulationDistance do
    local r,g,b,a = Level:getPixel(endPos.x,endPos.y)
    if a >= Properties.CollisionAlpha then
      collission = {r=r,g=g,b=b,a=a,x=endPos.x,y=endPos.y}
      break
    end
    endPos.x,endPos.y = endPos.x + aim.x,endPos.y + aim.y
  end
  
  if collission then
    projector.collisions = {collission}
    projector.Pos = {x = collission.x, y = collission.y}
    projector.Vel = {x = aim.x, y = aim.y}
    projector.Ov = {x = aim.x, y = aim.y}
    projector.isProjector = true
    Vehicle:collide(projector, true)
  end
  
  table.insert(Projection.list,
      {start={x=sourcePos.x,y=sourcePos.y},
       stop={x=endPos.x,y=endPos.y},
       startPower = firePower,
       currentPower = firePower,
       color = {r=projector.Color.r,g=projector.Color.g,b=projector.Color.b,a=projector.Color.a} } )
end

function Projection:update(dt)
  for index = #Projection.list,1,-1 do
    if Projection.list[index].currentPower <= 0 then
      table.remove(Projection.list,index)
    else
      Projection.list[index].currentPower = math.max(0,Projection.list[index].currentPower - dt * Properties.ProjectionFalloff)
    end
  end
end

function Projection:draw()
  for _,projection in ipairs(Projection.list) do
    local sx, sy = Camera:worldToScreen(projection.start.x,projection.start.y)
    local cx, cy = Camera:worldToScreen(projection.stop.x,projection.stop.y)
    local fade = projection.currentPower / projection.startPower
    love.graphics.setColor(projection.color.r,projection.color.g,projection.color.b,projection.color.a*fade)
    love.graphics.line(sx,sy,cx,cy)
  end
end