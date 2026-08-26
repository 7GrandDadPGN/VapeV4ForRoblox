local VehicleSpeed
local Value
local old

VehicleSpeed = vape.Categories.Blatant:CreateModule({
	Name = 'VehicleSpeed',
	Function = function(callback)
		if callback then
			old = hookfunction(jb.AlexChassis.Update, function(...)
				local self = ...
				self.GarageEngineSpeed = Value.Value
				return old(...)
			end)
		else
			if old then
				restorefunction(jb.AlexChassis.Update)
				old = nil
			end
		end
	end,
	Tooltip = 'Automatically adjust the engine level of the vehicle.'
})
Value = VehicleSpeed:CreateSlider({
	Name = 'Speed',
	Min = 0,
	Max = 30,
	Default = 30
})
