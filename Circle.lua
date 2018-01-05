require 'Properties'

Circle = {}

local function circle10()
  local coords = {{x=10, y=0},
  
                  {x=10, y=-1},
                  {x=10, y=-2},
                  {x=9, y=-3},
                  {x=9, y=-4},
                  {x=8, y=-5},
                  {x=8, y=-6},
                  {x=7, y=-7},
                  {x=6, y=-8},
                  {x=5, y=-8},
                  {x=4, y=-9},
                  {x=3, y=-9},
                  {x=2, y=-10},
                  {x=1, y=-10},
  
                  {x=0, y=-10},
  
                  {x=-10, y=-1},
                  {x=-10, y=-2},
                  {x=-9, y=-3},
                  {x=-9, y=-4},
                  {x=-8, y=-5},
                  {x=-8, y=-6},
                  {x=-7, y=-7},
                  {x=-6, y=-8},
                  {x=-5, y=-8},
                  {x=-4, y=-9},
                  {x=-3, y=-9},
                  {x=-2, y=-10},
                  {x=-1, y=-10},
  
                  {x=0, y=10},
  
                  {x=10, y=1},
                  {x=10, y=2},
                  {x=9, y=3},
                  {x=9, y=4},
                  {x=8, y=5},
                  {x=8, y=6},
                  {x=7, y=7},
                  {x=6, y=8},
                  {x=5, y=8},
                  {x=4, y=9},
                  {x=3, y=9},
                  {x=2, y=10},
                  {x=1, y=10},
  
                  {x=-10, y=0},
  
                  {x=-10, y=1},
                  {x=-10, y=2},
                  {x=-9, y=3},
                  {x=-9, y=4},
                  {x=-8, y=5},
                  {x=-8, y=6},
                  {x=-7, y=7},
                  {x=-6, y=8},
                  {x=-5, y=8},
                  {x=-4, y=9},
                  {x=-3, y=9},
                  {x=-2, y=9},
                  {x=-1, y=9} }
  
  return coords
end
local function circle9()
  local coords = {{x=9, y=0},
  
                  {x=9, y=-1},
                  {x=9, y=-2},
                  {x=8, y=-3},
                  {x=8, y=-4},
                  {x=7, y=-5},
                  {x=6, y=-6},
                  {x=5, y=-7},
                  {x=4, y=-8},
                  {x=3, y=-8},
                  {x=2, y=-9},
                  {x=1, y=-9},
  
                  {x=0, y=-9},
  
                  {x=-9, y=-1},
                  {x=-9, y=-2},
                  {x=-8, y=-3},
                  {x=-8, y=-4},
                  {x=-7, y=-5},
                  {x=-6, y=-6},
                  {x=-5, y=-7},
                  {x=-4, y=-8},
                  {x=-3, y=-8},
                  {x=-2, y=-9},
                  {x=-1, y=-9},
  
                  {x=0, y=9},
  
                  {x=9, y=1},
                  {x=9, y=2},
                  {x=8, y=3},
                  {x=8, y=4},
                  {x=7, y=5},
                  {x=6, y=6},
                  {x=5, y=7},
                  {x=4, y=8},
                  {x=3, y=8},
                  {x=2, y=9},
                  {x=1, y=9},
  
                  {x=-9, y=0},
  
                  {x=-9, y=1},
                  {x=-9, y=2},
                  {x=-8, y=3},
                  {x=-8, y=4},
                  {x=-7, y=5},
                  {x=-6, y=6},
                  {x=-5, y=7},
                  {x=-4, y=8},
                  {x=-3, y=8},
                  {x=-2, y=9},
                  {x=-1, y=9} }
  
  return coords
end
local function circle8()

  local coords = {{x=8, y=0},
                  {x=8, y=-1},
                  {x=8, y=-2},
                  {x=7, y=-3},
                  {x=7, y=-4},
                  {x=6, y=-5},
                  {x=5, y=-6},
                  {x=4, y=-7},
                  {x=3, y=-7},
                  {x=2, y=-8},
                  {x=1, y=-8},
  
                  {x=0, y=-8},
  
                  {x=-8, y=-1},
                  {x=-8, y=-2},
                  {x=-7, y=-3},
                  {x=-7, y=-4},
                  {x=-6, y=-5},
                  {x=-5, y=-6},
                  {x=-4, y=-7},
                  {x=-3, y=-7},
                  {x=-2, y=-8},
                  {x=-1, y=-8},
  
                  {x=0, y=8},
  
                  {x=8, y=1},
                  {x=8, y=2},
                  {x=7, y=3},
                  {x=7, y=4},
                  {x=6, y=5},
                  {x=5, y=6},
                  {x=4, y=7},
                  {x=3, y=7},
                  {x=2, y=8},
                  {x=1, y=8},
  
                  {x=-8, y=0},
  
                  {x=-8, y=1},
                  {x=-8, y=2},
                  {x=-7, y=3},
                  {x=-7, y=4},
                  {x=-6, y=5},
                  {x=-5, y=6},
                  {x=-4, y=7},
                  {x=-3, y=7},
                  {x=-2, y=8},
                  {x=-1, y=8} }
  
  return coords
end
local function circle7()

  local coords = {{x=7, y=0},
  
                  {x=7, y=-1},
                  {x=7, y=-2},
                  {x=6, y=-3},
                  {x=6, y=-4},
                  {x=5, y=-5},
                  {x=4, y=-6},
                  {x=3, y=-6},
                  {x=2, y=-7},
                  {x=1, y=-7},
  
                  {x=0, y=-7},
  
                  {x=-7, y=-1},
                  {x=-7, y=-2},
                  {x=-6, y=-3},
                  {x=-6, y=-4},
                  {x=-5, y=-5},
                  {x=-4, y=-6},
                  {x=-3, y=-6},
                  {x=-2, y=-7},
                  {x=-1, y=-7},
  
                  {x=0, y=7},
  
                  {x=7, y=1},
                  {x=7, y=2},
                  {x=6, y=3},
                  {x=6, y=4},
                  {x=5, y=5},
                  {x=4, y=6},
                  {x=3, y=6},
                  {x=2, y=7},
                  {x=1, y=7},
  
                  {x=-7, y=0},
  
                  {x=-7, y=1},
                  {x=-7, y=2},
                  {x=-6, y=3},
                  {x=-6, y=4},
                  {x=-5, y=5},
                  {x=-4, y=6},
                  {x=-3, y=6},
                  {x=-2, y=7},
                  {x=-1, y=7} }
  
  return coords
end
local function circle6()

  local coords = {{x=6, y=0},
  
                  {x=6, y=-1},
                  {x=5, y=-2},
                  {x=5, y=-3},
                  {x=4, y=-4},
                  {x=3, y=-5},
                  {x=2, y=-5},
                  {x=1, y=-6},
  
                  {x=0, y=-6},
  
                  {x=-6, y=-1},
                  {x=-5, y=-2},
                  {x=-5, y=-3},
                  {x=-4, y=-4},
                  {x=-3, y=-5},
                  {x=-2, y=-5},
                  {x=-1, y=-6},
  
                  {x=0, y=6},
  
                  {x=6, y=1},
                  {x=5, y=2},
                  {x=5, y=3},
                  {x=4, y=4},
                  {x=3, y=5},
                  {x=2, y=5},
                  {x=1, y=6},
  
                  {x=-6, y=0},
  
                  {x=-6, y=1},
                  {x=-5, y=2},
                  {x=-5, y=3},
                  {x=-4, y=4},
                  {x=-3, y=5},
                  {x=-2, y=5},
                  {x=-1, y=6}}
  
  return coords
end
local function circle5()

  local coords = {{x=5, y=0},
  
                  {x=5, y=-1},
                  {x=4, y=-2},
                  {x=4, y=-3},
                  {x=3, y=-4},
                  {x=2, y=-4},
                  {x=1, y=-5},
                  
                  {x=0, y=-5},
                  
                  {x=-5, y=-1},
                  {x=-4, y=-2},
                  {x=-4, y=-3},
                  {x=-3, y=-4},
                  {x=-2, y=-4},
                  {x=-1, y=-5},
                  
                  {x=0, y=5},
                  
                  {x=5, y=1},
                  {x=4, y=2},
                  {x=4, y=3},
                  {x=3, y=4},
                  {x=2, y=4},
                  {x=1, y=5},
                  
                  {x=-5, y=0},
                  
                  {x=-5, y=1},
                  {x=-4, y=2},
                  {x=-4, y=3},
                  {x=-3, y=4},
                  {x=-2, y=4},
                  {x=-1, y=5}}
  
  return coords
end
local function circle4()

  local coords = {{x=4, y=0},
                  {x=4, y=-1},
                  {x=3, y=-2},
                  {x=2, y=-3},
                  {x=1, y=-4},
                  {x=0, y=-4},
                  {x=-4, y=-1},
                  {x=-3, y=-2},
                  {x=-2, y=-3},
                  {x=-1, y=-4},
                  {x=-4, y=0},  
                  {x=4, y=1},
                  {x=3, y=2},
                  {x=2, y=3},
                  {x=1, y=4},
                  {x=0, y=4},
                  {x=-4, y=1},
                  {x=-3, y=2},
                  {x=-2, y=3},
                  {x=-1, y=4}}
  
  return coords
end
local function circle3()

  local coords = {{x=3, y=0},
                  {x=3, y=-1},
                  {x=2, y=-2},
                  {x=1, y=-3},
                  {x=0, y=-3},
                  {x=-3, y=-1},
                  {x=-2, y=-2},
                  {x=-1, y=-3},
                  {x=-3, y=0},
                  {x=3, y=1},
                  {x=2, y=2},
                  {x=1, y=3},
                  {x=0, y=3},
                  {x=-3, y=1},
                  {x=-2, y=2},
                  {x=-1, y=3}}
  
  return coords
end
local function circle2()

  local coords = {{x=2, y=0},
                  {x=2, y=-1},
                  {x=1, y=-2},
                  {x=0, y=-2},
                  {x=-2, y=-1},
                  {x=-1, y=-2},
                  {x=-2, y=0},
                  {x=2, y=1},
                  {x=1, y=2},
                  {x=0, y=2},
                  {x=-2, y=1},
                  {x=-1, y=2}}
  
  return coords
end
local function circle1()

  local coords = {{x=1, y=0},
                  {x=1, y=-1},
                  {x=0, y=-1},
                  {x=-1, y=-1},
                  {x=-1, y=0},
                  {x=1, y=1},
                  {x=0, y=1},
                  {x=-1, y=1}}
  
  return coords
end
local function initCircleLine(radius)
  if radius == 10 then
    return circle10()
  elseif radius == 9 then
    return circle9()
  elseif radius == 8 then
    return circle8()
  elseif radius == 7 then
    return circle7()
  elseif radius == 6 then
    return circle6()
  elseif radius == 5 then
    return circle5()
  elseif radius == 4 then
    return circle4()
  elseif radius == 3 then
    return circle3()
  elseif radius == 2 then
    return circle2()
  elseif radius == 1 then
    return circle1()
  end
end
local function floodfill(coords)
  local cx,cy = 0,0
  
  local fill = {unpack(coords)}
  while not isIn(cx,cy,coords) do
    -- down
    while not isIn(cx,cy,coords) do
    -- right
      table.insert(fill,{x=cx,y=cy})
      cx = cx + 1
    end
    cx = - 1
    while not isIn(cx,cy,coords) do
    -- left
      table.insert(fill,{x=cx,y=cy})
      cx = cx - 1
    end
    cx = 0
    cy = cy + 1
  end
  
  cx = 0
  cy = cy - 1
  while not isIn(cx,cy,coords) do
    -- up
    while not isIn(cx,cy,coords) do
    -- right
      table.insert(fill,{x=cx,y=cy})
      cx = cx + 1
    end
    cx = - 1
    while not isIn(cx,cy,coords) do
    -- left
      table.insert(fill,{x=cx,y=cy})
      cx = cx - 1
    end
    cx = 0
    cy = cy - 1
  end
  
  return fill
end


local function initCircleFill(radius)
  return floodfill(Circle.line[radius])
end


function Circle:Initialize()
  Circle.line = {}
  Circle.fill = {}
  
  for radius = 1, 10 do
    Circle.line[radius] = initCircleLine(radius)
    Circle.fill[radius] = initCircleFill(radius)
  end
end

