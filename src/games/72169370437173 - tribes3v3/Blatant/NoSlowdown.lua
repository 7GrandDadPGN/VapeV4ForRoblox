vape.Categories.Blatant:CreateModule({
	Name = 'NoSlowdown',
	Function = function(callback)
		if callback then
			if true then return end
			old = hookfunction(tribes.SetSpeed, newcclosure(function(...)
				hideStack()
				if not argCheck({{'string'}, {'number', 'nil'}}, ...) then
					return old(...)
				end
			end))

			table.clear(rawget(tribes.State, 'speed') or {})
		else
			if old then
				restorefunction(tribes.SetSpeed)
			end
		end
	end,
	Tooltip = 'Prevents slowing down when using items.'
})