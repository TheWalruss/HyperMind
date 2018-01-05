require 'Properties'
require 'Effector'
require 'Materials'

Vehicle = {}

local function doEffect(vehicle)
  if Effector:doEffect(vehicle) then
    vehicle.removeThis = true
  end
end

local function stickTo(vehicle, material)
  vehicle.sticking = true
  
  if vehicle.VehicleAttribute == "Spider" then
    vehicle.crawling = true
    local angle = betweenangle(vehicle.Vel.x, vehicle.Vel.y, vehicle.Ov.x, vehicle.Ov.y)
    vehicle.FacingRight = angle > 0
  end
  
  vehicle.Vel = {x=0,y=0}
end

local function doStick(vehicle)
  if vehicle.collisions then
    for _,c in ipairs(vehicle.collisions) do
      local material = Materials:GetMaterial(c.r, c.g, c.b, c.a)
      -- TODO: stickiness and VehicleMaxPower is pretty tenuous... find something better here? Better than VehicleTime anyway...
      if material and material.crawlresist <= vehicle.VehicleMass then
        stickTo(vehicle, material)
        break
      end
    end
  end
end

function Vehicle:collide(vehicle,terrain)
  if vehicle.Special == "Cascade" then
    local emissions = vehicle.SpecialPower * Properties.CascadeNumber
    Tool:makeChildren(vehicle, emissions, terrain, Properties.CascadedToolThingSize, Properties.CascadeSpread)
    doEffect(vehicle)
    return
  end
  
  if (not vehicle.isProjector) and
     (terrain and (vehicle.VehicleAttribute == "Sticky" or 
                  vehicle.VehicleAttribute == "Spider") ) then
    doStick(vehicle)
  elseif vehicle.isProjector or 
    (vehicle.VehicleAttribute ~= "Timed") then
    doEffect(vehicle)
  end    
end
