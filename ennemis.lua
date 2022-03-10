--
local Ennemi = {}
--
--------------------------------------------------------------------------------------------------------------
--
function Ennemi.load()
--
-- Images
  Ennemi.img_base = love.graphics.newImage("images/baseadv.png")
  Ennemi.img_canon = love.graphics.newImage("images/canonadv.png")
-- Repères
  Ennemi.largeur = Ennemi.img_base:getWidth()
  Ennemi.hauteur = Ennemi.img_base:getHeight()
  Ennemi.ox = Ennemi.largeur/2
  Ennemi.oy = Ennemi.hauteur/2
--
  function Ennemi.Gen_Ennemi(pGenre,pX,pY,pXf,pYf)
    local ennemi = {}
    ennemi.genre = pGenre
    if pGenre == 1 or pGenre == 2 then
      ennemi.vie = 2
    end
    ennemi.on = false
    ennemi.chronotir = 1
    -- Flamme
    ennemi.flamme = false
    ennemi.chronoflamme = 1
    -- Base
    ennemi.x = pX
    ennemi.y = pY
    ennemi.v_av = 100
    ennemi.v_ar = 45
    ennemi.rot_base = math.rad(90)
    ennemi.v_rot_base = math.rad(120)
    -- Canon
    ennemi.rot_canon = math.angle(ennemi.x,ennemi.y,Tank.x,Tank.y)
    -- Positions finales et intermédiaires
    ennemi.xf = pXf
    ennemi.yf = pYf
    if pX < pXf then
      ennemi.pos = "droite"
    else
      ennemi.pos = "gauche"
    end
    ennemi.mouv1 = true
    ennemi.mouv2 = false
    ennemi.mouv3 = false
    ennemi.mouv4 = false
    ennemi.mouv5 = false
    ennemi.mouv6 = false
    ennemi.mouv7 = false
    ennemi.mouv8 = false
    ennemi.mouv9 = false
    ennemi.mouv10 = false
  --
    table.insert(Ennemi, ennemi)
  --
  end
--
end
--
--------------------------------------------------------------------------------------------------------------
--
function Ennemi.update(dt)
--
  if Display.action == false then
    for e=#Ennemi,1,-1 do
    --
    -- Comportement avant réveil
      if Ennemi[e].on == false then
        if math.dist(Tank.x,Tank.y,Ennemi[e].x,Ennemi[e].y) > Tank.largeur then
          Ennemi[e].y = Ennemi[e].y  + Ennemi[e].v_av*dt
          if Ennemi[e].y >= 0 then
            Ennemi[e].on = true
          end
        end
    --Comportement au réveil
      else
      -- Déplacement ennemis
        -- Ennemis de type 1
        if math.dist(Tank.x,Tank.y,Ennemi[e].x,Ennemi[e].y) > Tank.largeur then
          if Ennemi[e].genre == 1 then
            -- Premier mouvement, vertical
            if Ennemi[e].mouv1 == true then
              if Ennemi[e].y < Ennemi[e].yf then
                Ennemi[e].y = Ennemi[e].y  + Ennemi[e].v_av*dt
              else
                Ennemi[e].mouv1 = false
                Ennemi[e].y = Ennemi[e].yf
                Ennemi[e].mouv2 = true
              end
            end
            -- Deuxième mouvement, rotation
            if Ennemi[e].mouv2 == true then
              -- Ennemis allant à gauche
              if Ennemi[e].pos == "gauche" then
                if Ennemi[e].rot_base < math.rad(180) then
                  Ennemi[e].rot_base = Ennemi[e].rot_base + Ennemi[e].v_rot_base*dt
                else
                  Ennemi[e].mouv2 = false
                  Ennemi[e].rot_base = math.rad(180)
                  Ennemi[e].mouv3 = true
                end
              -- Ennemis allant à droite
              elseif Ennemi[e].pos == "droite" then
                if Ennemi[e].rot_base > math.rad(0) then
                  Ennemi[e].rot_base = Ennemi[e].rot_base - Ennemi[e].v_rot_base*dt
                else
                  Ennemi[e].mouv2 = false
                  Ennemi[e].rot_base = math.rad(0)
                  Ennemi[e].mouv3 = true
                end
              end
            end
            -- Troisième mouvement, horizontal
            if Ennemi[e].mouv3 == true then
              -- Ennemis allant à gauche
              if Ennemi[e].pos == "gauche" then
                if Ennemi[e].x > Ennemi[e].xf then
                  Ennemi[e].x = Ennemi[e].x - Ennemi[e].v_av*dt
                else
                  Ennemi[e].mouv3 = false
                  Ennemi[e].x = Ennemi[e].xf
                  Ennemi[e].mouv4 = true
                end
              -- Ennemis allant à droite
              elseif Ennemi[e].pos == "droite" then
                if Ennemi[e].x < Ennemi[e].xf then
                  Ennemi[e].x = Ennemi[e].x + Ennemi[e].v_av*dt
                else
                  Ennemi[e].mouv3 = false
                  Ennemi[e].x = Ennemi[e].xf
                  Ennemi[e].mouv4 = true
                end
              end
            end
            -- Quatrième mouvement, rotation finale
            if Ennemi[e].mouv4 == true then
              -- Ennemis allant à gauche
              if Ennemi[e].pos == "gauche" then
                if Ennemi[e].rot_base > math.rad(45) then
                  Ennemi[e].rot_base = Ennemi[e].rot_base - Ennemi[e].v_rot_base*dt
                else
                  Ennemi[e].mouv4 = false
                  Ennemi[e].rot_base = math.rad(45)
                end
              -- Ennemis allant à droite
              elseif Ennemi[e].pos == "droite" then
                if Ennemi[e].rot_base < math.rad(135) then
                  Ennemi[e].rot_base = Ennemi[e].rot_base + Ennemi[e].v_rot_base*dt
                else
                  Ennemi[e].mouv4 = false
                  Ennemi[e].rot_base = math.rad(135)
                end
              end
            end
          --
          -- Ennemis de type 2
          elseif Ennemi[e].genre == 2 then
          --
            -- Premier mouvement, vertical
            if Ennemi[e].mouv1 == true then
              if Ennemi[e].y < Hauteur/8 then
                Ennemi[e].y = Ennemi[e].y + Ennemi[e].v_av*dt
              else
                Ennemi[e].mouv1 = false
                Ennemi[e].y = Hauteur/8
                Ennemi[e].mouv2 = true
              end
            end
            -- Deuxième mouvement, rotation
            if Ennemi[e].mouv2 == true then
              if Ennemi[e].pos == "gauche" then
                if Ennemi[e].rot_base < math.rad(180) then
                  Ennemi[e].rot_base = Ennemi[e].rot_base + Ennemi[e].v_rot_base*dt
                else
                  Ennemi[e].mouv2 = false
                  Ennemi[e].rot_base = math.rad(180)
                  Ennemi[e].mouv3 = true
                end
              elseif Ennemi[e].pos == "droite" then
                if Ennemi[e].rot_base > math.rad(0) then
                  Ennemi[e].rot_base = Ennemi[e].rot_base - Ennemi[e].v_rot_base*dt
                else
                  Ennemi[e].mouv2 = false
                  Ennemi[e].rot_base = math.rad(0)
                  Ennemi[e].mouv3 = true
                end
              end
            end
            -- Troisième mouvement, horizontal, boucle 1/8
            if Ennemi[e].mouv3 == true then
              if Ennemi[e].pos == "gauche" then
                if Ennemi[e].x > Ennemi[e].xf then
                  Ennemi[e].x = Ennemi[e].x - Ennemi[e].v_av*dt
                else
                  Ennemi[e].mouv3 = false
                  Ennemi[e].x = Ennemi[e].xf
                  Ennemi[e].mouv4 = true
                end
              elseif Ennemi[e].pos == "droite" then
                if Ennemi[e].x < Ennemi[e].xf then
                  Ennemi[e].x = Ennemi[e].x + Ennemi[e].v_av*dt
                else
                  Ennemi[e].mouv3 = false
                  Ennemi[e].x = Ennemi[e].xf
                  Ennemi[e].mouv4 = true
                end
              end
            end
            -- Quatrième mouvement, rotation, boucle 2/8
            if Ennemi[e].mouv4 == true then
              if Ennemi[e].pos == "gauche" then
                if Ennemi[e].rot_base > math.rad(90) then
                  Ennemi[e].rot_base = Ennemi[e].rot_base - Ennemi[e].v_rot_base*dt
                else
                  Ennemi[e].mouv4 = false
                  Ennemi[e].rot_base = math.rad(90)
                  Ennemi[e].mouv5 = true
                end
              elseif Ennemi[e].pos == "droite" then
                if Ennemi[e].rot_base < math.rad(90) then
                  Ennemi[e].rot_base = Ennemi[e].rot_base + Ennemi[e].v_rot_base*dt
                else
                  Ennemi[e].mouv4 = false
                  Ennemi[e].rot_base = math.rad(90)
                  Ennemi[e].mouv5 = true
                end
              end
            end
            -- Cinquième mouvement, vertical, boucle 3/8
            if Ennemi[e].mouv5 == true then
              if Ennemi[e].y < Ennemi[e].yf then
                Ennemi[e].y = Ennemi[e].y + Ennemi[e].v_av*dt
              else
                Ennemi[e].mouv5 = false
                Ennemi[e].y = Ennemi[e].yf
                Ennemi[e].mouv6 = true
              end
            end
            -- Sixième mouvement, rotation, boucle 4/8
            if Ennemi[e].mouv6 == true then
              if Ennemi[e].pos == "gauche" then
                if Ennemi[e].rot_base > math.rad(0) then
                  Ennemi[e].rot_base = Ennemi[e].rot_base - Ennemi[e].v_rot_base*dt
                else
                  Ennemi[e].mouv6 = false
                  Ennemi[e].rot_base = math.rad(0)
                  Ennemi[e].mouv7 = true
                end
              elseif Ennemi[e].pos == "droite" then
                if Ennemi[e].rot_base < math.rad(180) then
                  Ennemi[e].rot_base = Ennemi[e].rot_base + Ennemi[e].v_rot_base*dt
                else
                  Ennemi[e].mouv6 = false
                  Ennemi[e].rot_base = math.rad(180)
                  Ennemi[e].mouv7 = true
                end
              end
            end
            -- Septième mouvement, horizontal, boucle 5/8
            if Ennemi[e].mouv7 == true then
              if Ennemi[e].pos == "gauche" then
                if Ennemi[e].x < Largeur - Ennemi[e].xf - Jeu.tile_largeur then
                  Ennemi[e].x = Ennemi[e].x + Ennemi[e].v_av*dt
                else 
                  Ennemi[e].mouv7 = false
                  Ennemi[e].x = Largeur - Ennemi[e].xf - Jeu.tile_largeur
                  Ennemi[e].mouv8 = true
                end
              elseif Ennemi[e].pos == "droite" then
                if Ennemi[e].x > Largeur - Ennemi[e].xf + Jeu.tile_largeur then
                  Ennemi[e].x = Ennemi[e].x - Ennemi[e].v_av*dt
                else
                  Ennemi[e].mouv7 = false
                  Ennemi[e].x = Largeur - Ennemi[e].xf + Jeu.tile_largeur
                  Ennemi[e].mouv8 = true
                end
              end
            end
            -- Huitième mouvement, rotation, boucle 6/8
            if Ennemi[e].mouv8 == true then
              if Ennemi[e].pos == "gauche" then
                if Ennemi[e].rot_base > math.rad(-90) then
                  Ennemi[e].rot_base = Ennemi[e].rot_base - Ennemi[e].v_rot_base*dt
                else
                  Ennemi[e].mouv8 = false
                  Ennemi[e].rot_base = math.rad(-90)
                  Ennemi[e].mouv9 = true
                end
              elseif Ennemi[e].pos == "droite" then
                if Ennemi[e].rot_base < math.rad(270) then
                  Ennemi[e].rot_base = Ennemi[e].rot_base + Ennemi[e].v_rot_base*dt
                else
                  Ennemi[e].mouv8 = false
                  Ennemi[e].rot_base = math.rad(270)
                  Ennemi[e].mouv9 = true
                end
              end
            end
            -- Neuvième mouvement, vertical, boucle, 7/8
            if Ennemi[e].mouv9 == true then
              if Ennemi[e].pos == "gauche" then
                if Ennemi[e].y > Hauteur - Ennemi[e].yf + Jeu.tile_hauteur then
                  Ennemi[e].y = Ennemi[e].y - Ennemi[e].v_av*dt
                else
                  Ennemi[e].mouv9 = false
                  Ennemi[e].y = Hauteur - Ennemi[e].yf + Jeu.tile_hauteur
                  Ennemi[e].mouv10 = true
                end
              elseif Ennemi[e].pos == "droite" then
                if Ennemi[e].y > Hauteur - Ennemi[e].yf - Jeu.tile_hauteur then
                  Ennemi[e].y = Ennemi[e].y - Ennemi[e].v_av*dt
                else
                  Ennemi[e].mouv9 = false
                  Ennemi[e].y = Hauteur - Ennemi[e].yf - Jeu.tile_hauteur
                  Ennemi[e].mouv10 = true
                end
              end
            end
            -- Dixième mouvement, rotation, boucle 8/8 (retour sur 1/8)
            if Ennemi[e].mouv10 == true then
              if Ennemi[e].pos == "gauche" then
                if Ennemi[e].rot_base > math.rad(-180) then
                  Ennemi[e].rot_base = Ennemi[e].rot_base - Ennemi[e].v_rot_base*dt
                else
                  Ennemi[e].mouv10 = false
                  Ennemi[e].rot_base = math.rad(180)
                  Ennemi[e].mouv3 = true
                end
              elseif Ennemi[e].pos == "droite" then
                if Ennemi[e].rot_base < math.rad(360) then
                  Ennemi[e].rot_base = Ennemi[e].rot_base + Ennemi[e].v_rot_base*dt
                else
                  Ennemi[e].mouv10 = false
                  Ennemi[e].rot_base = math.rad(0)
                  Ennemi[e].mouv3 = true
                end
              end
            end
          end
        --
        end
      --
      -- Rotation canons ennemis
        Ennemi[e].rot_canon = math.angle(Ennemi[e].x,Ennemi[e].y,Tank.x,Tank.y)
      --
      -- Cadence des tirs ennemis
        Ennemi[e].chronotir = Ennemi[e].chronotir - dt
        if Ennemi[e].chronotir <= 0 then
          Ennemi[e].chronotir = math.random(2,4)
          Rocket.Gen_Tir("adv", Ennemi[e].x + 30*math.cos(Ennemi[e].rot_canon), Ennemi[e].y + 30*math.sin(Ennemi[e].rot_canon), Ennemi[e].rot_canon)
          Ennemi[e].flamme = true
        end
      --
      -- Flammes ennemies
        if Ennemi[e].flamme == true then
          Ennemi[e].chronoflamme = Ennemi[e].chronoflamme + 24*dt
          if Ennemi[e].chronoflamme >= 4 then
            Ennemi[e].flamme = false
            Ennemi[e].chronoflamme = 1
          end
        end
      --
      end
    --
    end
  end
--
end
--
--------------------------------------------------------------------------------------------------------------
--
function Ennemi.draw()
--
  for e=#Ennemi,1,-1 do
    love.graphics.draw(Ennemi.img_base, Ennemi[e].x, Ennemi[e].y, Ennemi[e].rot_base, 1, 1, Ennemi.ox, Ennemi.oy)
    love.graphics.draw(Ennemi.img_canon, Ennemi[e].x, Ennemi[e].y, Ennemi[e].rot_canon, 1, 1, Ennemi.ox, Ennemi.oy)
    if Ennemi[e].flamme == true then
      love.graphics.draw(Tank.img_flamme[math.floor(Ennemi[e].chronoflamme)], Ennemi[e].x + 20*math.cos(Ennemi[e].rot_canon), Ennemi[e].y + 20*math.sin(Ennemi[e].rot_canon),
        Ennemi[e].rot_canon, 1, 1, 0, Tank.flamme_hauteur/2)
    end
  end
--
end
--
--------------------------------------------------------------------------------------------------------------
--
return Ennemi
--