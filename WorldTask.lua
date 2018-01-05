
require 'love.image'
require 'love.thread'
require 'love.math'
require 'love.filesystem'
require 'love.image'

require 'trace'
require 'Chunk'
require 'Properties'

local thisChannel = love.thread.getChannel("world")
local mainChannel = love.thread.getChannel("main")
print(' world ready')

while true do
  local payload = thisChannel:demand()
  local x0, y0 = payload.x, payload.y
  Chunk:generate(x0, y0)
  mainChannel:push("ok")
  
  for border = 1, Properties.PregenChunkBorder do
    for y = y0 + border, y0 - border, -1 do
      for x = x0 + border, x0 - border, -1 do
        Chunk:generate(x,y)
        if thisChannel:getCount() > 0 then
          break
        end
      end
    end
  end
end
