require 'Properties'
require 'Common'

Grapple = { Chain = {},
            FireVector = {},
            State = "idle" }
   

local function addChainLink(pos, isHead)
  local power = Grapple.Powered and 1 or (Properties.GrappleFireTime - Grapple.fireTime)
  
  table.insert(Grapple.Chain,{Pos = {x=pos.x,y=pos.y}, 
                              Vel = {x=Grapple.FireVector.x * power, 
                                     y = Grapple.FireVector.y * power },
                              IsHead = isHead or false,
                              Length = #Grapple.Chain == 0 and 0 or distance(pos, Grapple.Chain[#Grapple.Chain].Pos),
                              Impulse = {x=0,y=0} } )
                                     
end
local function chainlength()
  local length = 0
  for link = 2, #(Grapple.Chain) do
    length = length + distance(Grapple.Chain[link].Pos,Grapple.Chain[link-1].Pos)
  end
  return length
end

function Grapple:initialize()
  Grapple.State = "idle"
  Grapple.Chain = {} 
  Grapple.FireVector = {}
end

function Grapple:fire(pos, vel, powered)
  print('firing!')
  Grapple.fireTime = 0
  Grapple.Chain = {}
  Grapple.FireVector.x, Grapple.FireVector.y = vel.x, vel.y
  Grapple.Powered = powered
  Grapple.State = "firing"
  addChainLink(pos, nil, true)
end
local function addConditionalChainLink(pos)
  if(distance(pos, Grapple.Chain[#(Grapple.Chain)].Pos) > Properties.GrappleChainLinkLength) and
    Grapple.fireTime < Properties.GrappleFireTime then
    addChainLink(pos)
  end
end

local function attach(links)
  for _,link in ipairs(links) do
    link.Colliding = true
  end
end

local function isColliding(link)
  local r,g,b,a = Level:getPixel(link.Pos.x,link.Pos.y)
  return a > Properties.CollisionAlpha
end

local function addChainLinkCollissions(link, linkcollissions)
  if isColliding(link) then
    table.insert(linkcollissions,link)
  end
end

local function getChainLinkCollissions()
  local collisions = {}
  for index,link in ipairs(Grapple.Chain) do
    if index > 1 then
      addChainLinkCollissions(link, collisions)
    end
  end
  return collisions
end

local function updateWhileFiring(dt)
  Grapple.fireTime = Grapple.fireTime + dt
  addConditionalChainLink(Player.Pos)
  
end
 
local function updateGrappleState(collisions)
  if Properties.GrappleChainMaxLength <= chainlength() or
    Grapple.fireTime >= Properties.GrappleFireTime or 
    #collisions > 0 then
    Grapple.State = "extended"
  end
end
local function updateCollissions()
  -- test for collission
  local collisions = getChainLinkCollissions()
  
  if #collisions > 0 then
    attach(collisions)
  end
  
  updateGrappleState(collisions)
end

local function updateVel(link)
  link.Vel.x = link.Vel.x  + link.Impulse.x/Properties.GrappleChainLinkMass
  link.Vel.y = link.Vel.y  + link.Impulse.y/Properties.GrappleChainLinkMass
  clearImpulse(link)
end

local function integrateChainlink(dt)
  if Grapple.State ~= "idle" then
    -- update chainlink positions
    for index,link in ipairs(Grapple.Chain) do
      if index ~= 1 or not link.Colliding then
        updateVel(link)
        link.Pos.x, link.Pos.y = link.Pos.x + link.Vel.x * dt, link.Pos.y + link.Vel.y * dt
      end
    end
  end
end


local function constrainChainlink(dt)
  local d = 0
  local velDifference = {}
  local posDifference = {}
  local posNormal = {}
  for index, link2 in ipairs(Grapple.Chain) do
    if index > 1 then
      local link1 = Grapple.Chain[index-1]
      d = distance(link1.Pos, link2.Pos)
      if d > link2.Length then
        velDifference.x, velDifference.y = link2.Vel.x - link1.Vel.x, link2.Vel.y - link1.Vel.y
        posDifference.x, posDifference.y = link2.Pos.x - link1.Pos.x, link2.Pos.y - link1.Pos.y
        posNormal = normalize(posDifference.x, posDifference.y)
        
        --local r1 = mag(velDifference.x, velDifference.y) + (d-link2.Length)
        local r1 = (d-link2.Length)
        local r = r1 / (2 * Properties.GrappleChainLinkMass)
        
        print(ts(".",{d=d,l2l=link2.Length,vd=velDifference,pd=posDifference,pn=posNormal,r1=r1,r2=r}))
        if index == 2 and link1.Colliding then
          print("hook is hooked")
          local imp2 = {x=posNormal.x * r, y = posNormal.y * r}
          applyImpulse(link2,imp2)
          applyImpulse(link2,imp2)
        else
          local imp1 = {x=-posNormal.x * r, y = -posNormal.y * r}
          local imp2 = {x=posNormal.x * r, y = posNormal.y * r}
          applyImpulse(link1,imp1)
          applyImpulse(link2,imp2)
        end
      end
    end
  end
end

local function chainlinkForces(dt)
  for index,link in ipairs(Grapple.Chain) do
    link.Vel.x, link.Vel.y = link.Vel.x + Properties.Gravity.x * dt, link.Vel.y + Properties.Gravity.y * dt
  end
end

local function solveChainlink()
  for index,link in ipairs(Grapple.Chain) do
    if index > 1 then
      if link.Colliding then
        local collisions = getLevelCollissions(link,Properties.LinkNeighborhood)
        updateObstacleVector(link, collisions)
        local of = obstacleImpulse(link, Properties.GrappleChainLinkMass)
        applyImpulse(link,of)
      end
      while link.Colliding do
        local collisions = getLevelCollissions(link,Properties.LinkNeighborhood)
        updateObstacleVector(link, collisions)
        stepFromObstacles(link)
        link.Colliding = isColliding(link)
      end
    end
  end
end

local function updateWhileExtended(dt)
  chainlinkForces(dt)
  updateCollissions()
  solveChainlink()
  constrainChainlink(dt)
  integrateChainlink(dt)
end

local function cleanup()
  for index,link in ipairs(Grapple.Chain) do
    if distance(link.Pos, Player.Pos) > Properties.MaximumSimulationDistance then
      Grapple:initialize()
    end
  end
end
function Grapple:update(dt)
  
  if Grapple.State == "firing" then
    updateWhileFiring(dt)
  end
  
  if Grapple.State ~= "idle" then
    updateWhileExtended(dt)
  end
  
  cleanup()
  
end

local function chainscreencoordinates()
  local coords = {}
  for _,link in ipairs(Grapple.Chain) do
    local cx, cy = Camera:worldToScreen(link.Pos.x,link.Pos.y)
    table.insert(coords,cx)
    table.insert(coords,cy)
  end
  return unpack(coords)
end

function Grapple:draw()
  if Grapple.State == "firing" and #(Grapple.Chain) > 1 then
    --love.graphics.setColor(255,255,255,255)
    --local cx,cy = Camera:worldToScreen(Grapple.Pos.x,Grapple.Pos.y)
    --love.graphics.circle('fill',cx,cy,Properties.GrappleDrawRadius,10)

    love.graphics.setColor(0,Grapple.Powered and 127 or 0,0,255)
    love.graphics.line(chainscreencoordinates())
    love.graphics.setColor(255,255,255,255)
    love.graphics.points(chainscreencoordinates())
  elseif Grapple.State == "extended" and #(Grapple.Chain) > 1 then
    love.graphics.setColor(0,Grapple.Powered and 127 or 0,255,255)
    love.graphics.line(chainscreencoordinates())
    love.graphics.setColor(255,255,255,255)
    love.graphics.points(chainscreencoordinates())
  end
    
end
