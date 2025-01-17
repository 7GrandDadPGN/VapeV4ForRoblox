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
	Version = '6.1.30',
	Windows = {}
}

local cloneref = cloneref or function(obj)
	return obj
end
local tweenService = cloneref(game:GetService('TweenService'))
local inputService = cloneref(game:GetService('UserInputService'))
local textService = cloneref(game:GetService('TextService'))
local guiService = cloneref(game:GetService('GuiService'))
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
local guiTween2
local scale
local gui

local color = {}
local tween = {
	tweens = {},
	tweenstwo = {}
}
local uipallet = {
	Main = Color3.fromRGB(23, 26, 33),
	MainColor = Color3.fromRGB(12, 163, 232),
	SecondaryColor = Color3.fromRGB(12, 232, 199),
	Text = Color3.new(1, 1, 1),
	Tween = TweenInfo.new(0.16, Enum.EasingStyle.Linear),
	Themes = {
		Aubergine = {{Color3.fromRGB(170, 7, 107), Color3.fromRGB(97, 4, 95)}, 1, 8},
		Aqua = {{Color3.fromRGB(185, 250, 255), Color3.fromRGB(79, 199, 200)}, 6},
		Banana = {{Color3.fromRGB(253, 236, 177), Color3.fromRGB(255, 255, 255)}, 3},
		Blend = {{Color3.fromRGB(71, 148, 253), Color3.fromRGB(71, 253, 160)}, 4, 6},
		Blossom = {{Color3.fromRGB(226, 208, 249), Color3.fromRGB(49, 119, 115)}, 9, 10},
		Bubblegum = {{Color3.fromRGB(243, 145, 216), Color3.fromRGB(152, 165, 243)}, 8, 9},
		['Candy Cane'] = {{Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 255, 255)}, 1},
		Cherry = {{Color3.fromRGB(187, 55, 125), Color3.fromRGB(251, 211, 233)}, 1, 8, 9},
		Christmas = {{Color3.fromRGB(255, 64, 64), Color3.fromRGB(255, 255, 255), Color3.fromRGB(64, 255, 64)}, 1, 4},
		Coral = {{Color3.fromRGB(244, 168, 150), Color3.fromRGB(52, 133, 151)}, 2, 7, 9},
		Creida = {{Color3.fromRGB(156, 164, 224), Color3.fromRGB(54, 57, 78)}, 10},
		['Creida Two'] = {{Color3.fromRGB(154, 202, 235), Color3.fromRGB(88, 130, 161)}, 10},
		['Digital Horizon'] = {{Color3.fromRGB(95, 195, 228), Color3.fromRGB(229, 93, 135)}, 1, 6, 9},
		Express = {{Color3.fromRGB(173, 83, 137), Color3.fromRGB(60, 16, 83)}, 8, 9},
		Gothic = {{Color3.fromRGB(31, 30, 30), Color3.fromRGB(196, 190, 190)}, 10},
		Halogen = {{Color3.fromRGB(255, 65, 108), Color3.fromRGB(255, 75, 43)}, 1, 2},
		Hyper = {{Color3.fromRGB(236, 110, 173), Color3.fromRGB(52, 148, 230)}, 6, 7, 9},
		Legacy = {{Color3.fromRGB(112, 206, 255), Color3.fromRGB(112, 206, 255)}, 6, 7},
		['Lime Water'] = {{Color3.fromRGB(18, 255, 247), Color3.fromRGB(179, 255, 171)}, 4, 6},
		Lush = {{Color3.fromRGB(168, 224, 99), Color3.fromRGB(86, 171, 47)}, 4, 5},
		Magic = {{Color3.fromRGB(74, 0, 224), Color3.fromRGB(142, 45, 226)}, 7, 8},
		May = {{Color3.fromRGB(170, 7, 107), Color3.fromRGB(238, 79, 238)}, 8, 9},
		['Orange Juice'] = {{Color3.fromRGB(252, 74, 26), Color3.fromRGB(247, 183, 51)}, 2, 3},
		Pastel = {{Color3.fromRGB(243, 155, 178), Color3.fromRGB(207, 196, 243)}, 9},
		Peony = {{Color3.fromRGB(226, 208, 249), Color3.fromRGB(207, 171, 255)}, 9, 10},
		Pumpkin = {{Color3.fromRGB(241, 166, 98), Color3.fromRGB(255, 216, 169), Color3.fromRGB(227, 139, 42)}, 2},
		Purple = {{Color3.fromRGB(82, 67, 145), Color3.fromRGB(117, 95, 207)}, 8},
		Rainbow = {{Color3.new(1, 1, 1), Color3.new(1, 1, 1)}, 10},
		Rue = {{Color3.fromRGB(234, 118, 176), Color3.fromRGB(31, 30, 30)}, 9},
		Satin = {{Color3.fromRGB(215, 60, 67), Color3.fromRGB(140, 23, 39)}, 1},
		Shadow = {{Color3.fromRGB(97, 131, 255), Color3.fromRGB(206, 212, 255)}, 6},
		['Snowy Sky'] = {{Color3.fromRGB(1, 171, 179), Color3.fromRGB(234, 234, 234), Color3.fromRGB(18, 232, 232)}, 6, 10},
		['Steel Fade'] = {{Color3.fromRGB(66, 134, 244), Color3.fromRGB(55, 59, 68)}, 7, 10},
		Sundae = {{Color3.fromRGB(206, 74, 126), Color3.fromRGB(122, 44, 77)}, 1, 8, 9},
		Sunkist = {{Color3.fromRGB(242, 201, 76), Color3.fromRGB(242, 153, 74)}, 2, 3},
		Water = {{Color3.fromRGB(12, 232, 199), Color3.fromRGB(12, 163, 232)}, 6, 7},
		Winter = {{Color3.new(1, 1, 1), Color3.new(1, 1, 1)}, 10},
		Wood = {{Color3.fromRGB(79, 109, 81), Color3.fromRGB(170, 139, 87), Color3.fromRGB(240, 235, 206)}, 5}
	},
	ThemeObjects = {}
}

local themecolors = {
	Color3.fromRGB(248, 57, 57),
	Color3.fromRGB(250, 128, 55),
	Color3.fromRGB(252, 255, 53),
	Color3.fromRGB(128, 255, 50),
	Color3.fromRGB(50, 128, 50),
	Color3.fromRGB(50, 200, 255),
	Color3.fromRGB(50, 105, 200),
	Color3.fromRGB(128, 52, 255),
	Color3.fromRGB(255, 128, 255),
	Color3.fromRGB(100, 100, 110)
}

local getcustomassets = {
	['newvape/assets/rise/slice.png'] = 'rbxasset://risesix/slice.png',
	['newvape/assets/rise/blur.png'] = 'rbxasset://risesix/blur.png',
	['newvape/assets/new/blur.png'] = 'rbxassetid://14898786664',
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
	corner.CornerRadius = radius or UDim.new(0, 22)
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

local function createHighlight(size, pos)
	local old = categoryhighlight
	local info = TweenInfo.new(0.3)
	if old then
		if old.Position == pos then return end
		tween:Tween(old, info, {
			BackgroundTransparency = 1
		})
		task.delay(0.4, function()
			old:Destroy()
		end)
	end
	categoryhighlight = Instance.new('Frame')
	categoryhighlight.Size = size
	categoryhighlight.Position = pos
	categoryhighlight.BackgroundTransparency = old and 1 or 0
	categoryhighlight.BackgroundColor3 = uipallet.MainColor
	categoryhighlight.Parent = sidebar
	addCorner(categoryhighlight, UDim.new(0, 10))
	if old then
		tween:Tween(categoryhighlight, info, {
			BackgroundTransparency = 0
		})
	end
end

local function downloadFile(path, func)
	if not isfile(path) then
		createDownloader(path)
		local suc, res = pcall(function()
			return game:HttpGet('https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/'..readfile('newvape/profiles/commit.txt')..'/'..select(1, path:gsub('newvape/', '')), true)
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
		if window and not window.Visible then return end
		if
			(inputObj.UserInputType == Enum.UserInputType.MouseButton1 or inputObj.UserInputType == Enum.UserInputType.Touch)
			and (inputObj.Position.Y - obj.AbsolutePosition.Y < 40 or window)
		then
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
	if not assetfunction then return 'rbxasset://fonts/productsans.json' end
	writefile('newvape/assets/rise/risefont.json', httpService:JSONEncode({
		name = 'ProductSans',
		faces = {
			{style = 'normal', assetId = getcustomasset('newvape/assets/rise/SF-Pro-Rounded-Light.otf'), name = 'Light', weight = 300},
			{style = 'normal', assetId = getcustomasset('newvape/assets/rise/SF-Pro-Rounded-Regular.otf'), name = 'Regular', weight = 400},
			{style = 'normal', assetId = getcustomasset('newvape/assets/rise/SF-Pro-Rounded-Medium.otf'), name = 'Medium', weight = 500},
			{style = 'normal', assetId = getcustomasset('newvape/assets/rise/Icon-1.ttf'), name = 'Icon1', weight = 600},
			{style = 'normal', assetId = getcustomasset('newvape/assets/rise/Icon-3.ttf'), name = 'Icon3', weight = 800}
		}
	}))
	return getcustomasset('newvape/assets/rise/risefont.json')
end

if inputService.TouchEnabled then
	writefile('newvape/profiles/gui.txt', 'new')
	return
end

do
	local risefont = writeFont()
	uipallet.Font = Font.new(risefont, Enum.FontWeight.Regular)
	uipallet.FontSemiBold = Font.new(risefont, Enum.FontWeight.Medium)
	uipallet.FontLight = Font.new(risefont, Enum.FontWeight.Light)
	uipallet.FontIcon1 = Font.new(risefont, Enum.FontWeight.SemiBold)
	uipallet.FontIcon3 = Font.new(risefont, Enum.FontWeight.ExtraBold)

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
	local function getBlendFactor(vec)
		return math.sin(DateTime.now().UnixTimestampMillis / 600 + vec.X * 0.005 + vec.Y * 0.06) * 0.5 + 0.5
	end

	function color.Dark(col, num)
		local h, s, v = col:ToHSV()
		return Color3.fromHSV(h, s, math.clamp(select(3, uipallet.Main:ToHSV()) > 0.5 and v + num or v - num, 0, 1))
	end

	function color.Light(col, num)
		local h, s, v = col:ToHSV()
		return Color3.fromHSV(h, s, math.clamp(select(3, uipallet.Main:ToHSV()) > 0.5 and v - num or v + num, 0, 1))
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

	function mainapi:TextColor(h, s, v, col)
		if v < 0.7 then
			return Color3.new(1, 1, 1)
		end
		if s < 0.6 or h > 0.04 and h < 0.56 then
			return col or color.Light(uipallet.Main, 0.14)
		end
		return Color3.new(1, 1, 1)
	end

	function mainapi:RiseColor(vec)
		local blend = getBlendFactor(vec)
		if uipallet.ThirdColor then
			if blend <= 0.5 then
				return uipallet.MainColor:Lerp(uipallet.SecondaryColor, blend * 2)
			end
			return uipallet.SecondaryColor:Lerp(uipallet.ThirdColor, (blend - 0.5) * 2)
		end
		return uipallet.SecondaryColor:Lerp(uipallet.MainColor, blend)
	end

	function mainapi:RiseColorCustom(v, offset)
		local blend = getBlendFactor(Vector2.new(offset))
		if v[3] then
			if blend <= 0.5 then
				return v[1]:Lerp(v[2], blend * 2)
			end
			return v[2]:Lerp(v[3], (blend - 0.5) * 2)
		end
		return v[2]:Lerp(v[1], blend)
	end
end

do
	function tween:Tween(obj, tweeninfo, goal, tab, bypass)
		tab = tab or self.tweens
		if tab[obj] then
			tab[obj]:Cancel()
			tab[obj] = nil
		end

		if bypass or obj.Parent and obj.Visible then
			tab[obj] = tweenService:Create(obj, tweeninfo, goal)
			tab[obj].Completed:Once(function()
				if tab then
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
	Button = function(optionsettings, children, api)
		local button = Instance.new('TextButton')
		button.Name = optionsettings.Name..'Button'
		button.Size = UDim2.new(1, 0, 0, 28)
		button.BackgroundTransparency = 1
		button.Text = ''
		button.Visible = optionsettings.Visible == nil or optionsettings.Visible
		button.Parent = children
		local title = Instance.new('TextLabel')
		title.Size = UDim2.new(1, -13, 1, 0)
		title.Position = UDim2.fromOffset(13 + (optionsettings.Darker and 20 or 0), 0)
		title.BackgroundTransparency = 1
		title.Text = optionsettings.Name
		title.TextColor3 = color.Dark(uipallet.Text, 0.21)
		title.TextSize = 18
		title.TextXAlignment = Enum.TextXAlignment.Left
		title.FontFace = uipallet.Font
		title.Parent = button
		optionsettings.Function = optionsettings.Function or function() end
		
		button.MouseButton1Click:Connect(function() optionsettings.Function() end)
	end,
	ColorSlider = function(optionsettings, children, api)
		local optionapi = {
			Type = 'ColorSlider',
			Hue = optionsettings.DefaultHue or 0.44,
			Sat = optionsettings.DefaultSat or 1,
			Value = optionsettings.DefaultValue or 1,
			Opacity = optionsettings.DefaultOpacity or 1,
			Rainbow = false,
			Index = 0
		}
		
		local startpos = getfontsize(optionsettings.Name, 18, uipallet.Font).X + (optionsettings.Darker and 20 or 0) + 26
		local slider = Instance.new('TextButton')
		slider.Name = optionsettings.Name..'Slider'
		slider.Size = UDim2.new(1, 0, 0, 28)
		slider.BackgroundTransparency = 1
		slider.Text = ''
		slider.Visible = optionsettings.Visible == nil or optionsettings.Visible
		slider.Parent = children
		local title = Instance.new('TextLabel')
		title.Size = UDim2.new(1, -13, 1, 0)
		title.Position = UDim2.fromOffset(13 + (optionsettings.Darker and 20 or 0), 0)
		title.BackgroundTransparency = 1
		title.Text = optionsettings.Name
		title.TextColor3 = color.Dark(uipallet.Text, 0.21)
		title.TextSize = 18
		title.TextXAlignment = Enum.TextXAlignment.Left
		title.FontFace = uipallet.Font
		title.Parent = slider
		local valuebutton = Instance.new('TextButton')
		valuebutton.Name = 'Value'
		valuebutton.Size = UDim2.new(1, -13, 1, 0)
		valuebutton.Position = UDim2.fromOffset(startpos + 210, 0)
		valuebutton.BackgroundTransparency = 1
		valuebutton.Text = '0, 255, 60'
		valuebutton.TextColor3 = color.Dark(uipallet.Text, 0.21)
		valuebutton.TextSize = 18
		valuebutton.TextXAlignment = Enum.TextXAlignment.Left
		valuebutton.FontFace = uipallet.Font
		valuebutton.Parent = slider
		local valuebox = Instance.new('TextBox')
		valuebox.Name = 'Box'
		valuebox.Size = valuebutton.Size
		valuebox.Position = valuebutton.Position
		valuebox.BackgroundTransparency = 1
		valuebox.Text = valuebutton.Text
		valuebox.TextColor3 = color.Dark(uipallet.Text, 0.21)
		valuebox.TextSize = 18
		valuebox.TextXAlignment = Enum.TextXAlignment.Left
		valuebox.FontFace = uipallet.Font
		valuebox.ClearTextOnFocus = false
		valuebox.Visible = false
		valuebox.Parent = slider
		local bkg = Instance.new('Frame')
		bkg.Name = 'Slider'
		bkg.Size = UDim2.fromOffset(200, 4)
		bkg.Position = UDim2.fromOffset(startpos, 13)
		bkg.BackgroundColor3 = Color3.new(1, 1, 1)
		bkg.Parent = slider
		addCorner(bkg, UDim.new(1, 0))
		local fill = bkg:Clone()
		fill.Name = 'Fill'
		fill.Size = UDim2.fromScale(0.44, 1)
		fill.Position = UDim2.new()
		fill.BackgroundTransparency = 1
		fill.Parent = bkg
		local rainbowTable = {}
		for i = 0, 1, 0.1 do
			table.insert(rainbowTable, ColorSequenceKeypoint.new(i, Color3.fromHSV(i, 1, 1)))
		end
		local gradient = Instance.new('UIGradient')
		gradient.Color = ColorSequence.new(rainbowTable)
		gradient.Parent = bkg
		local knob = Instance.new('Frame')
		knob.Name = 'Knob'
		knob.Size = UDim2.fromOffset(10, 10)
		knob.Position = UDim2.new(1, -5, 0, -3)
		knob.BackgroundColor3 = Color3.new(1, 1, 1)
		knob.Parent = fill
		addCorner(knob, UDim.new(1, 0))
		optionsettings.Function = optionsettings.Function or function() end
		
		function optionapi:Save(tab)
			tab[optionsettings.Name] = {
				Hue = self.Hue,
				Sat = self.Sat,
				Value = self.Value,
				Opacity = self.Opacity,
				Rainbow = self.Rainbow
			}
		end
		
		function optionapi:Load(tab)
			if tab.Rainbow ~= self.Rainbow then
				self:Toggle()
			end
			if self.Hue ~= tab.Hue or self.Sat ~= tab.Sat or self.Value ~= tab.Value or self.Opacity ~= tab.Opacity then
				self:SetValue(tab.Hue, tab.Sat, tab.Value, tab.Opacity)
			end
		end
		
		function optionapi:SetValue(h, s, v, o)
			self.Hue = h or self.Hue
			self.Sat = s or self.Sat
			self.Value = v or self.Value
			self.Opacity = o or self.Opacity
			if self.Rainbow then
				fill.Size = UDim2.fromScale(math.clamp(self.Hue, 0, 0.99), 1)
				valuebutton.Text = 'Rainbow'
			else
				tween:Tween(fill, uipallet.Tween, {
					Size = UDim2.fromScale(math.clamp(self.Hue, 0, 0.99), 1)
				})
				local text = Color3.fromHSV(self.Hue, self.Sat, self.Value)
				valuebutton.Text = math.round(text.R * 255)..', '..math.round(text.G * 255)..', '..math.round(text.B * 255)
			end
			optionsettings.Function(self.Hue, self.Sat, self.Value, self.Opacity)
		end
		
		function optionapi:Toggle()
			self.Rainbow = not self.Rainbow
			if self.Rainbow then
				table.insert(mainapi.RainbowTable, self)
			else
				local ind = table.find(mainapi.RainbowTable, self)
				if ind then
					table.remove(mainapi.RainbowTable, ind)
				end
			end
		end
		
		local doubleClick = tick()
		slider.InputBegan:Connect(function(inputObj)
			if (inputObj.UserInputType == Enum.UserInputType.MouseButton1 or inputObj.UserInputType == Enum.UserInputType.Touch) then
				if doubleClick > tick() then
					optionapi:Toggle()
				end
				doubleClick = tick() + 0.3
				local changed = inputService.InputChanged:Connect(function(input)
					if input.UserInputType == (inputObj.UserInputType == Enum.UserInputType.MouseButton1 and Enum.UserInputType.MouseMovement or Enum.UserInputType.Touch) then
						optionapi:SetValue(math.clamp((input.Position.X - bkg.AbsolutePosition.X) / bkg.AbsoluteSize.X, 0, 1))
					end
				end)
		
				local ended
				ended = inputObj.Changed:Connect(function()
					if inputObj.UserInputState == Enum.UserInputState.End then
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
		valuebutton.MouseButton1Click:Connect(function()
			valuebutton.Visible = false
			valuebox.Visible = true
			valuebox:CaptureFocus()
			local text = Color3.fromHSV(optionapi.Hue, optionapi.Sat, optionapi.Value)
			valuebox.Text = math.round(text.R * 255)..', '..math.round(text.G * 255)..', '..math.round(text.B * 255)
		end)
		valuebox.FocusLost:Connect(function(enter)
			valuebutton.Visible = true
			valuebox.Visible = false
			if enter then
				local commas = valuebox.Text:split(',')
				local suc, res = pcall(function()
					return tonumber(commas[1]) and Color3.fromRGB(tonumber(commas[1]), tonumber(commas[2]), tonumber(commas[3])) or Color3.fromHex(valuebox.Text)
				end)
				if suc then
					if optionapi.Rainbow then
						optionapi:Toggle()
					end
					optionapi:SetValue(res:ToHSV())
				end
			end
		end)
		
		optionapi.Object = slider
		api.Options[optionsettings.Name] = optionapi
		
		return optionapi
	end,
	Dropdown = function(optionsettings, children, api)
		local optionapi = {
			Type = 'Dropdown',
			Value = optionsettings.List[1] or 'None',
			Index = 0
		}
		
		local dropdown = Instance.new('TextButton')
		dropdown.Name = optionsettings.Name..'Dropdown'
		dropdown.Size = UDim2.new(1, 0, 0, 28)
		dropdown.BackgroundTransparency = 1
		dropdown.Text = ''
		dropdown.Visible = optionsettings.Visible == nil or optionsettings.Visible
		dropdown.Parent = children
		local title = Instance.new('TextLabel')
		title.Size = UDim2.new(1, -13, 1, 0)
		title.Position = UDim2.fromOffset(13 + (optionsettings.Darker and 20 or 0), 0)
		title.BackgroundTransparency = 1
		title.Text = optionsettings.Name..': '..optionapi.Value
		title.TextColor3 = color.Dark(uipallet.Text, 0.21)
		title.TextSize = 18
		title.TextXAlignment = Enum.TextXAlignment.Left
		title.FontFace = uipallet.Font
		title.Parent = dropdown
		optionsettings.Function = optionsettings.Function or function() end
		
		function optionapi:Save(tab)
			tab[optionsettings.Name] = {Value = self.Value}
		end
		
		function optionapi:Load(tab)
			if self.Value ~= tab.Value then
				self:SetValue(tab.Value)
			end
		end
		
		function optionapi:Change(list)
			optionsettings.List = list or {}
			if not table.find(optionsettings.List, self.Value) then
				self:SetValue(self.Value)
			end
		end
		
		function optionapi:SetValue(val, mouse)
			self.Value = table.find(optionsettings.List, val) and val or optionsettings.List[1] or 'None'
			title.Text = optionsettings.Name..': '..self.Value
			optionsettings.Function(self.Value, mouse)
		end
		
		dropdown.MouseButton1Click:Connect(function()
			optionapi:SetValue(optionsettings.List[(table.find(optionsettings.List, optionapi.Value) % #optionsettings.List) + 1], true)
		end)
		dropdown.MouseButton2Click:Connect(function()
			local num = table.find(optionsettings.List, optionapi.Value) - 1
			optionapi:SetValue(optionsettings.List[num < 1 and #optionsettings.List or num], true)
		end)
		
		optionapi.Object = dropdown
		api.Options[optionsettings.Name] = optionapi
		
		return optionapi
	end,
	Font = function(optionsettings, children, api)
		local fonts = {
			optionsettings.Blacklist,
			'Custom'
		}
		for _, v in Enum.Font:GetEnumItems() do
			if not table.find(fonts, v.Name) then table.insert(fonts, v.Name) end
		end
		
		local optionapi = {Value = Font.fromEnum(Enum.Font[fonts[1]])}
		local fontdropdown
		local fontbox
		optionsettings.Function = optionsettings.Function or function() end
		
		fontdropdown = components.Dropdown({
			Name = optionsettings.Name,
			List = fonts,
			Function = function(val)
				fontbox.Object.Visible = val == 'Custom' and fontdropdown.Object.Visible
				if val ~= 'Custom' then
					optionapi.Value = Font.fromEnum(Enum.Font[val])
					optionsettings.Function(optionapi.Value)
				else
					pcall(function()
						optionapi.Value = Font.fromId(tonumber(fontbox.Value))
					end)
					optionsettings.Function(optionapi.Value)
				end
			end,
			Darker = optionsettings.Darker,
			Visible = optionsettings.Visible
		}, children, api)
		optionapi.Object = fontdropdown.Object
		fontbox = components.TextBox({
			Name = optionsettings.Name..' Asset',
			Placeholder = 'font (rbxasset)',
			Function = function()
				if fontdropdown.Value == 'Custom' then
					pcall(function()
						optionapi.Value = Font.fromId(tonumber(fontbox.Value))
					end)
					optionsettings.Function(optionapi.Value)
				end
			end,
			Visible = false,
			Darker = true
		}, children, api)
		
		fontdropdown.Object:GetPropertyChangedSignal('Visible'):Connect(function()
			fontbox.Object.Visible = fontdropdown.Object.Visible and fontdropdown.Value == 'Custom'
		end)
		
		return optionapi
	end,
	Slider = function(optionsettings, children, api)
		local optionapi = {
			Type = 'Slider',
			Value = optionsettings.Default or optionsettings.Min,
			Max = optionsettings.Max,
			Index = getTableSize(api.Options)
		}
		
		local startpos = getfontsize(optionsettings.Name, 18, uipallet.Font).X + (optionsettings.Darker and 20 or 0) + 26
		local slider = Instance.new('TextButton')
		slider.Name = optionsettings.Name..'Slider'
		slider.Size = UDim2.new(1, 0, 0, 28)
		slider.BackgroundTransparency = 1
		slider.Text = ''
		slider.Visible = optionsettings.Visible == nil or optionsettings.Visible
		slider.Parent = children
		local title = Instance.new('TextLabel')
		title.Size = UDim2.new(1, -13, 1, 0)
		title.Position = UDim2.fromOffset(13 + (optionsettings.Darker and 20 or 0), 0)
		title.BackgroundTransparency = 1
		title.Text = optionsettings.Name
		title.TextColor3 = color.Dark(uipallet.Text, 0.21)
		title.TextSize = 18
		title.TextXAlignment = Enum.TextXAlignment.Left
		title.FontFace = uipallet.Font
		title.Parent = slider
		local valuebutton = Instance.new('TextButton')
		valuebutton.Name = 'Value'
		valuebutton.Size = UDim2.new(1, -13, 1, 0)
		valuebutton.Position = UDim2.fromOffset(startpos + 210, 0)
		valuebutton.BackgroundTransparency = 1
		valuebutton.Text = optionapi.Value..(optionsettings.Suffix and ' '..(type(optionsettings.Suffix) == 'function' and optionsettings.Suffix(optionapi.Value) or optionsettings.Suffix) or '')
		valuebutton.TextColor3 = color.Dark(uipallet.Text, 0.21)
		valuebutton.TextSize = 18
		valuebutton.TextXAlignment = Enum.TextXAlignment.Left
		valuebutton.FontFace = uipallet.Font
		valuebutton.Parent = slider
		local valuebox = Instance.new('TextBox')
		valuebox.Name = 'Box'
		valuebox.Size = valuebutton.Size
		valuebox.Position = valuebutton.Position
		valuebox.BackgroundTransparency = 1
		valuebox.Text = optionapi.Value
		valuebox.TextColor3 = color.Dark(uipallet.Text, 0.21)
		valuebox.TextSize = 18
		valuebox.TextXAlignment = Enum.TextXAlignment.Left
		valuebox.FontFace = uipallet.Font
		valuebox.ClearTextOnFocus = false
		valuebox.Visible = false
		valuebox.Parent = slider
		local bkg = Instance.new('Frame')
		bkg.Name = 'Slider'
		bkg.Size = UDim2.fromOffset(200, 4)
		bkg.Position = UDim2.fromOffset(startpos, 13)
		bkg.BackgroundColor3 = uipallet.Main
		bkg.Parent = slider
		addCorner(bkg, UDim.new(1, 0))
		local fill = bkg:Clone()
		fill.Name = 'Fill'
		fill.Size = UDim2.fromScale(math.clamp((optionapi.Value - optionsettings.Min) / optionsettings.Max, 0, 1), 1)
		fill.Position = UDim2.new()
		fill.BackgroundColor3 = color.Dark(uipallet.MainColor, 0.5)
		fill.Parent = bkg
		local knob = Instance.new('Frame')
		knob.Name = 'Knob'
		knob.Size = UDim2.fromOffset(10, 10)
		knob.Position = UDim2.new(1, -5, 0, -3)
		knob.BackgroundColor3 = uipallet.MainColor
		knob.Parent = fill
		addCorner(knob, UDim.new(1, 0))
		optionsettings.Function = optionsettings.Function or function() end
		optionsettings.Decimal = optionsettings.Decimal or 1
		
		function optionapi:Save(tab)
			tab[optionsettings.Name] = {
				Value = self.Value,
				Max = self.Max
			}
		end
		
		function optionapi:Load(tab)
			local newval = tab.Value == tab.Max and tab.Max ~= self.Max and self.Max or tab.Value
			if self.Value ~= newval then
				self:SetValue(newval, nil, true)
			end
		end
		
		function optionapi:Color(hue, sat, val, rainbowcheck)
			fill.BackgroundColor3 = color.Dark(uipallet.MainColor, 0.5)
			knob.BackgroundColor3 = uipallet.MainColor
		end
		
		function optionapi:SetValue(value, pos, final)
			if tonumber(value) == math.huge or value ~= value then return end
			local check = self.Value ~= value
			self.Value = value
			tween:Tween(fill, uipallet.Tween, {
				Size = UDim2.fromScale(math.clamp(pos or math.clamp(value / optionsettings.Max, 0, 1), 0, 1), 1)
			})
			valuebutton.Text = self.Value..(optionsettings.Suffix and ' '..(type(optionsettings.Suffix) == 'function' and optionsettings.Suffix(self.Value) or optionsettings.Suffix) or '')
			if check or final then
				optionsettings.Function(value, final)
			end
		end
		
		slider.InputBegan:Connect(function(inputObj)
			if (inputObj.UserInputType == Enum.UserInputType.MouseButton1 or inputObj.UserInputType == Enum.UserInputType.Touch) then
				local newPosition = math.clamp((inputObj.Position.X - bkg.AbsolutePosition.X) / bkg.AbsoluteSize.X, 0, 1)
				optionapi:SetValue(math.floor((optionsettings.Min + (optionsettings.Max - optionsettings.Min) * newPosition) * optionsettings.Decimal) / optionsettings.Decimal, newPosition)
				local lastValue = optionapi.Value
				local lastPosition = newPosition
		
				local changed = inputService.InputChanged:Connect(function(input)
					if input.UserInputType == (inputObj.UserInputType == Enum.UserInputType.MouseButton1 and Enum.UserInputType.MouseMovement or Enum.UserInputType.Touch) then
						local newPosition = math.clamp((input.Position.X - bkg.AbsolutePosition.X) / bkg.AbsoluteSize.X, 0, 1)
						optionapi:SetValue(math.floor((optionsettings.Min + (optionsettings.Max - optionsettings.Min) * newPosition) * optionsettings.Decimal) / optionsettings.Decimal, newPosition)
						lastValue = optionapi.Value
						lastPosition = newPosition
					end
				end)
		
				local ended
				ended = inputObj.Changed:Connect(function()
					if inputObj.UserInputState == Enum.UserInputState.End then
						if changed then
							changed:Disconnect()
						end
						if ended then
							ended:Disconnect()
						end
						optionapi:SetValue(lastValue, lastPosition, true)
					end
				end)
			end
		end)
		valuebutton.MouseButton1Click:Connect(function()
			valuebutton.Visible = false
			valuebox.Visible = true
			valuebox.Text = optionapi.Value
			valuebox:CaptureFocus()
		end)
		valuebox.FocusLost:Connect(function(enter)
			valuebutton.Visible = true
			valuebox.Visible = false
			if enter and tonumber(valuebox.Text) then
				optionapi:SetValue(tonumber(valuebox.Text), nil, true)
			end
		end)
		
		optionapi.Object = slider
		api.Options[optionsettings.Name] = optionapi
		
		return optionapi
	end,
	Targets = function(optionsettings, children, api)
		local optionapi = {
			Type = 'Targets',
			Index = getTableSize(api.Options)
		}
		
		local textlist = components.Toggle({
			Name = 'Targets',
			Function = function(callback)
				optionapi.Players.Object.Visible = callback
				optionapi.NPCs.Object.Visible = callback
				optionapi.Invisible.Object.Visible = callback
				optionapi.Walls.Object.Visible = callback
			end
		}, children, api)
		optionsettings.Function = optionsettings.Function or function() end
		
		function optionapi:Save(tab)
			tab.Targets = {
				Players = self.Players.Enabled,
				NPCs = self.NPCs.Enabled,
				Invisible = self.Invisible.Enabled,
				Walls = self.Walls.Enabled
			}
		end
		
		function optionapi:Load(tab)
			if self.Players.Enabled ~= tab.Players then
				self.Players:Toggle()
			end
			if self.NPCs.Enabled ~= tab.NPCs then
				self.NPCs:Toggle()
			end
			if self.Invisible.Enabled ~= tab.Invisible then
				self.Invisible:Toggle()
			end
			if self.Walls.Enabled ~= tab.Walls then
				self.Walls:Toggle()
			end
		end
		
		function optionapi:Color(hue, sat, val, rainbowcheck)
			for _, v in {textlist, self.Players, self.NPCs, self.Invisible, self.Walls} do
				v:Color(hue, sat, val, rainbowcheck)
			end
		end
		
		optionapi.Players = components.Toggle({
			Name = 'Players',
			Function = optionsettings.Function,
			Special = true,
			Darker = true,
			Visible = false
		}, children, api)
		optionapi.NPCs = components.Toggle({
			Name = 'NPCs',
			Function = optionsettings.Function,
			Special = true,
			Darker = true,
			Visible = false
		}, children, api)
		optionapi.Invisible = components.Toggle({
			Name = 'Ignore invisible',
			Function = optionsettings.Function,
			Special = true,
			Darker = true,
			Visible = false
		}, children, api)
		optionapi.Walls = components.Toggle({
			Name = 'Ignore behind walls',
			Function = optionsettings.Function,
			Special = true,
			Darker = true,
			Visible = false
		}, children, api)
		if optionsettings.Players then
			optionapi.Players:Toggle()
		end
		if optionsettings.NPCs then
			optionapi.NPCs:Toggle()
		end
		if optionsettings.Invisible then
			optionapi.Invisible:Toggle()
		end
		if optionsettings.Walls then
			optionapi.Walls:Toggle()
		end
		
		optionapi.Object = textlist.Object
		api.Options.Targets = optionapi
		
		return optionapi
	end,
	TextBox = function(optionsettings, children, api)
		local optionapi = {
			Type = 'TextBox',
			Value = optionsettings.Default or '',
			Index = 0
		}
		
		local textbox = Instance.new('TextButton')
		textbox.Name = optionsettings.Name..'TextBox'
		textbox.Size = UDim2.new(1, 0, 0, 55)
		textbox.BackgroundTransparency = 1
		textbox.Text = ''
		textbox.Visible = optionsettings.Visible == nil or optionsettings.Visible
		textbox.Parent = children
		local title = Instance.new('TextLabel')
		title.Size = UDim2.new(1, -13, 1, -27)
		title.Position = UDim2.fromOffset(13 + (optionsettings.Darker and 20 or 0), 0)
		title.BackgroundTransparency = 1
		title.Text = optionsettings.Name
		title.TextColor3 = color.Dark(uipallet.Text, 0.21)
		title.TextSize = 18
		title.TextXAlignment = Enum.TextXAlignment.Left
		title.FontFace = uipallet.Font
		title.Parent = textbox
		local box = Instance.new('TextBox')
		box.Size = UDim2.new(1, -13, 1, -28)
		box.Position = UDim2.fromOffset(13 + (optionsettings.Darker and 20 or 0), 28)
		box.BackgroundTransparency = 1
		box.Text = optionsettings.Default or ''
		box.PlaceholderText = optionsettings.Placeholder or 'Click to set'
		box.TextXAlignment = Enum.TextXAlignment.Left
		box.TextColor3 = color.Dark(uipallet.Text, 0.21)
		box.PlaceholderColor3 = color.Dark(uipallet.Text, 0.31)
		box.TextSize = 18
		box.TextXAlignment = Enum.TextXAlignment.Left
		box.FontFace = uipallet.Font
		box.ClearTextOnFocus = false
		box.Parent = textbox
		optionsettings.Function = optionsettings.Function or function() end
		
		function optionapi:Save(tab)
			tab[optionsettings.Name] = {Value = self.Value}
		end
		
		function optionapi:Load(tab)
			if self.Value ~= tab.Value then
				self:SetValue(tab.Value)
			end
		end
		
		function optionapi:SetValue(val, enter)
			self.Value = val
			box.Text = val
			optionsettings.Function(enter)
		end
		
		textbox.MouseButton1Click:Connect(function()
			box:CaptureFocus()
		end)
		box.FocusLost:Connect(function(enter)
			optionapi:SetValue(box.Text, enter)
		end)
		box:GetPropertyChangedSignal('Text'):Connect(function()
			optionapi:SetValue(box.Text)
		end)
		
		optionapi.Object = textbox
		api.Options[optionsettings.Name] = optionapi
		
		return optionapi
	end,
	TextList = function(optionsettings, children, api)
		local optionapi = {
			Type = 'TextList',
			List = optionsettings.Default or {},
			ListEnabled = optionsettings.Default or {},
			Objects = {},
			Window = {Visible = false},
			Index = getTableSize(api.Options)
		}
		optionsettings.Color = optionsettings.Color or Color3.fromRGB(5, 134, 105)
		
		local textlist = Instance.new('TextButton')
		textlist.Name = optionsettings.Name..'TextList'
		textlist.Size = UDim2.new(1, 0, 0, 55)
		textlist.BackgroundTransparency = 1
		textlist.Text = ''
		textlist.Visible = optionsettings.Visible == nil or optionsettings.Visible
		textlist.Parent = children
		local title = Instance.new('TextLabel')
		title.Size = UDim2.new(1, -13, 0, 28)
		title.Position = UDim2.fromOffset(13 + (optionsettings.Darker and 20 or 0), 0)
		title.BackgroundTransparency = 1
		title.Text = optionsettings.Name
		title.TextColor3 = color.Dark(uipallet.Text, 0.21)
		title.TextSize = 18
		title.TextXAlignment = Enum.TextXAlignment.Left
		title.FontFace = uipallet.Font
		title.Parent = textlist
		local box = Instance.new('TextBox')
		box.Size = UDim2.new(1, -13, 0, 28)
		box.Position = UDim2.fromOffset(13 + (optionsettings.Darker and 20 or 0), 28)
		box.BackgroundTransparency = 1
		box.Text = ''
		box.PlaceholderText = optionsettings.Placeholder or 'Add entry...'
		box.TextXAlignment = Enum.TextXAlignment.Left
		box.TextColor3 = color.Dark(uipallet.Text, 0.21)
		box.PlaceholderColor3 = color.Dark(uipallet.Text, 0.31)
		box.TextSize = 18
		box.TextXAlignment = Enum.TextXAlignment.Left
		box.FontFace = uipallet.Font
		box.ClearTextOnFocus = false
		box.Parent = textlist
		local children = Instance.new('Frame')
		children.Size = UDim2.new()
		children.Position = UDim2.fromOffset(0, 55)
		children.BackgroundTransparency = 1
		children.Parent = textlist
		optionsettings.Function = optionsettings.Function or function() end
		
		function optionapi:Save(tab)
			tab[optionsettings.Name] = {
				List = self.List,
				ListEnabled = self.ListEnabled
			}
		end
		
		function optionapi:Load(tab)
			self.List = tab.List or {}
			self.ListEnabled = tab.ListEnabled or {}
			self:ChangeValue()
		end
		
		function optionapi:Color(hue, sat, val, rainbowcheck)
			if children.Visible then
				if optionsettings.Profiles then
					if self.Selected then
						self.Selected.TextLabel.TextColor3 = uipallet.MainColor
					end
				else
					for _, object in self.Objects do
						object.Dot.Dot.BackgroundColor3 = uipallet.MainColor
					end
				end
			end
		end
		
		function optionapi:ChangeValue(val)
			if val then
				if optionsettings.Profiles then
					local ind = self:GetValue(val)
					if ind then
						if val ~= 'default' then
							table.remove(mainapi.Profiles, ind)
							if isfile('newvape/profiles/'..val..mainapi.Place..'.txt') and delfile then
								delfile('newvape/profiles/'..val..mainapi.Place..'.txt')
							end
						end
					else
						table.insert(mainapi.Profiles, {Name = val, Bind = ''})
					end
				else
					local ind = table.find(self.List, val)
					if ind then
						table.remove(self.List, ind)
						ind = table.find(self.ListEnabled, val)
						if ind then
							table.remove(self.ListEnabled, ind)
						end
					else
						table.insert(self.List, val)
						table.insert(self.ListEnabled, val)
					end
				end
			end
		
			optionsettings.Function(self.List)
			for _, v in self.Objects do
				v:Destroy()
			end
			table.clear(self.Objects)
			self.Selected = nil
		
			local list = (optionsettings.Profiles and mainapi.Profiles or self.List)
			for i, v in list do
				local enabled = table.find(self.ListEnabled, v)
				local object = Instance.new('TextButton')
				object.Size = UDim2.new(1, 0, 0, 28)
				object.Position = UDim2.fromOffset(title.Position.X.Offset + 7, -28 + (i * 28))
				object.BackgroundTransparency = 1
				object.Text = ''
				object.Parent = children
				local objecttitle = Instance.new('TextLabel')
				objecttitle.Size = UDim2.new(1, -13, 1, 0)
				objecttitle.Position = UDim2.fromOffset(13, 0)
				objecttitle.BackgroundTransparency = 1
				objecttitle.Text = optionsettings.Profiles and v.Name or v
				objecttitle.TextColor3 = color.Dark(uipallet.Text, 0.21)
				objecttitle.TextSize = 18
				objecttitle.TextXAlignment = Enum.TextXAlignment.Left
				objecttitle.FontFace = uipallet.Font
				objecttitle.Parent = object
				if optionsettings.Profiles then
					object.MouseButton1Click:Connect(function()
						mainapi:Save(v.Name)
						mainapi:Load(true)
					end)
					object.MouseButton2Click:Connect(function()
						if v.Name ~= mainapi.Profile then
							categoryapi:ChangeValue(v.Name)
						end
					end)
					if v.Name == mainapi.Profile then
						objecttitle.TextColor3 = uipallet.MainColor
						objecttitle.TextStrokeTransparency = 0.5
						self.Selected = object
					end
				else
					local objectdot = Instance.new('Frame')
					objectdot.Name = 'Dot'
					objectdot.Size = UDim2.fromOffset(10, 10)
					objectdot.Position = UDim2.fromOffset(getfontsize(v, 18, uipallet.Font).X + 22, 10)
					objectdot.BackgroundColor3 = uipallet.Main
					objectdot.Parent = object
					addCorner(objectdot, UDim.new(1, 0))
					local objectdotin = objectdot:Clone()
					objectdotin.Size = UDim2.fromOffset(enabled and 10 or 0, enabled and 10 or 0)
					objectdotin.Position = UDim2.fromScale(0.5, 0.5)
					objectdotin.AnchorPoint = Vector2.new(0.5, 0.5)
					objectdotin.BackgroundColor3 = uipallet.MainColor
					objectdotin.Parent = objectdot
					object.MouseButton1Click:Connect(function()
						local ind = table.find(self.ListEnabled, v)
						if ind then
							table.remove(self.ListEnabled, ind)
						else
							table.insert(self.ListEnabled, v)
						end
						objectdotin.Visible = true
						tween:Tween(objectdotin, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
							Size = UDim2.fromOffset((not ind) and 10 or 0, (not ind) and 10 or 0)
						})
						task.delay(0.1, function()
							objectdotin.Visible = objectdotin.Size ~= UDim2.new()
						end)
						optionsettings.Function()
					end)
					object.MouseButton2Click:Connect(function()
						self:ChangeValue(v)
					end)
				end
				table.insert(self.Objects, object)
			end
			children.Size = UDim2.new(1, 0, 0, (#list * 28))
			if children.Visible then
				textlist.Size = UDim2.new(1, 0, 0, 55 + children.Size.Y.Offset)
			end
		end
		
		if optionsettings.Profiles then
			function optionapi:GetValue(name)
				for i, v in mainapi.Profiles do
					if v.Name == name then
						return i
					end
				end
			end
		end
		
		box.FocusLost:Connect(function(enter)
			if enter and not table.find(optionapi.List, box.Text) then
				optionapi:ChangeValue(box.Text)
				box.Text = ''
			end
		end)
		textlist.MouseButton1Click:Connect(function()
			children.Visible = not children.Visible
			textlist.Size = UDim2.new(1, 0, 0, 55 + children.Size.Y.Offset)
		end)
		
		if optionsettings.Default then
			optionapi:ChangeValue()
		end
		optionapi.Object = textlist
		api.Options[optionsettings.Name] = optionapi
		
		return optionapi
	end,
	Toggle = function(optionsettings, children, api)
		local optionapi = {
			Type = 'Toggle',
			Enabled = false,
			Index = getTableSize(api.Options)
		}
		
		local toggle = Instance.new('TextButton')
		toggle.Name = optionsettings.Name..'Toggle'
		toggle.Size = UDim2.new(1, 0, 0, 28)
		toggle.BackgroundTransparency = 1
		toggle.Text = ''
		toggle.Visible = optionsettings.Visible == nil or optionsettings.Visible
		toggle.Parent = children
		local title = Instance.new('TextLabel')
		title.Size = UDim2.new(1, -13, 1, 0)
		title.Position = UDim2.fromOffset(13 + (optionsettings.Darker and 20 or 0), 0)
		title.BackgroundTransparency = 1
		title.Text = optionsettings.Name
		title.TextColor3 = color.Dark(uipallet.Text, 0.21)
		title.TextSize = 18
		title.TextXAlignment = Enum.TextXAlignment.Left
		title.FontFace = uipallet.Font
		title.Parent = toggle
		local knobholder = Instance.new('Frame')
		knobholder.Name = 'Knob'
		knobholder.Size = UDim2.fromOffset(10, 10)
		knobholder.Position = UDim2.fromOffset(getfontsize(optionsettings.Name, 18, uipallet.Font).X + (optionsettings.Darker and 20 or 0) + 22, 10)
		knobholder.BackgroundColor3 = uipallet.Main
		knobholder.Parent = toggle
		addCorner(knobholder, UDim.new(1, 0))
		local knob = knobholder:Clone()
		knob.Size = UDim2.new()
		knob.Position = UDim2.fromScale(0.5, 0.5)
		knob.AnchorPoint = Vector2.new(0.5, 0.5)
		knob.BackgroundColor3 = uipallet.MainColor
		knob.Parent = knobholder
		optionsettings.Function = optionsettings.Function or function() end
		
		function optionapi:Save(tab)
			tab[optionsettings.Name] = {Enabled = self.Enabled}
		end
		
		function optionapi:Load(tab)
			if self.Enabled ~= tab.Enabled then
				self:Toggle()
			end
		end
		
		function optionapi:Color(hue, sat, val, rainbowcheck)
			if self.Enabled then
				knob.BackgroundColor3 = uipallet.MainColor
			end
		end
		
		function optionapi:Toggle()
			self.Enabled = not self.Enabled
			knob.Visible = true
			tween:Tween(knob, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
				Size = UDim2.fromOffset(self.Enabled and 10 or 0, self.Enabled and 10 or 0)
			})
			task.delay(0.1, function()
				knob.Visible = knob.Size ~= UDim2.new() or self.Enabled
			end)
			optionsettings.Function(self.Enabled)
		end
		
		toggle.MouseButton1Click:Connect(function()
			optionapi:Toggle()
		end)
		
		if optionsettings.Default then
			optionapi:Toggle()
		end
		optionapi.Object = toggle
		if not optionsettings.Special then
			api.Options[optionsettings.Name] = optionapi
		end
		
		return optionapi
	end,
	TwoSlider = function(optionsettings, children, api)
		local optionapi = {
			Type = 'TwoSlider',
			ValueMin = optionsettings.DefaultMin or optionsettings.Min,
			ValueMax = optionsettings.DefaultMax or 10,
			Max = optionsettings.Max,
			Index = getTableSize(api.Options)
		}
		
		local startpos = getfontsize(optionsettings.Name, 18, uipallet.Font).X + (optionsettings.Darker and 20 or 0) + 26
		local slider = Instance.new('TextButton')
		slider.Name = optionsettings.Name..'Slider'
		slider.Size = UDim2.new(1, 0, 0, 28)
		slider.BackgroundTransparency = 1
		slider.Text = ''
		slider.Visible = optionsettings.Visible == nil or optionsettings.Visible
		slider.Parent = children
		local title = Instance.new('TextLabel')
		title.Size = UDim2.new(1, -13, 1, 0)
		title.Position = UDim2.fromOffset(13 + (optionsettings.Darker and 20 or 0), 0)
		title.BackgroundTransparency = 1
		title.Text = optionsettings.Name
		title.TextColor3 = color.Dark(uipallet.Text, 0.21)
		title.TextSize = 18
		title.TextXAlignment = Enum.TextXAlignment.Left
		title.FontFace = uipallet.Font
		title.Parent = slider
		local valuebutton = Instance.new('TextButton')
		valuebutton.Name = 'Value'
		valuebutton.Size = UDim2.new(1, -13, 1, 0)
		valuebutton.Position = UDim2.fromOffset(startpos + 210, 0)
		valuebutton.BackgroundTransparency = 1
		valuebutton.Text = optionapi.ValueMin..' '..optionapi.ValueMax
		valuebutton.TextColor3 = color.Dark(uipallet.Text, 0.21)
		valuebutton.TextSize = 18
		valuebutton.TextXAlignment = Enum.TextXAlignment.Left
		valuebutton.FontFace = uipallet.Font
		valuebutton.Parent = slider
		local valuebox = Instance.new('TextBox')
		valuebox.Name = 'Box'
		valuebox.Size = valuebutton.Size
		valuebox.Position = valuebutton.Position
		valuebox.BackgroundTransparency = 1
		valuebox.Text = optionapi.ValueMin..' '..optionapi.ValueMax
		valuebox.TextColor3 = color.Dark(uipallet.Text, 0.21)
		valuebox.TextSize = 18
		valuebox.TextXAlignment = Enum.TextXAlignment.Left
		valuebox.FontFace = uipallet.Font
		valuebox.ClearTextOnFocus = false
		valuebox.Visible = false
		valuebox.Parent = slider
		local bkg = Instance.new('Frame')
		bkg.Name = 'Slider'
		bkg.Size = UDim2.fromOffset(200, 4)
		bkg.Position = UDim2.fromOffset(startpos, 13)
		bkg.BackgroundColor3 = uipallet.Main
		bkg.Parent = slider
		addCorner(bkg, UDim.new(1, 0))
		local fill = bkg:Clone()
		fill.Name = 'Fill'
		fill.Position = UDim2.fromScale(math.clamp(optionapi.ValueMin / optionsettings.Max, 0, 1), 0)
		fill.Size = UDim2.fromScale(math.clamp(math.clamp(optionapi.ValueMax / optionsettings.Max, 0, 1), 0, 1) - fill.Position.X.Scale, 1)
		fill.BackgroundColor3 = color.Dark(uipallet.MainColor, 0.5)
		fill.Parent = bkg
		local knob = Instance.new('Frame')
		knob.Name = 'Knob'
		knob.Size = UDim2.fromOffset(10, 10)
		knob.Position = UDim2.fromOffset(-5, -3)
		knob.BackgroundColor3 = uipallet.MainColor
		knob.Parent = fill
		addCorner(knob, UDim.new(1, 0))
		local knobmax = knob:Clone()
		knobmax.Name = 'KnobMax'
		knobmax.Position = UDim2.new(1, -5, 0, -3)
		knobmax.Parent = fill
		optionsettings.Function = optionsettings.Function or function() end
		optionsettings.Decimal = optionsettings.Decimal or 1
		local random = Random.new()
		
		function optionapi:Save(tab)
			tab[optionsettings.Name] = {
				ValueMin = self.ValueMin,
				ValueMax = self.ValueMax
			}
		end
		
		function optionapi:Load(tab)
			if self.ValueMin ~= tab.ValueMin then
				self:SetValue(false, tab.ValueMin)
			end
			if self.ValueMax ~= tab.ValueMax then
				self:SetValue(true, tab.ValueMax)
			end
		end
		
		function optionapi:Color(hue, sat, val, rainbowcheck)
			fill.BackgroundColor3 = color.Dark(uipallet.MainColor, 0.5)
			knob.BackgroundColor3 = uipallet.MainColor
			knobmax.BackgroundColor3 = uipallet.MainColor
		end
		
		function optionapi:GetRandomValue()
			return random:NextNumber(optionapi.ValueMin, optionapi.ValueMax)
		end
		
		function optionapi:SetValue(max, value)
			if tonumber(value) == math.huge or value ~= value then return end
			self[max and 'ValueMax' or 'ValueMin'] = value
			valuebutton.Text = self.ValueMin..' '..self.ValueMax
			local size = math.clamp(math.clamp(self.ValueMin / optionsettings.Max, 0, 1), 0.04, 0.96)
			tween:Tween(fill, TweenInfo.new(0.1), {
				Position = UDim2.fromScale(size, 0), Size = UDim2.fromScale(math.clamp(math.clamp(math.clamp(self.ValueMax / optionsettings.Max, 0.04, 0.96), 0.04, 0.96) - size, 0, 1), 1)
			})
		end
		
		slider.InputBegan:Connect(function(inputObj)
			if (inputObj.UserInputType == Enum.UserInputType.MouseButton1 or inputObj.UserInputType == Enum.UserInputType.Touch) then
				local maxCheck = (inputObj.Position.X - knobmax.AbsolutePosition.X) > -10
				local newPosition = math.clamp((inputObj.Position.X - bkg.AbsolutePosition.X) / bkg.AbsoluteSize.X, 0, 1)
				optionapi:SetValue(maxCheck, math.floor((optionsettings.Min + (optionsettings.Max - optionsettings.Min) * newPosition) * optionsettings.Decimal) / optionsettings.Decimal, newPosition)
		
				local changed = inputService.InputChanged:Connect(function(input)
					if input.UserInputType == (inputObj.UserInputType == Enum.UserInputType.MouseButton1 and Enum.UserInputType.MouseMovement or Enum.UserInputType.Touch) then
						local newPosition = math.clamp((input.Position.X - bkg.AbsolutePosition.X) / bkg.AbsoluteSize.X, 0, 1)
						optionapi:SetValue(maxCheck, math.floor((optionsettings.Min + (optionsettings.Max - optionsettings.Min) * newPosition) * optionsettings.Decimal) / optionsettings.Decimal, newPosition)
					end
				end)
		
				local ended
				ended = inputObj.Changed:Connect(function()
					if inputObj.UserInputState == Enum.UserInputState.End then
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
		valuebutton.MouseButton1Click:Connect(function()
			valuebutton.Visible = false
			valuebox.Visible = true
			valuebox.Text = optionapi.ValueMin..' '..optionapi.ValueMax
			valuebox:CaptureFocus()
		end)
		valuebox.FocusLost:Connect(function(enter)
			valuebutton.Visible = true
			valuebox.Visible = false
			if enter then
				for i, v in valuebox.Text:split(' ') do
					if tonumber(v) then
						optionapi:SetValue(i == 2, tonumber(v))
					end
				end
			end
		end)
		
		optionapi.Object = slider
		api.Options[optionsettings.Name] = optionapi
		
		return optionapi
	end,
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

function mainapi:UpdateTextGUI() end
function mainapi:UpdateGUI() end

task.spawn(function()
	repeat
		local hue = tick() * (0.2 * mainapi.RainbowSpeed.Value) % 1
		for _, v in mainapi.RainbowTable do
			v:SetValue(hue)
		end

		if mainapi.Categories.Themes and mainapi.Categories.Themes.Theme == 'Rainbow' then
			uipallet.MainColor = Color3.fromHSV(hue, 0.59, 1)
			uipallet.SecondaryColor = Color3.fromHSV((hue + 0.1) % 1, 0.59, 1)
		end

		mainapi:UpdateGUI(mainapi.GUIColor.Hue, mainapi.GUIColor.Sat, mainapi.GUIColor.Value, true)
		task.wait(1 / mainapi.RainbowUpdateSpeed.Value)
	until mainapi.Loaded == nil
end)

addMaid(mainapi)

function mainapi:CreateGUI()
	return self.Categories.Minigames:CreateModule({
		Name = 'Settings',
		Tooltip = 'Miscellaneous options for the utility.'
	})
end

function mainapi:CreateCategory(categorysettings)
	local categoryapi = {Type = 'Category'}

	local buttonsize = getfontsize(categorysettings.Name, 18, uipallet.Font)
	local button = Instance.new('TextButton')
	button.Size = UDim2.fromOffset(buttonsize.X + 42, 30)
	button.BackgroundTransparency = 1
	button.Text = ''
	button.ZIndex = 2
	button.Parent = categoryholder
	local title = Instance.new('TextLabel')
	title.Name = 'Main'
	title.Size = UDim2.fromOffset(60, 30)
	title.Position = UDim2.fromOffset(28, 0)
	title.BackgroundTransparency = 1
	title.Text = categorysettings.Name
	title.TextColor3 = color.Dark(uipallet.Text, 0.21)
	title.TextSize = 18
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.FontFace = uipallet.Font
	title.ZIndex = 2
	title.Parent = button
	local icon = Instance.new('TextLabel')
	icon.Size = UDim2.fromOffset(30, 30)
	icon.Position = UDim2.fromOffset(-3, 0)
	icon.BackgroundTransparency = 1
	icon.Text = categorysettings.RiseIcon or 'a'
	icon.TextColor3 = color.Dark(uipallet.Text, 0.21)
	icon.TextSize = 16
	icon.FontFace = uipallet['FontIcon'..(categorysettings.Font or 1)]
	icon.ZIndex = 2
	icon.Parent = button
	local children = Instance.new('ScrollingFrame')
	children.Visible = false
	children.Size = UDim2.new(1, -222, 1, -16)
	children.Position = UDim2.fromOffset(216, 14)
	children.BackgroundTransparency = 1
	children.BorderSizePixel = 0
	children.ScrollBarThickness = 2
	children.ScrollBarImageColor3 = color.Dark(uipallet.Text, 0.56)
	children.TopImage = 'rbxasset://textures/ui/Scroll/scroll-middle.png'
	children.BottomImage = 'rbxasset://textures/ui/Scroll/scroll-middle.png'
	children.Parent = mainframe
	local windowlist = Instance.new('UIListLayout')
	windowlist.SortOrder = Enum.SortOrder.LayoutOrder
	windowlist.FillDirection = Enum.FillDirection.Vertical
	windowlist.HorizontalAlignment = Enum.HorizontalAlignment.Left
	windowlist.VerticalAlignment = Enum.VerticalAlignment.Top
	windowlist.Padding = UDim.new(0, 14)
	windowlist.Parent = children
	if categorysettings.Name == 'Search' then
		createHighlight(UDim2.fromOffset(buttonsize.X + 49, 30), UDim2.fromOffset(20, button.AbsolutePosition.Y - mainframe.AbsolutePosition.Y))
		lastSelected = {button, children}
		title.Position = UDim2.fromOffset(34, 0)
		icon.Position = UDim2.fromOffset(3, 0)
		title.TextColor3 = uipallet.Text
		icon.TextColor3 = uipallet.Text
		mainscale.Scale = 0
	end

	function categoryapi:CreateModule(modulesettings)
		local moduleapi = {
			Enabled = false,
			Options = {},
			Bind = {},
			Index = modulesettings.Index or getTableSize(mainapi.Modules),
			ExtraText = modulesettings.ExtraText,
			Name = modulesettings.Name,
			Category = categorysettings.Name
		}
		mainapi:Remove(modulesettings.Name)

		local modulebutton = Instance.new('TextButton')
		modulebutton.Size = UDim2.fromOffset(566, 76)
		modulebutton.BackgroundColor3 = color.Dark(uipallet.Main, 0.03)
		modulebutton.AutoButtonColor = false
		modulebutton.Text = ''
		modulebutton.Parent = children
		addCorner(modulebutton, UDim.new(0, 12))
		local mtitle = Instance.new('TextLabel')
		mtitle.Name = 'Title'
		mtitle.Size = UDim2.fromOffset(200, 24)
		mtitle.Position = UDim2.fromOffset(13, 11)
		mtitle.BackgroundTransparency = 1
		mtitle.Text = modulesettings.Name
		mtitle.TextColor3 = color.Dark(uipallet.Text, 0.21)
		mtitle.TextSize = 23
		mtitle.TextXAlignment = Enum.TextXAlignment.Left
		mtitle.TextYAlignment = Enum.TextYAlignment.Top
		mtitle.FontFace = uipallet.Font
		mtitle.Parent = modulebutton
		modulesettings.Tooltip = modulesettings.Tooltip or 'None'
		local desc = Instance.new('TextLabel')
		desc.Size = UDim2.fromOffset(200, 24)
		desc.Position = UDim2.fromOffset(13, 45 - (modulesettings.Tooltip:find('\n') and 10 or 0))
		desc.BackgroundTransparency = 1
		desc.Text = modulesettings.Tooltip
		desc.TextColor3 = color.Dark(uipallet.Text, 0.6)
		desc.TextSize = 17
		desc.TextXAlignment = Enum.TextXAlignment.Left
		desc.TextYAlignment = Enum.TextYAlignment.Top
		desc.FontFace = uipallet.Font
		desc.Parent = modulebutton
		local modulechildren = Instance.new('Frame')
		modulechildren.Size = UDim2.fromOffset(570, 10)
		modulechildren.Position = UDim2.fromOffset(0, 68)
		modulechildren.BackgroundTransparency = 1
		modulechildren.BorderSizePixel = 0
		modulechildren.Visible = false
		modulechildren.Parent = modulebutton
		local mwindowlist = Instance.new('UIListLayout')
		mwindowlist.SortOrder = Enum.SortOrder.LayoutOrder
		mwindowlist.FillDirection = Enum.FillDirection.Vertical
		mwindowlist.HorizontalAlignment = Enum.HorizontalAlignment.Left
		mwindowlist.VerticalAlignment = Enum.VerticalAlignment.Top
		mwindowlist.Parent = modulechildren
		modulesettings.Function = modulesettings.Function or function() end
		addMaid(moduleapi)

		function moduleapi:SetBind(tab)
			if tab.Mobile then
				return
			end

			self.Bind = table.clone(tab)
		end

		function moduleapi:Toggle(multiple)
			if mainapi.ThreadFix then
				setthreadidentity(8)
			end
			self.Enabled = not self.Enabled
			tween:Tween(mtitle, TweenInfo.new(0.1), {
				TextColor3 = self.Enabled and mainapi:RiseColor(mtitle.AbsolutePosition) or color.Dark(uipallet.Text, 0.21)
			})
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
			moduleapi['Create'..i] = function(self, optionsettings)
				return v(optionsettings, modulechildren, moduleapi)
			end
		end

		mwindowlist:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
			if mainapi.ThreadFix then
				setthreadidentity(8)
			end
			modulechildren.Size = UDim2.fromOffset(570, mwindowlist.AbsoluteContentSize.Y + 10)
			if modulechildren.Visible then
				local height = (mwindowlist.AbsoluteContentSize.Y / scale.Scale) + 76
				tween:Tween(modulebutton, TweenInfo.new(math.min(height * 3, 450) / 1000, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
					Size = UDim2.fromOffset(566, height)
				})
			end
		end)
		modulebutton.MouseEnter:Connect(function()
			tween:Tween(modulebutton, uipallet.Tween, {
				BackgroundColor3 = color.Dark(uipallet.Main, 0.05)
			})
		end)
		modulebutton.MouseLeave:Connect(function()
			tween:Tween(modulebutton, uipallet.Tween, {
				BackgroundColor3 = color.Dark(uipallet.Main, 0.03)
			})
		end)
		modulebutton.MouseButton1Click:Connect(function()
			if inputService:IsKeyDown(Enum.KeyCode.LeftShift) then
				mainapi.Binding = moduleapi
				return
			end
			moduleapi:Toggle()
		end)
		modulebutton.MouseButton2Click:Connect(function()
			modulechildren.Visible = not modulechildren.Visible
			local height = modulechildren.Visible and (modulechildren.Size.Y.Offset / scale.Scale) + 66 or 76
			tween:Tween(modulebutton, TweenInfo.new(math.min(height * 3, 450) / 1000, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
				Size = UDim2.fromOffset(566, height)
			})
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
			end
		end

		return moduleapi
	end

	button.MouseButton1Click:Connect(function()
		if not guiTween or guiTween.PlaybackState ~= Enum.PlaybackState.Playing then
			local info = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
			if lastSelected then
				local obj = lastSelected[1]
				tween:Tween(obj.Main, info, {
					Position = UDim2.fromOffset(28, 0)
				})
				tween:Tween(obj.TextLabel, info, {
					Position = UDim2.fromOffset(-3, 0)
				})
				obj.Main.TextColor3 = color.Dark(uipallet.Text, 0.21)
				obj.TextLabel.TextColor3 = color.Dark(uipallet.Text, 0.21)
				lastSelected[2].Visible = false
			end
			lastSelected = {button, children}
			tween:Tween(title, info, {
				Position = UDim2.fromOffset(34, 0)
			})
			tween:Tween(icon, info, {
				Position = UDim2.fromOffset(3, 0)
			})
			createHighlight(UDim2.fromOffset(buttonsize.X + 49, 30), UDim2.fromOffset(20, (button.AbsolutePosition.Y - mainframe.AbsolutePosition.Y) / scale.Scale))
			title.TextColor3 = uipallet.Text
			icon.TextColor3 = uipallet.Text
			children.Visible = categorysettings.Name ~= 'Search'
		end
	end)
	windowlist:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
		if self.ThreadFix then
			setthreadidentity(8)
		end
		children.CanvasSize = UDim2.fromOffset(0, (windowlist.AbsoluteContentSize.Y / scale.Scale) + 10)
	end)

	self.Categories[categorysettings.RealName or categorysettings.Name] = categoryapi
	categoryapi.Object = button
	categoryapi.Sort = windowlist

	return categoryapi
end

function mainapi:CreateCategoryList(categorysettings)
	local module, list = self.Categories.Minigames:CreateModule({
		Name = categorysettings.Name,
		Tooltip = categorysettings.Tooltip or 'Miscellaneous options for the category.'
	})
	categorysettings.Function = categorysettings.Function or function() end
	module.List = {}
	module.ListEnabled = {}
	list = module:CreateTextList({
		Name = categorysettings.Name,
		Function = function()
			module.List = list.List
			module.ListEnabled = list.ListEnabled
			categorysettings.Function()
		end,
		Placeholder = categorysettings.Placeholder,
		Profiles = categorysettings.Profiles
	})

	for i, v in list do
		if type(v) == 'function' then
			module[i] = function(self, ...)
				v(list, ...)
			end
		end
	end

	self.Categories[categorysettings.Name] = module
	return module
end

function mainapi:CreateCategoryTheme(categorysettings)
	local colorsort
	local categoryapi = self:CreateCategory(categorysettings)
	categoryapi.Type = 'CategoryTheme'
	categoryapi.Theme = 'Blend'
	local scrollframe = categoryapi.Sort.Parent
	local sortlabel = Instance.new('TextLabel')
	sortlabel.Size = UDim2.fromOffset(404, 15)
	sortlabel.Position = UDim2.new(1, -404, 0, 23)
	sortlabel.BackgroundTransparency = 1
	sortlabel.Text = 'You can click on a color to filter it. Click again to reset.'
	sortlabel.TextSize = 18
	sortlabel.TextColor3 = color.Dark(uipallet.Text, 0.56)
	sortlabel.TextXAlignment = Enum.TextXAlignment.Left
	sortlabel.FontFace = uipallet.Font
	sortlabel.Parent = scrollframe
	local sortholder = Instance.new('Frame')
	sortholder.Size = UDim2.fromOffset(570, 80)
	sortholder.Position = UDim2.fromOffset(0, 75)
	sortholder.BackgroundTransparency = 1
	sortholder.Parent = scrollframe
	local holder = Instance.new('Frame')
	holder.Size = UDim2.new(1, 0, 1, -194)
	holder.Position = UDim2.fromOffset(0, 194)
	holder.BackgroundTransparency = 1
	holder.Parent = scrollframe
	local windowlist = Instance.new('UIGridLayout')
	windowlist.SortOrder = Enum.SortOrder.LayoutOrder
	windowlist.FillDirection = Enum.FillDirection.Horizontal
	windowlist.FillDirectionMaxCells = 3
	windowlist.CellPadding = UDim2.fromOffset(14, 14)
	windowlist.CellSize = UDim2.fromOffset(180, 100)
	windowlist.Parent = holder
	local sortlist = windowlist:Clone()
	sortlist.FillDirectionMaxCells = 5
	sortlist.CellPadding = UDim2.fromOffset(16, 16)
	sortlist.CellSize = UDim2.fromOffset(101, 32)
	sortlist.Parent = sortholder
	windowlist:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
		if self.ThreadFix then
			setthreadidentity(8)
		end
		holder.Parent.CanvasSize = UDim2.fromOffset(0, windowlist.AbsoluteContentSize.Y + (204 / scale.Scale))
	end)
	categoryapi.Sort:Destroy()

	function categoryapi:SetTheme(val)
		if uipallet.SelectedTheme then
			uipallet.SelectedTheme.TextColor3 = uipallet.Text
		end
		val = uipallet.Themes[val] and val or 'Blend'
		self.Theme = val
		local obj
		for i, v in uipallet.ThemeObjects do
			if v == uipallet.Themes[val][1] then
				obj = i.Parent.Parent.TextLabel
			end
		end
		local theme = uipallet.Themes[val][1]
		uipallet.SelectedTheme = obj
		uipallet.MainColor = theme[1]
		uipallet.SecondaryColor = theme[2]
		uipallet.ThirdColor = theme[3]
		mainapi:UpdateGUI(mainapi.GUIColor.Hue, mainapi.GUIColor.Sat, mainapi.GUIColor.Value, true)
	end

	local sortedthemes = {}
	for i in uipallet.Themes do
		table.insert(sortedthemes, i)
	end
	table.sort(sortedthemes)

	for i, v in themecolors do
		local button = Instance.new('TextButton')
		button.Name = i
		button.BackgroundColor3 = v
		button.Text = ''
		button.AutoButtonColor = false
		button.Parent = sortholder
		addCorner(button, UDim.new(0, 8))

		button.MouseButton1Click:Connect(function()
			colorsort = (colorsort ~= i and i or nil)

			for ind, bv in themecolors do
				tween:Tween(sortholder[tostring(ind)], TweenInfo.new(0.4), {
					BackgroundColor3 = color.Dark(bv, colorsort ~= ind and colorsort and 0.25 or 0)
				})
			end

			for obj in uipallet.ThemeObjects do
				obj = obj.Parent.Parent
				if colorsort then
					local theme = uipallet.Themes[obj.Name] or {}
					obj.Visible = theme[2] == colorsort or theme[3] == colorsort or theme[4] == colorsort
				else
					obj.Visible = true
				end
			end
		end)
	end

	for _, v in sortedthemes do
		local title = v
		v = uipallet.Themes[v][1]
		local button = Instance.new('TextButton')
		button.Name = title
		button.BackgroundColor3 = color.Dark(uipallet.Main, 0.03)
		button.Text = ''
		button.AutoButtonColor = false
		button.Parent = holder
		addCorner(button, UDim.new(0, 16))
		local themeshowcase = Instance.new('Frame')
		themeshowcase.Size = UDim2.fromOffset(180, 90)
		themeshowcase.BackgroundColor3 = Color3.new(1, 1, 1)
		themeshowcase.Parent = button
		addCorner(themeshowcase, UDim.new(0, 16))
		local gradient = Instance.new('UIGradient')
		gradient.Parent = themeshowcase
		uipallet.ThemeObjects[gradient] = v
		local line = Instance.new('Frame')
		line.Size = UDim2.new(1, 0, 0, 30)
		line.Position = UDim2.new(0, 0, 1, -30)
		line.BackgroundColor3 = button.BackgroundColor3
		line.BorderSizePixel = 0
		line.Parent = themeshowcase
		local namelabel = Instance.new('TextLabel')
		namelabel.Size = UDim2.fromOffset(179, 24)
		namelabel.Position = UDim2.fromOffset(0, 65)
		namelabel.BackgroundTransparency = 1
		namelabel.Text = title
		namelabel.TextColor3 = uipallet.Text
		namelabel.TextSize = 18
		namelabel.FontFace = uipallet.Font
		namelabel.ZIndex = 2
		namelabel.Parent = button
		if title == 'Blend' then
			uipallet.SelectedTheme = namelabel
		end

		button.MouseButton1Click:Connect(function()
			categoryapi:SetTheme(title, namelabel)
		end)
	end

	return categoryapi
end

function mainapi:CreateCategoryProfile(categorysettings)
	local categoryapi = self:CreateCategory(categorysettings)
	categoryapi.Type = 'CategoryProfiles'
	local windowlist = Instance.new('UIGridLayout')
	windowlist.SortOrder = Enum.SortOrder.LayoutOrder
	windowlist.FillDirection = Enum.FillDirection.Horizontal
	windowlist.FillDirectionMaxCells = 3
	windowlist.CellPadding = UDim2.fromOffset(14, 14)
	windowlist.CellSize = UDim2.fromOffset(180, 100)
	windowlist.Parent = categoryapi.Sort.Parent
	windowlist:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
		if self.ThreadFix then
			setthreadidentity(8)
		end
		windowlist.Parent.CanvasSize = UDim2.fromOffset(0, windowlist.AbsoluteContentSize.Y + 10)
	end)
	categoryapi.Sort:Destroy()

	return categoryapi
end

function mainapi:CreateLegit()
	local legitapi = {Modules = {}}

	function legitapi:CreateModule(modulesettings)
		modulesettings.Function = modulesettings.Function or function() end
		local module
		module = mainapi.Categories.Legit:CreateModule({
			Name = modulesettings.Name,
			Function = function(callback)
				if module.Children then
					module.Children.Visible = callback
				end
				task.spawn(modulesettings.Function, callback)
			end,
			Tooltip = modulesettings.Tooltip
		})
		if modulesettings.Size then
			local modulechildren = Instance.new('Frame')
			modulechildren.Size = modulesettings.Size
			modulechildren.BackgroundTransparency = 1
			modulechildren.Visible = false
			modulechildren.Parent = scaledgui
			makeDraggable(modulechildren, clickgui)
			module.Children = modulechildren
		end

		return module
	end

	return legitapi
end

function mainapi:CreateOverlay(categorysettings)
	local customchildren
	local categoryapi
	categoryapi = {
		Type = 'Overlay',
		Expanded = false,
		Button = self.Categories.Render:CreateModule({
			Name = categorysettings.Name,
			Function = function(callback)
				customchildren.Visible = callback
				if not callback then
					for _, v in categoryapi.Connections do
						v:Disconnect()
					end
					table.clear(categoryapi.Connections)
				end

				if categorysettings.Function then
					task.spawn(categorysettings.Function, callback)
				end
			end,
			Tooltip = categorysettings.Tooltip or 'None',
			ExtraText = categorysettings.ExtraText
		}),
		Options = {}
	}

	customchildren = Instance.new(categorysettings.NoDrag and 'Frame' or 'TextButton')
	customchildren.Name = 'CustomChildren'
	customchildren.Size = categorysettings.NoDrag and UDim2.fromScale(1, 1) or UDim2.fromOffset(220, 200)
	customchildren.Position = UDim2.new()
	customchildren.BackgroundTransparency = 1
	customchildren.Parent = scaledgui
	if not categorysettings.NoDrag then
		makeDraggable(customchildren, clickgui)
		customchildren.Text = ''
	end
	categoryapi.Button.Children = customchildren
	categoryapi.Button.Button = categoryapi.Button
	addMaid(categoryapi)

	function categoryapi:Update()
		customchildren.Visible = self.Button.Enabled
		if self.Expanded then
			self:Expand()
		end
	end

	self:Clean(clickgui:GetPropertyChangedSignal('Visible'):Connect(function()
		categoryapi:Update()
	end))

	categoryapi:Update()
	categoryapi.Object = window
	categoryapi.Children = customchildren
	self.Categories[categorysettings.Name] = categoryapi

	return categoryapi.Button
end

local notifs = {}
function mainapi:CreateNotification(title, text, duration, type, continued)
	if #notifs > 0 and not continued then
		table.insert(notifs, {
			title,
			text,
			duration
		})
		return
	end
	if not continued then
		table.insert(notifs, {
			title,
			text,
			duration
		})
	end
	if title == 'Finished Loading' then
		title = 'Rise'
		text = 'Reconnecting to nothing...'
		duration = 5
	end
	local notification = Instance.new('Frame')
	notification.Name = 'Notification'
	notification.Size = UDim2.fromOffset(280, 60)
	notification.Position = UDim2.fromOffset(150, guiService:GetGuiInset().Y + 84)
	notification.AnchorPoint = Vector2.new(0.5, 0.5)
	notification.BackgroundTransparency = 1
	notification.BackgroundColor3 = color.Dark(uipallet.Main, 0.4)
	notification.Parent = notifications
	addCorner(notification)
	local scale = Instance.new('UIScale')
	scale.Scale = 1.1
	scale.Parent = notification
	local icon = Instance.new('Frame')
	icon.Size = UDim2.fromOffset(40, 40)
	icon.Position = UDim2.fromOffset(10, 10)
	icon.BackgroundColor3 = uipallet.Text
	icon.Parent = notification
	addCorner(icon, UDim.new(0, 11))
	local titlelabel = Instance.new('TextLabel')
	titlelabel.Name = 'Title'
	titlelabel.Size = UDim2.fromOffset(60, 30)
	titlelabel.Position = UDim2.fromOffset(61, 6)
	titlelabel.BackgroundTransparency = 1
	titlelabel.Text = title
	titlelabel.TextXAlignment = Enum.TextXAlignment.Left
	titlelabel.TextYAlignment = Enum.TextYAlignment.Center
	titlelabel.TextColor3 = uipallet.MainColor
	titlelabel.TextSize = 18
	titlelabel.RichText = true
	titlelabel.FontFace = uipallet.FontSemiBold
	titlelabel.Parent = notification
	local textlabel = Instance.new('TextLabel')
	textlabel.Size = UDim2.fromOffset(60, 30)
	textlabel.Position = UDim2.fromOffset(61, 25)
	textlabel.BackgroundTransparency = 1
	textlabel.Text = text
	textlabel.TextColor3 = uipallet.Text
	textlabel.TextSize = 17
	textlabel.TextXAlignment = Enum.TextXAlignment.Left
	textlabel.TextYAlignment = Enum.TextYAlignment.Center
	textlabel.FontFace = uipallet.FontLight
	textlabel.Parent = notification
	local info = TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
	if tween.Tween then
		tween:Tween(scale, info, {
			Scale = 1
		}, nil, true)
		tween:Tween(notification, info, {
			BackgroundTransparency = 0.5
		})
		for _, v in {titlelabel, textlabel, icon} do
			tween:Tween(v, info, {
				[v:IsA('TextLabel') and 'TextTransparency' or 'BackgroundTransparency'] = 0
			})
		end
	end
	task.delay(duration, function()
		if tween.Tween then
			tween:Tween(scale, info, {
				Scale = 1.1
			}, nil, true)
			for _, v in {notification, titlelabel, textlabel, icon} do
				tween:Tween(v, info, {
					[v:IsA('TextLabel') and 'TextTransparency' or 'BackgroundTransparency'] = 1
				})
			end
		end
		task.delay(0.5, function()
			notification:Destroy()
		end)
		task.delay(0.3, function()
			table.remove(notifs, 1)
			if notifs[1] and mainapi.Loaded ~= nil then
				mainapi:CreateNotification(notifs[1][1], notifs[1][2], notifs[1][3], '', true)
			end
		end)
	end)
end

function mainapi:Load(skipgui, profile)
	local guidata = {}
	local savecheck = true

	if isfile('newvape/profiles/'..game.GameId..'.gui.txt') then
		guidata = loadJson('newvape/profiles/'..game.GameId..'.gui.txt')
		if not guidata then
			guidata = {Categories = {}}
			self:CreateNotification('Vape', 'Failed to load GUI settings.', 10, 'alert')
			savecheck = false
		end

		if not skipgui then
			self.Keybind = guidata.Keybind
			for i, v in guidata.Categories do
				local object = self.Categories[i]
				if not object or object.Type ~= 'Overlay' and object.Type ~= 'CategoryTheme' then continue end
				if v.Theme then
					object:SetTheme(v.Theme)
				end
				if v.Position then
					object.Children.Position = UDim2.fromOffset(v.Position.X, v.Position.Y)
				end
			end
		end
	end

	self.Profile = profile or guidata.Profile or 'default'
	self.Profiles = guidata.Profiles or {{
		Name = 'default',
		Bind = {}
	}}
	--self.Categories.Profiles:ChangeValue()

	if isfile('newvape/profiles/'..self.Profile..self.Place..'.txt') then
		local savedata = loadJson('newvape/profiles/'..self.Profile..self.Place..'.txt')
		if not savedata then
			savedata = {
				Categories = {},
				Modules = {},
				Legit = {}
			}
			self:CreateNotification('Vape', 'Failed to load '..self.Profile..' profile.', 10, 'alert')
			savecheck = false
		end

		for i, v in savedata.Modules do
			local object = self.Modules[i]
			if not object then continue end
			if object.Options and v.Options then
				self:LoadOptions(object, v.Options)
			end
			if v.Enabled ~= object.Enabled then
				if skipgui then
					if self.ToggleNotifications.Enabled then
						self:CreateNotification('Toggled', 'Toggled '..i..' '..(v.Enabled and 'on' or 'off'), 1)
					end
				end
				object:Toggle(true)
			end
			object:SetBind(v.Bind)
		end

		for i, v in savedata.Legit do
			local object = self.Legit.Modules[i]
			if not object then continue end
			if object.Options and v.Options then
				self:LoadOptions(object, v.Options)
			end
			if object.Enabled ~= v.Enabled then
				object:Toggle()
			end
			if v.Position and object.Children then
				object.Children.Position = UDim2.fromOffset(v.Position.X, v.Position.Y)
			end
		end

		self:UpdateTextGUI(true)
	else
		self:Save()
	end

	if self.Downloader then
		self.Downloader:Destroy()
		self.Downloader = nil
	end
	self.Loaded = savecheck
end

function mainapi:LoadOptions(object, savedoptions)
	for i, v in savedoptions do
		local option = object.Options[i]
		if not option then continue end
		option:Load(v)
	end
end

function mainapi:Remove(obj)
	local tab = (self.Modules[obj] and self.Modules or self.Legit.Modules[obj] and self.Legit.Modules)
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
	if not self.Loaded then return end
	local guidata = {
		Categories = {},
		Profile = newprofile or self.Profile,
		Profiles = self.Profiles,
		Keybind = self.Keybind
	}
	local savedata = {
		Modules = {},
		Categories = {},
		Legit = {}
	}

	for i, v in self.Categories do
		if v.Type ~= 'Overlay' and v.Type ~= 'CategoryTheme' then continue end
		guidata.Categories[i] = {
			Position = v.Children and {X = v.Children.Position.X.Offset, Y = v.Children.Position.Y.Offset} or nil,
			Theme = v.Theme
		}
	end

	for i, v in self.Modules do
		savedata.Modules[i] = {
			Enabled = v.Enabled,
			Bind = typeof(v.Bind) == 'Instance' and {Mobile = true, X = v.Bind.Position.X.Offset, Y = v.Bind.Position.Y.Offset} or v.Bind,
			Options = mainapi:SaveOptions(v, true)
		}
	end

	for i, v in self.Legit.Modules do
		savedata.Legit[i] = {
			Enabled = v.Enabled,
			Position = v.Children and {X = v.Children.Position.X.Offset, Y = v.Children.Position.Y.Offset} or nil,
			Options = mainapi:SaveOptions(v, v.Options)
		}
	end

	writefile('newvape/profiles/'..game.GameId..'.gui.txt', httpService:JSONEncode(guidata))
	writefile('newvape/profiles/'..self.Profile..self.Place..'.txt', httpService:JSONEncode(savedata))
end

function mainapi:SaveOptions(object, savedoptions)
	if not savedoptions then return end
	savedoptions = {}
	for _, v in object.Options do
		if not v.Save then continue end
		v:Save(savedoptions)
	end
	return savedoptions
end

function mainapi:Uninject()
	mainapi:Save()
	mainapi.Loaded = nil
	for _, v in self.Modules do
		if v.Enabled then
			v:Toggle()
		end
		v.Button = nil
		v.Options = {}
	end
	for _, v in self.Legit.Modules do
		if v.Enabled then
			v:Toggle()
		end
	end
	for _, v in self.Categories do
		if v.Type == 'Overlay' and v.Button.Enabled then
			v.Button:Toggle()
		end
	end
	for _, v in mainapi.Connections do
		pcall(function()
			v:Disconnect()
		end)
	end
	if mainapi.ThreadFix then
		setthreadidentity(8)
		clickgui.Visible = false
	end
	mainapi.gui:ClearAllChildren()
	mainapi.gui:Destroy()
	table.clear(mainapi.Libraries)
	loopClean(mainapi)
	shared.vape = nil
	shared.vapereload = nil
	shared.VapeIndependent = nil
end

gui = Instance.new('ScreenGui')
gui.Name = randomString()
gui.DisplayOrder = 9999999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
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
clickgui = Instance.new('Frame')
clickgui.Name = 'ClickGui'
clickgui.Size = UDim2.fromScale(1, 1)
clickgui.BackgroundTransparency = 1
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
scale.Scale = 1
scale.Parent = scaledgui
mainapi.guiscale = scale
scaledgui.Size = UDim2.fromScale(1 / scale.Scale, 1 / scale.Scale)
mainframe = Instance.new('CanvasGroup')
mainframe.Size = UDim2.fromOffset(800, 600)
mainframe.Position = UDim2.fromScale(0.5, 0.5)
mainframe.AnchorPoint = Vector2.new(0.5, 0.5)
mainframe.BackgroundColor3 = uipallet.Main
mainframe.GroupTransparency = 1
mainframe.Parent = clickgui
--addBlur(mainframe)
local selected = Instance.new('TextButton')
selected.Text = ''
selected.BackgroundTransparency = 1
selected.Modal = true
selected.Parent = mainframe
mainscale = Instance.new('UIScale')
mainscale.Parent = mainframe
addCorner(mainframe)
sidebar = Instance.new('Frame')
sidebar.Size = UDim2.new(0, 200, 1, 0)
sidebar.BackgroundColor3 = color.Dark(uipallet.Main, 0.03)
sidebar.Parent = mainframe
addCorner(sidebar)
local scorner = Instance.new('Frame')
scorner.BorderSizePixel = 0
scorner.BackgroundColor3 = color.Dark(uipallet.Main, 0.03)
scorner.Position = UDim2.new(1, -20, 0, 0)
scorner.Size = UDim2.new(0, 20, 1, 0)
scorner.Parent = sidebar
local swatermark = Instance.new('TextLabel')
swatermark.Size = UDim2.fromOffset(70, 40)
swatermark.Position = UDim2.fromOffset(28, 22)
swatermark.BackgroundTransparency = 1
swatermark.Text = 'Rise'
swatermark.TextColor3 = uipallet.Text
swatermark.TextSize = 38
swatermark.TextXAlignment = Enum.TextXAlignment.Left
swatermark.TextYAlignment = Enum.TextYAlignment.Top
swatermark.FontFace = uipallet.Font
swatermark.Parent = sidebar
local swatermarkversion = Instance.new('TextLabel')
swatermarkversion.Size = UDim2.fromOffset(70, 40)
swatermarkversion.Position = UDim2.fromOffset(85, 20)
swatermarkversion.BackgroundTransparency = 1
swatermarkversion.Text = mainapi.Version
swatermarkversion.TextColor3 = uipallet.MainColor
swatermarkversion.TextSize = 18
swatermarkversion.TextXAlignment = Enum.TextXAlignment.Left
swatermarkversion.TextYAlignment = Enum.TextYAlignment.Top
swatermarkversion.FontFace = uipallet.Font
swatermarkversion.Parent = sidebar
categoryholder = Instance.new('Frame')
categoryholder.Size = UDim2.new(1, -22, 1, -80)
categoryholder.Position = UDim2.fromOffset(22, 80)
categoryholder.ZIndex = 2
categoryholder.BackgroundTransparency = 1
categoryholder.Parent = sidebar
local sort = Instance.new('UIListLayout')
sort.FillDirection = Enum.FillDirection.Vertical
sort.HorizontalAlignment = Enum.HorizontalAlignment.Left
sort.VerticalAlignment = Enum.VerticalAlignment.Top
sort.Padding = UDim.new(0, 9)
sort.Parent = categoryholder

mainapi:Clean(gui:GetPropertyChangedSignal('AbsoluteSize'):Connect(function()
	if mainapi.Scale.Enabled then
		scale.Scale = math.max(gui.AbsoluteSize.X / 1920, 0.6)
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
	Name = 'Search',
	RiseIcon = 'U',
	Font = 3
})
mainapi:CreateCategory({
	Name = 'Combat',
	RiseIcon = 'a'
})
mainapi:CreateCategory({
	Name = 'Movement',
	RealName = 'Blatant',
	RiseIcon = 'b'
})
mainapi:CreateCategory({
	Name = 'Player',
	RealName = 'Utility',
	RiseIcon = 'c'
})
mainapi:CreateCategory({
	Name = 'Render',
	RiseIcon = 'g'
})
mainapi:CreateCategory({
	Name = 'Exploit',
	RealName = 'World',
	RiseIcon = 'a'
})
mainapi:CreateCategory({
	Name = 'Ghost',
	RealName = 'Legit',
	RiseIcon = 'f'
})
mainapi.Categories.Minigames = mainapi.Categories.Utility
mainapi.Categories.Inventory = mainapi.Categories.Utility

--[[
	Profiles
]]
mainapi:CreateCategoryProfile({
	Name = 'CaS',
	RealName = 'Profiles',
	RiseIcon = 'm',
	Font = 3,
	Size = UDim2.fromOffset(17, 10),
	Position = UDim2.fromOffset(12, 16),
	Placeholder = 'Type name'
})

mainapi:CreateCategoryTheme({
	Name = 'Themes',
	RiseIcon = 'U',
	Font = 3
})

--[[
	Friends
]]
local friends
local friendscolor = {
	Hue = 1,
	Sat = 1,
	Value = 1
}
local friendssettings = {
	Name = 'Friends',
	Size = UDim2.fromOffset(17, 16),
	Placeholder = 'Roblox username',
	Color = Color3.fromRGB(5, 134, 105),
	Function = function()
		friends.Update:Fire()
		friends.ColorUpdate:Fire(friendscolor.Hue, friendscolor.Sat, friendscolor.Value)
	end
}
friends = mainapi:CreateCategoryList(friendssettings)
friends.Update = Instance.new('BindableEvent')
friends.ColorUpdate = Instance.new('BindableEvent')
friends:CreateToggle({
	Name = 'Recolor visuals',
	Darker = true,
	Default = true,
	Function = function()
		friends.Update:Fire()
		friends.ColorUpdate:Fire(friendscolor.Hue, friendscolor.Sat, friendscolor.Value)
	end
})
friendscolor = friends:CreateColorSlider({
	Name = 'Friends color',
	Darker = true,
	Function = function(hue, sat, val)
		friendssettings.Color = Color3.fromHSV(hue, sat, val)
		friends.ColorUpdate:Fire(hue, sat, val)
	end
})
friends:CreateToggle({
	Name = 'Use friends',
	Darker = true,
	Default = true,
	Function = function()
		friends.Update:Fire()
		friends.ColorUpdate:Fire(friendscolor.Hue, friendscolor.Sat, friendscolor.Value)
	end
})
mainapi:Clean(friends.Update)
mainapi:Clean(friends.ColorUpdate)

mainapi.Legit = mainapi:CreateLegit()
mainapi.Categories.Main = mainapi:CreateGUI()

--[[
	Targets
]]
local targets
targets = mainapi:CreateCategoryList({
	Name = 'Targets',
	Size = UDim2.fromOffset(17, 16),
	Placeholder = 'Roblox username',
	Function = function()
		targets.Update:Fire()
	end
})
targets.Update = Instance.new('BindableEvent')
mainapi:Clean(targets.Update)

mainapi.Categories.Main:CreateToggle({
	Name = 'Teams by server',
	Tooltip = 'Ignore players on your team designated by the server',
	Default = true,
	Function = function()
		if mainapi.Libraries.entity and mainapi.Libraries.entity.Running then
			mainapi.Libraries.entity.refresh()
		end
	end
})
mainapi.Categories.Main:CreateToggle({
	Name = 'Use team color',
	Tooltip = 'Uses the TeamColor property on players for render modules',
	Default = true,
	Function = function()
		if mainapi.Libraries.entity and mainapi.Libraries.entity.Running then
			mainapi.Libraries.entity.refresh()
		end
	end
})


--[[
	GUI Settings
]]

mainapi.Categories.Main.Options['GUI bind indicator'] = mainapi.Categories.Main:CreateToggle({
	Name = 'GUI bind indicator',
	Default = true,
	Tooltip = "Displays a message indicating your GUI upon injecting.\nI.E. 'Press RSHIFT to open GUI'"
})
mainapi.Notifications = mainapi.Categories.Main:CreateToggle({
	Name = 'Notifications',
	Tooltip = 'Shows notifications',
	Default = true
})
local scaleslider = {
	Object = {},
	Value = 1
}
mainapi.Scale = mainapi.Categories.Main:CreateToggle({
	Name = 'Auto rescale',
	Default = true,
	Function = function(callback)
		scaleslider.Object.Visible = not callback
		if callback then
			scale.Scale = math.max(gui.AbsoluteSize.X / 1920, 0.6)
		else
			scale.Scale = scaleslider.Value
		end
	end
})
scaleslider = mainapi.Categories.Main:CreateSlider({
	Name = 'Scale',
	Min = 0.1,
	Max = 2,
	Decimal = 10,
	Function = function(val, final)
		if final and not mainapi.Scale.Enabled then
			scale.Scale = val
		end
	end,
	Default = 1,
	Darker = true,
	Visible = false
})
mainapi.Categories.Main:CreateDropdown({
	Name = 'GUI Theme',
	List = {'rise', 'new', 'old'},
	Function = function(val, mouse)
		if mouse then
			writefile('newvape/profiles/gui.txt', val)
			shared.vapereload = true
			if shared.VapeDeveloper then
				loadstring(readfile('newvape/loader.lua'), 'loader')()
			else
				loadstring(game:HttpGet('https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/'..readfile('newvape/profiles/commit.txt')..'/loader.lua', true))()
			end
		end
	end
})
mainapi.RainbowSpeed = mainapi.Categories.Main:CreateSlider({
	Name = 'Color speed',
	Min = 0.1,
	Max = 10,
	Decimal = 10,
	Default = 1,
	Tooltip = 'Adjusts the speed of color values'
})
mainapi.RainbowUpdateSpeed = mainapi.Categories.Main:CreateSlider({
	Name = 'Color update rate',
	Min = 1,
	Max = 144,
	Default = 60,
	Tooltip = 'Adjusts the update rate of color values',
	Suffix = 'hz'
})
mainapi.Categories.Main:CreateButton({
	Name = 'Reinject',
	Function = function()
		shared.vapereload = true
		if shared.VapeDeveloper then
			loadstring(readfile('newvape/loader.lua'), 'loader')()
		else
			loadstring(game:HttpGet('https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/'..readfile('newvape/profiles/commit.txt')..'/loader.lua', true))()
		end
	end
})
mainapi.Categories.Main:CreateButton({
	Name = 'Uninject',
	Function = function()
		mainapi:Uninject()
	end
})

--[[
	Interface
]]

local interface = mainapi:CreateOverlay({
	Name = 'RiseInterface',
	Function = function()
		mainapi:UpdateTextGUI()
	end,
	ExtraText = function()
		return 'Modern'
	end,
	Tooltip = 'The clients interface with all information',
	NoDrag = true
})
local interfaceshow = interface:CreateDropdown({
	Name = 'Modules to Show',
	List = {
		'All',
		'Exclude render',
		'Only bound'
	},
	Function = function()
		mainapi:UpdateTextGUI()
	end
})
local interfacearraycolor = interface:CreateDropdown({
	Name = 'ArrayList Color Mode',
	List = {
		'Fade',
		'Breathe',
		'Static'
	},
	Function = function()
		mainapi:UpdateTextGUI()
	end
})
local interfacebkg = interface:CreateDropdown({
	Name = 'BackGround',
	List = {
		'Normal',
		'Off'
	},
	Function = function()
		mainapi:UpdateTextGUI()
	end
})
local interfacebar = interface:CreateToggle({
	Name = 'Sidebar',
	Function = function()
		mainapi:UpdateTextGUI()
	end,
	Default = true
})
local interfacesuffix = interface:CreateToggle({
	Name = 'Suffix',
	Function = function()
		mainapi:UpdateTextGUI()
	end,
	Default = true
})
local interfacelowercase = interface:CreateToggle({
	Name = 'Lowercase',
	Function = function()
		mainapi:UpdateTextGUI()
	end
})
mainapi.ToggleNotifications = interface:CreateToggle({
	Name = 'Toggle Notifications',
	Default = true
})
interface.Button:Toggle()

--[[
	Interface Objects
]]

local InterfaceLabels = {}
local watermark = Instance.new('TextLabel')
watermark.Size = UDim2.fromOffset(70, 40)
watermark.Position = UDim2.fromOffset(12, guiService:GetGuiInset().Y + 5)
watermark.BackgroundTransparency = 1
watermark.Text = 'Rise'
watermark.TextColor3 = Color3.new(1, 1, 1)
watermark.TextSize = 43
watermark.TextXAlignment = Enum.TextXAlignment.Left
watermark.TextYAlignment = Enum.TextYAlignment.Top
watermark.FontFace = uipallet.FontSemiBold
watermark.Parent = interface.Children
local watermarkgradient = Instance.new('UIGradient')
watermarkgradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, uipallet.SecondaryColor:Lerp(uipallet.MainColor, 0.34)),
	ColorSequenceKeypoint.new(1, uipallet.SecondaryColor:Lerp(uipallet.MainColor, 0.64))
})
watermarkgradient.Parent = watermark
local arrayholder = Instance.new('Frame')
arrayholder.Size = UDim2.fromOffset(100, 100)
arrayholder.Position = UDim2.new(1, -15, 0, 15)
arrayholder.AnchorPoint = Vector2.new(1, 0)
arrayholder.BackgroundTransparency = 1
arrayholder.Parent = interface.Children
local arraylayout = Instance.new('UIListLayout')
arraylayout.SortOrder = Enum.SortOrder.LayoutOrder
arraylayout.FillDirection = Enum.FillDirection.Vertical
arraylayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
arraylayout.VerticalAlignment = Enum.VerticalAlignment.Top
arraylayout.Parent = arrayholder


--[[
	Target Info
]]

local targetinfo
local targetinfoobj
local targetinfobcolor
targetinfoobj = mainapi:CreateOverlay({
	Name = 'Target Info',
	Function = function(callback)
		if callback then
			task.spawn(function()
				repeat
					targetinfo:UpdateInfo()
					task.wait()
				until not targetinfoobj.Button or not targetinfoobj.Button.Enabled
			end)
		end
	end,
	NoDrag = true
})

local targetinfobkg = Instance.new('Frame')
targetinfobkg.Size = UDim2.fromOffset(295, 95)
targetinfobkg.Position = UDim2.new(0.5, 0, 0.5, 95)
targetinfobkg.AnchorPoint = Vector2.new(0.5, 0.5)
targetinfobkg.BackgroundTransparency = 0.5
targetinfobkg.Parent = targetinfoobj.Children
local targetinfoscale = Instance.new('UIScale')
targetinfoscale.Scale = 0
targetinfoscale.Parent = targetinfobkg
local targetinfogradient = Instance.new('UIGradient')
targetinfogradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, color.Dark(uipallet.MainColor, 0.5)),
	ColorSequenceKeypoint.new(1, color.Dark(uipallet.SecondaryColor, 0.5))
})
targetinfogradient.Rotation = 90
targetinfogradient.Parent = targetinfobkg
addCorner(targetinfobkg, UDim.new(0, 36))
local targetinfoshot = Instance.new('ImageLabel')
targetinfoshot.Size = UDim2.fromOffset(64, 64)
targetinfoshot.Position = UDim2.new(0, 48, 0.5, 1)
targetinfoshot.AnchorPoint = Vector2.new(0.5, 0.5)
targetinfoshot.BackgroundTransparency = 1
targetinfoshot.Image = 'rbxthumb://type=AvatarHeadShot&id=1&w=420&h=420'
targetinfoshot.Parent = targetinfobkg
addCorner(targetinfoshot, UDim.new(0, 14))
local targetinfoname = Instance.new('TextLabel')
targetinfoname.Size = UDim2.fromOffset(60, 30)
targetinfoname.Position = UDim2.fromOffset(158, 21)
targetinfoname.BackgroundTransparency = 1
targetinfoname.Text = 'Rise'
targetinfoname.TextSize = 26
targetinfoname.TextXAlignment = Enum.TextXAlignment.Left
targetinfoname.TextColor3 = uipallet.MainColor
targetinfoname.FontFace = uipallet.Font
targetinfoname.Parent = targetinfobkg
local targetinfoextra = targetinfoname:Clone()
targetinfoextra.Position = UDim2.fromOffset(94, 20)
targetinfoextra.Text = 'Name:'
targetinfoextra.TextColor3 = Color3.new(1, 1, 1)
targetinfoextra.FontFace = uipallet.FontLight
targetinfoextra.Parent = targetinfobkg
local targetinfohealthtext = targetinfoname:Clone()
targetinfohealthtext.Position = UDim2.fromOffset(232, 48)
targetinfohealthtext.Text = '20.0'
targetinfohealthtext.Parent = targetinfobkg
local targetinfohealthbkg = Instance.new('Frame')
targetinfohealthbkg.Name = 'HealthBKG'
targetinfohealthbkg.Size = UDim2.fromOffset(130, 12)
targetinfohealthbkg.Position = UDim2.fromOffset(94, 58)
targetinfohealthbkg.BackgroundColor3 = color.Dark(uipallet.MainColor, 0.5)
targetinfohealthbkg.BackgroundTransparency = 0.5
targetinfohealthbkg.BorderSizePixel = 0
targetinfohealthbkg.Parent = targetinfobkg
addCorner(targetinfohealthbkg, UDim.new(0, 10))
local targetinfohealth = targetinfohealthbkg:Clone()
targetinfohealth.Size = UDim2.fromScale(0.8, 1)
targetinfohealth.Position = UDim2.new()
targetinfohealth.BackgroundColor3 = Color3.new(1, 1, 1)
targetinfohealth.BackgroundTransparency = 0
targetinfohealth.Parent = targetinfohealthbkg
targetinfohealth:GetPropertyChangedSignal('Size'):Connect(function()
	targetinfohealth.Visible = targetinfohealth.Size.X.Scale > 0.01
end)
local targetinfohealthgradient = Instance.new('UIGradient')
targetinfohealthgradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, uipallet.MainColor),
	ColorSequenceKeypoint.new(1, uipallet.SecondaryColor)
})
targetinfohealthgradient.Rotation = 90
targetinfohealthgradient.Parent = targetinfohealth

local targetinfodisplay = targetinfoobj:CreateToggle({
	Name = 'Use Displayname',
	Default = true
})

local lasthealth = 0
local lastmaxhealth = 0
local lastvisible
targetinfo = {
	Targets = {},
	Object = targetinfobkg,
	UpdateInfo = function(self)
		local entitylib = mainapi.Libraries
		if not entitylib then return end
		for i, v in self.Targets do
			if v < tick() then
				self.Targets[i] = nil
			end
		end

		local v, highest = nil, tick()
		for i, check in self.Targets do
			if check > highest then
				v = i
				highest = check
			end
		end

		local visible = v ~= nil or mainapi.gui.ScaledGui.ClickGui.Visible
		if v then
			targetinfoname.Text = v.Player and (targetinfodisplay.Enabled and v.Player.DisplayName or v.Player.Name) or v.Character and v.Character.Name or targetinfoname.Text
			targetinfoshot.Image = 'rbxthumb://type=AvatarHeadShot&id='..(v.Player and v.Player.UserId or 1)..'&w=420&h=420'

			if not v.Character then
				v.Health = v.Health or 0
				v.MaxHealth = v.MaxHealth or 100
			end

			if self.LastTarget ~= v then
				local size = math.max(getfontsize(targetinfoname.Text, 26, uipallet.FontSemiBold).X + 180, 295)
				targetinfobkg.Size = UDim2.fromOffset(size, 95)
				targetinfohealthbkg.Size = UDim2.fromOffset(size - 165, 12)
				targetinfohealthtext.Position = UDim2.fromOffset(size - 63, 48)
			end

			if v.Health ~= lasthealth or v.MaxHealth ~= lastmaxhealth then
				targetinfohealthtext.Text = string.format("%.1f", v.Health / 5)
				tween:Tween(targetinfohealth, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
					Size = UDim2.fromScale(math.max(v.Health / v.MaxHealth, 0), 1)
				})
				if lasthealth > v.Health and self.LastTarget == v then
					tween:Cancel(targetinfoshot)
					targetinfoshot.Size = UDim2.fromOffset(56, 56)
					targetinfoshot.ImageColor3 = Color3.new(1, 0, 0)
					tween:Tween(targetinfoshot, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {
						ImageColor3 = Color3.new(1, 1, 1),
						Size = UDim2.fromOffset(64, 64)
					})
				end
				lasthealth = v.Health
				lastmaxhealth = v.MaxHealth
			end

			if not v.Character then table.clear(v) end
			self.LastTarget = v
		end

		if visible ~= lastvisible then
			if visible then
				tween:Tween(targetinfoscale, TweenInfo.new(0.85, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {
					Scale = 1
				}, nil, true)
			else
				tween:Tween(targetinfoscale, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
					Scale = 0
				}, nil, true)
			end
			lastvisible = visible
		end

		return v
	end
}
mainapi.Libraries.targetinfo = targetinfo

function mainapi:UpdateTextGUI(afterload)
	if not afterload and not mainapi.Loaded then return end
	if interface.Button.Enabled then
		local found = {}
		for _, v in InterfaceLabels do
			if v.Enabled then
				table.insert(found, v.Object.Name)
			end
			v.Object:Destroy()
		end
		table.clear(InterfaceLabels)

		local info = TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
		for i, v in mainapi.Modules do
			if v.Enabled or table.find(found, i) then
				if interfaceshow.Value == 'Exclude render' and v.Category == 'Render' then continue end
				if interfaceshow.Value == 'Only bound' and #v.Bind <= 0 then continue end
				if i == 'RiseInterface' then continue end
				local holder = Instance.new('Frame')
				holder.Name = i
				holder.Size = UDim2.fromOffset(0, 22)
				holder.BackgroundTransparency = 0.5
				holder.BackgroundColor3 = Color3.new()
				holder.BorderSizePixel = 0
				holder.Parent = arrayholder
				local holderbackground = Instance.new('Frame')
				local moduletext = i..(v.ExtraText and interfacesuffix.Enabled and ' '..v.ExtraText() or '')
				if interfacelowercase.Enabled then
					moduletext = moduletext:lower()
				end
				holderbackground.Size = UDim2.fromOffset(getfontsize(moduletext, 21, uipallet.Font).X + (v.ExtraText and 10 or 8), 22)
				holderbackground.Position = UDim2.fromOffset(-holderbackground.Size.X.Offset, 0)
				holderbackground.BackgroundColor3 = Color3.new()
				holderbackground.BackgroundTransparency = interfacebkg.Value == 'Normal' and 0.5 or 1
				holderbackground.BorderSizePixel = 0
				holderbackground.Parent = holder
				local holdertext = Instance.new('TextLabel')
				holdertext.Size = UDim2.fromScale(1, 1)
				holdertext.Position = UDim2.fromOffset(v.ExtraText and -6 or -4, 0)
				holdertext.BackgroundColor3 = Color3.new()
				holdertext.BackgroundTransparency = 1
				holdertext.Text = i..(v.ExtraText and interfacesuffix.Enabled and " <font color='rgb(200, 200, 200)'>"..v.ExtraText()..'</font>' or '')
				if interfacelowercase.Enabled then
					holdertext.Text = holdertext.Text:lower()
				end
				holdertext.TextColor3 = uipallet.MainColor
				holdertext.TextSize = 21
				holdertext.TextXAlignment = Enum.TextXAlignment.Right
				holdertext.TextYAlignment = Enum.TextYAlignment.Top
				holdertext.RichText = true
				holdertext.FontFace = uipallet.Font
				holdertext.Parent = holderbackground
				local holderline
				if interfacebar.Enabled then
					holderline = Instance.new('ImageLabel')
					holderline.Size = UDim2.fromOffset(2, 18)
					holderline.Position = UDim2.new(1, 0, 0, 2)
					holderline.BackgroundTransparency = 1
					holderline.Image = getcustomasset('newvape/assets/rise/slice.png')
					holderline.ImageColor3 = uipallet.MainColor
					holderline.ZIndex = -1
					holderline.Parent = holderbackground
					addCorner(holderline, UDim.new(1, 0))
				end

				if not table.find(found, i) then
					holder.Size = UDim2.fromOffset(0, 0)
					holderbackground.Position = UDim2.fromOffset(15, 0)
					tween:Tween(holder, info, {
						Size = UDim2.fromOffset(0, 22)
					})
					tween:Tween(holderbackground, info, {
						Position = UDim2.fromOffset(-holderbackground.Size.X.Offset, 0)
					})
				else
					holder.Size = UDim2.fromOffset(0, 22)
					holderbackground.Position = UDim2.fromOffset(-holderbackground.Size.X.Offset, 0)
					if not v.Enabled then
						tween:Tween(holder, info, {
							Size = UDim2.fromOffset(0, 0)
						})
						tween:Tween(holderbackground, info, {
							Position = UDim2.fromOffset(15, 0)
						})
					end
				end

				table.insert(InterfaceLabels, {
					Object = holder,
					Text = holdertext,
					Background = holderbackground,
					Color = holderline,
					Enabled = v.Enabled
				})
			end
		end

		table.sort(InterfaceLabels, function(a, b)
			return a.Background.Size.X.Offset > b.Background.Size.X.Offset
		end)

		for i, v in InterfaceLabels do
			v.Object.LayoutOrder = i
		end
	end

	mainapi:UpdateGUI(mainapi.GUIColor.Hue, mainapi.GUIColor.Sat, mainapi.GUIColor.Value, true)
end

function mainapi:UpdateGUI(hue, sat, val, default)
	if self.Loaded == nil then return end
	if not default and self.GUIColor.Rainbow then return end
	if interface.Button.Enabled then
		watermarkgradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, uipallet.SecondaryColor:Lerp(uipallet.MainColor, 0.34)),
			ColorSequenceKeypoint.new(1, uipallet.SecondaryColor:Lerp(uipallet.MainColor, 0.64))
		})
		for _, v in InterfaceLabels do
			if interfacearraycolor.Value == 'Static' then
				v.Text.TextColor3 = uipallet.MainColor
			else
				v.Text.TextColor3 = self:RiseColor(interfacearraycolor.Value == 'Fade' and v.Text.AbsolutePosition / 2 or Vector2.new())
			end
			if v.Color then
				v.Color.ImageColor3 = v.Text.TextColor3
			end
		end
	end

	if targetinfoobj.Button.Enabled then
		targetinfogradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, color.Dark(self:RiseColor(targetinfobkg.AbsolutePosition / 2), 0.5)),
			ColorSequenceKeypoint.new(1, color.Dark(self:RiseColor((targetinfobkg.AbsolutePosition + Vector2.new(0, 100)) / 2), 0.5))
		})
		targetinfohealthgradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, uipallet.MainColor),
			ColorSequenceKeypoint.new(1, uipallet.SecondaryColor)
		})
		targetinfohealthbkg.BackgroundColor3 = color.Dark(uipallet.MainColor, 0.5)
		targetinfohealthtext.TextColor3 = uipallet.MainColor
		targetinfoname.TextColor3 = uipallet.MainColor
	end

	if not clickgui.Visible then return end

	swatermarkversion.TextColor3 = uipallet.MainColor
	categoryhighlight.BackgroundColor3 = color.Dark(self:RiseColor(categoryhighlight.AbsolutePosition), 0.2)

	for _, button in self.Modules do
		if button.Enabled then
			button.Object.Title.TextColor3 = self:RiseColor(button.Object.Title.AbsolutePosition)
		end

		for _, option in button.Options do
			if option.Color then
				option:Color(hue, sat, val, rainbowcheck)
			end
		end
	end

	if uipallet.SelectedTheme then
		uipallet.SelectedTheme.TextColor3 = uipallet.MainColor
	end
	for i, v in uipallet.ThemeObjects do
		i.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, self:RiseColorCustom(v, 0)),
			ColorSequenceKeypoint.new(0.5, self:RiseColorCustom(v, 300)),
			ColorSequenceKeypoint.new(1, self:RiseColorCustom(v, 700))
		})
	end
end

mainapi:Clean(inputService.InputBegan:Connect(function(inputObj)
	if not inputService:GetFocusedTextBox() and inputObj.KeyCode ~= Enum.KeyCode.Unknown then
		table.insert(mainapi.HeldKeybinds, inputObj.KeyCode.Name)
		if mainapi.Binding then return end

		if checkKeybinds(mainapi.HeldKeybinds, mainapi.Keybind, inputObj.KeyCode.Name) then
			if mainapi.ThreadFix then
				setthreadidentity(8)
			end
			if guiTween then
				guiTween:Cancel()
			end
			if guiTween2 then
				guiTween2:Cancel()
			end
			mainapi.Visible = not mainapi.Visible
			mainapi:CreateNotification('Toggled', 'Toggled Click GUI '..(mainapi.Visible and 'on' or 'off'), 1)
			guiTween = tweenService:Create(mainscale, TweenInfo.new(0.3, mainapi.Visible and Enum.EasingStyle.Exponential or Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
				Scale = mainapi.Visible and 1 or 0
			})
			guiTween2 = tweenService:Create(mainframe, TweenInfo.new(0.3, mainapi.Visible and Enum.EasingStyle.Exponential or Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
				GroupTransparency = mainapi.Visible and 0 or 1
			})
			guiTween:Play()
			guiTween2:Play()
			if mainapi.Visible then
				clickgui.Visible = mainapi.Visible
			else
				guiTween.Completed:Connect(function()
					clickgui.Visible = mainapi.Visible
				end)
			end
		end

		local toggled = false
		for i, v in mainapi.Modules do
			if checkKeybinds(mainapi.HeldKeybinds, v.Bind, inputObj.KeyCode.Name) then
				toggled = true
				if mainapi.ToggleNotifications.Enabled then
					mainapi:CreateNotification('Toggled', 'Toggled '..i..' '..(not v.Enabled and 'on' or 'off'), 1)
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
		if mainapi.Binding and inputObj.KeyCode.Name ~= 'LeftShift' then
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