-- Local Wrapper --
local Wrap = require("scripts.modules.WrapUtility")
--/\ Local Wrapper /\ --

local Utility = {}

Utility.lastTick = 0
Utility.delay = 0
Utility.itemDelay = 0
Utility.lastItemCast = 0
Utility.lastItemTick = 0

local LoneDruid = {}

me = nil
mana = nill

phaseBoots = nil
ultimateScepter = nil

spiritBear = nil
spiritBearMana = nil
spiritBearPhaseBoots = nil

LoneDruid.enableCombo = Menu.AddOptionBool({"Hero Specific", "Lone Druid"}, "Enabled", false)
Menu.AddMenuIcon({"Hero Specific", "Lone Druid"}, "panorama/images/heroes/icons/npc_dota_hero_lone_druid_png.vtex_c")

LoneDruid.comboKey = Menu.AddKeyOption({ "Hero Specific", "Lone Druid" }, "Combo Key", Enum.ButtonCode.BUTTON_CODE_NONE)
LoneDruid.sendToBaseKey = Menu.AddKeyOption({ "Hero Specific", "Lone Druid" }, "Send to base", Enum.ButtonCode.BUTTON_CODE_NONE)
LoneDruid.callBackKey = Menu.AddKeyOption({ "Hero Specific", "Lone Druid"}, "Call back key", Enum.ButtonCode.BUTTON_CODE_NONE)


LoneDruid.callBackBearIfOutOfRange = Menu.AddOptionBool({"Hero Specific", "Lone Druid", "Bear Settings"}, "Move to hero if out of range", true)
LoneDruid.callBackBearRange = Menu.AddOptionSlider({"Hero Specific", "Lone Druid", "Bear Settings"}, "Stay in range",  200, 1100, 1000)

LoneDruid.usePhaseBoots = Menu.AddOptionBool({"Hero Specific", "Lone Druid", "Hero Options", "Utility"}, "Auto Phase Boots while moving", true)
LoneDruid.usePhaseBootsBear = Menu.AddOptionBool({"Hero Specific", "Lone Druid", "Bear Settings", "Utility"}, "Auto Phase Boots while moving", true)

function LoneDruid.OnModifierCreate(ent, mod)
    -- Log.Write(Modifier.GetName(mod))
end

function LoneDruid.OnUpdate()

	me = Heroes.GetLocal()
	mana = NPC.GetMana(me)
	midas = NPC.GetItem(me, "item_hand_of_midas", true)
	phaseBoots = NPC.GetItem(me, "item_phase_boots", true)
	ultimateScepter = NPC.GetItem(me, "item_ultimate_scepter", true)
  
	if not me or NPC.GetUnitName(me) ~= "npc_dota_hero_lone_druid" then return end
  
  for i= 1, NPCs.Count() do
        local entity = NPCs.Get(i)
        local name = NPC.GetUnitName(entity)
        if  Entity.GetOwner(entity) == me then 
          if name:find("npc_dota_lone_druid_bear") then 
            spiritBear = entity
          end 
        end 
  end
  
  if Menu.IsEnabled(LoneDruid.usePhaseBoots) and not NPC.HasModifier(me, "modifier_item_phase_boots_active") then
    if phaseBoots ~= nil and NPC.IsRunning(me) and Ability.IsReady(phaseBoots) and Ability.IsCastable(phaseBoots, mana) then
       Ability.CastNoTarget(phaseBoots)
    end
  end
  
  if spiritBear ~= nil and Wrap.EIsAlive(spiritBear) then
		spiritBearMana = NPC.GetMana(spiritBear)
		spiritBearPhaseBoots = NPC.GetItem(spiritBear, "item_phase_boots", true)
		if Menu.IsEnabled(LoneDruid.usePhaseBootsBear) and not NPC.HasModifier(spiritBear, "modifier_item_phase_boots_active") then
		  if spiritBear ~= nil and spiritBearPhaseBoots ~= nil and NPC.IsRunning(spiritBear) and Ability.IsReady(spiritBearPhaseBoots) and Ability.IsCastable(spiritBearPhaseBoots, mana) then
			 Ability.CastNoTarget(spiritBearPhaseBoots)
		  end
		end
		
		local heroVector = Entity.GetAbsOrigin(me);
		local distance = Entity.GetAbsOrigin(spiritBear):Distance(heroVector):Length2D()
		
		if Menu.IsEnabled(LoneDruid.callBackBearIfOutOfRange) and not ultimateScepter then
		  if distance > Menu.GetValue(LoneDruid.callBackBearRange) then
			LoneDruid.callBearBack()
		  end
		  if distance > Menu.GetValue(LoneDruid.callBackBearRange) + 1100 then
			LoneDruid.callBearBackReturn()
		  end
		end
		  
		if Menu.IsKeyDown(LoneDruid.callBackKey) then
			LoneDruid.callBearBack()
			if distance > Menu.GetValue(LoneDruid.callBackBearRange) then
				LoneDruid.callBearBackReturn()
			end
		end
		
		if Menu.IsKeyDown(LoneDruid.comboKey) and Menu.IsEnabled(LoneDruid.enableCombo) then LoneDruid.combo() end

	end
end

function LoneDruid.callBearBack()
    Player.PrepareUnitOrders(Players.GetLocal(), Enum.UnitOrder.DOTA_UNIT_ORDER_MOVE_TO_POSITION, target, Entity.GetAbsOrigin(me), ability, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, spiritBear)
end

function LoneDruid.callBearBackReturn()
	local spiritBearReturn = NPC.GetAbility(spiritBear, "lone_druid_spirit_bear_return")
	if spiritBearReturn and Ability.IsCastable(spiritBearReturn, spiritBearMana) and Ability.IsReady(spiritBearReturn) then
	  Ability.CastNoTarget(spiritBearReturn)
	end
	Player.ClearSelectedUnits(Players.GetLocal())
	Player.AddSelectedUnit(Players.GetLocal(), me)
	Player.AddSelectedUnit(Players.GetLocal(), spiritBear)
end

function LoneDruid.combo()

	if Utility.sleepReady(1) then
		
		local enemy = Input.GetNearestHeroToCursor(Entity.GetTeamNum(me), Enum.TeamType.TEAM_ENEMY)
		
		if(enemy ~= nill) then
			
			local enemyVector = Entity.GetAbsOrigin(enemy);
			local distance = Entity.GetAbsOrigin(spiritBear):Distance(enemyVector):Length2D()
			
			if distance > Menu.GetValue(LoneDruid.callBackBearRange) then	
				LoneDruid.callBearBackReturn()
			end
		
		end
		
		local spiritLink = NPC.GetAbility(me, "lone_druid_spirit_link")
		local battleCry = NPC.GetAbility(me, "lone_druid_true_form_battle_cry")
	   
		if NPC.HasModifier(me, "modifier_lone_druid_true_form") then
			if not NPC.HasModifier(me, "modifier_lone_druid_true_form_battle_cry") then
			  if battleCry and Ability.IsCastable(battleCry, mana) and Ability.IsReady(battleCry) then
				  Ability.CastNoTarget(battleCry)
				return
			  end
			end
		end
		if not NPC.HasModifier(me, "modifier_lone_druid_spirit_link") then
			if spiritLink and Ability.IsCastable(spiritLink, mana) and Ability.IsReady(spiritLink) then
				Ability.CastNoTarget(spiritLink)
			  return
			end
		end
	end

end

function Utility.makeDelay(sec)

	Utility.delay = sec + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
	Utility.lastTick = os.clock()

end

function Utility.ResetGlobalVariables()
  Utility.lastTick = 0
  Utility.delay = 0
  Utility.itemDelay = 0
  Utility.lastItemCast = 0
  Utility.lastItemTick = 0
  
  me = nil
  mana = nill

  phaseBoots = nil
  ultimateScepter = nil

  spiritBear = nil
  spiritBearMana = nil
  spiritBearPhaseBoots = nil
end

function Utility.OnGameStart()
	Utility.ResetGlobalVariables()
end

function Utility.OnGameEnd()
	Utility.ResetGlobalVariables()
end

function Utility.noItemCastFor(sec)

	Utility.itemDelay = sec
	Utility.lastItemTick = os.clock()

end

function Utility.sleepReady(sleep)

	if (os.clock() - Utility.lastTick) >= sleep then
		return true
	end
	return false

end

function Utility.iItemSleepReady(sleep)

	if (os.clock() - Utility.lastItemCast) >= sleep then
		return true
	end
	return false

end

function Utility.getAvgLatency()

	local AVGlatency = NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING) * 2
	return AVGlatency

end

function Utility.castAnimationDelay(ability)

	if not ability then return end
	local abilityAnimation = Ability.GetCastPoint(ability) + Utility.GetAvgLatency()
	return abilityAnimation

end

return LoneDruid
