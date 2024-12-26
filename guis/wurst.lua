local mainapi = {
	Connections = {},
	Categories = {},
	GUIColor = {Hue = 0.46, Sat = 0.96, Value = 0.52},
	Keybind = Enum.KeyCode.RightShift,
	Loaded = false,
	Libraries = {},
	Modules = {},
	Notifications = {Enabled = true},
	Place = game.PlaceId,
	Profile = 'default',
	Profiles = {},
	RainbowSpeed = {Value = 1},
	RainbowUpdateSpeed = {Value = 60},
	RainbowTable = {},
	Scale = {Value = 1},
	ToggleNotifications = {Enabled = true},
	ThreadFix = setthreadidentity and true or false,
	Version = '6.35.3',
	Windows = {}
}

local cloneref = cloneref or function(obj) return obj end
local tweenService = cloneref(game:GetService('TweenService'))
local inputService = cloneref(game:GetService('UserInputService'))
local textService = cloneref(game:GetService('TextService'))
local guiService = cloneref(game:GetService('GuiService'))
local runService = cloneref(game:GetService('RunService'))
local httpService = cloneref(game:GetService('HttpService'))

local fontsize = Instance.new('GetTextBoundsParams')
fontsize.Width = math.huge
local notifications
local getcustomasset
local clickgui
local expanded
local moduleholder
local scaledgui
local toolblur
local tooltip
local scale
local gui

local color = {}
local tween = {tweens = {}, tweenstwo = {}}
local uipallet = {
	Main = Color3.fromRGB(64, 64, 64),
	Text = Color3.new(1, 1, 1),
	Font = Font.fromEnum(Enum.Font.SourceSans),
	FontSemiBold = Font.fromEnum(Enum.Font.SourceSans, Enum.FontWeight.SemiBold),
	Tween = TweenInfo.new(0.16, Enum.EasingStyle.Linear)
}

local getcustomassets = {
	['newvape/assets/wurst/triangle.png'] = 'rbxasset://wurst/triangle.png'
}

local isfile = isfile or function(file)
	local suc, res = pcall(function() return readfile(file) end)
	return suc and res ~= nil and res ~= ''
end

local getfontsize = function(text, size, font)
	fontsize.Text = text
	fontsize.Size = size
	if typeof(font) == 'Font' then fontsize.Font = font end
	return textService:GetTextBoundsAsync(fontsize)
end


local function downloadFile(path, func)
	if not isfile(path) then
		local suc, res = pcall(function() return game:HttpGet('https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/'..readfile('newvape/profiles/commit.txt')..'/'..select(1, path:gsub('newvape/', '')), true) end)
		if not suc or res == '404: Not Found' then error(res) end
		if path:find('.lua') then res = '--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.\n'..res end
		writefile(path, res)
	end
	return (func or readfile)(path)
end

getcustomasset = not inputService.TouchEnabled and getcustomasset and function(path)
	return downloadFile(path, getcustomasset)
end or function(path)
	return getcustomassets[path] or ''
end

local function getTableSize(tab)
	local ind = 0
	for _ in tab do ind += 1 end
	return ind
end

local function loopClean(tab)
	for i, v in tab do
		if type(v) == 'table' then loopClean(v) end
		tab[i] = nil
	end
end

local function loadJson(path)
	local suc, res = pcall(function() return httpService:JSONDecode(readfile(path)) end)
	return suc and type(res) == 'table' and res or nil
end

local function makeDraggable(gui, window)
	gui.InputBegan:Connect(function(inputObj)
		if window and not window.Visible then return end
		if (inputObj.UserInputType == Enum.UserInputType.MouseButton1 or inputObj.UserInputType == Enum.UserInputType.Touch) and (inputObj.Position.Y - gui.AbsolutePosition.Y < 40 or window) then
			local dragPosition = Vector2.new(gui.AbsolutePosition.X - inputObj.Position.X, gui.AbsolutePosition.Y - inputObj.Position.Y + guiService:GetGuiInset().Y) / scale.Scale
			local changed = inputService.InputChanged:Connect(function(input)
				if input.UserInputType == (inputObj.UserInputType == Enum.UserInputType.MouseButton1 and Enum.UserInputType.MouseMovement or Enum.UserInputType.Touch) then
					local position = input.Position
					if inputService:IsKeyDown(Enum.KeyCode.LeftShift) then
						dragPosition = (dragPosition // 3) * 3
						position = (position // 3) * 3
					end
					gui.Position = UDim2.fromOffset((position.X / scale.Scale) + dragPosition.X, (position.Y / scale.Scale) + dragPosition.Y)
				end
			end)
			local ended
			ended = inputObj.Changed:Connect(function()
				if inputObj.UserInputState == Enum.UserInputState.End then
					if changed then changed:Disconnect() end
					if ended then ended:Disconnect() end
				end
			end)
		end
	end)
end

local function randomString()
	local array = {}
	for i = 1, math.random(10, 100) do
		array[i] = string.char(math.random(32, 126))
	end
	return table.concat(array)
end

local function removeTags(str)
	str = str:gsub('<br%s*/>', '\n')
	return str:gsub('<[^<>]->', '')
end

do
	local res = isfile("newvape/profiles/color.txt") and loadJson("newvape/profiles/color.txt")
	if res then
		uipallet.Main = res.Main and Color3.fromRGB(unpack(res.Main)) or uipallet.Main
		uipallet.Text = res.Text and Color3.fromRGB(unpack(res.Text)) or uipallet.Text
		uipallet.Font = res.Font and Font.new(res.Font:find('rbxasset') and res.Font or string.format('rbxasset://fonts/families/%s.json', res.Font)) or uipallet.Font
		uipallet.FontSemiBold = Font.new(uipallet.Font.Family, Enum.FontWeight.SemiBold)
	end
	fontsize.Font = uipallet.Font
end

do
	color.Dark = function(color, num)
		local h, s, v = color:ToHSV()
		local _, _, compare = uipallet.Main:ToHSV()
		return Color3.fromHSV(h, s, math.clamp(compare > 0.5 and v + num or v - num, 0, 1))
	end

	color.Light = function(color, num)
		local h, s, v = color:ToHSV()
		local _, _, compare = uipallet.Main:ToHSV()
		return Color3.fromHSV(h, s, math.clamp(compare > 0.5 and v - num or v + num, 0, 1))
	end

	function mainapi:Color(h)
		local s = 0.75 + (0.15 * math.min(h / 0.03, 1))
		if h > 0.57 then s = 0.9 - (0.4 * math.min((h - 0.57) / 0.09, 1)) end
		if h > 0.66 then s = 0.5 + (0.4 * math.min((h - 0.66) / 0.16, 1)) end
		if h > 0.87 then s = 0.9 - (0.15 * math.min((h - 0.87) / 0.13, 1)) end
		return h, s, 1
	end

	function mainapi:TextColor(h, s, v)
		if v < 0.7 then return Color3.new(1, 1, 1) end
		if s < 0.6 or h > 0.04 and h < 0.56 then return Color3.new(0.19, 0.19, 0.19) end
		return Color3.new(1, 1, 1)
	end
end

do
	function tween:Tween(obj, tweeninfo, goal, tab)
		tab = tab or self.tweens
		if tab[obj] then tab[obj]:Cancel() end
		if obj.Parent and obj.Visible then
			tab[obj] = tweenService:Create(obj, tweeninfo, goal)
			tab[obj].Completed:Once(function()
				if tab then
					tab[obj] = nil
					tab = nil
				end
			end)
			tab[obj]:Play()
		else
			for i, v in goal do obj[i] = v end
		end
	end

	function tween:Cancel(obj)
		if self.tweens[obj] then
			self.tweens[obj]:Cancel()
			self.tweens[obj] = nil
		end
	end
end

mainapi.Libraries = {
	color = color,
	getcustomasset = getcustomasset,
	getfontsize = getfontsize,
	tween = tween,
	uipallet = uipallet,
}

local components
components = {
	Divider = function(children, text)
		local divider = Instance.new('Frame')
		divider.Name = 'Divider'
		divider.Size = UDim2.new(1, 0, 0, 1)
		divider.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
		divider.BorderSizePixel = 0
		divider.Parent = children
		if text then
			local label = Instance.new('TextLabel')
			label.Name = 'DividerLabel'
			label.Size = UDim2.fromOffset(218, 27)
			label.BackgroundTransparency = 1
			label.Text = '          '..text:upper()
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.TextColor3 = color.Dark(uipallet.Text, 0.43)
			label.TextSize = 9
			label.FontFace = uipallet.Font
			label.Parent = children
			divider.Position = UDim2.fromOffset(0, 26)
			divider.Parent = label
		end
	end
}

mainapi.Components = setmetatable(components, {
	__newindex = function(self, ind, func)
		for _, v in mainapi.Modules do
			rawset(v, 'Create'..ind, function(_, settings)
				return func(settings, v.Children, v)
			end)
		end
		if mainapi.Legit then
			for _, v in mainapi.Legit.Modules do
				rawset(v, 'Create'..ind, function(_, settings)
					return func(settings, v.Children, v)
				end)
			end
		end
		rawset(self, ind, func)
	end
})

task.spawn(function()
	repeat
		local hue = tick() * (0.2 * mainapi.RainbowSpeed.Value) % 1
		for _, v in mainapi.RainbowTable do
			if v.Type == 'GUISlider' then
				v:SetValue(mainapi:Color(hue))
			else
				v:SetValue(hue)
			end
		end
		task.wait(1 / mainapi.RainbowUpdateSpeed.Value)
	until mainapi.Loaded == nil
end)

function mainapi:UpdateTextGUI() end
function mainapi:UpdateGUI() end
function mainapi:Load() self.Loaded = true end
function mainapi:Save() end
function mainapi:CreateNotification() end

function mainapi:Clean(obj)
	if typeof(obj) == 'Instance' then
		table.insert(self.Connections, {Disconnect = function()
			obj:ClearAllChildren()
			obj:Destroy()
		end})
		return
	elseif type(obj) == 'function' then
		table.insert(self.Connections, {Disconnect = obj})
		return
	end
	table.insert(self.Connections, obj)
end

function mainapi:CreateCategory(categorysettings)
	local categoryapi = {Type = 'Category'}

	function categoryapi:CreateModule(modulesettings)
		local moduleapi = {Enabled = false, Options = {}, Bind = '', Connections = {}, Index = modulesettings.Index or getTableSize(mainapi.Modules), ExtraText = modulesettings.ExtraText, Name = modulesettings.Name, Category = categorysettings.Name}
		--mainapi:Remove(modulesettings.Name)

		local modulebutton = Instance.new('TextButton')
		modulebutton.BackgroundColor3 = uipallet.Main
		modulebutton.BackgroundTransparency = 0.75
		modulebutton.BorderSizePixel = 0
		modulebutton.Text = '   '..modulesettings.Name
		modulebutton.TextXAlignment = Enum.TextXAlignment.Left
		modulebutton.TextYAlignment = Enum.TextYAlignment.Center
		modulebutton.TextColor3 = uipallet.Text
		modulebutton.TextSize = 36
		modulebutton.FontFace = uipallet.Font
		modulebutton.Parent = moduleholder
		local stroke = Instance.new('UIStroke')
		stroke.Color = color.Dark(uipallet.Main, 0.75)
		stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		stroke.Thickness = 1
		stroke.Transparency = 0.25
		stroke.Parent = modulebutton
		local line = Instance.new('Frame')
		line.Size = UDim2.fromOffset(1, 36)
		line.Position = UDim2.new(1, -49, 0, 6)
		line.BackgroundColor3 = stroke.Color
		line.BackgroundTransparency = 0.39
		line.BorderSizePixel = 0
		line.Parent = modulebutton
		local triangle = Instance.new('ImageButton')
		triangle.Size = UDim2.fromOffset(28, 16)
		triangle.Position = UDim2.new(1, -38, 0, 16)
		triangle.BackgroundTransparency = 1
		triangle.Image = getcustomasset('newvape/assets/wurst/triangle.png')
		triangle.AutoButtonColor = false
		triangle.Parent = modulebutton
		local modulechildren = Instance.new('ScrollingFrame')
		modulechildren.Name = modulesettings.Name..'Children'
		modulechildren.Size = UDim2.new()
		modulechildren.Position = UDim2.fromScale(0.5, 0.5)
		modulechildren.AnchorPoint = Vector2.new(0.5, 0.5)
		modulechildren.BackgroundColor3 = uipallet.Main
		modulechildren.BackgroundTransparency = 0.75
		modulechildren.BorderSizePixel = 0
		modulechildren.Visible = false
		modulechildren.Parent = clickgui
		moduleapi.Children = modulechildren
		local windowlist = Instance.new('UIListLayout')
		windowlist.SortOrder = Enum.SortOrder.LayoutOrder
		windowlist.HorizontalAlignment = Enum.HorizontalAlignment.Center
		windowlist.Parent = modulechildren
		local title = Instance.new('TextLabel')
		title.Parent = modulechildren
		local description = Instance.new('TextLabel')
		description.BackgroundTransparency = 1
		description.Text = 'Type: Hack, Category: '..moduleapi.Category..'\n\nDescription:\n'..(modulesettings.Tooltip or 'None')..'\n\nSettings:'
		description.TextXAlignment = Enum.TextXAlignment.Left
		description.TextYAlignment = Enum.TextYAlignment.Top
		description.TextColor3 = uipallet.Text
		description.TextSize = 28
		description.FontFace = uipallet.Font
		description.Size = UDim2.new(1, -10, 0, getfontsize(description.Text, description.TextSize).Y)
		description.Parent = modulechildren

		function moduleapi:Clean(obj)
			if typeof(obj) == 'Instance' then
				table.insert(self.Connections, {Disconnect = function()
					obj:ClearAllChildren()
					obj:Destroy()
				end})
				return
			elseif type(obj) == 'function' then
				table.insert(self.Connections, {Disconnect = obj})
				return
			end
			table.insert(self.Connections, obj)
		end

		function moduleapi:Expand()
			modulechildren.Visible = true
			modulechildren.Size = moduleholder.Visible and UDim2.new() or UDim2.new(0, 924, 1, -306)
			tween:Tween(modulechildren, TweenInfo.new(0.4, Enum.EasingStyle.Linear), {Size = moduleholder.Visible and UDim2.new(0, 924, 1, -306) or UDim2.new()})
			expanded = moduleholder.Visible and self or nil

			local visibletable = {}
			description.Visible = false
			for _, option in self.Options do
				visibletable[option.Object] = option.Object.Visible
				option.Object.Visible = false
			end

			if moduleholder.Visible then
				moduleholder.Visible = false
				task.delay(0.4, function()
					description.Visible = true
					for i, v in visibletable do
						i.Visible = v
					end
				end)
			else
				task.delay(0.4, function()
					for i, v in visibletable do
						i.Visible = v
					end
					moduleholder.Visible = true
					modulechildren.Visible = false
				end)
			end
		end

		function moduleapi:SetBind(val, mouse)
			if type(val) == 'table' then
				createMobileButton(object, Vector2.new(v.Bind.X, v.Bind.Y))
				return
			end

			self.Bind = val
		end

		function moduleapi:Toggle(multiple)
			if mainapi.ThreadFix then setthreadidentity(8) end
			self.Enabled = not self.Enabled
			modulebutton.BackgroundColor3 = self.Enabled and Color3.new(0, 1, 0) or uipallet.Main
			if not self.Enabled then
				for _, v in self.Connections do v:Disconnect() end
				table.clear(self.Connections)
			end
			if not multiple then mainapi:UpdateTextGUI() end
			task.spawn(modulesettings.Function, self.Enabled)
		end

		for i, v in components do
			moduleapi['Create'..i] = function(self, optionsettings)
				return v(optionsettings, modulechildren, moduleapi)
			end
		end

		modulebutton.MouseButton1Click:Connect(function()
			moduleapi:Toggle()
		end)
		modulebutton.MouseButton2Click:Connect(function()
			moduleapi:Expand()
		end)
		triangle.MouseButton1Click:Connect(function()
			moduleapi:Expand()
		end)
		windowlist:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
			if mainapi.ThreadFix then setthreadidentity(8) end
			modulechildren.CanvasSize = UDim2.new(0, 0, 0, windowlist.AbsoluteContentSize.Y / scale.Scale)
		end)

		moduleapi.Object = modulebutton
		mainapi.Modules[modulesettings.Name] = moduleapi

		local sorted = {}
		for i in mainapi.Modules do
			table.insert(sorted, i)
		end

		table.sort(sorted, function(a, b) return a > b end)

		for i, v in sorted do
			mainapi.Modules[v].Index = i
			mainapi.Modules[v].Object.LayoutOrder = i
		end

		return moduleapi
	end

	self.Categories[categorysettings.Name] = categoryapi

	return categoryapi
end

gui = Instance.new('ScreenGui')
gui.Name = randomString()
gui.DisplayOrder = 9999999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
gui.IgnoreGuiInset = true
gui.OnTopOfCoreBlur = true
if mainapi.ThreadFix then
	gui.Parent = (gethui and gethui()) or cloneref(game:GetService('CoreGui'))
else
	gui.Parent = cloneref(game:GetService('Players')).LocalPlayer.PlayerGui
	gui.ResetOnSpawn = false
end
mainapi.gui = gui
scaledgui = Instance.new('Frame')
scaledgui.Name = 'ScaledGui'
scaledgui.Size = UDim2.fromScale(1, 1)
scaledgui.BackgroundTransparency = 1
scaledgui.Parent = gui
clickgui = Instance.new('TextButton')
clickgui.Name = 'ClickGui'
clickgui.Size = UDim2.fromScale(1, 1)
clickgui.BackgroundTransparency = 1
clickgui.Text = ''
clickgui.Visible = false
clickgui.Parent = scaledgui
moduleholder = Instance.new('ScrollingFrame')
moduleholder.Size = UDim2.new(1, -306, 1, -306)
moduleholder.Position = UDim2.fromScale(0.5, 0.5)
moduleholder.AnchorPoint = Vector2.new(0.5, 0.5)
moduleholder.BackgroundTransparency = 1
moduleholder.BorderSizePixel = 0
moduleholder.Parent = clickgui
local modulegrid = Instance.new('UIGridLayout')
modulegrid.SortOrder = Enum.SortOrder.LayoutOrder
modulegrid.FillDirection = Enum.FillDirection.Horizontal
modulegrid.FillDirectionMaxCells = 3
modulegrid.CellPadding = UDim2.fromOffset(12, 12)
modulegrid.CellSize = UDim2.fromOffset(300, 48)
modulegrid.HorizontalAlignment = Enum.HorizontalAlignment.Center
modulegrid.VerticalAlignment = Enum.VerticalAlignment.Center
modulegrid.Parent = moduleholder
local modal = Instance.new('TextButton')
modal.BackgroundTransparency = 1
modal.Modal = true
modal.Text = ''
modal.Parent = clickgui
local cursor = Instance.new('ImageLabel')
cursor.Size = UDim2.fromOffset(64, 64)
cursor.BackgroundTransparency = 1
cursor.Visible = false
cursor.Image = 'rbxasset://textures/Cursors/KeyboardMouse/ArrowFarCursor.png'
cursor.Parent = gui
scale = Instance.new('UIScale')
scale.Scale = 1--math.max(gui.AbsoluteSize.X / 1920, 0.68)
scale.Parent = scaledgui
mainapi.guiscale = scale
scaledgui.Size = UDim2.fromScale(1 / scale.Scale, 1 / scale.Scale)
modulegrid:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
	moduleholder.CanvasSize = UDim2.fromOffset(0, modulegrid.AbsoluteContentSize.Y + 2)
end)

for _, v in {'Combat', 'Blatant', 'Render', 'Utility', 'World', 'Inventory', 'Minigames'} do
	mainapi:CreateCategory({Name = v})
end

for i = 1, 60 do
	local mod = mainapi.Categories.Combat:CreateModule({
		Name = 'mod'..i,
		Function = function(callback)
			print('mod'..i, callback)
		end,
		Tooltip = 'testing!'
	})
end

mainapi:Clean(clickgui.MouseButton1Click:Connect(function()
	if expanded then expanded:Expand() end
end))

mainapi:Clean(gui:GetPropertyChangedSignal('AbsoluteSize'):Connect(function()
	if mainapi.Scale.Enabled then
		scale.Scale = 1--math.max(gui.AbsoluteSize.X / 1920, 0.68)
	end
end))

mainapi:Clean(scale:GetPropertyChangedSignal('Scale'):Connect(function()
	scaledgui.Size = UDim2.fromScale(1 / scale.Scale, 1 / scale.Scale)
	for _, v in scaledgui:GetDescendants() do
		if v:IsA('GuiObject') and v.Visible then
			v.Visible = false
			v.Visible = true
		end
	end
end))

mainapi:Clean(clickgui:GetPropertyChangedSignal('Visible'):Connect(function()
	if clickgui.Visible and inputService.MouseEnabled then
		repeat
			local visibleCheck = clickgui.Visible
			for _, v in mainapi.Windows do
				visibleCheck = visibleCheck or v.Visible
			end
			if not visibleCheck then break end

			cursor.Visible = not inputService.MouseIconEnabled
			if cursor.Visible then
				local mouseLocation = inputService:GetMouseLocation()
				cursor.Position = UDim2.fromOffset(mouseLocation.X - 31, mouseLocation.Y - 32)
			end

			task.wait()
		until mainapi.Loaded == nil
		cursor.Visible = false
	end
end))

mainapi:Clean(inputService.InputBegan:Connect(function(inputObj)
	if not inputService:GetFocusedTextBox() and inputObj.KeyCode ~= Enum.KeyCode.Unknown then
		if mainapi.Binding then
			mainapi.Binding:SetBind(mainapi.Binding.Bind == inputObj.KeyCode.Name and '' or inputObj.KeyCode.Name, true)
			mainapi.Binding = nil
			return
		end

		if inputObj.KeyCode == mainapi.Keybind then
			if mainapi.ThreadFix then setthreadidentity(8) end
			for _, v in mainapi.Windows do v.Visible = false end
			clickgui.Visible = not clickgui.Visible
			--tooltip.Visible = false
		end

		local toggled = false
		for i, v in mainapi.Modules do
			if v.Bind == inputObj.KeyCode.Name then
				toggled = true
				if mainapi.ToggleNotifications.Enabled then mainapi:CreateNotification('Module Toggled', i.."<font color='#FFFFFF'> has been </font>"..(not v.Enabled and "<font color='#5AFF5A'>Enabled</font>" or "<font color='#FF5A5A'>Disabled</font>").."<font color='#FFFFFF'>!</font>", 0.75) end
				v:Toggle(true)
			end
		end
		if toggled then mainapi:UpdateTextGUI() end

		for _, v in mainapi.Profiles do
			if v.Bind == inputObj.KeyCode.Name and v.Name ~= mainapi.Profile then
				mainapi:Save(v.Name)
				mainapi:Load(true)
				break
			end
		end
	end
end))

return mainapi