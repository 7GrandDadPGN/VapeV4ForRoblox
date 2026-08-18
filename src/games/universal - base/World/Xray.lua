local Xray
local List
local modified = {}

local function modifyPart(part)
	if part:IsA('BasePart') and not table.find(List.ListEnabled, part.Name) then
		modified[part] = true
		part.LocalTransparencyModifier = 0.5
	end
end

Xray = vape.Categories.World:CreateModule({
	Name = 'Xray',
	Function = function(callback)
		if callback then
			Xray:Clean(workspace.DescendantAdded:Connect(modifyPart))
			for _, part in workspace:QueryDescendants('BasePart') do
				modifyPart(part)
			end
		else
			for part in modified do
				part.LocalTransparencyModifier = 0
			end
			table.clear(modified)
		end
	end,
	Tooltip = 'Renders whitelisted parts through walls.'
})
List = Xray:CreateTextList({
	Name = 'Part',
	Function = function()
		if Xray.Enabled then
			Xray:Toggle()
			Xray:Toggle()
		end
	end
})