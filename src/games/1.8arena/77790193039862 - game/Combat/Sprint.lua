local Sprint

Sprint = vape.Categories.Combat:CreateModule({
	Name = 'Sprint',
	Function = function(callback)
		if callback then
			repeat
				arena.PlayerState.Preferences.AutoSprint = true
				task.wait(0.016)
			until not Sprint.Enabled
		end
	end,
	Tooltip = 'Sets your sprinting to true.'
})