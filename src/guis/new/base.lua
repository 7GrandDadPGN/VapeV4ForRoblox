local vape = {
	ActiveBinds = {},
	Categories = {},
	GUIColor = {
		Hue = 0.46,
		Sat = 0.96,
		Value = 0.52
	},
	HeldKeybinds = {},
	Loaded = false,
	Libraries = {},
	Modules = {},
	Place = game.PlaceId,
	Profile = 'default',
	RainbowSliders = {},
	Settings = {},
	SettingToggleNotifications = {},
	ThreadFix = setthreadidentity and true or false,
	ToggleNotifications = {},
	Version = '4.22',
	Windows = {}
}

local run = function(func)
	func()
end
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
local getvapeasset
local components
local clickgui
local scaledgui
local toolblur
local tooltip
local TextGUI
local scale = {Scale = 1}
local gui

local isfile = isfile or function(file)
	local success, data = pcall(function()
		return readfile(file)
	end)

	return success and data ~= nil and data ~= ''
end

local function loadJson(path)
	local success, data = pcall(function()
		return httpService:JSONDecode(readfile(path))
	end)

	return success and type(data) == 'table' and data or nil
end

--Libraries

local function addBlur(parent, notif, old)
	local blur
	if old then
		blur = Instance.new('ImageLabel')
		blur.Name = 'Blur'
		blur.Size = UDim2.new(1, 89, 1, 52)
		blur.Position = UDim2.fromOffset(-48, -31)
		blur.BackgroundTransparency = 1
		blur.Image = getvapeasset('newvape/assets/new/'..(notif and 'blurnoti' or 'blur')..'.png')
		blur.ScaleType = Enum.ScaleType.Slice
		blur.SliceCenter = Rect.new(52, 31, 261, 502)
		blur.Parent = parent
	else
		blur = Instance.new('UIShadow')
		blur.BlurRadius = UDim.new(0, 13)
		blur.Transparency = 0.25
		blur.Parent = parent
	end

	return blur
end

local function addCorner(parent, radius)
	local corner = Instance.new('UICorner')
	corner.CornerRadius = radius or UDim.new(0, 5)
	corner.Parent = parent

	return corner
end

local function addCloseButton(parent, mini, offset)
	local close = Instance.new('ImageButton')
	close.AutoButtonColor = false
	close.BackgroundColor3 = Color3.new(1, 1, 1)
	close.BackgroundTransparency = 1
	close.Image = getvapeasset('newvape/assets/new/'..(mini and 'closemini' or 'close')..'.png')
	close.ImageColor3 = color.Light(uipallet.Text, 0.2)
	close.ImageTransparency = 0.5
	close.Name = 'Close'
	close.Position = offset or (mini and UDim2.new(1, -28, 0, 11) or UDim2.new(1, -35, 0, 9))
	close.Size = mini and UDim2.fromOffset(20, 20) or UDim2.fromOffset(24, 24)
	close.Parent = parent
	addCorner(close, UDim.new(1, 0))

	close.MouseEnter:Connect(function()
		close.ImageTransparency = 0.3
		tween:Tween(close, uipallet.Tween, {
			BackgroundTransparency = 0.6
		})
	end)

	close.MouseLeave:Connect(function()
		close.ImageTransparency = 0.5
		tween:Tween(close, uipallet.Tween, {
			BackgroundTransparency = 1
		})
	end)

	return close
end

local function addDragHandler(gui, window)
	gui.InputBegan:Connect(function(input)
		if window and not window.Visible then return end

		if
			(input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch)
			and (input.Position.Y - gui.AbsolutePosition.Y < 40 or window)
		then
			local dragPosition = Vector2.new(
				gui.AbsolutePosition.X - input.Position.X,
				gui.AbsolutePosition.Y - input.Position.Y + guiService:GetGuiInset().Y
			) / scale.Scale

			local releaseConnection
			local moveConnection = inputService.InputChanged:Connect(function(newInput)
				if newInput.UserInputType == (input.UserInputType == Enum.UserInputType.MouseButton1 and Enum.UserInputType.MouseMovement or Enum.UserInputType.Touch) then
					local position = newInput.Position
					if inputService:IsKeyDown(Enum.KeyCode.LeftShift) then
						dragPosition = (dragPosition // 3) * 3
						position = (position // 3) * 3
					end

					gui.Position = UDim2.fromOffset((position.X / scale.Scale) + dragPosition.X, (position.Y / scale.Scale) + dragPosition.Y)
				end
			end)

			releaseConnection = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					moveConnection:Disconnect()
					releaseConnection:Disconnect()
				end
			end)
		end
	end)
end

local function addMaid(obj)
	obj.Connections = {}

	function obj:Clean(callback)
		if typeof(callback) == 'Instance' then
			table.insert(self.Connections, {
				Disconnect = function()
					callback:ClearAllChildren()
					callback:Destroy()
				end
			})
		elseif type(callback) == 'thread' then
			table.insert(self.Connections, {
				Disconnect = function()
					if coroutine.status(callback) ~= 'dead' then
						task.cancel(callback)
					end
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

local function addTooltip(gui, text, customText, visCheck)
	if not text then return end

	local function tooltipMoved(x, y)
		if visCheck and visCheck() then
			return
		end

		local isRight = x + 16 + tooltip.Size.X.Offset > (scale.Scale * 1920)
		tooltip.Position = UDim2.fromOffset(
			(isRight and x - (tooltip.Size.X.Offset * scale.Scale) - 16 or x + 16) / scale.Scale,
			((y + 11) - (tooltip.Size.Y.Offset / 2)) / scale.Scale
		)

		tooltip.Visible = toolblur.Enabled
	end

	local function callback()
		local newText = customText()
		tooltip.Text = newText
		local tooltipSize = getfontbounds(tooltip.ContentText, tooltip.TextSize, uipallet.Font)
		tooltip.Size = UDim2.fromOffset(tooltipSize.X + 10, tooltipSize.Y + 10)
	end

	gui.MouseEnter:Connect(function(x, y)
		if visCheck and visCheck() then
			return
		end

		tooltip.Text = text
		local tooltipSize = getfontbounds(tooltip.ContentText, tooltip.TextSize, uipallet.Font)
		tooltip.Size = UDim2.fromOffset(tooltipSize.X + 10, tooltipSize.Y + 10)
		tooltipMoved(x, y)

		if customText then
			vape.CurrentTooltip = callback
			callback()
		end
	end)
	gui.MouseMoved:Connect(tooltipMoved)
	gui.MouseLeave:Connect(function()
		if visCheck and visCheck() then
			return
		end

		tooltip.Visible = false
		vape.CurrentTooltip = nil
	end)
end

local function createSignal()
	local signal = {
		Connections = {}
	}

	function signal:Connect(callback)
		table.insert(self.Connections, callback)

		return {
			Disconnect = function()
				local index = table.find(signal.Connections, callback)
				if index then
					table.remove(signal.Connections, index)
				end
			end
		}
	end

	function signal:Fire(...)
		for _, callback in self.Connections do
			task.spawn(callback, ...)
		end
	end

	return signal
end

local function checkKeybinds(compare, target, key)
	if type(target) == 'table' then
		if table.find(target, key) then
			for _, key in target do
				if not table.find(compare, key) then
					return false
				end
			end

			return true
		end
	end

	return false
end

local function getTableSize(dict)
	local size = 0
	for _ in dict do
		size += 1
	end

	return size
end

local function loopClean(obj)
	for index, value in obj do
		if type(value) == 'table' then
			loopClean(value)
		end

		obj[index] = nil
	end
end

local function randomString()
	local array = {}
	for i = 1, math.random(10, 100) do
		array[i] = string.char(math.random(32, 126))
	end

	return table.concat(array)
end

local function removeTags(text)
	text = text:gsub('<br%s*/>', '\n')
	return text:gsub('<[^<>]->', '')
end

function vape:BlurCheck()
	if self.ThreadFix then
		setthreadidentity(8)
		runService:SetRobloxGuiFocused((clickgui.Visible or guiService:GetErrorType() ~= Enum.ConnectionError.OK) and self.Blur.Enabled)
	end
end

function vape:CreateCategory(props)
	return components.Category(props)
end

function vape:CreateCategoryList(props)
	return components.CategoryList(props)
end

function vape:CreateNotification(title, text, duration, type)
	if not self.Notifications.Enabled then
		return
	end

	task.delay(0, function()
		if self.ThreadFix then
			setthreadidentity(8)
		end

		local index = #notifications:GetChildren() + 1
		local notification = Instance.new('ImageLabel')
		notification.BackgroundTransparency = 1
		notification.Position = UDim2.new(1, 0, 1, -(29 + (78 * index)))
		notification.Image = getvapeasset('newvape/assets/new/notification.png')
		notification.ScaleType = Enum.ScaleType.Slice
		notification.SliceCenter = Rect.new(7, 7, 9, 9)
		notification.ZIndex = 5
		notification.Parent = notifications
		addBlur(notification, true, true)
		local iconshadow = Instance.new('ImageLabel')
		iconshadow.BackgroundTransparency = 1
		iconshadow.Image = getvapeasset('newvape/assets/new/noti_'..(type or 'info')..'.png')
		iconshadow.ImageColor3 = Color3.new()
		iconshadow.ImageTransparency = 0.5
		iconshadow.Position = UDim2.fromOffset(-5, -8)
		iconshadow.Size = UDim2.fromOffset(60, 60)
		iconshadow.ZIndex = 5
		iconshadow.Parent = notification
		local icon = iconshadow:Clone()
		icon.ImageColor3 = Color3.new(1, 1, 1)
		icon.ImageTransparency = 0
		icon.Position = UDim2.fromOffset(-1, -1)
		icon.Parent = iconshadow
		local label = Instance.new('TextLabel')
		label.BackgroundTransparency = 1
		label.FontFace = uipallet.FontSemiBold
		label.Position = UDim2.fromOffset(46, 16)
		label.RichText = true
		label.Size = UDim2.new(1, -56, 0, 20)
		label.Text = "<stroke joins='round' thickness='0.3' transparency='0.5'>"..title..'</stroke>'
		label.TextColor3 = type == 'alert' and Color3.fromRGB(250, 50, 56) or Color3.new(1, 1, 1)
		label.TextSize = 14
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.TextYAlignment = Enum.TextYAlignment.Top
		label.ZIndex = 5
		label.Parent = notification
		local textshadow = label:Clone()
		textshadow.FontFace = uipallet.Font
		textshadow.Position = UDim2.fromOffset(47, 44)
		textshadow.RichText = false
		textshadow.Text = removeTags(text)
		textshadow.TextColor3 = Color3.new()
		textshadow.TextTransparency = 0.5
		textshadow.Parent = notification
		notification.Size = UDim2.fromOffset(math.max(getfontbounds(textshadow.Text, 14, uipallet.Font).X + 80, 266), 75)
		local textlabel = textshadow:Clone()
		textlabel.Position = UDim2.fromOffset(-1, -1)
		textlabel.RichText = true
		textlabel.Text = text
		textlabel.TextColor3 = Color3.fromRGB(170, 170, 170)
		textlabel.TextTransparency = 0
		textlabel.Parent = textshadow
		local progress = Instance.new('Frame')
		progress.BackgroundColor3 =
			type == 'alert' and Color3.fromRGB(250, 50, 56)
			or type == 'warning' and Color3.fromRGB(236, 129, 44)
			or Color3.new(1, 1, 1)
		progress.BorderSizePixel = 0
		progress.Position = UDim2.new(0, 3, 1, -4)
		progress.Size = UDim2.new(1, -13, 0, 1)
		progress.ZIndex = 5
		progress.Parent = notification

		if tween.Tween then
			tween:Tween(notification, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {
				AnchorPoint = Vector2.new(1, 0)
			}, 'tweenstwo')

			tween:Tween(progress, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
				Size = UDim2.fromOffset(0, 1)
			})
		end

		task.delay(duration, function()
			if tween.Tween then
				tween:Tween(notification, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {
					AnchorPoint = Vector2.new(0, 0)
				}, 'tweenstwo')
			end

			task.wait(0.2)
			notification:ClearAllChildren()
			notification:Destroy()
		end)
	end)
end

function vape:CreateOverlay(props)
	return components.Overlay(props)
end

function vape:Load(skipgui, profile)
	local guiData = {Categories = {}}
	local oldProfile = self.Profile
	local canSave = true
	local toggleCount = 0

	if isfile('newvape/profiles/'..game.GameId..'.gui.txt') then
		guiData = loadJson('newvape/profiles/'..game.GameId..'.gui.txt')
		if not guiData then
			guiData = {Categories = {}}
			self:CreateNotification('Vape', 'Failed to load GUI settings.', 10, 'alert')
			canSave = false
		end

		if guiData.v ~= 1 then
			guiData.Categories.Main = nil
		end

		self.Profile = profile or guiData.Profile or 'default'
		if self.ProfileLabel then
			self.ProfileLabel.Text = #self.Profile > 10 and self.Profile:sub(1, 10)..'...' or self.Profile
			self.ProfileLabel.Size = UDim2.fromOffset(getfontbounds(self.ProfileLabel.Text, self.ProfileLabel.TextSize, self.ProfileLabel.Font).X + 16, 24)
		end

		if not skipgui then
			for name, data in guiData.Categories do
				local category = self.Categories[name]
				if category then
					category:Load(data)
				end
			end
		end
	end

	if not self.Categories.Profiles:GetValue('default') then
		self.Categories.Profiles:ChangeValue('default', true)
	end

	if isfile('newvape/profiles/'..self.Profile..self.Place..'.txt') then
		local mainData = loadJson('newvape/profiles/'..self.Profile..self.Place..'.txt')
		if not mainData then
			mainData = {Categories = {}, Modules = {}, Legit = {}}
			self:CreateNotification('Vape', 'Failed to load '..self.Profile..' profile.', 10, 'alert')
			canSave = false
		end

		if mainData.v ~= 1 then
			for _, data in mainData.Modules do
				data.Bind = {Keys = data.Bind}
				data.Visible = true
			end
		end

		for name, data in mainData.Categories do
			local category = self.Categories[name]
			if category then
				category:Load(data)
			end
		end

		for name, data in mainData.Modules do
			local module = self.Modules[name]
			if module then
				module:Load(data)
				toggleCount += module.Enabled and 1 or 0
			end
		end

		for name, data in mainData.Legit do
			local module = self.Legit.Modules[name]
			if module then
				module:Load(data)
			end
		end

		self:UpdateTextGUI(true)
	else
		self:Save()
	end

	if self.Profile ~= oldProfile and skipgui then
		self:CreateNotification('Profile swap to <font color="#FFAA00">'..self.Profile..'</font>', toggleCount..' modules enabled', 3)
	end

	if self.Downloader then
		self.Downloader:Destroy()
		self.Downloader = nil
	end

	self.Loaded = canSave

	if inputService.TouchEnabled and not skipgui then
		local button = Instance.new('TextButton')
		button.BackgroundColor3 = Color3.new()
		button.BackgroundTransparency = 0.2
		button.Position = UDim2.new(1, -90, 0, 4)
		button.Size = UDim2.fromOffset(32, 32)
		button.Text = ''
		button.Parent = gui
		local image = Instance.new('ImageLabel')
		image.BackgroundTransparency = 1
		image.Image = getvapeasset('newvape/assets/new/vape.png')
		image.Position = UDim2.fromOffset(6, 6)
		image.Size = UDim2.fromOffset(20, 20)
		image.Parent = button
		addCorner(button, UDim.new(1, 0))

		button.MouseButton1Click:Connect(function()
			self.GUIBind.Triggered:Fire(true)
		end)
	end

	return toggleData
end

function vape:LoadOptions(obj, data)
	for name, componentData in data do
		local component = obj.Options[name]

		if component then
			component:Load(componentData)
		end
	end
end

function vape:LoadGUI()
--Init
end

function vape:Remove(obj)
	local container = (self.Modules[obj] and self.Modules or self.Legit.Modules[obj] and self.Legit.Modules or self.Categories)
	if container and container[obj] then
		local component = container[obj]
		local isModule = component.Type == 'Module'
		if self.ThreadFix then
			setthreadidentity(8)
		end

		if component.Destroy then
			component:Destroy()
		end

		for _, child in {'Object', 'Children', 'Toggle', 'Button'} do
			child = typeof(component[child]) == 'table' and component[child].Object or component[child]

			if typeof(child) == 'Instance' then
				child:Destroy()
				child:ClearAllChildren()
			end
		end

		loopClean(component)
		container[obj] = nil

		if isModule then
			self:SortCategories()
		end
	end
end

function vape:Save(newProfile)
	if not self.Loaded then
		return
	end

	local guiData = {
		Categories = {},
		Profile = newProfile or self.Profile,
		v = 1
	}

	local mainData = {
		Modules = {},
		Categories = {},
		Legit = {},
		v = 1
	}

	for name, category in self.Categories do
		category:Save((category.Type == 'Overlay' and mainData or guiData).Categories)
	end

	for _, module in self.Modules do
		module:Save(mainData.Modules)
	end

	for _, module in self.Legit.Modules do
		module:Save(mainData.Legit)
	end

	writefile('newvape/profiles/'..game.GameId..'.gui.txt', httpService:JSONEncode(guiData))
	writefile('newvape/profiles/'..self.Profile..self.Place..'.txt', httpService:JSONEncode(mainData))
end

function vape:SaveOptions(obj)
	local data = {}
	for _, component in obj.Options do
		if not component.Save then
			continue
		end

		component:Save(data)
	end

	return data
end

function vape:SortCategories()
	local sorting = {}
	for _, module in self.Modules do
		sorting[module.Category] = sorting[module.Category] or {}
		table.insert(sorting[module.Category], module.Name)
	end

	for _, sort in sorting do
		table.sort(sort)
		for index, name in sort do
			self.Modules[name].Index = index
			self.Modules[name].Object.LayoutOrder = index
			self.Modules[name].Children.LayoutOrder = index
		end
	end
end

function vape:Uninject()
	self:Save()
	self.Loaded = nil

	for _, module in self.Modules do
		if module.Enabled then
			module:Toggle()
		end
	end

	for _, module in self.Legit.Modules do
		if module.Enabled then
			module:Toggle()
		end
	end

	for _, category in self.Categories do
		if category.Type == 'Overlay' and category.Button.Enabled then
			category.Button:Toggle()
		end
	end

	for _, connection in self.Connections do
		pcall(function()
			connection:Disconnect()
		end)
	end

	if self.ThreadFix then
		setthreadidentity(8)
		clickgui.Visible = false
		self:BlurCheck()
	end

	gui:ClearAllChildren()
	gui:Destroy()
	table.clear(self.Connections)
	table.clear(self.Libraries)
	loopClean(self)

	shared.vape = nil
	shared.vapereload = nil
	shared.VapeIndependent = nil
end

local guiUpdate
function vape:UpdateGUI()
	if guiUpdate then
		return
	end

	guiUpdate = runService.RenderStepped:Once(function()
		if vape.Loaded ~= nil then
			vape:UpdateGUIQueue(vape.GUIColor.Hue, vape.GUIColor.Sat, vape.GUIColor.Value)
		end

		guiUpdate = nil
	end)
end

function vape:UpdateGUIQueue(hue, sat, val)
	if TextGUI.Button.Enabled then
		TextGUI:UpdateColor(hue, sat, val, default)
	end

	if not clickgui.Visible and not vape.Legit.Window.Visible then return end
	local isRainbow = vape.GUIColor.Rainbow and vape.RainbowMode.Value ~= 'Retro'

	for name, component in vape.Categories do
		component:Color(hue, sat, val, isRainbow)
	end

	for _, component in vape.Modules do
		component:Color(hue, sat, val, isRainbow)
	end

	for _, component in vape.Overlays.Options do
		if component.Color then
			component:Color(hue, sat, val, isRainbow)
		end
	end

	for _, pane in vape.Settings do
		for _, component in pane.Options do
			if component.Color then
				component:Color(hue, sat, val, isRainbow)
			end
		end
	end

	if vape.Legit.Window.Visible then
		for _, component in vape.Legit.Modules do
			component:Color(hue, sat, val, isRainbow)
		end
	end
end

--Components

vape.Components = setmetatable(components, {
	__newindex = function(_, index, callback)
		for _, module in vape.Modules do
			rawset(module, 'Create'..index, function(_, props)
				return callback(props, module.Children, module)
			end)
		end

		if vape.Legit then
			for _, module in vape.Legit.Modules do
				rawset(module, 'Create'..index, function(_, props)
					return callback(props, module.Children, module)
				end)
			end
		end

		rawset(components, index, callback)
	end
})

vape:LoadGUI()

return vape