local Sort
local FontOption
local ColorSlider
local ColorMode
local Scale
local Shadow
local Gradient
local GradientV4
local Animations
local Watermark
local Background
local BackgroundTransparency
local BackgroundTint
local HideModules
local HideModulesList
local HideRender
local CustomText
local CustomTextBox
local CustomTextFont
local CustomTextColor
local CustomTextColorSlider
local Labels = {}
local info = TweenInfo.new(0.3, Enum.EasingStyle.Exponential)

local function findValidLabel(labels, index, dir)
	local label = labels[index + dir]
	if label then
		if label.Size ~= UDim2.fromOffset() then
			return label
		else
			return findValidLabel(labels, index + dir, dir)
		end
	end
end

TextGUI = vape:CreateOverlay({
	Name = 'Text GUI',
	Icon = getvapeasset('newvape/assets/new/textgui.png'),
	Size = UDim2.fromOffset(16, 12),
	Position = UDim2.fromOffset(12, 14),
	Function = function()
		vape:UpdateTextGUI()
	end
})
Sort = TextGUI:CreateDropdown({
	Name = 'Sort',
	List = {'Alphabetical', 'Length'},
	Function = function()
		vape:UpdateTextGUI()
	end
})
FontOption = TextGUI:CreateFont({
	Name = 'Font',
	Default = 'Arial',
	Function = function()
		vape:UpdateTextGUI()
	end
})
ColorMode = TextGUI:CreateDropdown({
	Name = 'Color Mode',
	List = {'Match GUI color', 'Custom color'},
	Function = function(value)
		ColorSlider.Object.Visible = value == 'Custom color'
		vape:UpdateTextGUI()
	end
})
ColorSlider = TextGUI:CreateColorSlider({
	Name = 'Text GUI color',
	Function = function()
		vape:UpdateGUI()
	end,
	Darker = true,
	Visible = false
})
TextGUI:CreateSlider({
	Name = 'Scale',
	Min = 0,
	Max = 2,
	Decimal = 10,
	Default = 1,
	Function = function(val)
		Scale.Scale = val
		vape:UpdateTextGUI()
	end
})
Shadow = TextGUI:CreateToggle({
	Name = 'Shadow',
	Tooltip = 'Renders shadowed text.',
	Function = function()
		vape:UpdateTextGUI()
	end
})
Gradient = TextGUI:CreateToggle({
	Name = 'Gradient',
	Tooltip = 'Renders a gradient',
	Function = function(callback)
		GradientV4.Object.Visible = callback
		vape:UpdateTextGUI()
	end
})
GradientV4 = TextGUI:CreateToggle({
	Name = 'V4 Gradient',
	Function = function()
		vape:UpdateTextGUI()
	end,
	Darker = true,
	Visible = false
})
Animations = TextGUI:CreateToggle({
	Name = 'Animations',
	Tooltip = 'Use animations on text gui',
	Function = function()
		vape:UpdateTextGUI()
	end
})
Watermark = TextGUI:CreateToggle({
	Name = 'Watermark',
	Tooltip = 'Renders a vape watermark',
	Function = function()
		vape:UpdateTextGUI()
	end
})
Background = TextGUI:CreateToggle({
	Name = 'Render background',
	Function = function(callback)
		BackgroundTransparency.Object.Visible = callback
		BackgroundTint.Object.Visible = callback
		vape:UpdateTextGUI()
	end
})
BackgroundTransparency = TextGUI:CreateSlider({
	Name = 'Transparency',
	Min = 0,
	Max = 1,
	Default = 0.5,
	Decimal = 10,
	Function = function()
		vape:UpdateTextGUI()
	end,
	Darker = true,
	Visible = false
})
BackgroundTint = TextGUI:CreateToggle({
	Name = 'Tint',
	Function = function()
		vape:UpdateTextGUI()
	end,
	Darker = true,
	Visible = false
})
HideModules = TextGUI:CreateToggle({
	Name = 'Hide modules',
	Tooltip = 'Allows you to blacklist certain modules from being shown.',
	Function = function(enabled)
		HideModulesList.Object.Visible = enabled
		vape:UpdateTextGUI()
	end
})
HideModulesList = TextGUI:CreateTextList({
	Name = 'Blacklist',
	Tooltip = 'Name of module to hide.',
	Color = Color3.fromRGB(250, 50, 56),
	Function = function()
		vape:UpdateTextGUI()
	end,
	Visible = false,
	Darker = true
})
HideRender = TextGUI:CreateToggle({
	Name = 'Hide render',
	Function = function()
		vape:UpdateTextGUI()
	end
})
CustomText = TextGUI:CreateToggle({
	Name = 'Add custom text',
	Function = function(enabled)
		CustomTextBox.Object.Visible = enabled
		CustomTextFont.Object.Visible = enabled
		CustomTextColor.Object.Visible = enabled
		CustomTextColorSlider.Object.Visible = CustomTextColor.Enabled and enabled
		vape:UpdateTextGUI()
	end
})
CustomTextBox = TextGUI:CreateTextBox({
	Name = 'Custom text',
	Function = function()
		vape:UpdateTextGUI()
	end,
	Darker = true,
	Visible = false
})
CustomTextFont = TextGUI:CreateFont({
	Name = 'Custom Font',
	Default = 'Arial',
	Function = function()
		vape:UpdateTextGUI()
	end,
	Darker = true,
	Visible = false
})
CustomTextColor = TextGUI:CreateToggle({
	Name = 'Set custom text color',
	Function = function(enabled)
		CustomTextColorSlider.Object.Visible = enabled
		vape:UpdateGUI()
	end,
	Darker = true,
	Visible = false
})
CustomTextColorSlider = TextGUI:CreateColorSlider({
	Name = 'Color of custom text',
	Function = function(afterload)
		vape:UpdateGUI()
	end,
	Darker = true,
	Visible = false
})


--[[
	Text GUI Objects
]]

Scale = Instance.new('UIScale')
Scale.Parent = TextGUI.Children
local Logo = Instance.new('ImageLabel')
Logo.BackgroundColor3 = Color3.new()
Logo.BackgroundTransparency = 1
Logo.BorderSizePixel = 0
Logo.Image = getvapeasset('newvape/assets/new/vapelogo.png')
Logo.Name = 'Logo'
Logo.Position = UDim2.new(1, -142, 0, 3)
Logo.Size = UDim2.fromOffset(81, 24)
Logo.Visible = false
Logo.Parent = TextGUI.Children
local LogoV4 = Instance.new('ImageLabel')
LogoV4.BackgroundColor3 = Color3.new()
LogoV4.BackgroundTransparency = 1
LogoV4.BorderSizePixel = 0
LogoV4.Image = getvapeasset('newvape/assets/new/v4.png')
LogoV4.Name = 'Logo2'
LogoV4.Position = UDim2.new(1, -1, 0, 0)
LogoV4.Size = UDim2.fromOffset(35, 24)
LogoV4.Parent = Logo
local LogoShadow = Logo:Clone()
LogoShadow.ImageColor3 = Color3.new()
LogoShadow.ImageTransparency = 0.65
LogoShadow.Position = UDim2.fromOffset(1, 1)
LogoShadow.Visible = true
LogoShadow.ZIndex = 0
LogoShadow.Parent = Logo
LogoShadow.Logo2.ImageColor3 = Color3.new()
LogoShadow.Logo2.ImageTransparency = 0.65
LogoShadow.Logo2.ZIndex = 0
local LogoGradient = Instance.new('UIGradient')
LogoGradient.Rotation = 90
LogoGradient.Parent = Logo
local LogoGradient2 = Instance.new('UIGradient')
LogoGradient2.Rotation = 90
LogoGradient2.Parent = LogoV4
local LabelCustom = Instance.new('TextLabel')
LabelCustom.BackgroundTransparency = 1
LabelCustom.BorderSizePixel = 0
LabelCustom.FontFace = CustomTextFont.Value
LabelCustom.Position = UDim2.fromOffset(5, 2)
LabelCustom.Text = ''
LabelCustom.TextSize = 25
LabelCustom.Visible = false
LabelCustom.RichText = true
local LabelCustomShadow = LabelCustom:Clone()
LabelCustomShadow.TextColor3 = Color3.new()
LabelCustomShadow.TextTransparency = 0.65
LabelCustomShadow.Parent = TextGUI.Children
LabelCustom.Parent = TextGUI.Children
local LabelHolder = Instance.new('Frame')
LabelHolder.Name = 'Holder'
LabelHolder.Size = UDim2.fromScale(1, 1)
LabelHolder.Position = UDim2.fromOffset(5, 37)
LabelHolder.BackgroundTransparency = 1
LabelHolder.Parent = TextGUI.Children
local ListLayout = Instance.new('UIListLayout')
ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
ListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Parent = LabelHolder

LabelCustom:GetPropertyChangedSignal('Position'):Connect(function()
	LabelCustomShadow.Position = UDim2.new(
		LabelCustom.Position.X.Scale,
		LabelCustom.Position.X.Offset + 1,
		0,
		LabelCustom.Position.Y.Offset + 1
	)
end)

LabelCustom:GetPropertyChangedSignal('FontFace'):Connect(function()
	LabelCustomShadow.FontFace = LabelCustom.FontFace
end)

LabelCustom:GetPropertyChangedSignal('Text'):Connect(function()
	LabelCustomShadow.Text = LabelCustom.ContentText
end)

LabelCustom:GetPropertyChangedSignal('Size'):Connect(function()
	LabelCustomShadow.Size = LabelCustom.Size
end)

local oldRight = TextGUI.Children.AbsolutePosition.X > (gui.AbsoluteSize.X / 2)
vape:Clean(TextGUI.Children:GetPropertyChangedSignal('AbsolutePosition'):Connect(function()
	if vape.ThreadFix then
		setthreadidentity(8)
	end

	local isRight = TextGUI.Children.AbsolutePosition.X > (gui.AbsoluteSize.X / 2)
	if oldRight ~= isRight then
		vape:UpdateTextGUI()
		oldRight = isRight
	end
end))

function vape:UpdateTextGUI(afterload)
	if not afterload and not vape.Loaded then return end
	if TextGUI.Button.Enabled then
		local isRight = TextGUI.Children.AbsolutePosition.X > (gui.AbsoluteSize.X / 2)

		Logo.Visible = Watermark.Enabled
		Logo.Position = isRight and UDim2.new(1 / Scale.Scale, -113, 0, 6) or UDim2.fromOffset(0, 6)
		LogoShadow.Visible = Shadow.Enabled
		LabelCustom.Text = CustomTextBox.Value
		LabelCustom.FontFace = CustomTextFont.Value
		LabelCustom.Visible = LabelCustom.Text ~= '' and CustomText.Enabled
		LabelCustomShadow.Visible = LabelCustom.Visible and Shadow.Enabled
		ListLayout.HorizontalAlignment = isRight and Enum.HorizontalAlignment.Right or Enum.HorizontalAlignment.Left
		LabelHolder.Size = UDim2.fromScale(1 / Scale.Scale, 1)
		LabelHolder.Position = UDim2.fromOffset(isRight and 3 or 0, 11 + (Logo.Visible and Logo.Size.Y.Offset or 0) + (LabelCustom.Visible and 28 or 0) + (Background.Enabled and 3 or 0))

		if LabelCustom.Visible then
			local size = getfontbounds(LabelCustom.ContentText, LabelCustom.TextSize, LabelCustom.FontFace)
			LabelCustom.Size = UDim2.fromOffset(size.X, size.Y)
			LabelCustom.Position = UDim2.new(isRight and 1 / Scale.Scale or 0, isRight and -size.X or 0, 0, (Logo.Visible and 32 or 8))
		end

		local Previous = {}
		for _, label in Labels do
			if label.Enabled then
				table.insert(Previous, label.Object.Name)
			end

			label.Object:Destroy()
		end
		table.clear(Labels)

		for name, module in vape.Modules do
			if HideModules.Enabled and table.find(HideModulesList.ListEnabled, name) then
				continue
			end

			if HideRender.Enabled and module.Category == 'Render' then
				continue
			end

			if module.Enabled or table.find(Previous, name) then
				local bkg, colorline
				local holder = Instance.new('Frame')
				holder.BackgroundTransparency = 1
				holder.ClipsDescendants = true
				holder.Name = name
				holder.Size = UDim2.fromOffset()
				holder.Parent = LabelHolder

				if Background.Enabled then
					bkg = Instance.new('Frame')
					bkg.BackgroundColor3 = color.Dark(uipallet.Main, 0.15)
					bkg.BackgroundTransparency = BackgroundTransparency.Value
					bkg.BorderSizePixel = 0
					bkg.Size = UDim2.new(1, 0, 1, 0)
					bkg.Parent = holder
					local corner = Instance.new('UICorner')
					corner.Parent = bkg
					local line = Instance.new('Frame')
					line.BackgroundColor3 = Color3.new()
					line.BackgroundTransparency = 0.928 + (0.072 * math.clamp((BackgroundTransparency.Value - 0.5) / 0.5, 0, 1))
					line.BorderSizePixel = 0
					line.Position = UDim2.new(0, 0, 1, -1)
					line.Size = UDim2.new(1, 0, 0, 1)
					line.Parent = bkg
					local line2 = line:Clone()
					line2.Position = UDim2.new()
					line2.Name = 'Line'
					line2.Parent = bkg
					colorline = Instance.new('Frame')
					colorline.BorderSizePixel = 0
					colorline.Position = isRight and UDim2.new(1, -4, 0, 0) or UDim2.new()
					colorline.Size = UDim2.new(0, 4, 1, 0)
					colorline.Parent = bkg
					local colorcorner = Instance.new('UICorner')
					colorcorner.CornerRadius = UDim.new()
					colorcorner.Parent = colorline
				end

				local label = Instance.new('TextLabel')
				label.BackgroundTransparency = 1
				label.BorderSizePixel = 0
				label.FontFace = FontOption.Value
				label.Position = UDim2.fromOffset(isRight and 5 or 9, 2)
				label.Text = name..(module.ExtraText and " <font color='#A8A8A8'>"..module.ExtraText()..'</font>' or '')
				label.TextSize = 18
				label.RichText = true

				local size = getfontbounds(label.ContentText, label.TextSize, label.FontFace)
				label.Size = UDim2.fromOffset(size.X, size.Y)

				if Shadow.Enabled then
					local shadowlabel = label:Clone()
					shadowlabel.Position = UDim2.fromOffset(label.Position.X.Offset + 1, label.Position.Y.Offset + 1)
					shadowlabel.Text = label.ContentText
					shadowlabel.TextColor3 = Color3.new()
					shadowlabel.Parent = holder
				end

				label.Parent = holder

				local tweenSize = UDim2.fromOffset(size.X + 16, size.Y + 6)
				if Animations.Enabled then
					if not table.find(Previous, name) then
						tween:Tween(holder, info, {
							Size = tweenSize
						})
					else
						holder.Size = tweenSize
						if not module.Enabled then
							tween:Tween(holder, info, {
								Size = UDim2.fromOffset()
							})
						end
					end
				else
					holder.Size = module.Enabled and tweenSize or UDim2.fromOffset()
				end

				table.insert(Labels, {
					Background = bkg,
					Color = colorline,
					Enabled = module.Enabled,
					Object = holder,
					Text = label,
					Size = module.Enabled and tweenSize or UDim2.fromOffset()
				})
			end
		end

		if Sort.Value == 'Alphabetical' then
			table.sort(Labels, function(a, b)
				return a.Text.Text < b.Text.Text
			end)
		else
			table.sort(Labels, function(a, b)
				return a.Text.Size.X.Offset > b.Text.Size.X.Offset
			end)
		end

		for index, label in Labels do
			if label.Color then
				local topLabel = findValidLabel(Labels, index, -1)
				local bottomLabel = findValidLabel(Labels, index, 1)
				local top = (not topLabel or (topLabel.Size.X.Offset < label.Size.X.Offset)) and 4 or 0
				local bottom = (not bottomLabel or (bottomLabel.Size.X.Offset < label.Size.X.Offset)) and 4 or 0

				label.Color.Parent.Line.Visible = index ~= 1
				label.Color.UICorner.TopLeftRadius = isRight and UDim.new() or UDim.new(0, index == 1 and 4 or 0)
				label.Color.UICorner.TopRightRadius = isRight and UDim.new(0, index == 1 and 4 or 0) or UDim.new()
				label.Color.UICorner.BottomLeftRadius = isRight and UDim.new() or UDim.new(0, index == #Labels and 4 or 0)
				label.Color.UICorner.BottomRightRadius = isRight and UDim.new(0, index == #Labels and 4 or 0) or UDim.new()

				label.Background.UICorner.TopLeftRadius = UDim.new(0, top)
				label.Background.UICorner.TopRightRadius = UDim.new(0, top)
				label.Background.UICorner.BottomLeftRadius = UDim.new(0, bottom)
				label.Background.UICorner.BottomRightRadius = UDim.new(0, bottom)
			end

			label.Object.LayoutOrder = index
		end
	end

	self:UpdateGUI()
end

function TextGUI:UpdateColor(hue, sat, val, default)
	LogoGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromHSV(hue, sat, val)),
		ColorSequenceKeypoint.new(1, Gradient.Enabled and Color3.fromHSV(vape:Color((hue - 0.075) % 1)) or Color3.fromHSV(hue, sat, val))
	})
	LogoGradient2.Color = Gradient.Enabled and GradientV4.Enabled and LogoGradient.Color or ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
		ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1))
	})
	LabelCustom.TextColor3 = CustomTextColor.Enabled and Color3.fromHSV(CustomTextColorSlider.Hue, CustomTextColorSlider.Sat, CustomTextColorSlider.Value) or LogoGradient.Color.Keypoints[2].Value

	local isCustom = ColorMode.Value == 'Custom color' and Color3.fromHSV(ColorSlider.Hue, ColorSlider.Sat, ColorSlider.Value) or nil
	for index, label in Labels do
		label.Text.TextColor3 = isCustom or (vape.GUIColor.Rainbow and Color3.fromHSV(vape:Color((hue - ((Gradient.Enabled and index + 2 or index) * 0.025)) % 1)) or LogoGradient.Color.Keypoints[2].Value)

		if label.Color then
			label.Color.BackgroundColor3 = label.Text.TextColor3
		end

		if BackgroundTint.Enabled and label.Background then
			label.Background.BackgroundColor3 = color.Dark(label.Text.TextColor3, 0.75)
		end
	end
end