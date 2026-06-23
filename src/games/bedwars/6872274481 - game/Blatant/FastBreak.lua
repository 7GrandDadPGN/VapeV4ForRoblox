local FastBreak
local Time

FastBreak = vape.Categories.Blatant:CreateModule({
	Name = 'FastBreak',
	Function = function(callback)
		if callback then
			repeat
				bedwars.BlockBreakController.blockBreaker:setCooldown(Time.Value)
				task.wait(0.1)
			until not FastBreak.Enabled
		else
			bedwars.BlockBreakController.blockBreaker:setCooldown(0.3)
		end
	end,
	Tooltip = 'Decreases block hit cooldown'
})
Time = FastBreak:CreateSlider({
	Name = 'Break speed',
	Min = 0,
	Max = 0.3,
	Default = 0.25,
	Decimal = 100,
	Suffix = 'seconds'
})