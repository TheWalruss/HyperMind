require 'Properties'

Camera = { Pos = {},
           Vel = {},
           TargetPos = {},
           TargetVel = {}}

function Camera:setPos(x,y)
  Camera.Pos.x, Camera.Pos.y = x,y
end
function Camera:setCenter(x,y)
  Camera:setPos(x - Properties.WindowWidth / 2, y - Properties.WindowHeight / 2)
end

function Camera:setVel(x,y)
  Camera.Vel.x, Camera.Vel.y = x,y
end

function Camera:setTargetPos(x,y)
  Camera.TargetPos.x, Camera.TargetPos.y = x,y
end
function Camera:setTargetCenter(x,y)
  Camera:setTargetPos(x - Properties.WindowWidth / 2, y - Properties.WindowHeight / 2)
end

function Camera:setTargetVel(x,y)
  Camera.TargetVel.x, Camera.TargetVel.y = x,y
end

function Camera:initialize()
  Camera:setCenter(0,0)
  Camera:setVel(0,0)
  Camera:setTargetPos(0,0)
  Camera:setTargetVel(0,0)
end

function Camera:worldToScreen(x,y)
  return x - Camera.Pos.x, y - Camera.Pos.y
end
function Camera:worldToCenter(x,y)
  return x - Camera.Pos.x + Properties.WindowWidth / 2, y - Camera.Pos.y + Properties.WindowHeight / 2
end

function Camera:update(dt)
  local posDiffx, posDiffy = Camera.TargetPos.x - Camera.Pos.x, Camera.TargetPos.y - Camera.Pos.y
  local velDiffx, velDiffy = Camera.TargetVel.x - Camera.Vel.x, Camera.TargetVel.y - Camera.Vel.y
  Camera.Vel.x = Camera.Vel.x + velDiffx * Properties.CameraVelResponse * dt + posDiffx * Properties.CameraPosResponse * dt
  Camera.Vel.y = Camera.Vel.y + velDiffy * Properties.CameraVelResponse * dt + posDiffy * Properties.CameraPosResponse * dt
  Camera.Pos.x, Camera.Pos.y = Camera.Pos.x + Camera.Vel.x * dt, Camera.Pos.y + Camera.Vel.y * dt
end
