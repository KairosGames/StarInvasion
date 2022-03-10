 -- Paramètre l'angle du canon variant en 0 et 360
    if Tank.rot_canon >= math.rad(360) then
      Tank.rot_canon = math.rad(0)
    elseif Tank.rot_canon <= math.rad(0) then
      Tank.rot_canon = math.rad(360)
    end
    -- Calcul de la rotation du canon en fonction de la souris
    if Tank.angl_vis < 0  then
      if Tank.rot_canon < 0 then
        if math.abs(Tank.rot_canon) < math.abs(Tank.angl_vis) then
          Tank.rot_canon = Tank.rot_canon - Tank.v_rot_canon*dt
          if math.abs(Tank.rot_canon) >= math.abs(Tank.angl_vis) then
            Tank.rot_canon = Tank.angl_vis
          end
        end
      else
        if (math.abs(Tank.angl_vis) + Tank.rot_canon) > ((math.rad(180)-Tank.rot_canon)+(180-math.abs(Tank.angl_vis))) then
          Tank.rot_canon = Tank.rot_canon + Tank.v_rot_canon*dt
          if Tank.rot_canon
        else
          Tank.rot_canon = Tank.rot_canon - Tank.v_rot_canon*dt
    else
      if Tank.rot_canon < Tank.angl_vis then
        Tank.rot_canon = Tank.rot_canon + Tank.v_rot_canon*dt
        if Tank.rot_canon >= Tank.angl_vis then
          Tank.rot_canon = Tank.angl_vis
        end
      elseif Tank.rot_canon > Tank.angl_vis then
        Tank.rot_canon = Tank.rot_canon - Tank.v_rot_canon*dt
        if Tank.rot_canon <= Tank.angl_vis then
          Tank.rot_canon = Tank.angl_vis
        end
      end
    end