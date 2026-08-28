local old
local await

vape.Categories.Utility:CreateModule({
	Name = 'InstantAction',
	Function = function(callback)
		if callback then
			old = hookfunction(jb.CircleAction.Press, function(...)
				local action = jb.CircleAction.Spec
				if action and action.Timed and not (action.ReleaseCallback or action.ShouldHotwire or await) then
					local old = action.Timed

					action.Timed = false
					await = task.defer(function()
						action.Timed = old
						await = nil
					end)
				end

				return old(...)
			end)
		else
			if old then
				restorefunction(jb.CircleAction.Press)
				old = nil
			end
		end
	end,
	Tooltip = 'Allows you to instantly complete ProximityPrompt actions'
})