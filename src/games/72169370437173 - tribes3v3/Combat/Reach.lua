local Value
local Arc
local old

Reach = vape.Categories.Combat:CreateModule({
	Name = 'Reach',
	Function = function(callback)
		if callback then
			HitboxHook:Add('Reach', function(args)
				args[2] += Value.Value
				args[3] = math.min(args[3] + Arc.Value, 90)
			end)
		else
			HitboxHook:Remove('Reach')
		end
	end,
	Tooltip = 'Extends attack reach'
})
Value = Reach:CreateSlider({
	Name = 'Range',
	Min = 0,
	Max = 4,
	Default = 4,
	Suffix = function(val)
		return val == 1 and 'stud' or 'studs'
	end
})
Arc = Reach:CreateSlider({
	Name = 'Arc',
	Min = 0,
	Max = 60,
	Default = 60,
	Suffix = function(val)
		return val == 1 and 'degree' or 'degrees'
	end
})