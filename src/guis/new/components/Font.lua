local fonts = {
	props.Default,
	'Custom'
}

for _, v in Enum.Font:GetEnumItems() do
	if not table.find(fonts, v.Name) then
		table.insert(fonts, v.Name)
	end
end

local component = {
	Value = Font.fromEnum(Enum.Font[fonts[1]])
}
local fontdropdown
local fontbox
props.Function = props.Function or function() end

fontdropdown = components.Dropdown({
	Name = props.Name,
	List = fonts,
	Function = function(val)
		fontbox.Object.Visible = val == 'Custom' and fontdropdown.Object.Visible
		if val ~= 'Custom' then
			component.Value = Font.fromEnum(Enum.Font[val])
			props.Function(component.Value)
		else
			pcall(function()
				component.Value = Font.fromId(tonumber(fontbox.Value))
			end)

			props.Function(component.Value)
		end
	end,
	Darker = props.Darker,
	Visible = props.Visible
}, children, api)
component.Object = fontdropdown.Object

fontbox = components.TextBox({
	Name = props.Name..' Asset',
	Placeholder = 'font (rbxasset)',
	Function = function()
		if fontdropdown.Value == 'Custom' then
			pcall(function()
				component.Value = Font.fromId(tonumber(fontbox.Value))
			end)

			props.Function(component.Value)
		end
	end,
	Visible = false,
	Darker = true
}, children, api)

fontdropdown.Object:GetPropertyChangedSignal('Visible'):Connect(function()
	fontbox.Object.Visible = fontdropdown.Object.Visible and fontdropdown.Value == 'Custom'
end)

return component