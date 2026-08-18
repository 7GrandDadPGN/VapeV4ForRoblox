local component = {
	Buttons = {},
	Type = 'MainWindow'
}

local window = Instance.new('TextButton')
window.AutoButtonColor = false
window.BackgroundColor3 = color.Dark(uipallet.Main, 0.02)
window.Name = 'GUICategory'
window.Position = UDim2.fromOffset(6, 60)
window.Text = ''
window.Parent = clickgui
component.Object = window
addBlur(window)
addCorner(window)
addDragHandler(window)
local logo = Instance.new('ImageLabel')
logo.BackgroundTransparency = 1
logo.Image = getvapeasset('newvape/assets/new/vapelogomini.png')
logo.ImageColor3 = select(3, uipallet.Main:ToHSV()) > 0.5 and uipallet.Text or Color3.new(1, 1, 1)
logo.Name = 'VapeLogo'
logo.Position = UDim2.fromOffset(12, 11)
logo.Size = UDim2.fromOffset(55, 16)
logo.Parent = window
local v4logo = Instance.new('ImageLabel')
v4logo.BackgroundTransparency = 1
v4logo.Image = getvapeasset('newvape/assets/new/v4mini.png')
v4logo.Name = 'V4Logo'
v4logo.Position = UDim2.new(1, -1, 0, 0)
v4logo.Size = UDim2.fromOffset(23, 16)
v4logo.Parent = logo
local children = Instance.new('Frame')
children.BackgroundTransparency = 1
children.Position = UDim2.fromOffset(0, 37)
children.Size = UDim2.new(1, 0, 1, -33)
children.Parent = window
local windowlist = Instance.new('UIListLayout')
windowlist.HorizontalAlignment = Enum.HorizontalAlignment.Center
windowlist.SortOrder = Enum.SortOrder.LayoutOrder
windowlist.Parent = children
local settingsbutton = Instance.new('TextButton')
settingsbutton.BackgroundTransparency = 1
settingsbutton.Position = UDim2.new(1, -40, 0, 0)
settingsbutton.Size = UDim2.fromOffset(40, 40)
settingsbutton.Text = ''
settingsbutton.Parent = window
addTooltip(settingsbutton, 'Open settings')
local settingsicon = Instance.new('ImageLabel')
settingsicon.BackgroundTransparency = 1
settingsicon.Image = getvapeasset('newvape/assets/new/settings.png')
settingsicon.ImageColor3 = color.Light(uipallet.Main, 0.37)
settingsicon.Position = UDim2.fromOffset(15, 12)
settingsicon.Size = UDim2.fromOffset(14, 14)
settingsicon.Parent = settingsbutton
local discord = Instance.new('ImageButton')
discord.BackgroundTransparency = 1
discord.Image = getvapeasset('newvape/assets/new/discord.png')
discord.Position = UDim2.new(1, -56, 0, 11)
discord.Size = UDim2.fromOffset(16, 16)
discord.Parent = window
addTooltip(discord, 'Join discord')
local stroke = Instance.new('UIStroke')
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Color = Color3.fromRGB(85, 85, 85)
stroke.Transparency = 0.8
stroke.Parent = window
local settingspane = components.SettingsPane({
	Name = 'Settings',
	Main = true
}, window, component)
component.Settings = settingspane

function component:Color(hue, sat, val, isRainbow)
	v4logo.ImageColor3 = Color3.fromHSV(hue, sat, val)

	for _, button in self.Buttons do
		if button.Enabled then
			button.Object.TextColor3 = isRainbow and Color3.fromHSV(vape:Color((hue - (button.Index * 0.025)) % 1)) or Color3.fromHSV(hue, sat, val)

			if button.Icon then
				button.Icon.ImageColor3 = button.Object.TextColor3
			end
		end
	end
end

function component:Load(data)
	for name, paneData in data.Settings do
		local pane = vape.Settings[name]
		if pane then
			pane:Load(paneData)
		end
	end

	if data.Position then
		window.Position = UDim2.fromOffset(data.Position.X, data.Position.Y)
	end
end

function component:Save(data)
	data.Main = {
		Position = {
			X = window.Position.X.Offset,
			Y = window.Position.Y.Offset
		},
		Settings = {}
	}

	for name, pane in vape.Settings do
		pane:Save(data.Main.Settings)
	end
end

for index, comp in components do
	component['Create'..index] = function(_, props)
		return comp(props, children, component)
	end
end

discord.MouseButton1Click:Connect(function()
	task.spawn(function()
		local body = httpService:JSONEncode({
			nonce = httpService:GenerateGUID(false),
			args = {
				invite = {code = 'VZEQJxMSnG'},
				code = 'VZEQJxMSnG'
			},
			cmd = 'INVITE_BROWSER'
		})

		for i = 1, 14 do
			task.spawn(function()
				pcall(function()
					request({
						Method = 'POST',
						Url = 'http://127.0.0.1:64'..(53 + i)..'/rpc?v=1',
						Headers = {
							['Content-Type'] = 'application/json',
							Origin = 'https://discord.com'
						},
						Body = body
					})
				end)
			end)
		end
	end)

	task.spawn(function()
		tooltip.Text = 'Copied!'
		setclipboard('https://discord.gg/VZEQJxMSnG')
	end)
end)

settingsbutton.MouseEnter:Connect(function()
	settingsicon.ImageColor3 = uipallet.Text
end)

settingsbutton.MouseLeave:Connect(function()
	settingsicon.ImageColor3 = color.Light(uipallet.Main, 0.37)
end)

settingsbutton.MouseButton1Click:Connect(function()
	settingspane.Object.Visible = true
end)

windowlist:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
	if vape.ThreadFix then
		setthreadidentity(8)
	end

	window.Size = UDim2.fromOffset(220, 42 + windowlist.AbsoluteContentSize.Y / scale.Scale)
	for _, button in component.Buttons do
		if button.Icon then
			button.Object.Text = string.rep(' ', 39 * scale.Scale)..button.Name
		end
	end
end)

vape.Categories.Main = component

return component