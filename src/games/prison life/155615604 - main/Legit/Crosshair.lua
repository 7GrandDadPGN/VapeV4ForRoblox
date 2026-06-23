local Crosshair
local Image
local old

Crosshair = vape.Legit:CreateModule({
	Name = 'Crosshair',
	Function = function(callback)
		if callback then
			debug.setconstant(oldequip or pl.Equip, 30, Image.Value:find('rbxasset') and Image.Value or isfile(Image.Value) and getcustomasset(Image.Value) or '')
		else
			debug.setconstant(oldequip or pl.Equip, 30, 'rbxassetid://98794608762931')
		end
	end,
	Tooltip = 'Change the crosshair icon'
})
Image = Crosshair:CreateTextBox({
	Name = 'Image',
	Placeholder = 'assetid',
	Function = function()
		if Crosshair.Enabled then
			debug.setconstant(oldequip or pl.Equip, 30, Image.Value:find('rbxasset') and Image.Value or isfile(Image.Value) and getcustomasset(Image.Value) or '')
		end
	end
})