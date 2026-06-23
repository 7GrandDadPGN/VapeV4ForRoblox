vape.Categories.Blatant:CreateModule({
	Name = 'KeepSprint',
	Function = function(callback)
		debug.setconstant(bedwars.SprintController.startSprinting, 5, callback and 'blockSprinting' or 'blockSprint')
		bedwars.SprintController:stopSprinting()
	end,
	Tooltip = 'Lets you sprint with a speed potion.'
})