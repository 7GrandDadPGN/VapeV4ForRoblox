local Waypoints
local FontOption
local List
local Color
local Scale
local Background
local Stroke
WaypointFolder = Instance.new('Folder')
WaypointFolder.Parent = vape.holder

Waypoints = vape.Categories.Render:CreateModule({
	Name = 'Waypoints',
	Function = function(callback)
		if callback then
			for _, data in List.ListEnabled do
				local split = data:split('/')
				local tagSize = getfontbounds(removeTags(split[2]), 14 * Scale.Value, FontOption.Value, Vector2.new(100000, 100000))
				local billboard = Instance.new('BillboardGui')
				billboard.AlwaysOnTop = true
				billboard.Size = UDim2.fromOffset(tagSize.X + 8, tagSize.Y + 7)
				billboard.StudsOffsetWorldSpace = Vector3.new(unpack(split[1]:split(',')))
				billboard.Parent = WaypointFolder
				local tag = Instance.new('TextLabel')
				tag.BackgroundColor3 = Color3.new()
				tag.BackgroundTransparency = Background.Value
				tag.BorderSizePixel = 0
				tag.FontFace = FontOption.Value
				tag.RichText = true
				tag.Size = billboard.Size
				tag.Text = split[2]
				tag.TextColor3 = Color3.fromHSV(Color.Hue, Color.Sat, Color.Value)
				tag.TextSize = 14 * Scale.Value
				tag.TextStrokeTransparency = Stroke.Value
				tag.Visible = true
				tag.Parent = billboard
			end
		else
			WaypointFolder:ClearAllChildren()
		end
	end,
	Tooltip = 'Mark certain spots with a visual indicator'
})
FontOption = Waypoints:CreateFont({
	Name = 'Font',
	Blacklist = 'Arial',
	Function = function()
		if Waypoints.Enabled then
			Waypoints:Toggle()
			Waypoints:Toggle()
		end
	end,
})
List = Waypoints:CreateTextList({
	Name = 'Points',
	Placeholder = '(name) | (x, y, z/name)',
	Function = function()
		if Waypoints.Enabled then
			Waypoints:Toggle()
			Waypoints:Toggle()
		end
	end,
	TextFunction = function(text)
		if not text:find('/') then
			local pos = entitylib.character.RootPart.Position // 1
			return pos.X..','..pos.Y..','..pos.Z..'/'..text
		end
	end
})
Color = Waypoints:CreateColorSlider({
	Name = 'Color',
	Function = function(hue, sat, val)
		for _, v in WaypointFolder:GetChildren() do
			v.TextLabel.TextColor3 = Color3.fromHSV(hue, sat, val)
		end
	end
})
Scale = Waypoints:CreateSlider({
	Name = 'Scale',
	Function = function()
		if Waypoints.Enabled then
			Waypoints:Toggle()
			Waypoints:Toggle()
		end
	end,
	Default = 1,
	Min = 0.1,
	Max = 1.5,
	Decimal = 10
})
Background = Waypoints:CreateSlider({
	Name = 'Transparency',
	Function = function()
		if Waypoints.Enabled then
			Waypoints:Toggle()
			Waypoints:Toggle()
		end
	end,
	Default = 0.5,
	Min = 0,
	Max = 1,
	Decimal = 10
})
Stroke = Waypoints:CreateSlider({
	Name = 'Stroke Transparency',
	Function = function()
		if Waypoints.Enabled then
			Waypoints:Toggle()
			Waypoints:Toggle()
		end
	end,
	Default = 1,
	Min = 0,
	Max = 1,
	Decimal = 10
})