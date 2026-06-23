local StorageESP
local List
local Background
local Color = {}
local Reference = {}
local Folder = Instance.new('Folder')
Folder.Parent = vape.gui

local function nearStorageItem(item)
	for _, v in List.ListEnabled do
		if item:find(v) then return v end
	end
end

local function refreshAdornee(v)
	local chest = v.Adornee:FindFirstChild('ChestFolderValue')
	chest = chest and chest.Value or nil
	if not chest then
		v.Enabled = false
		return
	end

	local chestitems = chest and chest:GetChildren() or {}
	for _, obj in v.Frame:GetChildren() do
		if obj:IsA('ImageLabel') and obj.Name ~= 'Blur' then
			obj:Destroy()
		end
	end

	v.Enabled = false
	local alreadygot = {}
	for _, item in chestitems do
		if not alreadygot[item.Name] and (table.find(List.ListEnabled, item.Name) or nearStorageItem(item.Name)) then
			alreadygot[item.Name] = true
			v.Enabled = true
			local blockimage = Instance.new('ImageLabel')
			blockimage.Size = UDim2.fromOffset(32, 32)
			blockimage.BackgroundTransparency = 1
			blockimage.Image = bedwars.getIcon({itemType = item.Name}, true)
			blockimage.Parent = v.Frame
		end
	end
	table.clear(chestitems)
end

local function Added(v)
	local chest = v:WaitForChild('ChestFolderValue', 3)
	if not (chest and StorageESP.Enabled) then return end
	chest = chest.Value
	local billboard = Instance.new('BillboardGui')
	billboard.Parent = Folder
	billboard.Name = 'chest'
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
	StorageESP:Clean(chest.ChildAdded:Connect(function(item)
		if table.find(List.ListEnabled, item.Name) or nearStorageItem(item.Name) then
			refreshAdornee(billboard)
		end
	end))
	StorageESP:Clean(chest.ChildRemoved:Connect(function(item)
		if table.find(List.ListEnabled, item.Name) or nearStorageItem(item.Name) then
			refreshAdornee(billboard)
		end
	end))
	task.spawn(refreshAdornee, billboard)
end

StorageESP = vape.Categories.Render:CreateModule({
	Name = 'StorageESP',
	Function = function(callback)
		if callback then
			StorageESP:Clean(collectionService:GetInstanceAddedSignal('chest'):Connect(Added))
			for _, v in collectionService:GetTagged('chest') do
				task.spawn(Added, v)
			end
		else
			table.clear(Reference)
			Folder:ClearAllChildren()
		end
	end,
	Tooltip = 'Displays items in chests'
})
List = StorageESP:CreateTextList({
	Name = 'Item',
	Function = function()
		for _, v in Reference do
			task.spawn(refreshAdornee, v)
		end
	end
})
Background = StorageESP:CreateToggle({
	Name = 'Background',
	Function = function(callback)
		if Color.Object then Color.Object.Visible = callback end
		for _, v in Reference do
			v.Frame.BackgroundTransparency = 1 - (callback and Color.Opacity or 0)
			v.Blur.Visible = callback
		end
	end,
	Default = true
})
Color = StorageESP:CreateColorSlider({
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