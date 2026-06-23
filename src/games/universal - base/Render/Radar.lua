local Radar
local Targets
local DotStyle
local PlayerColor
local Clamp
local Reference = {}
local bkg

local function Added(ent)
	if not Targets.Players.Enabled and ent.Player then return end
	if not Targets.NPCs.Enabled and ent.NPC then return end
	if (not ent.Targetable) and (not ent.Friend) then return end
	if vape.ThreadFix then
		setthreadidentity(8)
	end

	local dot = Instance.new('Frame')
	dot.Size = UDim2.fromOffset(4, 4)
	dot.AnchorPoint = Vector2.new(0.5, 0.5)
	dot.BackgroundColor3 = entitylib.getEntityColor(ent) or Color3.fromHSV(PlayerColor.Hue, PlayerColor.Sat, PlayerColor.Value)
	dot.Parent = bkg
	local corner = Instance.new('UICorner')
	corner.CornerRadius = UDim.new(DotStyle.Value == 'Circles' and 1 or 0, 0)
	corner.Parent = dot
	local stroke = Instance.new('UIStroke')
	stroke.Color = Color3.new()
	stroke.Thickness = 1
	stroke.Transparency = 0.8
	stroke.Parent = dot
	Reference[ent] = dot
end

local function Removed(ent)
	local v = Reference[ent]
	if v then
		if vape.ThreadFix then
			setthreadidentity(8)
		end
		Reference[ent] = nil
		v:Destroy()
	end
end

Radar = vape:CreateOverlay({
	Name = 'Radar',
	Icon = getcustomasset('newvape/assets/new/radaricon.png'),
	Size = UDim2.fromOffset(14, 14),
	Position = UDim2.fromOffset(12, 13),
	Function = function(callback)
		if callback then
			Radar:Clean(entitylib.Events.EntityRemoved:Connect(Removed))
			for _, v in entitylib.List do
				if Reference[v] then
					Removed(v)
				end
				Added(v)
			end
			Radar:Clean(entitylib.Events.EntityAdded:Connect(function(ent)
				if Reference[ent] then
					Removed(ent)
				end
				Added(ent)
			end))
			Radar:Clean(vape.Categories.Friends.ColorUpdate.Event:Connect(function()
				for ent, dot in Reference do
					dot.BackgroundColor3 = entitylib.getEntityColor(ent) or Color3.fromHSV(PlayerColor.Hue, PlayerColor.Sat, PlayerColor.Value)
				end
			end))
			Radar:Clean(runService.RenderStepped:Connect(function()
				for ent, dot in Reference do
					if entitylib.isAlive then
						local dt = CFrame.lookAlong(entitylib.character.RootPart.Position, gameCamera.CFrame.LookVector * Vector3.new(1, 0, 1)):PointToObjectSpace(ent.RootPart.Position)
						dot.Position = UDim2.fromOffset(Clamp.Enabled and math.clamp(108 + dt.X, 2, 214) or 108 + dt.X, Clamp.Enabled and math.clamp(108 + dt.Z, 8, 214) or 108 + dt.Z)
					end
				end
			end))
		else
			for ent in Reference do
				Removed(ent)
			end
		end
	end
})
Targets = Radar:CreateTargets({
	Players = true,
	Function = function()
		if Radar.Button.Enabled then
			Radar.Button:Toggle()
			Radar.Button:Toggle()
		end
	end
})
DotStyle = Radar:CreateDropdown({
	Name = 'Dot Style',
	List = {'Circles', 'Squares'},
	Function = function(val)
		for _, dot in Reference do
			dot.UICorner.CornerRadius = UDim.new(val == 'Circles' and 1 or 0, 0)
		end
	end
})
PlayerColor = Radar:CreateColorSlider({
	Name = 'Player Color',
	Function = function(hue, sat, val)
		for ent, dot in Reference do
			dot.BackgroundColor3 = entitylib.getEntityColor(ent) or Color3.fromHSV(hue, sat, val)
		end
	end
})
bkg = Instance.new('Frame')
bkg.Size = UDim2.fromOffset(216, 216)
bkg.Position = UDim2.fromOffset(2, 2)
bkg.BackgroundColor3 = Color3.new()
bkg.BackgroundTransparency = 0.5
bkg.ClipsDescendants = true
bkg.Parent = Radar.Children
local corner = Instance.new('UICorner')
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = bkg
local stroke = Instance.new('UIStroke')
stroke.Thickness = 2
stroke.Color = Color3.new()
stroke.Transparency = 0.4
stroke.Parent = bkg
local line1 = Instance.new('Frame')
line1.Size = UDim2.new(0, 2, 1, 0)
line1.Position = UDim2.fromScale(0.5, 0.5)
line1.AnchorPoint = Vector2.new(0.5, 0.5)
line1.ZIndex = 0
line1.BackgroundColor3 = Color3.new(1, 1, 1)
line1.BackgroundTransparency = 0.5
line1.BorderSizePixel = 0
line1.Parent = bkg
local line2 = line1:Clone()
line2.Size = UDim2.new(1, 0, 0, 2)
line2.Parent = bkg
local bar = Instance.new('Frame')
bar.Size = UDim2.new(1, -6, 0, 4)
bar.Position = UDim2.fromOffset(3, 0)
bar.BackgroundColor3 = Color3.fromHSV(0.44, 1, 1)
bar.Parent = bkg
local barcorner = Instance.new('UICorner')
barcorner.CornerRadius = UDim.new(0, 8)
barcorner.Parent = bar
Radar:CreateColorSlider({
	Name = 'Bar Color',
	Function = function(hue, sat, val)
		bar.BackgroundColor3 = Color3.fromHSV(hue, sat, val)
	end
})
Radar:CreateToggle({
	Name = 'Show Background',
	Default = true,
	Function = function(callback)
		bkg.BackgroundTransparency = callback and 0.5 or 1
		bar.BackgroundTransparency = callback and 0 or 1
		stroke.Transparency = callback and 0.4 or 1
	end
})
Radar:CreateToggle({
	Name = 'Show Cross',
	Default = true,
	Function = function(callback)
		line1.BackgroundTransparency = callback and 0.5 or 1
		line2.BackgroundTransparency = callback and 0.5 or 1
	end
})
Clamp = Radar:CreateToggle({
	Name = 'Clamp Radar',
	Default = true
})