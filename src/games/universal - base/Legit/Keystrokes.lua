local Keystrokes
local Style
local Color
local keys, holder = {}

local function createKeystroke(keybutton, pos, pos2, text)
	if keys[keybutton] then
		keys[keybutton].Key:Destroy()
		keys[keybutton] = nil
	end

	local key = Instance.new('Frame')
	key.Size = keybutton == Enum.KeyCode.Space and UDim2.new(0, 110, 0, 24) or UDim2.new(0, 34, 0, 36)
	key.BackgroundColor3 = Color3.fromHSV(Color.Hue, Color.Sat, Color.Value)
	key.BackgroundTransparency = 1 - Color.Opacity
	key.Position = pos
	key.Name = keybutton.Name
	key.Parent = holder
	local keytext = Instance.new('TextLabel')
	keytext.BackgroundTransparency = 1
	keytext.Size = UDim2.fromScale(1, 1)
	keytext.Font = Enum.Font.Gotham
	keytext.Text = text or keybutton.Name
	keytext.TextXAlignment = Enum.TextXAlignment.Left
	keytext.TextYAlignment = Enum.TextYAlignment.Top
	keytext.Position = pos2
	keytext.TextSize = keybutton == Enum.KeyCode.Space and 18 or 15
	keytext.TextColor3 = Color3.new(1, 1, 1)
	keytext.Parent = key
	local corner = Instance.new('UICorner')
	corner.CornerRadius = UDim.new(0, 4)
	corner.Parent = key

	keys[keybutton] = {Key = key}
end

local function updateKey(inputType)
	local key = keys[inputType.KeyCode]
	if key then
		if key.Tween then
			key.Tween:Cancel()
		end

		if key.Tween2 then
			key.Tween2:Cancel()
		end

		local pressed = inputType.UserInputState == Enum.UserInputState.Begin
		key.Pressed = pressed
		key.Tween = tweenService:Create(key.Key, TweenInfo.new(0.1), {
			BackgroundColor3 = pressed and Color3.new(1, 1, 1) or Color3.fromHSV(Color.Hue, Color.Sat, Color.Value),
			BackgroundTransparency = pressed and 0 or 1 - Color.Opacity
		})
		key.Tween2 = tweenService:Create(key.Key.TextLabel, TweenInfo.new(0.1), {
			TextColor3 = pressed and Color3.new() or Color3.new(1, 1, 1)
		})
		key.Tween:Play()
		key.Tween2:Play()
	end
end

Keystrokes = vape.Legit:CreateModule({
	Name = 'Keystrokes',
	Function = function(callback)
		if callback then
			createKeystroke(Enum.KeyCode.W, UDim2.new(0, 38, 0, 0), UDim2.new(0, 6, 0, 5), Style.Value == 'Arrow' and '↑' or nil)
			createKeystroke(Enum.KeyCode.S, UDim2.new(0, 38, 0, 42), UDim2.new(0, 8, 0, 5), Style.Value == 'Arrow' and '↓' or nil)
			createKeystroke(Enum.KeyCode.A, UDim2.new(0, 0, 0, 42), UDim2.new(0, 7, 0, 5), Style.Value == 'Arrow' and '←' or nil)
			createKeystroke(Enum.KeyCode.D, UDim2.new(0, 76, 0, 42), UDim2.new(0, 8, 0, 5), Style.Value == 'Arrow' and '→' or nil)

			Keystrokes:Clean(inputService.InputBegan:Connect(updateKey))
			Keystrokes:Clean(inputService.InputEnded:Connect(updateKey))
		end
	end,
	Size = UDim2.fromOffset(110, 176),
	Tooltip = 'Shows movement keys onscreen'
})
holder = Instance.new('Frame')
holder.Size = UDim2.fromScale(1, 1)
holder.BackgroundTransparency = 1
holder.Parent = Keystrokes.Children
Style = Keystrokes:CreateDropdown({
	Name = 'Key Style',
	List = {'Keyboard', 'Arrow'},
	Function = function()
		if Keystrokes.Enabled then
			Keystrokes:Toggle()
			Keystrokes:Toggle()
		end
	end
})
Color = Keystrokes:CreateColorSlider({
	Name = 'Color',
	DefaultValue = 0,
	DefaultOpacity = 0.5,
	Function = function(hue, sat, val, opacity)
		for _, v in keys do
			if not v.Pressed then
				v.Key.BackgroundColor3 = Color3.fromHSV(hue, sat, val)
				v.Key.BackgroundTransparency = 1 - opacity
			end
		end
	end
})
Keystrokes:CreateToggle({
	Name = 'Show Spacebar',
	Function = function(callback)
		Keystrokes.Children.Size = UDim2.fromOffset(110, callback and 107 or 78)

		if callback then
			createKeystroke(Enum.KeyCode.Space, UDim2.new(0, 0, 0, 83), UDim2.new(0, 25, 0, -10), '______')
		else
			keys[Enum.KeyCode.Space].Key:Destroy()
			keys[Enum.KeyCode.Space] = nil
		end
	end,
	Default = true
})