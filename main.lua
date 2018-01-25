-- Working on:
-- Adjust emitter things so you can drop a trail of stuff - maybe vary floaty params?
-- Implement torch
-- Grappling hook (i.e. Rope effector)
-- Tool building in inventoryview
-- Mouse aim??
-- How to capture neat side-effects like "floaty bombs" and reward tricky shots (using timers, long shots, etc.) over easy shots (projection, crawlers, etc.)
-- Trigger on things other than terrain - cleanup spiders?

require 'Properties'
require 'Level'
require 'State'
require 'Player'
require 'Camera'
require 'Circle'
require 'Grapple'
require 'Toolkit'
require 'ToolBuilder'
require 'Inventory'
require 'Thing'
require 'Annihilator'
require 'Probe'
require 'Converter'
require 'Dilator'
require 'Harvester'
require 'Extruder'
require 'Materials'
require 'Projection'
require 'Wind'
require 'ToolCraft'

require 'trace'

function love.load()
  Circle:Initialize()
  Materials:Initialize()
  Level:initialize()
  Inventory:addTool(ToolBuilder:CreateBasicTool())
  
  Player:spawn(200,200)
  Grapple:initialize()
  Camera:initialize()
  Camera:setCenter(0,0)
  
  print("loading")
  trace.print("loading")
  worldtask = love.thread.newThread('WorldTask.lua')
  worldChannel = love.thread.getChannel("world")
  mainChannel = love.thread.getChannel("main")
  worldtask:start()
  worldChannel:push({x=0,y=0})
  mainChannel:demand()
  trace.print("done!")
  print("done!")

  Level:load()
  trace.clear()
end

 
function love.threaderror(thread, errorstr)
  print("Thread error!\n"..errorstr)
  -- thread:getError() will return the same error string now.
end
function love.draw()
    
  if State.paused then
    love.graphics.setBackgroundColor(163, 163, 163)
  else
    love.graphics.setBackgroundColor(63, 63, 63)
  end
  Level:draw()
  Player:draw()
  Grapple:draw()
  Thing:draw()
  Inventory:draw()
  Probe:draw()
  Annihilator:draw()
  Converter:draw()
  Dilator:draw()
  Harvester:draw()
  Extruder:draw()
  Projection:draw()
  Wind:draw()
  ToolCraft:draw()
  trace.draw()
end

function love.update(dt)
  if State.paused then
    return
  end
  dt = math.min(dt, Properties.MaximumTimestep)
  Level:update(dt)
  Player:update(dt)
  Grapple:update(dt)
  Thing:update(dt,Wind.wind)
  Probe:update(dt)
  Annihilator:update(dt)
  Converter:update(dt)
  Dilator:update(dt)
  Harvester:update(dt)
  Extruder:update(dt)
  Projection:update(dt)
  Wind:update(dt)

  local reticulex = Player.Pos.x + Player.Aim.x * Properties.AimFocusDistance
  local reticuley = Player.Pos.y + Player.Aim.y * Properties.AimFocusDistance
  Camera:setTargetCenter(reticulex,reticuley)
  Camera:setTargetVel(Player.Vel.x,Player.Vel.y)
  
  Camera:update(dt)
end

function love.focus(f)
  if not f then
    State.paused = true
  end
end


function love.mousepressed(x,y,button,touch)
end
function love.mousereleased(x,y,button,touch)
end
function love.keypressed(key,isrepeat)

  if key == Properties.Keybindings.pause then
    State.toggle("paused")
  elseif key == Properties.Keybindings.inventoryview then
    State.toggle("inventoryView")
  elseif key == 'tab' then 
    local tool = ToolBuilder:CreateRandomTool()
    Inventory:addTool(tool)
    print(tool.Name)
  elseif key == '2' then
    print(tostring(love.math.randomNormal(2,0)))
  elseif key == '3' then 
    local part = ToolBuilder:CreateRandomToolPart()
    Inventory:addPart(part)
    print(ts('part',part))
  else
    Player:keypressed(key,isrepeat)
  end
end
function love.keyreleased(key)
  if key == 'l' then
    --nothing
  else
    Player:keyreleased(key)
  end
end
