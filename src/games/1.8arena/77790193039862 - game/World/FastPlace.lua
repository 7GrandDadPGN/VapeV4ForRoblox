local FastPlace
local Value
local old

FastPlace = vape.Categories.World:CreateModule({
	Name = 'FastPlace',
	Function = function(callback)
		if callback then
			old = debug.getupvalue(arena.Client.startPlaceHold, 7)
			debug.setupvalue(arena.Client.startPlaceHold, 7, math.max(Value.Value, 0.001))
		else
			if old then
				debug.setupvalue(arena.Client.startPlaceHold, 7, old)
				old = nil
			end
		end
	end,
	Tooltip = 'Place blocks faster while holding right click.'
})
Value = FastPlace:CreateSlider({
	Name = 'Delay',
	Min = 0,
	Max = 0.2,
    Default = 0,
	Decimal = 100,
    Function = function(val)
		if FastPlace.Enabled then
			debug.setupvalue(arena.Client.startPlaceHold, 7, math.max(val, 0.001))
		end
	end,
	Suffix = function(val)
		return 'seconds'
	end
})