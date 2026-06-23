local Waypoints
local FontOption
local List
local Color
local Scale
local Background
WaypointFolder = Instance.new('Folder')
WaypointFolder.Parent = vape.gui

Waypoints = vape.Categories.Render:CreateModule({
	Name = 'Waypoints',
	Function = function(callback)
		if callback then
			for _, v in List.ListEnabled do
				local split = v:split('/')
				local tagSize = getfontsize(removeTags(split[2]), 14 * Scale.Value, FontOption.Value, Vector2.new(100000, 100000))
				local billboard = Instance.new('BillboardGui')
				billboard.Size = UDim2.fromOffset(tagSize.X + 8, tagSize.Y + 7)
				billboard.StudsOffsetWorldSpace = Vector3.new(unpack(split[1]:split(',')))
				billboard.AlwaysOnTop = true
				billboard.Parent = WaypointFolder
				local tag = Instance.new('TextLabel')
				tag.BackgroundColor3 = Color3.new()
				tag.BorderSizePixel = 0
				tag.Visible = true
				tag.RichText = true
				tag.FontFace = FontOption.Value
				tag.TextSize = 14 * Scale.Value
				tag.BackgroundTransparency = Background.Value
				tag.Size = billboard.Size
				tag.Text = split[2]
				tag.TextColor3 = Color3.fromHSV(Color.Hue, Color.Sat, Color.Value)
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
	Placeholder = 'x, y, z/name',
	Function = function()
		if Waypoints.Enabled then
			Waypoints:Toggle()
			Waypoints:Toggle()
		end
	end
})
Waypoints:CreateButton({
	Name = 'Add current position',
	Function = function()
		if entitylib.isAlive then
			local pos = entitylib.character.RootPart.Position // 1
			List:ChangeValue(pos.X..','..pos.Y..','..pos.Z..'/Waypoint '..(#List.List + 1))
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
