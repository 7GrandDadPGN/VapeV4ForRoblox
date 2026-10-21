local TrapESP
local FillColor
local OutlineColor
local FillTransparency
local OutlineTransparency
local Walls
local Reference = {}
local Folder = Instance.new('Folder')
Folder.Parent = vape.holder
local Frame

local function Added(obj)
	if vape.ThreadFix then
		setthreadidentity(8)
	end

	if obj:GetAttribute('Team') == lplr:GetAttribute('Team') then
		return
	end

	local box = Instance.new('BoxHandleAdornment')
	box.AlwaysOnTop = Walls.Enabled
	box.Adornee = obj
	box.Size = Vector3.new(3, 1, 3)
	box.ZIndex = 0
	box.Transparency = FillTransparency.Value
	box.Color3 = Color3.fromHSV(FillColor.Hue, FillColor.Sat, FillColor.Value)
	box.Parent = Folder
	Reference[obj] = box
end

local function Removed(obj)
	if Reference[obj] then
		if vape.ThreadFix then
			setthreadidentity(8)
		end

		Reference[obj]:Destroy()
		Reference[obj] = nil
	end
end

TrapESP = vape.Categories.Render:CreateModule({
	Name = 'TrapESP',
	Function = function(callback)
		if callback then
			TrapESP:Clean(collectionService:GetInstanceAddedSignal('BearTrap'):Connect(Added))
			TrapESP:Clean(collectionService:GetInstanceRemovedSignal('BearTrap'):Connect(Removed))

			for _, obj in collectionService:GetTagged('BearTrap') do
				task.spawn(Added, obj)
			end
		else
			Folder:ClearAllChildren()
			table.clear(Reference)
		end
	end,
	Tooltip = 'Render traps through walls'
})
FillColor = TrapESP:CreateColorSlider({
	Name = 'Color',
	Function = function(hue, sat, val)
		for _, entry in Reference do
			local color = Color3.fromHSV(hue, sat, val)
			entry.Color3 = color
		end
	end
})
FillTransparency = TrapESP:CreateSlider({
	Name = 'Transparency',
	Min = 0,
	Max = 1,
	Default = 0.5,
	Function = function(val)
		for _, entry in Reference do
			entry.Transparency = val
		end
	end,
	Decimal = 10
})
Walls = TrapESP:CreateToggle({
	Name = 'Render Walls',
	Function = function(callback)
		for _, entry in Reference do
			entry.AlwaysOnTop = callback
		end
	end,
	Default = true
})