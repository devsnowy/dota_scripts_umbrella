local MineDestroyer = {}

MineDestroyer.optionEnabled = Menu.AddOptionBool({"Utility"}, "Mine Destroyer", false)

function MineDestroyer.OnUpdate()
	if not Menu.IsEnabled( MineDestroyer.optionEnabled ) then return end

	local hero = Heroes.GetLocal()
	if
		not hero or
		not Entity.IsAlive(hero)
	then
		return false end
		
	local radius = NPC.GetAttackRange(hero)
		
	if radius < 430 then 
		radius = 430
	end
		
	local npcs = Entity.GetUnitsInRadius(hero, radius, Enum.TeamType.TEAM_ENEMY)
	if not npcs or #npcs < 1 then return end

	for i = 0, #npcs do
		local npc = npcs[i]
		if npc and not Entity.IsSameTeam(hero, npc) then
			local name = NPC.GetUnitName(npc)
			if name and name == "npc_dota_techies_land_mine" or name == "npc_dota_techies_stasis_trap" then
				MineDestroyer.Attack(hero, npc)
			end
		end
	end
end

function MineDestroyer.Attack(hero, target)
	
	if
		MineDestroyer.isHeroInvisible(hero) or
		MineDestroyer.isHeroChannelling(hero) or
		MineDestroyer.isHeroUnderStress(hero)
	then
		return end

	Player.AttackTarget(Players.GetLocal(), hero, target)
end

function MineDestroyer.isHeroInvisible(hero)

	if
		not hero or
		not Entity.IsAlive(hero)
	then
		return false end

	if NPC.HasState(hero, Enum.ModifierState.MODIFIER_STATE_INVISIBLE) then return true end
	if NPC.HasModifier(hero, "modifier_invoker_ghost_walk_self") then return true end
	if NPC.HasAbility(hero, "invoker_ghost_walk") then
		if Ability.SecondsSinceLastUse(NPC.GetAbility(hero, "invoker_ghost_walk")) > -1 and Ability.SecondsSinceLastUse(NPC.GetAbility(hero, "invoker_ghost_walk")) < 1 then 
			return true
		end
	end

	if NPC.HasItem(hero, "item_invis_sword", true) then
		if Ability.SecondsSinceLastUse(NPC.GetItem(hero, "item_invis_sword", true)) > -1 and Ability.SecondsSinceLastUse(NPC.GetItem(hero, "item_invis_sword", true)) < 1 then 
			return true
		end
	end
	if NPC.HasItem(hero, "item_silver_edge", true) then
		if Ability.SecondsSinceLastUse(NPC.GetItem(hero, "item_silver_edge", true)) > -1 and Ability.SecondsSinceLastUse(NPC.GetItem(hero, "item_silver_edge", true)) < 1 then 
			return true
		end
	end
	
	return false
end

function MineDestroyer.isHeroUnderStress(hero)

	if
		NPC.IsStunned(hero) or
		NPC.HasModifier(hero, "modifier_bashed") or
		NPC.HasState(hero, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) or
		NPC.HasModifier(hero, "modifier_eul_cyclone") or
		NPC.HasModifier(hero, "modifier_obsidian_destroyer_astral_imprisonment_prison") or
		NPC.HasModifier(hero, "modifier_shadow_demon_disruption") or
		NPC.HasModifier(hero, "modifier_invoker_tornado") or
		NPC.HasState(hero, Enum.ModifierState.MODIFIER_STATE_HEXED) or
		NPC.HasModifier(hero, "modifier_legion_commander_duel") or
		NPC.HasModifier(hero, "modifier_axe_berserkers_call") or
		NPC.HasModifier(hero, "modifier_winter_wyvern_winters_curse") or
		NPC.HasModifier(hero, "modifier_bane_fiends_grip") or
		NPC.HasModifier(hero, "modifier_bane_nightmare") or
		NPC.HasModifier(hero, "modifier_faceless_void_chronosphere_freeze") or
		NPC.HasModifier(hero, "modifier_enigma_black_hole_pull") or
		NPC.HasModifier(hero, "modifier_magnataur_reverse_polarity") or
		NPC.HasModifier(hero, "modifier_pudge_dismember") or
		NPC.HasModifier(hero, "modifier_shadow_shaman_shackles") or
		NPC.HasModifier(hero, "modifier_techies_stasis_trap_stunned") or
		NPC.HasModifier(hero, "modifier_storm_spirit_electric_vortex_pull") or
		NPC.HasModifier(hero, "modifier_tidehunter_ravage") or
		NPC.HasModifier(hero, "modifier_windrunner_shackle_shot")
	then
		return true end

	return false
end

function MineDestroyer.isHeroChannelling(hero)

	if
		NPC.IsChannellingAbility(hero) or
		NPC.HasModifier(hero, "modifier_teleporting")
	then
		return true end
		
	return false
end

return MineDestroyer