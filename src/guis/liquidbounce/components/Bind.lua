local bind = Instance.new('TextButton')
bind.Name = 'Bind'
bind.Size = UDim2.new(1, 0, 0, 41)
bind.BackgroundTransparency = 1
bind.Text = ''
bind.Parent = children
--addTooltip(button, optionsettings.Tooltip)
local accentbar = Instance.new('Frame')
accentbar.Size = UDim2.new(0, 4, 1, 0)
accentbar.BackgroundColor3 = uipallet.Main
accentbar.BorderSizePixel = 0
accentbar.Parent = bind
local bkg = Instance.new('Frame')
bkg.Size = UDim2.new(1, -22, 1, -14)
bkg.Position = UDim2.fromOffset(11, 7)
bkg.BackgroundColor3 = uipallet.Main
bkg.Parent = bind
addCorner(bkg, UDim.new(0, 4))
local bkg2 = bkg:Clone()
bkg2.Size = UDim2.new(1, -4, 1, -4)
bkg2.Position = UDim2.fromOffset(2, 2)
bkg2.BackgroundColor3 = Color3.new()
bkg2.Parent = bkg
local label = Instance.new('TextLabel')
label.Size = UDim2.new(1, -4, 1, -4)
label.Position = UDim2.fromOffset(2, 2)
label.BackgroundTransparency = 1
label.Text = 'Bind: None'
label.TextColor3 = uipallet.Text
label.TextSize = 14
label.FontFace = uipallet.FontSemiBold
label.Parent = bkg2

api.Bind = {}
function api:SetBind(tab, mouse)
	if tab.Mobile then
		return
	end

	self.Bind = table.clone(tab)
	label.Text = 'Bind: '..(#tab <= 0 and 'None' or table.concat(tab, ' + '))
end

bind.MouseButton1Click:Connect(function()
	label.Text = 'Press any key'
	mainapi.Binding = api
end)