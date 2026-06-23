local Search
local List
local Color
local FillTransparency
local Reference = {}
local Folder = Instance.new('Folder')
Folder.Parent = vape.gui

local function Add(v)
	if not table.find(List.ListEnabled, v.Name) then return end
	if v:IsA('BasePart') or v:IsA('Model') then
		local size = v:IsA('Model') and v:GetExtentsSize() or v.Size
		local box = Instance.new('BoxHandleAdornment')
		box.AlwaysOnTop = true
		box.Adornee = v
		box.Size = size.Magnitude > 0.4 and size or Vector3.one
		box.ZIndex = 0
		box.Transparency = FillTransparency.Value
		box.Color3 = Color3.fromHSV(Color.Hue, Color.Sat, Color.Value)
		box.Parent = Folder
		Reference[v] = box
	end
end

Search = vape.Categories.Render:CreateModule({
	Name = 'Search',
	Function = function(callback)
		if callback then
			Search:Clean(workspace.DescendantAdded:Connect(Add))
			Search:Clean(workspace.DescendantRemoving:Connect(function(v)
				if Reference[v] then
					Reference[v]:Destroy()
					Reference[v] = nil
				end
			end))

			for _, v in workspace:GetDescendants() do
				Add(v)
			end
		else
			Folder:ClearAllChildren()
			table.clear(Reference)
		end
	end,
	Tooltip = 'Draws box around selected parts\nAdd parts in Search frame'
})
List = Search:CreateTextList({
	Name = 'Parts',
	Function = function()
		if Search.Enabled then
			Search:Toggle()
			Search:Toggle()
		end
	end
})
Color = Search:CreateColorSlider({
	Name = 'Color',
	Function = function(hue, sat, val)
		for _, v in Reference do
			v.Color3 = Color3.fromHSV(hue, sat, val)
		end
	end
})
FillTransparency = Search:CreateSlider({
	Name = 'Transparency',
	Min = 0,
	Max = 1,
	Function = function(val)
		for _, v in Reference do
			v.Transparency = val
		end
	end,
	Decimal = 10
})