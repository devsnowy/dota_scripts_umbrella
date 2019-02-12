local WrapUtility = {}

WrapUtility.HInRadius = function (vec, radius, teamNum, teamType)
	local tbl = Heroes.InRadius(vec, radius, teamNum, teamType)
	if tbl ~= nil then
		return tbl
	else
		return {}
	end
end

WrapUtility.TInRadius = function (vec, radius, active)
	local  tbl = Trees.InRadius(vec, radius, active)
	if tbl ~= nil then
		return tbl
	else
		return {}
	end
end

WrapUtility.NInRadius = function (vec, radius, teamNum, teamType)
	local  tbl = NPCs.InRadius(vec, radius, teamNum, teamType)
	if tbl ~= nil then
		return tbl
	else
		return {}
	end
end



WrapUtility.HeroesInRadius = function (entity, radius, team)
	local tbl = Entity.GetHeroesInRadius(entity,  math.floor(radius), team)
	if tbl ~= nil then
			return tbl
	else
		return {}
	end
end

WrapUtility.UnitsInRadius = function (entity, radius, team)
	local tbl = Entity.GetUnitsInRadius(entity,  math.floor(radius), team)
	if tbl ~= nil then

			return tbl
	else
		return {}
	end
end

WrapUtility.TreesInRadius = function (radius, active)
	local tbl = Entity.GetTreesInRadius( math.floor(radius), active)
	if tbl ~= nil then
		return tbl
	else
		return {}
	end
end

WrapUtility.EIsAlive = function (entity)
	if entity and entity ~= 0 then
		return Entity.IsAlive(entity)
	else
		return false
	end
end

WrapUtility.EIsNPC = function (entity)
	if entity and entity ~= 0 then
		return Entity.IsNPC(entity)
	else
		return false
	end
end

function WrapUtility.GetRadius(p1)
	return Ability.GetLevelSpecialValueFor(p1, "radius")
end

WrapUtility.ConfigReadString = function(p1, p2, p3)
	if p3 == nil then
		local answ = Config.ReadString(p1, p2, "")
		if answ ~= nil then
			return answ
		else
			return ""
		end
	else
		return Config.ReadString(p1, p2, p3)
	end
end

WrapUtility.ConfigReadInt = function(p1, p2, p3)
	if p3 == nil then
		local answ = Config.ReadInt(p1, p2, 0)
		if answ ~= nil then
			return answ
		else
			return 0
		end
	else
		local answ = Config.ReadInt(p1, p2, p3)
		if answ ~= nil then
			return answ
		else
			return 0
		end
	end
end

WrapUtility.ConfigReadString = function(p1, p2, p3)
	if p3 == nil then
		local answ = Config.ReadString(p1, p2, "")
		if answ ~= nil then
			return answ
		else
			return ""
		end
	else
		return Config.ReadString(p1, p2, p3)
	end
end

function WrapUtility.Extend(p1, p2, p3)
	return p1 + ((p2 - p1):Normalized():Scaled(p3))
end

function WrapUtility.DrawTextCenteredX(p1, p2, p3, p4, p5)
	local wide, tall = Renderer.GetTextSize(p1, p4)
	return Renderer.DrawText(p1, p2 - wide/2, p3, p4)
end

function WrapUtility.DrawTextCenteredY(p1, p2, p3, p4, p5)
	local wide, tall = Renderer.GetTextSize(p1, p4)
	return Renderer.DrawText(p1, p2, p3 - tall/2, p4)
end

function WrapUtility.DrawTextCentered(p1, p2, p3, p4, p5)
	local wide, tall = Renderer.GetTextSize(p1, p4)
	return Renderer.DrawText(p1, p2 - wide/2 , p3 - tall/2, p4)
end


return WrapUtility