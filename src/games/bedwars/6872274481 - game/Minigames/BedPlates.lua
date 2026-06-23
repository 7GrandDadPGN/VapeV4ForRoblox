local BedPlates
local Background
local Color = {}
local Reference = {}
local Folder = Instance.new('Folder')
Folder.Parent = vape.gui

local function scanSide(self, start, tab)
	for _, side in sides do
		for i = 1, 15 do
			local block = getPlacedBlock(start + (side * i))
			if not block or block == self then break end
			if not block:GetAttribute('NoBreak') and not table.find(tab, block.Name) then
				table.insert(tab, block.Name)
			end
		end
	end
end

local function refreshAdornee(v)
	for _, obj in v.Frame:GetChildren() do
		if obj:IsA('ImageLabel') and obj.Name ~= 'Blur' then
			obj:Destroy()
		end
	end

	local start = v.Adornee.Position
	local alreadygot = {}
	scanSide(v.Adornee, start, alreadygot)
	scanSide(v.Adornee, start + Vector3.new(0, 0, 3), alreadygot)
	table.sort(alreadygot, function(a, b)
		return (bedwars.ItemMeta[a].block and bedwars.ItemMeta[a].block.health or 0) > (bedwars.ItemMeta[b].block and bedwars.ItemMeta[b].block.health or 0)
	end)
	v.Enabled = #alreadygot > 0

	for _, block in alreadygot do
		local blockimage = Instance.new('ImageLabel')
		blockimage.Size = UDim2.fromOffset(32, 32)
		blockimage.BackgroundTransparency = 1
		blockimage.Image = bedwars.getIcon({itemType = block}, true)
		blockimage.Parent = v.Frame
	end
end

local function Added(v)
	local billboard = Instance.new('BillboardGui')
	billboard.Parent = Folder
	billboard.Name = 'bed'
	billboard.StudsOffsetWorldSpace = Vector3.new(0, 3, 0)
	billboard.Size = UDim2.fromOffset(36, 36)
	billboard.AlwaysOnTop = true
	billboard.ClipsDescendants = false
	billboard.Adornee = v
	local blur = addBlur(billboard)
	blur.Visible = Background.Enabled
	local frame = Instance.new('Frame')
	frame.Size = UDim2.fromScale(1, 1)
	frame.BackgroundColor3 = Color3.fromHSV(Color.Hue, Color.Sat, Color.Value)
	frame.BackgroundTransparency = 1 - (Background.Enabled and Color.Opacity or 0)
	frame.Parent = billboard
	local layout = Instance.new('UIListLayout')
	layout.FillDirection = Enum.FillDirection.Horizontal
	layout.Padding = UDim.new(0, 4)
	layout.VerticalAlignment = Enum.VerticalAlignment.Center
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
		billboard.Size = UDim2.fromOffset(math.max(layout.AbsoluteContentSize.X + 4, 36), 36)
	end)
	layout.Parent = frame
	local corner = Instance.new('UICorner')
	corner.CornerRadius = UDim.new(0, 4)
	corner.Parent = frame
	Reference[v] = billboard
	refreshAdornee(billboard)
end

local function refreshNear(data)
	data = data.blockRef.blockPosition * 3
	for i, v in Reference do
		if (data - i.Position).Magnitude <= 30 then
			refreshAdornee(v)
		end
	end
end

BedPlates = vape.Categories.Minigames:CreateModule({
	Name = 'BedPlates',
	Function = function(callback)
		if callback then
			for _, v in collectionService:GetTagged('bed') do 
				task.spawn(Added, v) 
			end
			BedPlates:Clean(vapeEvents.PlaceBlockEvent.Event:Connect(refreshNear))
			BedPlates:Clean(vapeEvents.BreakBlockEvent.Event:Connect(refreshNear))
			BedPlates:Clean(collectionService:GetInstanceAddedSignal('bed'):Connect(Added))
			BedPlates:Clean(collectionService:GetInstanceRemovedSignal('bed'):Connect(function(v)
				if Reference[v] then
					Reference[v]:Destroy()
					Reference[v]:ClearAllChildren()
					Reference[v] = nil
				end
			end))
		else
			table.clear(Reference)
			Folder:ClearAllChildren()
		end
	end,
	Tooltip = 'Displays blocks over the bed'
})
Background = BedPlates:CreateToggle({
	Name = 'Background',
	Function = function(callback)
		if Color.Object then 
			Color.Object.Visible = callback 
		end
		for _, v in Reference do
			v.Frame.BackgroundTransparency = 1 - (callback and Color.Opacity or 0)
			v.Blur.Visible = callback
		end
	end,
	Default = true
})
Color = BedPlates:CreateColorSlider({
	Name = 'Background Color',
	DefaultValue = 0,
	DefaultOpacity = 0.5,
	Function = function(hue, sat, val, opacity)
		for _, v in Reference do
			v.Frame.BackgroundColor3 = Color3.fromHSV(hue, sat, val)
			v.Frame.BackgroundTransparency = 1 - opacity
		end
	end,
	Darker = true
})