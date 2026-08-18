local oldnitro

InfNitro = vape.Categories.Utility:CreateModule({
	Name = 'InfiniteNitro',
	Function = function(callback)
		if callback then
			oldnitro = jb.VehicleController.nitroState.Nitro
			jb.VehicleController.updateSpdBarRatio(1)

			repeat
				jb.VehicleController.nitroState.Nitro = 250
				task.wait(0.1)
			until not InfNitro.Enabled
		else
			jb.VehicleController.nitroState.Nitro = oldnitro
			jb.VehicleController.updateSpdBarRatio(oldnitro / 250)
		end
	end,
	Tooltip = 'Infinite boost for the local car'
})