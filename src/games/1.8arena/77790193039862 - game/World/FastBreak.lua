local FastBreak
local Value
local old

FastBreak = vape.Categories.World:CreateModule({
	Name = 'FastBreak',
	Function = function(callback)
		if callback then
			old = hookfunction(arena.Client.showMiningProgress, function(progress)
				progress *= Value.Value
				debug.setstack(3, 5, debug.getstack(3, 5) * Value.Value)
				return old(progress)
			end)
		else
			if old then
				hookfunction(arena.Client.showMiningProgress, old)
				old = nil
			end
		end
	end,
	Tooltip = 'Break blocks faster when mining.'
})
Value = FastBreak:CreateSlider({
	Name = 'Multiplier',
	Min = 0,
	Max = 3,
	Default = 3,
	Decimal = 10
})