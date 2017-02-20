module("Main", package.seeall)
require "Game"
require "Menu"
require "Sound"
require "Store"

function love.load()
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  
  gamestate = "endless"
  Game.load()
  Menu.load()
  Sound.load()
  Store.load()
  Sound.play()
  
  clickX = 0
  clickY=0
  
  screenWidth = 750/2
  screenHeight = 1337/2
  
  --global value
   _G.completedStory = false

  if love.system.getOS() == "Android" then
    local x,y = love.graphics.getDimensions()
    scalex = (x/screenWidth)
    scaley = (y/screenHeight)
  else
    scalex = 1
    scaley = 1
  end
  love.window.setMode(screenWidth * scalex, screenHeight * scaley)
  end

function love.draw()
  love.graphics.scale(scalex, scaley)
  
  if gamestate == "menu" then
    Menu.draw()
  end
  
  if gamestate == "story" then
    Menu.drawStory()
  end
  
  if gamestate == "endless" then
    Game.drawEndless()
  end
  
  if gamestate == "store" then
    Store.drawDuckSelect()
  end

  love.graphics.setColor(0,0,0)
  love.graphics.print(clickX,100,200)
  love.graphics.print(clickY,100,250)
  love.graphics.setColor(255,255,255)
end

function love.update()
  love.graphics.scale(scalex, scaley)
  
  if gamestate == "menu" then
    Menu.update()
  end
  
  if gamestate == "story" then
    Menu.updateStory()
  end
  
  if gamestate == "endless" then
    Game.updateEndless()
  end
end

function love.mousepressed(x,y,button,istouch)
  if button == 1 then
    clickX = x
    clickY = y
  end

  --story mode main screen duck
  if (x < 95 and y > 355 and y <455) then
    _G.completedStory = true
  end 

--duck shop 
  if (x > 140 and x < 235 and y > 345 and y <450) then
  
  end 

-- endless mode
  if (x > 265 and x < 360 and y > 345 and y <450 and _G.completedStory) then
  
  end 

end
