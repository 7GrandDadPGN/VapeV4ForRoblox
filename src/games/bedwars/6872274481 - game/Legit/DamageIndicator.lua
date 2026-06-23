local DamageIndicator
local FontOption
local Color
local Size
local Anchor
local Stroke
local suc, tab = pcall(function()
	return debug.getupvalue(bedwars.DamageIndicator, 2)
end)
tab = suc and tab or {}
local oldvalues, oldfont = {}

DamageIndicator = vape.Legit:CreateModule({
	Name = 'Damage Indicator',
	Function = function(callback)
		if callback then
			oldvalues = table.clone(tab)
			oldfont = debug.getconstant(bedwars.DamageIndicator, 86)
			debug.setconstant(bedwars.DamageIndicator, 86, Enum.Font[FontOption.Value])
			debug.setconstant(bedwars.DamageIndicator, 119, Stroke.Enabled and 'Thickness' or 'Enabled')
			tab.strokeThickness = Stroke.Enabled and 1 or false
			tab.textSize = Size.Value
			tab.blowUpSize = Size.Value
			tab.blowUpDuration = 0
			tab.baseColor = Color3.fromHSV(Color.Hue, Color.Sat, Color.Value)
			tab.blowUpCompleteDuration = 0
			tab.anchoredDuration = Anchor.Value
		else
			for i, v in oldvalues do
				tab[i] = v
			end
			debug.setconstant(bedwars.DamageIndicator, 86, oldfont)
			debug.setconstant(bedwars.DamageIndicator, 119, 'Thickness')
		end
	end,
	Tooltip = 'Customize the damage indicator'
})
local fontitems = {'GothamBlack'}
for _, v in Enum.Font:GetEnumItems() do
	if v.Name ~= 'GothamBlack' then
		table.insert(fontitems, v.Name)
	end
end
FontOption = DamageIndicator:CreateDropdown({
	Name = 'Font',
	List = fontitems,
	Function = function(val)
		if DamageIndicator.Enabled then
			debug.setconstant(bedwars.DamageIndicator, 86, Enum.Font[val])
		end
	end
})
Color = DamageIndicator:CreateColorSlider({
	Name = 'Color',
	DefaultHue = 0,
	Function = function(hue, sat, val)
		if DamageIndicator.Enabled then
			tab.baseColor = Color3.fromHSV(hue, sat, val)
		end
	end
})
Size = DamageIndicator:CreateSlider({
	Name = 'Size',
	Min = 1,
	Max = 32,
	Default = 32,
	Function = function(val)
		if DamageIndicator.Enabled then
			tab.textSize = val
			tab.blowUpSize = val
		end
	end
})
Anchor = DamageIndicator:CreateSlider({
	Name = 'Anchor',
	Min = 0,
	Max = 1,
	Decimal = 10,
	Function = function(val)
		if DamageIndicator.Enabled then
			tab.anchoredDuration = val
		end
	end
})
Stroke = DamageIndicator:CreateToggle({
	Name = 'Stroke',
	Function = function(callback)
		if DamageIndicator.Enabled then
			debug.setconstant(bedwars.DamageIndicator, 119, callback and 'Thickness' or 'Enabled')
			tab.strokeThickness = callback and 1 or false
		end
	end
})