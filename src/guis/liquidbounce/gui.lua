local mainapi = {
	Categories = {},
	GUIColor = {
		Hue = 0.46,
		Sat = 0.96,
		Value = 0.52
	},
	HeldKeybinds = {},
	Keybind = {'RightShift'},
	Loaded = false,
	Legit = {Modules = {}},
	Libraries = {},
	Modules = {},
	MultiKeybind = {},
	Place = game.PlaceId,
	Profile = 'default',
	Profiles = {},
	RainbowSpeed = {Value = 1},
	RainbowUpdateSpeed = {Value = 60},
	RainbowTable = {},
	Scale = {Value = 1},
	ThreadFix = setthreadidentity and true or false,
	ToggleNotifications = {},
	Version = '4.18',
	Windows = {}
}

local cloneref = cloneref or function(obj)
	return obj
end
local tweenService = cloneref(game:GetService('TweenService'))
local inputService = cloneref(game:GetService('UserInputService'))
local textService = cloneref(game:GetService('TextService'))
local guiService = cloneref(game:GetService('GuiService'))
local runService = cloneref(game:GetService('RunService'))
local httpService = cloneref(game:GetService('HttpService'))

local fontsize = Instance.new('GetTextBoundsParams')
fontsize.Width = math.huge
local notifications
local assetfunction = getcustomasset
local getcustomasset
local clickgui
local scaledgui
local mainframe
local mainscale
local sidebar
local categoryholder
local categoryhighlight
local lastSelected
local guiTween
local scale
local gui

local color = {}
local tween = {
	tweens = {},
	tweenstwo = {}
}
local uipallet = {
	Main = Color3.fromRGB(70, 119, 255),
	Text = Color3.new(1, 1, 1),
	Tween = TweenInfo.new(0.16, Enum.EasingStyle.Linear),
}

local getcustomassets = {
	['newvape/assets/liquidbounce/blatant.png'] = 'rbxasset://liquidbounce/blatant.png',
	['newvape/assets/liquidbounce/combat.png'] = 'rbxasset://liquidbounce/combat.png',
	['newvape/assets/liquidbounce/expand.png'] = 'rbxasset://liquidbounce/expand.png',
	['newvape/assets/liquidbounce/inventory.png'] = 'rbxasset://liquidbounce/inventory.png',
	['newvape/assets/liquidbounce/logo.png'] = 'rbxasset://liquidbounce/logo.png',
	['newvape/assets/liquidbounce/minigames.png'] = 'rbxasset://liquidbounce/minigames.png',
	['newvape/assets/liquidbounce/render.png'] = 'rbxasset://liquidbounce/render.png',
	['newvape/assets/liquidbounce/textgui.png'] = 'rbxasset://liquidbounce/textgui.png',
	['newvape/assets/liquidbounce/utility.png'] = 'rbxasset://liquidbounce/utility.png',
	['newvape/assets/liquidbounce/world.png'] = 'rbxasset://liquidbounce/world.png',
	['newvape/assets/new/blur.png'] = 'rbxassetid://14898786664'
}

local isfile = isfile or function(file)
	local suc, res = pcall(function()
		return readfile(file)
	end)
	return suc and res ~= nil and res ~= ''
end

local getfontsize = function(text, size, font)
	fontsize.Text = text
	fontsize.Size = size
	if typeof(font) == 'Font' then
		fontsize.Font = font
	end
	return textService:GetTextBoundsAsync(fontsize)
end

local function addBlur(parent)
	local blur = Instance.new('ImageLabel')
	blur.Name = 'Blur'
	blur.Size = UDim2.new(1, 42, 1, 42)
	blur.Position = UDim2.fromOffset(-24, -15)
	blur.BackgroundTransparency = 1
	blur.Image = getcustomasset('newvape/assets/new/blur.png')
	blur.ScaleType = Enum.ScaleType.Slice
	blur.SliceCenter = Rect.new(44, 38, 804, 595)
	blur.Parent = parent

	return blur
end

local function addCorner(parent, radius)
	local corner = Instance.new('UICorner')
	corner.CornerRadius = radius or UDim.new(0, 5)
	corner.Parent = parent

	return corner
end

local function addMaid(object)
	object.Connections = {}
	function object:Clean(callback)
		if typeof(callback) == 'Instance' then
			table.insert(self.Connections, {
				Disconnect = function()
					callback:ClearAllChildren()
					callback:Destroy()
				end
			})
		elseif type(callback) == 'function' then
			table.insert(self.Connections, {
				Disconnect = callback
			})
		else
			table.insert(self.Connections, callback)
		end
	end
end

local function checkKeybinds(compare, target, key)
	if table.find(target, key) then
		for _, v in target do
			if not table.find(compare, v) then
				return false
			end
		end
		return true
	end

	return false
end

local function createDownloader(text)
	if mainapi.Loaded ~= true then
		local downloader = mainapi.Downloader
		if not downloader then
			downloader = Instance.new('TextLabel')
			downloader.Size = UDim2.new(1, 0, 0, 40)
			downloader.BackgroundTransparency = 1
			downloader.TextStrokeTransparency = 0
			downloader.TextSize = 20
			downloader.TextColor3 = Color3.new(1, 1, 1)
			downloader.FontFace = Font.fromEnum(Enum.Font.Arial)
			downloader.Parent = mainapi.gui
			mainapi.Downloader = downloader
		end
		downloader.Text = 'Downloading '..text
	end
end

local function createTween(time, dir)
	return TweenInfo.new(time, Enum.EasingStyle.Cubic, Enum.EasingDirection[dir or 'InOut'])
end

local function downloadFile(path, func)
	if not isfile(path) then
		createDownloader(path)
		local suc, res = pcall(function()
			return game:HttpGet('https://raw.githubusercontent.com/7GrandDadPGN/VapeCompiled/'..readfile('newvape/profiles/commit.txt')..'/'..select(1, path:gsub('newvape/', '')), true)
		end)
		if not suc or res == '404: Not Found' then
			error(res)
		end
		if path:find('.lua') then
			res = '--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.\n'..res
		end
		writefile(path, res)
	end
	return (func or readfile)(path)
end

getcustomasset = not inputService.TouchEnabled and assetfunction and function(path)
	return downloadFile(path, assetfunction)
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
		if type(v) == 'table' then
			loopClean(v)
		end
		tab[i] = nil
	end
end

local function loadJson(path)
	local suc, res = pcall(function()
		return httpService:JSONDecode(readfile(path))
	end)
	return suc and type(res) == 'table' and res or nil
end

local function makeDraggable(obj, window)
	obj.InputBegan:Connect(function(inputObj)
		if window and not window.Visible or mainapi.Dragging then return end
		if
			(inputObj.UserInputType == Enum.UserInputType.MouseButton1 or inputObj.UserInputType == Enum.UserInputType.Touch)
			and (inputObj.Position.Y - obj.AbsolutePosition.Y < 40 or window)
		then
			mainapi.Dragging = true
			local dragPosition = Vector2.new(obj.AbsolutePosition.X - inputObj.Position.X, obj.AbsolutePosition.Y - inputObj.Position.Y + guiService:GetGuiInset().Y) / scale.Scale
			local changed = inputService.InputChanged:Connect(function(input)
				if input.UserInputType == (inputObj.UserInputType == Enum.UserInputType.MouseButton1 and Enum.UserInputType.MouseMovement or Enum.UserInputType.Touch) then
					local position = input.Position
					if inputService:IsKeyDown(Enum.KeyCode.LeftShift) then
						dragPosition = (dragPosition // 3) * 3
						position = (position // 3) * 3
					end
					obj.Position = UDim2.fromOffset((position.X / scale.Scale) + dragPosition.X, (position.Y / scale.Scale) + dragPosition.Y)
				end
			end)

			local ended
			ended = inputObj.Changed:Connect(function()
				if inputObj.UserInputState == Enum.UserInputState.End then
					mainapi.Dragging = nil
					if changed then
						changed:Disconnect()
					end
					if ended then
						ended:Disconnect()
					end
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

local function writeFont()
	if not assetfunction then return 'rbxasset://fonts/inter.json' end
	--[[writefile('newvape/assets/liquidbounce/lbfont.json', httpService:JSONEncode({
		name = 'Inter',
		faces = {
			{style = 'normal', assetId = getcustomasset('newvape/assets/liquidbounce/Inter-Light.ttf'), name = 'Light', weight = 300},
			{style = 'normal', assetId = getcustomasset('newvape/assets/liquidbounce/Inter-Regular.ttf'), name = 'Regular', weight = 400},
			{style = 'normal', assetId = getcustomasset('newvape/assets/liquidbounce/Inter-Medium.ttf'), name = 'Medium', weight = 500}
		}
	}))]]
	return getcustomasset('newvape/assets/liquidbounce/lbfont.json')
end

if inputService.TouchEnabled then
	writefile('newvape/profiles/gui.txt', 'new')
	return
end

do
	local lbfont = writeFont()
	uipallet.Font = Font.new(lbfont, Enum.FontWeight.Regular)
	uipallet.FontSemiBold = Font.new(lbfont, Enum.FontWeight.Medium)
	uipallet.FontLight = Font.new(lbfont, Enum.FontWeight.Light)

	local res = isfile('newvape/profiles/color.txt') and loadJson('newvape/profiles/color.txt')
	if res then
		uipallet.Main = res.Main and Color3.fromRGB(unpack(res.Main)) or uipallet.Main
		uipallet.Text = res.Text and Color3.fromRGB(unpack(res.Text)) or uipallet.Text
		uipallet.Font = res.Font and Font.new(
			res.Font:find('rbxasset') and res.Font or string.format('rbxasset://fonts/families/%s.json', res.Font)
		) or uipallet.Font
		uipallet.FontSemiBold = Font.new(uipallet.Font.Family, Enum.FontWeight.SemiBold)
		uipallet.FontLight = Font.new(uipallet.Font.Family, Enum.FontWeight.Light)
	end

	fontsize.Font = uipallet.Font
end

do
	function color.Dark(col, num)
		local h, s, v = col:ToHSV()
		return Color3.fromHSV(h, s, math.clamp(v - num, 0, 1))
	end

	function color.Light(col, num)
		local h, s, v = col:ToHSV()
		return Color3.fromHSV(h, s, math.clamp(v + num, 0, 1))
	end

	function color.Saturate(col, num)
		local h, s, v = col:ToHSV()
		return Color3.fromHSV(h, math.clamp(s - (s * num), 0, 1), math.clamp(v - 0.3, 0, 1))
	end

	function mainapi:Color(h)
		local s = 0.75 + (0.15 * math.min(h / 0.03, 1))
		if h > 0.57 then
			s = 0.9 - (0.4 * math.min((h - 0.57) / 0.09, 1))
		end
		if h > 0.66 then
			s = 0.5 + (0.4 * math.min((h - 0.66) / 0.16, 1))
		end
		if h > 0.87 then
			s = 0.9 - (0.15 * math.min((h - 0.87) / 0.13, 1))
		end
		return h, s, 1
	end

	function mainapi:TextColor(h, s, v)
		if v >= 0.7 and (s < 0.6 or h > 0.04 and h < 0.56) then
			return Color3.new(0.19, 0.19, 0.19)
		end
		return Color3.new(1, 1, 1)
	end
end

do
	function tween:Tween(obj, tweeninfo, goal, tab)
		tab = tab or self.tweens
		if tab[obj] then
			tab[obj]:Cancel()
			tab[obj] = nil
		end

		if obj.Parent and obj.Visible then
			tab[obj] = tweenService:Create(obj, tweeninfo, goal)
			tab[obj].Completed:Once(function()
				if tab then
					tab[obj]:Destroy()
					tab[obj] = nil
					tab = nil
				end
			end)
			tab[obj]:Play()
		else
			for i, v in goal do
				obj[i] = v
			end
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
--Components
	Divider = function(children, text)

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

function mainapi:BlurCheck()
	if self.ThreadFix then
		setthreadidentity(8)
		runService:SetRobloxGuiFocused((clickgui.Visible or guiService:GetErrorType() ~= Enum.ConnectionError.OK) and self.Blur.Enabled)
	end
end

addMaid(mainapi)

function mainapi:CreateCategory(categorysettings)
	local categoryapi = {
		Type = 'Category',
		Expanded = false
	}

	local window = Instance.new('CanvasGroup')
	window.Name = categorysettings.Name..'Category'
	window.Size = UDim2.fromOffset(250, 39)
	window.Position = UDim2.fromOffset(236, 60)
	window.BackgroundTransparency = 1
	window.Parent = clickgui
	local titlebar = Instance.new('Frame')
	titlebar.Size = UDim2.fromOffset(250, 39)
	titlebar.BackgroundColor3 = Color3.new()
	titlebar.BackgroundTransparency = 0.1
	titlebar.BorderSizePixel = 0
	titlebar.Parent = window
	local title = Instance.new('TextLabel')
	title.Size = UDim2.new(1, -44, 1, -2)
	title.Position = UDim2.fromOffset(44, 0)
	title.BackgroundTransparency = 1
	title.Text = categorysettings.Name
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.TextColor3 = uipallet.Text
	title.TextSize = 16
	title.FontFace = uipallet.FontSemiBold
	title.Parent = titlebar
	local icon = Instance.new('ImageLabel')
	icon.Size = categorysettings.Size or UDim2.fromOffset(15, 15)
	icon.Position = UDim2.fromOffset(24, 18)
	icon.AnchorPoint = Vector2.new(0.5, 0.5)
	icon.BackgroundTransparency = 1
	icon.Image = categorysettings.Icon
	icon.Parent = titlebar
	local expandbar1 = Instance.new('Frame')
	expandbar1.Size = UDim2.fromOffset(2, 12)
	expandbar1.Position = UDim2.new(1, -21, 0.5, 0)
	expandbar1.AnchorPoint = Vector2.new(0.5, 0.5)
	expandbar1.BackgroundColor3 = uipallet.Text
	expandbar1.BorderSizePixel = 0
	expandbar1.Parent = title
	local expandbar2 = expandbar1:Clone()
	expandbar2.Rotation = 90
	expandbar2.Parent = title
	local divider = Instance.new('Frame')
	divider.Size = UDim2.fromOffset(250, 2)
	divider.Position = UDim2.fromOffset(0, 37)
	divider.BackgroundColor3 = uipallet.Main
	divider.BorderSizePixel = 0
	divider.Parent = titlebar
	addCorner(window)
	makeDraggable(window)
	local children = Instance.new('ScrollingFrame')
	children.Name = 'Children'
	children.Size = UDim2.new(1, 0, 1, -39)
	children.Position = UDim2.fromOffset(0, 39)
	children.BackgroundTransparency = 1
	children.BorderSizePixel = 0
	children.Visible = true
	children.ScrollBarThickness = 0
	children.CanvasSize = UDim2.new()
	children.Parent = window
	local windowlist = Instance.new('UIListLayout')
	windowlist.SortOrder = Enum.SortOrder.LayoutOrder
	windowlist.HorizontalAlignment = Enum.HorizontalAlignment.Center
	windowlist.Parent = children

	function categoryapi:CreateModule(modulesettings)
		mainapi:Remove(modulesettings.Name)
		local moduleapi = {
			Enabled = false,
			Options = {},
			Bind = {},
			Index = getTableSize(mainapi.Modules),
			ExtraText = modulesettings.ExtraText,
			Name = modulesettings.Name,
			Category = categorysettings.Name
		}

		local hovered = false
		local modulebutton = Instance.new('TextButton')
		modulebutton.Name = modulesettings.Name
		modulebutton.Size = UDim2.fromOffset(250, 35)
		modulebutton.BackgroundColor3 = Color3.new()
		modulebutton.BackgroundTransparency = 0.25
		modulebutton.BorderSizePixel = 0
		modulebutton.AutoButtonColor = false
		modulebutton.Text = modulesettings.Name
		modulebutton.TextColor3 = color.Dark(uipallet.Text, 0.2)
		modulebutton.TextSize = 14
		modulebutton.FontFace = uipallet.FontSemiBold
		modulebutton.Parent = children
		local expandicon = Instance.new('ImageButton')
		expandicon.Size = UDim2.fromOffset(6, 10)
		expandicon.Position = UDim2.new(1, -20, 0.5, 0)
		expandicon.AnchorPoint = Vector2.new(0.5, 0.5)
		expandicon.BackgroundTransparency = 1
		expandicon.Image = getcustomasset('newvape/assets/liquidbounce/expand.png')
		expandicon.ImageTransparency = 0.5
		expandicon.Parent = modulebutton
		local modulechildren = Instance.new('Frame')
		modulechildren.Name = modulesettings.Name..'Children'
		modulechildren.Size = UDim2.new(1, 0, 0, 0)
		modulechildren.BackgroundColor3 = Color3.new()
		modulechildren.BackgroundTransparency = 0.1
		modulechildren.BorderSizePixel = 0
		modulechildren.Visible = false
		modulechildren.Parent = children
		moduleapi.Children = modulechildren
		local windowlist = Instance.new('UIListLayout')
		windowlist.SortOrder = Enum.SortOrder.LayoutOrder
		windowlist.HorizontalAlignment = Enum.HorizontalAlignment.Center
		windowlist.Parent = modulechildren
		modulesettings.Function = modulesettings.Function or function() end
		addMaid(moduleapi)

		function moduleapi:Toggle(multiple)
			if mainapi.ThreadFix then
				setthreadidentity(8)
			end
			self.Enabled = not self.Enabled
			tween:Tween(modulebutton, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {
				TextColor3 = self.Enabled and uipallet.Main or (hovered and uipallet.Text or color.Dark(uipallet.Text, 0.2))
			}, tween.tweenstwo)
			if not self.Enabled then
				for _, v in self.Connections do
					v:Disconnect()
				end
				table.clear(self.Connections)
			end
			if not multiple then
				mainapi:UpdateTextGUI()
			end
			task.spawn(modulesettings.Function, self.Enabled)
		end

		for i, v in components do
			moduleapi['Create'..i] = function(_, optionsettings)
				return v(optionsettings, modulechildren, moduleapi)
			end
		end

		moduleapi:CreateBind()
		modulebutton.MouseEnter:Connect(function()
			hovered = true
			tween:Tween(modulebutton, createTween(0.2), {
				BackgroundTransparency = 0.15
			})

			if not moduleapi.Enabled then
				tween:Tween(modulebutton, createTween(0.2), {
					TextColor3 = uipallet.Text
				}, tween.tweenstwo)
			end
		end)
		modulebutton.MouseLeave:Connect(function()
			hovered = false
			tween:Tween(modulebutton, createTween(0.2), {
				BackgroundTransparency = 0.25
			})

			if not moduleapi.Enabled then
				tween:Tween(modulebutton, createTween(0.2), {
					TextColor3 = color.Dark(uipallet.Text, 0.2)
				}, tween.tweenstwo)
			end
		end)
		modulebutton.MouseButton1Click:Connect(function()
			moduleapi:Toggle()
		end)
		modulebutton.MouseButton2Click:Connect(function()
			modulechildren.Visible = not modulechildren.Visible
			tween:Tween(expandicon, createTween(0.2), {
				ImageTransparency = modulechildren.Visible and 0 or 0.5
			})
			tween:Tween(expandicon, createTween(0.4), {
				Rotation = modulechildren.Visible and 90 or 0
			}, tween.tweenstwo)
		end)
		windowlist:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
			if mainapi.ThreadFix then
				setthreadidentity(8)
			end
			modulechildren.Size = UDim2.new(1, 0, 0, windowlist.AbsoluteContentSize.Y / scale.Scale)
		end)

		moduleapi.Object = modulebutton
		mainapi.Modules[modulesettings.Name] = moduleapi

		local sorting = {}
		for _, v in mainapi.Modules do
			sorting[v.Category] = sorting[v.Category] or {}
			table.insert(sorting[v.Category], v.Name)
		end

		for _, sort in sorting do
			table.sort(sort)
			for i, v in sort do
				mainapi.Modules[v].Index = i
				mainapi.Modules[v].Object.LayoutOrder = i
				mainapi.Modules[v].Children.LayoutOrder = i
			end
		end

		return moduleapi
	end

	function categoryapi:Expand()
		self.Expanded = not self.Expanded
		tween:Tween(expandbar1, createTween(0.4, 'Out'), {
			Rotation = self.Expanded and 90 or 0
		})
		tween:Tween(expandbar2, createTween(0.4, 'Out'), {
			Rotation = self.Expanded and 270 or 90
		})
		tween:Tween(window, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
			Size = UDim2.fromOffset(250, self.Expanded and math.min(39 + windowlist.AbsoluteContentSize.Y / scale.Scale, 583) or 39)
		})
	end

	window.InputBegan:Connect(function(inputObj)
		if inputObj.Position.Y < window.AbsolutePosition.Y + 39 and inputObj.UserInputType == Enum.UserInputType.MouseButton2 then
			categoryapi:Expand()
		end
	end)
	windowlist:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
		if self.ThreadFix then
			setthreadidentity(8)
		end
		children.CanvasSize = UDim2.fromOffset(0, windowlist.AbsoluteContentSize.Y / scale.Scale)
		if categoryapi.Expanded then
			tween:Tween(window, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				Size = UDim2.fromOffset(250, math.min(39 + windowlist.AbsoluteContentSize.Y / scale.Scale, 583))
			})
		end
	end)

	categoryapi.Object = window
	self.Categories[categorysettings.Name] = categoryapi

	return categoryapi
end

function mainapi:CreateNotification(title, text, duration, type)

end

function mainapi:Load(skipgui, profile)

end

function mainapi:LoadOptions(object, savedoptions)

end

function mainapi:Remove(obj)
	local tab = (self.Modules[obj] and self.Modules or self.Legit.Modules[obj] and self.Legit.Modules or self.Categories)
	if tab and tab[obj] then
		local newobj = tab[obj]
		if self.ThreadFix then
			setthreadidentity(8)
		end

		for _, v in {'Object', 'Children', 'Toggle', 'Button'} do
			local childobj = typeof(newobj[v]) == 'table' and newobj[v].Object or newobj[v]
			if typeof(childobj) == 'Instance' then
				childobj:Destroy()
				childobj:ClearAllChildren()
			end
		end

		loopClean(newobj)
		tab[obj] = nil
	end
end

function mainapi:Save(newprofile)

end

function mainapi:SaveOptions(object, savedoptions)

end

function mainapi:Uninject()

end

function mainapi:UpdateGUI()

end

function mainapi:UpdateTextGUI()

end

gui = Instance.new('ScreenGui')
gui.Name = randomString()
gui.DisplayOrder = 9999999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.IgnoreGuiInset = true
gui.OnTopOfCoreBlur = true
if mainapi.ThreadFix then
	gui.Parent = cloneref(game:GetService('CoreGui'))--(gethui and gethui()) or cloneref(game:GetService('CoreGui'))
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
clickgui = Instance.new('Frame')
clickgui.Name = 'ClickGui'
clickgui.Size = UDim2.fromScale(1, 1)
clickgui.BackgroundTransparency = 0.4
clickgui.BackgroundColor3 = Color3.new()
clickgui.BorderSizePixel = 0
clickgui.Visible = false
clickgui.Parent = scaledgui
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
notifications = Instance.new('Folder')
notifications.Name = 'Notifications'
notifications.Parent = scaledgui
scale = Instance.new('UIScale')
scale.Scale = math.max(gui.AbsoluteSize.X / 1920, 1)
scale.Parent = scaledgui
mainapi.guiscale = scale
scaledgui.Size = UDim2.fromScale(1 / scale.Scale, 1 / scale.Scale)

mainapi:Clean(gui:GetPropertyChangedSignal('AbsoluteSize'):Connect(function()
	if mainapi.Scale.Enabled then
		scale.Scale = math.max(gui.AbsoluteSize.X / 1920, 1)
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
	mainapi:UpdateGUI(mainapi.GUIColor.Hue, mainapi.GUIColor.Sat, mainapi.GUIColor.Value, true)
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

mainapi:CreateCategory({
	Name = 'Combat',
	Icon = getcustomasset('newvape/assets/liquidbounce/combat.png'),
	Size = UDim2.fromOffset(16, 15)
})
mainapi:CreateCategory({
	Name = 'Blatant',
	Icon = getcustomasset('newvape/assets/liquidbounce/blatant.png'),
	Size = UDim2.fromOffset(15, 15)
})
mainapi:CreateCategory({
	Name = 'Render',
	Icon = getcustomasset('newvape/assets/liquidbounce/render.png'),
	Size = UDim2.fromOffset(15, 9)
})
mainapi:CreateCategory({
	Name = 'Utility',
	Icon = getcustomasset('newvape/assets/liquidbounce/utility.png'),
	Size = UDim2.fromOffset(15, 15)
})
mainapi:CreateCategory({
	Name = 'World',
	Icon = getcustomasset('newvape/assets/liquidbounce/world.png'),
	Size = UDim2.fromOffset(15, 15)
})
mainapi:CreateCategory({
	Name = 'Inventory',
	Icon = getcustomasset('newvape/assets/liquidbounce/inventory.png'),
	Size = UDim2.fromOffset(14, 15)
})
mainapi:CreateCategory({
	Name = 'Minigames',
	Icon = getcustomasset('newvape/assets/liquidbounce/minigames.png'),
	Size = UDim2.fromOffset(15, 15)
})

mainapi:Clean(inputService.InputBegan:Connect(function(inputObj)
	if not inputService:GetFocusedTextBox() and inputObj.KeyCode ~= Enum.KeyCode.Unknown then
		table.insert(mainapi.HeldKeybinds, inputObj.KeyCode.Name)
		if mainapi.Binding then return end

		if checkKeybinds(mainapi.HeldKeybinds, mainapi.Keybind, inputObj.KeyCode.Name) then
			if mainapi.ThreadFix then
				setthreadidentity(8)
			end
			for _, v in mainapi.Windows do
				v.Visible = false
			end
			clickgui.Visible = not clickgui.Visible
			--tooltip.Visible = false
			mainapi:BlurCheck()
		end

		local toggled = false
		for i, v in mainapi.Modules do
			if checkKeybinds(mainapi.HeldKeybinds, v.Bind, inputObj.KeyCode.Name) then
				toggled = true
				if mainapi.ToggleNotifications.Enabled then
					mainapi:CreateNotification('Module Toggled', i.."<font color='#FFFFFF'> has been </font>"..(not v.Enabled and "<font color='#5AFF5A'>Enabled</font>" or "<font color='#FF5A5A'>Disabled</font>").."<font color='#FFFFFF'>!</font>", 0.75)
				end
				v:Toggle(true)
			end
		end
		if toggled then
			mainapi:UpdateTextGUI()
		end

		for _, v in mainapi.Profiles do
			if checkKeybinds(mainapi.HeldKeybinds, v.Bind, inputObj.KeyCode.Name) and v.Name ~= mainapi.Profile then
				mainapi:Save(v.Name)
				mainapi:Load(true)
				break
			end
		end
	end
end))

mainapi:Clean(inputService.InputEnded:Connect(function(inputObj)
	if not inputService:GetFocusedTextBox() and inputObj.KeyCode ~= Enum.KeyCode.Unknown then
		if mainapi.Binding then
			if not mainapi.MultiKeybind.Enabled then
				mainapi.HeldKeybinds = {inputObj.KeyCode.Name}
			end
			mainapi.Binding:SetBind(checkKeybinds(mainapi.HeldKeybinds, mainapi.Binding.Bind, inputObj.KeyCode.Name) and {} or mainapi.HeldKeybinds, true)
			mainapi.Binding = nil
		end
	end

	local ind = table.find(mainapi.HeldKeybinds, inputObj.KeyCode.Name)
	if ind then
		table.remove(mainapi.HeldKeybinds, ind)
	end
end))

return mainapi