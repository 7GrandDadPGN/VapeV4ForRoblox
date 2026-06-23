--[[local old

vape.Categories.Combat:CreateModule({
	Name = 'Reach',
	Function = function(callback)
		if callback then
			--old = rawget(bd.CombatConstants, 'REACH_IN_STUDS')
			--rawset(bd.CombatConstants, 'REACH_IN_STUDS', 18)
			--rawset(bd.Entity.LocalEntity, 'Reach', 18)
		else
			--rawset(bd.CombatConstants, 'REACH_IN_STUDS', old)
			--rawset(bd.Entity.LocalEntity, 'Reach', old)
			--old = nil
		end
	end,
	Tooltip = 'Extends attack reach'
})]]