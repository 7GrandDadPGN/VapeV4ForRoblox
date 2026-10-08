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
	Normal = function(entity)
		if not Targets.Players.Enabled and entity.Player then return end
		if not Targets.NPCs.Enabled and entity.NPC then return end
		if Teammates.Enabled and (not entity.Targetable) and (not entity.Friend) then return end
		if vape.ThreadFix then
			setthreadidentity(8)
		end

		Strings[entity] = entity.Player and whitelist:tag(entity.Player, true, true)..(DisplayName.Enabled and entity.Player.DisplayName or entity.Player.Name) or entity.Character.Name

		if Health.Enabled then
			local healthColor = Color3.fromHSV(math.clamp(entity.Health / entity.MaxHealth, 0, 1) / 2.5, 0.89, 0.75)
			Strings[entity] = Strings[entity]..' <font color="#'..healthColor:ToHex()..'">'..math.round(entity.Health)..'</font>'
		end

		if Distance.Enabled then
			Strings[entity] = '<font color="#55ff55">[</font><font color="#ffffff">%s</font><font color="#55ff55">]</font> '..Strings[entity]
		end

		local nametag = Instance.new('TextLabel')
		nametag.TextSize = 14 * Scale.Value
		nametag.FontFace = FontOption.Value
		local size = getfontbounds(removeTags(Strings[entity]), nametag.TextSize, nametag.FontFace, Vector2.new(100000, 100000))
		nametag.Name = entity.Player and entity.Player.Name or entity.Character.Name
		nametag.Size = UDim2.fromOffset(size.X + 8, size.Y + 7)
		nametag.AnchorPoint = Vector2.new(0.5, 1)
		nametag.BackgroundColor3 = Color3.new()
		nametag.BackgroundTransparency = Background.Value
		nametag.TextStrokeTransparency = Stroke.Value
		nametag.BorderSizePixel = 0
		nametag.Visible = false
		nametag.Text = Strings[entity]
		nametag.TextColor3 = entitylib.getEntityColor(entity) or Color3.fromHSV(Color.Hue, Color.Sat, Color.Value)
		nametag.RichText = true
		nametag.Parent = Folder
		Reference[entity] = nametag
	end,
	Drawing = function(entity)
		if not Targets.Players.Enabled and entity.Player then return end
		if not Targets.NPCs.Enabled and entity.NPC then return end
		if Teammates.Enabled and (not entity.Targetable) and (not entity.Friend) then return end

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
		Strings[entity] = entity.Player and whitelist:tag(entity.Player, true)..(DisplayName.Enabled and entity.Player.DisplayName or entity.Player.Name) or entity.Character.Name

		if Health.Enabled then
			Strings[entity] = Strings[entity]..' '..math.round(entity.Health)
		end

		if Distance.Enabled then
			Strings[entity] = '[%s] '..Strings[entity]
		end

		nametag.Text.Text = Strings[entity]
		nametag.Text.Color = entitylib.getEntityColor(entity) or Color3.fromHSV(Color.Hue, Color.Sat, Color.Value)
		nametag.BG.Size = Vector2.new(nametag.Text.TextBounds.X + 8, nametag.Text.TextBounds.Y + 7)
		Reference[entity] = nametag
	end
}

local Removed = {
	Normal = function(entity)
		local v = Reference[entity]
		if v then
			if vape.ThreadFix then
				setthreadidentity(8)
			end
			Reference[entity] = nil
			Strings[entity] = nil
			Sizes[entity] = nil
			v:Destroy()
		end
	end,
	Drawing = function(entity)
		local v = Reference[entity]
		if v then
			if vape.ThreadFix then
				setthreadidentity(8)
			end
			Reference[entity] = nil
			Strings[entity] = nil
			Sizes[entity] = nil
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
	Normal = function(entity)
		local nametag = Reference[entity]
		if nametag then
			if vape.ThreadFix then
				setthreadidentity(8)
			end
			Sizes[entity] = nil
			Strings[entity] = entity.Player and whitelist:tag(entity.Player, true, true)..(DisplayName.Enabled and entity.Player.DisplayName or entity.Player.Name) or entity.Character.Name

			if Health.Enabled then
				local color = Color3.fromHSV(math.clamp(entity.Health / entity.MaxHealth, 0, 1) / 2.5, 0.89, 0.75)
				Strings[entity] = Strings[entity]..' <font color="#'..color:ToHex()..'">'..math.round(entity.Health)..'</font>'
			end

			if Distance.Enabled then
				Strings[entity] = '<font color="#55ff55">[</font><font color="#ffffff">%s</font><font color="#55ff55">]</font> '..Strings[entity]
			end

			local size = getfontbounds(removeTags(Strings[entity]), nametag.TextSize, nametag.FontFace, Vector2.new(100000, 100000))
			nametag.Size = UDim2.fromOffset(size.X + 8, size.Y + 7)
			nametag.Text = Strings[entity]
		end
	end,
	Drawing = function(entity)
		local nametag = Reference[entity]
		if nametag then
			if vape.ThreadFix then
				setthreadidentity(8)
			end
			Sizes[entity] = nil
			Strings[entity] = entity.Player and whitelist:tag(entity.Player, true)..(DisplayName.Enabled and entity.Player.DisplayName or entity.Player.Name) or entity.Character.Name

			if Health.Enabled then
				Strings[entity] = Strings[entity]..' '..math.round(entity.Health)
			end

			if Distance.Enabled then
				Strings[entity] = '[%s] '..Strings[entity]
				nametag.Text.Text = entitylib.isAlive and string.format(Strings[entity], math.floor((entitylib.character.RootPart.Position - entity.RootPart.Position).Magnitude)) or Strings[entity]
			else
				nametag.Text.Text = Strings[entity]
			end

			nametag.BG.Size = Vector2.new(nametag.Text.TextBounds.X + 8, nametag.Text.TextBounds.Y + 7)
			nametag.Text.Color = entitylib.getEntityColor(entity) or Color3.fromHSV(Color.Hue, Color.Sat, Color.Value)
		end
	end
}

local ColorFunc = {
	Normal = function(hue, sat, val)
		local color = Color3.fromHSV(hue, sat, val)
		for entity, v in Reference do
			v.TextColor3 = entitylib.getEntityColor(entity) or color
		end
	end,
	Drawing = function(hue, sat, val)
		local color = Color3.fromHSV(hue, sat, val)
		for entity, v in Reference do
			v.Text.Color = entitylib.getEntityColor(entity) or color
		end
	end
}

local Loop = {
	Normal = function()
		for entity, nametag in Reference do
			if DistanceCheck.Enabled then
				local distance = entitylib.isAlive and (entitylib.character.RootPart.Position - entity.RootPart.Position).Magnitude or math.huge
				if distance < DistanceLimit.ValueMin or distance > DistanceLimit.ValueMax then
					nametag.Visible = false
					continue
				end
			end

			local headPos, headVis = gameCamera:WorldToViewportPoint(entity.RootPart.Position + Vector3.new(0, entity.HipHeight + 1, 0))
			nametag.Visible = headVis
			if not headVis then
				continue
			end

			if Distance.Enabled then
				local mag = entitylib.isAlive and math.floor((entitylib.character.RootPart.Position - entity.RootPart.Position).Magnitude) or 0
				if Sizes[entity] ~= mag then
					nametag.Text = string.format(Strings[entity], mag)
					local ize = getfontbounds(removeTags(nametag.Text), nametag.TextSize, nametag.FontFace, Vector2.new(100000, 100000))
					nametag.Size = UDim2.fromOffset(ize.X + 8, ize.Y + 7)
					Sizes[entity] = mag
				end
			end

			nametag.Position = UDim2.fromOffset(headPos.X, headPos.Y)
		end
	end,
	Drawing = function()
		for entity, nametag in Reference do
			if DistanceCheck.Enabled then
				local distance = entitylib.isAlive and (entitylib.character.RootPart.Position - entity.RootPart.Position).Magnitude or math.huge
				if distance < DistanceLimit.ValueMin or distance > DistanceLimit.ValueMax then
					nametag.Text.Visible = false
					nametag.BG.Visible = false
					continue
				end
			end

			local headPos, headVis = gameCamera:WorldToViewportPoint(entity.RootPart.Position + Vector3.new(0, entity.HipHeight + 1, 0))
			nametag.Text.Visible = headVis
			nametag.BG.Visible = headVis
			if not headVis then
				continue
			end

			if Distance.Enabled then
				local mag = entitylib.isAlive and math.floor((entitylib.character.RootPart.Position - entity.RootPart.Position).Magnitude) or 0
				if Sizes[entity] ~= mag then
					nametag.Text.Text = string.format(Strings[entity], mag)
					nametag.BG.Size = Vector2.new(nametag.Text.TextBounds.X + 8, nametag.Text.TextBounds.Y + 7)
					Sizes[entity] = mag
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
				for _, entity in entitylib.List do
					if Reference[entity] then
						Removed[methodused](entity)
					end
					Added[methodused](entity)
				end
				NameTags:Clean(entitylib.Events.EntityAdded:Connect(function(entity)
					if Reference[entity] then
						Removed[methodused](entity)
					end
					Added[methodused](entity)
				end))
			end
			if Updated[methodused] then
				NameTags:Clean(entitylib.Events.EntityUpdated:Connect(Updated[methodused]))
				for _, entity in entitylib.List do
					Updated[methodused](entity)
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
				for entity in Reference do
					Removed[methodused](entity)
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