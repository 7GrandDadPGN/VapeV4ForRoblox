local ComputerESP
local FillColor
local OutlineColor
local FillTransparency
local OutlineTransparency
local Reference = {}
local Folder = Instance.new('Folder')
Folder.Parent = vape.gui

local function Added(computer)
	local screen = computer:FindFirstChild('Screen')
	local cham = Instance.new('Highlight')
	cham.Adornee = computer
	cham.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	cham.FillColor = Color3.fromHSV(FillColor.Hue, FillColor.Sat, FillColor.Value)
	cham.OutlineColor = Color3.fromHSV(OutlineColor.Hue, OutlineColor.Sat, OutlineColor.Value)
	cham.FillTransparency = FillTransparency.Value
	cham.OutlineTransparency = OutlineTransparency.Value
	cham.Parent = Folder
	cham.Enabled = screen.Color ~= Color3.fromRGB(40, 127, 71)

	ComputerESP:Clean(screen:GetPropertyChangedSignal('Color'):Connect(function()
		cham.Enabled = screen.Color ~= Color3.fromRGB(40, 127, 71)
	end))

	Reference[computer] = cham
end

local function Removed(computer)
	if Reference[computer] then
		if vape.ThreadFix then
			setthreadidentity(8)
		end

		Reference[computer]:Destroy()
		Reference[computer] = nil
	end
end

local function MapAdded(map)
	local status = replicatedStorage.GameStatus
	if status.Value:find('LOADING') or status.Value:find('START') then
		repeat
			task.wait()
		until not (status.Value:find('LOADING') or status.Value:find('START')) or not ComputerESP.Enabled

		if not ComputerESP.Enabled then
			return
		end
	end

	for _, v in map:GetChildren() do
		if v.Name == 'ComputerTable' then
			task.spawn(Added, v)
		end
	end
end

ComputerESP = vape.Categories.Render:CreateModule({
	Name = 'ComputerESP',
	Function = function(callback)
		if callback then
			ComputerESP:Clean(vapeEvents.MapAdded.Event:Connect(MapAdded))
			ComputerESP:Clean(vapeEvents.MapRemoved.Event:Connect(function()
				for _, v in Reference do
					v:Destroy()
				end
				table.clear(Reference)
			end))

			if mapobj then
				task.spawn(MapAdded, mapobj)
			end
		else
			for _, v in Reference do
				v:Destroy()
			end
			table.clear(Reference)
		end
	end,
	Tooltip = 'Show nearby uncompleted computers.'
})
FillColor = ComputerESP:CreateColorSlider({
	Name = 'Color',
	Function = function(hue, sat, val)
		for _, v in Reference do
			v.FillColor = Color3.fromHSV(hue, sat, val)
		end
	end
})
OutlineColor = ComputerESP:CreateColorSlider({
	Name = 'Outline Color',
	DefaultSat = 0,
	Function = function(hue, sat, val)
		for _, v in Reference do
			v.OutlineColor = Color3.fromHSV(hue, sat, val)
		end
	end
})
FillTransparency = ComputerESP:CreateSlider({
	Name = 'Transparency',
	Min = 0,
	Max = 1,
	Default = 0.5,
	Function = function(val)
		for _, v in Reference do
			v.FillTransparency = val
		end
	end,
	Decimal = 10
})
OutlineTransparency = ComputerESP:CreateSlider({
	Name = 'Outline Transparency',
	Min = 0,
	Max = 1,
	Default = 0.5,
	Function = function(val)
		for _, v in Reference do
			v.OutlineTransparency = val
		end
	end,
	Decimal = 10
})