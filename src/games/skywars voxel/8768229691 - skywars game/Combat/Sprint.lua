local Sprint
local old

Sprint = vape.Categories.Combat:CreateModule({
	Name = 'Sprint',
	Function = function(callback)
		if callback then
			old = skywars.SprintingController.disableSprinting
			skywars.SprintingController.disableSprinting = function(tab, ...)
				local data = old(tab, ...)

				if not tab.canSprint then
					task.spawn(function()
						repeat task.wait(0.1) until tab.canSprint or not Sprint.Enabled

						if Sprint.Enabled then
							skywars.SprintingController:enableSprinting(tab)
						end
					end)
				else
					skywars.SprintingController:enableSprinting(tab)
				end

				return data
			end

			Sprint:Clean(entitylib.Events.LocalAdded:Connect(function()
				skywars.SprintingController:disableSprinting()
			end))

			skywars.SprintingController:disableSprinting()
		else
			skywars.SprintingController.disableSprinting = old
			skywars.SprintingController:disableSprinting()
		end
	end,
	Tooltip = 'Sets your sprinting to true.'
})