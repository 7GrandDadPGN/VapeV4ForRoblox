local FlyingAttack

FlyingAttack = vape.Categories.Blatant:CreateModule({
	Name = 'FlyingAttack',
	Function = function(callback)
		if callback then
			debug.setconstant(bt.Shucky.PossibleFirst, 7, '_Flying')
		else
			debug.setconstant(bt.Shucky.PossibleFirst, 7, 'Flying')
		end
	end,
	Tooltip = 'Allow you to attack flying enemies with onground attacks.'
})