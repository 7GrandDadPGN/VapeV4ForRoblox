local PickupTracers
local Color
local Transparency
local Bux
local Reference = {}

local function Added(ent)
	if vape.ThreadFix then
		setthreadidentity(8)
	end

	if Bux.Enabled and ent.Name ~= 'BUX' then
		return
	end

	local EntityTracer = Drawing.new('Line')
	EntityTracer.Thickness = 1
	EntityTracer.Transparency = 1 - Transparency.Value
	EntityTracer.Color = Color3.fromHSV(Color.Hue, Color.Sat, Color.Value)
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
	local tracerColor = Color3.fromHSV(hue, sat, val)
	for ent, EntityTracer in Reference do
		EntityTracer.Color = tracerColor
	end
end

local function Loop()
	local screenSize = vape.gui.AbsoluteSize
	local startVector = Vector2.new(screenSize.X / 2, screenSize.Y / 2)

	for ent, EntityTracer in Reference do
		if ent:GetAttribute('Inactive') then
			EntityTracer.Visible = false
			continue
		end

		local pos = ent.Position
		local rootPos, rootVis = gameCamera:WorldToViewportPoint(pos)

		if not rootVis then
			local tempPos = gameCamera.CFrame:PointToObjectSpace(pos)
			tempPos = CFrame.Angles(0, 0, (math.atan2(tempPos.Y, tempPos.X) + math.pi)):VectorToWorldSpace((CFrame.Angles(0, math.rad(89.9), 0):VectorToWorldSpace(Vector3.new(0, 0, -1))))
			rootPos = gameCamera:WorldToViewportPoint(gameCamera.CFrame:pointToWorldSpace(tempPos))
			rootVis = true
		end

		local endVector = Vector2.new(rootPos.X, rootPos.Y)
		EntityTracer.Visible = rootVis
		EntityTracer.From = startVector
		EntityTracer.To = endVector
	end
end

PickupTracers = vape.Categories.Render:CreateModule({
	Name = 'PickupTracers',
	Function = function(callback)
		if callback then
			PickupTracers:Clean(collectionService:GetInstanceAddedSignal('Pickup'):Connect(function(ent)
				if Reference[ent] then
					Removed(ent)
				end
				Added(ent)
			end))
			PickupTracers:Clean(collectionService:GetInstanceRemovedSignal('Pickup'):Connect(Removed))
			for _, v in collectionService:GetTagged('Pickup') do
				if Reference[v] then
					Removed(v)
				end
				Added(v)
			end
			PickupTracers:Clean(runService.RenderStepped:Connect(Loop))
		else
			for i in Reference do
				Removed(i)
			end
		end
	end,
	Tooltip = 'Renders tracers on pickups.'
})
Color = PickupTracers:CreateColorSlider({
	Name = 'BUX Color',
	Function = function(hue, sat, val)
		if PickupTracers.Enabled then
			ColorFunc(hue, sat, val)
		end
	end
})
Transparency = PickupTracers:CreateSlider({
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
Bux = PickupTracers:CreateToggle({
	Name = 'Bux Only',
	Function = function()
		if PickupTracers.Enabled then
			PickupTracers:Toggle()
			PickupTracers:Toggle()
		end
	end,
	Tooltip = 'Hides non BUX pickups'
})