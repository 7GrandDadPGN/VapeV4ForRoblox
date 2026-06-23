local FOV
local Value
local old, old2

FOV = vape.Legit:CreateModule({
	Name = 'FOV',
	Function = function(callback)
		if callback then
			old = bedwars.FovController.setFOV
			old2 = bedwars.FovController.getFOV
			bedwars.FovController.setFOV = function(self) 
				return old(self, Value.Value) 
			end
			bedwars.FovController.getFOV = function() 
				return Value.Value 
			end
		else
			bedwars.FovController.setFOV = old
			bedwars.FovController.getFOV = old2
		end
		
		bedwars.FovController:setFOV(bedwars.Store:getState().Settings.fov)
	end,
	Tooltip = 'Adjusts camera vision'
})
Value = FOV:CreateSlider({
	Name = 'FOV',
	Min = 30,
	Max = 120
})