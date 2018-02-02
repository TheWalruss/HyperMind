require 'Properties'

local function materialIndex(r,g,b) 
  return r + g * Properties.MaterialLevels + b * Properties.MaterialLevels * Properties.MaterialLevels
end

-- red: happiness { "despair", "sadness", "melancholy",    "nothing", "      "contentedness",   "happiness", "euphoria" }
-- green: passion { "rage",      "anger",    "disapproval",    "ambivalence", "approval",           "love",           "obsession"
-- blue: fear {         "terror",   "fear",       "apprehension", "uncertainty",   "comfort",            "confidence", "certainty"} --are these better?

--redNames = { {"terror", "terrorizing"}, {"fear", "fearful"}, {"uncertainty","uncertain"}, {"hope", "hopeful"}, {"joy", "joyful"} }
--greenNames = { {"disgust", "disgusting"}, {"dislike", "disliking"}, {"ambivalence", "ambivalent"}, {"approval", "liking"}, {"love","loving"} }
--blueNames = { {"hate","hateful"}, {"concern", "concerning"}, {"indifference", "indifferent"}, {"curiousity", "curious"}, {"enthousiasm", "enthousiastic"}}

blueNames = { {"despair", "despairing"}, {"unhappiness", "unhappy"}, {"ambivalence", "ambivalent"}, {"happiness", "happy"}, {"euphoria", "euphoric"}}
greenNames = { { "terror", "terrorizing"}, {"fear", "fearful"}, {"numbness", "numbing"}, {"confidence","confident"},{"certainty","certain"}}
redNames = {{"rage", "raging"}, {"anger","angry"},{"indifference","indifferent"}, {"passion", "passionate"}, {"love","loving"}}

                       
 -- Assuming r g and b are strictly ordered, then the strongest word goes last (as a noun), the second strongest goes first (adjective, primacy effect),
 -- and the weakest goes last. If the weakest thing is uncertain, ambivalent, or indifferent, then forgetaboutit.
 function generateMaterialName(r,g,b)
   local offset = Properties.MaterialLevels/2
   local rabs, gabs, babs = math.abs(r - offset),math.abs(g - offset),math.abs(b - offset)
  if rabs > gabs then
    if babs > gabs then
    --  r > b > g
      if gabs ~= 0 then
        return blueNames[r+1][2].." "..greenNames[g+1][2].." "..redNames[b+1][1]
      else
        return blueNames[r+1][2].." "..redNames[b+1][1]
      end
    else
    -- r > g > b
      if babs ~= 0 then
        return greenNames[r+1][2].." "..blueNames[g+1][2].." "..redNames[b+1][1]
      else
        return greenNames[r+1][2].." "..redNames[b+1][1]
      end
    end
  else
    if babs > gabs then
     -- b > g > r
      if rabs ~= 0 then
        return greenNames[r+1][2].." "..redNames[g+1][2].." "..blueNames[b+1][1]
      else
        return greenNames[r+1][2].." "..blueNames[b+1][1]
      end
    else
     -- g > b > r
      if rabs ~= 0 then
        return blueNames[r+1][2].." "..redNames[g+1][2].." "..greenNames[b+1][1]
      else
        return blueNames[r+1][2].." "..greenNames[b+1][1]
      end
    end
  end
      
  return "ERROR:  "..tostring(r)..", "..tostring(g)..", "..tostring(b)
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

