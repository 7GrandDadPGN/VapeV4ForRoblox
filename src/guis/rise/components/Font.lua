local fonts = {
	optionsettings.Blacklist,
	'Custom'
}
for _, v in Enum.Font:GetEnumItems() do
	if not table.find(fonts, v.Name) then table.insert(fonts, v.Name) end
end

local optionapi = {Value = Font.fromEnum(Enum.Font[fonts[1]])}
local fontdropdown
local fontbox
optionsettings.Function = optionsettings.Function or function() end

fontdropdown = components.Dropdown({
	Name = optionsettings.Name,
	List = fonts,
	Function = function(val)
		fontbox.Object.Visible = val == 'Custom' and fontdropdown.Object.Visible
		if val ~= 'Custom' then
			optionapi.Value = Font.fromEnum(Enum.Font[val])
			optionsettings.Function(optionapi.Value)
		else
			pcall(function()
				optionapi.Value = Font.fromId(tonumber(fontbox.Value))
			end)
			optionsettings.Function(optionapi.Value)
		end
	end,
	Darker = optionsettings.Darker,
	Visible = optionsettings.Visible
}, children, api)
optionapi.Object = fontdropdown.Object
fontbox = components.TextBox({
	Name = optionsettings.Name..' Asset',
	Placeholder = 'font (rbxasset)',
	Function = function()
		if fontdropdown.Value == 'Custom' then
			pcall(function()
				optionapi.Value = Font.fromId(tonumber(fontbox.Value))
			end)
			optionsettings.Function(optionapi.Value)
		end
	end,
	Visible = false,
	Darker = true
}, children, api)

fontdropdown.Object:GetPropertyChangedSignal('Visible'):Connect(function()
	fontbox.Object.Visible = fontdropdown.Object.Visible and fontdropdown.Value == 'Custom'
end)

return optionapi