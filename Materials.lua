require 'Properties'

local function materialIndex(r,g,b) 
  return r + g * Properties.MaterialLevels + b * Properties.MaterialLevels * Properties.MaterialLevels
end

 materialNames = {rg= {"crystalline", "amorphous", "conglomerate", "igneous", "polished", "metallic", "native"},
                       gb= {"shal", "pyr", "jasper", "beryl", "op", "fluor", "asgard"},
                       br= {"ite", "oclase", "yst", "al", "um", "ald", "uoise"} }
                       
 function generateMaterialName(r,g,b)
  return materialNames.rg[r+g+1].." "..materialNames.gb[g+b+1]..materialNames.br[b+r+1]
end

Materials = { list = {} }

function Materials:getHardness(r,g,b,a)
  return a >= Properties.CollisionAlpha and r*r or 0
end

function Materials:getTriggerResist(r,g,b,a)
  return a >= Properties.CollisionAlpha and g*b or 0
end

function Materials:getGrappleResist(r,g,b,a)
  return a >= Properties.CollisionAlpha and g*g or 0
end
function Materials:getCrawlResist(r,g,b,a)
  return a >= Properties.CollisionAlpha and b*b or 0
end
function Materials:getDensity(r,g,b,a)
  return a >= Properties.CollisionAlpha and r+g+b + 1 or 0
end
local function generateMaterials()
  local list = {}
  local a = 255
  for r = 0, Properties.MaterialLevels do
    for g = 0, Properties.MaterialLevels do
      for b = 0, Properties.MaterialLevels do
        local material = {}
        material.hardness = Materials:getHardness(r,g,b,a)
        material.triggerresist = Materials:getTriggerResist(r,g,b,a)
        material.grappleresist = Materials:getGrappleResist(r,g,b,a)
        material.crawlresist = Materials:getCrawlResist(r,g,b,a)
        material.density = Materials:getDensity(r,g,b,a)
        material.name = generateMaterialName(r,g,b)
        list[materialIndex(r,g,b)] = material
      end
    end
  end
  return list
end


function Materials:Initialize()
  Materials.list = generateMaterials()
end

function Materials:GetMaterial(r,g,b,a)
  if not a or a < Properties.CollisionAlpha then
    return
  end
  r, g, b, a = math.floor(r / (255 / Properties.MaterialLevels)), 
              math.floor(g / (255 / Properties.MaterialLevels)), 
              math.floor(b / (255 / Properties.MaterialLevels)), 
              math.floor(a / (255 /Properties.MaterialLevels))
  local materialIndex = materialIndex(r,g,b)
  return Materials.list[materialIndex]
end

