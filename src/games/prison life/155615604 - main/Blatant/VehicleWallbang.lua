VehicleWallbang = vape.Categories.Blatant:CreateModule({
	Name = 'VehicleWallbang',
	Function = function(callback)
		OriginScanner:UpdateIgnore()

		if callback then
			pl.ShootParams.FilterDescendantsInstances = {lplr.Character, workspace.CarContainer}

			VehicleWallbang:Clean(entitylib.Events.LocalAdded:Connect(function()
				task.defer(function()
					pl.ShootParams.FilterDescendantsInstances = {lplr.Character, workspace.CarContainer}
				end)
			end))
		else
			pl.ShootParams.FilterDescendantsInstances = {lplr.Character}
		end
	end,
	Tooltip = 'Allow you to shoot through vehicles.'
})