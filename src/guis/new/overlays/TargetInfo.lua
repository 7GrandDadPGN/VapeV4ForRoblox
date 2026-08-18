--[[
	Target Info
]]

local targetinfo = {
	Targets = {},
	Object = Holder,
	Health = 0,
	MaxHealth = 0
}
local TargetInfoOverlay
local BackgroundTransparency = {
	Value = 0.5,
	Object = {Visible = {}}
}
local BorderColor
local BKGColor
local CustomColor
local DisplayName

TargetInfoOverlay = vape:CreateOverlay({
	Name = 'Target Info',
	Icon = getvapeasset('newvape/assets/new/targetinfo.png'),
	Size = UDim2.fromOffset(14, 14),
	Position = UDim2.fromOffset(12, 14),
	CategorySize = 240,
	Function = function(callback)
		if callback then
			TargetInfoOverlay:Clean(runService.RenderStepped:Connect(function()
				targetinfo:Update()
			end))
		end
	end
})

local Holder = Instance.new('Frame')
Holder.Size = UDim2.fromOffset(240, 89)
Holder.BackgroundColor3 = color.Dark(uipallet.Main, 0.1)
Holder.BackgroundTransparency = 0.5
Holder.Parent = TargetInfoOverlay.Children
local BlurHolder = addBlur(Holder, nil, true)
BlurHolder.Visible = false
addCorner(Holder)
local Headshot = Instance.new('ImageLabel')
Headshot.Size = UDim2.fromOffset(26, 27)
Headshot.Position = UDim2.fromOffset(19, 17)
Headshot.BackgroundColor3 = uipallet.Main
Headshot.Image = 'rbxthumb://type=AvatarHeadShot&id=1&w=420&h=420'
Headshot.Parent = Holder
addCorner(Headshot)
local HurtFlash = Instance.new('Frame')
HurtFlash.Size = UDim2.fromScale(1, 1)
HurtFlash.BackgroundTransparency = 1
HurtFlash.BackgroundColor3 = Color3.new(1, 0, 0)
HurtFlash.Parent = Headshot
addCorner(HurtFlash)
local HeadshotBlur = addBlur(Headshot)
HeadshotBlur.Enabled = false
local Name = Instance.new('TextLabel')
Name.Size = UDim2.fromOffset(145, 20)
Name.Position = UDim2.fromOffset(54, 20)
Name.BackgroundTransparency = 1
Name.Text = 'Target name'
Name.TextXAlignment = Enum.TextXAlignment.Left
Name.TextYAlignment = Enum.TextYAlignment.Top
Name.TextScaled = true
Name.TextColor3 = color.Light(uipallet.Text, 0.4)
Name.TextStrokeTransparency = 1
Name.FontFace = uipallet.Font
local NameShadow = Name:Clone()
NameShadow.Position = UDim2.fromOffset(55, 21)
NameShadow.TextColor3 = Color3.new()
NameShadow.TextTransparency = 0.65
NameShadow.Visible = false
NameShadow.Parent = Holder
for _, prop in {'Size', 'Text', 'FontFace'} do
	Name:GetPropertyChangedSignal(prop):Connect(function()
		NameShadow[prop] = Name[prop]
	end)
end
Name.Parent = Holder
local HealthBKG = Instance.new('Frame')
HealthBKG.Name = 'HealthBKG'
HealthBKG.Size = UDim2.fromOffset(200, 9)
HealthBKG.Position = UDim2.fromOffset(20, 56)
HealthBKG.BackgroundColor3 = uipallet.Main
HealthBKG.BorderSizePixel = 0
HealthBKG.Parent = Holder
addCorner(HealthBKG, UDim.new(1, 0))
local Health = HealthBKG:Clone()
Health.Size = UDim2.fromScale(0.8, 1)
Health.Position = UDim2.new()
Health.BackgroundColor3 = Color3.fromHSV(1 / 2.5, 0.89, 0.75)
Health.Parent = HealthBKG
Health:GetPropertyChangedSignal('Size'):Connect(function()
	Health.Visible = Health.Size.X.Scale > 0.01
end)
local Armor = Health:Clone()
Armor.Size = UDim2.new()
Armor.Position = UDim2.fromScale(1, 0)
Armor.AnchorPoint = Vector2.new(1, 0)
Armor.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
Armor.Visible = false
Armor.Parent = HealthBKG
Armor:GetPropertyChangedSignal('Size'):Connect(function()
	Armor.Visible = Armor.Size.X.Scale > 0.01
end)
local HealthBlur = addBlur(HealthBKG)
HealthBlur.Enabled = false
local Stroke = Instance.new('UIStroke')
Stroke.Enabled = false
Stroke.Color = Color3.fromHSV(0.44, 1, 1)
Stroke.Parent = Holder

TargetInfoOverlay:CreateFont({
	Name = 'Font',
	Default = 'Arial',
	Function = function(val)
		Name.FontFace = val
	end
})
DisplayName = TargetInfoOverlay:CreateToggle({
	Name = 'Use Displayname',
	Default = true
})
TargetInfoOverlay:CreateToggle({
	Name = 'Render Background',
	Function = function(callback)
		Holder.BackgroundTransparency = callback and BackgroundTransparency.Value or 1
		NameShadow.Visible = not callback
		BlurHolder.Visible = callback
		HealthBlur.Enabled = not callback
		HeadshotBlur.Enabled = not callback
		BackgroundTransparency.Object.Visible = callback
	end,
	Default = true
})
BackgroundTransparency = TargetInfoOverlay:CreateSlider({
	Name = 'Transparency',
	Min = 0,
	Max = 1,
	Default = 0.5,
	Decimal = 10,
	Function = function(val)
		Holder.BackgroundTransparency = val
	end,
	Darker = true
})
CustomColor = TargetInfoOverlay:CreateToggle({
	Name = 'Custom Color',
	Function = function(callback)
		BKGColor.Object.Visible = callback
		if callback then
			Holder.BackgroundColor3 = Color3.fromHSV(BKGColor.Hue, BKGColor.Sat, BKGColor.Value)
			Headshot.BackgroundColor3 = Color3.fromHSV(BKGColor.Hue, BKGColor.Sat, math.max(BKGColor.Value - 0.1, 0.075))
			HealthBKG.BackgroundColor3 = Headshot.BackgroundColor3
		else
			Holder.BackgroundColor3 = color.Dark(uipallet.Main, 0.1)
			Headshot.BackgroundColor3 = uipallet.Main
			HealthBKG.BackgroundColor3 = uipallet.Main
		end
	end
})
BKGColor = TargetInfoOverlay:CreateColorSlider({
	Name = 'Color',
	Function = function(hue, sat, val)
		if CustomColor.Enabled then
			Holder.BackgroundColor3 = Color3.fromHSV(hue, sat, val)
			Headshot.BackgroundColor3 = Color3.fromHSV(hue, sat, math.max(val - 0.1, 0))
			HealthBKG.BackgroundColor3 = Headshot.BackgroundColor3
		end
	end,
	Darker = true,
	Visible = false
})
TargetInfoOverlay:CreateToggle({
	Name = 'Border',
	Function = function(callback)
		Stroke.Enabled = callback
		BorderColor.Object.Visible = callback
	end
})
BorderColor = TargetInfoOverlay:CreateColorSlider({
	Name = 'Border Color',
	Function = function(hue, sat, val, opacity)
		Stroke.Color = Color3.fromHSV(hue, sat, val)
		Stroke.Transparency = 1 - opacity
	end,
	Darker = true,
	Visible = false
})

function targetinfo:Update()
	local entitylib = vape.Libraries
	if not entitylib then return end

	local cloned = table.clone(self.Targets)
	for index, expire in cloned do
		if expire < tick() then
			self.Targets[index] = nil
		end
	end
	table.clear(cloned)

	local entity, highest = nil, tick()
	for index, level in self.Targets do
		if level > highest then
			entity = index
			highest = level
		end
	end

	Holder.Visible = entity ~= nil or clickgui.Visible
	if entity then
		Name.Text = entity.Player and (DisplayName.Enabled and entity.Player.DisplayName or entity.Player.Name) or entity.Character and entity.Character.Name or Name.Text
		Headshot.Image = 'rbxthumb://type=AvatarHeadShot&id='..(entity.Player and entity.Player.UserId or 1)..'&w=420&h=420'

		if not entity.Character then
			entity.Health = entity.Health or 0
			entity.MaxHealth = entity.MaxHealth or 100
		end

		if entity.Health ~= self.Health or entity.MaxHealth ~= self.MaxHealth then
			local percent = math.max(entity.Health / entity.MaxHealth, 0)

			tween:Tween(Health, TweenInfo.new(0.3), {
				Size = UDim2.fromScale(math.min(percent, 1), 1), BackgroundColor3 = Color3.fromHSV(math.clamp(percent / 2.5, 0, 1), 0.89, 0.75)
			})

			tween:Tween(Armor, TweenInfo.new(0.3), {
				Size = UDim2.fromScale(math.clamp(percent - 1, 0, 0.8), 1)
			})

			if self.Health > entity.Health and self.LastTarget == entity then
				tween:Cancel(HurtFlash)
				HurtFlash.BackgroundTransparency = 0.3
				tween:Tween(HurtFlash, TweenInfo.new(0.5), {
					BackgroundTransparency = 1
				})
			end

			self.Health = entity.Health
			self.MaxHealth = entity.MaxHealth
		end

		if not entity.Character then
			table.clear(entity)
		end

		self.LastTarget = entity
	end
end

vape.Libraries.targetinfo = targetinfo