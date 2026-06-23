local NameTags
local Targets
local Color
local Background
local Stroke
local DisplayName
local Health
local Distance
local DrawingToggle
local Scale
local FontOption
local Teammates
local DistanceCheck
local DistanceLimit
local Strings, Sizes, Reference = {}, {}, {}
local Folder = Instance.new('Folder')
Folder.Parent = vape.gui
local methodused

local Added = {
	Normal = function(ent)
		if not Targets.Players.Enabled and ent.Player then return end
		if not Targets.NPCs.Enabled and ent.NPC then return end
		if Teammates.Enabled and (not ent.Targetable) and (not ent.Friend) then return end
		if vape.ThreadFix then
			setthreadidentity(8)
		end

		Strings[ent] = ent.Player and whitelist:tag(ent.Player, true, true)..(DisplayName.Enabled and ent.Player.DisplayName or ent.Player.Name) or ent.Character.Name

		if Health.Enabled then
			local healthColor = Color3.fromHSV(math.clamp(ent.Health / ent.MaxHealth, 0, 1) / 2.5, 0.89, 0.75)
			Strings[ent] = Strings[ent]..' <font color="rgb('..tostring(math.floor(healthColor.R * 255))..','..tostring(math.floor(healthColor.G * 255))..','..tostring(math.floor(healthColor.B * 255))..')">'..math.round(ent.Health)..'</font>'
		end

		if Distance.Enabled then
			Strings[ent] = '<font color="rgb(85, 255, 85)">[</font><font color="rgb(255, 255, 255)">%s</font><font color="rgb(85, 255, 85)">]</font> '..Strings[ent]
		end

		local nametag = Instance.new('TextLabel')
		nametag.TextSize = 14 * Scale.Value
		nametag.FontFace = FontOption.Value
		local size = getfontsize(removeTags(Strings[ent]), nametag.TextSize, nametag.FontFace, Vector2.new(100000, 100000))
		nametag.Name = ent.Player and ent.Player.Name or ent.Character.Name
		nametag.Size = UDim2.fromOffset(size.X + 8, size.Y + 7)
		nametag.AnchorPoint = Vector2.new(0.5, 1)
		nametag.BackgroundColor3 = Color3.new()
		nametag.BackgroundTransparency = Background.Value
		nametag.TextStrokeTransparency = Stroke.Value
		nametag.BorderSizePixel = 0
		nametag.Visible = false
		nametag.Text = Strings[ent]
		nametag.TextColor3 = entitylib.getEntityColor(ent) or Color3.fromHSV(Color.Hue, Color.Sat, Color.Value)
		nametag.RichText = true
		nametag.Parent = Folder
		Reference[ent] = nametag
	end,
	Drawing = function(ent)
		if not Targets.Players.Enabled and ent.Player then return end
		if not Targets.NPCs.Enabled and ent.NPC then return end
		if Teammates.Enabled and (not ent.Targetable) and (not ent.Friend) then return end

		local nametag = {}
		nametag.BG = Drawing.new('Square')
		nametag.BG.Filled = true
		nametag.BG.Transparency = 1 - Background.Value
		nametag.BG.Color = Color3.new()
		nametag.BG.ZIndex = 1
		nametag.Text = Drawing.new('Text')
		nametag.Text.Size = 15 * Scale.Value
		nametag.Text.Font = 0
		nametag.Text.ZIndex = 2
		Strings[ent] = ent.Player and whitelist:tag(ent.Player, true)..(DisplayName.Enabled and ent.Player.DisplayName or ent.Player.Name) or ent.Character.Name

		if Health.Enabled then
			Strings[ent] = Strings[ent]..' '..math.round(ent.Health)
		end

		if Distance.Enabled then
			Strings[ent] = '[%s] '..Strings[ent]
		end

		nametag.Text.Text = Strings[ent]
		nametag.Text.Color = entitylib.getEntityColor(ent) or Color3.fromHSV(Color.Hue, Color.Sat, Color.Value)
		nametag.BG.Size = Vector2.new(nametag.Text.TextBounds.X + 8, nametag.Text.TextBounds.Y + 7)
		Reference[ent] = nametag
	end
}

local Removed = {
	Normal = function(ent)
		local v = Reference[ent]
		if v then
			if vape.ThreadFix then
				setthreadidentity(8)
			end
			Reference[ent] = nil
			Strings[ent] = nil
			Sizes[ent] = nil
			v:Destroy()
		end
	end,
	Drawing = function(ent)
		local v = Reference[ent]
		if v then
			if vape.ThreadFix then
				setthreadidentity(8)
			end
			Reference[ent] = nil
			Strings[ent] = nil
			Sizes[ent] = nil
			for _, obj in v do
				pcall(function()
					obj.Visible = false
					obj:Remove()
				end)
			end
		end
	end
}

local Updated = {
	Normal = function(ent)
		local nametag = Reference[ent]
		if nametag then
			if vape.ThreadFix then
				setthreadidentity(8)
			end
			Sizes[ent] = nil
			Strings[ent] = ent.Player and whitelist:tag(ent.Player, true, true)..(DisplayName.Enabled and ent.Player.DisplayName or ent.Player.Name) or ent.Character.Name

			if Health.Enabled then
				local color = Color3.fromHSV(math.clamp(ent.Health / ent.MaxHealth, 0, 1) / 2.5, 0.89, 0.75)
				Strings[ent] = Strings[ent]..' <font color="rgb('..tostring(math.floor(color.R * 255))..','..tostring(math.floor(color.G * 255))..','..tostring(math.floor(color.B * 255))..')">'..math.round(ent.Health)..'</font>'
			end

			if Distance.Enabled then
				Strings[ent] = '<font color="rgb(85, 255, 85)">[</font><font color="rgb(255, 255, 255)">%s</font><font color="rgb(85, 255, 85)">]</font> '..Strings[ent]
			end

			local size = getfontsize(removeTags(Strings[ent]), nametag.TextSize, nametag.FontFace, Vector2.new(100000, 100000))
			nametag.Size = UDim2.fromOffset(size.X + 8, size.Y + 7)
			nametag.Text = Strings[ent]
		end
	end,
	Drawing = function(ent)
		local nametag = Reference[ent]
		if nametag then
			if vape.ThreadFix then
				setthreadidentity(8)
			end
			Sizes[ent] = nil
			Strings[ent] = ent.Player and whitelist:tag(ent.Player, true)..(DisplayName.Enabled and ent.Player.DisplayName or ent.Player.Name) or ent.Character.Name

			if Health.Enabled then
				Strings[ent] = Strings[ent]..' '..math.round(ent.Health)
			end

			if Distance.Enabled then
				Strings[ent] = '[%s] '..Strings[ent]
				nametag.Text.Text = entitylib.isAlive and string.format(Strings[ent], math.floor((entitylib.character.RootPart.Position - ent.RootPart.Position).Magnitude)) or Strings[ent]
			else
				nametag.Text.Text = Strings[ent]
			end

			nametag.BG.Size = Vector2.new(nametag.Text.TextBounds.X + 8, nametag.Text.TextBounds.Y + 7)
			nametag.Text.Color = entitylib.getEntityColor(ent) or Color3.fromHSV(Color.Hue, Color.Sat, Color.Value)
		end
	end
}

local ColorFunc = {
	Normal = function(hue, sat, val)
		local color = Color3.fromHSV(hue, sat, val)
		for i, v in Reference do
			v.TextColor3 = entitylib.getEntityColor(i) or color
		end
	end,
	Drawing = function(hue, sat, val)
		local color = Color3.fromHSV(hue, sat, val)
		for i, v in Reference do
			v.Text.Color = entitylib.getEntityColor(i) or color
		end
	end
}

local Loop = {
	Normal = function()
		for ent, nametag in Reference do
			if DistanceCheck.Enabled then
				local distance = entitylib.isAlive and (entitylib.character.RootPart.Position - ent.RootPart.Position).Magnitude or math.huge
				if distance < DistanceLimit.ValueMin or distance > DistanceLimit.ValueMax then
					nametag.Visible = false
					continue
				end
			end

			local headPos, headVis = gameCamera:WorldToViewportPoint(ent.RootPart.Position + Vector3.new(0, ent.HipHeight + 1, 0))
			nametag.Visible = headVis
			if not headVis then
				continue
			end

			if Distance.Enabled then
				local mag = entitylib.isAlive and math.floor((entitylib.character.RootPart.Position - ent.RootPart.Position).Magnitude) or 0
				if Sizes[ent] ~= mag then
					nametag.Text = string.format(Strings[ent], mag)
					local ize = getfontsize(removeTags(nametag.Text), nametag.TextSize, nametag.FontFace, Vector2.new(100000, 100000))
					nametag.Size = UDim2.fromOffset(ize.X + 8, ize.Y + 7)
					Sizes[ent] = mag
				end
			end
			nametag.Position = UDim2.fromOffset(headPos.X, headPos.Y)
		end
	end,
	Drawing = function()
		for ent, nametag in Reference do
			if DistanceCheck.Enabled then
				local distance = entitylib.isAlive and (entitylib.character.RootPart.Position - ent.RootPart.Position).Magnitude or math.huge
				if distance < DistanceLimit.ValueMin or distance > DistanceLimit.ValueMax then
					nametag.Text.Visible = false
					nametag.BG.Visible = false
					continue
				end
			end

			local headPos, headVis = gameCamera:WorldToViewportPoint(ent.RootPart.Position + Vector3.new(0, ent.HipHeight + 1, 0))
			nametag.Text.Visible = headVis
			nametag.BG.Visible = headVis
			if not headVis then
				continue
			end

			if Distance.Enabled then
				local mag = entitylib.isAlive and math.floor((entitylib.character.RootPart.Position - ent.RootPart.Position).Magnitude) or 0
				if Sizes[ent] ~= mag then
					nametag.Text.Text = string.format(Strings[ent], mag)
					nametag.BG.Size = Vector2.new(nametag.Text.TextBounds.X + 8, nametag.Text.TextBounds.Y + 7)
					Sizes[ent] = mag
				end
			end
			nametag.BG.Position = Vector2.new(headPos.X - (nametag.BG.Size.X / 2), headPos.Y - nametag.BG.Size.Y)
			nametag.Text.Position = nametag.BG.Position + Vector2.new(4, 3)
		end
	end
}

NameTags = vape.Categories.Render:CreateModule({
	Name = 'NameTags',
	Function = function(callback)
		if callback then
			methodused = DrawingToggle.Enabled and 'Drawing' or 'Normal'
			if Removed[methodused] then
				NameTags:Clean(entitylib.Events.EntityRemoved:Connect(Removed[methodused]))
			end
			if Added[methodused] then
				for _, v in entitylib.List do
					if Reference[v] then
						Removed[methodused](v)
					end
					Added[methodused](v)
				end
				NameTags:Clean(entitylib.Events.EntityAdded:Connect(function(ent)
					if Reference[ent] then
						Removed[methodused](ent)
					end
					Added[methodused](ent)
				end))
			end
			if Updated[methodused] then
				NameTags:Clean(entitylib.Events.EntityUpdated:Connect(Updated[methodused]))
				for _, v in entitylib.List do
					Updated[methodused](v)
				end
			end
			if ColorFunc[methodused] then
				NameTags:Clean(vape.Categories.Friends.ColorUpdate.Event:Connect(function()
					ColorFunc[methodused](Color.Hue, Color.Sat, Color.Value)
				end))
			end
			if Loop[methodused] then
				NameTags:Clean(runService.RenderStepped:Connect(Loop[methodused]))
			end
		else
			if Removed[methodused] then
				for i in Reference do
					Removed[methodused](i)
				end
			end
		end
	end,
	Tooltip = 'Renders nametags on entities through walls.'
})
Targets = NameTags:CreateTargets({
	Players = true,
	Function = function()
		if NameTags.Enabled then
			NameTags:Toggle()
			NameTags:Toggle()
		end
	end
})
FontOption = NameTags:CreateFont({
	Name = 'Font',
	Blacklist = 'Arial',
	Function = function()
		if NameTags.Enabled then
			NameTags:Toggle()
			NameTags:Toggle()
		end
	end
})
Color = NameTags:CreateColorSlider({
	Name = 'Player Color',
	Function = function(hue, sat, val)
		if NameTags.Enabled and ColorFunc[methodused] then
			ColorFunc[methodused](hue, sat, val)
		end
	end
})
Scale = NameTags:CreateSlider({
	Name = 'Scale',
	Function = function()
		if NameTags.Enabled then
			NameTags:Toggle()
			NameTags:Toggle()
		end
	end,
	Default = 1,
	Min = 0.1,
	Max = 1.5,
	Decimal = 10
})
Background = NameTags:CreateSlider({
	Name = 'Transparency',
	Function = function()
		if NameTags.Enabled then
			NameTags:Toggle()
			NameTags:Toggle()
		end
	end,
	Default = 0.5,
	Min = 0,
	Max = 1,
	Decimal = 10
})
Stroke = NameTags:CreateSlider({
	Name = 'Stroke Transparency',
	Function = function()
		if NameTags.Enabled then
			NameTags:Toggle()
			NameTags:Toggle()
		end
	end,
	Default = 1,
	Min = 0,
	Max = 1,
	Decimal = 10
})
Health = NameTags:CreateToggle({
	Name = 'Health',
	Function = function()
		if NameTags.Enabled then
			NameTags:Toggle()
			NameTags:Toggle()
		end
	end
})
Distance = NameTags:CreateToggle({
	Name = 'Distance',
	Function = function()
		if NameTags.Enabled then
			NameTags:Toggle()
			NameTags:Toggle()
		end
	end
})
DisplayName = NameTags:CreateToggle({
	Name = 'Use Displayname',
	Function = function()
		if NameTags.Enabled then
			NameTags:Toggle()
			NameTags:Toggle()
		end
	end,
	Default = true
})
Teammates = NameTags:CreateToggle({
	Name = 'Priority Only',
	Function = function()
		if NameTags.Enabled then
			NameTags:Toggle()
			NameTags:Toggle()
		end
	end,
	Default = true,
	Tooltip = 'Hides teammates & non targetable entities'
})
DrawingToggle = NameTags:CreateToggle({
	Name = 'Drawing',
	Function = function()
		if NameTags.Enabled then
			NameTags:Toggle()
			NameTags:Toggle()
		end
	end
})
DistanceCheck = NameTags:CreateToggle({
	Name = 'Distance Check',
	Function = function(callback)
		DistanceLimit.Object.Visible = callback
	end
})
DistanceLimit = NameTags:CreateTwoSlider({
	Name = 'Player Distance',
	Min = 0,
	Max = 256,
	DefaultMin = 0,
	DefaultMax = 64,
	Darker = true,
	Visible = false
})