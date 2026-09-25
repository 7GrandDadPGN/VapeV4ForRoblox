local VehicleSpeed
local Value
local Boat
local old
local oldboat

VehicleSpeed = vape.Categories.Blatant:CreateModule({
	Name = 'VehicleSpeed',
	Function = function(callback)
		if callback then
			old = hookfunction(jb.AlexChassis.Update, function(...)
				local self = ...
				self.GarageEngineSpeed = Value.Value
				return old(...)
			end)

			if Boat.Enabled then
				oldboat = hookfunction(jb.Boat.UpdatePhysics, function(...)
					local self = ...
					self.SpringAccelp *= math.max(Value.Value / 10, 1)
					return oldboat(...)
				end)
			end
		else
			if old then
				restorefunction(jb.AlexChassis.Update)
				old = nil
			end

			if oldboat then
				restorefunction(jb.Boat.UpdatePhysics)
				oldboat = nil
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
Boat = VehicleSpeed:CreateToggle({
	Name = 'Modify Boats',
	Default = true,
	Function = function()
		if VehicleSpeed.Enabled then
			VehicleSpeed:Toggle()
			VehicleSpeed:Toggle()
		end
	end,
	Tooltip = 'Allow you to adjust the speed of boats'
})
