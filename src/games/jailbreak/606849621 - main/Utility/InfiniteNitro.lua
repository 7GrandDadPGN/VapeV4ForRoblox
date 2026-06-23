local nitrotable = debug.getupvalue(jb.VehicleController.NitroShopVisible, 1)
local oldnitro

InfNitro = vape.Categories.Utility:CreateModule({
	Name = 'InfiniteNitro',
	Function = function(callback)
		if callback then
			oldnitro = nitrotable.Nitro
			jb.VehicleController.updateSpdBarRatio(1)

			repeat
				nitrotable.Nitro = 250
				task.wait(0.1)
			until not InfNitro.Enabled
		else
			nitrotable.Nitro = oldnitro
			jb.VehicleController.updateSpdBarRatio(oldnitro / 250)
		end
	end,
	Tooltip = 'Infinite boost for the local car'
})