local Arrows
local Targets
local Color
local Teammates
local Distance
local DistanceLimit
local Reference = {}
local Folder = Instance.new('Folder')
Folder.Parent = vape.gui

local function Added(entity)
	if not Targets.Players.Enabled and entity.Player then return end
	if not Targets.NPCs.Enabled and entity.NPC then return end
	if Teammates.Enabled and (not entity.Targetable) and (not entity.Friend) and (not entity.Friend) then return end
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
	arrow.Image = getvapeasset('newvape/assets/new/arrow.png')
	arrow.ImageColor3 = entitylib.getEntityColor(entity) or Color3.fromHSV(Color.Hue, Color.Sat, Color.Value)
	arrow.Parent = Folder
	Reference[entity] = arrow
end

local function Removed(entity)
	local enty = Reference[entity]
	if entry then
		if vape.ThreadFix then
			setthreadidentity(8)
		end

		Reference[entity] = nil
		entry:Destroy()
	end
end

local function ColorFunc(hue, sat, val)
	local color = Color3.fromHSV(hue, sat, val)
	for entity, entry in Reference do
		entry.ImageColor3 = entitylib.getEntityColor(entity) or color
	end
end

local function Loop()
	for entity, entry in Reference do
		if Distance.Enabled then
			local distance = entitylib.isAlive and (entitylib.character.RootPart.Position - entity.RootPart.Position).Magnitude or math.huge
			if distance < DistanceLimit.ValueMin or distance > DistanceLimit.ValueMax then
				entry.Visible = false
				continue
			end
		end

		local _, rootVis = gameCamera:WorldToScreenPoint(entity.RootPart.Position)
		entry.Visible = not rootVis
		if rootVis then continue end

		local dir = CFrame.lookAlong(gameCamera.CFrame.Position, gameCamera.CFrame.LookVector * Vector3.new(1, 0, 1)):PointToObjectSpace(entity.RootPart.Position)
		entry.Rotation = math.deg(math.atan2(dir.Z, dir.X))
	end
end

Arrows = vape.Categories.Render:CreateModule({
	Name = 'Arrows',
	Function = function(callback)
		if callback then
			Arrows:Clean(entitylib.Events.EntityRemoved:Connect(Removed))
			for _, entity in entitylib.List do
				if Reference[entity] then Removed(entity) end
				Added(entity)
			end
			Arrows:Clean(entitylib.Events.EntityAdded:Connect(function(entity)
				if Reference[entity] then Removed(entity) end
				Added(entity)
			end))
			Arrows:Clean(vape.Categories.Friends.ColorUpdate.Event:Connect(function()
				ColorFunc(Color.Hue, Color.Sat, Color.Value)
			end))
			Arrows:Clean(runService.RenderStepped:Connect(Loop))
		else
			for entity in Reference do
				Removed(entity)
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