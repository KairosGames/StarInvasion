--
local Display = {}
--
--------------------------------------------------------------------------------------------------------------
--
function Display.load()
--
-- Système display
  -- Souris
  Display.x_mouse = love.mouse.getX()
  Display.y_mouse = love.mouse.getY()
  Display.x_filtre = Largeur
  Display.x_pause = 0 - Largeur
  Display.y_filtreL = 0 - Hauteur
  Display.y_filtreW = Hauteur
  -- Chronos et conditions
  Display.chronoalpha = 0
  Display.chronoanim = 0
  Display.chronoson = 1
  Display.choice = false
  Display.action = false
  Display.curseur_in = false
  Display.transition = true
  Display.animtank0 = true
  Display.animtank1 = false
  Display.animtank2 = false
  Display.animtank3 = false
  Display.animtank4 = false
  Display.animtank5 = false
  Display.alphapause = 0
  Display.chronopause = 0
  Display.pause = false
  -- Menu
  Display.img_menufond = love.graphics.newImage("images/display/menu_img.jpg")
  Display.img_menufiltre = love.graphics.newImage("images/display/menu_filtre.png")
  Display.img_ctrlfiltre = love.graphics.newImage("images/display/controles_filtre.png")
  -- Pause
  Display.img_pause = love.graphics.newImage("images/display/pause_img.png")
  -- Défaite
  Display.img_gameoverfond = love.graphics.newImage("images/display/gameover_img.png")
  Display.img_gameoverfiltre = love.graphics.newImage("images/display/gameover_filtre.png")
  -- Victoire
  Display.img_victoirefond = love.graphics.newImage("images/display/victoire_img.png")
  Display.img_victoirefiltre = love.graphics.newImage("images/display/victoire_filtre.png")
  -- Scoring
  Display.ts_score = love.graphics.newImage("images/display/score_ts.png")
  -- Filtres des niveaux
  Display.img_niveau = {}
  for n=1,6 do
    Display.img_niveau[n] = love.graphics.newImage("images/display/lvl"..n..".png")
  end
  Display.img_niveau_ulti = love.graphics.newImage("images/display/lvlulti.png")
--
--En jeu
  -- Images vies tank
  Display.img_shieldG = love.graphics.newImage("images/armor_left.png")
  Display.img_shieldD = love.graphics.newImage("images/armor_right.png")
  Display.shield_largeur = Display.img_shieldG:getWidth()
  Display.shield_hauteur = Display.img_shieldG:getHeight()
  Display.chronoshield = 0
  -- Images vies ennemis
  Display.img_shieldadv = love.graphics.newImage("images/armoradv.png")
  -- Images score in game
    -- Intitulé
  Display.img_score = love.graphics.newImage("images/score.png")
  Display.score_largeur = Display.img_score:getWidth()
  Display.score_hauteur = Display.img_score:getHeight()
    -- Chiffres du score in game
  Display.ts_score_IG = love.graphics.newImage("images/score_ts_IG.png")
  Display.n_score = {}
  Display.ch_largeur = 65
  Display.ch_hauteur = 54
  for ch=1,10 do
    Display.n_score[ch] = love.graphics.newQuad((ch-1)*Display.ch_largeur, 0, Display.ch_largeur, Display.ch_hauteur, Display.ch_largeur*10, Display.ch_hauteur)
  end
  -- Viseur
  Display.viseur_on = love.graphics.newImage("images/viseur_on.png")
  Display.viseur_off = love.graphics.newImage("images/viseur_off.png")
--
end
--
--------------------------------------------------------------------------------------------------------------
--
function Display.update(dt)
--
-- Coordonnées souris
  Display.x_mouse = love.mouse.getX()
  Display.y_mouse = love.mouse.getY()
--
-- Son de préselection dans les interfaces
  if (Display.etat == "menu" or Display.etat == "loose" or Display.etat == "win") and Display.choice == true then
    if not love.keyboard.isDown("tab") then
      if (Display.x_mouse > 1419 and Display.x_mouse < 1738  and Display.y_mouse > 809 and Display.y_mouse < 899) or 
        (Display.x_mouse > 1419 and Display.x_mouse < 1738  and Display.y_mouse > 931 and Display.y_mouse < 1021) then
        if Display.curseur_in == false then
          Son.sndCurseur:play()
          Display.curseur_in = true
        end
      else
        Display.curseur_in = false
      end
    end
  end
--
-- Menu
--
  if Display.etat == "menu" then
  -- Retour souris
    love.mouse.setVisible(true)
    Son.sndMenu:play()
  -- Affichage des contrôles
    if Display.choice == true then
      if love.keyboard.isDown("tab") then
        Display.chronoalpha = 0.05
      else
        Display.chronoalpha = 1
      end
    end
  -- Ouverture
    if Display.action == false then
      Display.x_filtre = 0
    -- Apparition fondue du fond du menu
      Display.chronoalpha = Display.chronoalpha + dt/3
      if Display.chronoalpha >= 1 then
        Display.chronoalpha = 1
    -- Affichage des filtres menu
        Display.y_filtreW = Display.y_filtreW - 120*dt
        if Display.y_filtreW <= Hauteur/4 and Display.transition == true then
          Display.y_filtreW = Hauteur/4
          Display.chronoanim = Display.chronoanim + dt
          if Display.chronoanim >= 5 then
            Display.chronoanim = 0
            Display.transition = false
          end
        elseif Display.y_filtreW <= 0 then
          Display.y_filtreW = 0
          Display.choice = true
        end
      end
  -- Fermeture
    else
    -- Retrait des filtres menu
      Display.x_filtre = Display.x_filtre - 1920*dt
      if Display.x_filtre <= 0 - Largeur then
        Display.x_filtre = 0 - Largeur
    -- Disparition fondue du fond
        Display.chronoalpha = Display.chronoalpha - dt/3
        Son.sndMenu:setVolume(Display.chronoalpha*0.4)
        if Display.chronoalpha <= 0 then
          Display.chronoalpha = 0
          Son.sndMenu:stop()
          Display.etat = "play"
          Display.y_filtreW = Hauteur
          Display.x_filtre = Largeur
          Display.transition = true
        end
      end
    end
  end
--
-- Jeu qui tourne
--
  if Display.etat == "play" then
  -- Action commencement / action défaite / action victoire
    -- Commencement, apparition en fondue
    if Display.action == true and Tank.vie > 0 and Jeu.niveau6 == false then
      if Display.animtank0 == true then
        Display.chronoalpha = Display.chronoalpha + dt/2
        Son.sndChaineanim:setVolume(Display.chronoalpha)
        Son.sndChaineanim:play()
        if Display.chronoalpha >= 1 then
          Display.animtank0 = false
          Display.chronoalpha = 1
          Display.animtank1 = true
        end
      end
      if Display.animtank1 == true then
        Tank.y = Tank.y - (Tank.v_av/1.5)*dt
        if Tank.y <= Hauteur - Hauteur/4 then
          Tank.y = Hauteur - Hauteur/4
          Son.sndChaineanim:stop()
          Display.chronoanim = Display.chronoanim + dt
          if Display.chronoanim >= 1 then
            Display.animtank1 = false
            Display.chronoanim = 0
            Display.animtank2 = true
          end
        end
      end
      if Display.animtank2 == true then
        Son.sndRotationanim:play()
        Tank.rot_canon = Tank.rot_canon - Tank.v_rot_base*dt/3
        if Tank.rot_canon <= math.rad(-157.5) then
          Display.animtank2  = false
          Tank.rot_canon = math.rad(-157.5)
          Display.animtank3  = true
          Son.sndRotationanim:stop()
        end
      end
      if Display.animtank3 == true then
        Son.sndRotationanim:play()
        Tank.rot_canon = Tank.rot_canon + Tank.v_rot_base*dt/3
        if Tank.rot_canon >= math.rad(-22.5) then
          Display.animtank3  = false
          Tank.rot_canon =  math.rad(-22.5)
          Display.animtank4  = true
          Son.sndRotationanim:stop()
        end
      end
      if Display.animtank4 == true then
        Son.sndRotationanim:play()
        Tank.rot_canon = Tank.rot_canon - Tank.v_rot_base*dt/3
        if Tank.rot_canon <= math.rad(-90) then
          Display.animtank4 = false
          Son.sndRotationanim:stop()
          Tank.rot_canon =  math.rad(-90)
          Display.animtank5 = true
          Son.sndRotationanim:stop()
        end
      end
      if Display.animtank5 == true then
        Display.chronoanim = Display.chronoanim + dt
        if Display.chronoanim >= 1.5 then
          Display.action = false
          Display.animtank0 = true
          Display.animtank5 = false
          Display.chronoanim = 0
        end
      end
    --
    -- Défaite, explosion, disparition en fondu
    elseif Display.action == true and Tank.vie == 0 then
      Display.chronoanim = Display.chronoanim + dt
      if Display.chronoanim >= 0.1 and Display.chronoanim <= 0.2 then
        Rocket.Gen_Destruction(Tank.x,Tank.y)
        Son.sndDestruction_tank:play()
      elseif Display.chronoanim >= 0.5 and Display.chronoanim <= 0.6 then
        Rocket.Gen_Destruction(Tank.x,Tank.y)
      elseif Display.chronoanim >= 1.3 and Display.chronoanim <= 1.4 then
        Rocket.Gen_Destruction(Tank.x,Tank.y)
      elseif Display.chronoanim >= 1.7 and Display.chronoanim <= 1.8 then
        Rocket.Gen_Destruction(Tank.x,Tank.y)
      elseif Display.chronoanim >= 2.5 and Display.chronoanim <= 2.6 then
        Rocket.Gen_Destruction(Tank.x,Tank.y)
      elseif Display.chronoanim >= 2.6 and Display.chronoanim <= 8 then
        Display.chronoalpha = Display.chronoalpha - dt/2
        if Display.chronoalpha <= 0 then
          Son.sndDefaite:play()
          if Tank.score < 16 then
            Son.sndBigloose:play()
          end
          Display.chronoalpha = 0
        end
      elseif Display.chronoanim >= 8 then
        Display.etat = "loose"
        Display.action = false
        Display.chronoanim = 0
      end
    --
    -- Victoire, sortie d'écran, disparition en fondu 
    elseif Display.action == true and Jeu.niveau6 == true then
      Display.chronoanim = Display.chronoanim + dt
      if Display.chronoanim >= 2 then
      -- Remise à niveau du canon
        if Tank.rot_canon > math.rad(90) and Tank.rot_canon < math.rad(270) then
          Tank.rot_canon = Tank.rot_canon + (Tank.v_rot_base/3)*dt
          Son.sndRotationanim:play()
          if Tank.rot_canon >= math.rad(270) then
            Tank.rot_canon = math.rad(270)
          end
        elseif Tank.rot_canon > math.rad(270) and Tank.rot_canon < math.rad(360) then
          Tank.rot_canon = Tank.rot_canon - (Tank.v_rot_base/3)*dt
          Son.sndRotationanim:play()
          if Tank.rot_canon <= math.rad(270) then
            Tank.rot_canon = math.rad(270)
          end
        elseif Tank.rot_canon < math.rad(90) then
          Tank.rot_canon = Tank.rot_canon - (Tank.v_rot_base/3)*dt
          Son.sndRotationanim:play()
          if Tank.rot_canon <= math.rad(-90) then
            Tank.rot_canon = math.rad(-90)
          end
        end
      -- Remise à niveau de la base
        if Tank.rot_base > math.rad(90) and Tank.rot_base < math.rad(270) then
          Tank.rot_base = Tank.rot_base + (Tank.v_rot_base/2)*dt
          Son.sndRotationanim:play()
          if Tank.rot_base >= math.rad(270) then
            Tank.rot_base = math.rad(270)
          end
        elseif Tank.rot_base > math.rad(-90) and Tank.rot_base < math.rad(90) then
          Tank.rot_base = Tank.rot_base - (Tank.v_rot_base/2)*dt
          Son.sndRotationanim:play()
          if Tank.rot_base <= math.rad(-90) then
            Tank.rot_base = math.rad(-90)
          end
        elseif Tank.rot_base < math.rad(-90) then
          Tank.rot_base = Tank.rot_base + (Tank.v_rot_base/2)*dt
          Son.sndRotationanim:play()
          if Tank.rot_base >= math.rad(-90) then
            Tank.rot_base = math.rad(-90)
          end
        end
      -- Sortie du tank par le haut
        if Tank.rot_base == math.rad(270) or Tank.rot_base == math.rad(-90) then
          Son.sndRotationanim:stop()
          Tank.y = Tank.y - (Tank.v_av/1.5)*dt
          Son.sndChaineanim:play()
          if Tank.y <= 0 then
            Display.chronoalpha = Display.chronoalpha - dt/4
            Son.sndChaineanim:setVolume(Display.chronoalpha)
            if Display.chronoalpha <= 0 then
              Son.sndChaineanim:stop()
              Display.etat = "win"
              Tank.score = Tank.score + Tank.vie
              Display.action = false
              Display.chronoalpha = 0
              Display.chronoanim = 0
              Son.sndVictoire:play()
            end
          end
        end
      end
      --
    end
  --
  -- Clignotement de la vie
    if Display.etat == "play" and Display.action == false then
      if Tank.vie == 1 then
        Son.sndAlarm:play()
        Display.chronoshield = Display.chronoshield + dt
        if Display.chronoshield >= 1 then
          Display.chronoshield = 0
        end
      else
        Son.sndAlarm:stop()
        Display.chronoshield = 0
      end
    else
      Son.sndAlarm:stop()
      Display.chronoshield = 0
    end
  --
  end
--
-- Défaite
--
  if Display.etat == "loose" then
  -- Retour souris
    love.mouse.setVisible(true)
  -- Ouverture
    if Display.action == false then
    -- Apparition fondue du fond de défaite
      Display.chronoalpha = Display.chronoalpha + dt/3
      if Display.chronoalpha >= 1 then
        Display.chronoalpha = 1
    -- Affichage des filtres menu
        Display.y_filtreL = Display.y_filtreL + 1920*dt
        if Display.y_filtreL >= 0 then
          Display.y_filtreL = 0
          Display.choice = true
        end
      end
  -- Fermeture
    else
    -- Retrait des filtres menu
      Display.y_filtreL = Display.y_filtreL + 1920*dt
      if Display.y_filtreL >= Hauteur then
        Display.y_filtreL = Hauteur
    -- Disparition fondue du fond
        Display.chronoalpha = Display.chronoalpha - dt/3
        if Display.chronoalpha <= 0 then
          Display.chronoalpha = 0
          Display.etat = "menu"
          Display.y_filtreL = 0 - Hauteur
          Display.action = false
        end
      end
    end
  end
--
-- Victoire
--
  if Display.etat == "win" then
  -- Retour souris
    love.mouse.setVisible(true)
  -- Ouverture
    if Display.action == false then
      Display.x_filtre = 0
    -- Apparition fondue du fond de défaite
      Display.chronoalpha = Display.chronoalpha + dt/3
      if Display.chronoalpha >= 1 then
        Display.chronoalpha = 1
    -- Affichage des filtres menu
        Display.y_filtreW = Display.y_filtreW - 120*dt
        if Display.y_filtreW <= 0 then
          Display.y_filtreW = 0
          Display.choice = true
        end
      end
  -- Fermeture
    else
    -- Retrait des filtres menu
      Display.x_filtre = Display.x_filtre - 1920*dt
      if Display.x_filtre <= 0 - Largeur then
        Display.x_filtre = 0 - Largeur
    -- Disparition fondue du fond
        Display.chronoalpha = Display.chronoalpha - dt/3
        if Display.chronoalpha <= 0 then
          Display.chronoalpha = 0
          Display.etat = "menu"
          Display.x_filtre = Largeur
          Display.y_filtreW = Hauteur
          Display.action = false
        end
      end
    end
  end
--
-- Pause
--
  if Display.etat == "pause" then
    Display.chronopause = Display.chronopause + dt
    Display.x_pause = Display.x_pause - 3840*dt
    if Display.chronopause >= 0.65 then
      Display.chronopause = 0.65
    end
    if Display.x_pause <= 0 then
      Display.x_pause = 0
    end
  else
    Display.x_pause = Display.x_pause - 3840*dt
    Display.chronopause = 0
    if Display.x_pause <= 0 - Largeur then
      Display.x_pause = 0 - Largeur
    end
  end
--
  if love.keyboard.isDown("z") and not love.keyboard.isDown("s") then
    Tank.chronochaines = Tank.chronochaines + 30*dt*Tank.acc_av
  elseif love.keyboard.isDown("s") and not love.keyboard.isDown("z") then
    Tank.chronochaines = Tank.chronochaines + 10*dt*Tank.acc_ar
  end
  if Tank.chronochaines >= 3 then
      Tank.chronochaines = 1
  end
--
end
--
--------------------------------------------------------------------------------------------------------------
--
function Display.draw()
--
-- Paramètre de fondu écran
  love.graphics.setColor(1, 1, 1, Display.chronoalpha)
--
-- Menu
--
  if Display.etat == "menu" then
  -- Fond menu en fondu
    love.graphics.draw(Display.img_menufond, 0, 0)
  -- Affichage filtres menu
    love.graphics.draw(Display.img_menufiltre, Display.x_filtre, Display.y_filtreW)
  -- Sélection souris
    if Display.choice == true then
      if love.keyboard.isDown("tab") then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(Display.img_ctrlfiltre, 0, 0)
        love.graphics.setColor(1, 1, 1, 0.05)
      else
        if Display.x_mouse > 1419 and Display.x_mouse < 1738  and Display.y_mouse > 809 and Display.y_mouse < 899 then
          love.graphics.setColor(1, 0, 1)
          love.graphics.rectangle("line", 1419, 809, 319, 90, 10, 10, 100)
          love.graphics.setColor(1, 1, 1)
        elseif Display.x_mouse > 1419 and Display.x_mouse < 1738  and Display.y_mouse > 931 and Display.y_mouse < 1021 then
          love.graphics.setColor(0, 1, 1)
          love.graphics.rectangle("line", 1419, 931, 319, 90, 10, 10, 100)
          love.graphics.setColor(1, 1, 1)
        end
      end
    end
  --
  end
--
-- En jeu
--
  if Display.etat == "play" or Display.etat == "pause" then
  -- Filtre des niveaux
    if Jeu.anim1 == true then
      love.graphics.draw(Display.img_niveau[1], Display.x_filtre, 0)
    elseif Jeu.anim2 == true then
      love.graphics.draw(Display.img_niveau[2], Display.x_filtre, 0)
    elseif Jeu.anim3 == true then
      love.graphics.draw(Display.img_niveau[3], Display.x_filtre, 0)
    elseif Jeu.anim4 == true then
      love.graphics.draw(Display.img_niveau[4], Display.x_filtre, 0)
    elseif Jeu.anim5 == true then
      love.graphics.draw(Display.img_niveau[5], Display.x_filtre, 0)
    elseif Jeu.anim6 == true then
      love.graphics.draw(Display.img_niveau_ulti, Display.x_filtre, 0)
    end
    love.graphics.setColor(1,1,1,1) -- (transparance off)
  -- Vies du tank à l'écran (transparance off)
    for n=1,Tank.vie,2 do
      if Tank.vie > 1 then
        love.graphics.draw(Display.img_shieldG, 50 + (Display.shield_largeur/2)*(n-1) , Hauteur-Display.shield_hauteur-20)
      else
        if Display.chronoshield <= 0.5 then
          love.graphics.draw(Display.img_shieldG, 50 + (Display.shield_largeur/2)*(n-1) , Hauteur-Display.shield_hauteur-20)
        end
      end
      for n=2,Tank.vie,2 do
        love.graphics.draw(Display.img_shieldD, 50 + (Display.shield_largeur/2)*(n-2) , Hauteur-Display.shield_hauteur-20)
      end
    end
  -- Score (transparance off)
    love.graphics.draw(Display.img_score, 
                      Largeur - 50 - (Display.score_largeur - Display.score_largeur/4) - (2*Display.ch_largeur - 2*Display.ch_largeur/4),
                      Hauteur-Display.score_hauteur - 30,
                      0, 0.75, 0.75
                      )
    love.graphics.draw(Display.ts_score_IG,
                      Display.n_score[math.floor(Tank.score/10)+1],
                      Largeur - 50 - (Display.ch_largeur*2 - 2*Display.ch_largeur/4),
                      Hauteur - Display.ch_hauteur - 30,
                      0, 0.75, 0.75
                      )
    love.graphics.draw(Display.ts_score_IG,
                      Display.n_score[((Tank.score)+1)-(math.floor(Tank.score/10)*10)],
                      Largeur - 50 - (Display.ch_largeur - Display.ch_largeur/4),
                      Hauteur - Display.ch_hauteur - 30,
                      0, 0.75, 0.75
                    )
    love.graphics.setColor(1,1,1,Display.chronoalpha) -- (transparance on)
  -- Vies des ennemis
    for e=#Ennemi,1,-1 do
      for v=1,Ennemi[e].vie do
        if Display.action == false then
          love.graphics.setColor(1,1,1,0.8)
        else
          love.graphics.setColor(1,1,1,Display.chronoalpha-0.2)
        end
        love.graphics.draw(Display.img_shieldadv, Ennemi[e].x - 10 + (v-1)*20, Ennemi[e].y - 40, 0, 1, 1, 5, 5)
        love.graphics.setColor(1,1,1,Display.chronoalpha)
      end
    end
  -- Viseur
    if Display.action == false then
      if Tank.reload == false then
        love.graphics.draw(Display.viseur_on, Tank.x_mouse, Tank.y_mouse, 0, 1, 1, 16, 15)
      else
        love.graphics.draw(Display.viseur_off, Tank.x_mouse, Tank.y_mouse, 0, 1, 1, 16, 15)
      end
    end
  -- Pause
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(Display.img_pause, Display.x_pause, 0)
    love.graphics.setColor(1,1,1, Display.chronoalpha)
  -- 
  end
--
-- Défaite
--
  if Display.etat == "loose" then
  -- Fond défaite en fondu
    love.graphics.draw(Display.img_gameoverfond, 0, 0)
  -- Affichage filtres défaite
    love.graphics.draw(Display.img_gameoverfiltre, 0, Display.y_filtreL)
  -- Affichage score
    love.graphics.draw(Display.ts_score,
                      Display.n_score[math.floor(Tank.score/10)+1],
                      547,
                      904 + Display.y_filtreL,
                      0, 1, 1
                      )
    love.graphics.draw(Display.ts_score,
                      Display.n_score[((Tank.score)+1)-(math.floor(Tank.score/10)*10)],
                      547 + Display.ch_largeur,
                      904 + Display.y_filtreL,
                      0, 1, 1
                      )
  -- Sélection souris
    if Display.choice == true then
      if Display.x_mouse > 1419 and Display.x_mouse < 1738  and Display.y_mouse > 809 and Display.y_mouse < 899 then
        love.graphics.setColor(1, 0, 1)
        love.graphics.rectangle("line", 1419, 809, 319, 90, 10, 10, 100)
        love.graphics.setColor(1, 1, 1)
      elseif Display.x_mouse > 1419 and Display.x_mouse < 1738  and Display.y_mouse > 931 and Display.y_mouse < 1021 then
        love.graphics.setColor(0, 1, 1)
        love.graphics.rectangle("line", 1419, 931, 319, 90, 10, 10, 100)
        love.graphics.setColor(1, 1, 1)
      end
    end
  --
  end
--
-- Victoire
--
  if Display.etat == "win" then
  -- Fond défaite en fondu
    love.graphics.draw(Display.img_victoirefond, 0, 0)
  -- Affichage filtres défaite
    love.graphics.draw(Display.img_victoirefiltre, Display.x_filtre, Display.y_filtreW)
  -- Affichage score
    love.graphics.draw(Display.ts_score,
                      Display.n_score[math.floor(Tank.score/10)+1],
                      547 + Display.x_filtre,
                      904 + Display.y_filtreW,
                      0, 1, 1
                      )
    love.graphics.draw(Display.ts_score,
                      Display.n_score[((Tank.score)+1)-(math.floor(Tank.score/10)*10)],
                      547 + Display.ch_largeur + Display.x_filtre,
                      904 + Display.y_filtreW,
                      0, 1, 1
                      )
  -- Sélection souris
    if Display.choice == true then
      if Display.x_mouse > 1419 and Display.x_mouse < 1738  and Display.y_mouse > 809 and Display.y_mouse < 899 then
        love.graphics.setColor(1, 0, 1)
        love.graphics.rectangle("line", 1419, 809, 319, 90, 10, 10, 100)
        love.graphics.setColor(1, 1, 1)
      elseif Display.x_mouse > 1419 and Display.x_mouse < 1738  and Display.y_mouse > 931 and Display.y_mouse < 1021 then
        love.graphics.setColor(0, 1, 1)
        love.graphics.rectangle("line", 1419, 931, 319, 90, 10, 10, 100)
        love.graphics.setColor(1, 1, 1)
      end
    end
  --
  end
--
end
--
--------------------------------------------------------------------------------------------------------------
--
function Display.keypressed(key)
--
-- Mettre en pause
  if key == "p" then
    --
    --
    if Display.etat == "play" then
      -- Alpha et position filtre
      Display.alphapause = Display.chronoalpha
      Son.sndSelect:play()
      Display.chronoalpha = 0.3
      Display.x_pause = Largeur
      -- Sons en pause
      if Son.sndLevel:isPlaying() then
        Son.sndLevel:pause()
      end
      if Son.sndDestruction_tank:isPlaying() then
        Son.sndDestruction_tank:pause()
      end
      if Son.sndChaineanim:isPlaying() then
        Son.sndChaineanim:pause()
      end
      if Son.sndRotationanim:isPlaying() then
        Son.sndRotationanim:pause()
      end
      if Son.sndChaines:isPlaying() then
        Son.sndChaines:pause()
      end
      if Son.sndRotation:isPlaying() then
        Son.sndRotation:pause()
      end
      -- Son Ingame baissé
      if Son.sndIngame:isPlaying() then
        if Display.action == false then
          Son.sndIngame:setVolume(0.1)
        else
          if Tank.vie == 0 or Jeu.niveau6 == true then
            Son.sndIngame:pause()
          end
        end
      end
      -- Mettre en pause
      Display.etat = "pause"
      --
    --
    elseif Display.etat == "pause" then
      -- Alpha
      Display.chronoalpha = Display.alphapause
      -- Sons en play
      Son.sndSelect:play()
      if Son.sndLevel:isPlaying() then
        Son.sndLevel:play()
      end
      if Son.sndDestruction_tank:isPlaying() then
        Son.sndDestruction_tank:play()
      end
      if Son.sndChaineanim:isPlaying() then
        Son.sndChaineanim:play()
      end
      if Son.sndRotationanim:isPlaying() then
        Son.sndRotationanim:play()
      end
      -- Remettre le son Ingame
      if Son.sndIngame:isPlaying() then
        if Display.action == false then
          Son.sndIngame:setVolume(0.5)
        else
          if Tank.vie == 0 or Jeu.niveau6 == true then
            Son.sndIngame:setVolume(Display.chronoson*0.6)
          end
        end
      end
      -- Sortir de la pause
      Display.etat = "play"
      --
    --
    end
  end
--
-- Quitter le jeu
  if key == "escape" then
    love.event.quit()
  end
--
end
--
--------------------------------------------------------------------------------------------------------------
--
function Display.mousereleased(px,py,nb)
--
-- Menu
  if Display.etat == "menu" and Display.choice == true then
  -- Zones sélectionnables
    if not love.keyboard.isDown("tab") then
      if nb == 1 and px > 1419 and px < 1738 and py > 809 and py < 899 then
        Display.choice = false
        Display.action = true
        Son.sndSelect:play()
        Jeu.Start()
      elseif nb == 1 and px > 1419 and px < 1738 and py > 931 and py < 1021 then
        love.event.quit()
      end
    end
  end
--
-- Défaite
  if Display.etat == "loose" and Display.choice == true then
  -- Zones sélectionnables
    if nb == 1 and px > 1419 and px < 1738 and py > 809 and py < 899 then
      Display.choice = false
      Display.action = true
      Son.sndSelect:play()
    elseif nb == 1 and px > 1419 and px < 1738 and py > 931 and py < 1021 then
      love.event.quit()
    end
  end
--
-- Victoire
  if Display.etat == "win" and Display.choice == true then
  -- Zones sélectionnables
    if nb == 1 and px > 1419 and px < 1738 and py > 809 and py < 899 then
      Display.choice = false
      Display.action = true
      Son.sndSelect:play()
    elseif nb == 1 and px > 1419 and px < 1738 and py > 931 and py < 1021 then
      love.event.quit()
    end
  end
--
end
--
--------------------------------------------------------------------------------------------------------------
--
return Display
--