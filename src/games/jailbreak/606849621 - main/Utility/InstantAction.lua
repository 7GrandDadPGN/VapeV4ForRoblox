vape.Categories.Utility:CreateModule({
	Name = 'InstantAction',
	Function = function(callback)
		debug.setconstant(jb.CircleAction.Press, 3, callback and 'Timeda' or 'Timed')
	end,
	Tooltip = 'Allows you to instantly complete ProximityPrompt actions'
})