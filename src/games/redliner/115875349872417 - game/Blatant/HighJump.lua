local HighJump
local Value

HighJump = vape.Categories.Blatant:CreateModule({
	Name = 'HighJump',
	Function = function(callback)
		if callback then
			HighJump:Toggle()
			if redline[redline.MoveController] and typeof(redline[redline.MoveController][redline.VelocityName]) == 'Vector3' then
				redline[redline.MoveController][redline.VelocityName] += Vector3.new(0, Value.Value, 0)
			end
		end
	end,
	ExtraText = function()
		return 'Redliner'
	end,
	Tooltip = 'Lets you jump higher'
})
Value = HighJump:CreateSlider({
	Name = 'Velocity',
	Min = 1,
	Max = 150,
	Default = 50,
	Suffix = function(val)
		return val == 1 and 'stud' or 'studs'
	end
})