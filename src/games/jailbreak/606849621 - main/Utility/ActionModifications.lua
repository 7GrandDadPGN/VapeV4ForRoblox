local ActionModifications
local Instant
local NoWall
local old, oldindex
local await
local blacklist = {
	['Break In'] = true,
	['Place TNT'] = true
}

ActionModifications = vape.Categories.Utility:CreateModule({
	Name = 'ActionModifications',
	Function = function(callback)
		if callback then
			if Instant.Enabled then
				old = hookfunction(jb.CircleAction.Press, function(...)
					local action = jb.CircleAction.Spec
					if action and action.Timed and not (action.ReleaseCallback or action.ShouldArrest or action.ShouldBreakout or action.ShouldHotwire or blacklist[action.Name] or await) then
						local old = action.Timed

						action.Timed = false
						await = task.defer(function()
							action.Timed = old
							await = nil
						end)
					end

					return old(...)
				end)
			end

			if NoWall.Enabled then
				oldindex = debug.getupvalue(jb.UI.CircleAction.UpdateLogic, 1)
				debug.setconstant(oldindex, 47, 'Part')
			end
		else
			if old then
				restorefunction(jb.CircleAction.Press)
				old = nil
			end

			if oldindex then
				debug.setconstant(oldindex, 47, 'NoRay')
				oldindex = nil
			end
		end
	end,
	Tooltip = 'Allows you to modify certain properties of actions.'
})
Instant = ActionModifications:CreateToggle({
	Name = 'Instant',
	Function = function()
		if ActionModifications.Enabled then
			ActionModifications:Toggle()
			ActionModifications:Toggle()
		end
	end,
	Tooltip = 'Allows you to instantly complete certain ProximityPrompt actions.',
	Default = true
})
NoWall = ActionModifications:CreateToggle({
	Name = 'No wallcheck',
	Function = function()
		if ActionModifications.Enabled then
			ActionModifications:Toggle()
			ActionModifications:Toggle()
		end
	end,
	Tooltip = 'Allows you to interact with all ProximityPrompts through walls.',
	Default = true
})