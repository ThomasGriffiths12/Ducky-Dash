module("upgrades", package.seeall)
require "main"
require "DuckDataBase"
function load()
  LeftPoint = 50
  MiddlePoint = 130
  RightPoint = 210
  speedState = "normalspeed"
  duckState = "vulnerable"
  pointState = "normal"
  lifeline = 0
  isActive = false
  isSpawned = false
  upgradeType = "none"
  purchQuadI = love.graphics.newQuad(1,1,70,70,70,70)
  purchQuadL = love.graphics.newQuad(1,1,70,70,70,70)
  purchQuadX2 = love.graphics.newQuad(1,1,70,70,70,70)
  purchQuadHS = love.graphics.newQuad(1,1,70,70,70,70)
  upgradeQuad = love.graphics.newQuad(1,1,100,100,100,100)
  upgradeTex = nil
  purchTank = love.graphics.newQuad(1,1,750/2,1337/2,750/2,1337/2)
  purchImage = love.graphics.newImage("assets/power_up_box.png")
  lifeLineUpgrade = love.graphics.newImage("assets/lifeline.png")
  invincibilityUpgrade = love.graphics.newImage("assets/invincibility.png")
  x2PointsUpgrade = love.graphics.newImage("assets/doublepoints.png")
  halfSpeedUpgrade = love.graphics.newImage("assets/slowdown.png")
  lifeLineQuad = love.graphics.newQuad(1,1,100,100,100,100)
  invincibilityQuad = love.graphics.newQuad(1,1,100,100,100,100)
  x2PointsQuad = love.graphics.newQuad(1,1,100,100,100,100)
  halfSpeedQuad = love.graphics.newQuad(1,1,100,100,100,100)
  upgradeX = 60
  upgradeY = -100
  upgradeDrop = love.math.random(1,4)
  upgradeLane = love.math.random(1,3)
  
  upgradeSpTimer = 0
  upgradeAcTimer = 0
  timerStep = love.math.random(10,30)
end

function Update()
  upgradeSpTimer = upgradeSpTimer + 1 * love.timer.getDelta()
  if (isSpawned == false) then
    if (isActive == false) then
      if(main.gamestate == "endless") then
        if (upgradeSpTimer > timerStep) then
          SpawnUpgrade()
          timerStep = love.math.random(5,10)
        end
      end
    end
  elseif (isSpawned == true) then
    if(isActive == false) then
      if (upgradeY < 500) then
        upgradeY = upgradeY + 3
      else
        upgradeY = 0
        isSpawned = false
        upgradeSpTimer = 0
        timerStep = love.math.random(10,30)
      end
    end
  end
  hitTest = CheckCollision(upgradeX, upgradeY, 100, 100, game.Ducky.PosX, game.Ducky.PosY, game.Ducky.Width, game.Ducky.Height)
  if (hitTest) then
    upgradeY = 700
    isSpawned = false
    isActive = true
  end
  if (isSpawned == false) then
    if (isActive == true) then
      if (upgradeType == "Invincibility") then
      Invincibility()
      elseif (upgradeType == "LifeLine") then
        if (game.duckLife == 1  or game.duckLife == 2) then
        LifeLine()
        end
      elseif (upgradeType == "x2Points") then
        DoublePoints()
      elseif (upgradeType == "halfSpeed") then
        HalfSpeed()
      elseif (upgradeType == "purchLifeline") then
        purchLifeLine()
      elseif (upgradeType == "purchX2Points") then
        purchX2()
      elseif (upgradeType == "purchInvincibility") then
        purchInv()
      elseif (upgradeType == "purchHalfSpeed") then
        purchHalfSpeed()
      end
    end
  end
end  
function DoublePoints()
  if (upgradeAcTimer > timerStep) then
    pointState = "normal"
    isActive = false
    upgradeAcTimer = 0
    upgradeSpTimer = 0
    timerStep = love.math.random(10,30)
    upgradeType = "none"
  else
    upgradeAcTimer = upgradeAcTimer + 1 * love.timer.getDelta()
    pointState = "doublePoints"
  end

end

function LifeLine()
  if (game.duckLife < 3) then  
    game.duckVerticalMove = "up"  
    game.hit = false
    upgradeAcTimer = 0
    upgradeSpTimer = 0
    timerStep = love.math.random(10,30)
    isActive = false
    upgradeType = "none"   
  end
end
function Invincibility()
  if (upgradeAcTimer > timerStep) then
    duckState = "vulnerable"
    upgradeAcTimer = 0
    upgradeSpTimer = 0
    timerStep = love.math.random(10,30)
    isActive = false
    upgradeType = "none"
  else
    upgradeAcTimer = upgradeAcTimer + 1 * love.timer.getDelta()
    duckState = "invulnerable"
  end
end
function HalfSpeed()
  if (upgradeAcTimer > timerStep) then
    speedState = "normal"
    upgradeAcTimer = 0
    upgradeSpTimer = 0
    timerStep = love.math.random(10,30)
    isActive = false
    upgradeType = "none"
  else
    upgradeAcTimer = upgradeAcTimer + 1 * love.timer.getDelta()
    speedState = "halfSpeed"
  end
end

function SpawnUpgrade()
  upgradeDrop = love.math.random(1,4)
  upgradeLane = love.math.random(1,3)
  if(upgradeLane == 1) then
    upgradeX = LeftPoint
  else if(upgradeLane == 2) then
    upgradeX = MiddlePoint
  elseif(upgradeLane == 3) then
    upgradeX = RightPoint
  end
  if (upgradeDrop == 1 and not (game.duckLife == 3)) then
    upgradeType = "LifeLine"
    upgradeTex = lifeLineUpgrade
    upgradeQuad = lifeLineQuad
  end
  if (upgradeDrop == 1 and game.duckLife == 3) then 
    upgradeDrop = love.math.random(2,4)
  end
  if (upgradeDrop == 2) then
    upgradeType = "Invincibility"
    upgradeTex = invincibilityUpgrade
    upgradeQuad = invincibilityQuad
  end
  if(upgradeDrop == 3) then
    upgradeType = "x2Points"
    upgradeTex = x2PointsUpgrade
    upgradeQuad = x2PointsQuad
  end
  if(upgradeDrop == 4) then
    upgradeType = "HalfSpeed"
    upgradeTex = halfSpeedUpgrade
    upgradeQuad = halfSpeedQuad
  end
end
isSpawned = true
end

function purchInv()
  if (upgradeAcTimer > 15) then
    duckState = "vulnerable"
    upgradeAcTimer = 0
    upgradeSpTimer = 0
    timerStep = love.math.random(10,30)
    DuckDataBase.numInvincability = DuckDataBase.numInvincability -1
    isActive = false
    upgradeType = "none"
  else
    upgrades.isActive = true
    upgradeAcTimer = upgradeAcTimer + 1 * love.timer.getDelta()
    duckState = "invulnerable"
  end

end

function purchLifeLine()
  if (game.duckLife < 3) then
    game.duckVerticalMove = "up"  
    game.duckLife = 2
    game.hit = false
    upgradeAcTimer = 0
    upgradeSpTimer = 0
    timerStep = love.math.random(10,30)
    DuckDataBase.numLifeLine = DuckDataBase.numLifeLine - 1
    isActive = false
    upgradeType = "none"
  end
end
function purchX2()
    if (upgradeAcTimer > 15) then
    pointState = "normal"
    upgradeAcTimer = 0
    upgradeSpTimer = 0
    timerStep = love.math.random(10,30)
    DuckDataBase.numDoublePoints = DuckDataBase.numDoublePoints - 1
    isActive = false
    upgradeType = "none"
  else
    upgrades.isActive = true
    upgradeAcTimer = upgradeAcTimer + 1 * love.timer.getDelta()
    pointState = "doublePoints"
  end
end
function purchHalfSpeed()
  if (upgradeAcTimer > 10) then
    speedState = "normal"
    timerStep = love.math.random(10,30)
    upgradeSpTimer = 0
    upgradeAcTimer = 0
    DuckDataBase.numHalfSpeed = DuckDataBase.numHalfSpeed - 1
    isActive = false
    upgradeType = "none"
  else
    upgrades.isActive = true
    upgradeAcTimer = upgradeAcTimer + 1 * love.timer.getDelta()
    speedState = "halfSpeed"
  end
end
function Draw()
  if(isSpawned == true) then
    if not(upgradeTex == nil) then
      love.graphics.draw(upgradeTex,upgradeQuad,upgradeX, upgradeY)
    end
  end
  if (isActive) then
    love.graphics.setColor(111,111,111)
  end
  love.graphics.draw(purchImage,purchTank,0,0)
  love.graphics.draw(invincibilityUpgrade,purchQuadI,602/2,50/2)
  love.graphics.draw(lifeLineUpgrade,purchQuadL,602/2,250/2)
  love.graphics.draw(x2PointsUpgrade,purchQuadX2,602/2,450/2)
  love.graphics.draw(halfSpeedUpgrade,purchQuadHS,602/2,650/2)
  love.graphics.setColor(0,0,0)
  love.graphics.print(DuckDataBase.numInvincability,700/2, 200/2)
  love.graphics.print(DuckDataBase.numLifeLine,700/2, 400/2)
  love.graphics.print(DuckDataBase.numDoublePoints,700/2, 600/2)
  love.graphics.print(DuckDataBase.numHalfSpeed,700/2, 800/2)
  love.graphics.setColor(255,255,255)
end

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end