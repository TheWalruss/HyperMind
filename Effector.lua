require 'Properties'
require 'Probe'
require 'Annihilator'
require 'Converter'
require 'Dilator'
require 'Fizzle'
require 'Harvester'
require 'Extruder'
require 'Level'

Effector = {}

local function tag(effector)
  if effector.Operation == "Probe" then
    Probe:tag(effector)
  elseif effector.Operation == "Annihilator" then
    Annihilator:tag(effector)
  elseif effector.Operation == "Harvester" then
    Harvester:tag(effector)
  elseif effector.Operation == "Converter" then
    Converter:tag(effector)
  elseif effector.Operation == "Dilator" then
    Dilator:tag(effector)
  elseif effector.Operation == "Extruder" then
    Extruder:tag(effector)
  end
end

local function sphereAround(center, effector)
  local sphere = getCircleCoords(center, effector.EffectorSize, true)
  return {center,unpack(sphere)}
end

local function blastAround(center, effector)
  --TODO blast
  return {center}
end

function Effector:doEffect(effector)
  local effective = false
  
  if effector.collisions then
    if effector.Effector == "Precision" then
      local x,y = effector.collisions[1].x, effector.collisions[1].y
      local r,g,b,a = Level:getPixel(x,y)
      effector.collisions = {{x=x,y=y,r=r,g=g,b=b,a=a}}
    else
      for _,c in ipairs(effector.collisions) do
        local material = Materials:GetMaterial(c.r, c.g, c.b, c.a)
        if material and material.triggerresist <= effector.OperationStrength then
          effector.collisions = {c}
          break
        end
      end
    end
  else
    local x,y = effector.Pos.x,effector.Pos.y
    local r,g,b,a = Level:getPixel(x,y)
    effector.collisions = {{x=x,y=y,r=r,g=g,b=b,a=a}}
  end
  
  if #(effector.collisions) == 1 then
    effective = true
  end
  
  if effector.Effector == "Precision" then
    tag(effector) 
  elseif effector.Effector == "Sphere" then
    effector.collisions = sphereAround(effector.collisions[1],effector)
    tag(effector) 
  elseif effector.Effector == "Blast" then
    effector.collisions = blastAround(effector.collisions[1],effector)
    tag(effector) 
  end
  
  return effective
end

