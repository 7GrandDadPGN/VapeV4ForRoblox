local Chams
local Targets
local Mode
local FillColor
local OutlineColor
local FillTransparency
local OutlineTransparency
local Teammates
local Walls
local Reference = {}
local Folder = Instance.new('Folder')
Folder.Parent = vape.gui

local function Added(ent)
	if not Targets.Players.Enabled and ent.Player then return end
	if not Targets.NPCs.Enabled and ent.NPC then return end
	if Teammates.Enabled and (not ent.Targetable) and (not ent.Friend) then return end
	if vape.ThreadFix then
		setthreadidentity(8)
	end

	if Mode.Value == 'Highlight' then
		local cham = Instance.new('Highlight')
		cham.Adornee = ent.Character
		cham.DepthMode = Enum.HighlightDepthMode[Walls.Enabled and 'AlwaysOnTop' or 'Occluded']
		cham.FillColor = entitylib.getEntityColor(ent) or Color3.fromHSV(FillColor.Hue, FillColor.Sat, FillColor.Value)
		cham.OutlineColor = Color3.fromHSV(OutlineColor.Hue, OutlineColor.Sat, OutlineColor.Value)
		cham.FillTransparency = FillTransparency.Value
		cham.OutlineTransparency = OutlineTransparency.Value
		cham.Parent = Folder
		Reference[ent] = cham
	else
		local chams = {}
		for _, v in ent.Character:GetChildren() do
			if v:IsA('BasePart') and (ent.NPC or v.Name:find('Arm') or v.Name:find('Leg') or v.Name:find('Hand') or v.Name:find('Feet') or v.Name:find('Torso') or v.Name == 'Head') then
				local box = Instance.new(v.Name == 'Head' and 'SphereHandleAdornment' or 'BoxHandleAdornment')
				if v.Name == 'Head' then
					box.Radius = 0.75
				else
					box.Size = v.Size
				end
				box.AlwaysOnTop = Walls.Enabled
				box.Adornee = v
				box.ZIndex = 0
				box.Transparency = FillTransparency.Value
				box.Color3 = entitylib.getEntityColor(ent) or Color3.fromHSV(FillColor.Hue, FillColor.Sat, FillColor.Value)
				box.Parent = Folder
				table.insert(chams, box)
			end
		end
		Reference[ent] = chams
	end
end

local function Removed(ent)
	if Reference[ent] then
		if vape.ThreadFix then
			setthreadidentity(8)
		end
		if type(Reference[ent]) == 'table' then
			for _, v in Reference[ent] do
				v:Destroy()
			end
			table.clear(Reference[ent])
		else
			Reference[ent]:Destroy()
		end
		Reference[ent] = nil
	end
end

Chams = vape.Categories.Render:CreateModule({
	Name = 'Chams',
	Function = function(callback)
		if callback then
			Chams:Clean(entitylib.Events.EntityRemoved:Connect(Removed))
			Chams:Clean(entitylib.Events.EntityAdded:Connect(function(ent)
				if Reference[ent] then
					Removed(ent)
				end
				Added(ent)
			end))
			Chams:Clean(vape.Categories.Friends.ColorUpdate.Event:Connect(function()
				for i, v in Reference do
					local color = entitylib.getEntityColor(i) or Color3.fromHSV(FillColor.Hue, FillColor.Sat, FillColor.Value)
					if type(v) == 'table' then
						for _, v2 in v do v2.Color3 = color end
					else
						v.FillColor = color
					end
				end
			end))

			for _, v in entitylib.List do
				if Reference[v] then
					Removed(v)
				end
				Added(v)
			end
		else
			for i in Reference do
				Removed(i)
			end
		end
	end,
	Tooltip = 'Render players through walls'
})
Targets = Chams:CreateTargets({
	Players = true,
	Function = function()
		if Chams.Enabled then
			Chams:Toggle()
			Chams:Toggle()
		end
	end
	})
Mode = Chams:CreateDropdown({
	Name = 'Mode',
	List = {'Highlight', 'BoxHandles'},
	Function = function(val)
		OutlineColor.Object.Visible = val == 'Highlight'
		OutlineTransparency.Object.Visible = val == 'Highlight'
		if Chams.Enabled then
			Chams:Toggle()
			Chams:Toggle()
		end
	end
})
FillColor = Chams:CreateColorSlider({
	Name = 'Color',
	Function = function(hue, sat, val)
		for i, v in Reference do
			local color = entitylib.getEntityColor(i) or Color3.fromHSV(hue, sat, val)
			if type(v) == 'table' then
				for _, v2 in v do v2.Color3 = color end
			else
				v.FillColor = color
			end
		end
	end
})
OutlineColor = Chams:CreateColorSlider({
	Name = 'Outline Color',
	DefaultSat = 0,
	Function = function(hue, sat, val)
		for i, v in Reference do
			if type(v) ~= 'table' then
				v.OutlineColor = Color3.fromHSV(hue, sat, val)
			end
		end
	end,
	Darker = true
})
FillTransparency = Chams:CreateSlider({
	Name = 'Transparency',
	Min = 0,
	Max = 1,
	Default = 0.5,
	Function = function(val)
		for _, v in Reference do
			if type(v) == 'table' then
				for _, v2 in v do v2.Transparency = val end
			else
				v.FillTransparency = val
			end
		end
	end,
	Decimal = 10
})
OutlineTransparency = Chams:CreateSlider({
	Name = 'Outline Transparency',
	Min = 0,
	Max = 1,
	Default = 0.5,
	Function = function(val)
		for _, v in Reference do
			if type(v) ~= 'table' then
				v.OutlineTransparency = val
			end
		end
	end,
	Decimal = 10,
	Darker = true
})
Walls = Chams:CreateToggle({
	Name = 'Render Walls',
	Function = function(callback)
		for _, v in Reference do
			if type(v) == 'table' then
				for _, v2 in v do
					v2.AlwaysOnTop = callback
				end
			else
				v.DepthMode = Enum.HighlightDepthMode[callback and 'AlwaysOnTop' or 'Occluded']
			end
		end
	end,
	Default = true
})
Teammates = Chams:CreateToggle({
	Name = 'Priority Only',
	Function = function()
		if Chams.Enabled then
			Chams:Toggle()
			Chams:Toggle()
		end
	end,
	Default = true,
	Tooltip = 'Hides teammates & non targetable entities'
})