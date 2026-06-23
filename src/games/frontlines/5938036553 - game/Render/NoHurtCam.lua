local NoHurtCam

NoHurtCam = vape.Categories.Render:CreateModule({
	Name = 'NoHurtCam',
	Function = function(callback)
		if callback then
			NoHurtCam:Clean(hookEvent('UPDATE_FPV_SOL_DAMAGE_GFX', function() return true end))
			NoHurtCam:Clean(hookEvent('UPDATE_FPV_SOL_HEALTH_SFX', function() return true end))
			NoHurtCam:Clean(hookEvent('DISPLAY_SUPPRESSION_VIGNETTE', function() return true end))
		end
	end,
	Tooltip = 'Removes camera flash after taking damage'
})