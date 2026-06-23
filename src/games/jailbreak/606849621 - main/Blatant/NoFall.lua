vape.Categories.Blatant:CreateModule({
	Name = 'NoFall',
	Function = function(callback)
		debug.setconstant(debug.getupvalue(jb.FallingController.Init, 20), 9, callback and 'Archivable' or 'Sit')
	end,
	Tooltip = 'Disables ragdoll handling & fall damage'
})