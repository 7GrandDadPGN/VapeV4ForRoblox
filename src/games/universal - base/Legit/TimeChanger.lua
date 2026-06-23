local TimeChanger
local Value
local old

TimeChanger = vape.Legit:CreateModule({
	Name = 'Time Changer',
	Function = function(callback)
		if callback then
			old = lightingService.TimeOfDay
			lightingService.TimeOfDay = Value.Value..':00:00'
		else
			lightingService.TimeOfDay = old
			old = nil
		end
	end,
	Tooltip = 'Change the time of the current world'
})
Value = TimeChanger:CreateSlider({
	Name = 'Time',
	Min = 0,
	Max = 24,
	Default = 12,
	Function = function(val)
		if TimeChanger.Enabled then 
			lightingService.TimeOfDay = val..':00:00'
		end
	end
})
