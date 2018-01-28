require 'Properties'
require 'Common'
require 'Vehicle'

Thing = {}

Thing.list = {}

function Thing:add(thing, pos, vel)
  if pos then
    thing.Pos = {x=pos.x, y=pos.y, angle=pos.angle}
  end
  
  if vel then
    thing.Vel = {x=vel.x, y=vel.y, angle=vel.angle}
  end
  
  table.insert(Thing.list, thing)
end
function Thing:applyGravity(thing)
  thing.MassGravity = {x=Properties.Gravity.x * thing.VehicleMass, y = Properties.Gravity.y * thing.VehicleMass}
end
function Thing:addPlayerThing(thing, pos, vel, id)
  
  thing.Pos = {x = pos.x, y = pos.y, angle = 0}  
  thing.Vel = {x = vel.x, y = vel.y, angle = 0}
  thing.Force = {x = 0, y = 0}
  thing.Impulse = {x = 0, y = 0}
  
  thing.Color = {r=0,g=255,b=0,a=255}
  
  thing.Type = "player"
  thing.Id = id -- Important: used as key for trigger commands!
  thing.VehicleMass = Properties.PlayerMass
  thing.Radius = Properties.PlayerRadius
  thing.CrossSection = thing.Radius * thing.Radius
  thing.DeviceSpeed = Properties.PlayerCrawlSpeed
  Thing:applyGravity(thing)
  Thing:add(thing, pos, vel)
end
function Thing:addToolThing(tool, pos, vel, isPowered)
  local thing = {}
  
  thing.Pos = {x = x, y = y, angle = 0}  
  thing.Vel = {x = 0, y = 0, angle = 0}
  thing.Force = {x = 0, y = 0}
  thing.Impulse = {x = 0, y = 0}
  
  thing.Operation = tool.Operation
  thing.Effector = tool.Effector
  thing.VehicleAttribute = tool.VehicleAttribute
  thing.Special = tool.Special
  
  thing.OperationStrength = tool.OperationStrength
  thing.EffectorSize = tool.EffectorSize
  thing.VehicleTime = tool.VehicleTime
  thing.SpecialPower = tool.SpecialPower
  thing.DeviceSpeed = tool.DeviceSpeed

  thing.VehicleMass = tool.VehicleMass
  thing.Radius = Properties.ToolThingRadius
  
  thing.VehicleSize = tool.VehicleSize -- TODO: hang on, why is there a radius and vehiclesize?
  
  thing.Color = tool.Color
  
  if isPowered then
    if tool.Powermod == "OperationStrength" then
      thing.OperationStrength = thing.OperationStrength * Properties.PowerFactor
    elseif tool.Powermod == "EffectorSize" then
      thing.EffectorSize = thing.EffectorSize * Properties.PowerFactor
    elseif tool.Powermod == "VehicleTime" then
      thing.VehicleTime = thing.VehicleTime * Properties.PowerFactor  -- counts down
    elseif tool.Powermod == "SpecialPower" then
      thing.SpecialPower = thing.SpecialPower * Properties.PowerFactor
    elseif tool.Powermod == "VehicleMass" then
      thing.VehicleMass = thing.VehicleMass * Properties.PowerFactor
    elseif tool.Powermod == "VehicleSize" then
      thing.VehicleSize = thing.VehicleSize * Properties.PowerFactor
    end
  end
  
  thing.CrossSection = thing.VehicleSize * thing.VehicleSize
  
  if thing.VehicleAttribute == "Contact-trigger" then
    thing.VehicleTime = nil -- no timer on contact triggers
  end
  
  if tool.Special == "Emitter" then
    thing.Emitter = { rate = thing.SpecialPower * Properties.EmitterRate, timer = 0 }
  end
  
  
  thing.Type = "toolVehicle"
  thing.ToolName = tool.Name -- Important: used as key for trigger commands! (TODO?)_
  
  Thing:applyGravity(thing)
  Thing:add(thing, pos, vel)
end
local function updateFreefall(thing, dt, wind)
  local windDiff = {x = wind.x - thing.Vel.x, y = wind.y - thing.Vel.y}
  local force = {x = thing.Force.x + windDiff.x * thing.CrossSection * Properties.AirViscosity + thing.MassGravity.x, 
                 y = thing.Force.y + windDiff.y * thing.CrossSection * Properties.AirViscosity + thing.MassGravity.y}
  thing.Vel.x = thing.Vel.x + (force.x / thing.VehicleMass * dt) + thing.Impulse.x/thing.VehicleMass 
  thing.Vel.y = thing.Vel.y + (force.y / thing.VehicleMass * dt) + thing.Impulse.y/thing.VehicleMass
  thing.Vel = clampMag(thing.Vel,Properties.MaxVelocity)
  
  thing.Impulse.x, thing.Impulse.y = 0,0  
  
  thing.Pos.x = thing.Pos.x + (thing.Vel.x * dt)
  thing.Pos.y = thing.Pos.y + (thing.Vel.y * dt)
end
local function solveFreefall(thing, dt)
  thing.Ov = nil
  
  local collisions = getLevelCollissions(thing,thing.Radius)
  
  local collided = #collisions > 0
  if collided then
    updateObstacleVector(thing, collisions)
    local of = obstacleImpulse(thing, thing.VehicleMass)
    applyImpulse(thing,of)
    
    while #collisions > 0 do
      thing.collisions = {unpack(collisions)}
      updateObstacleVector(thing, collisions)
      stepFromObstacles(thing)
      collisions = getLevelCollissions(thing,thing.Radius)
    end
  end
  if collided then
    if thing.Type == "toolVehicle" then
      collide = Vehicle:collide(thing, true)
    end
  end
end

local function updateCrawling(thing, dt)
  if thing.crawling then    
  -- sign is positive when going right
    local sign = thing.FacingRight and -1 or 1
    
    -- scan for a "side" pixel from the obstacle vector "pixel"    
    -- theta goes from obstacle vector angle to its opposite.
    local origin = {x = thing.Pos.x + thing.Ov.x*thing.Radius, y = thing.Pos.y + thing.Ov.y*thing.Radius}
    local thetaDown = math.atan2(thing.Ov.y, thing.Ov.x)
    local thetaUp = thetaDown + math.pi * sign
    for theta = thetaDown, thetaUp, Properties.PlayerCrawlScanStep * sign do
      local px = {x = origin.x + Properties.PlayerStepWidth * math.cos(theta),
                  y = origin.y + Properties.PlayerStepWidth * math.sin(theta)}
      local _,_,_,a = Level:getPixel(px.x,px.y)
      
      if a < Properties.CollisionAlpha then
        thing.Pos.x = thing.Pos.x + thing.DeviceSpeed * math.cos(theta) 
        thing.Pos.y = thing.Pos.y + thing.DeviceSpeed * math.sin(theta)
        break
      end
    end
    
    if thing.Type == "toolVehicle"  and thing.VehicleAttribute == "Contact-trigger" then
      collide = Vehicle:collide(thing, true)
    end
    
  end
end

local function solveCrawling(thing, dt)
  local collisions = getLevelCollissions(thing,thing.Radius)
  
  if #collisions > 0 then  
    while #collisions > 0 do
      thing.collisions = {unpack(collisions)}
      updateObstacleVector(thing, collisions)
      stepFromObstacles(thing)
      collisions = getLevelCollissions(thing,thing.Radius)
    end
  end
end
local function cleanup()
  for index = #Thing.list,1,-1 do
    -- TODO: instead of removing things past simdistance, just persist them
    if Thing.list[index].removeThis or distance(Thing.list[index].Pos, Player.Pos) > Properties.MaximumSimulationDistance then
      table.remove(Thing.list,index)
    end
  end
end

local function updateEmitter(thing, dt)
  if thing.Emitter then
    thing.Emitter.timer = thing.Emitter.timer + dt
    
    if thing.Emitter.timer > Properties.EmitterPeriod then
      local periods = thing.Emitter.timer / Properties.EmitterPeriod
      local emissions = thing.Emitter.rate * periods
      Tool:makeChildren(thing, emissions, false, Properties.EmittedToolThingSize, Properties.EmitterSpread)
      thing.Emitter.timer = 0
    end
  end
end

local function updateSticking(thing)
  if thing.sticking then
    thing.sticking = false
    for _,c in ipairs(thing.collisions) do
      -- TODO: stickiness should have to do with crawlresist and some intrinsic 'stick-ability' value.
      local r,g,b,a = Level:getPixel(c.x,c.y)
      if a >= Properties.CollisionAlpha then
        thing.sticking = true
        break
      end
    end
  end
end
function Thing:update(dt, wind)
  print("#things = "..#Thing.list)
  for _,thing in ipairs(Thing.list) do
    updateEmitter(thing, dt)
    if thing.VehicleTime then
      thing.VehicleTime = thing.VehicleTime - dt
      if thing.VehicleTime < 0 then
	--thing.VehicleAttribute = "Contact-trigger"
	--thing.VehicleTime = nil
	--thing.Lifetime = Properties.VehicleTimeGrace -- TODO: derive lifetime value from initial VehicleTime?
         Vehicle:collide(thing) -- TODO: Evaluate if swapping the collide with a contact-trigger is better?
         thing.removeThis = true
      end
    end
    if thing.Lifetime then
      thing.Lifetime = thing.Lifetime - dt
      if thing.Lifetime < 0 then
        thing.removeThis = true
      end
    end
    --	thing.Lifetime = Properties.VehicleLifetime -- TODO: Why was this here?
    
    updateSticking(thing)
    if not thing.sticking then
      updateFreefall(thing, dt, wind)
      solveFreefall(thing, dt)
    else
      updateCrawling(thing, dt)
      solveCrawling(thing, dt)
    end
  end
  cleanup()
end

function Thing:draw()
  for _,thing in ipairs(Thing.list) do
    if thing.Color then
      love.graphics.setColor(thing.Color.r,thing.Color.g,thing.Color.b,thing.Color.a)
    else
      love.graphics.setColor(0,0,0,255)
    end
    local cx,cy = Camera:worldToScreen(thing.Pos.x,thing.Pos.y)
    love.graphics.circle('fill',cx,cy,thing.Radius,10)
  end
end

function Thing:trigger(toolname)
  for _,thing in ipairs(Thing.list) do
    if thing.ToolName and thing.ToolName == toolname then
      print("manual trigger!")
      Vehicle:collide(thing)
      thing.removeThis = true
    end
  end
end
