local ESP
local Targets
local Color
local Method
local BoundingBox
local Filled
local HealthBar
local Name
local DisplayName
local Background
local Teammates
local Distance
local DistanceLimit
local Reference = {}
local methodused

local function ESPWorldToViewport(pos)
	local newpos = gameCamera:WorldToViewportPoint(gameCamera.CFrame:pointToWorldSpace(gameCamera.CFrame:PointToObjectSpace(pos)))
	return Vector2.new(newpos.X, newpos.Y)
end

local ESPAdded = {
	Drawing2D = function(entity)
		if not Targets.Players.Enabled and entity.Player then return end
		if not Targets.NPCs.Enabled and entity.NPC then return end
		if Teammates.Enabled and (not entity.Targetable) and (not entity.Friend) then return end
		if vape.ThreadFix then
			setthreadidentity(8)
		end
		local EntityESP = {}
		EntityESP.Main = Drawing.new('Square')
		EntityESP.Main.Transparency = BoundingBox.Enabled and 1 or 0
		EntityESP.Main.ZIndex = 2
		EntityESP.Main.Filled = false
		EntityESP.Main.Thickness = 1
		EntityESP.Main.Color = entitylib.getEntityColor(entity) or Color3.fromHSV(Color.Hue, Color.Sat, Color.Value)

		if BoundingBox.Enabled then
			EntityESP.Border = Drawing.new('Square')
			EntityESP.Border.Transparency = 0.35
			EntityESP.Border.ZIndex = 1
			EntityESP.Border.Thickness = 1
			EntityESP.Border.Filled = false
			EntityESP.Border.Color = Color3.new()
			EntityESP.Border2 = Drawing.new('Square')
			EntityESP.Border2.Transparency = 0.35
			EntityESP.Border2.ZIndex = 1
			EntityESP.Border2.Thickness = 1
			EntityESP.Border2.Filled = Filled.Enabled
			EntityESP.Border2.Color = Color3.new()
		end

		if HealthBar.Enabled then
			EntityESP.HealthLine = Drawing.new('Line')
			EntityESP.HealthLine.Thickness = 1
			EntityESP.HealthLine.ZIndex = 2
			EntityESP.HealthLine.Color = Color3.fromHSV(math.clamp(entity.Health / entity.MaxHealth, 0, 1) / 2.5, 0.89, 0.75)
			EntityESP.HealthBorder = Drawing.new('Line')
			EntityESP.HealthBorder.Thickness = 3
			EntityESP.HealthBorder.Transparency = 0.35
			EntityESP.HealthBorder.ZIndex = 1
			EntityESP.HealthBorder.Color = Color3.new()
		end

		if Name.Enabled then
			if Background.Enabled then
				EntityESP.TextBKG = Drawing.new('Square')
				EntityESP.TextBKG.Transparency = 0.35
				EntityESP.TextBKG.ZIndex = 0
				EntityESP.TextBKG.Thickness = 1
				EntityESP.TextBKG.Filled = true
				EntityESP.TextBKG.Color = Color3.new()
			end

			EntityESP.Drop = Drawing.new('Text')
			EntityESP.Drop.Color = Color3.new()
			EntityESP.Drop.Text = entity.Player and whitelist:tag(entity.Player, true)..(DisplayName.Enabled and entity.Player.DisplayName or entity.Player.Name) or entity.Character.Name
			EntityESP.Drop.ZIndex = 1
			EntityESP.Drop.Center = true
			EntityESP.Drop.Size = 20
			EntityESP.Text = Drawing.new('Text')
			EntityESP.Text.Text = EntityESP.Drop.Text
			EntityESP.Text.ZIndex = 2
			EntityESP.Text.Color = EntityESP.Main.Color
			EntityESP.Text.Center = true
			EntityESP.Text.Size = 20
		end

		Reference[entity] = EntityESP
	end,
	Drawing3D = function(entity)
		if not Targets.Players.Enabled and entity.Player then return end
		if not Targets.NPCs.Enabled and entity.NPC then return end
		if Teammates.Enabled and (not entity.Targetable) and (not entity.Friend) then return end
		if vape.ThreadFix then
			setthreadidentity(8)
		end

		local EntityESP = {}
		EntityESP.Line1 = Drawing.new('Line')
		EntityESP.Line2 = Drawing.new('Line')
		EntityESP.Line3 = Drawing.new('Line')
		EntityESP.Line4 = Drawing.new('Line')
		EntityESP.Line5 = Drawing.new('Line')
		EntityESP.Line6 = Drawing.new('Line')
		EntityESP.Line7 = Drawing.new('Line')
		EntityESP.Line8 = Drawing.new('Line')
		EntityESP.Line9 = Drawing.new('Line')
		EntityESP.Line10 = Drawing.new('Line')
		EntityESP.Line11 = Drawing.new('Line')
		EntityESP.Line12 = Drawing.new('Line')

		local color = entitylib.getEntityColor(entity) or Color3.fromHSV(Color.Hue, Color.Sat, Color.Value)
		for _, v in EntityESP do
			v.Thickness = 1
			v.Color = color
		end

		Reference[entity] = EntityESP
	end,
	DrawingSkeleton = function(entity)
		if not Targets.Players.Enabled and entity.Player then return end
		if not Targets.NPCs.Enabled and entity.NPC then return end
		if Teammates.Enabled and (not entity.Targetable) and (not entity.Friend) then return end
		if vape.ThreadFix then
			setthreadidentity(8)
		end

		local EntityESP = {}
		EntityESP.Head = Drawing.new('Line')
		EntityESP.HeadFacing = Drawing.new('Line')
		EntityESP.Torso = Drawing.new('Line')
		EntityESP.UpperTorso = Drawing.new('Line')
		EntityESP.LowerTorso = Drawing.new('Line')
		EntityESP.LeftArm = Drawing.new('Line')
		EntityESP.RightArm = Drawing.new('Line')
		EntityESP.LeftLeg = Drawing.new('Line')
		EntityESP.RightLeg = Drawing.new('Line')

		local color = entitylib.getEntityColor(entity) or Color3.fromHSV(Color.Hue, Color.Sat, Color.Value)
		for _, v in EntityESP do
			v.Thickness = 2
			v.Color = color
		end

		Reference[entity] = EntityESP
	end
}

local ESPRemoved = {
	Drawing2D = function(entity)
		local EntityESP = Reference[entity]
		if EntityESP then
			if vape.ThreadFix then
				setthreadidentity(8)
			end

			Reference[entity] = nil
			for _, v in EntityESP do
				pcall(function()
					v.Visible = false
					v:Remove()
				end)
			end
		end
	end
}
ESPRemoved.Drawing3D = ESPRemoved.Drawing2D
ESPRemoved.DrawingSkeleton = ESPRemoved.Drawing2D

local ESPUpdated = {
	Drawing2D = function(entity)
		local EntityESP = Reference[entity]
		if EntityESP then
			if vape.ThreadFix then
				setthreadidentity(8)
			end

			if EntityESP.HealthLine then
				EntityESP.HealthLine.Color = Color3.fromHSV(math.clamp(entity.Health / entity.MaxHealth, 0, 1) / 2.5, 0.89, 0.75)
			end

			if EntityESP.Text then
				EntityESP.Text.Text = entity.Player and whitelist:tag(entity.Player, true)..(DisplayName.Enabled and entity.Player.DisplayName or entity.Player.Name) or entity.Character.Name
				EntityESP.Drop.Text = EntityESP.Text.Text
			end
		end
	end
}

local ColorFunc = {
	Drawing2D = function(hue, sat, val)
		local color = Color3.fromHSV(hue, sat, val)
		for entity, v in Reference do
			v.Main.Color = entitylib.getEntityColor(entity) or color

			if v.Text then
				v.Text.Color = v.Main.Color
			end
		end
	end,
	Drawing3D = function(hue, sat, val)
		local color = Color3.fromHSV(hue, sat, val)
		for entity, v in Reference do
			local playercolor = entitylib.getEntityColor(entity) or color

			for _, v2 in v do
				v2.Color = playercolor
			end
		end
	end
}
ColorFunc.DrawingSkeleton = ColorFunc.Drawing3D

local ESPLoop = {
	Drawing2D = function()
		for entity, EntityESP in Reference do
			if Distance.Enabled then
				local distance = entitylib.isAlive and (entitylib.character.RootPart.Position - entity.RootPart.Position).Magnitude or math.huge
				if distance < DistanceLimit.ValueMin or distance > DistanceLimit.ValueMax then
					for _, obj in EntityESP do
						obj.Visible = false
					end
					continue
				end
			end

			local rootPos, rootVis = gameCamera:WorldToViewportPoint(entity.RootPart.Position)
			for _, obj in EntityESP do
				obj.Visible = rootVis
			end
			if not rootVis then continue end

			local topPos = gameCamera:WorldToViewportPoint((CFrame.lookAlong(entity.RootPart.Position, gameCamera.CFrame.LookVector) * CFrame.new(2, entity.HipHeight, 0)).Position)
			local bottomPos = gameCamera:WorldToViewportPoint((CFrame.lookAlong(entity.RootPart.Position, gameCamera.CFrame.LookVector) * CFrame.new(-2, -entity.HipHeight - 1, 0)).Position)
			local sizex, sizey = topPos.X - bottomPos.X, topPos.Y - bottomPos.Y
			local posx, posy = (rootPos.X - sizex / 2),  ((rootPos.Y - sizey / 2))
			EntityESP.Main.Position = Vector2.new(posx, posy) // 1
			EntityESP.Main.Size = Vector2.new(sizex, sizey) // 1
			if EntityESP.Border then
				EntityESP.Border.Position = Vector2.new(posx - 1, posy + 1) // 1
				EntityESP.Border.Size = Vector2.new(sizex + 2, sizey - 2) // 1
				EntityESP.Border2.Position = Vector2.new(posx + 1, posy - 1) // 1
				EntityESP.Border2.Size = Vector2.new(sizex - 2, sizey + 2) // 1
			end

			if EntityESP.HealthLine then
				local healthposy = sizey * math.clamp(entity.Health / entity.MaxHealth, 0, 1)
				EntityESP.HealthLine.Visible = entity.Health > 0
				EntityESP.HealthLine.From = Vector2.new(posx - 6, posy + (sizey - (sizey - healthposy))) // 1
				EntityESP.HealthLine.To = Vector2.new(posx - 6, posy) // 1
				EntityESP.HealthBorder.From = Vector2.new(posx - 6, posy + 1) // 1
				EntityESP.HealthBorder.To = Vector2.new(posx - 6, (posy + sizey) - 1) // 1
			end

			if EntityESP.Text then
				EntityESP.Text.Position = Vector2.new(posx + (sizex / 2), posy + (sizey - 28)) // 1
				EntityESP.Drop.Position = EntityESP.Text.Position + Vector2.new(1, 1)
				if EntityESP.TextBKG then
					EntityESP.TextBKG.Size = EntityESP.Text.TextBounds + Vector2.new(8, 4)
					EntityESP.TextBKG.Position = EntityESP.Text.Position - Vector2.new(4 + (EntityESP.Text.TextBounds.X / 2), 0)
				end
			end
		end
	end,
	Drawing3D = function()
		for entity, EntityESP in Reference do
			if Distance.Enabled then
				local distance = entitylib.isAlive and (entitylib.character.RootPart.Position - entity.RootPart.Position).Magnitude or math.huge
				if distance < DistanceLimit.ValueMin or distance > DistanceLimit.ValueMax then
					for _, obj in EntityESP do
						obj.Visible = false
					end
					continue
				end
			end

			local _, rootVis = gameCamera:WorldToViewportPoint(entity.RootPart.Position)
			for _, obj in EntityESP do
				obj.Visible = rootVis
			end
			if not rootVis then continue end

			local point1 = ESPWorldToViewport(entity.RootPart.Position + Vector3.new(1.5, entity.HipHeight, 1.5))
			local point2 = ESPWorldToViewport(entity.RootPart.Position + Vector3.new(1.5, -entity.HipHeight, 1.5))
			local point3 = ESPWorldToViewport(entity.RootPart.Position + Vector3.new(-1.5, entity.HipHeight, 1.5))
			local point4 = ESPWorldToViewport(entity.RootPart.Position + Vector3.new(-1.5, -entity.HipHeight, 1.5))
			local point5 = ESPWorldToViewport(entity.RootPart.Position + Vector3.new(1.5, entity.HipHeight, -1.5))
			local point6 = ESPWorldToViewport(entity.RootPart.Position + Vector3.new(1.5, -entity.HipHeight, -1.5))
			local point7 = ESPWorldToViewport(entity.RootPart.Position + Vector3.new(-1.5, entity.HipHeight, -1.5))
			local point8 = ESPWorldToViewport(entity.RootPart.Position + Vector3.new(-1.5, -entity.HipHeight, -1.5))
			EntityESP.Line1.From = point1
			EntityESP.Line1.To = point2
			EntityESP.Line2.From = point3
			EntityESP.Line2.To = point4
			EntityESP.Line3.From = point5
			EntityESP.Line3.To = point6
			EntityESP.Line4.From = point7
			EntityESP.Line4.To = point8
			EntityESP.Line5.From = point1
			EntityESP.Line5.To = point3
			EntityESP.Line6.From = point1
			EntityESP.Line6.To = point5
			EntityESP.Line7.From = point5
			EntityESP.Line7.To = point7
			EntityESP.Line8.From = point7
			EntityESP.Line8.To = point3
			EntityESP.Line9.From = point2
			EntityESP.Line9.To = point4
			EntityESP.Line10.From = point2
			EntityESP.Line10.To = point6
			EntityESP.Line11.From = point6
			EntityESP.Line11.To = point8
			EntityESP.Line12.From = point8
			EntityESP.Line12.To = point4
		end
	end,
	DrawingSkeleton = function()
		for entity, EntityESP in Reference do
			if Distance.Enabled then
				local distance = entitylib.isAlive and (entitylib.character.RootPart.Position - entity.RootPart.Position).Magnitude or math.huge
				if distance < DistanceLimit.ValueMin or distance > DistanceLimit.ValueMax then
					for _, obj in EntityESP do
						obj.Visible = false
					end
					continue
				end
			end

			local _, rootVis = gameCamera:WorldToViewportPoint(entity.RootPart.Position)
			for _, obj in EntityESP do
				obj.Visible = rootVis
			end
			if not rootVis then continue end

			local rigcheck = entity.Humanoid.RigType == Enum.HumanoidRigType.R6
			pcall(function()
				local offset = rigcheck and CFrame.new(0, -0.8, 0) or CFrame.identity
				local head = ESPWorldToViewport((entity.Head.CFrame).Position)
				local headfront = ESPWorldToViewport((entity.Head.CFrame * CFrame.new(0, 0, -0.5)).Position)
				local toplefttorso = ESPWorldToViewport((entity.Character[(rigcheck and 'Torso' or 'UpperTorso')].CFrame * CFrame.new(-1.5, 0.8, 0)).Position)
				local toprighttorso = ESPWorldToViewport((entity.Character[(rigcheck and 'Torso' or 'UpperTorso')].CFrame * CFrame.new(1.5, 0.8, 0)).Position)
				local toptorso = ESPWorldToViewport((entity.Character[(rigcheck and 'Torso' or 'UpperTorso')].CFrame * CFrame.new(0, 0.8, 0)).Position)
				local bottomtorso = ESPWorldToViewport((entity.Character[(rigcheck and 'Torso' or 'UpperTorso')].CFrame * CFrame.new(0, -0.8, 0)).Position)
				local bottomlefttorso = ESPWorldToViewport((entity.Character[(rigcheck and 'Torso' or 'UpperTorso')].CFrame * CFrame.new(-0.5, -0.8, 0)).Position)
				local bottomrighttorso = ESPWorldToViewport((entity.Character[(rigcheck and 'Torso' or 'UpperTorso')].CFrame * CFrame.new(0.5, -0.8, 0)).Position)
				local leftarm = ESPWorldToViewport((entity.Character[(rigcheck and 'Left Arm' or 'LeftHand')].CFrame * offset).Position)
				local rightarm = ESPWorldToViewport((entity.Character[(rigcheck and 'Right Arm' or 'RightHand')].CFrame * offset).Position)
				local leftleg = ESPWorldToViewport((entity.Character[(rigcheck and 'Left Leg' or 'LeftFoot')].CFrame * offset).Position)
				local rightleg = ESPWorldToViewport((entity.Character[(rigcheck and 'Right Leg' or 'RightFoot')].CFrame * offset).Position)
				EntityESP.Head.From = toptorso
				EntityESP.Head.To = head
				EntityESP.HeadFacing.From = head
				EntityESP.HeadFacing.To = headfront
				EntityESP.UpperTorso.From = toplefttorso
				EntityESP.UpperTorso.To = toprighttorso
				EntityESP.Torso.From = toptorso
				EntityESP.Torso.To = bottomtorso
				EntityESP.LowerTorso.From = bottomlefttorso
				EntityESP.LowerTorso.To = bottomrighttorso
				EntityESP.LeftArm.From = toplefttorso
				EntityESP.LeftArm.To = leftarm
				EntityESP.RightArm.From = toprighttorso
				EntityESP.RightArm.To = rightarm
				EntityESP.LeftLeg.From = bottomlefttorso
				EntityESP.LeftLeg.To = leftleg
				EntityESP.RightLeg.From = bottomrighttorso
				EntityESP.RightLeg.To = rightleg
			end)
		end
	end
}

ESP = vape.Categories.Render:CreateModule({
	Name = 'ESP',
	Function = function(callback)
		if callback then
			methodused = 'Drawing'..Method.Value
			if ESPRemoved[methodused] then
				ESP:Clean(entitylib.Events.EntityRemoved:Connect(ESPRemoved[methodused]))
			end
			if ESPAdded[methodused] then
				for _, entity in entitylib.List do
					if Reference[entity] then
						ESPRemoved[methodused](entity)
					end
					ESPAdded[methodused](entity)
				end
				ESP:Clean(entitylib.Events.EntityAdded:Connect(function(entity)
					if Reference[entity] then
						ESPRemoved[methodused](entity)
					end
					ESPAdded[methodused](entity)
				end))
			end
			if ESPUpdated[methodused] then
				ESP:Clean(entitylib.Events.EntityUpdated:Connect(ESPUpdated[methodused]))
				for _, entity in entitylib.List do
					ESPUpdated[methodused](entity)
				end
			end
			if ColorFunc[methodused] then
				ESP:Clean(vape.Categories.Friends.ColorUpdate.Event:Connect(function()
					ColorFunc[methodused](Color.Hue, Color.Sat, Color.Value)
				end))
			end
			if ESPLoop[methodused] then
				ESP:Clean(runService.RenderStepped:Connect(ESPLoop[methodused]))
			end
		else
			if ESPRemoved[methodused] then
				for entity in Reference do
					ESPRemoved[methodused](entity)
				end
			end
		end
	end,
	Tooltip = 'Extra Sensory Perception\nRenders an ESP on players.'
})
Targets = ESP:CreateTargets({
	Players = true,
	Function = function()
		if ESP.Enabled then
			ESP:Toggle()
			ESP:Toggle()
		end
	end
})
Method = ESP:CreateDropdown({
	Name = 'Mode',
	List = {'2D', '3D', 'Skeleton'},
	Function = function(val)
		if ESP.Enabled then
			ESP:Toggle()
			ESP:Toggle()
		end
		BoundingBox.Object.Visible = (val == '2D')
		Filled.Object.Visible = (val == '2D')
		HealthBar.Object.Visible = (val == '2D')
		Name.Object.Visible = (val == '2D')
		DisplayName.Object.Visible = Name.Object.Visible and Name.Enabled
		Background.Object.Visible = Name.Object.Visible and Name.Enabled
	end,
})
Color = ESP:CreateColorSlider({
	Name = 'Player Color',
	Function = function(hue, sat, val)
		if ESP.Enabled and ColorFunc[methodused] then
			ColorFunc[methodused](hue, sat, val)
		end
	end
})
BoundingBox = ESP:CreateToggle({
	Name = 'Bounding Box',
	Function = function()
		if ESP.Enabled then
			ESP:Toggle()
			ESP:Toggle()
		end
	end,
	Default = true,
	Darker = true
})
Filled = ESP:CreateToggle({
	Name = 'Filled',
	Function = function()
		if ESP.Enabled then
			ESP:Toggle()
			ESP:Toggle()
		end
	end,
	Darker = true
})
HealthBar = ESP:CreateToggle({
	Name = 'Health Bar',
	Function = function()
		if ESP.Enabled then
			ESP:Toggle()
			ESP:Toggle()
		end
	end,
	Darker = true
})
Name = ESP:CreateToggle({
	Name = 'Name',
	Function = function(callback)
		if ESP.Enabled then
			ESP:Toggle()
			ESP:Toggle()
		end
		DisplayName.Object.Visible = callback
		Background.Object.Visible = callback
	end,
	Darker = true
})
DisplayName = ESP:CreateToggle({
	Name = 'Use Displayname',
	Function = function()
		if ESP.Enabled then
			ESP:Toggle()
			ESP:Toggle()
		end
	end,
	Default = true,
	Darker = true
})
Background = ESP:CreateToggle({
	Name = 'Show Background',
	Function = function()
		if ESP.Enabled then
			ESP:Toggle()
			ESP:Toggle()
		end
	end,
	Darker = true
})
Teammates = ESP:CreateToggle({
	Name = 'Priority Only',
	Function = function()
		if ESP.Enabled then
			ESP:Toggle()
			ESP:Toggle()
		end
	end,
	Default = true,
	Tooltip = 'Hides teammates & non targetable entities'
})
Distance = ESP:CreateToggle({
	Name = 'Distance Check',
	Function = function(callback)
		DistanceLimit.Object.Visible = callback
	end
})
DistanceLimit = ESP:CreateTwoSlider({
	Name = 'Player Distance',
	Min = 0,
	Max = 256,
	DefaultMin = 0,
	DefaultMax = 64,
	Darker = true,
	Visible = false
})