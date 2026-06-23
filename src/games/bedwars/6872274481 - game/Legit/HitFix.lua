vape.Legit:CreateModule({
	Name = 'HitFix',
	Function = function(callback)
		debug.setconstant(bedwars.SwordController.swingSwordAtMouse, 23, callback and 'raycast' or 'Raycast')
		debug.setupvalue(bedwars.SwordController.swingSwordAtMouse, 4, callback and bedwars.QueryUtil or workspace)
	end,
	Tooltip = 'Changes the raycast function to the correct one'
})