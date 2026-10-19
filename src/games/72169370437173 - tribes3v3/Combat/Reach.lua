local Value
local Arc
local old

Reach = vape.Categories.Combat:CreateModule({
	Name = 'Reach',
	Function = function(callback)
		if callback then
			old = hookfunction(tribes.Melee.Detect, function(...)
				local pack = table.pack(...)
				pack[2] += Value.Value
				pack[3] += Arc.Value

				return old(unpack(pack, 1, pack.n))
			end)
		else
			if old then
				restorefunction(tribes.Melee.Detect)
				old = nil
			end
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