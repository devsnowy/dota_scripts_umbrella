local Furion = {}

enemy = nil
me = nil
midas = nil


Furion.enablecombo = Menu.AddOptionBool({"Hero Specific", "Furion"}, "Enabled", false)
Menu.AddMenuIcon({"Hero Specific", "Furion"}, "panorama/images/heroes/icons/npc_dota_hero_furion_png.vtex_c")
Furion.key = Menu.AddKeyOption({ "Hero Specific", "Furion" }, "Combo Key", Enum.ButtonCode.BUTTON_CODE_NONE)
Furion.enableblock = Menu.AddOptionBool({"Hero Specific", "Furion"}, "Treant Block", true)
Furion.addsprout = Menu.AddOptionBool({"Hero Specific", "Furion", "Use in combo"}, "Sprout", false)
Furion.addhex = Menu.AddOptionBool({"Hero Specific", "Furion", "Use in combo"}, "Hex (Scythe if Vyse)", false)
Furion.addorchid = Menu.AddOptionBool({"Hero Specific", "Furion", "Use in combo"}, "Orchid", false)
Furion.addbloodthorn = Menu.AddOptionBool({"Hero Specific", "Furion", "Use in combo"}, "Bloodthorn", false)
Furion.enableantilinka = Menu.AddOptionBool({"Hero Specific", "Furion", "Disable Linken`s Sphere"}, "Enable", true)
Furion.sheepstickforlink = Menu.AddOptionBool({"Hero Specific", "Furion", "Disable Linken`s Sphere"}, "Disable by hex", false)
Furion.bloodforlink = Menu.AddOptionBool({"Hero Specific", "Furion", "Disable Linken`s Sphere"}, "Disable by bloodthorn", false)
Furion.orchidforlink = Menu.AddOptionBool({"Hero Specific", "Furion", "Disable Linken`s Sphere"}, "Disable by orchid", false)


function Furion.OnUpdate()

	me = Heroes.GetLocal()
	midas = NPC.GetItem(me, "item_hand_of_midas")
	mana = NPC.GetMana(me)

	if not me or NPC.GetUnitName(me) ~= "npc_dota_hero_furion" then return end
	
	if Menu.IsKeyDown(Furion.key) and Menu.IsEnabled(Furion.enablecombo) then Furion.Combo(me, enemy) end

end


function Furion.Combo(me, enemy)


	me = Heroes.GetLocal()
	mana = NPC.GetMana(me)
	sprout = NPC.GetAbility(me, "furion_sprout")
	ultimate = NPC.GetAbility(me, "furion_wrath_of_nature")
	treants = NPC.GetAbility(me, "furion_force_of_nature")
	teleportation = NPC.GetAbility(me, "furion_teleportation")
	hex = NPC.GetItem(me, "item_sheepstick")
	orchid = NPC.GetItem(me, "item_orchid")
	bloodthorn= NPC.GetItem(me, "item_bloodthorn")

	enemy = Input.GetNearestHeroToCursor(Entity.GetTeamNum(me), Enum.TeamType.TEAM_ENEMY)

		if NPC.IsLinkensProtected(enemy) and bloodthorn or orchid or hex then
			if Menu.IsEnabled(Furion.enableantilinka) then
				if Menu.IsEnabled(Furion.sheepstickforlink) then
			if hex and Ability.IsReady(hex) then
				Ability.CastTarget(hex, enemy)
			end
		end
		end

		if Menu.IsEnabled(Furion.enableantilinka) then
			if Menu.IsEnabled(Furion.bloodforlink) then
		if bloodthorn and Ability.IsReady(bloodthorn) then
			Ability.CastTarget(bloodthorn, enemy)
		end
		end
		end

		if Menu.IsEnabled(Furion.enableantilinka) then
			if Menu.IsEnabled(Furion.orchidforlink) then
		if orchid and Ability.IsReady(orchid) then
			Ability.CastTarget(orchid, enemy)
		end
		end
		end



		if Entity.GetHealth(enemy) > 1 then



		if sprout and Menu.IsEnabled(Furion.addsprout) and Ability.IsCastable(sprout, mana) and Ability.IsReady(sprout) then
				          Ability.CastTarget(sprout, enemy)
				        return
				    end

						if Menu.IsEnabled(Furion.enableblock) and treants and Ability.GetLevel(treants) >= 4 and Ability.IsReady(treants) then Furion.Block(me, enemy) end

						if hex and Menu.IsEnabled(Furion.addhex) and Ability.IsCastable(hex, mana) and Ability.IsReady(hex) then
												Ability.CastTarget(hex, enemy)
											return
									end

									if orchid and Menu.IsEnabled(Furion.addorchid) and Ability.IsCastable(orchid, mana) and Ability.IsReady(orchid) then
															Ability.CastTarget(orchid, enemy)
														return
												end

												if bloodthorn and Menu.IsEnabled(Furion.addbloodthorn) and Ability.IsCastable(bloodthorn, mana) and Ability.IsReady(bloodthorn) then
																		Ability.CastTarget(bloodthorn, enemy)
																	return
															end
														end

			end
end

function Furion.Block(me, enemy)

	sprout = NPC.GetAbility(me, "furion_sprout")
	treants = NPC.GetAbility(me, "furion_force_of_nature")
	me = Heroes.GetLocal()
	mana = NPC.GetMana(me)
	enemy = Input.GetNearestHeroToCursor(Entity.GetTeamNum(me), Enum.TeamType.TEAM_ENEMY)
	position = Entity.GetAbsOrigin(enemy)

	if Ability.IsCastable(sprout, mana) and Ability.IsReady(sprout) then
								Ability.CastTarget(sprout, enemy)
							return
					end

					if Ability.IsCastable(treants, mana) and Ability.IsReady(treants) then
												Ability.CastPosition(treants, position)
											return
									end

end


return Furion
