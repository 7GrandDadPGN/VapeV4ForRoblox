local Tracers
local Targets
local Color
local Transparency
local StartPosition
local EndPosition
local Teammates
local DistanceColor
local Distance
local DistanceLimit
local Behind
local Reference = {}

local function Added(ent)
	if not Targets.Players.Enabled and ent.Player then return end
	if not Targets.NPCs.Enabled and ent.NPC then return end
	if Teammates.Enabled and (not ent.Targetable) and (not ent.Friend) then return end
	if vape.ThreadFix then
		setthreadidentity(8)
	end

	local EntityTracer = Drawing.new('Line')
	EntityTracer.Thickness = 1
	EntityTracer.Transparency = 1 - Transparency.Value
	EntityTracer.Color = entitylib.getEntityColor(ent) or Color3.fromHSV(Color.Hue, Color.Sat, Color.Value)
	Reference[ent] = EntityTracer
end

local function Removed(ent)
	local v = Reference[ent]
	if v then
		if vape.ThreadFix then
			setthreadidentity(8)
		end
		Reference[ent] = nil
		pcall(function()
			v.Visible = false
			v:Remove()
		end)
	end
end

local function ColorFunc(hue, sat, val)
	if DistanceColor.Enabled then return end
	local tracerColor = Color3.fromHSV(hue, sat, val)
	for ent, EntityTracer in Reference do
		EntityTracer.Color = entitylib.getEntityColor(ent) or tracerColor
	end
end

local function Loop()
	local screenSize = vape.gui.AbsoluteSize
	local startVector = StartPosition.Value == 'Mouse' and inputService:GetMouseLocation() or Vector2.new(screenSize.X / 2, (StartPosition.Value == 'Middle' and screenSize.Y / 2 or screenSize.Y))

	for ent, EntityTracer in Reference do
		local distance = entitylib.isAlive and (entitylib.character.RootPart.Position - ent.RootPart.Position).Magnitude
		if Distance.Enabled and distance then
			if distance < DistanceLimit.ValueMin or distance > DistanceLimit.ValueMax then
				EntityTracer.Visible = false
				continue
			end
		end

		local pos = ent[EndPosition.Value == 'Torso' and 'RootPart' or 'Head'].Position
		local rootPos, rootVis = gameCamera:WorldToViewportPoint(pos)
		if not rootVis and Behind.Enabled then
			local tempPos = gameCamera.CFrame:PointToObjectSpace(pos)
			tempPos = CFrame.Angles(0, 0, (math.atan2(tempPos.Y, tempPos.X) + math.pi)):VectorToWorldSpace((CFrame.Angles(0, math.rad(89.9), 0):VectorToWorldSpace(Vector3.new(0, 0, -1))))
			rootPos = gameCamera:WorldToViewportPoint(gameCamera.CFrame:pointToWorldSpace(tempPos))
			rootVis = true
		end

		local endVector = Vector2.new(rootPos.X, rootPos.Y)
		EntityTracer.Visible = rootVis
		EntityTracer.From = startVector
		EntityTracer.To = endVector
		if DistanceColor.Enabled and distance then
			EntityTracer.Color = Color3.fromHSV(math.min((distance / 128) / 2.8, 0.4), 0.89, 0.75)
		end
	end
end

Tracers = vape.Categories.Render:CreateModule({
	Name = 'Tracers',
	Function = function(callback)
		if callback then
			Tracers:Clean(entitylib.Events.EntityRemoved:Connect(Removed))
			for _, v in entitylib.List do
				if Reference[v] then
					Removed(v)
				end
				Added(v)
			end
			Tracers:Clean(entitylib.Events.EntityAdded:Connect(function(ent)
				if Reference[ent] then
					Removed(ent)
				end
				Added(ent)
			end))
			Tracers:Clean(vape.Categories.Friends.ColorUpdate.Event:Connect(function()
				ColorFunc(Color.Hue, Color.Sat, Color.Value)
			end))
			Tracers:Clean(runService.RenderStepped:Connect(Loop))
		else
			for i in Reference do
				Removed(i)
			end
		end
	end,
	Tooltip = 'Renders tracers on players.'
})
Targets = Tracers:CreateTargets({
	Players = true,
	Function = function()
		if Tracers.Enabled then
			Tracers:Toggle()
			Tracers:Toggle()
		end
	end
})
StartPosition = Tracers:CreateDropdown({
	Name = 'Start Position',
	List = {'Middle', 'Bottom', 'Mouse'},
	Function = function()
		if Tracers.Enabled then
			Tracers:Toggle()
			Tracers:Toggle()
		end
	end
})
EndPosition = Tracers:CreateDropdown({
	Name = 'End Position',
	List = {'Head', 'Torso'},
	Function = function()
		if Tracers.Enabled then
			Tracers:Toggle()
			Tracers:Toggle()
		end
	end
})
Color = Tracers:CreateColorSlider({
	Name = 'Player Color',
	Function = function(hue, sat, val)
		if Tracers.Enabled then
			ColorFunc(hue, sat, val)
		end
	end
})
Transparency = Tracers:CreateSlider({
	Name = 'Transparency',
	Min = 0,
	Max = 1,
	Function = function(val)
		for _, tracer in Reference do
			tracer.Transparency = 1 - val
		end
	end,
	Decimal = 10
})
DistanceColor = Tracers:CreateToggle({
	Name = 'Color by distance',
	Function = function()
		if Tracers.Enabled then
			Tracers:Toggle()
			Tracers:Toggle()
		end
	end
})
Distance = Tracers:CreateToggle({
	Name = 'Distance Check',
	Function = function(callback)
		DistanceLimit.Object.Visible = callback
	end
})
DistanceLimit = Tracers:CreateTwoSlider({
	Name = 'Player Distance',
	Min = 0,
	Max = 256,
	DefaultMin = 0,
	DefaultMax = 64,
	Darker = true,
	Visible = false
})
Behind = Tracers:CreateToggle({
	Name = 'Behind',
	Default = true
})
Teammates = Tracers:CreateToggle({
	Name = 'Priority Only',
	Function = function()
		if Tracers.Enabled then
			Tracers:Toggle()
			Tracers:Toggle()
		end
	end,
	Default = true,
	Tooltip = 'Hides teammates & non targetable entities'
})