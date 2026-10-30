vape.Categories.Blatant:CreateModule({
	Name = 'NoSlowdown',
	Function = function(callback)
		if callback then
			old = hookfunction(tribes.SetSpeed, function() end)
			table.clear(rawget(tribes.State, 'speed') or {})
		else
			if old then
				restorefunction(tribes.SetSpeed)
			end
		end
	end,
	Tooltip = 'Prevents slowing down when using items.'
})