local FPSBoost
local Kill
local Visualizer
local effects, util = {}, {}

FPSBoost = vape.Legit:CreateModule({
	Name = 'FPS Boost',
	Function = function(callback)
		if callback then
			if Kill.Enabled then
				for i, v in bedwars.KillEffectController.killEffects do
					if not i:find('Custom') then
						effects[i] = v
						bedwars.KillEffectController.killEffects[i] = {
							new = function() 
								return {
									onKill = function() end, 
									isPlayDefaultKillEffect = function() 
										return true 
									end
								} 
							end
						}
					end
				end
			end

			if Visualizer.Enabled then
				for i, v in bedwars.VisualizerUtils do
					util[i] = v
					bedwars.VisualizerUtils[i] = function() end
				end
			end

			repeat task.wait() until store.matchState ~= 0
			if not bedwars.AppController then return end
			bedwars.NametagController.addGameNametag = function() end
			for _, v in bedwars.AppController:getOpenApps() do
				if tostring(v):find('Nametag') then
					bedwars.AppController:closeApp(tostring(v))
				end
			end
		else
			for i, v in effects do 
				bedwars.KillEffectController.killEffects[i] = v 
			end
			for i, v in util do 
				bedwars.VisualizerUtils[i] = v 
			end
			table.clear(effects)
			table.clear(util)
		end
	end,
	Tooltip = 'Improves the framerate by turning off certain effects'
})
Kill = FPSBoost:CreateToggle({
	Name = 'Kill Effects',
	Function = function()
		if FPSBoost.Enabled then
			FPSBoost:Toggle()
			FPSBoost:Toggle()
		end
	end,
	Default = true
})
Visualizer = FPSBoost:CreateToggle({
	Name = 'Visualizer',
	Function = function()
		if FPSBoost.Enabled then
			FPSBoost:Toggle()
			FPSBoost:Toggle()
		end
	end,
	Default = true
})