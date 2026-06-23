local AutoRespawn

AutoRespawn = vape.Categories.Utility:CreateModule({
	Name = 'AutoRespawn',
	Function = function(callback)
		if callback then
			AutoRespawn:Clean(hookEvent('ENTER_CLI_KILLCAM', function(id, health)
				task.delay(0, function()
					frontlines.Main.exe_set(frontlines.Main.exe_set_t.CTRL_KILLCAM_TO_COMBAT_RELEASE)
				end)
			end))
		end
	end,
	Tooltip = 'Automatically respawns after death'
})