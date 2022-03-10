--
local Rocket = {}
--
--------------------------------------------------------------------------------------------------------------
--
function Rocket.load()
-- Les rockets
  Rocket.img = love.graphics.newImage("images/rocket.png")
  Rocket.largeur = Rocket.img:getWidth()
  Rocket.hauteur = Rocket.img:getHeight()
  Rocket.ox = Rocket.largeur/2
  Rocket.oy = Rocket.hauteur/2
  --
  function Rocket.Gen_Tir(pCamp,pX,pY,pAngle)
    local rocket = {}
    if pCamp == "joueur" then
      Son.Gen_sndTirjoueur()
    elseif pCamp == "adv" then
      Son.Gen_sndTiradv()
    end
    rocket.camp = pCamp
    rocket.x = pX
    rocket.y = pY
    rocket.v = 2000
    rocket.angle = pAngle
    rocket.vx = rocket.v * math.cos(rocket.angle)
    rocket.vy = rocket.v * math.sin(rocket.angle)
    table.insert(Rocket, rocket)
  end
-- Trainées
  Rocket.img_trace = love.graphics.newImage("images/trace.png")
  Rocket.img_trace_ox = Rocket.img_trace:getWidth()
  Rocket.img_trace_oy = Rocket.img_trace:getHeight()/2
  Rocket.Trace = {}
-- Les explosions
  Rocket.Explosion = {}
  Rocket.ts_explosion = love.graphics.newImage("images/explosion.png")
  Rocket.quad_explosion= {}
  for q=1,8 do
    Rocket.quad_explosion[q] = love.graphics.newQuad((q-1)*32, 0, 32, 32, 256, 32)
  end
  --
  function Rocket.Gen_Explosion(pX,pY)
    local explosion = {}
    explosion.x = pX
    explosion.y = pY
    explosion.chrono = 1
    table.insert(Rocket.Explosion, explosion)
  end
-- Explosions des destructions
  Rocket.Destruction = {}
  function Rocket.Gen_Destruction(pX,pY)
    local destruction = {}
    destruction.chronozone = 0
    for ex=1,4 do
      destruction[ex]= {}
      destruction[ex].x = math.random(pX-30, pX+30) 
      destruction[ex].y = math.random(pY-30, pY+30)
      destruction[ex].chrono = 1
    end
    table.insert(Rocket.Destruction, destruction)
  end
--
end
--
--------------------------------------------------------------------------------------------------------------
--
function Rocket.update(dt)
-- 
-- Rockets
  for r=#Rocket,1,-1 do
    if Rocket[r] ~= nil then
  -- Déplacement des rockets
      Rocket[r].x = Rocket[r].x + Rocket[r].vx * dt
      Rocket[r].y = Rocket[r].y + Rocket[r].vy * dt
    -- Impact des rockets
      -- Rockets ennemies
      if Rocket[r].camp == "adv" then
        if math.dist(Rocket[r].x,Rocket[r].y,Tank.x, Tank.y) <= Tank.hauteur/2 then
          Rocket.Gen_Explosion(Rocket[r].x, Rocket[r].y)
          table.remove(Rocket, r)
          Son.Gen_sndExplosion()
          Tank.vie = Tank.vie - 1
          if Tank.vie <= 0 then
            Tank.vie = 0
            Display.action = true
          end
        end
        for e=#Ennemi,1,-1 do
          if Rocket[r] ~= nil then
            if math.dist(Rocket[r].x,Rocket[r].y,Ennemi[e].x, Ennemi[e].y) <= Ennemi.hauteur/2 then
              Rocket.Gen_Explosion(Rocket[r].x, Rocket[r].y)
              table.remove(Rocket, r)
              Son.Gen_sndExplosion()
              Ennemi[e].vie = Ennemi[e].vie - 1
              if Ennemi[e].vie <= 0 then
                  Rocket.Gen_Destruction(Ennemi[e].x,Ennemi[e].y)
                  table.remove(Ennemi, e)
                  Tank.score = Tank.score + 1
              end
            end
          end
        end
      -- Rockets du joueur
      elseif Rocket[r].camp == "joueur" then
        for e=#Ennemi,1,-1 do
          if Rocket[r] ~= nil then
            if math.dist(Rocket[r].x,Rocket[r].y, Ennemi[e].x, Ennemi[e].y) <= Ennemi.hauteur/2 then
              Rocket.Gen_Explosion(Rocket[r].x, Rocket[r].y)
              table.remove(Rocket, r)
              Son.Gen_sndExplosion()
              Ennemi[e].vie = Ennemi[e].vie - 1
              if Ennemi[e].vie <= 0 then
                Rocket.Gen_Destruction(Ennemi[e].x,Ennemi[e].y)
                table.remove(Ennemi, e)
                Son.Gen_sndDestruction()
                Tank.score = Tank.score + 2
              end
            end
          end
        end
      end
      -- Collisions entre rockets
      if Rocket[r] ~= nil then
        for r2=#Rocket,1,-1 do
          if r ~= r2 then
            if Rocket[r] ~= nil and Rocket[r2] ~= nil then
              if math.dist(Rocket[r].x,Rocket[r].y,Rocket[r2].x, Rocket[r2].y) <= Rocket.largeur then
                Rocket.Gen_Explosion(Rocket[r].x, Rocket[r].y)
                Rocket.Gen_Explosion(Rocket[r2].x, Rocket[r2].y)
                if r>r2 then
                  table.remove(Rocket, r)
                  table.remove(Rocket, r2)
                else
                  table.remove(Rocket, r2)
                  table.remove(Rocket, r)
                end
                Son.Gen_sndInterrocket()
              end
            end
          end
        end
      end
    -- Enregistre les traces des rockets
      if Rocket[r] ~= nil then
        local trace = {}
        trace.x = Rocket[r].x
        trace.y = Rocket[r].y
        trace.angle = Rocket[r].angle
        trace.perma = 1
        table.insert(Rocket.Trace, trace)
      end
    -- Supprime les rockets sorties de l'écran
      if Rocket[r] ~= nil then
        if Rocket[r].x <= 0 - Largeur/8 or Rocket[r].x >= Largeur + Largeur/8 or Rocket[r].y <= 0 - Hauteur/8 or Rocket[r].y >= Hauteur + Hauteur/8 then
          table.remove(Rocket, r)
        end
      end
    end
  end
--
-- Disparition des traces
  for t=#Rocket.Trace,1,-1 do
    Rocket.Trace[t].perma = Rocket.Trace[t].perma - 3*dt
    if Rocket.Trace[t].perma <= 0 then
      table.remove(Rocket.Trace, t)
    end
  end
-- Animation des explosions
  for ex=#Rocket.Explosion,1,-1 do
    Rocket.Explosion[ex].chrono = Rocket.Explosion[ex].chrono + 20*dt
    if Rocket.Explosion[ex].chrono >= 9 then
      table.remove(Rocket.Explosion, ex)
    end
  end
-- Animation des destructions
  for d=#Rocket.Destruction,1,-1 do
    Rocket.Destruction[d].chronozone = Rocket.Destruction[d].chronozone + 10*dt
    for ex=#Rocket.Destruction[d],1,-1 do
      if math.floor(Rocket.Destruction[d].chronozone) >= ex then
        Rocket.Destruction[d][ex].chrono = Rocket.Destruction[d][ex].chrono + 20*dt
      end
      if Rocket.Destruction[d][ex].chrono >= 9 then
        table.remove(Rocket.Destruction[d], ex)
      end
    end
    if Rocket.Destruction[d].chronozone >= 13 then
      table.remove(Rocket.Destruction, d)
    end
  end
--
end
--
--------------------------------------------------------------------------------------------------------------
--
function Rocket.draw()
--
-- Rockets
  for r=#Rocket,1,-1 do
    love.graphics.draw(Rocket.img, Rocket[r].x, Rocket[r].y, Rocket[r].angle, 1, 1, Rocket.ox, Rocket.oy)
  end
--
-- Trainées des rockets
  for t=#Rocket.Trace,1,-1 do
    love.graphics.setColor(1,1,1,Rocket.Trace[t].perma)
    love.graphics.draw(Rocket.img_trace, Rocket.Trace[t].x, Rocket.Trace[t].y, Rocket.Trace[t].angle, 1, 1, Rocket.img_trace_ox, Rocket.img_trace_oy)
    love.graphics.setColor(1,1,1,Display.chronoalpha)
  end
--
-- Explosions
  for ex=#Rocket.Explosion,1,-1 do
    love.graphics.draw(Rocket.ts_explosion, Rocket.quad_explosion[math.floor(Rocket.Explosion[ex].chrono)], Rocket.Explosion[ex].x, Rocket.Explosion[ex].y, 0, 1.5, 1.5, 32/2, 32/2)
  end
--
-- Explosions des destructions
  for d=#Rocket.Destruction,1,-1 do
    for ex=#Rocket.Destruction[d],1,-1 do
      love.graphics.draw(Rocket.ts_explosion, Rocket.quad_explosion[math.floor(Rocket.Destruction[d][ex].chrono)], Rocket.Destruction[d][ex].x, Rocket.Destruction[d][ex].y, 0, 1.5, 1.5, 32/2, 32/2)
    end
  end
--
end
--
--------------------------------------------------------------------------------------------------------------
--
return Rocket
--