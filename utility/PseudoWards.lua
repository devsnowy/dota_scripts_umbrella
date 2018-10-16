local PseudoWards = {}

PseudoWards.optionIcon = Menu.AddOptionIcon({"devsnowy"}, "panorama/images/dota_plus/dotaplus_logo_small_png.vtex_c")
PseudoWards.optionAwarenessIcon = Menu.AddOptionIcon({"devsnowy", "Awareness"}, "panorama/images/items/gem_of_true_sight_png.vtex_c")

PseudoWards.optionEnabled = Menu.AddOptionBool({"devsnowy", "Awareness", "Pseudo Wards"}, "Enabled", false)
PseudoWards.optionAwarenessIcon = Menu.AddOptionIcon({"devsnowy", "Awareness", "Pseudo Wards"}, "panorama/images/items/ward_dispenser_png.vtex_c")

PseudoWards.optionCalibrate = Menu.AddKeyOption({ "devsnowy", "Awareness", "Pseudo Wards"}, "Place Triangulation Point", Enum.ButtonCode.KEY_N)

PseudoWards.font = Renderer.LoadFont("Tahoma", 28, Enum.FontWeight.NORMAL)
PseudoWards.points = {}
PseudoWards.nextTick = 0

function PseudoWards.OnUpdate()
	if Menu.IsEnabled(PseudoWards.optionEnabled) then
    
    	local hero = Heroes.GetLocal()
      if
        not hero or
        not Entity.IsAlive(hero)
      then
        return false end
        
        local isHeroVisibleToEnemies = NPC.IsVisibleToEnemies(hero)
        
        if Menu.IsKeyDown(PseudoWards.optionCalibrate) and isHeroVisibleToEnemies and os.clock()>PseudoWards.nextTick then
            local position =  Entity.GetAbsOrigin(hero)
            local currentPoint = {
                position = position
            }
            table.insert(PseudoWards.points, currentPoint)
            PseudoWards.nextTick = os.clock() + 1
          end
        
    end
end

function PseudoWards.OnDraw()
  if Menu.IsEnabled(PseudoWards.optionEnabled) then
    for i, point in ipairs(PseudoWards.points) do
      local x, y, visible = Renderer.WorldToScreen(point.position)
        if visible then
          Renderer.SetDrawColor(255, 0, 255, 255)
          Renderer.DrawText(PseudoWards.font, x, y, "X", 1)
      end 
    end
    
    local sumX = 0;
    local sumY = 0;
    
    local points = PseudoWards.points;
    if not points then return end
    for i = 1, #points do
      local point = points[i]
      local x, y, visible = Renderer.WorldToScreen(point.position)
      sumX = sumX + x;
      sumY = sumY + y;
    end
    
    local x = sumX/#points
    local y = sumY/#points
    
    Renderer.SetDrawColor(255, 255, 0)
    Renderer.DrawText(PseudoWards.font, x, y, "Possible ward", 1)
    Renderer.DrawOutlineRect(x - 800, y - 800, 1600, 1600)

    
  end
end

return PseudoWards