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
	Drawing2D = function(ent)
		if not Targets.Players.Enabled and ent.Player then return end
		if not Targets.NPCs.Enabled and ent.NPC then return end
		if Teammates.Enabled and (not ent.Targetable) and (not ent.Friend) then return end
		if vape.ThreadFix then
			setthreadidentity(8)
		end
		local EntityESP = {}
		EntityESP.Main = Drawing.new('Square')
		EntityESP.Main.Transparency = BoundingBox.Enabled and 1 or 0
		EntityESP.Main.ZIndex = 2
		EntityESP.Main.Filled = false
		EntityESP.Main.Thickness = 1
		EntityESP.Main.Color = entitylib.getEntityColor(ent) or Color3.fromHSV(Color.Hue, Color.Sat, Color.Value)

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
			EntityESP.HealthLine.Color = Color3.fromHSV(math.clamp(ent.Health / ent.MaxHealth, 0, 1) / 2.5, 0.89, 0.75)
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
			EntityESP.Drop.Text = ent.Player and whitelist:tag(ent.Player, true)..(DisplayName.Enabled and ent.Player.DisplayName or ent.Player.Name) or ent.Character.Name
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
		Reference[ent] = EntityESP
	end,
	Drawing3D = function(ent)
		if not Targets.Players.Enabled and ent.Player then return end
		if not Targets.NPCs.Enabled and ent.NPC then return end
		if Teammates.Enabled and (not ent.Targetable) and (not ent.Friend) then return end
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

		local color = entitylib.getEntityColor(ent) or Color3.fromHSV(Color.Hue, Color.Sat, Color.Value)
		for _, v in EntityESP do
			v.Thickness = 1
			v.Color = color
		end

		Reference[ent] = EntityESP
	end,
	DrawingSkeleton = function(ent)
		if not Targets.Players.Enabled and ent.Player then return end
		if not Targets.NPCs.Enabled and ent.NPC then return end
		if Teammates.Enabled and (not ent.Targetable) and (not ent.Friend) then return end
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

		local color = entitylib.getEntityColor(ent) or Color3.fromHSV(Color.Hue, Color.Sat, Color.Value)
		for _, v in EntityESP do
			v.Thickness = 2
			v.Color = color
		end

		Reference[ent] = EntityESP
	end
}

local ESPRemoved = {
	Drawing2D = function(ent)
		local EntityESP = Reference[ent]
		if EntityESP then
			if vape.ThreadFix then
				setthreadidentity(8)
			end
			Reference[ent] = nil
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
	Drawing2D = function(ent)
		local EntityESP = Reference[ent]
		if EntityESP then
			if vape.ThreadFix then
				setthreadidentity(8)
			end
			
			if EntityESP.HealthLine then
				EntityESP.HealthLine.Color = Color3.fromHSV(math.clamp(ent.Health / ent.MaxHealth, 0, 1) / 2.5, 0.89, 0.75)
			end

			if EntityESP.Text then
				EntityESP.Text.Text = ent.Player and whitelist:tag(ent.Player, true)..(DisplayName.Enabled and ent.Player.DisplayName or ent.Player.Name) or ent.Character.Name
				EntityESP.Drop.Text = EntityESP.Text.Text
			end
		end
	end
}

local ColorFunc = {
	Drawing2D = function(hue, sat, val)
		local color = Color3.fromHSV(hue, sat, val)
		for i, v in Reference do
			v.Main.Color = entitylib.getEntityColor(i) or color
			if v.Text then
				v.Text.Color = v.Main.Color
			end
		end
	end,
	Drawing3D = function(hue, sat, val)
		local color = Color3.fromHSV(hue, sat, val)
		for i, v in Reference do
			local playercolor = entitylib.getEntityColor(i) or color
			for _, v2 in v do
				v2.Color = playercolor
			end
		end
	end
}
ColorFunc.DrawingSkeleton = ColorFunc.Drawing3D

local ESPLoop = {
	Drawing2D = function()
		for ent, EntityESP in Reference do
			if Distance.Enabled then
				local distance = entitylib.isAlive and (entitylib.character.RootPart.Position - ent.RootPart.Position).Magnitude or math.huge
				if distance < DistanceLimit.ValueMin or distance > DistanceLimit.ValueMax then
					for _, obj in EntityESP do
						obj.Visible = false
					end
					continue
				end
			end

			local rootPos, rootVis = gameCamera:WorldToViewportPoint(ent.RootPart.Position)
			for _, obj in EntityESP do
				obj.Visible = rootVis
			end
			if not rootVis then continue end

			local topPos = gameCamera:WorldToViewportPoint((CFrame.lookAlong(ent.RootPart.Position, gameCamera.CFrame.LookVector) * CFrame.new(2, ent.HipHeight, 0)).p)
			local bottomPos = gameCamera:WorldToViewportPoint((CFrame.lookAlong(ent.RootPart.Position, gameCamera.CFrame.LookVector) * CFrame.new(-2, -ent.HipHeight - 1, 0)).p)
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
				local healthposy = sizey * math.clamp(ent.Health / ent.MaxHealth, 0, 1)
				EntityESP.HealthLine.Visible = ent.Health > 0
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
		for ent, EntityESP in Reference do
			if Distance.Enabled then
				local distance = entitylib.isAlive and (entitylib.character.RootPart.Position - ent.RootPart.Position).Magnitude or math.huge
				if distance < DistanceLimit.ValueMin or distance > DistanceLimit.ValueMax then
					for _, obj in EntityESP do
						obj.Visible = false
					end
					continue
				end
			end

			local _, rootVis = gameCamera:WorldToViewportPoint(ent.RootPart.Position)
			for _, obj in EntityESP do
				obj.Visible = rootVis
			end
			if not rootVis then continue end

			local point1 = ESPWorldToViewport(ent.RootPart.Position + Vector3.new(1.5, ent.HipHeight, 1.5))
			local point2 = ESPWorldToViewport(ent.RootPart.Position + Vector3.new(1.5, -ent.HipHeight, 1.5))
			local point3 = ESPWorldToViewport(ent.RootPart.Position + Vector3.new(-1.5, ent.HipHeight, 1.5))
			local point4 = ESPWorldToViewport(ent.RootPart.Position + Vector3.new(-1.5, -ent.HipHeight, 1.5))
			local point5 = ESPWorldToViewport(ent.RootPart.Position + Vector3.new(1.5, ent.HipHeight, -1.5))
			local point6 = ESPWorldToViewport(ent.RootPart.Position + Vector3.new(1.5, -ent.HipHeight, -1.5))
			local point7 = ESPWorldToViewport(ent.RootPart.Position + Vector3.new(-1.5, ent.HipHeight, -1.5))
			local point8 = ESPWorldToViewport(ent.RootPart.Position + Vector3.new(-1.5, -ent.HipHeight, -1.5))
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
		for ent, EntityESP in Reference do
			if Distance.Enabled then
				local distance = entitylib.isAlive and (entitylib.character.RootPart.Position - ent.RootPart.Position).Magnitude or math.huge
				if distance < DistanceLimit.ValueMin or distance > DistanceLimit.ValueMax then
					for _, obj in EntityESP do
						obj.Visible = false
					end
					continue
				end
			end

			local _, rootVis = gameCamera:WorldToViewportPoint(ent.RootPart.Position)
			for _, obj in EntityESP do
				obj.Visible = rootVis
			end
			if not rootVis then continue end
			
			local rigcheck = ent.Humanoid.RigType == Enum.HumanoidRigType.R6
			pcall(function()
				local offset = rigcheck and CFrame.new(0, -0.8, 0) or CFrame.identity
				local head = ESPWorldToViewport((ent.Head.CFrame).p)
				local headfront = ESPWorldToViewport((ent.Head.CFrame * CFrame.new(0, 0, -0.5)).p)
				local toplefttorso = ESPWorldToViewport((ent.Character[(rigcheck and 'Torso' or 'UpperTorso')].CFrame * CFrame.new(-1.5, 0.8, 0)).p)
				local toprighttorso = ESPWorldToViewport((ent.Character[(rigcheck and 'Torso' or 'UpperTorso')].CFrame * CFrame.new(1.5, 0.8, 0)).p)
				local toptorso = ESPWorldToViewport((ent.Character[(rigcheck and 'Torso' or 'UpperTorso')].CFrame * CFrame.new(0, 0.8, 0)).p)
				local bottomtorso = ESPWorldToViewport((ent.Character[(rigcheck and 'Torso' or 'UpperTorso')].CFrame * CFrame.new(0, -0.8, 0)).p)
				local bottomlefttorso = ESPWorldToViewport((ent.Character[(rigcheck and 'Torso' or 'UpperTorso')].CFrame * CFrame.new(-0.5, -0.8, 0)).p)
				local bottomrighttorso = ESPWorldToViewport((ent.Character[(rigcheck and 'Torso' or 'UpperTorso')].CFrame * CFrame.new(0.5, -0.8, 0)).p)
				local leftarm = ESPWorldToViewport((ent.Character[(rigcheck and 'Left Arm' or 'LeftHand')].CFrame * offset).p)
				local rightarm = ESPWorldToViewport((ent.Character[(rigcheck and 'Right Arm' or 'RightHand')].CFrame * offset).p)
				local leftleg = ESPWorldToViewport((ent.Character[(rigcheck and 'Left Leg' or 'LeftFoot')].CFrame * offset).p)
				local rightleg = ESPWorldToViewport((ent.Character[(rigcheck and 'Right Leg' or 'RightFoot')].CFrame * offset).p)
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
				for _, v in entitylib.List do
					if Reference[v] then
						ESPRemoved[methodused](v)
					end
					ESPAdded[methodused](v)
				end
				ESP:Clean(entitylib.Events.EntityAdded:Connect(function(ent)
					if Reference[ent] then
						ESPRemoved[methodused](ent)
					end
					ESPAdded[methodused](ent)
				end))
			end
			if ESPUpdated[methodused] then
				ESP:Clean(entitylib.Events.EntityUpdated:Connect(ESPUpdated[methodused]))
				for _, v in entitylib.List do
					ESPUpdated[methodused](v)
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
				for i in Reference do
					ESPRemoved[methodused](i)
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