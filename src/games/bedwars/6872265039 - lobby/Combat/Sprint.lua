local Sprint
local old

Sprint = vape.Categories.Combat:CreateModule({
	Name = 'Sprint',
	Function = function(callback)
		if callback then
			if inputService.TouchEnabled then pcall(function() lplr.PlayerGui.MobileUI['2'].Visible = false end) end
			old = bedwars.SprintController.stopSprinting
			bedwars.SprintController.stopSprinting = function(...)
				local call = old(...)
				bedwars.SprintController:startSprinting()
				return call
			end
			Sprint:Clean(entitylib.Events.LocalAdded:Connect(function() bedwars.SprintController:stopSprinting() end))
			bedwars.SprintController:stopSprinting()
		else
			if inputService.TouchEnabled then pcall(function() lplr.PlayerGui.MobileUI['2'].Visible = true end) end
			bedwars.SprintController.stopSprinting = old
			bedwars.SprintController:stopSprinting()
		end
	end,
	Tooltip = 'Sets your sprinting to true.'
})