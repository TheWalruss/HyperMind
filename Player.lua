
require 'trace'
require 'Camera'
require 'Grapple'
require 'Common'
require 'Tool'

Player = {}

-- Utilities

local function getPlayerCoordinates()
  return getCircleCoords(Player.Pos, Properties.PlayerRadius)
end

local function applyGravity()
  applyForce( Player, {x = Properties.Gravity.x * Properties.PlayerMass, y = Properties.Gravity.y * Properties.PlayerMass})
end

local function toFreefall()
  if Player.state == "freefall" then return end
  Player.crawling = false
  Player.sticking = false
  Player.state = "freefall"
  Player.collisions = nil
  Player.Ov = nil
end
local function toCrawling()
  if Player.state == "crawling" then return end
  
  Player.crawling = true
  Player.sticking = true
  Player.state = "crawling"
  clearImpulse(Player)
  clearVel(Player)
end
local function toGrappling()
  if Player.state == "grappling" then return end
  toFreefall()
  Player.state = "grappling"
end
local function updateState(targetState)
  if targetState then
    if targetState == "freefall" then
      toFreefall()
    elseif targetState == "crawling" then
      toCrawling()
    elseif targetState == "grappling" then
      toGrappling()
    end
  elseif Player.Ov and not love.keyboard.isDown('down') then
    toCrawling()
  else 
    toFreefall()
  end
end


-- Loading/saving
function Player:spawn(x, y, id)
  Player.MoveControl = {x = 0, y = 0}
  Player.AimControl = {y = 0}
  Player.GrappleControl = 0
  Player.SailControl = 0
  
  Player.ToolControl = {use = 0, trigger = 0}
  Player.Powered = false
  
  Player.Aim = {x = 0, y = 0, angle = -math.pi/2, angularV = 0}
  
  Player.GrapplePower = 0
  Player.JumpPower = 0
  Player.FacingRight = true
  Player.state = "freefall"
  Thing:addPlayerThing(Player,{x=x,y=y}, {x=0,y=0}, id)
  Player.Pos.angle = 0
end

-- Drawing/updating

local function drawAim()
  love.graphics.setColor(255,0,0,255)
  local reticulex = Player.Pos.x + Player.Aim.x * Properties.AimDistance
  local reticuley = Player.Pos.y + Player.Aim.y * Properties.AimDistance
  local cx,cy = Camera:worldToScreen(reticulex,reticuley)
  love.graphics.circle('line',cx,cy,Properties.AimDrawRadius,10)
end

local function drawMods()
  if Player.SailControl > 0 then
    love.graphics.setColor(50,100,255,100)
    local cx,cy = Camera:worldToScreen(Player.Pos.x,Player.Pos.y)
    love.graphics.circle('fill',cx,cy,Properties.SailGraphicFactor*Properties.PlayerRadius,10)
  end
end

function Player:draw()
  drawAim()
  drawMods()
end

local function updateFreeFall(dt)
 
  if Player.MoveControl.y < 0 then
    Player.JumpPower = clamp01(Player.JumpPower + Properties.LaunchPowerRate * dt)
  end
  
  if Player.Pos.angle ~= math.pi / 2 then
    if Player.Pos.angle >= -math.pi / 2 and Player.Pos.angle < math.pi / 2 then
      Player.Pos.angle = math.min(Player.Pos.angle + Properties.PlayerFreefallRotationPeriod * dt, math.pi / 2)
    elseif Player.Pos.angle < -math.pi / 2 then
      Player.Pos.angle = rollangle(Player.Pos.angle - Properties.PlayerFreefallRotationPeriod * dt)
    else -- angle must be between math.pi/2 and math.pi
      Player.Pos.angle = math.max(Player.Pos.angle - Properties.PlayerFreefallRotationPeriod * dt, math.pi / 2)
    end
  end
end

local function updateAim(dt)
  if Player.AimControl.y > 0 then
    Player.Aim.angularV = clamp(-Properties.AimSpeedMax, Player.Aim.angularV - Properties.AimSpeedAccel * dt, Properties.AimSpeedMax)
  elseif Player.AimControl.y < 0 then
    Player.Aim.angularV = clamp(-Properties.AimSpeedMax, Player.Aim.angularV + Properties.AimSpeedAccel * dt, Properties.AimSpeedMax)
  else
    local negative = Player.Aim.angularV < 0
    if negative then
      Player.Aim.angularV = clamp(-Properties.AimSpeedMax,Player.Aim.angularV + Properties.AimSpeedSlow * dt,0)
    else
      Player.Aim.angularV = clamp(0,Player.Aim.angularV - Properties.AimSpeedSlow * dt,Properties.AimSpeedMax)
    end
  end
  
  Player.Aim.angle = Player.Aim.angle + Player.Aim.angularV * dt
  Player.Aim.angle = rollangle(Player.Aim.angle)
  
  -- Move angle based on ground
  
  local groundAngle = Player.Ov and toangle(0,0,Player.Ov.x,Player.Ov.y) or Player.Pos.angle
  local currentAimAngle = (Player.FacingRight and Player.Aim.angle or -Player.Aim.angle) + groundAngle
     
  Player.Aim.x, Player.Aim.y = math.cos(currentAimAngle), math.sin(currentAimAngle)
  
end
local function fireGrapple(imp)
  print("Firing")
  local grappleVel = {x = imp.x + Player.Vel.x, y = imp.y + Player.Vel.y}
  Grapple:fire(Player.Pos,grappleVel, Player.Powered)
  Player.GrapplePower = 0
  updateState("grappling")
end
local function updateGrappleControl(dt)
  if Player.GrappleControl > 0 then
    Player.GrapplePower = clamp01(Player.GrapplePower + Properties.LaunchPowerRate * dt)
  elseif Player.GrapplePower > 0 then
    local imp = {x = Player.Aim.x * Properties.GrapplePower * Player.GrapplePower,
                 y = Player.Aim.y * Properties.GrapplePower * Player.GrapplePower}
    fireGrapple(imp)
  end
end

local function updateSailControl(dt)
  if Player.SailControl > 0 then  
    Player.CrossSection = Player.Radius * Player.Radius * Properties.SailFactor
  else
    Player.CrossSection = Player.Radius * Player.Radius
  end
end


local function updateCrawling(dt)
  if Player.MoveControl.y < 0 then
    Player.JumpPower = clamp01(Player.JumpPower + Properties.LaunchPowerRate * dt)
  elseif Player.MoveControl.y > 0 then
    updateState("freefall")
    return
  end
  
  if Player.MoveControl.y == 0 and Player.JumpPower > 0 then
    print('JUMP = '..tostring(Player.JumpPower))
    local imp = {x = Player.Aim.x * Properties.JumpPower * Player.JumpPower * (Player.Powered and Properties.JumpPowerPowFactor or 1),
                 y = Player.Aim.y * Properties.JumpPower * Player.JumpPower * (Player.Powered and Properties.JumpPowerPowFactor or 1)}
    applyImpulse(Player,imp)
    Player.JumpPower = 0
    updateState("freefall")
    return
  end

  if Player.MoveControl.x ~= 0 then
    Player.FacingRight = Player.MoveControl.x > 0
    Player.Speed = Properties.PlayerCrawlSpeed * (Player.Powered and Properties.PlayerCrawlSpeedPowFactor or 1)
    Player.crawling = true
  else
    Player.crawling = false
  end
  
end


local function levelshift()
  if Level:shift(Player.Pos.x,Player.Pos.y) then
    Inventory:addTool(createRandomTool())
  end
end

local function updateToolControl(dt)
  Tool:updateControl(Inventory:getCurrentTool(), Player.ToolControl.use == 1, Player.ToolControl.trigger == 1, dt, Player.Aim, Player.Powered, Player.Pos, Player.Vel or {x=0, y=0})
end

function Player:update(dt)
  if Player.state == "freefall" then
    updateFreeFall(dt)
    updateAim(dt)
    updateGrappleControl(dt)
    updateSailControl(dt)
    updateToolControl(dt)
  elseif Player.state == "crawling" then
    updateCrawling(dt)
    updateAim(dt)
    updateGrappleControl(dt)
    updateToolControl(dt)
  elseif Player.state == "grappling" then
    updateGrapple(dt)
    updateSailControl(dt)
    updateToolControl(dt)
  end
  levelshift()
  updateState()
end

function Player:keypressed(key,isrepeat)
  if key == Properties.Keybindings.right then
    Player.MoveControl.x = 1
  elseif key == Properties.Keybindings.left then
    Player.MoveControl.x = -1
  elseif key == Properties.Keybindings.jump then
    Player.MoveControl.y = -1
  elseif key == Properties.Keybindings.drop then
    Player.MoveControl.y = 1
  elseif key == Properties.Keybindings.aimup then
    Player.AimControl.y = 1
  elseif key == Properties.Keybindings.aimdown then
    Player.AimControl.y = -1
  elseif key == Properties.Keybindings.grapple then
    Player.GrappleControl = 1
  elseif key == Properties.Keybindings.sail then
    Player.SailControl = 1
  elseif key == Properties.Keybindings.power then
    Player.Powered = not Player.Powered
  elseif key == Properties.Keybindings.powerlock then
    Player.Powered = not Player.Powered -- until next pressed
  elseif key == Properties.Keybindings.nexttool then
    Inventory:nextTool()
  elseif key == Properties.Keybindings.prevtool then
    Inventory:previousTool()
  elseif key == Properties.Keybindings.usetool then
    Player.ToolControl.use = 1
  elseif key == Properties.Keybindings.triggertool then
    Player.ToolControl.trigger = 1
  elseif key == Properties.Keybindings.discardtool then
    Inventory:discardtool()
  end
end

function Player:keyreleased(key)
  if key == Properties.Keybindings.left or key == Properties.Keybindings.right then
    Player.MoveControl.x = 0
  elseif key == Properties.Keybindings.jump or key == Properties.Keybindings.drop then
    Player.MoveControl.y = 0
  elseif key == Properties.Keybindings.aimup or key == Properties.Keybindings.aimdown then
    Player.AimControl.y = 0
  elseif key == Properties.Keybindings.grapple then
    Player.GrappleControl = 0
  elseif key == Properties.Keybindings.sail then
    Player.SailControl = 0
  elseif key == Properties.Keybindings.power then
    Player.Powered = not Player.Powered
  elseif key == Properties.Keybindings.powerlock then
    -- do nothing
  elseif key == Properties.Keybindings.usetool then
    Player.ToolControl.use = 0
  elseif key == Properties.Keybindings.triggertool then
    Player.ToolControl.trigger = 0
  elseif key == Properties.Keybindings.discardtool then
    -- do nothing
  end
end