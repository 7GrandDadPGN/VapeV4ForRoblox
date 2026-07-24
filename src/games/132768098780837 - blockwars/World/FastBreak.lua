local FastBreak
local Value
local old

FastBreak = vape.Categories.World:CreateModule({
	Name = 'FastBreak',
	Function = function(callback)
		if callback then
			old = hookfunction(bw.BlockBreakConstants.CooldownFor, function(...)
				return old(...) * (Value.Value / 100)
			end)
		else
			if old then
				hookfunction(bw.BlockBreakConstants.CooldownFor, old)
				old = nil
			end
		end
	end,
	Tooltip = 'Allow you to swing the pickaxe faster.'
})
Value = FastBreak:CreateSlider({
	Name = 'Break Speed Percent',
	Min = 0,
	Max = 100,
	Default = 50,
	Suffix = '%'
})