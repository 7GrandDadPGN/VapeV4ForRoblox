local C4ESP
local FillColor
local OutlineColor
local FillTransparency
local OutlineTransparency
local Reference = {}
local Folder = Instance.new('Folder')
Folder.Parent = vape.holder

local function Added(c4)
	local cham = Instance.new('Highlight')
	cham.Adornee = c4
	cham.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	cham.FillColor = Color3.fromHSV(FillColor.Hue, FillColor.Sat, FillColor.Value)
	cham.OutlineColor = Color3.fromHSV(OutlineColor.Hue, OutlineColor.Sat, OutlineColor.Value)
	cham.FillTransparency = FillTransparency.Value
	cham.OutlineTransparency = OutlineTransparency.Value
	cham.Parent = Folder

	Reference[c4] = cham
end

local function Removed(c4)
	if Reference[c4] then
		if vape.ThreadFix then
			setthreadidentity(8)
		end

		Reference[c4]:Destroy()
		Reference[c4] = nil
	end
end

C4ESP = vape.Categories.Render:CreateModule({
	Name = 'C4ESP',
	Function = function(callback)
		if callback then
			C4ESP:Clean(collectionService:GetInstanceAddedSignal('C4'):Connect(Added))
			C4ESP:Clean(collectionService:GetInstanceRemovedSignal('C4'):Connect(Removed))

			for _, c4 in collectionService:GetTagged('C4') do
				task.spawn(Added, c4)
			end
		else
			for _, cham in Reference do
				cham:Destroy()
			end
			table.clear(Reference)
		end
	end,
	Tooltip = 'Display all C4\'s placed'
})
FillColor = C4ESP:CreateColorSlider({
	Name = 'Color',
	Function = function(hue, sat, val)
		for _, cham in Reference do
			cham.FillColor = Color3.fromHSV(hue, sat, val)
		end
	end
})
OutlineColor = C4ESP:CreateColorSlider({
	Name = 'Outline Color',
	DefaultSat = 0,
	Function = function(hue, sat, val)
		for _, cham in Reference do
			cham.OutlineColor = Color3.fromHSV(hue, sat, val)
		end
	end
})
FillTransparency = C4ESP:CreateSlider({
	Name = 'Transparency',
	Min = 0,
	Max = 1,
	Default = 0.5,
	Function = function(val)
		for _, cham in Reference do
			cham.FillTransparency = val
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
		for _, cham in Reference do
			cham.OutlineTransparency = val
		end
	end,
	Decimal = 10
})