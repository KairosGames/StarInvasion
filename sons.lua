--
local Son = {}
--------------------------------------------------------------------------------------------------------------
--
function Son.load()
--
-- Listes des sons statiques à supprimer
  Son.Statics = {}
--
-- Sons en jeu
  -- Tirs du joueur
  function Son.Gen_sndTirjoueur()
    local tir = {}
    tir.son = love.audio.newSource("sons/tircanon.wav", "static")
    tir.son:setPitch(1)
    tir.son:setVolume(1)
    table.insert(Son.Statics, tir)
    tir.son:play()
  end
  -- Tirs ennemis
  Son.sndTiradv = love.audio.newSource("sons/tircanon.wav", "static")
  Son.sndTiradv:setPitch(1)
  Son.sndTiradv:setVolume(0.4)
  function Son.Gen_sndTiradv()
    if Son.sndTiradv:isPlaying() then
      Son.sndTiradv:stop()
    end
    Son.sndTiradv:play()
  end
  -- Impact explosif
  function Son.Gen_sndExplosion()
    local explosion = {}
    explosion.son = love.audio.newSource("sons/explosion.wav", "static")
    explosion.son:setPitch(1)
    explosion.son:setVolume(1)
    table.insert(Son.Statics, explosion)
    explosion.son:play()
  end
  -- Destruction
  function Son.Gen_sndDestruction()
    local destruction = {}
    destruction.son = love.audio.newSource("sons/destruction.wav", "static")
    destruction.son:setPitch(1)
    destruction.son:setVolume(0.5)
    table.insert(Son.Statics, destruction)
    destruction.son:play()
  end
  -- Collision entre deux rockets
  function Son.Gen_sndInterrocket()
    local interrocket = {}
    interrocket.son = love.audio.newSource("sons/interrocket.wav", "static")
    interrocket.son:setPitch(1)
    interrocket.son:setVolume(1)
    table.insert(Son.Statics, interrocket)
    interrocket.son:play()
  end
  -- Rotation du tank
  Son.sndRotation = love.audio.newSource("sons/rotation.wav", "static")
  Son.sndRotation:setPitch(0.7)
  Son.sndRotation:setVolume(0.6)
  -- Chaînes
  Son.sndChaines = love.audio.newSource("sons/chaines.wav", "static")
  Son.sndChaines_pitch = 0.7
  Son.sndChaines_volume = 0
  Son.sndChaines:setPitch(Son.sndChaines_pitch)
  Son.sndChaines:setVolume(Son.sndChaines_volume)
  -- Rechargement canon
  Son.sndReload = love.audio.newSource("sons/reload.wav", "static")
  Son.sndReload:setPitch(1)
  Son.sndReload:setVolume(1)
  -- Bélier
    -- Ouvert
  Son.sndBelier_ouvert = love.audio.newSource("sons/belier_ouvert.wav", "static")
  Son.sndBelier_ouvert:setPitch(0.6)
  Son.sndBelier_ouvert:setVolume(0.4)
    -- Fermé
  Son.sndBelier_ferme = love.audio.newSource("sons/belier_ferme.wav", "static")
  Son.sndBelier_ferme:setPitch(0.6)
  Son.sndBelier_ferme:setVolume(0.4)
  -- Bruit de radio passage level
  Son.sndLevel = love.audio.newSource("sons/level.wav", "static")
  Son.sndLevel:setPitch(0.9)
  Son.sndLevel:setVolume(0.7)
  -- Alarme low hp
  Son.sndAlarm = love.audio.newSource("sons/lowhp.mp3", "stream")
  Son.sndAlarm:setLooping(true)
  Son.sndAlarm:setPitch(1)
  Son.sndAlarm:setVolume(0.8)
--
-- Sons de scènes
  -- Destruction du tank
  Son.sndDestruction_tank = love.audio.newSource("sons/destructiontank.wav", "static")
  Son.sndDestruction_tank:setPitch(1)
  Son.sndDestruction_tank:setVolume(1)
  -- Bruit des chaînes pour scène de victoire
  Son.sndChaineanim = love.audio.newSource("sons/chaines.wav", "static")
  Son.sndChaineanim:setLooping(true)
  Son.sndChaineanim:setPitch(0.7)
  Son.sndChaineanim:setVolume(1)
  -- Bruit de rotation pour scène de victoire
  Son.sndRotationanim = love.audio.newSource("sons/rotation.wav", "static")
  Son.sndRotationanim:setLooping(true)
  Son.sndRotationanim:setPitch(0.7)
  Son.sndRotationanim:setVolume(1)
--
-- Sons d'interface
  -- Préselection
  Son.sndCurseur = love.audio.newSource("sons/curseur.wav", "static")
  Son.sndCurseur:setPitch(1)
  Son.sndCurseur:setVolume(1)
  -- Clic sur choix
  Son.sndSelect = love.audio.newSource("sons/select.wav", "static")
  Son.sndSelect:setPitch(1)
  Son.sndSelect:setVolume(1)
--
-- Musiques
  -- Menu
  Son.sndMenu = love.audio.newSource("sons/menu.mp3", "stream")
  Son.sndMenu:setLooping(true)
  Son.sndMenu:setPitch(1)
  Son.sndMenu:setVolume(0.4)
  -- En jeu
  Son.sndIngame = love.audio.newSource("sons/ingame.mp3", "stream")
  Son.sndIngame:setLooping(true)
  Son.sndIngame:setPitch(1)
  Son.sndIngame:setVolume(0.5)
  -- Défaite
  Son.sndDefaite = love.audio.newSource("sons/defaite.mp3", "static")
  Son.sndDefaite:setPitch(0.9)
  Son.sndDefaite:setVolume(1)
  -- Loose totale
  Son.sndBigloose = love.audio.newSource("sons/grosseloose.mp3", "stream")
  Son.sndBigloose:setPitch(1)
  Son.sndBigloose:setVolume(1)
  -- Victoire
  Son.sndVictoire = love.audio.newSource("sons/victoire.mp3", "stream")
  Son.sndVictoire:setPitch(1)
  Son.sndVictoire:setVolume(1)
--
end
--
--------------------------------------------------------------------------------------------------------------
--
function Son.update(dt)
--
-- Jeu qui tourne
  if Display.etat == "play" then
    if Display.action == false then
      Son.sndIngame:play()
    -- Son des chaînes
      if love.keyboard.isDown("s") then
        Son.sndChaines:play()
        Son.sndChaines_volume = Son.sndChaines_volume + 0.1*dt
        if Son.sndChaines_volume >= 0.1 then
          Son.sndChaines_volume = 0.1
        end
        Son.sndChaines:setVolume(Son.sndChaines_volume)
        Son.sndChaines:setPitch(Son.sndChaines_pitch)
      elseif love.keyboard.isDown("z") then
        Son.sndChaines:play()
        Son.sndChaines_volume = Son.sndChaines_volume + 0.3*dt
        Son.sndChaines_pitch = Son.sndChaines_pitch + 0.2*dt
        if Son.sndChaines_volume >= 0.2 then
          Son.sndChaines_volume = 0.2
        end
        if Son.sndChaines_pitch >= 0.8 then
          Son.sndChaines_pitch = 0.8
        end
        Son.sndChaines:setVolume(Son.sndChaines_volume)
        Son.sndChaines:setPitch(Son.sndChaines_pitch)
      else
        Son.sndChaines_volume = Son.sndChaines_volume - dt
        Son.sndChaines_pitch = Son.sndChaines_pitch - dt
        if Son.sndChaines_volume <= 0 then
          Son.sndChaines_volume = 0
          Son.sndChaines:stop()
        end
        if Son.sndChaines_pitch <= 0.6 then
          Son.sndChaines_pitch = 0.6
        end
        Son.sndChaines:setVolume(Son.sndChaines_volume)
        Son.sndChaines:setPitch(Son.sndChaines_pitch)
      end
    -- Son de la rotation du Tank
      if love.keyboard.isDown("q") or love.keyboard.isDown("d") then
        Son.sndRotation:play()
      else
        Son.sndRotation:stop()
      end
    --
    elseif Display.action == true and (Tank.vie == 0 or Jeu.niveau6 == true) then
      Display.chronoson = Display.chronoson - dt/8
      Son.sndIngame:setVolume(Display.chronoson*0.5)
      if Display.chronoson <= 0 then
        Son.sndIngame:stop()
        Display.chronoson = 0
      end
    end
  --
  end
--
-- Suppression des sons statiques à l'arrêt
  for s=#Son.Statics,1,-1 do
    if not Son.Statics[s].son:isPlaying() then
      table.remove(Son.Statics, s)
    end
  end
--
end
--
--------------------------------------------------------------------------------------------------------------
--
function Son.keypressed(key)
--
-- Jeu qui tourne
  if Display.etat == "play" then
  --
  -- Ouverture du bélier
    if Tank.acc_av >= 1 then
      if key == "space" then
        Son.sndBelier_ouvert:play()
      end
    end
  --
  end
--
end
--
--------------------------------------------------------------------------------------------------------------
--
function Son.keyreleased(key)
--
-- Jeu qui tourne
  if Display.etat == "play" then
  --
  -- Rétractement du bélier
    if Tank.acc_av >= 1 then
      if key == "space" then
        Son.sndBelier_ferme:play()
      end
    end
  --
  end
--
end
--
--------------------------------------------------------------------------------------------------------------
--
return Son
--