local Sprint

Sprint = vape.Categories.Combat:CreateModule({
	Name = 'Sprint',
	Function = function(callback)
		if callback then
			repeat
				debug.setupvalue(jb.WalkSpeedFun, 9, true)
				task.wait(0.05)
			until not Sprint.Enabled
		end
	end,
	Tooltip = 'Sets your sprinting to true.'
})