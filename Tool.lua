require 'Properties'
require 'Thing'
require 'Probe'
require 'Projection'

Tool = {}

local function fireGrapple(imp)
  print("Firing")
  local grappleVel = {x = imp.x + Player.Vel.x, y = imp.y + Player.Vel.y}
  Grapple:fire(Player.Pos,grappleVel, Player.Powered)
  Player.GrapplePower = 0
  updateState("grappling")
end

local function powerShotMod(tool, firePower, isPowered)
  if not isPowered then
    return firePower
  end
  
  if tool.Powermod == "VehicleMaxPower" then
    firePower = firePower * Properties.PowerFactor
  elseif tool.TriggerTime and tool.Powermod == "VehicleTime" then
    tool.TriggerTime = tool.TriggerTime * Properties.PowerFactor
  end
  
  return firePower
end

local function singleShotMod(tool)
  if tool.Reloadperiod ~= "Single-Use" then
    return
  end
  tool.OperationStrength = tool.OperationStrength * Properties.SingleUseFactor
  tool.EffectorSize = tool.EffectorSize * Properties.SingleUseFactor
  tool.VehicleTime = tool.VehicleTime * Properties.SingleUseFactor
  tool.SpecialPower = tool.SpecialPower * Properties.SingleUseFactor
end

local function fireProjection(tool, aim, isPowered, sourcePos, firePowerfactor)
  local firePower = tool.VehicleMaxPower
  if isPowered and tool.Powermod == "VehicleMaxPower" then
    firePower = firePower * Properties.PowerFactor
  end
  singleShotMod(tool)
  firePower = firePower * firePowerfactor
  Projection:fire(tool, sourcePos, aim, firePower)
end

local function fireProjectile(tool, aim, isPowered, sourcePos, sourceVel, firePowerfactor)
  local firePower = 0
  
  if tool.VehicleAttribute ~= "Contact-trigger" then
    tool.TriggerTime = tool.VehicleTime
  else
    tool.Lifetime = Properties.VehicleLifetime
  end
  if tool.Vehicle == "Thrown" then
    firePower = tool.ThrownCharge or 1
  else
    firePower = tool.VehicleMaxPower or 1
  end
  firePower = powerShotMod(tool, firePower, isPowered)
  singleShotMod(tool)
  firePower = firePower * Properties.ToolThingLaunchPower
  
  if tool.Reloadperiod == "Single-Use" then
    firePower = firePower * Properties.SingleUseFactor
  end
  
  firePower = firePower * firePowerfactor
  
  local fireVel = {x = aim.x * firePower + sourceVel.x,
                   y = aim.y * firePower + sourceVel.y}
  Thing:addToolThing(tool, sourcePos, fireVel, isPowered)                  
end

local function resetReadyTimer(tool)
  tool.readyTimer = (tool.Reloadperiod == "Standard") and Properties.StandardReloadTime or Properties.FastReloadTime
end

local function fireShot(tool, aim, isPowered, sourcePos, sourceVel, firePowerfactor)
  if tool.Vehicle == "Projection" then
    fireProjection(tool, aim, isPowered, sourcePos, firePowerfactor)
  else
    fireProjectile(tool, aim, isPowered, sourcePos, sourceVel, firePowerfactor)
  end
end

function Tool:fire(tool, aim, isPowered, sourcePos, sourceVel)
  print('fire!')
  tool.readyToUse = false
  resetReadyTimer(tool)
  
  if tool.Firemode == "Burst" then
    for shot = 1, Properties.BurstModeShots do
      local shotx, shoty = aim.x + love.math.randomNormal(Properties.BurstSpread,0), aim.y + love.math.randomNormal(Properties.BurstSpread,0)
      fireShot(tool, {x=shotx,y=shoty}, isPowered, sourcePos, sourceVel, 1)
    end
  else
    fireShot(tool, aim, isPowered, sourcePos, sourceVel, 1)
  end
end

function Tool:makeChildren(tool, number, terrain, sizeFactor, spread)
  local stash = {special = tool.Special, 
                 firemode = tool.Firemode,
                 effectorSize = tool.EffectorSize,
		 vehicleTime = tool.VehicleTime}
  tool.Special = "Standard"
  tool.Firemode = "Semi-automatic"
  tool.EffectorSize = math.ceil(tool.EffectorSize * sizeFactor)
  tool.VehicleTime = tool.VehicleTime and tool.VehicleTime / 2 -- TODO: evaluate if this makes emitter particles properly ephemeral
  
  
  -- if terrain then aim is opposite Ov. Else aim is opposite current velocity.
  -- if terrain then sourceVel is zero, else sourceVel is current velocity.
  local aim = {x=-tool.Vel.x,y=-tool.Vel.y}
  local sourceVel = {x=tool.Vel.x, y=tool.Vel.y}
  local sourcePos = {x=tool.Pos.x, y=tool.Pos.y}
  if terrain then
    aim = {x = -tool.Ov.x, y = -tool.Ov.y }
    sourceVel = {x=0, y=0}
  end
  
  for i = 1, number do
    if tool.Vehicle == "Projection" then
    --  aim.x, aim.y = -aim.x, -aim.y
    end
    local shotx = aim.x + love.math.randomNormal(spread,0)
    local shoty = aim.y + love.math.randomNormal(spread,0)
    fireShot(tool, {x=shotx,y=shoty}, false, sourcePos, sourceVel, love.math.randomNormal(spread,1))
  end
  
  tool.Special = stash.special
  tool.Firemode = stash.firemode
  tool.EffectorSize = stash.effectorSize
  tool.VehicleTime = stash.vehicleTime
end

local function limitThrownCharge(tool, isPowered)
  local maxPower = tool.VehicleMaxPower
  if isPowered and tool.Powermod == "VehicleMaxPower" then
    maxPower = maxPower * Properties.PowerFactor
  end
  tool.ThrownCharge = math.min(maxPower,tool.ThrownCharge)
end

function Tool:updateControl(tool, useControl, triggerControl, dt, aim, isPowered, sourcePos, sourceVel)
  if useControl and tool.readyToUse then
    if tool.Vehicle ~= "Thrown" then
      Tool:fire(tool, aim, isPowered, sourcePos, sourceVel)
    else
      if not tool.ThrownCharge then
        tool.ThrownCharge = 0
      end
      tool.ThrownCharge = tool.ThrownCharge + dt
      limitThrownCharge(tool, isPowered)
    end
  end
  
  if (not useControl) and tool.readyToUse and tool.Vehicle == "Thrown" and tool.ThrownCharge and tool.ThrownCharge > 0 then
    Tool:fire(tool, aim, isPowered, sourcePos, sourceVel)
    tool.ThrownCharge = 0
  end
  
  if tool.readyTimer then
    tool.readyTimer = tool.readyTimer - dt
  
    if not tool.readyToUse and tool.readyTimer <= 0 and tool.Reloadperiod ~= "Single-Use" then
      if tool.Firemode == "Automatic" or not useControl then
        tool.readyToUse = true
      end
    end
  end
  
  if triggerControl and tool.Special == "Manual-trigger" then
    -- go through all the Things and trigger
    Thing:trigger(tool.Name)
  end
end
