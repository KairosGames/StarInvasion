--
local Jeu = {}
--
--------------------------------------------------------------------------------------------------------------
--
function Jeu.load()
--
-- Chargement des textures
  Jeu.texture = {}
  for n=1,34 do
    Jeu.texture[n] = love.graphics.newImage("images/tiles/"..n..".png")
  end
  Jeu.tile_largeur = Jeu.texture[1]:getWidth()
  Jeu.tile_hauteur = Jeu.texture[1]:getHeight()
  Jeu.largeur_col = Largeur/Jeu.tile_largeur
  Jeu.hauteur_lig = Hauteur/Jeu.tile_hauteur
--
-- Création grille
  Jeu.carte = {}
  for lig=1,Jeu.hauteur_lig do
    Jeu.carte[lig] = {}
    for col=1,Jeu.largeur_col do
      Jeu.carte[lig][col] = math.random(1,30)
    end
    Jeu.carte[lig][15] = 31
    Jeu.carte[lig][16] = 32
    Jeu.carte[lig][17] = 33
    Jeu.carte[lig][18] = 34
  end
--
-- Fonction de lancement du jeu
  function Jeu.Start()
  -- Réinitialisation du tank
    Tank.vie = 10
    Tank.score = 0
    Tank.x = Largeur/2
    Tank.y = Hauteur + Hauteur/4
    Tank.rot_base = math.rad(-90)
    Tank.rot_canon = math.rad(-90)
  -- Réinitialisation des ennemis
    for e=#Ennemi,1,-1 do
      table.remove(Ennemi, e)
    end
  -- Réinitialisation des niveaux
    Jeu.niveau0 = true
    Jeu.niveau1 = false
    Jeu.niveau2 = false
    Jeu.niveau3 = false
    Jeu.niveau4 = false
    Jeu.niveau5 = false
    Jeu.niveau6 = false
    Jeu.anim1 = false
    Jeu.anim2 = false
    Jeu.anim3 = false
    Jeu.anim4 = false
    Jeu.anim5 = false
    Jeu.anim6 = false
  -- Réinitialisation des chronos
    Display.chronoson = 1
  end

--
end
--
--------------------------------------------------------------------------------------------------------------
--
function Jeu.update(dt)
--
-- Effacer la souris
  love.mouse.setVisible(false)
--
-- Actionneur de niveaux
  if Display.action == false then
  --
    if #Ennemi == 0 then
    ----------------------------------
      if Jeu.niveau0 == true then
        Display.chronoanim = Display.chronoanim + dt
        if Display.chronoanim >= 1 and Display.chronoanim < 3 then
          Jeu.anim1 = true
          if Jeu.anim1 == true then
            Display.x_filtre = Display.x_filtre - 3840*dt
            if Display.x_filtre <= 0 then
              Son.sndLevel:play()
              Display.x_filtre = 0
            end
          end
        elseif Display.chronoanim >= 3 and Display.chronoanim < 6 then
          Display.x_filtre = Display.x_filtre - 3840*dt
          if Display.x_filtre <= 0 - Largeur then
            Display.x_filtre = 0 - Largeur
          end
        elseif Display.chronoanim >= 6 then
          --
          Ennemi.Gen_Ennemi(1,
                            Largeur/4,
                            0 - Hauteur/4,
                            Largeur/8,
                            Hauteur/8
                          )
          Ennemi.Gen_Ennemi(1,
                            Largeur - Largeur/4,
                            0 - Hauteur/4,
                            Largeur - Largeur/8,
                            Hauteur/8
                          )
          --
          Display.chronoanim = 0
          Display.x_filtre = Largeur
          Jeu.anim1 = false
          Jeu.niveau0 = false
          Jeu.niveau1 = true
        end
          
      end
    end
    ----------------------------------
    if #Ennemi == 0 then
      if Jeu.niveau1 == true then
        Display.chronoanim = Display.chronoanim + dt
        if Display.chronoanim >= 1 and Display.chronoanim < 3 then
          Son.sndLevel:play()
          Jeu.anim2 = true
          if Jeu.anim2 == true then
            Display.x_filtre = Display.x_filtre - 3840*dt
            if Display.x_filtre <= 0 then
              Display.x_filtre = 0
            end
          end
        elseif Display.chronoanim >= 3 and Display.chronoanim < 6 then
          Display.x_filtre = Display.x_filtre - 3840*dt
          if Display.x_filtre <= 0 - Largeur then
            Display.x_filtre = 0 - Largeur
          end
        elseif Display.chronoanim >= 6 then
          --
          Ennemi.Gen_Ennemi(2,
                            Largeur/4,
                            0 - Hauteur/4,
                            Largeur/8,
                            Hauteur - Hauteur/8
                          )
          Ennemi.Gen_Ennemi(2,
                            Largeur - Largeur/4,
                            0 - Hauteur/4,
                            Largeur - Largeur/8,
                            Hauteur - Hauteur/8 - Jeu.tile_largeur
                          )
          --
          Display.chronoanim = 0
          Display.x_filtre = Largeur
          Jeu.anim2 = false
          Jeu.niveau1 = false
          Jeu.niveau2 = true
        end
          
      end
    end
    ----------------------------------
    if #Ennemi == 0 then
      if Jeu.niveau2 == true then
        Display.chronoanim = Display.chronoanim + dt
        if Display.chronoanim >= 1 and Display.chronoanim < 3 then
          Son.sndLevel:play()
          Jeu.anim3 = true
          if Jeu.anim3 == true then
            Display.x_filtre = Display.x_filtre - 3840*dt
            if Display.x_filtre <= 0 then
              Display.x_filtre = 0
            end
          end
        elseif Display.chronoanim >= 3 and Display.chronoanim < 6 then
          Display.x_filtre = Display.x_filtre - 3840*dt
          if Display.x_filtre <= 0 - Largeur then
            Display.x_filtre = 0 - Largeur
          end
        elseif Display.chronoanim >= 6 then
          --
          Ennemi.Gen_Ennemi(1,
                            Largeur/4,
                            0 - Hauteur/4,
                            Largeur/10,
                            2*Hauteur/8
                          )
          Ennemi.Gen_Ennemi(1,
                            Largeur - Largeur/4,
                            0 - Hauteur/4,
                            Largeur - Largeur/10,
                            2*Hauteur/8
                          )
          --
          Ennemi.Gen_Ennemi(1,
                            Largeur/4, 
                            0 - Hauteur/2, 
                            Largeur/8, 
                            Hauteur/8
                          )
          Ennemi.Gen_Ennemi(1, 
                            Largeur - Largeur/4,
                            0 - Hauteur/2,
                            Largeur - Largeur/8,
                            Hauteur/8
                          )
          --
          Display.chronoanim = 0
          Display.x_filtre = Largeur
          Jeu.anim3 = false
          Jeu.niveau2 = false
          Jeu.niveau3 = true
        end
          
      end
    end
    ----------------------------------
    if #Ennemi == 0 then
      if Jeu.niveau3 == true then
        Display.chronoanim = Display.chronoanim + dt
        if Display.chronoanim >= 1 and Display.chronoanim < 3 then
          Son.sndLevel:play()
          Jeu.anim4 = true
          if Jeu.anim4 == true then
            Display.x_filtre = Display.x_filtre - 3840*dt
            if Display.x_filtre <= 0 then
              Display.x_filtre = 0
            end
          end
        elseif Display.chronoanim >= 3 and Display.chronoanim < 6 then
          Display.x_filtre = Display.x_filtre - 3840*dt
          if Display.x_filtre <= 0 - Largeur then
            Display.x_filtre = 0 - Largeur
          end
        elseif Display.chronoanim >= 6 then
          --
          Ennemi.Gen_Ennemi(2,
                            Largeur/4,
                            0 - Hauteur/4,
                            Largeur/8,
                            Hauteur - Hauteur/8
                          )
          Ennemi.Gen_Ennemi(2,
                            Largeur - Largeur/4,
                            0 - Hauteur/4,
                            Largeur - Largeur/8,
                            Hauteur - Hauteur/8 - Jeu.tile_largeur
                          )
          --
          Ennemi.Gen_Ennemi(2,
                            Largeur/4,
                            0 - 3*Hauteur/4,
                            Largeur/8,
                            Hauteur - Hauteur/8
                          )
          Ennemi.Gen_Ennemi(2,
                            Largeur - Largeur/4,
                            0 - 3*Hauteur/4,
                            Largeur - Largeur/8,
                            Hauteur - Hauteur/8 - Jeu.tile_largeur
                          )
          --
          Display.chronoanim = 0
          Display.x_filtre = Largeur
          Jeu.anim4 = false
          Jeu.niveau3 = false
          Jeu.niveau4 = true
        end
          
      end
    end
    ----------------------------------
    if #Ennemi == 0 then
      if Jeu.niveau4 == true then
        Display.chronoanim = Display.chronoanim + dt
        if Display.chronoanim >= 1 and Display.chronoanim < 3 then
          Son.sndLevel:play()
          Jeu.anim5 = true
          if Jeu.anim5 == true then
            Display.x_filtre = Display.x_filtre - 3840*dt
            if Display.x_filtre <= 0 then
              Display.x_filtre = 0
            end
          end
        elseif Display.chronoanim >= 3 and Display.chronoanim < 6 then
          Display.x_filtre = Display.x_filtre - 3840*dt
          if Display.x_filtre <= 0 - Largeur then
            Display.x_filtre = 0 - Largeur
          end
        elseif Display.chronoanim >= 6 then
          --
          Ennemi.Gen_Ennemi(1,
                            Largeur/4,
                            0 - Hauteur/4,
                            Largeur/12,
                            3*Hauteur/8
                          )
          Ennemi.Gen_Ennemi(1,
                            Largeur - Largeur/4,
                            0 - Hauteur/4,
                            Largeur - Largeur/12,
                            3*Hauteur/8
                          )
          --
          Ennemi.Gen_Ennemi(1,
                            Largeur/4,
                            0 - 2*Hauteur/4,
                            Largeur/10,
                            2*Hauteur/8
                          )
          Ennemi.Gen_Ennemi(1,
                            Largeur - Largeur/4,
                            0 - 2*Hauteur/4,
                            Largeur - Largeur/10,
                            2*Hauteur/8
                          )
          --
          Ennemi.Gen_Ennemi(1,
                            Largeur/4,
                            0 - 3*Hauteur/4,
                            Largeur/8,
                            Hauteur/8
                          )
          Ennemi.Gen_Ennemi(1,
                            Largeur - Largeur/4,
                            0 - 3*Hauteur/4,
                            Largeur - Largeur/8,
                            Hauteur/8
                          )
          --
          Display.chronoanim = 0
          Display.x_filtre = Largeur
          Jeu.anim5 = false
          Jeu.niveau4 = false
          Jeu.niveau5 = true
        end
          
      end
    end
    ----------------------------------
    if #Ennemi == 0 then
      if Jeu.niveau5 == true then
        Display.chronoanim = Display.chronoanim + dt
        if Display.chronoanim >= 1 and Display.chronoanim < 3 then
          Son.sndLevel:play()
          Jeu.anim6 = true
          if Jeu.anim6 == true then
            Display.x_filtre = Display.x_filtre - 3840*dt
            if Display.x_filtre <= 0 then
              Display.x_filtre = 0
            end
          end
        elseif Display.chronoanim >= 3 and Display.chronoanim < 6 then
          Display.x_filtre = Display.x_filtre - 3840*dt
          if Display.x_filtre <= 0 - Largeur then
            Display.x_filtre = 0 - Largeur
          end
        elseif Display.chronoanim >= 6 then
          --
          Ennemi.Gen_Ennemi(2,
                            Largeur/4,
                            0 - Hauteur/4,
                            Largeur/8,
                            Hauteur - Hauteur/8
                          )
          Ennemi.Gen_Ennemi(2,
                            Largeur - Largeur/4,
                            0 - Hauteur/4,
                            Largeur - Largeur/8,
                            Hauteur - Hauteur/8 - Jeu.tile_largeur
                          )
          --
          Ennemi.Gen_Ennemi(2,
                            Largeur/4,
                            0 - 3*Hauteur/4,
                            Largeur/8,
                            Hauteur - Hauteur/8
                          )
          Ennemi.Gen_Ennemi(2,
                            Largeur - Largeur/4,
                            0 - 3*Hauteur/4,
                            Largeur - Largeur/8,
                            Hauteur - Hauteur/8 - Jeu.tile_largeur
                          )
          --
          Ennemi.Gen_Ennemi(2,
                            Largeur/4,
                            0 - 5*Hauteur/4,
                            Largeur/8,
                            Hauteur - Hauteur/8
                          )
          Ennemi.Gen_Ennemi(2,
                            Largeur - Largeur/4,
                            0 - 5*Hauteur/4,
                            Largeur - Largeur/8,
                            Hauteur - Hauteur/8 - Jeu.tile_largeur
                          )
          --
          Display.chronoanim = 0
          Display.x_filtre = Largeur
          Jeu.anim6 = false
          Jeu.niveau5 = false
          Jeu.niveau6 = true
        end
          
      end
    end
    ----------------------------------
    if #Ennemi == 0 then
      if Jeu.niveau6 == true then
        Display.action = true
      end
    end
  --
  end
--
end
--
--------------------------------------------------------------------------------------------------------------
--
function Jeu.draw()
--
-- Dessine la carte
  for lig=1,Jeu.hauteur_lig do
    for col=1,Jeu.largeur_col do
      love.graphics.draw(Jeu.texture[Jeu.carte[lig][col]], (col-1)*Jeu.tile_largeur, (lig-1)*Jeu.tile_hauteur)
    end
  end
--
end
--
--------------------------------------------------------------------------------------------------------------
--
return Jeu
--