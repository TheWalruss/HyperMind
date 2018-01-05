require 'Properties'

Wind = { wind = {x = 0, y = 0} }

function Wind:update(dt)
  Wind.wind.x = Wind.wind.x + love.math.randomNormal(Properties.Windiness,0) * Properties.WindHorizontalness
  Wind.wind.y = Wind.wind.y + love.math.randomNormal(Properties.Windiness,0)
end

function Wind:draw()
  love.graphics.setColor(100,100,255,255)
  love.graphics.line(100,100,100+Wind.wind.x, 100+Wind.wind.y)
end
