--
io.stdout:setvbuf("no")
math.randomseed(os.time())
--love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require ("mobdebug").start() end
--
Jeu = require("jeu")
Tank = require("tank")
Rocket = require("rockets")
Ennemi = require("ennemis")
Son = require("sons")
Display = require("display")
--
--------------------------------------------------------------------------------------------------------------
--
function love.load()
--
  love.window.setMode(1920,1080)
  Largeur = love.graphics.getWidth()
  Hauteur = love.graphics.getHeight()
--
-- Calcul de distance
  function math.dist(x1,y1, x2,y2)
    return ((x2-x1)^2+(y2-y1)^2)^0.5
  end
--
-- Calcul d'angle
  function math.angle(x1,y1,x2,y2)
    return math.atan2(y2-y1, x2-x1)
  end
--
  Ennemi.load()
--
  Tank.load()
--
  Rocket.load()
--
  Jeu.load()
--
  Son.load()
--
  Display.load()
--
-- Lancement du menu
  Display.etat = "menu"
--
-- Pour tester rapidement le jeu
  --Display.etat = "play"
  --Display.chronoalpha = 1
  --Jeu.niveau0 = true
--
end
--
--------------------------------------------------------------------------------------------------------------
--
function love.update(dt)
--
-- Jeu qui tourne
  if Display.etat == "play" then
  --
    Jeu.update(dt)
  --
    Tank.update(dt)
  --
    Ennemi.update(dt)
  --
    Rocket.update(dt)
  --
  end
--
  Son.update(dt)
--
  Display.update(dt)
--
end
--
--------------------------------------------------------------------------------------------------------------
--
function love.draw()
--
-- Jeu qui tourne
  if Display.etat == "play" or Display.etat == "pause" then
  --
    Jeu.draw()
  --
    Ennemi.draw()
  --
    Tank.draw()
  --
    Rocket.draw()
  --
  end
--
  Display.draw()
--
  -- Débugueur
  love.graphics.setColor(1,1,1,1)
  --love.graphics.print("Angle base : "..Tank.rot_base, 10, 10)
  --love.graphics.print("Angle viseur : "..Tank.angl_vis, 10, 10)
  --love.graphics.print("Angle canon : "..Tank.rot_canon, 10, 25)
  --love.graphics.print("Calcul diff : "..math.angle(Tank.x,Tank.y,Tank.x_mouse,Tank.y_mouse), 10, 40)
  --love.graphics.print("Rocket(s) : "..#Rocket, 10, 40)
  --love.graphics.print("Ennemi(s) : "..#Ennemi, 10, 55)
  --love.graphics.print("Son(s) : "..#Son.sndStatics, 10, 70)
  --love.graphics.print("Score : "..Tank.score, 10, 85)
  --love.graphics.print("Vie(s) : "..Tank.vie, 10, 100)
  --love.graphics.print("Action : "..tostring(Display.action), 10, 115)
  --love.graphics.print("État : "..Display.etat, 10, 130)
  --love.graphics.print("ChronoAnim : "..Display.chronoanim, 10, 145)
  --love.graphics.print("TracesTank : "..#Tank.Trace, 10, 160)
  --love.graphics.print("TracesRockets : "..#Rocket.Trace, 10, 175)
  love.graphics.setColor(1,1,1,Display.chronoalpha)
--
end
--
--------------------------------------------------------------------------------------------------------------
--
function love.keypressed(key)
--
  Son.keypressed(key)
--
  Display.keypressed(key)
--
-- Cheat
  if Display.etat == "play" and Display.action == false then
    if key == "=" then
      --Tank.vie = Tank.vie + 1
      for e=#Ennemi,1,-1 do
        --Ennemi[e].vie = Ennemi[e].vie + 1
      end
    end
    if key == "!" then
      --Tank.score = Tank.score + 5
    end
  end
--
end
--
--------------------------------------------------------------------------------------------------------------
--
function love.keyreleased(key)
--
  Son.keyreleased(key)
--
end
--
--------------------------------------------------------------------------------------------------------------
--
function love.mousepressed(px,py,nb)
--
-- Jeu qui tourne
  if Display.etat == "play" and Display.action == false then
  --
  Tank.mousepressed(px,py,nb)  
  --
  end
--
end
--
--------------------------------------------------------------------------------------------------------------
--
function love.mousereleased(px,py,nb)
--
  Display.mousereleased(px,py,nb)
--
end
--