local DropESP
local FontOption
local List
local Color
local Scale
local Background
local Stroke
local Reference = {}
DropFolder = Instance.new('Folder')
DropFolder.Parent = vape.holder

local function Added(obj)
	local tagSize = getfontbounds('Drop', 14 * Scale.Value, FontOption.Value, Vector2.new(100000, 100000))
	local billboard = Instance.new('BillboardGui')
	billboard.AlwaysOnTop = true
	billboard.Size = UDim2.fromOffset(tagSize.X + 8, tagSize.Y + 7)
	billboard.Adornee = obj
	billboard.Parent = DropFolder
	local tag = Instance.new('TextLabel')
	tag.BackgroundColor3 = Color3.new()
	tag.BackgroundTransparency = Background.Value
	tag.BorderSizePixel = 0
	tag.FontFace = FontOption.Value
	tag.RichText = true
	tag.Size = billboard.Size
	tag.Text = 'Drop'
	tag.TextColor3 = Color3.fromHSV(Color.Hue, Color.Sat, Color.Value)
	tag.TextSize = 14 * Scale.Value
	tag.TextStrokeTransparency = Stroke.Value
	tag.Visible = true
	tag.Parent = billboard
	Reference[obj] = billboard
end

DropESP = vape.Categories.Render:CreateModule({
	Name = 'DropESP',
	Function = function(callback)
		if callback then
			DropESP:Clean(collectionService:GetInstanceAddedSignal('Briefcase'):Connect(Added))
			DropESP:Clean(collectionService:GetInstanceRemovedSignal('Briefcase'):Connect(function(obj)
				if Reference[obj] then
					Reference[obj]:Destroy()
					Reference[obj] = nil
				end
			end))

			for _, obj in collectionService:GetTagged('Briefcase') do
				task.spawn(Added, obj)
			end
		else
			DropFolder:ClearAllChildren()
			table.clear(Reference)
		end
	end,
	Tooltip = 'Visualize all dropped crates.'
})
FontOption = DropESP:CreateFont({
	Name = 'Font',
	Blacklist = 'Arial',
	Function = function()
		if DropESP.Enabled then
			DropESP:Toggle()
			DropESP:Toggle()
		end
	end,
})
Color = DropESP:CreateColorSlider({
	Name = 'Color',
	Function = function(hue, sat, val)
		for _, v in WaypointFolder:GetChildren() do
			v.TextLabel.TextColor3 = Color3.fromHSV(hue, sat, val)
		end
	end
})
Scale = DropESP:CreateSlider({
	Name = 'Scale',
	Function = function()
		if DropESP.Enabled then
			DropESP:Toggle()
			DropESP:Toggle()
		end
	end,
	Default = 1,
	Min = 0.1,
	Max = 1.5,
	Decimal = 10
})
Background = DropESP:CreateSlider({
	Name = 'Transparency',
	Function = function()
		if DropESP.Enabled then
			DropESP:Toggle()
			DropESP:Toggle()
		end
	end,
	Default = 0.5,
	Min = 0,
	Max = 1,
	Decimal = 10
})
Stroke = DropESP:CreateSlider({
	Name = 'Stroke Transparency',
	Function = function()
		if DropESP.Enabled then
			DropESP:Toggle()
			DropESP:Toggle()
		end
	end,
	Default = 1,
	Min = 0,
	Max = 1,
	Decimal = 10
})