local AutoClicker
local CPS

AutoClicker = vape.Categories.Combat:CreateModule({
	Name = 'AutoClicker',
	Function = function(callback)
		if callback then
			repeat
				local tool = getTool()
				if tool and inputService:IsMouseButtonPressed(0) then
					tool:Activate()
				end

				task.wait(1 / CPS.GetRandomValue())
			until not AutoClicker.Enabled
		end
	end,
	Tooltip = 'Automatically clicks for you'
})
CPS = AutoClicker:CreateTwoSlider({
	Name = 'CPS',
	Min = 1,
	Max = 20,
	DefaultMin = 8,
	DefaultMax = 12
})