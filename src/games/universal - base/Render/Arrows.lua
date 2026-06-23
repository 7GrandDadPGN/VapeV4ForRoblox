local Arrows
local Targets
local Color
local Teammates
local Distance
local DistanceLimit
local Reference = {}
local Folder = Instance.new('Folder')
Folder.Parent = vape.gui

local function Added(ent)
	if not Targets.Players.Enabled and ent.Player then return end
	if not Targets.NPCs.Enabled and ent.NPC then return end
	if Teammates.Enabled and (not ent.Targetable) and (not ent.Friend) and (not ent.Friend) then return end
	if vape.ThreadFix then
		setthreadidentity(8)
	end

	local arrow = Instance.new('ImageLabel')
	arrow.Size = UDim2.fromOffset(256, 256)
	arrow.Position = UDim2.fromScale(0.5, 0.5)
	arrow.AnchorPoint = Vector2.new(0.5, 0.5)
	arrow.BackgroundTransparency = 1
	arrow.BorderSizePixel = 0
	arrow.Visible = false
	arrow.Image = getcustomasset('newvape/assets/new/arrowmodule.png')
	arrow.ImageColor3 = entitylib.getEntityColor(ent) or Color3.fromHSV(Color.Hue, Color.Sat, Color.Value)
	arrow.Parent = Folder
	Reference[ent] = arrow
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

local function ColorFunc(hue, sat, val)
	local color = Color3.fromHSV(hue, sat, val)
	for ent, EntityArrow in Reference do
		EntityArrow.ImageColor3 = entitylib.getEntityColor(ent) or color
	end
end

local function Loop()
	for ent, arrow in Reference do
		if Distance.Enabled then
			local distance = entitylib.isAlive and (entitylib.character.RootPart.Position - ent.RootPart.Position).Magnitude or math.huge
			if distance < DistanceLimit.ValueMin or distance > DistanceLimit.ValueMax then
				arrow.Visible = false
				continue
			end
		end

		local _, rootVis = gameCamera:WorldToScreenPoint(ent.RootPart.Position)
		arrow.Visible = not rootVis
		if rootVis then continue end

		local dir = CFrame.lookAlong(gameCamera.CFrame.Position, gameCamera.CFrame.LookVector * Vector3.new(1, 0, 1)):PointToObjectSpace(ent.RootPart.Position)
		arrow.Rotation = math.deg(math.atan2(dir.Z, dir.X))
	end
end

Arrows = vape.Categories.Render:CreateModule({
	Name = 'Arrows',
	Function = function(callback)
		if callback then
			Arrows:Clean(entitylib.Events.EntityRemoved:Connect(Removed))
			for _, v in entitylib.List do
				if Reference[v] then Removed(v) end
				Added(v)
			end
			Arrows:Clean(entitylib.Events.EntityAdded:Connect(function(ent)
				if Reference[ent] then Removed(ent) end
				Added(ent)
			end))
			Arrows:Clean(vape.Categories.Friends.ColorUpdate.Event:Connect(function()
				ColorFunc(Color.Hue, Color.Sat, Color.Value)
			end))
			Arrows:Clean(runService.RenderStepped:Connect(Loop))
		else
			for i in Reference do
				Removed(i)
			end
		end
	end,
	Tooltip = 'Draws arrows on screen when entities\nare out of your field of view.'
})
Targets = Arrows:CreateTargets({
	Players = true,
	Function = function()
		if Arrows.Enabled then
			Arrows:Toggle()
			Arrows:Toggle()
		end
	end
})
Color = Arrows:CreateColorSlider({
	Name = 'Player Color',
	Function = function(hue, sat, val)
		if Arrows.Enabled then
			ColorFunc(hue, sat, val)
		end
	end,
})
Teammates = Arrows:CreateToggle({
	Name = 'Priority Only',
	Function = function()
		if Arrows.Enabled then
			Arrows:Toggle()
			Arrows:Toggle()
		end
	end,
	Default = true,
	Tooltip = 'Hides teammates & non targetable entities'
})
Distance = Arrows:CreateToggle({
	Name = 'Distance Check',
	Function = function(callback)
		DistanceLimit.Object.Visible = callback
	end
})
DistanceLimit = Arrows:CreateTwoSlider({
	Name = 'Player Distance',
	Min = 0,
	Max = 256,
	DefaultMin = 0,
	DefaultMax = 64,
	Darker = true,
	Visible = false
})