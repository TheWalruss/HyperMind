
require 'love.image'
require 'love.thread'
require 'love.math'
require 'love.filesystem'
require 'love.image'

require 'trace'
require 'chunk'
require 'properties'

local thisChannel = love.thread.getChannel("physics")
local mainChannel = love.thread.getChannel("main")
print(' physics ready')

while true do
  local payload = thisChannel:demand()
  Physics:update(payload.x, payload.y, payload.dt)  
end