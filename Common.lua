require 'Properties'
require 'Circle'

Common = {}

-- Utilities

function arrayconcat(t1,t2)
  for _,v in ipairs(t2) do
    table.insert(t1,v)
  end
end
function clampChunkSize(x,y)
  return {x = math.max(0,math.min(Properties.ChunkSize.x-1,x)),y = math.max(0,math.min(Properties.ChunkSize.y-1,y))}
end
function clamp01(val)
  return math.max(0,math.min(1,val))
end
function clamp0255(val)
  return math.max(0,math.min(255,val))
end
function clamp(min,val,max)
  return math.max(min,math.min(max,val))
end
function rollangle(angle)
  while angle < -math.pi do
    angle = angle + math.pi + math.pi
  end
  
  while angle > math.pi do
    angle = angle - math.pi - math.pi
  end
  
  return angle
end

function dot(v1, v2)
  return v1.x * v2.x + v1.y * v2.y
end

function mag(x,y)
  return math.sqrt(x * x + y * y)
end

function distance(pos1, pos2)
  return mag(pos2.x-pos1.x,pos2.y-pos1.y)
end

function normalize(x,y)
  local vecmag = mag(x,y)
  return {x=x/vecmag,y=y/vecmag}
end

function clampMag(vec,maxmag)
  local m = mag(vec.x, vec.y)
  if m > maxmag then
    return {x = vec.x / m * maxmag, y = vec.y / m * maxmag}
  else
    return vec
  end
end

function ts( key, value, seenTables )
	local st = seenTables or {}
	if type(value) == "table" then
		if st[tostring(value)] then
			return tostring(key) .. "=" .. tostring(value)
		end

		st[tostring(value)] = 1
		local tablestring = tostring(key) .. "={"
		for skey,svalue in pairs(value) do
			tablestring = tablestring .. ts(skey,svalue,st) .. ", "
		end
		tablestring = tablestring .. "}\r\n"
		return tablestring
	else
		return tostring(key) .. "=" .. tostring(value)
	end
end


function arrayconcat(t1,t2)
  for _,v in ipairs(t2) do
    table.insert(t1,v)
  end
end

function isIn(x,y, coords)
  for _,p in ipairs(coords) do
    if x == p.x and y == p.y then
      return true
    end
  end
  return false
end

function applyPos(pos, relcoord)
  local abscoord = {}
  
  for _,c in ipairs(relcoord) do
    table.insert(abscoord,{x=c.x+pos.x,y=c.y+pos.y})
  end
  return abscoord
end

function getCircleCoords(p, r, filled)
  local pos = {x=math.floor(p.x),y=math.floor(p.y)}
  local radius = clamp(1,math.floor(r),10)
  if filled then
    return applyPos(p,Circle.fill[radius])
  else
    return applyPos(p,Circle.line[radius])
  end
end

function getLevelCollissions(thing, neighborhood)
   local pixelCoords = getCircleCoords(thing.Pos, neighborhood)
   local collisions = {}
   for _,coordinate in ipairs(pixelCoords) do
    local r,g,b,a = Level:getPixel(coordinate.x,coordinate.y)
    if a == nil then
      return {}
    end
    if a >= Properties.CollisionAlpha then
      table.insert(collisions,{r=r,g=g,b=b,a=a,x=coordinate.x,y=coordinate.y})
    end
   end
   return collisions
end

function clearVel(thing)
  thing.Vel = {x=0,y=0}
end
function applyForce(thing, force)
  thing.Force.x = thing.Force.x + force.x
  thing.Force.y = thing.Force.y + force.y
end
function clearForce(thing)
  thing.Force = {x = 0, y = 0}
end
function applyImpulse(thing, force)
  thing.Impulse.x = thing.Impulse.x + force.x
  thing.Impulse.y = thing.Impulse.y + force.y
end
function clearImpulse(thing)
  thing.Impulse = {x = 0, y = 0}
end

function toangle(x0,y0,x1,y1)
  return math.atan2(y1-y0,x1-x0)
end
function betweenangle(x0,y0,x1,y1)
  return math.atan2(y1,x1) - math.atan2(y0,x0)
end

function stepFromObstacles(thing)
  thing.Pos.x = thing.Pos.x - thing.Ov.x
  thing.Pos.y = thing.Pos.y - thing.Ov.y
end

function stepAlongMotion(thing, dt)
  normalVel = normalize(thing.Vel.x, thing.Vel.y)
  thing.Pos.x, thing.Pos.y = thing.Pos.x - normalVel.x, thing.Pos.y - normalVel.y
end

function stepBack(thing, dt)
  if mag(thing.Vel.x, thing.Vel.y) < 1 then
    stepFromObstacles(thing)
  else
    stepAlongMotion(thing, dt)
  end
end

function obstacleVector(thing, obstaclePositions)
  local sumdx, sumdy = 0,0
  
  for _, collision in ipairs(obstaclePositions) do
    sumdx = sumdx + collision.x - thing.Pos.x
    sumdy = sumdy + collision.y - thing.Pos.y
  end
  
  return normalize(sumdx,sumdy)
end

function updateObstacleVector(thing, obstacles)
  thing.Ov = obstacleVector(thing, obstacles)
end

function obstacleImpulse(thing, mass)
  local velmag = mag(thing.Vel.x, thing.Vel.y) * mass * -1
  
  if thing.Type and thing.Type == "toolVehicle" then
   velmag = velmag * (1+Properties.ToolThingRestitution)
  elseif thing.Type and thing.Type == "player" then
   velmag = velmag * (1+Properties.PlayerRestitution)
  end
  --local theta = toangle(0,0,ov.x, ov.y)
  local theta = betweenangle(thing.Vel.x, thing.Vel.y, thing.Ov.x, thing.Ov.y)
  
  return {x = (thing.Ov.x * velmag * math.cos(theta)),
          y = (thing.Ov.y * velmag * math.cos(theta))}
end
