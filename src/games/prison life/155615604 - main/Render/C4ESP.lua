local C4ESP
local FillColor
local OutlineColor
local FillTransparency
local OutlineTransparency
local Reference = {}
local Folder = Instance.new('Folder')
Folder.Parent = vape.gui

local function Added(obj)
	local cham = Instance.new('Highlight')
	cham.Adornee = obj
	cham.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	cham.FillColor = Color3.fromHSV(FillColor.Hue, FillColor.Sat, FillColor.Value)
	cham.OutlineColor = Color3.fromHSV(OutlineColor.Hue, OutlineColor.Sat, OutlineColor.Value)
	cham.FillTransparency = FillTransparency.Value
	cham.OutlineTransparency = OutlineTransparency.Value
	cham.Parent = Folder

	Reference[obj] = cham
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

C4ESP = vape.Categories.Render:CreateModule({
	Name = 'C4ESP',
	Function = function(callback)
		if callback then
			C4ESP:Clean(collectionService:GetInstanceAddedSignal('C4'):Connect(Added))
			C4ESP:Clean(collectionService:GetInstanceRemovedSignal('C4'):Connect(Removed))

			for _, obj in collectionService:GetTagged('C4') do
				task.spawn(Added, obj)
			end
		else
			for _, v in Reference do
				v:Destroy()
			end
			table.clear(Reference)
		end
	end,
	Tooltip = 'Display all C4\'s placed'
})
FillColor = C4ESP:CreateColorSlider({
	Name = 'Color',
	Function = function(hue, sat, val)
		for _, v in Reference do
			v.FillColor = Color3.fromHSV(hue, sat, val)
		end
	end
})
OutlineColor = C4ESP:CreateColorSlider({
	Name = 'Outline Color',
	DefaultSat = 0,
	Function = function(hue, sat, val)
		for _, v in Reference do
			v.OutlineColor = Color3.fromHSV(hue, sat, val)
		end
	end
})
FillTransparency = C4ESP:CreateSlider({
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
OutlineTransparency = C4ESP:CreateSlider({
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