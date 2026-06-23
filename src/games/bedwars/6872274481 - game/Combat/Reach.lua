local Value

Reach = vape.Categories.Combat:CreateModule({
	Name = 'Reach',
	Function = function(callback)
		bedwars.CombatConstant.RAYCAST_SWORD_CHARACTER_DISTANCE = callback and Value.Value + 2 or 14.4
	end,
	Tooltip = 'Extends attack reach'
})
Value = Reach:CreateSlider({
	Name = 'Range',
	Min = 0,
	Max = 18,
	Default = 18,
	Function = function(val)
		if Reach.Enabled then
			bedwars.CombatConstant.RAYCAST_SWORD_CHARACTER_DISTANCE = val + 2
		end
	end,
	Suffix = function(val)
		return val == 1 and 'stud' or 'studs'
	end
})