--
local Tank = {}
--
--------------------------------------------------------------------------------------------------------------
--
function Tank.load()
-- Images du tank
  Tank.img_base = love.graphics.newImage("images/base1.png")
  Tank.img_canon = love.graphics.newImage("images/canon.png")
  Tank.img_chaines = {}
  Tank.img_chaines[1] = love.graphics.newImage("images/chaines1.png")
  Tank.img_chaines[2] = love.graphics.newImage("images/chaines2.png")
  Tank.img_belier = {}
  for b=1,6 do
    Tank.img_belier[b] = love.graphics.newImage("images/base"..b..".png")
  end
-- Repères
  Tank.largeur = Tank.img_base:getWidth()
  Tank.hauteur = Tank.img_base:getHeight()
  Tank.x = Largeur/2
  Tank.y = Hauteur/2
  Tank.rot_base = math.rad(-90)
  Tank.rot_canon = math.rad(-90)
  Tank.ox = Tank.largeur/2
  Tank.oy = Tank.hauteur/2
-- Vitesses déplacements
  Tank.v_av = 200
  Tank.acc_av = 0
  Tank.v_ar = 90
  Tank.acc_ar = 0
  Tank.iner_av = 1
  Tank.iner_ar = 3
-- Vitesses rotations base
  Tank.v_rot_base = math.rad(120)
  Tank.acc_rotd_base = 0
  Tank.acc_rotg_base = 0
  Tank.frot_base = 2.5
  Tank.inv_rot = false -----------------------------
-- Vitesses rotations canon
  Tank.x_mouse = love.mouse.getX()
  Tank.y_mouse = love.mouse.getY()
  Tank.rot_canon = math.rad(-90)
  Tank.angl_vis = math.angle(Tank.x,Tank.y,Tank.x_mouse,Tank.y_mouse)
  Tank.v_rot_canon = math.rad(120)
  Tank.frotcanon = 0
-- Flamme du tir
  Tank.img_flamme = {}
  for fl=1,3 do
    Tank.img_flamme[fl] = love.graphics.newImage("images/tir/"..fl..".png")
  end
  Tank.flamme_hauteur = Tank.img_flamme[1]:getHeight()
  Tank.flamme = false
  Tank.chronoflamme = 1
-- Flammes du speed
  Tank.img_speed = {}
  for sp=1,17 do
    Tank.img_speed[sp] = love.graphics.newImage("images/speed/"..sp..".png")
  end
  Tank.speed_largeur = Tank.img_speed[1]:getWidth()
  Tank.speed_hauteur = Tank.img_speed[1]:getHeight()
  Tank.chronospeed = 1
-- Trainée vitesse max
  Tank.Trace = {}
-- Trainée des chaînes
  Tank.img_traineechaines = love.graphics.newImage("images/traineechaines.png")
-- Mouvement des chaînes
  Tank.chronochaines = 1
-- Gameplay
  Tank.vie = 10
  Tank.score = 0
  Tank.chronotir = 0
  Tank.reload = false
  Tank.chronocoll = 0
  Tank.collision = false
  Tank.chronobelier = 1
  Tank.belier_anim = false
  Tank.belier_on = false
--
end
--
--
--------------------------------------------------------------------------------------------------------------
--
function Tank.update(dt)
--
  if Display.action == false then
  -- Déplacement du tank
    -- Avancer
    if love.keyboard.isDown("z") and not love.keyboard.isDown("s") then
      Tank.acc_av = Tank.acc_av + Tank.iner_av*dt
      if Tank.acc_av >= 1 then
        Tank.acc_av = 1
      end
      Tank.x = Tank.x + Tank.v_av*math.cos(Tank.rot_base)*Tank.acc_av*dt
      Tank.y = Tank.y + Tank.v_av*math.sin(Tank.rot_base)*Tank.acc_av*dt
    else
      if Tank.acc_av > 0 then
        Tank.acc_av = Tank.acc_av - Tank.iner_ar*dt
        Tank.x = Tank.x + Tank.v_av*math.cos(Tank.rot_base)*Tank.acc_av*dt
        Tank.y = Tank.y + Tank.v_av*math.sin(Tank.rot_base)*Tank.acc_av*dt
      else
        Tank.acc_av = 0
      end
    end
      -- Reculer
    if love.keyboard.isDown("s") and not love.keyboard.isDown("z") then
      Tank.acc_av = Tank.acc_av - Tank.iner_ar*dt
      Tank.acc_ar = Tank.acc_ar + Tank.iner_av*dt
      if Tank.acc_ar >= 1 then
        Tank.acc_ar = 1
      end
      Tank.x = Tank.x - Tank.v_ar*math.cos(Tank.rot_base)*Tank.acc_ar*dt
      Tank.y = Tank.y - Tank.v_ar*math.sin(Tank.rot_base)*Tank.acc_ar*dt
    else
      if Tank.acc_ar > 0 then
        Tank.acc_ar = Tank.acc_ar - Tank.iner_ar*dt
        Tank.x = Tank.x - Tank.v_ar*math.cos(Tank.rot_base)*Tank.acc_ar*dt
        Tank.y = Tank.y - Tank.v_ar*math.sin(Tank.rot_base)*Tank.acc_ar*dt
      else
        Tank.acc_ar = 0
      end
    end
  --
  -- Rotation du tank
    -- Rotation droite
    if love.keyboard.isDown("q") then
      Tank.acc_rotg_base = Tank.acc_rotg_base + Tank.frot_base*dt
      if Tank.acc_rotg_base >= 1 then
        Tank.acc_rotg_base = 1
      end
      if love.keyboard.isDown("s") then
        --Tank.inv_rot = true -----------------------------
        Tank.rot_base = Tank.rot_base + Tank.v_rot_base*Tank.acc_rotg_base*dt
      else
        Tank.rot_base = Tank.rot_base - Tank.v_rot_base*Tank.acc_rotg_base*dt
      end
    else
      Tank.acc_rotg_base = Tank.acc_rotg_base - Tank.frot_base*2*dt
      ----if Tank.inv_rot == true then
        ---Tank.rot_base = Tank.rot_base + Tank.v_rot_base*(60*dt)*Tank.acc_rotg_base
      ----else
        ----Tank.rot_base = Tank.rot_base - Tank.v_rot_base*(60*dt)*Tank.acc_rotg_base
      ----end
      if Tank.acc_rotg_base <= 0 then
        Tank.acc_rotg_base = 0
        ----Tank.inv_rot = false
      end
    end
    -- Rotation gauche
    if love.keyboard.isDown("d") then
      Tank.acc_rotd_base = Tank.acc_rotd_base + Tank.frot_base*dt
      if Tank.acc_rotd_base >= 1 then
        Tank.acc_rotd_base = 1
      end
      if love.keyboard.isDown("s") then
        ----Tank.inv_rot = true
        Tank.rot_base = Tank.rot_base - Tank.v_rot_base*Tank.acc_rotd_base*dt
      else
        Tank.rot_base = Tank.rot_base + Tank.v_rot_base*Tank.acc_rotd_base*dt
      end
    else
      Tank.acc_rotd_base = Tank.acc_rotd_base - Tank.frot_base*2*dt
      ----if Tank.inv_rot == true then
        -----Tank.rot_base = Tank.rot_base - Tank.v_rot_base*(60*dt)*Tank.acc_rotd_base
      ----else
        ----Tank.rot_base = Tank.rot_base + Tank.v_rot_base*(60*dt)*Tank.acc_rotd_base
      ----end
      if Tank.acc_rotd_base <= 0 then
        Tank.acc_rotd_base = 0
        --Tank.inv_rot = false
      end
    end
  --
  -- Limites de mouvement
    -- Angles de rotation de la base
    if Tank.rot_base >= math.rad(180) then
      Tank.rot_base = math.rad(-180)
    elseif Tank.rot_base <= math.rad(-180) then
      Tank.rot_base = math.rad(180)
    end
    -- Bords droite/gauche
    if Tank.x <= Tank.largeur/2 then
      Tank.x = Tank.largeur/2
    elseif Tank.x >= Largeur-(Tank.largeur/2) then
      Tank.x = Largeur-(Tank.largeur/2)
    end
    -- Bords haut/bas
    if Tank.y <= Tank.hauteur/2 then
      Tank.y = Tank.hauteur/2
    elseif Tank.y >= Hauteur-(Tank.hauteur/2) then
      Tank.y = Hauteur-(Tank.hauteur/2)
    end
    -- Limites par collisions avec l'ennemi / destruction par collision
    for e=#Ennemi,1,-1 do
        if math.dist(Tank.x,Tank.y,Ennemi[e].x,Ennemi[e].y) <= Tank.hauteur then
          Tank.x = Tank.x - Tank.v_av*math.cos(Tank.rot_base)*Tank.acc_av*2*dt
          Tank.y = Tank.y - Tank.v_av*math.cos(Tank.rot_base)*Tank.acc_av*2*dt
          if Tank.acc_av >= 1 then
            if Tank.belier_on == true then
              Rocket.Gen_Destruction(Ennemi[e].x,Ennemi[e].y)
              Ennemi[e].vie = 0
              table.remove(Ennemi,e)
              Son.Gen_sndExplosion()
              Son.Gen_sndDestruction()
              Tank.score = Tank.score + 4
            else
              Tank.vie = 0
              Display.action = true
            end
          end
          Tank.acc_av = 0
        end
      if love.keyboard.isDown("s") then
        if math.dist(Tank.x,Tank.y,Ennemi[e].x,Ennemi[e].y) <= Tank.hauteur then
          Tank.x = Tank.x + Tank.v_av*math.cos(Tank.rot_base)*Tank.acc_ar*4*dt
          Tank.y = Tank.y + Tank.v_av*math.cos(Tank.rot_base)*Tank.acc_ar*4*dt
          Tank.acc_ar = 0
        end
      end
    end
  --
  -- Rotation du canon
    -- Paramètre l'angle du canon variant en 0 et 360
    if Tank.rot_canon >= math.rad(360) then
      Tank.rot_canon = math.rad(0)
    elseif Tank.rot_canon <= math.rad(0) then
      Tank.rot_canon = math.rad(360)
    end
    -- Enregistre les coordonnées de la souris
    Tank.x_mouse = love.mouse.getX()
    Tank.y_mouse = love.mouse.getY()
    -- Enregistre l'angle entre le tank et la souris
    if math.angle(Tank.x,Tank.y,Tank.x_mouse,Tank.y_mouse) > 0 then
      Tank.angl_vis = math.angle(Tank.x,Tank.y,Tank.x_mouse,Tank.y_mouse)
    else
      Tank.angl_vis = math.rad(180) + (math.rad(180)-math.abs(math.angle(Tank.x,Tank.y,Tank.x_mouse,Tank.y_mouse)))
    end
    -- Paramètre l'angle tank/visuer variant en 0 et 360
    if Tank.angl_vis >= math.rad(360) then
      Tank.angl_vis = math.rad(0)
    elseif Tank.angl_vis <= math.rad(0) then
      Tank.angl_vis = math.rad(360)
    end
    -- Rotation du canon
    Tank.rot_canon = Tank.angl_vis
  --
  -- Rechargement du canon
    if Tank.reload == true then
      Son.sndReload:play()
      Tank.chronotir = Tank.chronotir + dt
      if Tank.chronotir >= 1.5 then
        Tank.reload = false
        Tank.chronotir = 0
      end
    end
  --
  -- Flamme du tir
    if Tank.flamme == true then
      Tank.chronoflamme = Tank.chronoflamme + 24*dt
      if Tank.chronoflamme >= 4 then
        Tank.flamme = false
        Tank.chronoflamme = 1
      end
    end
  --
  -- Flammes du speed
    if Tank.acc_av >= 1 then
      Tank.chronospeed = Tank.chronospeed + 24*dt
      if Tank.chronospeed >= 18 then
        Tank.chronospeed = 4
      end
    else
      Tank.chronospeed = 1
    end
  --
  -- Bélier
    if Tank.acc_av >= 1 then
      -- Save de la trainée du tank en vitesse max
      local trainee = {}
      trainee.x = Tank.x
      trainee.y = Tank.y
      trainee.angle_base = Tank.rot_base
      trainee.angle_canon = Tank.rot_canon
      trainee.perma = 0.1
      table.insert(Tank.Trace, trainee)
      -- Ouverture du bélier
      if love.keyboard.isDown("space") then
        Tank.chronobelier = Tank.chronobelier + 30*dt
        Tank.belier_anim = true
        if Tank.chronobelier >= 6 then
          Tank.chronobelier = 6
          Tank.belier_on = true
        end
      -- Fermeture du bélier si espace relâché
      else
        Tank.chronobelier = Tank.chronobelier - 30*dt
        Tank.belier_on = false
        if Tank.chronobelier <= 1 then
          Tank.chronobelier = 1
          Tank.belier_anim = false
        end
      end
    -- Fermeture du bélier si accélération relâchée
    else
      Tank.chronobelier = Tank.chronobelier - 30*dt
      Tank.belier_on = false
        if Tank.chronobelier <= 1 then
          Tank.chronobelier = 1
          Tank.belier_anim = false
        end
    end
  --
  --
  else
  -- Supprime les sons et animations du Tank
    Tank.acc_av = Tank.acc_av - Tank.iner_av*dt
    if Tank.acc_av <= 0 or Son.sndChaines:isPlaying() or Son.sndRotation:isPlaying() then
      Tank.acc_av = 0
      Son.sndChaines:stop()
      Son.sndRotation:stop()
      Tank.belier_anim = false
      Tank.belier_on = false
    end
  --
  end
-- Efface et supprime la trainée du tank
  for tr=#Tank.Trace,1,-1 do
    Tank.Trace[tr].perma = Tank.Trace[tr].perma - dt/2
    if Tank.Trace[tr].perma <= 0 then
      table.remove(Tank.Trace, tr)
    end
  end
--
end
--
--------------------------------------------------------------------------------------------------------------
--
function Tank.draw()
--
-- Hors scène
  if Display.action == false then
  -- Flammes speed roue
    for tr=#Tank.Trace,1,-1 do
      love.graphics.setColor(1,1,1,Tank.Trace[tr].perma*4)
      love.graphics.draw(Tank.img_speed[math.floor(Tank.chronospeed)], Tank.Trace[tr].x, Tank.Trace[tr].y, Tank.rot_base, 4, 1.5, Tank.ox+15, Tank.oy-5)
      love.graphics.draw(Tank.img_speed[math.floor(Tank.chronospeed)], Tank.Trace[tr].x, Tank.Trace[tr].y, Tank.rot_base, 4, 1.5, Tank.ox+15, Tank.oy-28)
      love.graphics.setColor(1,1,1,Display.chronoalpha)
    end
  -- Trainée du tank
    for tr=#Tank.Trace,1,-1 do
      love.graphics.setColor(1,1,1,Tank.Trace[tr].perma)
      love.graphics.draw(Tank.img_base, Tank.Trace[tr].x, Tank.Trace[tr].y, Tank.Trace[tr].angle_base, 1, 1, Tank.ox, Tank.oy)
      love.graphics.draw(Tank.img_canon, Tank.Trace[tr].x, Tank.Trace[tr].y, Tank.Trace[tr].angle_canon, 1, 1, Tank.ox, Tank.oy)
      love.graphics.setColor(1,1,1,Display.chronoalpha)
    end
  -- Base
    if Display.action == false then
      if Tank.belier_anim == false then
        love.graphics.draw(Tank.img_base, Tank.x, Tank.y, Tank.rot_base, 1, 1, Tank.ox, Tank.oy)
      else
        love.graphics.draw(Tank.img_belier[math.floor(Tank.chronobelier)], Tank.x, Tank.y, Tank.rot_base, 1, 1, Tank.ox, Tank.oy)
      end
    end
  -- Chaines
  if love.keyboard.isDown("z") or love.keyboard.isDown("s") then
    love.graphics.draw(Tank.img_chaines[math.floor(Tank.chronochaines)], Tank.x, Tank.y, Tank.rot_base, 1, 1, Tank.ox, Tank.oy)
  end
  -- Canon
    love.graphics.draw(Tank.img_canon, Tank.x, Tank.y, Tank.rot_canon, 1, 1, Tank.ox, Tank.oy)
  -- Flamme du tir
    if Tank.flamme == true then
      love.graphics.draw(Tank.img_flamme[math.floor(Tank.chronoflamme)], Tank.x + 20*math.cos(Tank.rot_canon), Tank.y + 20*math.sin(Tank.rot_canon), Tank.rot_canon, 1, 1, 0, Tank.flamme_hauteur/2)
    end
  end
--
-- Scène active
  if Display.action == true then
    -- Animation de défaite et apparition du début
    if Tank.vie == 0 or (Tank.vie == 10 and Jeu.niveau6 == false) then
      if Display.chronoanim <= 2.5 then
        love.graphics.draw(Tank.img_base, Tank.x, Tank.y, Tank.rot_base, 1, 1, Tank.ox, Tank.oy)
        love.graphics.draw(Tank.img_canon, Tank.x, Tank.y, Tank.rot_canon, 1, 1, Tank.ox, Tank.oy)
      end
    end
    -- Animation de victoire
    if Jeu.niveau6 == true then
      love.graphics.draw(Tank.img_base, Tank.x, Tank.y, Tank.rot_base, 1, 1, Tank.ox, Tank.oy)
      love.graphics.draw(Tank.img_canon, Tank.x, Tank.y, Tank.rot_canon, 1, 1, Tank.ox, Tank.oy)
    end
  end
-- Trainée du tank (à mettre ici pour l'effet flou sur le tank)
  --for tr=#Tank.Trace,1,-1 do
    --love.graphics.setColor(1,1,1,Tank.Trace[tr].perma)
    --love.graphics.draw(Tank.img_base, Tank.Trace[tr].x, Tank.Trace[tr].y, Tank.Trace[tr].angle_base, 1, 1, Tank.ox, Tank.oy)
    --love.graphics.draw(Tank.img_canon, Tank.Trace[tr].x, Tank.Trace[tr].y, Tank.Trace[tr].angle_canon, 1, 1, Tank.ox, Tank.oy)
    --love.graphics.setColor(1,1,1,Display.chronoalpha)
  --end
--
end
--
--------------------------------------------------------------------------------------------------------------
--
function Tank.mousepressed(px,py,nb)
--
  if nb == 1 then
    if Tank.reload == false then
      Rocket.Gen_Tir("joueur", Tank.x + 30*math.cos(Tank.rot_canon), Tank.y + 30*math.sin(Tank.rot_canon), Tank.rot_canon)
      if Son.sndReload:isPlaying() then
        Son.sndReload:stop()
      end
      Tank.flamme = true
      Tank.reload = true
    end
  end
--
end
--
--------------------------------------------------------------------------------------------------------------
--
return Tank
--