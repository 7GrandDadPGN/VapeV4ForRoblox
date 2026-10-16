vape.Categories.Blatant:CreateModule({
	Name = 'NoSlowdown',
	Function = function(callback)
		if callback then
			old = hookfunction(tribes.SetSpeed, function() end)
			table.clear(tribes.State.speed)
		else
			if old then
				restorefunction(tribes.SetSpeed)
			end
		end
	end,
	Tooltip = 'Prevents slowing down when using items.'
})