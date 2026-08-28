local NoSlowdown
local Toggles = {}

NoSlowdown = vape.Categories.Blatant:CreateModule({
	Name = 'NoSlowdown',
	Function = function(callback)
		debug.setconstant(jb.WalkSpeedFun, 5, callback and Toggles.Damage.Enabled and 'MaxHealth' or 'Health')
		debug.setconstant(jb.WalkSpeedFun, 13, callback and Toggles.SWAT.Enabled and '_ShieldSWAT' or 'ShieldSWAT')
		debug.setconstant(jb.WalkSpeedFun, 16, callback and Toggles.Crawling.Enabled and 1 or 0.4)
		debug.setconstant(jb.WalkSpeedFun, 33, callback and Toggles.Spotlight.Enabled and '_IsInTrackingSpotlight' or 'IsInTrackingSpotlight')
	end,
	Tooltip = 'Prevents slowing down from various sources.'
})

for _, toggle in {'Damage', 'Crawling', 'SWAT', 'Spotlight'} do
	Toggles[toggle] = NoSlowdown:CreateToggle({
		Name = toggle,
		Function = function(callback)
			if NoSlowdown.Enabled then
				NoSlowdown:Toggle()
				NoSlowdown:Toggle()
			end
		end
	})
end