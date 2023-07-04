if shared.VapeExecuted then
	local VERSION = "4.10"..(shared.VapePrivate and " PRIVATE" or "").." "..readfile("vape/commithash.txt"):sub(1, 6)
	local baseDirectory = (shared.VapePrivate and "vapeprivate/" or "vape/")
	local vapeAssetTable = {
		["vape/assets/AddItem.png"] = "rbxassetid://13350763121",
		["vape/assets/AddRemoveIcon1.png"] = "rbxassetid://13350764147",
		["vape/assets/ArrowIndicator.png"] = "rbxassetid://13350766521",
		["vape/assets/BackIcon.png"] = "rbxassetid://13350767223",
		["vape/assets/BindBackground.png"] = "rbxassetid://13350767577",
		["vape/assets/BlatantIcon.png"] = "rbxassetid://13350767943",
		["vape/assets/CircleListBlacklist.png"] = "rbxassetid://13350768647",
		["vape/assets/CircleListWhitelist.png"] = "rbxassetid://13350769066",
		["vape/assets/ColorSlider1.png"] = "rbxassetid://13350769439",
		["vape/assets/ColorSlider2.png"] = "rbxassetid://13350769842",
		["vape/assets/CombatIcon.png"] = "rbxassetid://13350770192",
		["vape/assets/DownArrow.png"] = "rbxassetid://13350770749",
		["vape/assets/DiscordIcon.png"] = "rbxassetid://13546311177",
		["vape/assets/ExitIcon1.png"] = "rbxassetid://13350771140",
		["vape/assets/FriendsIcon.png"] = "rbxassetid://13350771464",
		["vape/assets/HoverArrow.png"] = "rbxassetid://13350772201",
		["vape/assets/HoverArrow2.png"] = "rbxassetid://13350772588",
		["vape/assets/HoverArrow3.png"] = "rbxassetid://13350773014",
		["vape/assets/HoverArrow4.png"] = "rbxassetid://13350773643",
		["vape/assets/InfoNotification.png"] = "rbxassetid://13350774006",
		["vape/assets/KeybindIcon.png"] = "rbxassetid://13350774323",
		["vape/assets/LegitModeIcon.png"] = "rbxassetid://13436400428",
		["vape/assets/MoreButton1.png"] = "rbxassetid://13350775005",
		["vape/assets/MoreButton2.png"] = "rbxassetid://13350775731",
		["vape/assets/MoreButton3.png"] = "rbxassetid://13350776241",
		["vape/assets/NotificationBackground.png"] = "rbxassetid://13350776706",
		["vape/assets/NotificationBar.png"] = "rbxassetid://13350777235",
		["vape/assets/OnlineProfilesButton.png"] = "rbxassetid://13350777717",
		["vape/assets/PencilIcon.png"] = "rbxassetid://13350778187",
		["vape/assets/PinButton.png"] = "rbxassetid://13350778654",
		["vape/assets/ProfilesIcon.png"] = "rbxassetid://13350779149",
		["vape/assets/RadarIcon1.png"] = "rbxassetid://13350779545",
		["vape/assets/RadarIcon2.png"] = "rbxassetid://13350779992",
		["vape/assets/RainbowIcon1.png"] = "rbxassetid://13350780571",
		["vape/assets/RainbowIcon2.png"] = "rbxassetid://13350780993",
		["vape/assets/RightArrow.png"] = "rbxassetid://13350781908",
		["vape/assets/SearchBarIcon.png"] = "rbxassetid://13350782420",
		["vape/assets/SettingsWheel1.png"] = "rbxassetid://13350782848",
		["vape/assets/SettingsWheel2.png"] = "rbxassetid://13350783258",
		["vape/assets/SliderArrow1.png"] = "rbxassetid://13350783794",
		["vape/assets/SliderArrowSeperator.png"] = "rbxassetid://13350784477",
		["vape/assets/SliderButton1.png"] = "rbxassetid://13350785680",
		["vape/assets/TargetIcon.png"] = "rbxassetid://13350786128",
		["vape/assets/TargetIcon1.png"] = "rbxassetid://13350786776",
		["vape/assets/TargetIcon2.png"] = "rbxassetid://13350787228",
		["vape/assets/TargetIcon3.png"] = "rbxassetid://13350787729",
		["vape/assets/TargetIcon4.png"] = "rbxassetid://13350788379",
		["vape/assets/TargetInfoIcon1.png"] = "rbxassetid://13350788860",
		["vape/assets/TargetInfoIcon2.png"] = "rbxassetid://13350789239",
		["vape/assets/TextBoxBKG.png"] = "rbxassetid://13350789732",
		["vape/assets/TextBoxBKG2.png"] = "rbxassetid://13350790229",
		["vape/assets/TextGUIIcon1.png"] = "rbxassetid://13350790634",
		["vape/assets/TextGUIIcon2.png"] = "rbxassetid://13350791175",
		["vape/assets/TextGUIIcon3.png"] = "rbxassetid://13350791758",
		["vape/assets/TextGUIIcon4.png"] = "rbxassetid://13350792279",
		["vape/assets/ToggleArrow.png"] = "rbxassetid://13350792786",
		["vape/assets/UpArrow.png"] = "rbxassetid://13350793386",
		["vape/assets/UtilityIcon.png"] = "rbxassetid://13350793918",
		["vape/assets/WarningNotification.png"] = "rbxassetid://13350794868",
		["vape/assets/WindowBlur.png"] = "rbxassetid://13350795660",
		["vape/assets/WorldIcon.png"] = "rbxassetid://13350796199",
		["vape/assets/VapeIcon.png"] = "rbxassetid://13350808582",
		["vape/assets/RenderIcon.png"] = "rbxassetid://13350832775",
		["vape/assets/VapeLogo1.png"] = "rbxassetid://13350860863",
		["vape/assets/VapeLogo3.png"] = "rbxassetid://13350872035",
		["vape/assets/VapeLogo2.png"] = "rbxassetid://13350876307",
		["vape/assets/VapeLogo4.png"] = "rbxassetid://13350877564"
	}
	local getcustomasset = getsynasset or getcustomasset or function(location) return vapeAssetTable[location] or "" end
	local customassetcheck = (getsynasset or getcustomasset) and true
	local requestfunc = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or request or function() end 
	local isfile = isfile or function(file)
		local suc, res = pcall(function() return readfile(file) end)
		return suc and res ~= nil
	end
	local loadedsuccessfully = false
	local GuiLibrary = {
		Settings = {},
		Profiles = {
			default = {Keybind = "", Selected = true}
		},
		RainbowSpeed = 0.6,
		GUIKeybind = "RightShift",
		CurrentProfile = "default",
		KeybindCaptured = false,
		PressedKeybindKey = "",
		ToggleNotifications = false,
		Notifications = false,
		ToggleTooltips = false,
		ObjectsThatCanBeSaved = {["Gui ColorSliderColor"] = {Api = {Hue = 0.44, Sat = 1, Value = 1}}},
		MobileButtons = {},
		RainbowSliders = {}
	}
	local runService = game:GetService("RunService")
	local inputService = game:GetService("UserInputService")
	local httpService = game:GetService("HttpService")
	local tweenService = game:GetService("TweenService")
	local guiService = game:GetService("GuiService")
	local textService = game:GetService("TextService")
	local translations = shared.VapeTranslation or {}
	local translatedlogo = false

	GuiLibrary.ColorStepped = runService.RenderStepped:Connect(function()
		local col = (tick() * 0.25 * GuiLibrary.RainbowSpeed) % 1 
		for i, v in pairs(GuiLibrary.RainbowSliders) do 
			v.SetValue(col)
		end
	end)

	local function randomString()
		local randomlength = math.random(10,100)
		local array = {}

		for i = 1, randomlength do
			array[i] = string.char(math.random(32, 126))
		end

		return table.concat(array)
	end

	local function RelativeXY(GuiObject, location)
		local x, y = location.X - GuiObject.AbsolutePosition.X, location.Y - GuiObject.AbsolutePosition.Y
		local x2 = 0
		local xm, ym = GuiObject.AbsoluteSize.X, GuiObject.AbsoluteSize.Y
		x2 = math.clamp(x, 4, xm - 6)
		x = math.clamp(x, 0, xm)
		y = math.clamp(y, 0, ym)
		return x, y, x/xm, y/ym, x2/xm
	end

	local gui = Instance.new("ScreenGui")
	gui.Name = randomString()
	gui.DisplayOrder = 999
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
	gui.OnTopOfCoreBlur = true
	if gethui and (not KRNL_LOADED) then
		gui.Parent = gethui()
	elseif not is_sirhurt_closure and syn and syn.protect_gui then
		syn.protect_gui(gui)
		gui.Parent = game:GetService("CoreGui")
	else
		gui.Parent = game:GetService("CoreGui")
	end
	GuiLibrary["MainGui"] = gui

	local vapeCachedAssets = {}
	local function vapeGithubRequest(scripturl)
		if not isfile("vape/"..scripturl) then
			local suc, res = pcall(function() return game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/"..readfile("vape/commithash.txt").."/"..scripturl, true) end)
			assert(suc, res)
			assert(res ~= "404: Not Found", res)
			if scripturl:find(".lua") then res = "--This watermark is used to delete the file if its cached, remove it to make the file persist after commits.\n"..res end
			writefile("vape/"..scripturl, res)
		end
		return readfile("vape/"..scripturl)
	end
	
	local function downloadVapeAsset(path)
		if customassetcheck then
			if not isfile(path) then
				task.spawn(function()
					local textlabel = Instance.new("TextLabel")
					textlabel.Size = UDim2.new(1, 0, 0, 36)
					textlabel.Text = "Downloading "..path
					textlabel.BackgroundTransparency = 1
					textlabel.TextStrokeTransparency = 0
					textlabel.TextSize = 30
					textlabel.Font = Enum.Font.SourceSans
					textlabel.TextColor3 = Color3.new(1, 1, 1)
					textlabel.Position = UDim2.new(0, 0, 0, -36)
					textlabel.Parent = GuiLibrary.MainGui
					repeat task.wait() until isfile(path)
					textlabel:Destroy()
				end)
				local suc, req = pcall(function() return vapeGithubRequest(path:gsub("vape/assets", "assets")) end)
				if suc and req then
					writefile(path, req)
				else
					return ""
				end
			end
		end
		if not vapeCachedAssets[path] then vapeCachedAssets[path] = getcustomasset(path) end
		return vapeCachedAssets[path] 
	end

	GuiLibrary["UpdateHudEvent"] = Instance.new("BindableEvent")
	GuiLibrary["SelfDestructEvent"] = Instance.new("BindableEvent")
	GuiLibrary["LoadSettingsEvent"] = Instance.new("BindableEvent")

	local scaledgui = Instance.new("Frame")
	scaledgui.Name = "ScaledGui"
	scaledgui.Size = UDim2.new(1, 0, 1, 0)
	scaledgui.BackgroundTransparency = 1
	scaledgui.Parent = GuiLibrary["MainGui"]
	local clickgui = Instance.new("Frame")
	clickgui.Name = "ClickGui"
	clickgui.Size = UDim2.new(1, 0, 1, 0)
	clickgui.BackgroundTransparency = 1
	clickgui.BorderSizePixel = 0
	clickgui.BackgroundColor3 = Color3.fromRGB(79, 83, 166)
	clickgui.Visible = false
	clickgui.Parent = scaledgui
	local searchbarmain = Instance.new("Frame")
	searchbarmain.Size = UDim2.new(0, 220, 0, 37)
	searchbarmain.Position = UDim2.new(0.5, -110, 0, -23)
	searchbarmain.ClipsDescendants = false
	searchbarmain.ZIndex = 10
	searchbarmain.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	searchbarmain.Name = "SearchBar"
	searchbarmain.Parent = clickgui
	local searchbarchildren = Instance.new("Frame")
	searchbarchildren.Size = UDim2.new(1, 0, 1, -37)
	searchbarchildren.Position = UDim2.new(0, 0, 0, 37)
	searchbarchildren.BackgroundTransparency = 1
	searchbarchildren.ZIndex = 10
	searchbarchildren.Parent = searchbarmain
	local searchbaricon = Instance.new("ImageLabel")
	searchbaricon.BackgroundTransparency = 1
	searchbaricon.ZIndex = 10
	searchbaricon.Image = downloadVapeAsset("vape/assets/SearchBarIcon.png")
	searchbaricon.Size = UDim2.new(0, 14, 0, 14)
	searchbaricon.Position = UDim2.new(1, -32, 0, 10)
	searchbaricon.Parent = searchbarmain
	local searchbar = Instance.new("TextBox")
	searchbar.PlaceholderText = ""
	searchbar.Text = ""
	searchbar.ZIndex = 10
	searchbar.TextColor3 = Color3.fromRGB(121, 121, 121)
	searchbar.Size = UDim2.new(1, -56, 0, 37)
	searchbar.Font = Enum.Font.Gotham
	searchbar.TextXAlignment = Enum.TextXAlignment.Left
	searchbar.TextSize = 15
	searchbar.Position = UDim2.new(0, 56, 0, 0)
	searchbar.BackgroundTransparency = 1
	searchbar.Parent = searchbarmain
	local searchbarshadow = Instance.new("ImageLabel")
	searchbarshadow.AnchorPoint = Vector2.new(0.5, 0.5)
	searchbarshadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	searchbarshadow.Image = downloadVapeAsset("vape/assets/WindowBlur.png")
	searchbarshadow.BackgroundTransparency = 1
	searchbarshadow.ZIndex = -1
	searchbarshadow.Size = UDim2.new(1, 6, 1, 6)
	searchbarshadow.ImageColor3 = Color3.new(0, 0, 0)
	searchbarshadow.ScaleType = Enum.ScaleType.Slice
	searchbarshadow.SliceCenter = Rect.new(10, 10, 118, 118)
	searchbarshadow.Parent = searchbarmain
	local searchbarround = Instance.new("UICorner")
	searchbarround.CornerRadius = UDim.new(0, 5)
	searchbarround.Parent = searchbarmain
	local searchbaricon2 = Instance.new("ImageButton")
	searchbaricon2.Size = UDim2.new(0, 29, 0, 16)
	searchbaricon2.AutoButtonColor = false
	searchbaricon2.Image = downloadVapeAsset("vape/assets/LegitModeIcon.png")
	searchbaricon2.BackgroundTransparency = 1
	searchbaricon2.Name = "LegitMode"
	searchbaricon2.ZIndex = 10
	searchbaricon2.Position = UDim2.new(0, 8, 0, 11)
	searchbaricon2.Parent = searchbarmain
	local searchbarborder = Instance.new("Frame")
	searchbarborder.Size = UDim2.new(0, 2, 0, 12)
	searchbarborder.BorderSizePixel = 0
	searchbarborder.ZIndex = 10
	searchbarborder.Position = UDim2.new(0, 43, 0, 13)
	searchbarborder.BackgroundColor3 = Color3.fromRGB(51, 51, 51)
	searchbarborder.Parent = searchbarmain
	local OnlineProfilesBigFrame = Instance.new("Frame")
	OnlineProfilesBigFrame.Size = UDim2.new(1, 0, 1, 0)
	OnlineProfilesBigFrame.Name = "OnlineProfiles"
	OnlineProfilesBigFrame.BackgroundTransparency = 1
	OnlineProfilesBigFrame.Visible = false
	OnlineProfilesBigFrame.Parent = scaledgui
	local legitgui = Instance.new("Frame")
	legitgui.Name = "LegitGui"
	legitgui.Size = UDim2.new(1, 0, 1, 0)
	legitgui.BackgroundTransparency = 1
	legitgui.Visible = true
	legitgui.Parent = scaledgui
	local LegitModulesBigFrame = Instance.new("Frame")
	LegitModulesBigFrame.Size = UDim2.new(1, 0, 1, 0)
	LegitModulesBigFrame.Name = "LegitModules"
	LegitModulesBigFrame.BackgroundTransparency = 1
	LegitModulesBigFrame.Visible = false
	LegitModulesBigFrame.Parent = scaledgui
	local LegitModulesFrame = Instance.new("Frame")
	LegitModulesFrame.Size = UDim2.new(0, 700, 0, 389)
	LegitModulesFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	LegitModulesFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	LegitModulesFrame.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
	LegitModulesFrame.Parent = LegitModulesBigFrame
	local LegitModulesExitButton = Instance.new("ImageButton")
	LegitModulesExitButton.Name = "LegitModulesExitButton"
	LegitModulesExitButton.ImageColor3 = Color3.fromRGB(121, 121, 121)
	LegitModulesExitButton.Size = UDim2.new(0, 24, 0, 24)
	LegitModulesExitButton.AutoButtonColor = false
	LegitModulesExitButton.Image = downloadVapeAsset("vape/assets/ExitIcon1.png")
	LegitModulesExitButton.Visible = true
	LegitModulesExitButton.Position = UDim2.new(1, -31, 0, 8)
	LegitModulesExitButton.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
	LegitModulesExitButton.Parent = LegitModulesFrame
	LegitModulesExitButton.MouseButton1Click:Connect(function()
		LegitModulesBigFrame.Visible = false
		clickgui.Visible = true
		legitgui.Visible = not clickgui.Visible
		for i, v in pairs(legitgui:GetChildren()) do 
			if v:IsA("Frame") then v.BackgroundTransparency = legitgui.Visible and 0.8 or 1 end
		end
	end)
	local LegitModulesExitButtonround = Instance.new("UICorner")
	LegitModulesExitButtonround.CornerRadius = UDim.new(0, 16)
	LegitModulesExitButtonround.Parent = LegitModulesExitButton
	LegitModulesExitButton.MouseEnter:Connect(function()
		game:GetService("TweenService"):Create(LegitModulesExitButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(60, 60, 60), ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play()
	end)
	LegitModulesExitButton.MouseLeave:Connect(function()
		game:GetService("TweenService"):Create(LegitModulesExitButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(26, 25, 26), ImageColor3 = Color3.fromRGB(121, 121, 121)}):Play()
	end)
	local LegitModulesFrameShadow = Instance.new("ImageLabel")
	LegitModulesFrameShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	LegitModulesFrameShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	LegitModulesFrameShadow.Image = downloadVapeAsset("vape/assets/WindowBlur.png")
	LegitModulesFrameShadow.BackgroundTransparency = 1
	LegitModulesFrameShadow.ZIndex = -1
	LegitModulesFrameShadow.Size = UDim2.new(1, 6, 1, 6)
	LegitModulesFrameShadow.ImageColor3 = Color3.new()
	LegitModulesFrameShadow.ScaleType = Enum.ScaleType.Slice
	LegitModulesFrameShadow.SliceCenter = Rect.new(10, 10, 118, 118)
	LegitModulesFrameShadow.Parent = LegitModulesFrame
	local LegitModulesFrameIcon = Instance.new("ImageLabel")
	LegitModulesFrameIcon.Size = UDim2.new(0, 19, 0, 16)
	LegitModulesFrameIcon.Image = downloadVapeAsset("vape/assets/ProfilesIcon.png")
	LegitModulesFrameIcon.Name = "WindowIcon"
	LegitModulesFrameIcon.BackgroundTransparency = 1
	LegitModulesFrameIcon.Position = UDim2.new(0, 10, 0, 13)
	LegitModulesFrameIcon.ImageColor3 = Color3.fromRGB(200, 200, 200)
	LegitModulesFrameIcon.Parent = LegitModulesFrame
	local LegitModulesList = Instance.new("ScrollingFrame")
	LegitModulesList.BackgroundTransparency = 1
	LegitModulesList.Size = UDim2.new(0, 700, 0, 294)
	LegitModulesList.Position = UDim2.new(0, 14, 0, 81)
	LegitModulesList.CanvasSize = UDim2.new(0, 700, 0, 294)
	LegitModulesList.Parent = LegitModulesFrame
	local LegitModulesListGrid = Instance.new("UIGridLayout")
	LegitModulesListGrid.CellSize = UDim2.new(0, 163, 0, 114)
	LegitModulesListGrid.CellPadding = UDim2.new(0, 6, 0, 6)
	LegitModulesListGrid.Parent = LegitModulesList
	local LegitModulesFrameCorner = Instance.new("UICorner")
	LegitModulesFrameCorner.CornerRadius = UDim.new(0, 4)
	LegitModulesFrameCorner.Parent = LegitModulesFrame
	local notificationwindow = Instance.new("Frame")
	notificationwindow.BackgroundTransparency = 1
	notificationwindow.Active = false
	notificationwindow.Size = UDim2.new(1, 0, 1, 0)
	notificationwindow.Parent = GuiLibrary["MainGui"]
	local hoverbox = Instance.new("TextLabel")
	hoverbox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	hoverbox.Active = false
	hoverbox.Text = "  ".."Placeholder"
	hoverbox.ZIndex = 11
	hoverbox.TextColor3 = Color3.fromRGB(160, 160, 160)
	hoverbox.Font = Enum.Font.Arial
	hoverbox.TextXAlignment = Enum.TextXAlignment.Left
	hoverbox.TextSize = 14
	hoverbox.Visible = false
	hoverbox.Parent = clickgui
	local hoverround = Instance.new("UICorner")
	hoverround.CornerRadius = UDim.new(0, 5)
	hoverround.Parent = hoverbox
	local hoverbox2 = hoverbox:Clone()
	hoverbox2.ZIndex = -1
	hoverbox2.Size = UDim2.new(1, 2, 1, 2)
	hoverbox2.Text = ""
	hoverbox2.Visible = true
	hoverbox2.BackgroundColor3 = Color3.fromRGB(32, 35, 36)
	hoverbox2.Position = UDim2.new(0, -1, 0, -1)
	hoverbox2.Parent = hoverbox
	local hoverboxshadow = Instance.new("ImageLabel")
	hoverboxshadow.AnchorPoint = Vector2.new(0.5, 0.5)
	hoverboxshadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	hoverboxshadow.Image = downloadVapeAsset("vape/assets/WindowBlur.png")
	hoverboxshadow.BackgroundTransparency = 1
	hoverboxshadow.ZIndex = -1
	hoverboxshadow.Visible = true
	hoverboxshadow.Size = UDim2.new(1, 6, 1, 6)
	hoverboxshadow.ImageColor3 = Color3.new(0, 0, 0)
	hoverboxshadow.ScaleType = Enum.ScaleType.Slice
	hoverboxshadow.SliceCenter = Rect.new(10, 10, 118, 118)
	hoverboxshadow.Parent = hoverbox
	local vertextsize = textService:GetTextSize("v"..VERSION, 19, Enum.Font.SourceSans, Vector2.new(99999, 99999))
	local vertext = Instance.new("TextLabel")
	vertext.Name = "Version"
	vertext.Size = UDim2.new(0, vertextsize.X, 0, 20)
	vertext.Font = Enum.Font.SourceSans
	vertext.TextColor3 = Color3.new(1, 1, 1)
	vertext.Active = false
	vertext.TextSize = 19
	vertext.BackgroundTransparency = 1
	vertext.Text = "v"..VERSION
	vertext.TextXAlignment = Enum.TextXAlignment.Left
	vertext.TextYAlignment = Enum.TextYAlignment.Top
	vertext.Position = UDim2.new(1, -(vertextsize.X) - 20, 1, -19)
	vertext.Parent = clickgui
	local vertext2 = vertext:Clone()
	vertext2.Position = UDim2.new(0, 1, 0, 1)
	vertext2.TextColor3 = Color3.new(0.42, 0.42, 0.42)
	vertext2.ZIndex = 0
	vertext2.Parent = vertext
	local modal = Instance.new("TextButton")
	modal.Size = UDim2.new(0, 0, 0, 0)
	modal.BorderSizePixel = 0
	modal.Text = ""
	modal.Modal = true
	modal.Parent = clickgui
	local hudgui = Instance.new("Frame")
	hudgui.Name = "HudGui"
	hudgui.Size = UDim2.new(1, 0, 1, 0)
	hudgui.BackgroundTransparency = 1
	hudgui.Visible = true
	hudgui.Parent = scaledgui
	GuiLibrary["MainBlur"] = {Size = 25}
	GuiLibrary["MainRescale"] = Instance.new("UIScale")
	GuiLibrary["MainRescale"].Parent = scaledgui
	GuiLibrary["MainRescale"]:GetPropertyChangedSignal("Scale"):Connect(function()
		vertext.Position = UDim2.new(1 / GuiLibrary["MainRescale"].Scale, -(vertextsize.X) - 20, 1 / GuiLibrary["MainRescale"].Scale, -25)
	end)

	local function dragGUI(gui, mod)
		task.spawn(function()
			local dragging
			local dragInput
			local dragStart = Vector3.new(0,0,0)
			local startPos
			local function update(input)
				local delta = input.Position - dragStart
				local Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + (delta.X * (1 / GuiLibrary.MainRescale.Scale)), startPos.Y.Scale, startPos.Y.Offset + (delta.Y * (1 / GuiLibrary.MainRescale.Scale)))
				tweenService:Create(gui, TweenInfo.new(.20), {Position = Position}):Play()
			end
			gui.InputBegan:Connect(function(input)
				if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and (not mod or LegitModulesFrame.Visible) then
					dragStart = input.Position
					local delta = (dragStart - Vector3.new(gui.AbsolutePosition.X, gui.AbsolutePosition.Y, 0)) * (1 / GuiLibrary.MainRescale.Scale)
					if delta.Y <= 40 then
						dragging = mod and LegitModulesFrame.Visible or clickgui.Visible
						startPos = gui.Position
						
						input.Changed:Connect(function()
							if input.UserInputState == Enum.UserInputState.End then
								dragging = false
							end
						end)
					end
				end
			end)
			gui.InputChanged:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
					dragInput = input
				end
			end)
			inputService.InputChanged:Connect(function(input)
				if input == dragInput and dragging then
					update(input)
				end
			end)
		end)
	end

	local function createMobileButton(buttonapi, position)
		local touchButton = Instance.new("TextButton")
		touchButton.Size = UDim2.new(0, 40, 0, 40)
		touchButton.BackgroundTransparency = 0.5
		touchButton.BackgroundColor3 = buttonapi.Enabled and Color3.new(0, 0.7, 0) or Color3.new()
		touchButton.TextColor3 = Color3.new(1, 1, 1)
		touchButton.Text = buttonapi.Name
		touchButton.Font = Enum.Font.Gotham
		touchButton.TextScaled = true
		touchButton.AnchorPoint = Vector2.new(0.5, 0.5)
		touchButton.Position = UDim2.new(0, position.X, 0, position.Y)
		touchButton.Parent = GuiLibrary.MainGui
		touchButton.MouseButton1Click:Connect(function()
			buttonapi.ToggleButton(true)
			touchButton.BackgroundColor3 = buttonapi.Enabled and Color3.new(0, 0.7, 0) or Color3.new()
		end)
		local touchedButton = false
		touchButton.MouseButton1Down:Connect(function()
			touchedButton = true
			local touchtick2 = tick()
			repeat task.wait() until (tick() - touchtick2) > 1 or not touchedButton
			if touchedButton then 
				local ind = table.find(GuiLibrary.MobileButtons, touchButton)
				if ind then table.remove(GuiLibrary.MobileButtons, ind) end
				touchButton:Destroy()
			end
		end)
		touchButton.MouseButton1Up:Connect(function()
			touchedButton = false
		end)
		local touchCorner = Instance.new("UICorner")
		touchCorner.CornerRadius = UDim.new(0, 1024)
		touchCorner.Parent = touchButton
		local touchTextLimit = Instance.new("UITextSizeConstraint")
		touchTextLimit.MaxTextSize = 16
		touchTextLimit.Parent = touchButton
		table.insert(GuiLibrary.MobileButtons, touchButton)
	end

	GuiLibrary.SaveSettings = function()
		if not loadedsuccessfully then return end
		writefile(baseDirectory.."Profiles/"..(shared.CustomSaveVape or game.PlaceId)..".vapeprofiles.txt", httpService:JSONEncode(GuiLibrary.Profiles))
		local WindowTable = {}
		for i,v in pairs(GuiLibrary.ObjectsThatCanBeSaved) do
			if v.Type == "Window" then
				WindowTable[i] = {["Type"] = "Window", ["Visible"] = v.Object.Visible, ["Expanded"] = v["ChildrenObject"].Visible, ["Position"] = {v.Object.Position.X.Scale, v.Object.Position.X.Offset, v.Object.Position.Y.Scale, v.Object.Position.Y.Offset}}
			end
			local bypass = v.Api.Bypass and GuiLibrary.Settings or WindowTable
			if v.Type == "CustomWindow" then
				bypass[i] = {["Type"] = "CustomWindow", ["Visible"] = v.Object.Visible, ["Pinned"] = v["Api"]["Pinned"], ["Position"] = {v.Object.Position.X.Scale, v.Object.Position.X.Offset, v.Object.Position.Y.Scale, v.Object.Position.Y.Offset}}
			end
			if (v.Type == "ButtonMain" or v.Type == "ToggleMain") then
				bypass[i] = {["Type"] = "ButtonMain", ["Enabled"] = v["Api"]["Enabled"], ["Keybind"] = v["Api"]["Keybind"]}
			end
			if v.Type == "ColorSliderMain" then
				bypass[i] = {["Type"] = "ColorSliderMain", ["Hue"] = v["Api"]["Hue"], ["Sat"] = v["Api"]["Sat"], ["Value"] = v["Api"]["Value"], ["RainbowValue"] = v["Api"]["RainbowValue"], ["Custom"] = v["Api"]["Custom"]}
			end
			if v.Type == "ColorSliderGUI" then
				bypass[i] = {["Type"] = "ColorSliderGUI", ["Hue"] = v["Api"]["Custom"] and v["Api"]["Hue"] or v["Api"]["Saved"], ["Sat"] = v["Api"]["Sat"], ["Value"] = v["Api"]["Value"], ["RainbowValue"] = v["Api"]["RainbowValue"], ["Custom"] = v["Api"]["Custom"]}
			end
			if v.Type == "SliderMain" then
				bypass[i] = {["Type"] = "SliderMain", ["Value"] = v["Api"]["Value"]}
			end
			if v.Type == "DropdownMain" then
				bypass[i] = {["Type"] = "DropdownMain", ["Value"] = v["Api"]["Value"]}
			end
			if v.Type == "TextBoxMain" then
				bypass[i] = {["Type"] = "TextBoxMain", ["Value"] = v["Api"]["Value"]}
			end
			if (v.Type == "Button" or v.Type == "Toggle" or v.Type == "ExtrasButton" or v.Type == "TargetButton") then
				GuiLibrary.Settings[i] = {["Type"] = "Button", ["Enabled"] = v["Api"]["Enabled"], ["Keybind"] = v["Api"]["Keybind"]}
			end
			if (v.Type == "OptionsButton" or v.Type == "ExtrasButton") then
				GuiLibrary.Settings[i] = {["Type"] = "OptionsButton", ["Enabled"] = v["Api"]["Enabled"], ["Keybind"] = v["Api"]["Keybind"]}
			end
			if v.Type == "TextList" then
				GuiLibrary.Settings[i] = {["Type"] = "TextList", ["ObjectTable"] = v["Api"]["ObjectList"]}
			end
			if v.Type == "TextCircleList" then
				GuiLibrary.Settings[i] = {["Type"] = "TextCircleList", ["ObjectTable"] = v["Api"]["ObjectList"], ["ObjectTableEnabled"] = v["Api"]["ObjectListEnabled"]}
			end
			if v.Type == "TextBox" then
				GuiLibrary.Settings[i] = {["Type"] = "TextBox", ["Value"] = v["Api"]["Value"]}
			end
			if v.Type == "Dropdown" then
				GuiLibrary.Settings[i] = {["Type"] = "Dropdown", ["Value"] = v["Api"]["Value"]}
			end
			if v.Type == "Slider" then
				GuiLibrary.Settings[i] = {["Type"] = "Slider", ["Value"] = v["Api"]["Value"], ["OldMax"] = v["Api"]["Max"], ["OldDefault"] = v["Api"]["Default"]}
			end
			if v.Type == "TwoSlider" then
				GuiLibrary.Settings[i] = {["Type"] = "TwoSlider", ["Value"] = v["Api"]["Value"], ["Value2"] = v["Api"]["Value2"], ["SliderPos1"] = (v.Object:FindFirstChild("Slider") and v.Object.Slider.ButtonSlider.Position.X.Scale or 0), ["SliderPos2"] = (v.Object:FindFirstChild("Slider") and v.Object.Slider.ButtonSlider2.Position.X.Scale or 0)}
			end
			if v.Type == "ColorSlider" then
				GuiLibrary.Settings[i] = {["Type"] = "ColorSlider", ["Hue"] = v["Api"]["Hue"], ["Sat"] = v["Api"]["Sat"], ["Value"] = v["Api"]["Value"], ["RainbowValue"] = v["Api"]["RainbowValue"]}
			end
			if v.Type == "LegitModule" then 
				GuiLibrary.Settings[i] = {["Type"] = "LegitModule", ["Enabled"] = v["Api"]["Enabled"], ["Position"] = {v.Object.Position.X.Scale, v.Object.Position.X.Offset, v.Object.Position.Y.Scale, v.Object.Position.Y.Offset}}
			end
		end
		local mobileButtonSaving = {}
		for _, mobileButton in pairs(GuiLibrary.MobileButtons) do 
			table.insert(mobileButtonSaving, {Position = {mobileButton.Position.X.Offset, mobileButton.Position.Y.Offset}, Module = mobileButton.Text.."OptionsButton"})
		end
		GuiLibrary.Settings["MobileButtons"] = {["Type"] = "MobileButtons", ["Buttons"] = mobileButtonSaving}
		WindowTable["GUIKeybind"] = {["Type"] = "GUIKeybind", ["Value"] = GuiLibrary["GUIKeybind"]}
		writefile(baseDirectory.."Profiles/"..(GuiLibrary.CurrentProfile == "default" and "" or GuiLibrary.CurrentProfile)..(shared.CustomSaveVape or game.PlaceId)..".vapeprofile.txt", httpService:JSONEncode(GuiLibrary.Settings))
		writefile(baseDirectory.."Profiles/"..(game.GameId).."GUIPositions.vapeprofile.txt", httpService:JSONEncode(WindowTable))
	end

	GuiLibrary.LoadSettings = function(customprofile)
		if isfile("vape/Profiles/GUIPositions.vapeprofile.txt") and game.GameId == 2619619496 then
			writefile("vape/Profiles/"..(game.GameId).."GUIPositions.vapeprofile.txt", readfile("vape/Profiles/GUIPositions.vapeprofile.txt"))
			if delfile then delfile("vape/Profiles/GUIPositions.vapeprofile.txt") end
		end
		if shared.VapePrivate then
			if isfile("vapeprivate/Profiles/"..(game.GameId).."GUIPositions.vapeprofile.txt") == false and isfile("vape/Profiles/"..(game.GameId).."GUIPositions.vapeprofile.txt") then
				writefile("vapeprivate/Profiles/"..(game.GameId).."GUIPositions.vapeprofile.txt", readfile("vape/Profiles/"..(game.GameId).."GUIPositions.vapeprofile.txt"))
			end
			if isfile("vapeprivate/Profiles/"..(shared.CustomSaveVape or game.PlaceId)..".vapeprofiles.txt") == false and isfile("vape/Profiles/"..(shared.CustomSaveVape or game.PlaceId)..".vapeprofiles.txt") then
				writefile("vapeprivate/Profiles/"..(shared.CustomSaveVape or game.PlaceId)..".vapeprofiles.txt", readfile("vape/Profiles/"..(shared.CustomSaveVape or game.PlaceId)..".vapeprofiles.txt"))
			end
		end
		local success2, result2 = pcall(function()
			return httpService:JSONDecode(readfile(baseDirectory.."Profiles/"..(shared.CustomSaveVape or game.PlaceId)..".vapeprofiles.txt"))
		end)
		if success2 and type(result2) == "table" then
			GuiLibrary.Profiles = result2
		end
		for i,v in pairs(GuiLibrary.Profiles) do
			if v.Selected then
				GuiLibrary.CurrentProfile = i
			end
		end
		if customprofile then 
			GuiLibrary.Profiles[GuiLibrary.CurrentProfile]["Selected"] = false
			GuiLibrary.Profiles[customprofile] = GuiLibrary.Profiles[customprofile] or {["Keybind"] = "", ["Selected"] = true}
			GuiLibrary.CurrentProfile = customprofile
		end
		if shared.VapePrivate then
			if isfile("vapeprivate/Profiles/"..(GuiLibrary.CurrentProfile == "default" and "" or GuiLibrary.CurrentProfile)..(shared.CustomSaveVape or game.PlaceId)..".vapeprofile.txt") == false and isfile("vape/Profiles/"..(GuiLibrary.CurrentProfile == "default" and "" or GuiLibrary.CurrentProfile)..(shared.CustomSaveVape or game.PlaceId)..".vapeprofile.txt") then
				writefile("vapeprivate/Profiles/"..(GuiLibrary.CurrentProfile == "default" and "" or GuiLibrary.CurrentProfile)..(shared.CustomSaveVape or game.PlaceId)..".vapeprofile.txt", readfile("vape/Profiles/"..(GuiLibrary.CurrentProfile == "default" and "" or GuiLibrary.CurrentProfile)..(shared.CustomSaveVape or game.PlaceId)..".vapeprofile.txt"))
			end
		end
		local success3, result3 = pcall(function()
			return httpService:JSONDecode(readfile(baseDirectory.."Profiles/"..(game.GameId).."GUIPositions.vapeprofile.txt"))
		end)
		if success3 and type(result3) == "table" then
			for i,v in pairs(result3) do
				local obj = GuiLibrary.ObjectsThatCanBeSaved[i]
				if obj then
					if v.Type == "Window" then
						obj.Object.Position = UDim2.new(v["Position"][1], v["Position"][2], v["Position"][3], v["Position"][4])
						obj.Object.Visible = v["Visible"]
						if v["Expanded"] then
							obj["Api"]["ExpandToggle"]()
						end
					end
					if v.Type == "CustomWindow" then
						obj.Object.Position = UDim2.new(v["Position"][1], v["Position"][2], v["Position"][3], v["Position"][4])
						obj.Object.Visible = v["Visible"]
						if v["Pinned"] then
							obj["Api"]["PinnedToggle"]()
						end
						obj["Api"]["CheckVis"]()
					end
					if v.Type == "ButtonMain" then
						if obj["Type"] == "ToggleMain" then
							obj["Api"]["ToggleButton"](v["Enabled"], true)
							if v["Keybind"] ~= "" then
								obj["Api"]["Keybind"] = v["Keybind"]
							end
						else
							if v["Enabled"] then
								obj["Api"]["ToggleButton"](false, true)
								if v["Keybind"] ~= "" then
									obj["Api"]["SetKeybind"](v["Keybind"])
								end
							end
						end
					end
					if v.Type == "DropdownMain" then 
						obj["Api"]["SetValue"](v["Value"])
					end
					if v.Type == "ColorSliderMain" then
						local valcheck = v["Hue"] ~= nil
						obj["Api"]["SetValue"](valcheck and v["Hue"] or v["Value"] or 0.44, valcheck or v["Sat"] or 1, valcheck and v["Value"] or 1)
						if v["RainbowValue"] then obj["Api"]["SetRainbow"](v["RainbowValue"]) end
					end
					if v.Type == "ColorSliderGUI" then
						local valcheck = v["Hue"] ~= nil
						obj["Api"]["Custom"] = v["Custom"]
						if v["Custom"] then
							obj["Api"]["SetValue"](v["Hue"], v["Sat"], v["Value"])
						else
							obj["Api"]["SetValue"](valcheck and v["Hue"] and (v["Hue"] / 7) - 0.1 or v["Value"] or 0.44, valcheck and v["Sat"] or 1, valcheck and v["Value"] or 1)
						end
						if v["RainbowValue"] then obj["Api"]["SetRainbow"](v["RainbowValue"]) end
					end
					if v.Type == "SliderMain" then
						obj["Api"]["SetValue"](v["Value"])
					end
					if v.Type == "TextBoxMain" then
						obj["Api"]["SetValue"](v["Value"])
					end
				end
				if v.Type == "GUIKeybind" then
					if (v.Value ~= "RightShift") then 
						if shared.VapeButton then shared.VapeButton:Destroy() end
					end
					GuiLibrary["GUIKeybind"] = v["Value"]
				end
			end
		end
		local success, result = pcall(function()
			return httpService:JSONDecode(readfile(baseDirectory.."Profiles/"..(GuiLibrary.CurrentProfile == "default" and "" or GuiLibrary.CurrentProfile)..(shared.CustomSaveVape or game.PlaceId)..".vapeprofile.txt"))
		end)
		if success and type(result) == "table" then
			GuiLibrary["LoadSettingsEvent"]:Fire(result)
			for i,v in pairs(result) do
				if v.Type == "Custom" and GuiLibrary.Settings[i] then
					GuiLibrary.Settings[i] = v
				end
				local obj = GuiLibrary.ObjectsThatCanBeSaved[i]
				if obj then
					local starttick = tick()
					if v.Type == "Dropdown" then
						obj["Api"]["SetValue"](v["Value"])
					end
					if v.Type == "CustomWindow" then
						obj.Object.Position = UDim2.new(v["Position"][1], v["Position"][2], v["Position"][3], v["Position"][4])
						obj.Object.Visible = v["Visible"]
						if v["Pinned"] then
							obj["Api"]["PinnedToggle"]()
						end
						obj["Api"]["CheckVis"]()
					end
					if v.Type == "ButtonMain" then
						if obj["Type"] == "ToggleMain" then
							obj["Api"]["ToggleButton"](v["Enabled"], true)
							if v["Keybind"] ~= "" then
								obj["Api"]["Keybind"] = v["Keybind"]
							end
						else
							if v["Enabled"] then
								obj["Api"]["ToggleButton"](false, true)
								if v["Keybind"] ~= "" then
									obj["Api"]["SetKeybind"](v["Keybind"])
								end
							end
						end
					end
					if v.Type == "DropdownMain" then 
						obj["Api"]["SetValue"](v["Value"])
					end
					if v.Type == "ColorSliderMain" then
						local valcheck = v["Hue"] ~= nil
						obj["Api"]["SetValue"](valcheck and v["Hue"] or v["Value"] or 0.44, valcheck or v["Sat"] or 1, valcheck and v["Value"] or 1)
						if v["RainbowValue"] then obj["Api"]["SetRainbow"](v["RainbowValue"]) end
					end
					if v.Type == "Button" then
						if obj["Type"] == "Toggle" then
							if obj["Api"]["Default"] then
								if not v["Enabled"] then 
									obj["Api"]["ToggleButton"](v["Enabled"], true) 
								end
							else
								obj["Api"]["ToggleButton"](v["Enabled"], true)
							end
							if v["Keybind"] ~= "" then
								obj["Api"]["Keybind"] = v["Keybind"]
							end
						elseif obj["Type"] == "TargetButton" then
							obj["Api"]["ToggleButton"](v["Enabled"], true)
						else
							if v["Enabled"] then
								obj["Api"]["ToggleButton"](false)
								if v["Keybind"] ~= "" then
									obj["Api"]["SetKeybind"](v["Keybind"])
								end
							end
						end
					end
					if v.Type == "NewToggle" then
						obj["Api"]["ToggleButton"](v["Enabled"], true)
						if v["Keybind"] ~= "" then
							obj["Api"]["Keybind"] = v["Keybind"]
						end
					end
					if v.Type == "Slider" then
						obj["Api"]["SetValue"](v["OldMax"] ~= obj["Api"]["Max"] and v["Value"] > obj["Api"]["Max"] and obj["Api"]["Max"] or (v["OldDefault"] ~= obj["Api"]["Default"] and v["Value"] == v["OldDefault"] and obj["Api"]["Default"] or v["Value"]))
					end
					if v.Type == "TextBox" then
						obj["Api"]["SetValue"](v["Value"])
					end
					if v.Type == "TextList" then
						obj["Api"]["RefreshValues"]((v["ObjectTable"] or {}))
					end
					if v.Type == "TextCircleList" then
						obj["Api"]["RefreshValues"]((v["ObjectTable"] or {}), (v["ObjectTableEnabled"] or {}))
					end
					if v.Type == "TwoSlider" then
						obj["Api"]["SetValue"](v["Value"] == obj["Api"]["Min"] and 0 or v["Value"])
						obj["Api"]["SetValue2"](v["Value2"])
						obj.Object.Slider.ButtonSlider.Position = UDim2.new(v["SliderPos1"], -8, 1, -9)
						obj.Object.Slider.ButtonSlider2.Position = UDim2.new(v["SliderPos2"], -8, 1, -9)
						obj.Object.Slider.FillSlider.Size = UDim2.new(0, obj.Object.Slider.ButtonSlider2.AbsolutePosition.X - obj.Object.Slider.ButtonSlider.AbsolutePosition.X, 1, 0)
						obj.Object.Slider.FillSlider.Position = UDim2.new(obj.Object.Slider.ButtonSlider.Position.X.Scale, 0, 0, 0)
						--obj.Object.Slider.FillSlider.Size = UDim2.new((v["Value"] < obj["Api"]["Max"] and v["Value"] or obj["Api"]["Max"]) / obj["Api"]["Max"], 0, 1, 0)
					end
					if v.Type == "ColorSlider" then
						v["Hue"] = v["Hue"] or 0.44
						v["Sat"] = v["Sat"] or 1
						v["Value"] = v["Value"] or 1
						obj["Api"]["SetValue"](v["Hue"], v["Sat"], v["Value"])
						if v["RainbowValue"] then obj["Api"]["SetRainbow"](v["RainbowValue"]) end
						obj.Object.Slider.ButtonSlider.Position = UDim2.new(math.clamp(v["Hue"], 0.02, 0.95), -9, 0, -7)
						pcall(function()
							obj["Object2"].Slider.ButtonSlider.Position = UDim2.new(math.clamp(v["Sat"], 0.02, 0.95), -9, 0, -7)
							obj["Object3"].Slider.ButtonSlider.Position = UDim2.new(math.clamp(v["Value"], 0.02, 0.95), -9, 0, -7)
						end)
					end
					if v.Type == "LegitModule" then 
						obj.Object.Position = UDim2.new(v["Position"][1], v["Position"][2], v["Position"][3], v["Position"][4])
						if v["Enabled"] then
							obj["Api"]["ToggleButton"](true)
						end
					end
				end
			end
			for i,v in pairs(result) do
				local obj = GuiLibrary.ObjectsThatCanBeSaved[i]
				if obj then 
					if v.Type == "OptionsButton" then
						if v["Enabled"] and not obj["Api"]["Enabled"] then
							obj["Api"]["ToggleButton"](false)
						end
						if v["Keybind"] ~= "" then
							obj["Api"]["SetKeybind"](v["Keybind"])
						end
					end
				end
			end
			for i,v in pairs(result) do
				if v.Type == "MobileButtons" then 
					for _, mobileButton in pairs(v.Buttons) do 
						local module = GuiLibrary.ObjectsThatCanBeSaved[mobileButton.Module]
						if module then 
							createMobileButton(module.Api, Vector2.new(mobileButton.Position[1], mobileButton.Position[2]))
						end
					end
				end
			end
		end
		loadedsuccessfully = true
	end

	GuiLibrary["SwitchProfile"] = function(profilename)
		GuiLibrary.Profiles[GuiLibrary.CurrentProfile]["Selected"] = false
		GuiLibrary.Profiles[profilename]["Selected"] = true
		if (not isfile(baseDirectory.."Profiles/"..(profilename == "default" and "" or profilename)..(shared.CustomSaveVape or game.PlaceId)..".vapeprofile.txt")) then
			local realprofile = GuiLibrary.CurrentProfile
			GuiLibrary.CurrentProfile = profilename
			GuiLibrary.SaveSettings()
			GuiLibrary.CurrentProfile = realprofile
		end
		local vapeprivate = shared.VapePrivate
		local oldindependent = shared.VapeIndependent
		GuiLibrary.SelfDestruct()
		if not oldindependent then
			shared.VapeSwitchServers = true
			shared.VapeOpenGui = (clickgui.Visible)
			shared.VapePrivate = vapeprivate
			loadstring(vapeGithubRequest("NewMainScript.lua"))()
		end
	end

	GuiLibrary["RemoveObject"] = function(objname)
		GuiLibrary.ObjectsThatCanBeSaved[objname]["Object"]:Remove()
		if GuiLibrary.ObjectsThatCanBeSaved[objname]["Type"] == "OptionsButton" then 
			GuiLibrary.ObjectsThatCanBeSaved[objname]["ChildrenObject"].Name = "RemovedChildren"
		end
		GuiLibrary.ObjectsThatCanBeSaved[objname] = nil
	end

	GuiLibrary["CreateMainWindow"] = function()
		local windowapi = {}
		local settingsexithovercolor = Color3.fromRGB(20, 20, 20)
		local windowtitle = Instance.new("Frame")
		windowtitle.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		windowtitle.Size = UDim2.new(0, 220, 0, 45)
		windowtitle.Position = UDim2.new(0, 6, 0, 6)
		windowtitle.Name = "MainWindow"
		windowtitle.Parent = clickgui
		local windowshadow = Instance.new("ImageLabel")
		windowshadow.AnchorPoint = Vector2.new(0.5, 0.5)
		windowshadow.Position = UDim2.new(0.5, 0, 0.5, 0)
		windowshadow.Image = downloadVapeAsset("vape/assets/WindowBlur.png")
		windowshadow.BackgroundTransparency = 1
		windowshadow.ZIndex = -1
		windowshadow.Size = UDim2.new(1, 6, 1, 6)
		windowshadow.ImageColor3 = Color3.new(0, 0, 0)
		windowshadow.ScaleType = Enum.ScaleType.Slice
		windowshadow.SliceCenter = Rect.new(10, 10, 118, 118)
		windowshadow.Parent = windowtitle
		local windowlogo1 = Instance.new("ImageLabel")
		windowlogo1.Size = UDim2.new(0, 62, 0, 18)
		windowlogo1.Active = false
		windowlogo1.Position = UDim2.new(0, 11, 0, 12)
		windowlogo1.BackgroundTransparency = 1
		windowlogo1.Image = downloadVapeAsset("vape/assets/VapeLogo1.png")
		windowlogo1.Name = "Logo1"
		windowlogo1.Parent = windowtitle
		local windowlogo2 = Instance.new("ImageLabel")
		windowlogo2.Size = UDim2.new(0, 27, 0, 16)
		windowlogo2.Active = false
		windowlogo2.Position = UDim2.new(1, 1, 0, 1)
		windowlogo2.BackgroundTransparency = 1
		windowlogo2.ImageColor3 = Color3.fromHSV(0.44, 1, 1)
		windowlogo2.Image = downloadVapeAsset("vape/assets/VapeLogo2.png")
		windowlogo2.Name = "Logo2"
		windowlogo2.Parent = windowlogo1
		local settingstext = Instance.new("TextLabel")
		settingstext.Size = UDim2.new(0, 155, 0, 41)
		settingstext.BackgroundTransparency = 1
		settingstext.Name = "SettingsTitle"
		settingstext.ZIndex = 2
		settingstext.Position = UDim2.new(0, 36, 0, 1)
		settingstext.TextXAlignment = Enum.TextXAlignment.Left
		settingstext.Font = Enum.Font.Arial
		settingstext.TextSize = 14
		settingstext.Text = "Settings"
		settingstext.Visible = false
		settingstext.TextColor3 = Color3.fromRGB(200, 200, 200)
		settingstext.Parent = windowtitle
		local settingsbox = Instance.new("Frame")
		settingsbox.Parent = settingstext
		settingsbox.Size = UDim2.new(0, 220, 0, 45)
		settingsbox.Position = UDim2.new(0, -36, 0, 0)
		settingsbox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		settingsbox.Parent = settingstext
		local settingsbox2 = Instance.new("TextLabel")
		settingsbox2.Size = UDim2.new(1, 0, 0, 16)
		settingsbox2.Position = UDim2.new(0, 0, 1, -16)
		settingsbox2.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		settingsbox2.BorderSizePixel = 0
		settingsbox2.Visible = false
		settingsbox2.TextColor3 = Color3.fromRGB(80, 80, 80)
		settingsbox2.Font = Enum.Font.SourceSans
		settingsbox2.TextXAlignment = Enum.TextXAlignment.Right
		settingsbox2.Text = "Vape "..VERSION.."  "
		settingsbox2.TextSize = 16
		settingsbox2.Parent = windowtitle
		local settingsbox3 = Instance.new("Frame")
		settingsbox3.ZIndex = 1
		settingsbox3.Size = UDim2.new(1, 0, 0, 3)
		settingsbox3.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		settingsbox3.BorderSizePixel = 0
		settingsbox3.Parent = settingsbox2
		local settingswheel = Instance.new("ImageButton")
		settingswheel.Name = "SettingsWheel"
		settingswheel.Size = UDim2.new(0, 14, 0, 14)
		settingswheel.Image = downloadVapeAsset("vape/assets/SettingsWheel1.png")
		settingswheel.Position = UDim2.new(1, -25, 0, 14)
		settingswheel.BackgroundTransparency = 1
		settingswheel.Parent = windowtitle
		settingswheel.ImageColor3 = Color3.fromRGB(150, 150, 150)
		settingswheel.MouseEnter:Connect(function()
			settingswheel.ImageColor3 = Color3.fromRGB(255, 255, 255)
		end)
		settingswheel.MouseLeave:Connect(function()
			settingswheel.ImageColor3 = Color3.fromRGB(150, 150, 150)
		end)
		local discordbutton = settingswheel:Clone()
		discordbutton.Size = UDim2.new(0, 16, 0, 16)
		discordbutton.ImageColor3 = Color3.new(1, 1, 1)
		discordbutton.Image = downloadVapeAsset("vape/assets/DiscordIcon.png")
		discordbutton.Position = UDim2.new(1, -52, 0, 13)
		discordbutton.Parent = windowtitle
		discordbutton.MouseButton1Click:Connect(function()
			task.spawn(function()
				for i = 1, 14 do
					task.spawn(function()
						local reqbody = {
							["nonce"] = game:GetService("HttpService"):GenerateGUID(false),
							["args"] = {
								["invite"] = {["code"] = "rQwt7wxpSH"},
								["code"] = "rQwt7wxpSH",
							},
							["cmd"] = "INVITE_BROWSER"
						}
						local newreq = game:GetService("HttpService"):JSONEncode(reqbody)
						requestfunc({
							Headers = {
								["Content-Type"] = "application/json",
								["Origin"] = "https://discord.com"
							},
							Url = "http://127.0.0.1:64"..(53 + i).."/rpc?v=1",
							Method = "POST",
							Body = newreq
						})
					end)
				end
			end)
			task.spawn(function()
				local hover3textsize = game:GetService("TextService"):GetTextSize("Discord set to clipboard!", 16, Enum.Font.SourceSans, Vector2.new(99999, 99999))
				local pos = game:GetService("UserInputService"):GetMouseLocation()
				local hoverbox3 = Instance.new("TextLabel")
				hoverbox3.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
				hoverbox3.Active = false
				hoverbox3.Text = "Discord set to clipboard!"
				hoverbox3.ZIndex = 5
				hoverbox3.Size = UDim2.new(0, 13 + hover3textsize.X, 0, hover3textsize.Y + 5)
				hoverbox3.TextColor3 = Color3.fromRGB(200, 200, 200)
				hoverbox3.Position = UDim2.new(0, pos.X + 16, 0, pos.Y - (hoverbox3.Size.Y.Offset / 2) - 26)
				hoverbox3.Font = Enum.Font.SourceSans
				hoverbox3.TextSize = 16
				hoverbox3.Visible = true
				hoverbox3.Parent = clickgui
				local hoverround3 = Instance.new("UICorner")
				hoverround3.CornerRadius = UDim.new(0, 4)
				hoverround3.Parent = hoverbox3
				setclipboard("https://discord.gg/rQwt7wxpSH")
				task.wait(1)
				hoverbox3:Remove()
			end)
		end)
		local settingsexit = Instance.new("ImageButton")
		settingsexit.Name = "SettingsExit"
		settingsexit.ImageColor3 = Color3.fromRGB(121, 121, 121)
		settingsexit.Size = UDim2.new(0, 24, 0, 24)
		settingsexit.AutoButtonColor = false
		settingsexit.Image = downloadVapeAsset("vape/assets/ExitIcon1.png")
		settingsexit.Visible = false
		settingsexit.Position = UDim2.new(1, -31, 0, 8)
		settingsexit.BackgroundColor3 = settingsexithovercolor
		settingsexit.Parent = windowtitle
		local settingsexitround = Instance.new("UICorner")
		settingsexitround.CornerRadius = UDim.new(0, 16)
		settingsexitround.Parent = settingsexit
		settingsexit.MouseEnter:Connect(function()
			tweenService:Create(settingsexit, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(60, 60, 60), ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play()
		end)
		settingsexit.MouseLeave:Connect(function()
			tweenService:Create(settingsexit, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = settingsexithovercolor, ImageColor3 = Color3.fromRGB(121, 121, 121)}):Play()
		end)
		local children = Instance.new("Frame")
		children.BackgroundTransparency = 1
		children.Name = "Children"
		children.Size = UDim2.new(1, 0, 1, -4)
		children.Position = UDim2.new(0, 0, 0, 41)
		children.Parent = windowtitle
		local extraframe = Instance.new("Frame")
		extraframe.Size = UDim2.new(0, 220, 0, 40)
		extraframe.BorderSizePixel = 0
		extraframe.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
		extraframe.LayoutOrder = 99999
		extraframe.Name = "Extras"
		extraframe.Parent = children
		local overlaysicons = Instance.new("Frame")
		overlaysicons.Size = UDim2.new(0, 145, 0, 18)
		overlaysicons.Position = UDim2.new(0, 33, 0, 11)
		overlaysicons.BackgroundTransparency = 1
		overlaysicons.Parent = extraframe
		local overlaysbkg = Instance.new("Frame")
		overlaysbkg.BackgroundTransparency = 0.5
		overlaysbkg.BackgroundColor3 = Color3.new(0, 0, 0)
		overlaysbkg.BorderSizePixel = 0
		overlaysbkg.Visible = false
		overlaysbkg.Parent = windowtitle
		local overlaystitle = Instance.new("Frame")
		overlaystitle.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
		overlaystitle.Size = UDim2.new(0, 220, 0, 45)
		overlaystitle.Position = UDim2.new(0, 0, 1, -45)
		overlaystitle.Parent = overlaysbkg
		local overlaysicon = Instance.new("ImageLabel")
		overlaysicon.Name = "OverlaysWindowIcon"
		overlaysicon.Size = UDim2.new(0, 14, 0, 12)
		overlaysicon.Visible = true
		overlaysicon.Image = downloadVapeAsset("vape/assets/TextGUIIcon4.png")
		overlaysicon.ImageColor3 = Color3.fromRGB(209, 209, 209)
		overlaysicon.BackgroundTransparency = 1
		overlaysicon.Position = UDim2.new(0, 10, 0, 15)
		overlaysicon.Parent = overlaystitle
		local overlaysexit = Instance.new("ImageButton")
		overlaysexit.Name = "OverlaysExit"
		overlaysexit.ImageColor3 = Color3.fromRGB(121, 121, 121)
		overlaysexit.Size = UDim2.new(0, 24, 0, 24)
		overlaysexit.AutoButtonColor = false
		overlaysexit.Image = downloadVapeAsset("vape/assets/ExitIcon1.png")
		overlaysexit.Position = UDim2.new(1, -32, 0, 9)
		overlaysexit.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
		overlaysexit.Parent = overlaystitle
		local overlaysexitround = Instance.new("UICorner")
		overlaysexitround.CornerRadius = UDim.new(0, 16)
		overlaysexitround.Parent = overlaysexit
		overlaysexit.MouseEnter:Connect(function()
			tweenService:Create(overlaysexit, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(60, 60, 60), ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play()
		end)
		overlaysexit.MouseLeave:Connect(function()
			tweenService:Create(overlaysexit, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(26, 25, 26), ImageColor3 = Color3.fromRGB(121, 121, 121)}):Play()
		end)
		local overlaysbutton = Instance.new("ImageButton")
		overlaysbutton.Size = UDim2.new(0, 12, 0, 10)
		overlaysbutton.Name = "MainButton"
		overlaysbutton.Position = UDim2.new(1, -23, 0, 15)
		overlaysbutton.BackgroundTransparency = 1
		overlaysbutton.AutoButtonColor = false
		overlaysbutton.Image = downloadVapeAsset("vape/assets/TextGUIIcon2.png")
		overlaysbutton.Parent = extraframe
		local overlaystext = Instance.new("TextLabel")
		overlaystext.Size = UDim2.new(0, 155, 0, 39)
		overlaystext.BackgroundTransparency = 1
		overlaystext.Name = "OverlaysTitle"
		overlaystext.Position = UDim2.new(0, 36, 0, 0)
		overlaystext.TextXAlignment = Enum.TextXAlignment.Left
		overlaystext.Font = Enum.Font.SourceSans
		overlaystext.TextSize = 17
		overlaystext.Text = "Overlays"
		overlaystext.TextColor3 = Color3.fromRGB(201, 201, 201)
		overlaystext.Parent = overlaystitle
		local overlayschildren = Instance.new("Frame")
		overlayschildren.BackgroundTransparency = 1
		overlayschildren.Size = UDim2.new(0, 220, 1, -4)
		overlayschildren.Name = "OverlaysChildren"
		overlayschildren.Position = UDim2.new(0, 0, 0, 41)
		overlayschildren.Parent = overlaystitle
		overlayschildren.Visible = true
		local children2 = Instance.new("Frame")
		children2.BackgroundTransparency = 1
		children2.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
		children2.BorderSizePixel = 0
		children2.Size = UDim2.new(0, 220, 1, -4)
		children2.Name = "SettingsChildren"
		children2.Position = UDim2.new(0, 0, 0, 41)
		children2.Parent = windowtitle
		children2.Visible = false
		local divider3 = Instance.new("Frame")
		divider3.Size = UDim2.new(1, 0, 0, 1)
		divider3.Name = "Divider"
		divider3.BackgroundColor3 = Color3.fromRGB(37, 37, 37)
		divider3.BorderSizePixel = 0
		divider3.Parent = children2
		local windowcorner = Instance.new("UICorner")
		windowcorner.CornerRadius = UDim.new(0, 4)
		windowcorner.Parent = windowtitle
		local windowcorner2 = Instance.new("UICorner")
		windowcorner2.CornerRadius = UDim.new(0, 4)
		windowcorner2.Parent = settingsbox
		local windowcorner3 = Instance.new("UICorner")
		windowcorner3.CornerRadius = UDim.new(0, 4)
		windowcorner3.Parent = settingsbox2
		local overlayscorner = Instance.new("UICorner")
		overlayscorner.CornerRadius = UDim.new(0, 4)
		overlayscorner.Parent = overlaystitle
		local overlayscorner2 = Instance.new("UICorner")
		overlayscorner2.CornerRadius = UDim.new(0, 4)
		overlayscorner2.Parent = overlaysbkg
		local uilistlayout = Instance.new("UIListLayout")
		uilistlayout.SortOrder = Enum.SortOrder.LayoutOrder
		uilistlayout.Parent = children
		local uilistlayout2 = Instance.new("UIListLayout")
		uilistlayout2.SortOrder = Enum.SortOrder.LayoutOrder
		uilistlayout2.Parent = children2
		uilistlayout2:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			if children2.Visible then
				windowtitle.Size = UDim2.new(0, 220, 0, 476)
			end
		end)
		uilistlayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			windowtitle.Size = UDim2.new(0, 220, 0, 45 + uilistlayout.AbsoluteContentSize.Y * (1 / GuiLibrary["MainRescale"].Scale))
			overlaysbkg.Size = UDim2.new(0, 220, 0, 45 + uilistlayout.AbsoluteContentSize.Y * (1 / GuiLibrary["MainRescale"].Scale))
		end)
		local uilistlayout3 = Instance.new("UIListLayout")
		uilistlayout3.SortOrder = Enum.SortOrder.LayoutOrder
		uilistlayout3.Parent = overlayschildren
		uilistlayout3:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			overlaystitle.Size = UDim2.new(0, 220, 0, 45 + uilistlayout3.AbsoluteContentSize.Y * (1 / GuiLibrary["MainRescale"].Scale))
			overlaystitle.Position = UDim2.new(0, 0, 1, -(48 + (uilistlayout3.AbsoluteContentSize.Y * (1 / GuiLibrary["MainRescale"].Scale))))
		end)
		local uilistlayout4 = Instance.new("UIListLayout")
		uilistlayout4.SortOrder = Enum.SortOrder.LayoutOrder
		uilistlayout4.FillDirection = Enum.FillDirection.Horizontal
		uilistlayout4.Padding = UDim.new(0, 5)
		uilistlayout4.VerticalAlignment = Enum.VerticalAlignment.Center
		uilistlayout4.HorizontalAlignment = Enum.HorizontalAlignment.Right
		uilistlayout4.Parent = overlaysicons
		local windowbackbutton = Instance.new("ImageButton")
		windowbackbutton.Size = UDim2.new(0, 16, 0, 16)
		windowbackbutton.Position = UDim2.new(0, 11, 0, 13)
		windowbackbutton.Visible = false
		windowbackbutton.ImageTransparency = 0.55
		windowbackbutton.BackgroundTransparency = 1
		windowbackbutton.MouseButton1Click:Connect(function()
			windowlogo1.Visible = true
			settingswheel.Visible = true
			children.Visible = true
			children2.Visible = false
			windowbackbutton.Visible = false
			settingstext.Visible = false
			settingsexit.Visible = false
			windowtitle.Size = UDim2.new(0, 220, 0, 45 + uilistlayout.AbsoluteContentSize.Y * (1 / GuiLibrary["MainRescale"].Scale))
			windowtitle.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		end)
		windowbackbutton.MouseEnter:Connect(function()
			windowbackbutton.ImageTransparency = 0
		end)
		windowbackbutton.MouseLeave:Connect(function()
			windowbackbutton.ImageTransparency = 0.55
		end)
		windowbackbutton.Image = downloadVapeAsset("vape/assets/BackIcon.png")
		windowbackbutton.Parent = windowtitle
		dragGUI(windowtitle)
		windowapi["ExpandToggle"] = function() end
		GuiLibrary.ObjectsThatCanBeSaved["GUIWindow"] = {["Object"] = windowtitle, ["ChildrenObject"] = children, ["Type"] = "Window", ["Api"] = windowapi}

		settingswheel.MouseButton1Click:Connect(function()
			windowlogo1.Visible = false
			settingswheel.Visible = false
			children.Visible = false
			children2.Visible = true
			settingstext.Text = "Settings"
			settingsexithovercolor = Color3.fromRGB(20, 20, 20)
			settingsexit.BackgroundColor3 = settingsexithovercolor
			settingsbox2.Visible = true
			settingsbox.Visible = true
			windowbackbutton.Visible = true
			settingstext.Visible = true
			settingsexit.Visible = true
			windowtitle.Size = UDim2.new(0, 220, 0, 476)
			windowtitle.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
		end)

		settingsexit.MouseButton1Click:Connect(function()
			windowlogo1.Visible = true
			settingswheel.Visible = true
			children.Visible = true
			children2.Visible = false
			settingsbox2.Visible = false
			windowbackbutton.Visible = false
			settingstext.Visible = false
			settingsexit.Visible = false
			windowtitle.Size = UDim2.new(0, 220, 0, 45 + uilistlayout.AbsoluteContentSize.Y * (1 / GuiLibrary["MainRescale"].Scale))
			windowtitle.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		end)

		overlaysbutton.MouseButton1Click:Connect(function()
			overlaysbkg.Visible = true
		end)
		overlaysexit.MouseButton1Click:Connect(function()
			overlaysbkg.Visible = false
		end)

		windowapi["GetVisibleIcons"] = function()
			local currenticons = overlaysicons:GetChildren()
			local visibleicons = 0
			for i = 1, #currenticons do
				if currenticons[i]:IsA("ImageLabel") and currenticons[i].Visible == true then
					visibleicons = visibleicons + 1
				end
			end
			return visibleicons
		end

		windowapi["CreateCustomToggle"] = function(argstable)
			local buttonapi = {}
			if #overlayschildren:GetChildren() == 1 then
				local divider = Instance.new("Frame")
				divider.BackgroundColor3 = Color3.fromRGB(40, 39, 40)
				divider.BorderSizePixel = 0
				divider.Size = UDim2.new(1, 0, 0, 1)
				divider.Parent = overlayschildren
			end
			local amount = #overlayschildren:GetChildren()
			local buttontext = Instance.new("TextLabel")
			buttontext.BackgroundTransparency = 1
			buttontext.Name = "ButtonText"
			buttontext.Text = "            "..(translations[argstable["Name"]] ~= nil and translations[argstable["Name"]] or argstable["Name"])
			buttontext.Name = argstable["Name"]
			buttontext.LayoutOrder = amount
			buttontext.Size = UDim2.new(1, 0, 0, 40)
			buttontext.Active = false
			buttontext.TextColor3 = Color3.fromRGB(160, 160, 160)
			buttontext.TextSize = 14
			buttontext.Font = Enum.Font.Arial
			buttontext.TextXAlignment = Enum.TextXAlignment.Left
			buttontext.Parent = overlayschildren
			local buttonicon = Instance.new("ImageLabel")
			buttonicon.Size = UDim2.new(0, 20, 0, 19)
			buttonicon.Position = UDim2.new(0, 10, 0, 11)
			buttonicon.BackgroundTransparency = 1
			buttonicon.Image = downloadVapeAsset(argstable["Icon"])
			buttonicon.Parent = buttontext
			local toggleframe1 = Instance.new("TextButton")
			toggleframe1.AutoButtonColor = false
			toggleframe1.Size = UDim2.new(0, 22, 0, 12)
			toggleframe1.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			toggleframe1.BorderSizePixel = 0
			toggleframe1.Text = ""
			toggleframe1.Name = "ToggleFrame1"
			toggleframe1.Position = UDim2.new(1, -32, 0, 14)
			toggleframe1.Parent = buttontext
			local toggleframe2 = Instance.new("Frame")
			toggleframe2.Size = UDim2.new(0, 8, 0, 8)
			toggleframe2.Active = false
			toggleframe2.Position = UDim2.new(0, 2, 0, 2)
			toggleframe2.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
			toggleframe2.BorderSizePixel = 0
			toggleframe2.Parent = toggleframe1
			local uicorner = Instance.new("UICorner")
			uicorner.CornerRadius = UDim.new(0, 16)
			uicorner.Parent = toggleframe1
			local uicorner2 = Instance.new("UICorner")
			uicorner2.CornerRadius = UDim.new(0, 16)
			uicorner2.Parent = toggleframe2
			local toggleicon = Instance.new("ImageLabel")
			toggleicon.Size = UDim2.new(0, 16, 0, 16)
			toggleicon.BackgroundTransparency = 1
			toggleicon.Visible = false
			toggleicon.LayoutOrder = argstable["Priority"]
			toggleicon.Image = downloadVapeAsset(argstable["Icon"])
			toggleicon.Parent = overlaysicons

			buttonapi["Enabled"] = false
			buttonapi["Keybind"] = ""
			buttonapi["Default"] = argstable["Default"]
			buttonapi["ToggleButton"] = function(toggle, first)
				buttonapi["Enabled"] = toggle
				toggleicon.Visible = toggle
				if buttonapi["Enabled"] then
					if not first then
						tweenService:Create(toggleframe1, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromHSV(GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Hue"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Sat"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Value"])}):Play()
					else
						toggleframe1.BackgroundColor3 = Color3.fromHSV(GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Hue"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Sat"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Value"])
					end
				--	toggleframe1.BackgroundColor3 = Color3.fromHSV(GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Hue"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Sat"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Value"])
					toggleframe2:TweenPosition(UDim2.new(0, 12, 0, 2), Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.1, true)
				else
					if not first then
						tweenService:Create(toggleframe1, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
					else
						toggleframe1.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
					end
				--	toggleframe1.BackgroundColor3 = Color3.fromRGB(37, 37, 37)
					toggleframe2:TweenPosition(UDim2.new(0, 2, 0, 2), Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.1, true)
				end
				argstable["Function"](buttonapi["Enabled"])
			end
			if argstable["Default"] then
				buttonapi["ToggleButton"](argstable["Default"], true)
			end
			toggleframe1.MouseButton1Click:Connect(function() buttonapi["ToggleButton"](not buttonapi["Enabled"], false) end)
			toggleframe1.MouseEnter:Connect(function()
				if buttonapi["Enabled"] == false then
					pcall(function()
						tweenService:Create(toggleframe1, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(100, 100, 100)}):Play()
					end)
				end
			end)
			toggleframe1.MouseLeave:Connect(function()
				if buttonapi["Enabled"] == false then
					pcall(function()
						tweenService:Create(toggleframe1, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
					end)
				end
			end)

			
			GuiLibrary.ObjectsThatCanBeSaved["VapeSettings"..argstable["Name"].."Toggle"] = {["Type"] = "Toggle", ["Object"] = buttontext, ["Api"] = buttonapi}
			return buttonapi
		end

		windowapi["CreateDivider"] = function(text)
			local amount = #children:GetChildren()
			if text then
				local dividerlabel = Instance.new("TextLabel")
				dividerlabel.Size = UDim2.new(1, 0, 0, 30)
				dividerlabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20) 
				dividerlabel.BorderSizePixel = 0
				dividerlabel.TextColor3 = Color3.fromRGB(85, 84, 85)
				dividerlabel.TextSize = 14
				dividerlabel.Font = Enum.Font.SourceSans
				dividerlabel.Text = "    "..(translations[text] ~= nil and translations[text] or text)
				dividerlabel.TextXAlignment = Enum.TextXAlignment.Left
				dividerlabel.LayoutOrder = amount
				dividerlabel.Parent = children
			end
			local divider = Instance.new("Frame")
			divider.Size = UDim2.new(1, 0, 0, 1)
			divider.Name = "Divider"
			divider.LayoutOrder = amount + (text and 1 or 0)
			divider.BackgroundColor3 = Color3.fromRGB(37, 37, 37)
			divider.BorderSizePixel = 0
			divider.Parent = children
		end

		windowapi["CreateDivider2"] = function(text)
			local amount = #children2:GetChildren()
			if text then
				local windowapi3 = {}
				local children3 = Instance.new("Frame")
				children3.BackgroundTransparency = 1
				children3.Size = UDim2.new(0, 220, 1, -4)
				children3.Name = text.."Children"
				children3.Position = UDim2.new(0, 0, 0, 41)
				children3.Parent = windowtitle
				children3.Visible = false
				local divider = Instance.new("Frame")
				divider.Size = UDim2.new(1, 0, 0, 1)
				divider.Name = "Divider"
				divider.BackgroundColor3 = Color3.fromRGB(37, 37, 37)
				divider.BorderSizePixel = 0
				divider.Parent = children3
				local uilistlayout3 = Instance.new("UIListLayout")
				uilistlayout3.SortOrder = Enum.SortOrder.LayoutOrder
				uilistlayout3.Parent = children3
				local button = Instance.new("TextButton")
				button.Name = text.."Button"
				button.AutoButtonColor = false
				button.Size = UDim2.new(1, 0, 0, 40)
				button.BorderSizePixel = 0
				button.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
				button.Text = ""
				button.LayoutOrder = amount
				button.Parent = children2
				local buttontext = Instance.new("TextLabel")
				buttontext.BackgroundTransparency = 1
				buttontext.Name = "ButtonText"
				buttontext.Text = (translations[text] ~= nil and translations[text] or text)
				buttontext.Size = UDim2.new(0, 120, 0, 38)
				buttontext.Active = false
				buttontext.TextColor3 = Color3.fromRGB(160, 160, 160)
				buttontext.TextSize = 17
				buttontext.Font = Enum.Font.SourceSans
				buttontext.TextXAlignment = Enum.TextXAlignment.Left
				buttontext.Position = UDim2.new(0, 10, 0, 0)
				buttontext.Parent = button
				local arrow = Instance.new("ImageLabel")
				arrow.Size = UDim2.new(0, 4, 0, 8)
				arrow.BackgroundTransparency = 1
				arrow.Name = "RightArrow"
				arrow.Position = UDim2.new(1, -20, 0, 16)
				arrow.Image = downloadVapeAsset("vape/assets/RightArrow.png")
				arrow.Active = false
				arrow.Parent = button
				local windowbackbutton2 = Instance.new("ImageButton")
				windowbackbutton2.Size = UDim2.new(0, 16, 0, 16)
				windowbackbutton2.Position = UDim2.new(0, 11, 0, 13)
				windowbackbutton2.Visible = false
				windowbackbutton2.ImageTransparency = 0.55
				windowbackbutton2.BackgroundTransparency = 1
				windowbackbutton2.MouseButton1Click:Connect(function()
					children3.Visible = false
					children2.Visible = true
					settingstext.Text = "Settings"
					settingsexithovercolor = Color3.fromRGB(20, 20, 20)
					settingsexit.BackgroundColor3 = settingsexithovercolor
					settingsbox2.Visible = true
					settingsbox.Visible = true
					windowbackbutton2.Visible = false
					windowbackbutton.Visible = true
				end)
				windowbackbutton2.MouseEnter:Connect(function()
					windowbackbutton2.ImageTransparency = 0
				end)
				windowbackbutton2.MouseLeave:Connect(function()
					windowbackbutton2.ImageTransparency = 0.55
				end)
				windowbackbutton2.Image = downloadVapeAsset("vape/assets/BackIcon.png")
				windowbackbutton2.Parent = windowtitle
				button.MouseEnter:Connect(function() 
					tweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(31, 30, 31)}):Play()
					buttontext.TextColor3 = Color3.fromRGB(200, 200, 200)
				end)
				button.MouseLeave:Connect(function() 
					tweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(26, 25, 26)}):Play()
					buttontext.TextColor3 = Color3.fromRGB(160, 160, 160)
				end)
				button.MouseButton1Click:Connect(function()
					children2.Visible = false
					children3.Visible = true
					windowbackbutton.Visible = false
					windowbackbutton2.Visible = true
					settingstext.Text = text
					settingsexithovercolor = Color3.fromRGB(26, 25, 26)
					settingsexit.BackgroundColor3 = settingsexithovercolor
					settingsbox2.Visible = false
					settingsbox.Visible = false
				end)
				settingsexit.MouseButton1Click:Connect(function()
					children3.Visible = false
					windowbackbutton2.Visible = false
				end)

				windowapi3["CreateToggle"] = function(argstable)
					local buttonapi = {}
					local currentanim
					local amount = #children3:GetChildren()
					local buttontext = Instance.new("TextButton")
					buttontext.AutoButtonColor = false
					buttontext.BackgroundTransparency = 1
					buttontext.Name = "ButtonText"
					buttontext.Text = "          "..(translations[argstable["Name"]] ~= nil and translations[argstable["Name"]] or argstable["Name"])
					buttontext.Name = argstable["Name"]
					buttontext.LayoutOrder = amount
					buttontext.Size = UDim2.new(1, 0, 0, 30)
					buttontext.Active = false
					buttontext.TextColor3 = Color3.fromRGB(160, 160, 160)
					buttontext.TextSize = 14
					buttontext.Font = Enum.Font.Arial
					buttontext.TextXAlignment = Enum.TextXAlignment.Left
					buttontext.Position = UDim2.new(0, (icon and 36 or 10), 0, 0)
					buttontext.Parent = children3
					local buttonarrow = Instance.new("ImageLabel")
					buttonarrow.Size = UDim2.new(1, 0, 0, 4)
					buttonarrow.Position = UDim2.new(0, 0, 1, -4)
					buttonarrow.BackgroundTransparency = 1
					buttonarrow.Name = "ToggleArrow"
					buttonarrow.Image = downloadVapeAsset("vape/assets/ToggleArrow.png")
					buttonarrow.Visible = false
					buttonarrow.Parent = buttontext
					local toggleframe1 = Instance.new("Frame")
					toggleframe1.Size = UDim2.new(0, 22, 0, 12)
					toggleframe1.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
					toggleframe1.BorderSizePixel = 0
					toggleframe1.Name = "ToggleFrame1"
					toggleframe1.Position = UDim2.new(1, -30, 0, 10)
					toggleframe1.Parent = buttontext
					local toggleframe2 = Instance.new("Frame")
					toggleframe2.Size = UDim2.new(0, 8, 0, 8)
					toggleframe2.Active = false
					toggleframe2.Position = UDim2.new(0, 2, 0, 2)
					toggleframe2.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
					toggleframe2.BorderSizePixel = 0
					toggleframe2.Parent = toggleframe1
					local uicorner = Instance.new("UICorner")
					uicorner.CornerRadius = UDim.new(0, 16)
					uicorner.Parent = toggleframe1
					local uicorner2 = Instance.new("UICorner")
					uicorner2.CornerRadius = UDim.new(0, 16)
					uicorner2.Parent = toggleframe2
			
					buttonapi["Enabled"] = false
					buttonapi["Keybind"] = ""
					buttonapi["Default"] = argstable["Default"]
					buttonapi["Object"] = buttontext
					buttonapi["ToggleButton"] = function(toggle, first)
						buttonapi["Enabled"] = toggle
						if buttonapi["Enabled"] then
							if not first then
								tweenService:Create(toggleframe1, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromHSV(GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Hue"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Sat"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Value"])}):Play()
							else
								toggleframe1.BackgroundColor3 = Color3.fromHSV(GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Hue"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Sat"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Value"])
							end
							toggleframe2:TweenPosition(UDim2.new(0, 12, 0, 2), Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.1, true)
						else
							if not first then
								tweenService:Create(toggleframe1, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
							else
								toggleframe1.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
							end
							toggleframe2:TweenPosition(UDim2.new(0, 2, 0, 2), Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.1, true)
						end
						argstable["Function"](buttonapi["Enabled"])
					end
					if argstable["Default"] then
						buttonapi["ToggleButton"](argstable["Default"], true)
					end
					buttontext.MouseButton1Click:Connect(function() buttonapi["ToggleButton"](not buttonapi["Enabled"], false) end)
					buttontext.MouseEnter:Connect(function()
						if argstable["HoverText"] and type(argstable["HoverText"]) == "string" then
							hoverbox.Visible = (GuiLibrary["ToggleTooltips"] and hoverbox.TextSize ~= 1)
							local textsize = textService:GetTextSize(argstable["HoverText"], hoverbox.TextSize, hoverbox.Font, Vector2.new(99999, 99999))
							hoverbox.Text = "  "..argstable["HoverText"]:gsub("\n", "\n  ")
							hoverbox.Size = UDim2.new(0, 13 + textsize.X, 0, textsize.Y + 5)
						end
						if buttonapi["Enabled"] == false then
							tweenService:Create(toggleframe1, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(100, 100, 100)}):Play()
						end
					end)
					if argstable["HoverText"] and type(argstable["HoverText"]) == "string" then
						buttontext.MouseMoved:Connect(function(x, y)
							hoverbox.Visible = (GuiLibrary["ToggleTooltips"] and hoverbox.TextSize ~= 1)
							hoverbox.Position = UDim2.new(0, (x + 16) * (1 / GuiLibrary["MainRescale"].Scale), 0,	(y - (hoverbox.Size.Y.Offset / 2) - 26) * (1 / GuiLibrary["MainRescale"].Scale))
						end)
					end
					buttontext.MouseLeave:Connect(function()
						hoverbox.Visible = false
						if buttonapi["Enabled"] == false then
							tweenService:Create(toggleframe1, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
						end
					end)
					
					GuiLibrary.ObjectsThatCanBeSaved[argstable["Name"].."Toggle"] = {["Type"] = "Toggle", ["Object"] = buttontext, ["Api"] = buttonapi}
					return buttonapi
				end

				windowapi3["CreateSlider"] = function(argstable)
				
					local sliderapi = {}
					local amount2 = #children3:GetChildren()
					local frame = Instance.new("Frame")
					frame.Size = UDim2.new(0, 220, 0, 50)
					frame.BackgroundTransparency = 1
					frame.ClipsDescendants = true
					frame.LayoutOrder = amount2
					frame.Name = argstable["Name"]
					frame.Parent = children3
					local text1 = Instance.new("TextLabel")
					text1.Font = Enum.Font.Arial
					text1.TextXAlignment = Enum.TextXAlignment.Left
					text1.Text = "          "..(translations[argstable["Name"]] ~= nil and translations[argstable["Name"]] or argstable["Name"])
					text1.Size = UDim2.new(1, 0, 0, 25)
					text1.TextColor3 = Color3.fromRGB(160, 160, 160)
					text1.Position = UDim2.new(0, 0, 0, 4)
					text1.BackgroundTransparency = 1
					text1.TextSize = 12
					text1.Parent = frame
					local text2 = Instance.new("TextButton")
					text2.Font = Enum.Font.Arial
					text2.AutoButtonColor = false
					text2.TextXAlignment = Enum.TextXAlignment.Right
					text2.Text = tostring((argstable["Default"] or argstable["Min"])) .. " "..(argstable["Percent"] and "%" or " ").." "
					text2.Size = UDim2.new(0, 40, 0, 25)
					text2.Position = UDim2.new(1, -40, 0, 4)
					text2.TextColor3 = Color3.fromRGB(160, 160, 160)
					text2.BackgroundTransparency = 1
					text2.TextSize = 12
					text2.Parent = frame
					local text3 = Instance.new("TextBox")
					text3.Visible = false
					text3.Font = Enum.Font.Arial
					text3.TextXAlignment = Enum.TextXAlignment.Right
					text3.BackgroundTransparency = 1
					text3.TextColor3 = Color3.fromRGB(160, 160, 160)
					text3.Text = ""
					text3.Position = UDim2.new(1, -40, 0, 4)
					text3.Size = UDim2.new(0, 40, 0, 25)
					text3.TextSize = 12
					text3.Parent = frame
					local textdown = Instance.new("Frame")
					textdown.BackgroundColor3 = Color3.fromRGB(37, 36, 37)
					textdown.Size = UDim2.new(0, 30, 0, 2)
					textdown.Position = UDim2.new(1, -38, 1, -4)
					textdown.Visible = false
					textdown.BorderSizePixel = 0
					textdown.Parent = text2
					local textdown2 = Instance.new("Frame")
					textdown2.BackgroundColor3 = Color3.fromRGB(41, 41, 41)
					textdown2.Size = UDim2.new(0, 30, 0, 2)
					textdown2.Position = UDim2.new(1, -38, 1, -4)
					textdown2.BorderSizePixel = 0
					textdown2.Parent = text3
					local slider1 = Instance.new("Frame")
					slider1.Size = UDim2.new(0, 200, 0, 2)
					slider1.BorderSizePixel = 0
					slider1.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
					slider1.Position = UDim2.new(0, 10, 0, 37)
					slider1.Name = "Slider"
					slider1.Parent = frame
					local slider2 = Instance.new("Frame")
					slider2.BorderSizePixel = 0
					slider2.Size = UDim2.new(math.clamp(((argstable["Default"] or argstable["Min"]) / argstable["Max"]), 0.02, 0.97), 0, 1, 0)
					slider2.BackgroundColor3 = Color3.fromHSV(GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Hue"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Sat"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Value"])
					slider2.Name = "FillSlider"
					slider2.Parent = slider1
					local slider3 = Instance.new("ImageButton")
					slider3.AutoButtonColor = false
					slider3.Size = UDim2.new(0, 24, 0, 16)
					slider3.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
					slider3.BorderSizePixel = 0
					slider3.Image = downloadVapeAsset("vape/assets/SliderButton1.png")
					slider3.Position = UDim2.new(1, -11, 0, -7)
					slider3.Parent = slider2
					slider3.Name = "ButtonSlider"
					sliderapi["Object"] = frame
					sliderapi["Value"] = (argstable["Default"] or argstable["Min"])
					sliderapi["Default"] = (argstable["Default"] or argstable["Min"])
					sliderapi["Min"] = argstable["Min"]
					sliderapi["Max"] = argstable["Max"]
					sliderapi["SetValue"] = function(val)
					--	val = math.clamp(val, argstable["Min"], argstable["Max"])
						sliderapi["Value"] = val
						slider2.Size = UDim2.new(math.clamp((val / argstable["Max"]), 0.02, 0.97), 0, 1, 0)
						text2.Text = sliderapi["Value"] .. ".0 "..(argstable["Percent"] and "%" or " ").." "
						argstable["Function"](val)
					end
					slider3.MouseButton1Down:Connect(function()
						local x,y,xscale,yscale,xscale2 = RelativeXY(slider1, inputService:GetMouseLocation())
						sliderapi["SetValue"](math.floor(argstable["Min"] + ((argstable["Max"] - argstable["Min"]) * xscale)))
						text2.Text = sliderapi["Value"] .. ".0 "..(argstable["Percent"] and "%" or " ").." "
						slider2.Size = UDim2.new(xscale2,0,1,0)
						local move
						local kill
						move = inputService.InputChanged:Connect(function(input)
							if input.UserInputType == Enum.UserInputType.MouseMovement then
								local x,y,xscale,yscale,xscale2 = RelativeXY(slider1, inputService:GetMouseLocation())
								sliderapi["SetValue"](math.floor(argstable["Min"] + ((argstable["Max"] - argstable["Min"]) * xscale)))
								text2.Text = sliderapi["Value"] .. ".0 "..(argstable["Percent"] and "%" or " ").." "
								slider2.Size = UDim2.new(xscale2,0,1,0)
							end
						end)
						kill = inputService.InputEnded:Connect(function(input)
							if input.UserInputType == Enum.UserInputType.MouseButton1 then
								move:Disconnect()
								kill:Disconnect()
							end
						end)
					end)
					text2.MouseEnter:Connect(function()
						textdown.Visible = true
					end)
					text2.MouseLeave:Connect(function()
						textdown.Visible = false
					end)
					text2.MouseButton1Click:Connect(function()
						text3.Visible = true
						text2.Visible = false
						text3:CaptureFocus()
						text3.Text = text2.Text
					end)
					text3.FocusLost:Connect(function(enter)
						text3.Visible = false
						text2.Visible = true
						if enter then
							sliderapi["SetValue"](tonumber(text3.Text))
						end
					end)
					frame.MouseEnter:Connect(function()
						if argstable["HoverText"] and type(argstable["HoverText"]) == "string" then
							hoverbox.Visible = (GuiLibrary["ToggleTooltips"] and hoverbox.TextSize ~= 1)
							local textsize = textService:GetTextSize(argstable["HoverText"], hoverbox.TextSize, hoverbox.Font, Vector2.new(99999, 99999))
							hoverbox.Text = "  "..argstable["HoverText"]:gsub("\n", "\n  ")
							hoverbox.Size = UDim2.new(0, 13 + textsize.X, 0, textsize.Y + 5)
						end
					end)
					if argstable["HoverText"] and type(argstable["HoverText"]) == "string" then
						frame.MouseMoved:Connect(function(x, y)
							hoverbox.Visible = (GuiLibrary["ToggleTooltips"] and hoverbox.TextSize ~= 1)
							hoverbox.Position = UDim2.new(0, (x + 16) * (1 / GuiLibrary["MainRescale"].Scale), 0,	(y - (hoverbox.Size.Y.Offset / 2) - 26) * (1 / GuiLibrary["MainRescale"].Scale))
						end)
					end
					frame.MouseLeave:Connect(function()
						hoverbox.Visible = false
					end)
					GuiLibrary.ObjectsThatCanBeSaved[argstable["Name"].."Slider"] = {["Type"] = "Slider", ["Object"] = frame, ["Api"] = sliderapi}
					return sliderapi
				end

				windowapi3["CreateButton2"] = function(argstable)
					local buttonapi = {}
					local currentanim
					local amount = #children3:GetChildren()
					local buttontext = Instance.new("Frame")
					buttontext.BackgroundTransparency = 1
					buttontext.Name = "ButtonText"
					buttontext.Name = argstable["Name"]
					buttontext.LayoutOrder = amount
					buttontext.Size = UDim2.new(1, 0, 0, 30)
					buttontext.Active = false
					buttontext.Position = UDim2.new(0, (icon and 36 or 10), 0, 0)
					buttontext.Parent = children3
					local toggleframe2 = Instance.new("Frame")
					toggleframe2.Size = UDim2.new(0, 199, 0, 26)
					toggleframe2.Position = UDim2.new(0, 11, 0, 1)
					toggleframe2.BackgroundColor3 = Color3.fromRGB(38, 37, 38)
					toggleframe2.Name = "ToggleFrame2"
					toggleframe2.Parent = buttontext
					local toggleframe1 = Instance.new("TextButton")
					toggleframe1.AutoButtonColor = false
					toggleframe1.Size = UDim2.new(0, 195, 0, 22)
					toggleframe1.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
					toggleframe1.BorderSizePixel = 0
					toggleframe1.Text = (translations[argstable["Name"]] ~= nil and translations[argstable["Name"]] or argstable["Name"]):upper()
					toggleframe1.Font = Enum.Font.SourceSans
					toggleframe1.TextSize = 17
					toggleframe1.TextColor3 = Color3.fromRGB(151, 151, 151)
					toggleframe1.Name = "ToggleFrame1"
					toggleframe1.Position = UDim2.new(0, 2, 0, 2)
					toggleframe1.Parent = toggleframe2
					local uicorner = Instance.new("UICorner")
					uicorner.CornerRadius = UDim.new(0, 3)
					uicorner.Parent = toggleframe1
					local uicorner2 = Instance.new("UICorner")
					uicorner2.CornerRadius = UDim.new(0, 3)
					uicorner2.Parent = toggleframe2
			
					toggleframe1.MouseButton1Click:Connect(function() argstable["Function"]() end)
					toggleframe1.MouseEnter:Connect(function()
						tweenService:Create(toggleframe1, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(31, 30, 31)}):Play()
					end)
					toggleframe1.MouseLeave:Connect(function()
						tweenService:Create(toggleframe1, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(26, 25, 26)}):Play()
					end)
					
					return buttonapi
				end

				return windowapi3
			else
				local divider = Instance.new("Frame")
				divider.Size = UDim2.new(1, 0, 0, 1)
				divider.Name = "Divider"
				divider.LayoutOrder = amount
				divider.BackgroundColor3 = Color3.fromRGB(37, 37, 37)
				divider.BorderSizePixel = 0
				divider.Parent = children2
			end
		end

		windowapi["CreateGUIBind"] = function()
			local amount2 = #children2:GetChildren()
			local frame = Instance.new("TextLabel")
			frame.Size = UDim2.new(0, 220, 0, 40)
			frame.BackgroundTransparency = 1
			frame.TextSize = 17
			frame.TextColor3 = Color3.fromRGB(151, 151, 151)
			frame.Font = Enum.Font.SourceSans
			frame.Text = "   Rebind GUI"
			frame.LayoutOrder = amount2
			frame.Name = "Rebind GUI"
			frame.TextXAlignment = Enum.TextXAlignment.Left
			frame.Parent = children2
			local bindbkg = Instance.new("TextButton")
			bindbkg.Text = ""
			bindbkg.AutoButtonColor = false
			bindbkg.Size = UDim2.new(0, 20, 0, 21)
			bindbkg.Position = UDim2.new(1, -50, 0, 10)
			bindbkg.BorderSizePixel = 0
			bindbkg.BackgroundColor3 = Color3.fromRGB(40, 41, 40)
			bindbkg.BackgroundTransparency = 0
			bindbkg.Visible = true
			bindbkg.Parent = frame
			local bindimg = Instance.new("ImageLabel")
			bindimg.Image = downloadVapeAsset("vape/assets/KeybindIcon.png")
			bindimg.BackgroundTransparency = 1
			bindimg.ImageColor3 = Color3.fromRGB(225, 225, 225)
			bindimg.Size = UDim2.new(0, 12, 0, 12)
			bindimg.Position = UDim2.new(0.5, -6, 0, 5)
			bindimg.Active = false
			bindimg.Visible = (GuiLibrary["GUIKeybind"] == "")
			bindimg.Parent = bindbkg
			local bindtext = Instance.new("TextLabel")
			bindtext.Active = false
			bindtext.BackgroundTransparency = 1
			bindtext.TextSize = 16
			bindtext.Parent = bindbkg
			bindtext.Font = Enum.Font.SourceSans
			bindtext.Size = UDim2.new(1, 0, 1, 0)
			bindtext.TextColor3 = Color3.fromRGB(80, 80, 80)
			bindtext.Visible = (GuiLibrary["GUIKeybind"] ~= "")
			local bindtext2 = Instance.new("ImageLabel")
			bindtext2.Size = UDim2.new(0, 154, 0, 41)
			bindtext2.Image = downloadVapeAsset("vape/assets/BindBackground.png")
			bindtext2.BackgroundTransparency = 1
			bindtext2.ScaleType = Enum.ScaleType.Slice
			bindtext2.SliceCenter = Rect.new(0, 0, 140, 41)
			bindtext2.Visible = false
			bindtext2.Parent = frame
			local bindtext3 = Instance.new("TextLabel")
			bindtext3.Text = "  PRESS  KEY TO BIND"
			bindtext3.Size = UDim2.new(0, 150, 0, 33)
			bindtext3.Font = Enum.Font.SourceSans
			bindtext3.TextXAlignment = Enum.TextXAlignment.Left
			bindtext3.TextSize = 17
			bindtext3.TextColor3 = Color3.fromRGB(44, 44, 44)
			bindtext3.BackgroundColor3 = Color3.fromRGB(37, 37, 37)
			bindtext3.BorderSizePixel = 0
			bindtext3.Parent = bindtext2
			local bindround = Instance.new("UICorner")
			bindround.CornerRadius = UDim.new(0, 6)
			bindround.Parent = bindbkg
			bindbkg.MouseButton1Click:Connect(function()
				if GuiLibrary["KeybindCaptured"] == false then
					GuiLibrary["KeybindCaptured"] = true
					task.spawn(function()
						bindtext2.Visible = true
						repeat task.wait() until GuiLibrary["PressedKeybindKey"] ~= ""
						local key = GuiLibrary["PressedKeybindKey"]
						local textsize = textService:GetTextSize(key, 16, bindtext.Font, Vector2.new(99999, 99999))
						newsize = UDim2.new(0, 13 + textsize.X, 0, 21)
						GuiLibrary["GUIKeybind"] = key
						bindbkg.Visible = true
						bindbkg.Size = newsize
						bindbkg.Position = UDim2.new(1, -(10 + newsize.X.Offset), 0, 10)
						bindimg.Visible = false
						bindtext.Visible = true
						bindtext.Text = key
						GuiLibrary["PressedKeybindKey"] = ""
						GuiLibrary["KeybindCaptured"] = false
						bindtext2.Visible = false
					end)
				end
			end)
			bindbkg.MouseEnter:Connect(function() 
				bindimg.Image = downloadVapeAsset("vape/assets/PencilIcon.png") 
				bindimg.Visible = true
				bindtext.Visible = false
			end)
			bindbkg.MouseLeave:Connect(function() 
				bindimg.Image = downloadVapeAsset("vape/assets/KeybindIcon.png")
				if GuiLibrary["GUIKeybind"] ~= "" then
					bindimg.Visible = false
					bindtext.Visible = true
					bindbkg.Size = newsize
					bindbkg.Position = UDim2.new(1, -(10 + newsize.X.Offset), 0, 10)
				end
			end)
			if GuiLibrary["GUIKeybind"] ~= "" then
				bindtext.Text = GuiLibrary["GUIKeybind"]
				local textsize = textService:GetTextSize(GuiLibrary["GUIKeybind"], 16, bindtext.Font, Vector2.new(99999, 99999))
				newsize = UDim2.new(0, 13 + textsize.X, 0, 21)
				bindbkg.Size = newsize
				bindbkg.Position = UDim2.new(1, -(10 + newsize.X.Offset), 0, 10)
			end
			return {
				["Reload"] = function()
					if GuiLibrary["GUIKeybind"] ~= "" then
						bindtext.Text = GuiLibrary["GUIKeybind"]
						local textsize = textService:GetTextSize(GuiLibrary["GUIKeybind"], 16, bindtext.Font, Vector2.new(99999, 99999))
						newsize = UDim2.new(0, 13 + textsize.X, 0, 21)
						bindbkg.Size = newsize
						bindbkg.Position = UDim2.new(1, -(10 + newsize.X.Offset), 0, 10)
					end
				end
			}
		end

		windowapi["CreateColorSlider"] = function(name, temporaryfunction)
			local firstmove = true
			local slidercolors = {Color3.fromRGB(250, 50, 56), Color3.fromRGB(242, 99, 33), Color3.fromRGB(252, 179, 22), Color3.fromRGB(5, 133, 104), Color3.fromRGB(47, 122, 229), Color3.fromRGB(126, 84, 217), Color3.fromRGB(232, 96, 152)}
			local sldiercolorpos = {
				[1] = 4,
				[2] = 33,
				[3] = 62,
				[4] = 90,
				[5] = 119,
				[6] = 148, 
				[7] = 177
			}
			
			local function getclosestcolor(color)
				local singlecolor = (1 / #slidercolors)
				for i = 1, #slidercolors do
					if color <= (singlecolor * i) then
						return i
					end
				end
				return 1
			end

			local min, max = 0, 1
			local def = math.floor((min + max) / 2)
			local defsca = (def - min)/(max - min)
			local sliderapi = {}
			local amount2 = #children2:GetChildren()

			local function createSlider(text, changeType)
				local frame = Instance.new("Frame")
				frame.Size = UDim2.new(0, 220, 0, 50)
				frame.BorderSizePixel = 0
				frame.BackgroundTransparency = 0
				frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
				frame.LayoutOrder = amount2 + 1
				frame.Name = text
				frame.Visible = false
				frame.Parent = children2
				local text1 = Instance.new("TextLabel")
				text1.Font = Enum.Font.Arial
				text1.TextXAlignment = Enum.TextXAlignment.Left
				text1.Text = "          "..text
				text1.Size = UDim2.new(1, 0, 0, 27)
				text1.TextColor3 = Color3.fromRGB(160, 160, 160)
				text1.Position = UDim2.new(0, 0, 0, 4)
				text1.BackgroundTransparency = 1
				text1.TextSize = 12
				text1.Parent = frame
				local slider1 = Instance.new("TextButton")
				slider1.AutoButtonColor = false
				slider1.Text = ""
				slider1.Size = UDim2.new(0, 200, 0, 2)
				slider1.BorderSizePixel = 0
				slider1.BackgroundColor3 = Color3.new(1, 1, 1)
				slider1.Position = UDim2.new(0, 10, 0, 32)
				slider1.Name = "Slider"
				slider1.Parent = frame
				local uigradient = Instance.new("UIGradient")
				uigradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 1, 1)), ColorSequenceKeypoint.new(0.2, Color3.fromHSV(0.2, 1, 1)), ColorSequenceKeypoint.new(0.3, Color3.fromHSV(0.3, 1, 1)), ColorSequenceKeypoint.new(0.4, Color3.fromHSV(0.4, 1, 1)), ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5, 1, 1)), ColorSequenceKeypoint.new(0.6, Color3.fromHSV(0.6, 1, 1)), ColorSequenceKeypoint.new(0.7, Color3.fromHSV(0.7, 1, 1)), ColorSequenceKeypoint.new(0.8, Color3.fromHSV(0.8, 1, 1)), ColorSequenceKeypoint.new(0.9, Color3.fromHSV(0.9, 1, 1)), ColorSequenceKeypoint.new(1, Color3.fromHSV(1, 1, 1))})
				uigradient.Parent = slider1
				local slider3 = Instance.new("ImageButton")
				slider3.AutoButtonColor = false
				slider3.Size = UDim2.new(0, 24, 0, 16)
				slider3.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
				slider3.BorderSizePixel = 0
				slider3.Image = downloadVapeAsset("vape/assets/SliderButton1.png")
				slider3.Position = UDim2.new(0.44, -11, 0, -7)
				slider3.Parent = slider1
				slider3.Name = "ButtonSlider"

				local clicktick = tick()
				local function slidercode(obj)
					sliderapi["Custom"] = true
					if clicktick > tick() then
						sliderapi["SetRainbow"](not sliderapi["RainbowValue"])
					end
					clicktick = tick() + 0.3
					local x,y,xscale,yscale,xscale2 = RelativeXY(obj, inputService:GetMouseLocation())
					sliderapi["SetValue"]((changeType == "Hue" and (min + ((max - min) * xscale)) or sliderapi["Hue"]), (changeType == "Sat" and (min + ((max - min) * xscale)) or sliderapi["Sat"]), (changeType == "Value" and (min + ((max - min) * xscale)) or sliderapi["Value"]))
					obj.ButtonSlider.Position = UDim2.new(math.clamp(xscale2, 0.02, 0.95), -9, 0, -7)
					local move
					local kill
					move = inputService.InputChanged:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseMovement then
							local x,y,xscale,yscale,xscale2 = RelativeXY(obj, inputService:GetMouseLocation())
							sliderapi["SetValue"]((changeType == "Hue" and (min + ((max - min) * xscale)) or sliderapi["Hue"]), (changeType == "Sat" and (min + ((max - min) * xscale)) or sliderapi["Sat"]), (changeType == "Value" and (min + ((max - min) * xscale)) or sliderapi["Value"]))
							obj.ButtonSlider.Position = UDim2.new(math.clamp(xscale2, 0.02, 0.95), -9, 0, -7)
						end
					end)
					kill = inputService.InputEnded:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 then
							move:Disconnect()
							kill:Disconnect()
						end
					end)
				end
				slider1.MouseButton1Down:Connect(function()
					slidercode(slider1)
				end)
				slider3.MouseButton1Down:Connect(function()
					slidercode(slider1)
				end)

				return frame
			end

			local frame = Instance.new("Frame")
			frame.Size = UDim2.new(0, 220, 0, 50)
			frame.BackgroundTransparency = 1
			frame.LayoutOrder = amount2
			frame.Name = name
			frame.Parent = children2
			local text1 = Instance.new("TextLabel")
			text1.Font = Enum.Font.Arial
			text1.TextXAlignment = Enum.TextXAlignment.Left
			text1.Text = "          "..name
			text1.Size = UDim2.new(1, 0, 0, 25)
			text1.TextColor3 = Color3.fromRGB(160, 160, 160)
			text1.Position = UDim2.new(0, 0, 0, 4)
			text1.BackgroundTransparency = 1
			text1.TextSize = 12
			text1.Parent = frame
			local text2 = Instance.new("Frame")
			text2.Size = UDim2.new(0, 12, 0, 12)
			text2.Position = UDim2.new(1, -22, 0, 10)
			text2.BackgroundColor3 = Color3.fromRGB(5, 133, 104)
			text2.Parent = frame
			local uicorner4 = Instance.new("UICorner")
			uicorner4.CornerRadius = UDim.new(0, 4)
			uicorner4.Parent = text2
			local slider1 = Instance.new("TextButton")
			slider1.AutoButtonColor = false
			slider1.Text = ""
			slider1.Size = UDim2.new(0, 200, 0, 2)
			slider1.BackgroundTransparency = 1
			slider1.BackgroundColor3 = Color3.fromRGB(5, 133, 104)
			slider1.Position = UDim2.new(0, 10, 0, 32)
			slider1.Name = "Slider"
			slider1.Parent = frame
			local sliderrainbow = Instance.new("ImageButton")
			sliderrainbow.Image = downloadVapeAsset("vape/assets/RainbowIcon1.png")
			sliderrainbow.BackgroundTransparency = 1
			sliderrainbow.Size = UDim2.new(0, 12, 0, 12)
			sliderrainbow.Position = UDim2.new(1, -43, 0, 10)
			sliderrainbow.Parent = frame
			local colornum = 10
			local colorbigger = true
			for i, v in pairs(slidercolors) do
				local colorframe = Instance.new("Frame")
				colorframe.Size = UDim2.new(0, 27 + (colorbigger and 1 or 0), 0, 2)
				colorframe.Position = UDim2.new(0, colornum, 0, 32)
				colorframe.BorderSizePixel = 0
				colorframe.BackgroundColor3 = v
				colorframe.Parent = frame
				colornum = colornum + (colorframe.Size.X.Offset + 1)
				colorbigger = not colorbigger
			end
			local slider3 = Instance.new("ImageButton")
			slider3.AutoButtonColor = false
			slider3.Size = UDim2.new(0, 26, 0, 12)
			slider3.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
			slider3.BorderSizePixel = 0
			slider3.ZIndex = 2
			slider3.Image = downloadVapeAsset("vape/assets/ColorSlider1.png")
			slider3.Position = UDim2.new(0, sldiercolorpos[4] - 3, 0, -5)
			slider3.Parent = slider1
			slider3.Name = "ButtonSlider"
			local hueSlider = createSlider("Custom color", "Hue")
			local satSlider = createSlider("Saturation", "Sat")
			satSlider.Slider.UIGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 0, 1)), ColorSequenceKeypoint.new(1, Color3.fromHSV(0.4, 1, 1))})
			local valSlider = createSlider("Vibrance", "Value")
			valSlider.Slider.UIGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 0, 0)), ColorSequenceKeypoint.new(1, Color3.fromHSV(0.4, 1, 1))})
			local sliderexpand = Instance.new("ImageButton")
			sliderexpand.AutoButtonColor = false
			sliderexpand.Size = UDim2.new(0, 15, 0, 15)
			sliderexpand.BackgroundTransparency = 1
			sliderexpand.Position = UDim2.new(0, textService:GetTextSize(text1.Text, text1.TextSize, text1.Font, Vector2.new(10000, 100000)).X + 3, 0, 6)
			sliderexpand.Image = downloadVapeAsset("vape/assets/HoverArrow3.png")
			sliderexpand.Parent = frame
			sliderexpand.MouseEnter:Connect(function()
				sliderexpand.Image = downloadVapeAsset("vape/assets/HoverArrow4.png")
			end)
			sliderexpand.MouseLeave:Connect(function()
				sliderexpand.Image = downloadVapeAsset("vape/assets/HoverArrow3.png")
			end)
			sliderexpand.MouseButton1Click:Connect(function()
				local val = not hueSlider.Visible
				hueSlider.Visible = val
				satSlider.Visible = val
				valSlider.Visible = val
				sliderexpand.Rotation = (val and 180 or 0)
			end)
			local defaulth, defaults, defaultv = slidercolors[4]:ToHSV()
			sliderapi["Hue"] = defaulth
			sliderapi["Sat"] = defaults
			sliderapi["Value"] = defaultv
			sliderapi["Saved"] = 4
			sliderapi["RainbowValue"] = false
			sliderapi["Custom"] = false
			sliderapi["Object"] = frame

			--[[
				sliderapi["Hue"] = (argstable["Default"] or 0.44)
				sliderapi["Sat"] = 1
				sliderapi["Value"] = 1
				sliderapi["Object"] = frame
				sliderapi["RainbowValue"] = false
				sliderapi["SetValue"] = function(hue, sat, val)
					hue = (hue or sliderapi["Hue"])
					sat = (sat or sliderapi["Sat"])
					val = (val or sliderapi["Value"])
					text2.BackgroundColor3 = Color3.fromHSV(hue, sat, val)
					pcall(function()
						slidersat.Slider.UIGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 0, val)), ColorSequenceKeypoint.new(1, Color3.fromHSV(hue, 1, val))})
						sliderval.Slider.UIGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 0, 0)), ColorSequenceKeypoint.new(1, Color3.fromHSV(hue, sat, 1))})
					end)
					sliderapi["Hue"] = hue
					sliderapi["Sat"] = sat
					sliderapi["Value"] = val
					slider3.Position = UDim2.new(math.clamp(hue, 0.02, 0.95), -9, 0, -7)
					argstable["Function"](hue, sat, val)
				end
			]]
			sliderapi["SetValue"] = function(hue, sat, val)
				hue = hue or 0.46
				sat = sat or 0.96
				val = val or 0.52
				slider3.Image = ((sliderapi["RainbowValue"] or sliderapi["Custom"]) and downloadVapeAsset("vape/assets/ColorSlider2.png") or downloadVapeAsset("vape/assets/ColorSlider1.png"))
				sliderrainbow.Image = (sliderapi["RainbowValue"] and downloadVapeAsset("vape/assets/RainbowIcon2.png") or downloadVapeAsset("vape/assets/RainbowIcon1.png"))
				if sliderapi["RainbowValue"] or sliderapi["Custom"] then
					val = math.clamp(val, min, max)
					text2.BackgroundColor3 = Color3.fromHSV(hue, 0.7, 0.9)
					slider3.ImageColor3 = Color3.new(1, 1, 1)
					sliderapi["Hue"] = hue	
					sliderapi["Sat"] = sat
					sliderapi["Value"] = val
					pcall(function()
						satSlider.Slider.UIGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 0, val)), ColorSequenceKeypoint.new(1, Color3.fromHSV(hue, 1, val))})
						valSlider.Slider.UIGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 0, 0)), ColorSequenceKeypoint.new(1, Color3.fromHSV(hue, sat, 1))})
						hueSlider.Slider.ButtonSlider.Position = UDim2.new(math.clamp(hue, 0.02, 0.95), -9, 0, -7)
						satSlider.Slider.ButtonSlider.Position = UDim2.new(math.clamp(sat, 0.02, 0.95), -9, 0, -7)
						valSlider.Slider.ButtonSlider.Position = UDim2.new(math.clamp(val, 0.02, 0.95), -9, 0, -7)
					end)
					slider3.Position = UDim2.new(0, sldiercolorpos[4] - 3, 0, -5)
					temporaryfunction(hue, sat, val)
				else
					local colornum = getclosestcolor(hue)
					sliderapi["Saved"] = colornum
					local h, s, v = slidercolors[colornum]:ToHSV()
					text2.BackgroundColor3 = slidercolors[colornum]
					slider3.ImageColor3 = slidercolors[colornum]
					sliderapi["Hue"] = h
					sliderapi["Sat"] = s
					sliderapi["Value"] = v
					pcall(function()
						satSlider.Slider.UIGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 0, val)), ColorSequenceKeypoint.new(1, Color3.fromHSV(hue, 1, val))})
						valSlider.Slider.UIGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 0, 0)), ColorSequenceKeypoint.new(1, Color3.fromHSV(hue, sat, 1))})
						hueSlider.Slider.ButtonSlider.Position = UDim2.new(math.clamp(h, 0.02, 0.95), -9, 0, -7)
						satSlider.Slider.ButtonSlider.Position = UDim2.new(math.clamp(s, 0.02, 0.95), -9, 0, -7)
						valSlider.Slider.ButtonSlider.Position = UDim2.new(math.clamp(v, 0.02, 0.95), -9, 0, -7)
					end)
					slider3.Position = UDim2.new(0, sldiercolorpos[colornum] - 3, 0, -5)
					temporaryfunction(h, s, v)
				end
				firstmove = false
			end
			sliderapi["SetRainbow"] = function(val)
				sliderapi["RainbowValue"] = val
				sliderapi["Custom"] = false
				if sliderapi["RainbowValue"] then
					table.insert(GuiLibrary.RainbowSliders, sliderapi)
				else
					table.remove(GuiLibrary.RainbowSliders, table.find(GuiLibrary.RainbowSliders, sliderapi))
					sliderapi["SetValue"]()
				end
			end
			sliderrainbow.MouseButton1Click:Connect(function()
				sliderapi["SetRainbow"](not sliderapi["RainbowValue"])
				sliderrainbow.Image = (sliderapi["RainbowValue"] and downloadVapeAsset("vape/assets/RainbowIcon2.png") or downloadVapeAsset("vape/assets/RainbowIcon1.png"))
			end)
			slider1.MouseButton1Down:Connect(function()
				sliderapi["Custom"] = false
				local x,y,xscale,yscale,xscale2 = RelativeXY(slider1, inputService:GetMouseLocation())
				sliderapi["SetValue"](min + ((max - min) * xscale))
			--	slider3.Position = UDim2.new(math.clamp(xscale2, 0.02, 0.95), -9, 0, -5)
				local move
				local kill
				move = inputService.InputChanged:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseMovement then
						local x,y,xscale,yscale,xscale2 = RelativeXY(slider1, inputService:GetMouseLocation())
						sliderapi["SetValue"](min + ((max - min) * xscale))
					--	slider3.Position = UDim2.new(math.clamp(xscale2, 0.02, 0.95), -9, 0, -5)
					end
				end)
				kill = inputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						move:Disconnect()
						kill:Disconnect()
					end
				end)
			end)
			local clicktick = tick()
			slider3.MouseButton1Down:Connect(function()
				sliderapi["Custom"] = false
				if clicktick > tick() then
					sliderapi["SetRainbow"](not sliderapi["RainbowValue"])
				end
				clicktick = tick() + 0.3
				local x,y,xscale,yscale,xscale2 = RelativeXY(slider1, inputService:GetMouseLocation())
				sliderapi["SetValue"](min + ((max - min) * xscale), 0.7, 0.9)
				--slider3.Position = UDim2.new(math.clamp(xscale2, 0.02, 0.95), -9, 0, -5)
				local move
				local kill
				move = inputService.InputChanged:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseMovement then
						local x,y,xscale,yscale,xscale2 = RelativeXY(slider1, inputService:GetMouseLocation())
						sliderapi["SetValue"](min + ((max - min) * xscale), 0.7, 0.9)
					--	slider3.Position = UDim2.new(math.clamp(xscale2, 0.02, 0.95), -9, 0, -5)
					end
				end)
				kill = inputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						move:Disconnect()
						kill:Disconnect()
					end
				end)
			end)
			GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"] = {["Type"] = "ColorSliderGUI", ["Object"] = frame, ["Api"] = sliderapi}
			return sliderapi
		end

		windowapi["CreateToggle"] = function(argstable)
			local buttonapi = {}
			local currentanim
			local amount = #children2:GetChildren()
			local buttontext = Instance.new("TextButton")
			buttontext.AutoButtonColor = false
			buttontext.BackgroundTransparency = 1
			buttontext.Name = "ButtonText"
			buttontext.Text = "          "..(translations[argstable["Name"]] ~= nil and translations[argstable["Name"]] or argstable["Name"])
			buttontext.Name = argstable["Name"]
			buttontext.LayoutOrder = amount
			buttontext.Size = UDim2.new(1, 0, 0, 30)
			buttontext.Active = false
			buttontext.TextColor3 = Color3.fromRGB(160, 160, 160)
			buttontext.TextSize = 14
			buttontext.Font = Enum.Font.Arial
			buttontext.TextXAlignment = Enum.TextXAlignment.Left
			buttontext.Position = UDim2.new(0, (icon and 36 or 10), 0, 0)
			buttontext.Parent = children2
			local buttonarrow = Instance.new("ImageLabel")
			buttonarrow.Size = UDim2.new(1, 0, 0, 4)
			buttonarrow.Position = UDim2.new(0, 0, 1, -4)
			buttonarrow.BackgroundTransparency = 1
			buttonarrow.Name = "ToggleArrow"
			buttonarrow.Image = downloadVapeAsset("vape/assets/ToggleArrow.png")
			buttonarrow.Visible = false
			buttonarrow.Parent = buttontext
			local toggleframe1 = Instance.new("Frame")
			toggleframe1.Size = UDim2.new(0, 22, 0, 12)
			toggleframe1.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			toggleframe1.BorderSizePixel = 0
			toggleframe1.Name = "ToggleFrame1"
			toggleframe1.Position = UDim2.new(1, -30, 0, 10)
			toggleframe1.Parent = buttontext
			local toggleframe2 = Instance.new("Frame")
			toggleframe2.Size = UDim2.new(0, 8, 0, 8)
			toggleframe2.Active = false
			toggleframe2.Position = UDim2.new(0, 2, 0, 2)
			toggleframe2.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
			toggleframe2.BorderSizePixel = 0
			toggleframe2.Parent = toggleframe1
			local uicorner = Instance.new("UICorner")
			uicorner.CornerRadius = UDim.new(0, 16)
			uicorner.Parent = toggleframe1
			local uicorner2 = Instance.new("UICorner")
			uicorner2.CornerRadius = UDim.new(0, 16)
			uicorner2.Parent = toggleframe2

			buttonapi["Enabled"] = false
			buttonapi["Keybind"] = ""
			buttonapi["Default"] = argstable["Default"]
			buttonapi["Object"] = buttontext
			buttonapi["ToggleButton"] = function(toggle, first)
				buttonapi["Enabled"] = toggle
				if buttonapi["Enabled"] then
					if not first then
						tweenService:Create(toggleframe1, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromHSV(GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Hue"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Sat"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Value"])}):Play()
					else
						toggleframe1.BackgroundColor3 = Color3.fromHSV(GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Hue"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Sat"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Value"])
					end
					toggleframe2:TweenPosition(UDim2.new(0, 12, 0, 2), Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.1, true)
				else
					if not first then
						tweenService:Create(toggleframe1, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
					else
						toggleframe1.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
					end
					toggleframe2:TweenPosition(UDim2.new(0, 2, 0, 2), Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.1, true)
				end
				argstable["Function"](buttonapi["Enabled"])
			end
			if argstable["Default"] then
				buttonapi["ToggleButton"](argstable["Default"], true)
			end
			buttontext.MouseButton1Click:Connect(function() buttonapi["ToggleButton"](not buttonapi["Enabled"], false) end)
			buttontext.MouseEnter:Connect(function()
				if argstable["HoverText"] and type(argstable["HoverText"]) == "string" then
					hoverbox.Visible = (GuiLibrary["ToggleTooltips"] and hoverbox.TextSize ~= 1)
					local textsize = textService:GetTextSize(argstable["HoverText"], hoverbox.TextSize, hoverbox.Font, Vector2.new(99999, 99999))
					hoverbox.Text = " "..argstable["HoverText"]:gsub("\n", "\n ")
					hoverbox.Size = UDim2.new(0, 8 + textsize.X, 0, textsize.Y + 5)
				end
				if buttonapi["Enabled"] == false then
					tweenService:Create(toggleframe1, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(100, 100, 100)}):Play()
				end
			end)
			if argstable["HoverText"] and type(argstable["HoverText"]) == "string" then
				buttontext.MouseMoved:Connect(function(x, y)
					hoverbox.Visible = (GuiLibrary["ToggleTooltips"] and hoverbox.TextSize ~= 1)
					hoverbox.Position = UDim2.new(0, (x + 16) * (1 / GuiLibrary["MainRescale"].Scale), 0,	(y - (hoverbox.Size.Y.Offset / 2) - 26) * (1 / GuiLibrary["MainRescale"].Scale))
				end)
			end
			buttontext.MouseLeave:Connect(function()
				hoverbox.Visible = false
				if buttonapi["Enabled"] == false then
					tweenService:Create(toggleframe1, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
				end
			end)
			
			GuiLibrary.ObjectsThatCanBeSaved[argstable["Name"].."Toggle"] = {["Type"] = "Toggle", ["Object"] = buttontext, ["Api"] = buttonapi}
			return buttonapi
		end

		windowapi["CreateButton"] = function(argstable)
			local buttonapi = {}
			local amount = #children:GetChildren()
			local button = Instance.new("TextButton")
			button.Name = argstable["Name"].."Button"
			button.AutoButtonColor = false
			button.Size = UDim2.new(1, 0, 0, 40)
			button.BorderSizePixel = 0
			button.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
			button.Text = ""
			button.LayoutOrder = amount
			button.Parent = children
			local buttontext = Instance.new("TextLabel")
			buttontext.BackgroundTransparency = 1
			buttontext.Name = "ButtonText"
			buttontext.Text = (translations[argstable["Name"]] ~= nil and translations[argstable["Name"]] or argstable["Name"])
			buttontext.Size = UDim2.new(0, 120, 0, 38)
			buttontext.Active = false
			buttontext.TextColor3 = Color3.fromRGB(160, 160, 160)
			buttontext.TextSize = 14
			buttontext.Font = Enum.Font.Arial
			buttontext.TextXAlignment = Enum.TextXAlignment.Left
			buttontext.Position = UDim2.new(0, (argstable["Icon"] and 33 or 10), 0, 1)
			buttontext.Parent = button
			local arrow = Instance.new("ImageLabel")
			arrow.Size = UDim2.new(0, 4, 0, 8)
			arrow.BackgroundTransparency = 1
			arrow.Name = "RightArrow"
			arrow.Position = UDim2.new(1, -20, 0, 16)
			arrow.Image = downloadVapeAsset("vape/assets/RightArrow.png")
			arrow.Active = false
			arrow.Parent = button
			local buttonicon
			if argstable["Icon"] then
				buttonicon = Instance.new("ImageLabel")
				buttonicon.Active = false
				buttonicon.Size = UDim2.new(0, argstable["IconSize"] - 2, 0, 14)
				buttonicon.BackgroundTransparency = 1
				buttonicon.Position = UDim2.new(0, 10, 0, 13)
				buttonicon.ImageColor3 = Color3.fromRGB(160, 160, 160)
				buttonicon.Image = downloadVapeAsset(argstable["Icon"])
				buttonicon.Name = "ButtonIcon"
				buttonicon.Parent = button
			end
			buttonapi["Enabled"] = false
			buttonapi["Keybind"] = ""
			buttonapi["ToggleButton"] = function(clicked, first)
				if overlaysbkg.Visible == false then
					buttonapi["Enabled"] = not buttonapi["Enabled"]
					if buttonapi["Enabled"] then
						button.BackgroundColor3 = Color3.fromRGB(31, 30, 31)
						buttontext.TextColor3 = Color3.fromHSV(GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Hue"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Sat"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Value"])
						if not first then
							arrow:TweenPosition(UDim2.new(1, -14, 0, 16), Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.2, true)
						end
						if buttonicon then
							buttonicon.ImageColor3 = Color3.fromHSV(GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Hue"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Sat"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Value"])
						end
					else
						button.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
						buttontext.TextColor3 = Color3.fromRGB(160, 160, 160)
						if not first then 
							arrow:TweenPosition(UDim2.new(1, -20, 0, 16), Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.2, true)
						end
						if buttonicon then
							buttonicon.ImageColor3 = Color3.fromRGB(200, 200, 200)
						end
					end
					argstable["Function"](buttonapi["Enabled"])
					GuiLibrary["UpdateHudEvent"]:Fire()
				end
			end

			button.MouseButton1Click:Connect(function() buttonapi["ToggleButton"](true) end)
			button.MouseEnter:Connect(function() 
				if overlaysbkg.Visible == false then
					if not buttonapi["Enabled"] then
						tweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(31, 30, 31)}):Play()
						buttontext.TextColor3 = Color3.fromRGB(200, 200, 200)
						if buttonicon then
							buttonicon.ImageColor3 = Color3.fromRGB(200, 200, 200)
						end
					end
				end
			end)
			button.MouseLeave:Connect(function() 
				if overlaysbkg.Visible == false then
					if not buttonapi["Enabled"] then
						tweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(26, 25, 26)}):Play()
						buttontext.TextColor3 = Color3.fromRGB(160, 160, 160)
						if buttonicon then
							buttonicon.ImageColor3 = Color3.fromRGB(160, 160, 160)
						end
					end
				end
			end)
			GuiLibrary.ObjectsThatCanBeSaved[argstable["Name"].."Button"] = {["Type"] = "ButtonMain", ["Object"] = button, ["Api"] = buttonapi}

			return buttonapi
		end

		return windowapi
	end

	GuiLibrary["CreateCustomWindow"] = function(argstablemain)
		local windowapi = {}
		local windowtitle = Instance.new("TextButton")
		windowtitle.Text = ""
		windowtitle.AutoButtonColor = false
		windowtitle.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
		windowtitle.Size = UDim2.new(0, 220, 0, 45)
		windowtitle.Position = UDim2.new(0, 223, 0, 6)
		windowtitle.Name = "MainWindow"
		windowtitle.Visible = false
		windowtitle.Name = argstablemain["Name"]
		windowtitle.Parent = hudgui
		local windowshadow = Instance.new("ImageLabel")
		windowshadow.AnchorPoint = Vector2.new(0.5, 0.5)
		windowshadow.Position = UDim2.new(0.5, 0, 0.5, 0)
		windowshadow.Image = downloadVapeAsset("vape/assets/WindowBlur.png")
		windowshadow.BackgroundTransparency = 1
		windowshadow.ZIndex = -1
		windowshadow.Size = UDim2.new(1, 6, 1, 6)
		windowshadow.ImageColor3 = Color3.new(0, 0, 0)
		windowshadow.ScaleType = Enum.ScaleType.Slice
		windowshadow.SliceCenter = Rect.new(10, 10, 118, 118)
		windowshadow.Parent = windowtitle
		local windowicon = Instance.new("ImageLabel")
		windowicon.Size = UDim2.new(0, argstablemain["IconSize"], 0, 16)
		windowicon.Image = downloadVapeAsset(argstablemain["Icon"])
		windowicon.Name = "WindowIcon"
		windowicon.BackgroundTransparency = 1
		windowicon.Position = UDim2.new(0, 12, 0, 12)
		windowicon.Parent = windowtitle
		local windowtext = Instance.new("TextLabel")
		windowtext.Size = UDim2.new(0, 155, 0, 41)
		windowtext.BackgroundTransparency = 1
		windowtext.Name = "WindowTitle"
		windowtext.Position = UDim2.new(0, 36, 0, 1)
		windowtext.TextXAlignment = Enum.TextXAlignment.Left
		windowtext.Font = Enum.Font.Arial
		windowtext.TextSize = 14
		windowtext.Text = (translations[argstablemain["Name"]] ~= nil and translations[argstablemain["Name"]] or argstablemain["Name"])
		windowtext.TextColor3 = Color3.fromRGB(201, 201, 201)
		windowtext.Parent = windowtitle
		local expandbutton = Instance.new("ImageButton")
		expandbutton.AutoButtonColor = false
		expandbutton.Size = UDim2.new(0, 16, 0, 16)
		expandbutton.Image = downloadVapeAsset("vape/assets/PinButton.png")
		expandbutton.ImageColor3 = Color3.fromRGB(84, 84, 84)
		expandbutton.BackgroundTransparency = 1
		expandbutton.Name = "PinButton" 
		expandbutton.Position = UDim2.new(1, -47, 0, 13)
		expandbutton.Parent = windowtitle
		local optionsbutton = Instance.new("ImageButton")
		optionsbutton.AutoButtonColor = false
		optionsbutton.Size = UDim2.new(0, 10, 0, 20)
		optionsbutton.Position = UDim2.new(1, -16, 0, 11)
		optionsbutton.Name = "OptionsButton"
		optionsbutton.BackgroundTransparency = 1
		optionsbutton.Image = downloadVapeAsset("vape/assets/MoreButton3.png")
		optionsbutton.Parent = windowtitle
		local children = Instance.new("Frame")
		children.BackgroundTransparency = 1
		children.Size = UDim2.new(0, 220, 0, 300)
		children.Position = UDim2.new(0, 0, 1, 0)
		children.Visible = true
		children.Parent = windowtitle
		local children2 = Instance.new("Frame")
		children2.BackgroundTransparency = 1
		children2.Size = UDim2.new(1, 0, 1, -4)
		children2.Position = UDim2.new(0, 0, 0, 41)
		children2.Visible = false
		children2.Parent = windowtitle
		local windowcorner = Instance.new("UICorner")
		windowcorner.CornerRadius = UDim.new(0, 4)
		windowcorner.Parent = windowtitle
		local uilistlayout = Instance.new("UIListLayout")
		uilistlayout.SortOrder = Enum.SortOrder.LayoutOrder
		uilistlayout.Parent = children2
		uilistlayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			if children2.Visible then
				windowtitle.Size = UDim2.new(0, 220, 0, 45 + uilistlayout.AbsoluteContentSize.Y * (1 / GuiLibrary["MainRescale"].Scale))
				
			end
		end)
		dragGUI(windowtitle)
		windowapi["Pinned"] = false
		windowapi["RealVis"] = false
		windowapi["Bypass"] = argstablemain["Bypass"]
		
		windowapi["CheckVis"] = function()
			if windowapi["RealVis"] then
				if clickgui.Visible then
					windowtitle.Visible = true
					windowtext.Visible = true
					windowtitle.Size = UDim2.new(0, 220, 0, 45)
					windowtitle.BackgroundTransparency = 0
					windowicon.Visible = true
					expandbutton.Visible = true
					optionsbutton.Visible = true
				else
					if windowapi["Pinned"] then
						windowtitle.Visible = true
						windowtext.Visible = false
						windowtitle.Size = UDim2.new(0, 220, 0, 0)
						windowtitle.BackgroundTransparency = 1
						windowicon.Visible = false
						expandbutton.Visible = false
						optionsbutton.Visible = false
						children2.Visible = false
						children.Visible = true
					else
						windowtitle.Visible = false
					end
				end
			else
				windowtitle.Visible = false
			end
			windowshadow.Visible = (windowtitle.Size ~= UDim2.new(0, 220, 0, 0))
		end
		
		windowapi["SetVisible"] = function(value)
			windowapi["RealVis"] = value
			windowapi["CheckVis"]()
		end

		windowapi["ExpandToggle"] = function()
			if children2.Visible then
				children2.Visible = false
				children.Visible = true
				windowtitle.Size = UDim2.new(0, 220, 0, 45)
			else
				children2.Visible = true
				children.Visible = false
				windowtitle.Size = UDim2.new(0, 220, 0, 45 + uilistlayout.AbsoluteContentSize.Y * (1 / GuiLibrary["MainRescale"].Scale))
			end
		end

		windowapi["CreateSlider"] = function(argstable)
				
			local sliderapi = {}
			local amount2 = #children2:GetChildren()
			local frame = Instance.new("Frame")
			frame.Size = UDim2.new(0, 220, 0, 50)
			frame.BackgroundTransparency = 1
			frame.ClipsDescendants = true
			frame.LayoutOrder = amount2
			frame.Name = argstable["Name"]
			frame.Parent = children2
			local text1 = Instance.new("TextLabel")
			text1.Font = Enum.Font.Arial
			text1.TextXAlignment = Enum.TextXAlignment.Left
			text1.Text = "          "..(translations[argstable["Name"]] ~= nil and translations[argstable["Name"]] or argstable["Name"])
			text1.Size = UDim2.new(1, 0, 0, 25)
			text1.TextColor3 = Color3.fromRGB(160, 160, 160)
			text1.Position = UDim2.new(0, 0, 0, 4)
			text1.BackgroundTransparency = 1
			text1.TextSize = 12
			text1.Parent = frame
			local text2 = Instance.new("TextButton")
			text2.Font = Enum.Font.Arial
			text2.AutoButtonColor = false
			text2.TextXAlignment = Enum.TextXAlignment.Right
			text2.Text = tostring((argstable["Default"] or argstable["Min"])) .. " "..(argstable["Percent"] and "%" or " ").." "
			text2.Size = UDim2.new(0, 40, 0, 25)
			text2.Position = UDim2.new(1, -40, 0, 4)
			text2.TextColor3 = Color3.fromRGB(160, 160, 160)
			text2.BackgroundTransparency = 1
			text2.TextSize = 12
			text2.Parent = frame
			local text3 = Instance.new("TextBox")
			text3.Visible = false
			text3.Font = Enum.Font.Arial
			text3.TextXAlignment = Enum.TextXAlignment.Right
			text3.BackgroundTransparency = 1
			text3.TextColor3 = Color3.fromRGB(160, 160, 160)
			text3.Text = ""
			text3.Position = UDim2.new(1, -40, 0, 4)
			text3.Size = UDim2.new(0, 40, 0, 25)
			text3.TextSize = 12
			text3.Parent = frame
			local textdown = Instance.new("Frame")
			textdown.BackgroundColor3 = Color3.fromRGB(37, 36, 37)
			textdown.Size = UDim2.new(0, 30, 0, 2)
			textdown.Position = UDim2.new(1, -38, 1, -4)
			textdown.Visible = false
			textdown.BorderSizePixel = 0
			textdown.Parent = text2
			local textdown2 = Instance.new("Frame")
			textdown2.BackgroundColor3 = Color3.fromRGB(41, 41, 41)
			textdown2.Size = UDim2.new(0, 30, 0, 2)
			textdown2.Position = UDim2.new(1, -38, 1, -4)
			textdown2.BorderSizePixel = 0
			textdown2.Parent = text3
			local slider1 = Instance.new("Frame")
			slider1.Size = UDim2.new(0, 200, 0, 2)
			slider1.BorderSizePixel = 0
			slider1.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			slider1.Position = UDim2.new(0, 10, 0, 37)
			slider1.Name = "Slider"
			slider1.Parent = frame
			local slider2 = Instance.new("Frame")
			slider2.BorderSizePixel = 0
			slider2.Size = UDim2.new(math.clamp(((argstable["Default"] or argstable["Min"]) / argstable["Max"]), 0.02, 0.97), 0, 1, 0)
			slider2.BackgroundColor3 = Color3.fromHSV(GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Hue"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Sat"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Value"])
			slider2.Name = "FillSlider"
			slider2.Parent = slider1
			local slider3 = Instance.new("ImageButton")
			slider3.AutoButtonColor = false
			slider3.Size = UDim2.new(0, 24, 0, 16)
			slider3.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
			slider3.BorderSizePixel = 0
			slider3.Image = downloadVapeAsset("vape/assets/SliderButton1.png")
			slider3.Position = UDim2.new(1, -11, 0, -7)
			slider3.Parent = slider2
			slider3.Name = "ButtonSlider"
			sliderapi["Object"] = frame
			sliderapi["Value"] = (argstable["Default"] or argstable["Min"])
			sliderapi["Default"] = (argstable["Default"] or argstable["Min"])
			sliderapi["Min"] = argstable["Min"]
			sliderapi["Max"] = argstable["Max"]
			sliderapi["SetValue"] = function(val)
			--	val = math.clamp(val, argstable["Min"], argstable["Max"])
				sliderapi["Value"] = val
				slider2.Size = UDim2.new(math.clamp((val / argstable["Max"]), 0.02, 0.97), 0, 1, 0)
				text2.Text = sliderapi["Value"] .. ".0 "..(argstable["Percent"] and "%" or " ").." "
				argstable["Function"](val)
			end
			slider3.MouseButton1Down:Connect(function()
				local x,y,xscale,yscale,xscale2 = RelativeXY(slider1, inputService:GetMouseLocation())
				sliderapi["SetValue"](math.floor(argstable["Min"] + ((argstable["Max"] - argstable["Min"]) * xscale)))
				text2.Text = sliderapi["Value"] .. ".0 "..(argstable["Percent"] and "%" or " ").." "
				slider2.Size = UDim2.new(xscale2,0,1,0)
				local move
				local kill
				move = inputService.InputChanged:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseMovement then
						local x,y,xscale,yscale,xscale2 = RelativeXY(slider1, inputService:GetMouseLocation())
						sliderapi["SetValue"](math.floor(argstable["Min"] + ((argstable["Max"] - argstable["Min"]) * xscale)))
						text2.Text = sliderapi["Value"] .. ".0 "..(argstable["Percent"] and "%" or " ").." "
						slider2.Size = UDim2.new(xscale2,0,1,0)
					end
				end)
				kill = inputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						move:Disconnect()
						kill:Disconnect()
					end
				end)
			end)
			text2.MouseEnter:Connect(function()
				textdown.Visible = true
			end)
			text2.MouseLeave:Connect(function()
				textdown.Visible = false
			end)
			text2.MouseButton1Click:Connect(function()
				text3.Visible = true
				text2.Visible = false
				text3:CaptureFocus()
				text3.Text = text2.Text
			end)
			text3.FocusLost:Connect(function(enter)
				text3.Visible = false
				text2.Visible = true
				if enter then
					sliderapi["SetValue"](tonumber(text3.Text))
				end
			end)
			frame.MouseEnter:Connect(function()
				if argstable["HoverText"] and type(argstable["HoverText"]) == "string" then
					hoverbox.Visible = (GuiLibrary["ToggleTooltips"] and hoverbox.TextSize ~= 1)
					local textsize = textService:GetTextSize(argstable["HoverText"], hoverbox.TextSize, hoverbox.Font, Vector2.new(99999, 99999))
					hoverbox.Text = " "..argstable["HoverText"]:gsub("\n", "\n ")
					hoverbox.Size = UDim2.new(0, 8 + textsize.X, 0, textsize.Y + 5)
				end
			end)
			if argstable["HoverText"] and type(argstable["HoverText"]) == "string" then
				frame.MouseMoved:Connect(function(x, y)
					hoverbox.Visible = (GuiLibrary["ToggleTooltips"] and hoverbox.TextSize ~= 1)
					hoverbox.Position = UDim2.new(0, (x + 16) * (1 / GuiLibrary["MainRescale"].Scale), 0,	(y - (hoverbox.Size.Y.Offset / 2) - 26) * (1 / GuiLibrary["MainRescale"].Scale))
				end)
			end
			frame.MouseLeave:Connect(function()
				hoverbox.Visible = false
			end)
			GuiLibrary.ObjectsThatCanBeSaved[argstablemain["Name"]..argstable["Name"].."Slider"] = {["Type"] = "SliderMain", ["Object"] = frame, ["Api"] = sliderapi}
			return sliderapi
		end

		windowapi["CreateTextBox"] = function(argstable)
			local textGuiLibrary = {}
			local amount2 = #children2:GetChildren()
			local frame = Instance.new("Frame")
			frame.Size = UDim2.new(0, 220, 0, 50)
			frame.BackgroundTransparency = 1
			frame.ClipsDescendants = true
			frame.LayoutOrder = amount2
			frame.Name = argstable["Name"]
			frame.Parent = children2
			local frametext = Instance.new("TextLabel")
			frametext.Font = Enum.Font.SourceSans
			frametext.TextSize = 16
			frametext.Size = UDim2.new(1, 0, 0, 18)
			frametext.Position = UDim2.new(0, 0, 0, -3)
			frametext.BackgroundTransparency = 1
			frametext.TextXAlignment = Enum.TextXAlignment.Left
			frametext.TextYAlignment = Enum.TextYAlignment.Top
			frametext.TextColor3 = Color3.fromRGB(180, 180, 180)
			frametext.Text = "   "..argstable["Name"]
			frametext.Parent = frame
			local framebox = Instance.new("TextBox")
			framebox.Size = UDim2.new(0, 200, 0, 29)
			framebox.Position = UDim2.new(0, 10, 0, 16)
			framebox.BackgroundColor3 = Color3.fromRGB(31, 30, 31)
			framebox.Font = Enum.Font.SourceSans
			framebox.PlaceholderText = " Click to set"
			framebox.Text = ""
			framebox.TextColor3 = Color3.new(1, 1, 1)
			framebox.TextXAlignment = Enum.TextXAlignment.Left
			framebox.TextSize = 18
			framebox.PlaceholderColor3 = Color3.fromRGB(180, 180, 180)
			framebox.Parent = frame
			local frameboxcorner = Instance.new("UICorner")
			frameboxcorner.CornerRadius = UDim.new(0, 5)
			frameboxcorner.Parent = framebox
			textGuiLibrary["Object"] = frame
			textGuiLibrary["Value"] = ""
			textGuiLibrary["SetValue"] = function(val, entered)
				textGuiLibrary["Value"] = val
				framebox.Text = val
				if argstable["FocusLost"] and (not entered) then
					argstable["FocusLost"](false)
				end
			end

			framebox.FocusLost:Connect(function(enter) 
				textGuiLibrary["SetValue"](framebox.Text, true)
				if argstable["FocusLost"] then
					argstable["FocusLost"](enter)
				end
			end)

			GuiLibrary.ObjectsThatCanBeSaved[argstablemain["Name"]..argstable["Name"].."TextBox"] = {["Type"] = "TextBoxMain", ["Api"] = textGuiLibrary, ["Object"] = frame}

			return textGuiLibrary
		end

		windowapi["CreateCircleWindow"] = function(argstablemain3)
			local buttonapi = {}
			local buttonreturned = {}
			local windowapi3 = {}
			local amount2 = #children2:GetChildren()
			local frame = Instance.new("Frame")
			frame.Size = UDim2.new(0, 220, 0, 49)
			frame.BackgroundTransparency = 1
			frame.LayoutOrder = amount2
			frame.Name = argstablemain["Name"].."TargetFrame"
			frame.Parent = children2
			local drop1 = Instance.new("TextButton")
			drop1.AutoButtonColor = false
			drop1.Size = UDim2.new(0, 198, 0, 39)
			drop1.Position = UDim2.new(0, 11, 0, 5)
			drop1.Parent = frame
			drop1.BorderSizePixel = 0
			drop1.ZIndex = 2
			drop1.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
			drop1.TextSize = 17
			drop1.TextXAlignment = Enum.TextXAlignment.Left
			drop1.Text = ""
			local targeticon = Instance.new("ImageLabel")
			targeticon.Size = UDim2.new(0, 14, 0, 12)
			targeticon.Position = UDim2.new(0, 12, 0, 14)
			targeticon.BackgroundTransparency = 1
			targeticon.Image = downloadVapeAsset("vape/assets/CircleList"..(argstablemain3["Type"] == "Blacklist" and "Blacklist" or "Whitelist")..".png")
			targeticon.ZIndex = 2
			targeticon.Parent = drop1
			local targettext = Instance.new("TextLabel")
			targettext.Size = UDim2.new(0, 190, 1, 0)
			targettext.Position = UDim2.new(0, 29, 0, 0)
			targettext.TextTruncate = Enum.TextTruncate.AtEnd
			targettext.BackgroundTransparency = 1
			targettext.ZIndex = 2
			targettext.TextSize = 17
			targettext.RichText = true
			targettext.TextColor3 = Color3.new(205, 205, 205)
			targettext.Text = "  "..argstablemain3["Name"].." \n "..'<font color="rgb(151, 151, 151)">None</font>'
			targettext.Font = Enum.Font.SourceSans
			targettext.TextXAlignment = Enum.TextXAlignment.Left
			targettext.Parent = drop1
			local thing = Instance.new("Frame")
			thing.Size = UDim2.new(1, 2, 1, 2)
			thing.BorderSizePixel = 0
			thing.Position = UDim2.new(0, -1, 0, -1)
			thing.ZIndex = 1
			thing.BackgroundColor3 = Color3.fromRGB(38, 37, 38)
			thing.Parent = drop1
			local uicorner = Instance.new("UICorner")
			uicorner.CornerRadius = UDim.new(0, 4)
			uicorner.Parent = drop1
			local uicorner2 = Instance.new("UICorner")
			uicorner2.CornerRadius = UDim.new(0, 4)
			uicorner2.Parent = thing
			local windowtitle = Instance.new("TextButton")
			windowtitle.Text = ""
			windowtitle.AutoButtonColor = false
			windowtitle.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
			windowtitle.Size = UDim2.new(0, 220, 0, 41)
			windowtitle.Position = UDim2.new(1, 1, 0, 0)
			windowtitle.Name = "CircleWindow"
			windowtitle.Visible = false
			windowtitle.ZIndex = 3
			windowtitle.Parent = clickgui
			frame:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
				windowtitle.Position = UDim2.new(0, frame.Size.X.Offset + frame.AbsolutePosition.X + 2, 0, frame.AbsolutePosition.Y)
			end)
			local windowshadow = Instance.new("ImageLabel")
			windowshadow.AnchorPoint = Vector2.new(0.5, 0.5)
			windowshadow.Position = UDim2.new(0.5, 0, 0.5, 0)
			windowshadow.Image = downloadVapeAsset("vape/assets/WindowBlur.png")
			windowshadow.BackgroundTransparency = 1
			windowshadow.ZIndex = -1
			windowshadow.Size = UDim2.new(1, 6, 1, 6)
			windowshadow.ImageColor3 = Color3.new(0, 0, 0)
			windowshadow.ScaleType = Enum.ScaleType.Slice
			windowshadow.SliceCenter = Rect.new(10, 10, 118, 118)
			windowshadow.Parent = windowtitle
			local windowicon = Instance.new("ImageLabel")
			windowicon.Size = UDim2.new(0, 18, 0, 16)
			windowicon.Image = downloadVapeAsset("vape/assets/CircleList"..(argstablemain3["Type"] == "Blacklist" and "Blacklist" or "Whitelist")..".png")
			windowicon.ImageColor3 = Color3.fromRGB(200, 200, 200)
			windowicon.ZIndex = 3
			windowicon.Name = "WindowIcon"
			windowicon.BackgroundTransparency = 1
			windowicon.Position = UDim2.new(0, 10, 0, 13)
			windowicon.Parent = windowtitle
			local windowtext = Instance.new("TextLabel")
			windowtext.Size = UDim2.new(0, 155, 0, 41)
			windowtext.BackgroundTransparency = 1
			windowtext.Name = "WindowTitle"
			windowtext.Position = UDim2.new(0, 36, 0, 0)
			windowtext.ZIndex = 3
			windowtext.TextXAlignment = Enum.TextXAlignment.Left
			windowtext.Font = Enum.Font.SourceSans
			windowtext.TextSize = 17
			windowtext.Text = argstablemain3["Name"]
			windowtext.TextColor3 = Color3.fromRGB(200, 200, 200)
			windowtext.Parent = windowtitle
			local children = Instance.new("Frame")
			children.BackgroundTransparency = 1
			children.Size = UDim2.new(1, 0, 1, -4)
			children.ZIndex = 3
			children.Position = UDim2.new(0, 0, 0, 41)
			children.Visible = true
			children.Parent = windowtitle
			local windowcorner = Instance.new("UICorner")
			windowcorner.CornerRadius = UDim.new(0, 4)
			windowcorner.Parent = windowtitle
			local uilistlayout = Instance.new("UIListLayout")
			uilistlayout.SortOrder = Enum.SortOrder.LayoutOrder
			uilistlayout.Parent = children
			uilistlayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				windowtitle.Size = UDim2.new(0, 220, 0, 45 + uilistlayout.AbsoluteContentSize.Y)
			end)
		
			windowapi3["UpdateIgnore"] = function()
				local str = ""
				for i,v in pairs(buttonreturned["CircleList"]["ObjectList"]) do
					local enabled = buttonreturned["CircleList"]["ObjectListEnabled"][i]
					if enabled then
						str = (str == "" and v or str..", "..v)
					end
				end
				if str == "" then
					str = "None"
				end
				if argstablemain3["UpdateFunction"] then
					argstablemain3["UpdateFunction"]()
				end
				targettext.Text = "  "..argstablemain3["Name"].." \n "..'<font color="rgb(151, 151, 151)">'..str..'</font>'
			end
		
			windowapi3["CreateCircleTextList"] = function(argstable)
				local textGuiLibrary = {}
				local amount = #children:GetChildren()
				local frame = Instance.new("Frame")
				frame.Size = UDim2.new(0, 220, 0, 40)
				frame.BackgroundTransparency = 1
				frame.ZIndex = 5
				frame.ClipsDescendants = true
				frame.LayoutOrder = amount
				frame.Name = argstable["Name"]
				frame.Parent = children
				local textboxbkg = Instance.new("ImageLabel")
				textboxbkg.BackgroundTransparency = 1
				textboxbkg.Name = "AddBoxBKG"
				textboxbkg.Size = UDim2.new(0, (argstable["Name"] == "ProfilesList" and 150 or 200), 0, 31)
				textboxbkg.Position = UDim2.new(0, 10, 0, 5)
				textboxbkg.ZIndex = 6
				textboxbkg.ClipsDescendants = true
				textboxbkg.Image = downloadVapeAsset((argstable["Name"] == "ProfilesList" and "vape/assets/TextBoxBKG2.png" or "vape/assets/TextBoxBKG.png"))
				textboxbkg.Parent = frame
				local textbox = Instance.new("TextBox")
				textbox.Size = UDim2.new(0, 159, 1, 0)
				textbox.Position = UDim2.new(0, 11, 0, 0)
				textbox.ZIndex = 6
				textbox.TextXAlignment = Enum.TextXAlignment.Left
				textbox.Name = "AddBox"
				textbox.BackgroundTransparency = 1
				textbox.TextColor3 = Color3.new(1, 1, 1)
				textbox.PlaceholderColor3 = Color3.fromRGB(200, 200, 200)
				textbox.Font = Enum.Font.SourceSans
				textbox.Text = ""
				textbox.PlaceholderText = "Add entry..."
				textbox.TextSize = 17
				textbox.Parent = textboxbkg
				local addbutton = Instance.new("ImageButton")
				addbutton.BorderSizePixel = 0
				addbutton.Name = "AddButton"
				addbutton.ZIndex = 6
				addbutton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
				addbutton.Position = UDim2.new(0, (argstable["Name"] == "ProfilesList" and 124 or 174), 0, 8)
				addbutton.AutoButtonColor = false
				addbutton.Size = UDim2.new(0, 16, 0, 16)
				addbutton.ImageColor3 = argstable["Color"]
				addbutton.Image = downloadVapeAsset("vape/assets/AddItem.png")
				addbutton.Parent = textboxbkg
				local scrollframebkg = Instance.new("Frame")
				scrollframebkg.ZIndex = 5
				scrollframebkg.Name = "ScrollingFrameBKG"
				scrollframebkg.Size = UDim2.new(0, 220, 0, 3)
				scrollframebkg.BackgroundTransparency = 1
				scrollframebkg.LayoutOrder = amount
				scrollframebkg.Parent = children
				local scrollframe = Instance.new("ScrollingFrame")
				scrollframe.ZIndex = 5
				scrollframe.Size = UDim2.new(0, 200, 0, 3)
				scrollframe.Position = UDim2.new(0, 10, 0, 0)
				scrollframe.BackgroundTransparency = 1
				scrollframe.ScrollBarThickness = 0
				scrollframe.ScrollBarImageColor3 = Color3.new(0, 0, 0)
				scrollframe.LayoutOrder = amount
				scrollframe.Parent = scrollframebkg
				local uilistlayout3 = Instance.new("UIListLayout")
				uilistlayout3.Padding = UDim.new(0, 3)
				uilistlayout3.Parent = scrollframe
				uilistlayout3:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
					scrollframe.CanvasSize = UDim2.new(0, 0, 0, uilistlayout3.AbsoluteContentSize.Y)
					scrollframe.Size = UDim2.new(0, 220, 0, math.clamp(uilistlayout3.AbsoluteContentSize.Y, 1, 105))
					scrollframebkg.Size = UDim2.new(0, 220, 0, math.clamp(uilistlayout3.AbsoluteContentSize.Y, 1, 105) + 3)
				end)
		
				textGuiLibrary["Object"] = frame
				textGuiLibrary["ScrollingObject"] = scrollframebkg
				textGuiLibrary["ObjectList"] = {}
				textGuiLibrary["ObjectListEnabled"] = {}
				local hoveredover = {}
				textGuiLibrary["RefreshValues"] = function(tab, tab2)
					textGuiLibrary["ObjectList"] = tab
					if tab2 then
						textGuiLibrary["ObjectListEnabled"] = tab2
					end
					windowapi3["UpdateIgnore"]()
					for i2,v2 in pairs(scrollframe:GetChildren()) do
						if v2:IsA("TextButton") then v2:Remove() end
					end
					for i,v in pairs(textGuiLibrary["ObjectList"]) do
						local objenabled = textGuiLibrary["ObjectListEnabled"][i]
						local itemframe = Instance.new("TextButton")
						itemframe.Size = UDim2.new(0, 200, 0, 33)
						itemframe.Text = ""
						itemframe.AutoButtonColor = false
						itemframe.BackgroundColor3 = (hoveredover[i] and Color3.fromRGB(26, 25, 26) or Color3.fromRGB(31, 30, 31))
						itemframe.BorderSizePixel = 0
						itemframe.ZIndex = 5
						itemframe.Parent = scrollframe
						local itemcorner = Instance.new("UICorner")
						itemcorner.CornerRadius = UDim.new(0, 6)
						itemcorner.Parent = itemframe
						local itemtext = Instance.new("TextLabel")
						itemtext.BackgroundTransparency = 1
						itemtext.Size = UDim2.new(0, 157, 0, 33)
						itemtext.Name = "ItemText"
						itemtext.ZIndex = 5
						itemtext.Position = UDim2.new(0, 36, 0, 0)
						itemtext.Font = Enum.Font.SourceSans
						itemtext.TextSize = 17
						itemtext.Text = v
						itemtext.TextXAlignment = Enum.TextXAlignment.Left
						itemtext.TextColor3 = (objenabled and Color3.fromRGB(160, 160, 160) or Color3.fromRGB(90, 90, 90))
						itemtext.Parent = itemframe
						local friendcircle = Instance.new("Frame")
						friendcircle.Size = UDim2.new(0, 10, 0, 10)
						friendcircle.Name = "FriendCircle"
						friendcircle.ZIndex = 5
						friendcircle.BackgroundColor3 = (objenabled and argstable["Color"] or Color3.fromRGB(120, 120, 120))
						friendcircle.BorderSizePixel = 0
						friendcircle.Position = UDim2.new(0, 10, 0, 13)
						friendcircle.Parent = itemframe
						local friendcorner = Instance.new("UICorner")
						friendcorner.CornerRadius = UDim.new(0, 8)
						friendcorner.Parent = friendcircle
						local friendcircle2 = friendcircle:Clone()
						friendcircle2.Size = UDim2.new(0, 8, 0, 8)
						friendcircle2.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
						friendcircle2.Position = UDim2.new(0, 1, 0, 1)
						friendcircle2.Visible = not objenabled
						friendcircle2.Parent = friendcircle	
						itemframe:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
							friendcircle2.BackgroundColor3 = itemframe.BackgroundColor3
						end)
						itemframe.MouseEnter:Connect(function()
							itemframe.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
							hoveredover[i] = true
						end)
						itemframe.MouseLeave:Connect(function()
							itemframe.BackgroundColor3 = Color3.fromRGB(31, 30, 31)
							hoveredover[i] = nil
						end)
						itemframe.MouseButton1Click:Connect(function()
							textGuiLibrary["ObjectListEnabled"][i] = not textGuiLibrary["ObjectListEnabled"][i]
							textGuiLibrary["RefreshValues"](textGuiLibrary["ObjectList"])
						end)
						itemframe.MouseButton2Click:Connect(function()
							textGuiLibrary["ObjectListEnabled"][i] = not textGuiLibrary["ObjectListEnabled"][i]
							textGuiLibrary["RefreshValues"](textGuiLibrary["ObjectList"])
						end)
						local deletebutton = Instance.new("ImageButton")
						deletebutton.Size = UDim2.new(0, 6, 0, 6)
						deletebutton.BackgroundTransparency = 1
						deletebutton.AutoButtonColor = false
						deletebutton.ZIndex = 5
						deletebutton.Image = downloadVapeAsset("vape/assets/AddRemoveIcon1.png")
						deletebutton.Position = UDim2.new(1, -16, 0, 14)
						deletebutton.Parent = itemframe
						deletebutton.MouseButton1Click:Connect(function()
							table.remove(textGuiLibrary["ObjectList"], i)
							textGuiLibrary["ObjectListEnabled"][i] = nil
							textGuiLibrary["RefreshValues"](textGuiLibrary["ObjectList"])
							if argstable["RemoveFunction"] then
								argstable["RemoveFunction"](i, v)
							end
						end)
					end
				end
		
				GuiLibrary.ObjectsThatCanBeSaved[argstablemain["Name"]..argstable["Name"].."TextCircleList"] = {["Type"] = "TextCircleList", ["Api"] = textGuiLibrary}
				local function AddToList()
					local num = #textGuiLibrary["ObjectList"] + 1
					textGuiLibrary["ObjectList"][num] = textbox.Text
					textGuiLibrary["ObjectListEnabled"][num] = true
					textGuiLibrary["RefreshValues"](textGuiLibrary["ObjectList"])
					if argstable["AddFunction"] then
						argstable["AddFunction"](textbox.Text) 
					end
                    textbox.Text = ""
                end
                addbutton.MouseButton1Click:Connect(AddToList)
                textbox.FocusLost:Connect(function(enter)
                    if enter then
                        AddToList()
                        textbox:CaptureFocus()
                    end
                end)
				return textGuiLibrary
			end
		
			--[[windowapi3["CreateButton"] = function(argstable)
				local buttonapi = {}
				local amount = #children:GetChildren()
				local buttontext = Instance.new("TextButton")
				buttontext.Name = argstablemain["Name"]..argstable["Name"].."TargetButton"
				buttontext.LayoutOrder = amount
				buttontext.AutoButtonColor = false
				buttontext.Size = UDim2.new(0, 45, 0, 29)
				buttontext.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
				buttontext.Active = false
				buttontext.Text = ""
				buttontext.ZIndex = 4
				buttontext.Font = Enum.Font.SourceSans
				buttontext.TextXAlignment = Enum.TextXAlignment.Left
				buttontext.Position = argstable["Position"]
				buttontext.Parent = buttonframeholder
				local buttonbkg = Instance.new("Frame")
				buttonbkg.BackgroundColor3 = Color3.fromRGB(38, 37, 38)
				buttonbkg.Size = UDim2.new(0, 47, 0, 31)
				buttonbkg.Position = argstable["Position"] - UDim2.new(0, 1, 0, 1)
				buttonbkg.ZIndex = 3
				buttonbkg.Parent = buttonframeholder
				local buttonimage = Instance.new("ImageLabel")
				buttonimage.BackgroundTransparency = 1
				buttonimage.Position = UDim2.new(0, 14, 0, 7)
				buttonimage.Size = UDim2.new(0, argstable["IconSize"], 0, 16)
				buttonimage.Image = downloadVapeAsset(argstable["Icon"])
				buttonimage.ImageColor3 = Color3.fromRGB(121, 121, 121)
				buttonimage.ZIndex = 5
				buttonimage.Active = false
				buttonimage.Parent = buttontext
				local buttontexticon = Instance.new("ImageLabel")
				buttontexticon.Size = UDim2.new(0, argstable["IconSize"] - 3, 0, 12)
				buttontexticon.Image = downloadVapeAsset(argstable["Icon"])
				buttontexticon.LayoutOrder = amount
				buttontexticon.ZIndex = 4
				buttontexticon.BackgroundTransparency = 1
				buttontexticon.Visible = false
				buttontexticon.Parent = targetframe
				local buttonround1 = Instance.new("UICorner")
				buttonround1.CornerRadius = UDim.new(0, 5)
				buttonround1.Parent = buttontext
				local buttonround2 = Instance.new("UICorner")
				buttonround2.CornerRadius = UDim.new(0, 5)
				buttonround2.Parent = buttonbkg
				buttonapi["Enabled"] = false
				buttonapi["Default"] = argstable["Default"]
		
				buttonapi["ToggleButton"] = function(toggle, frist)
					buttonapi["Enabled"] = toggle
					buttontexticon.Visible = toggle
					if buttonapi["Enabled"] then
						if not first then
							tweenService:Create(buttontext, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromHSV(GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Hue"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Sat"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Value"])}):Play()
						else
							buttontext.BackgroundColor3 = Color3.fromHSV(GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Hue"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Sat"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Value"])
						end
					else
						if not first then
							tweenService:Create(buttontext, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(26, 25, 26)}):Play()
						else
							buttontext.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
						end
					end
					buttonimage.ImageColor3 = (buttonapi["Enabled"] and Color3.new(1, 1, 1) or Color3.fromRGB(121, 121, 121))
					argstable["Function"](buttonapi["Enabled"])
				end
		
				if argstable["Default"] then
					buttonapi["ToggleButton"](argstable["Default"], true)
				end
				buttontext.MouseButton1Click:Connect(function() buttonapi["ToggleButton"](not buttonapi["Enabled"], false) end)
				GuiLibrary.ObjectsThatCanBeSaved[argstablemain["Name"]..argstable["Name"].."TargetButton"] = {["Type"] = "TargetButton", ["Object"] = buttontext, ["Api"] = buttonapi}
				return buttonapi
			end]]
			buttonreturned["Object"] = frame
			buttonreturned["CircleList"] = windowapi3.CreateCircleTextList({
				Name = "CircleList",
				Color = (argstablemain3["Type"] == "Blacklist" and Color3.fromRGB(250, 50, 56) or Color3.fromRGB(5, 134, 105))
			})
		
			drop1.MouseButton1Click:Connect(function()
				windowtitle.Visible = not windowtitle.Visible
				if not windowtitle.Visible then
					tweenService:Create(thing, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(107, 107, 107)}):Play()
				end
			end)
			drop1.MouseEnter:Connect(function()
				if not windowtitle.Visible then
					tweenService:Create(thing, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(107, 107, 107)}):Play()
				end
			end)
			drop1.MouseLeave:Connect(function()
				if not windowtitle.Visible then
					tweenService:Create(thing, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(38, 37, 38)}):Play()
				end
			end)
		
			GuiLibrary.ObjectsThatCanBeSaved[argstablemain["Name"].."CircleListFrame"] = {["Type"] = "CircleListFrame", ["Object"] = frame, ["Object2"] = windowtitle, ["Api"] = buttonreturned}
		
			return buttonreturned
		end

		windowapi["CreateDropdown"] = function(argstable)
			local dropGuiLibrary = {}
			local list = argstable["List"]
			local amount2 = #children2:GetChildren()
			local frame = Instance.new("Frame")
			frame.Size = UDim2.new(0, 220, 0, 40)
			frame.BackgroundTransparency = 1
			frame.LayoutOrder = amount2
			frame.Name = argstable["Name"]
			frame.Parent = children2
			local drop1 = Instance.new("TextButton")
			drop1.AutoButtonColor = false
			drop1.Size = UDim2.new(0, 198, 0, 29)
			drop1.Position = UDim2.new(0, 11, 0, 5)
			drop1.Parent = frame
			drop1.BorderSizePixel = 0
			drop1.ZIndex = 2
			drop1.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
			drop1.TextSize = 14
			drop1.TextXAlignment = Enum.TextXAlignment.Left
			drop1.TextColor3 = Color3.fromRGB(160, 160, 160)
			drop1.Text = "         "..(translations[argstable["Name"]] ~= nil and translations[argstable["Name"]] or argstable["Name"]).." - "..(list ~= {} and list[1] or "")
			drop1.TextTruncate = Enum.TextTruncate.AtEnd
			drop1.Font = Enum.Font.Arial
			local expandbutton2 = Instance.new("ImageLabel")
			expandbutton2.Active = false
			expandbutton2.Size = UDim2.new(0, 9, 0, 4)
			expandbutton2.Image = downloadVapeAsset("vape/assets/DownArrow.png")
			expandbutton2.ZIndex = 5
			expandbutton2.Position = UDim2.new(1, -19, 1, -16)
			expandbutton2.Name = "ExpandButton2"
			expandbutton2.BackgroundTransparency = 0
			expandbutton2.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
			expandbutton2.BorderSizePixel = 0
			expandbutton2.Parent = drop1
			local drop2 = drop1:Clone()
			drop2.Name = "MainButton"
			drop2.Position = UDim2.new(0, 0, 0, 0)
			drop2.ZIndex = 4
			drop2.BackgroundTransparency = 1
			drop1:GetPropertyChangedSignal("Text"):Connect(function()
				drop2.Text = drop1.Text
			end)
			drop2.ExpandButton2.Image = downloadVapeAsset("vape/assets/UpArrow.png")
			local thing = Instance.new("Frame")
			thing.Size = UDim2.new(1, 2, 1, 2)
			thing.BorderSizePixel = 0
			thing.Position = UDim2.new(0, -1, 0, -1)
			thing.ZIndex = 1
			thing.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
			thing.Parent = drop1
			local uicorner = Instance.new("UICorner")
			uicorner.CornerRadius = UDim.new(0, 6)
			uicorner.Parent = drop1
			local uicorner2 = Instance.new("UICorner")
			uicorner2.CornerRadius = UDim.new(0, 6)
			uicorner2.Parent = thing
			local dropframe = Instance.new("Frame")
			dropframe.ZIndex = 3
			dropframe.Parent = drop1
			dropframe.Active = true
			dropframe.Position = UDim2.new(0, 0, 0, 0)
			dropframe.Size = UDim2.new(1, 0, 0, 0)
			dropframe.BackgroundTransparency = 0
			dropframe.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
			dropframe.Visible = false
			local uicorner3 = Instance.new("UICorner")
			uicorner3.CornerRadius = UDim.new(0, 6)
			uicorner3.Parent = dropframe
			local thing2 = thing:Clone()
			thing2.BackgroundColor3 = Color3.fromRGB(53, 52, 53)
			thing2.Parent = dropframe
			drop2.Parent = dropframe
			drop2.MouseButton1Click:Connect(function()
				dropframe.Visible = not dropframe.Visible
				hoverbox.TextSize = (dropframe.Visible and 0 or 15)
				--children.CanvasSize = UDim2.new(0, 0, 0, uilistlayout2.AbsoluteContentSize.Y + (dropframe.Visible and #dropframe:GetChildren() * 12 or 0) + 10)
			end)
			drop1.MouseButton1Click:Connect(function()
				dropframe.Visible = not dropframe.Visible
				hoverbox.TextSize = (dropframe.Visible and 0 or 15)
				--children.CanvasSize = UDim2.new(0, 0, 0, uilistlayout2.AbsoluteContentSize.Y + (dropframe.Visible and #dropframe:GetChildren() * 12 or 0) + 10)
			end)
			drop1.MouseEnter:Connect(function()
				thing.BackgroundColor3 = Color3.fromRGB(49, 48, 49)
			end)
			drop1.MouseLeave:Connect(function()
				thing.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
			end)
			frame.MouseEnter:Connect(function()
				if argstable["HoverText"] and type(argstable["HoverText"]) == "string" then
					hoverbox.Visible = (GuiLibrary["ToggleTooltips"] and hoverbox.TextSize ~= 1)
					local textsize = textService:GetTextSize(argstable["HoverText"], hoverbox.TextSize, hoverbox.Font, Vector2.new(99999, 99999))
					hoverbox.Text = " "..argstable["HoverText"]:gsub("\n", "\n ")
					hoverbox.Size = UDim2.new(0, 8 + textsize.X, 0, textsize.Y + 5)
				end
			end)
			if argstable["HoverText"] and type(argstable["HoverText"]) == "string" then
				frame.MouseMoved:Connect(function(x, y)
					hoverbox.Visible = (GuiLibrary["ToggleTooltips"] and hoverbox.TextSize ~= 1)
					hoverbox.Position = UDim2.new(0, (x + 16) * (1 / GuiLibrary["MainRescale"].Scale), 0,	(y - (hoverbox.Size.Y.Offset / 2) - 26) * (1 / GuiLibrary["MainRescale"].Scale))
				end)
			end
			frame.MouseLeave:Connect(function()
				hoverbox.Visible = false
			end)
			local placeholder = 0
			dropGuiLibrary["Value"] = (list ~= {} and list[1] or "")
			dropGuiLibrary["Default"] = dropGuiLibrary["Value"]
			dropGuiLibrary["Object"] = frame
			dropGuiLibrary["List"] = list
			dropGuiLibrary["UpdateList"] = function(val)
				placeholder = 25
				list = val
				dropGuiLibrary["List"] = val
				if not table.find(list, dropGuiLibrary["Value"]) then
					dropGuiLibrary["Value"] = list[1]
					drop1.Text = "         "..(translations[argstable["Name"]] ~= nil and translations[argstable["Name"]] or argstable["Name"]).." - "..list[1]
					dropframe.Visible = false
					argstable["Function"](list[1])
				end
				for del1, del2 in pairs(dropframe:GetChildren()) do if del2:IsA("TextButton") and del2.Name ~= "MainButton" then del2:Remove() end end
				for numbe, listobj in pairs(val) do
					if listobj == dropGuiLibrary["Value"] then continue end
					local drop2 = Instance.new("TextButton")
					dropframe.Size = UDim2.new(0, 198, 0, placeholder + 23)
					drop2.Text = "   "..listobj
					drop2.LayoutOrder = numbe
					drop2.TextColor3 = Color3.fromRGB(160, 160, 160)
					drop2.AutoButtonColor = false
					drop2.TextXAlignment = Enum.TextXAlignment.Left
					drop2.TextYAlignment = Enum.TextYAlignment.Top
					drop2.Size = UDim2.new(0, 198, 0, 19)
					drop2.Position = UDim2.new(0, 0, 0, placeholder)
					drop2.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
					drop2.Font = Enum.Font.SourceSans
					drop2.TextSize = 17
					drop2.ZIndex = 4
					drop2.BorderSizePixel = 0
					drop2.Name = listobj
					drop2.Parent = dropframe
					drop2.MouseButton1Click:Connect(function()
						hoverbox.TextSize = 15
						dropGuiLibrary["Value"] = listobj
						drop1.Text = "         "..(translations[argstable["Name"]] ~= nil and translations[argstable["Name"]] or argstable["Name"]).." - "..listobj
						dropframe.Visible = false
						--children.CanvasSize = UDim2.new(0, 0, 0, uilistlayout2.AbsoluteContentSize.Y + (dropframe.Visible and #dropframe:GetChildren() * 12 or 0) + 10)
						argstable["Function"](listobj)
						dropGuiLibrary["UpdateList"](list)
						GuiLibrary["UpdateHudEvent"]:Fire()
					end)
					drop2.MouseEnter:Connect(function()
						drop2.BackgroundColor3 = Color3.fromRGB(31, 30, 31)
					end)
					drop2.MouseLeave:Connect(function()
						drop2.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
					end)
					placeholder = placeholder + 19
				end
			end
			dropGuiLibrary["SetValue"] = function(listobj)
				dropGuiLibrary["Value"] = listobj
				drop1.Text = "         "..(translations[argstable["Name"]] ~= nil and translations[argstable["Name"]] or argstable["Name"]).." - "..listobj
				dropframe.Visible = false
				argstable["Function"](listobj)
				dropGuiLibrary["UpdateList"](list)
			end
			dropGuiLibrary["UpdateList"](list)
			GuiLibrary.ObjectsThatCanBeSaved[argstablemain["Name"]..argstable["Name"].."Dropdown"] = {["Type"] = "DropdownMain", ["Object"] = frame, ["Api"] = dropGuiLibrary}

			return dropGuiLibrary
		end

		windowapi["CreateColorSlider"] = function(argstable)
			local min, max = 0, 1
			local def = math.floor((min + max) / 2)
			local defsca = (def - min)/(max - min)
			local sliderapi = {}
			local amount2 = #children2:GetChildren()
			local frame = Instance.new("Frame")
			frame.Size = UDim2.new(0, 220, 0, 50)
			frame.BackgroundTransparency = 1
			frame.LayoutOrder = amount2
			frame.Name = argstable["Name"]
			frame.Parent = children2
			local text1 = Instance.new("TextLabel")
			text1.Font = Enum.Font.Arial
			text1.TextXAlignment = Enum.TextXAlignment.Left
			text1.Text = "          "..(translations[argstable["Name"]] ~= nil and translations[argstable["Name"]] or argstable["Name"])
			text1.Size = UDim2.new(1, 0, 0, 25)
			text1.TextColor3 = Color3.fromRGB(160, 160, 160)
			text1.Position = UDim2.new(0, 0, 0, 4)
			text1.BackgroundTransparency = 1
			text1.TextSize = 12
			text1.Parent = frame
			local text2 = Instance.new("Frame")
			text2.Size = UDim2.new(0, 12, 0, 12)
			text2.Position = UDim2.new(1, -22, 0, 9)
			text2.BackgroundColor3 = Color3.fromHSV(0.44, 1, 1)
			text2.Parent = frame
			local uicorner4 = Instance.new("UICorner")
			uicorner4.CornerRadius = UDim.new(0, 4)
			uicorner4.Parent = text2
			local slider1 = Instance.new("TextButton")
			slider1.AutoButtonColor = false
			slider1.Text = ""
			slider1.Size = UDim2.new(0, 200, 0, 2)
			slider1.BorderSizePixel = 0
			slider1.BackgroundColor3 = Color3.new(1, 1, 1)
			slider1.Position = UDim2.new(0, 10, 0, 32)
			slider1.Name = "Slider"
			slider1.Parent = frame
			local uigradient = Instance.new("UIGradient")
			uigradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 1, 1)), ColorSequenceKeypoint.new(0.1, Color3.fromHSV(0.1, 1, 1)), ColorSequenceKeypoint.new(0.2, Color3.fromHSV(0.2, 1, 1)), ColorSequenceKeypoint.new(0.3, Color3.fromHSV(0.3, 1, 1)), ColorSequenceKeypoint.new(0.4, Color3.fromHSV(0.4, 1, 1)), ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5, 1, 1)), ColorSequenceKeypoint.new(0.6, Color3.fromHSV(0.6, 1, 1)), ColorSequenceKeypoint.new(0.7, Color3.fromHSV(0.7, 1, 1)), ColorSequenceKeypoint.new(0.8, Color3.fromHSV(0.8, 1, 1)), ColorSequenceKeypoint.new(0.9, Color3.fromHSV(0.9, 1, 1)), ColorSequenceKeypoint.new(1, Color3.fromHSV(1, 1, 1))})
			uigradient.Parent = slider1
			local slider3 = Instance.new("ImageButton")
			slider3.AutoButtonColor = false
			slider3.Size = UDim2.new(0, 24, 0, 16)
			slider3.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
			slider3.BorderSizePixel = 0
			slider3.Image = downloadVapeAsset("vape/assets/SliderButton1.png")
			slider3.Position = UDim2.new(0.44, -11, 0, -7)
			slider3.Parent = slider1
			slider3.Name = "ButtonSlider"
			sliderapi["Value"] = 0.44
			sliderapi["RainbowValue"] = false
			sliderapi["Object"] = frame
			sliderapi["SetValue"] = function(val)
				val = math.clamp(val, min, max)
				text2.BackgroundColor3 = Color3.fromHSV(val, 1, 1)
				sliderapi["Value"] = val
				slider3.Position = UDim2.new(math.clamp(val, 0.02, 0.95), -9, 0, -7)
				argstable["Function"](val)
			end
			sliderapi["SetRainbow"] = function(val)
				sliderapi["RainbowValue"] = val
				if sliderapi["RainbowValue"] then
					table.insert(GuiLibrary.RainbowSliders, sliderapi)
				else
					table.remove(GuiLibrary.RainbowSliders, table.find(GuiLibrary.RainbowSliders, sliderapi))
				end
			end
			slider1.MouseButton1Down:Connect(function()
				task.spawn(function()
					click = true
					task.wait(0.3)
					click = false
				end)
				if click then
					sliderapi["SetRainbow"](not sliderapi["RainbowValue"])
				end
				local x,y,xscale,yscale,xscale2 = RelativeXY(slider1, inputService:GetMouseLocation())
				sliderapi["SetValue"](min + ((max - min) * xscale))
				slider3.Position = UDim2.new(math.clamp(xscale2, 0.02, 0.95), -9, 0, -7)
				local move
				local kill
				move = inputService.InputChanged:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseMovement then
						local x,y,xscale,yscale,xscale2 = RelativeXY(slider1, inputService:GetMouseLocation())
						sliderapi["SetValue"](min + ((max - min) * xscale))
						slider3.Position = UDim2.new(math.clamp(xscale2, 0.02, 0.95), -9, 0, -7)
					end
				end)
				kill = inputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						move:Disconnect()
						kill:Disconnect()
					end
				end)
			end)
			local clicktick = tick()
			slider3.MouseButton1Down:Connect(function()
				if clicktick > tick() then
					sliderapi["SetRainbow"](not sliderapi["RainbowValue"])
				end
				clicktick = tick() + 0.3
				local x,y,xscale,yscale,xscale2 = RelativeXY(slider1, inputService:GetMouseLocation())
				sliderapi["SetValue"](min + ((max - min) * xscale))
				slider3.Position = UDim2.new(math.clamp(xscale2, 0.02, 0.95), -9, 0, -7)
				local move
				local kill
				move = inputService.InputChanged:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseMovement then
						local x,y,xscale,yscale,xscale2 = RelativeXY(slider1, inputService:GetMouseLocation())
						sliderapi["SetValue"](min + ((max - min) * xscale))
						slider3.Position = UDim2.new(math.clamp(xscale2, 0.02, 0.95), -9, 0, -7)
					end
				end)
				kill = inputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						move:Disconnect()
						kill:Disconnect()
					end
				end)
			end)
			frame.MouseEnter:Connect(function()
				if argstable["HoverText"] and type(argstable["HoverText"]) == "string" then
					hoverbox.Visible = (GuiLibrary["ToggleTooltips"] and hoverbox.TextSize ~= 1)
					local textsize = textService:GetTextSize(argstable["HoverText"], hoverbox.TextSize, hoverbox.Font, Vector2.new(99999, 99999))
					hoverbox.Text = " "..argstable["HoverText"]:gsub("\n", "\n ")
					hoverbox.Size = UDim2.new(0, 8 + textsize.X, 0, textsize.Y + 5)
				end
			end)
			if argstable["HoverText"] and type(argstable["HoverText"]) == "string" then
				frame.MouseMoved:Connect(function(x, y)
					hoverbox.Visible = (GuiLibrary["ToggleTooltips"] and hoverbox.TextSize ~= 1)
					hoverbox.Position = UDim2.new(0, (x + 16) * (1 / GuiLibrary["MainRescale"].Scale), 0,	(y - (hoverbox.Size.Y.Offset / 2) - 26) * (1 / GuiLibrary["MainRescale"].Scale))
				end)
			end
			frame.MouseLeave:Connect(function()
				hoverbox.Visible = false
			end)
			GuiLibrary.ObjectsThatCanBeSaved[argstablemain["Name"]..argstable["Name"].."SliderColor"] = {["Type"] = "ColorSliderMain", ["Object"] = frame, ["Api"] = sliderapi}
			return sliderapi
		end

		windowapi["CreateToggle"] = function(argstable)
			local buttonapi = {}
			local currentanim
			local amount = #children2:GetChildren()
			local buttontext = Instance.new("TextButton")
			buttontext.AutoButtonColor = false
			buttontext.BackgroundTransparency = 1
			buttontext.Name = "ButtonText"
			buttontext.Text = "          "..(translations[argstable["Name"]] ~= nil and translations[argstable["Name"]] or argstable["Name"])
			buttontext.Name = argstable["Name"]
			buttontext.LayoutOrder = amount
			buttontext.Size = UDim2.new(1, 0, 0, 30)
			buttontext.Active = false
			buttontext.TextColor3 = Color3.fromRGB(160, 160, 160)
			buttontext.TextSize = 14
			buttontext.Font = Enum.Font.Arial
			buttontext.TextXAlignment = Enum.TextXAlignment.Left
			buttontext.Position = UDim2.new(0, (icon and 36 or 10), 0, 0)
			buttontext.Parent = children2
			local buttonarrow = Instance.new("ImageLabel")
			buttonarrow.Size = UDim2.new(1, 0, 0, 4)
			buttonarrow.Position = UDim2.new(0, 0, 1, -4)
			buttonarrow.BackgroundTransparency = 1
			buttonarrow.Name = "ToggleArrow"
			buttonarrow.Image = downloadVapeAsset("vape/assets/ToggleArrow.png")
			buttonarrow.Visible = false
			buttonarrow.Parent = buttontext
			local toggleframe1 = Instance.new("Frame")
			toggleframe1.Size = UDim2.new(0, 22, 0, 12)
			toggleframe1.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			toggleframe1.BorderSizePixel = 0
			toggleframe1.Name = "ToggleFrame1"
			toggleframe1.Position = UDim2.new(1, -30, 0, 10)
			toggleframe1.Parent = buttontext
			local toggleframe2 = Instance.new("Frame")
			toggleframe2.Size = UDim2.new(0, 8, 0, 8)
			toggleframe2.Active = false
			toggleframe2.Position = UDim2.new(0, 2, 0, 2)
			toggleframe2.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
			toggleframe2.BorderSizePixel = 0
			toggleframe2.Parent = toggleframe1
			local uicorner = Instance.new("UICorner")
			uicorner.CornerRadius = UDim.new(0, 16)
			uicorner.Parent = toggleframe1
			local uicorner2 = Instance.new("UICorner")
			uicorner2.CornerRadius = UDim.new(0, 16)
			uicorner2.Parent = toggleframe2

			buttonapi["Enabled"] = false
			buttonapi["Keybind"] = ""
			buttonapi["Default"] = argstable["Default"]
			buttonapi["Object"] = buttontext
			buttonapi["ToggleButton"] = function(toggle, first)
				buttonapi["Enabled"] = toggle
				if buttonapi["Enabled"] then
					if not first then
						tweenService:Create(toggleframe1, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromHSV(GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Hue"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Sat"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Value"])}):Play()
					else
						toggleframe1.BackgroundColor3 = Color3.fromHSV(GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Hue"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Sat"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Value"])
					end
					toggleframe2:TweenPosition(UDim2.new(0, 12, 0, 2), Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.1, true)
				else
					if not first then
						tweenService:Create(toggleframe1, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
					else
						toggleframe1.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
					end
					toggleframe2:TweenPosition(UDim2.new(0, 2, 0, 2), Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.1, true)
				end
				argstable["Function"](buttonapi["Enabled"])
			end
			if argstable["Default"] then
				buttonapi["ToggleButton"](argstable["Default"], true)
			end
			buttontext.MouseButton1Click:Connect(function() buttonapi["ToggleButton"](not buttonapi["Enabled"], false) end)
			buttontext.MouseEnter:Connect(function()
				if argstable["HoverText"] and type(argstable["HoverText"]) == "string" then
					hoverbox.Visible = (GuiLibrary["ToggleTooltips"] and hoverbox.TextSize ~= 1)
					local textsize = textService:GetTextSize(argstable["HoverText"], hoverbox.TextSize, hoverbox.Font, Vector2.new(99999, 99999))
					hoverbox.Text = " "..argstable["HoverText"]:gsub("\n", "\n ")
					hoverbox.Size = UDim2.new(0, 8 + textsize.X, 0, textsize.Y + 5)
				end
				if buttonapi["Enabled"] == false then
					tweenService:Create(toggleframe1, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(100, 100, 100)}):Play()
				end
			end)
			if argstable["HoverText"] and type(argstable["HoverText"]) == "string" then
				buttontext.MouseMoved:Connect(function(x, y)
					hoverbox.Visible = (GuiLibrary["ToggleTooltips"] and hoverbox.TextSize ~= 1)
					hoverbox.Position = UDim2.new(0, (x + 16) * (1 / GuiLibrary["MainRescale"].Scale), 0,	(y - (hoverbox.Size.Y.Offset / 2) - 26) * (1 / GuiLibrary["MainRescale"].Scale))
				end)
			end
			buttontext.MouseLeave:Connect(function()
				hoverbox.Visible = false
				if buttonapi["Enabled"] == false then
					tweenService:Create(toggleframe1, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
				end
			end)

			GuiLibrary.ObjectsThatCanBeSaved[argstablemain["Name"]..argstable["Name"].."Toggle"] = {["Type"] = "ToggleMain", ["Object"] = buttontext, ["Api"] = buttonapi}
			return buttonapi
		end
		
		windowapi["PinnedToggle"] = function()
			windowapi["Pinned"] = not windowapi["Pinned"]
			if windowapi["Pinned"] then
				expandbutton.ImageColor3 = Color3.fromRGB(200, 200, 200)
			else
				expandbutton.ImageColor3 = Color3.fromRGB(84, 84, 84)
			end
		end
		
		clickgui:GetPropertyChangedSignal("Visible"):Connect(windowapi["CheckVis"])
		windowapi["CheckVis"]()
		
		windowapi["GetCustomChildren"] = function()
			return children
		end
		
		expandbutton.MouseButton1Click:Connect(windowapi["PinnedToggle"])
		windowtitle.MouseButton2Click:Connect(windowapi["ExpandToggle"])
		optionsbutton.MouseButton1Click:Connect(windowapi["ExpandToggle"])
		GuiLibrary.ObjectsThatCanBeSaved[argstablemain["Name"].."CustomWindow"] = {["Object"] = windowtitle, ["ChildrenObject"] = children, ["Type"] = "CustomWindow", ["Api"] = windowapi}
		
		return windowapi
	end

	GuiLibrary["CreateWindow"] = function(argstablemain2)
		local currentexpandedbutton = nil
		local windowapi = {}
		local windowtitle = Instance.new("TextButton")
		windowtitle.Text = ""
		windowtitle.AutoButtonColor = false
		windowtitle.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
		windowtitle.Size = UDim2.new(0, 220, 0, 41)
		windowtitle.Position = UDim2.new(0, 223, 0, 6)
		windowtitle.Name = "MainWindow"
		windowtitle.Visible = false
		windowtitle.Name = argstablemain2["Name"]
		windowtitle.Parent = clickgui
		local windowshadow = Instance.new("ImageLabel")
		windowshadow.AnchorPoint = Vector2.new(0.5, 0.5)
		windowshadow.Position = UDim2.new(0.5, 0, 0.5, 0)
		windowshadow.Image = downloadVapeAsset("vape/assets/WindowBlur.png")
		windowshadow.BackgroundTransparency = 1
		windowshadow.ZIndex = -1
		windowshadow.Size = UDim2.new(1, 6, 1, 6)
		windowshadow.ImageColor3 = Color3.new(0, 0, 0)
		windowshadow.ScaleType = Enum.ScaleType.Slice
		windowshadow.SliceCenter = Rect.new(10, 10, 118, 118)
		windowshadow.Parent = windowtitle
		local windowicon = Instance.new("ImageLabel")
		windowicon.Size = UDim2.new(0, argstablemain2["IconSize"], 0, 16)
		windowicon.Image = downloadVapeAsset(argstablemain2["Icon"])
		windowicon.Name = "WindowIcon"
		windowicon.BackgroundTransparency = 1
		windowicon.Position = UDim2.new(0, 12, 0, 12)
		windowicon.ImageColor3 = Color3.fromRGB(200, 200, 200)
		windowicon.Parent = windowtitle
		local windowbackbutton = Instance.new("ImageButton")
		windowbackbutton.Size = UDim2.new(0, 16, 0, 16)
		windowbackbutton.Position = UDim2.new(0, 15, 0, 13)
		windowbackbutton.Visible = false
		windowbackbutton.BackgroundTransparency = 1
		windowbackbutton.MouseButton1Click:Connect(function()
			if currentexpandedbutton then
				currentexpandedbutton["ExpandToggle"]()
			end
		end)
		windowbackbutton.Image = downloadVapeAsset("vape/assets/BackIcon.png")
		windowbackbutton.Parent = windowtitle
		local windowtext = Instance.new("TextLabel")
		windowtext.Size = UDim2.new(0, 155, 0, 41)
		windowtext.BackgroundTransparency = 1
		windowtext.Name = "WindowTitle"
		windowtext.Position = UDim2.new(0, 36, 0, 1)
		windowtext.TextXAlignment = Enum.TextXAlignment.Left
		windowtext.Font = Enum.Font.Arial
		windowtext.TextSize = 14
		windowtext.Text = (translations[argstablemain2["Name"]] ~= nil and translations[argstablemain2["Name"]] or argstablemain2["Name"])
		windowtext.TextColor3 = Color3.fromRGB(200, 200, 200)
		windowtext.Parent = windowtitle
		local expandbutton = Instance.new("TextButton")
		expandbutton.Text = ""
		expandbutton.BackgroundTransparency = 1
		expandbutton.BorderSizePixel = 0
		expandbutton.BackgroundColor3 = Color3.new(1, 1, 1)
		expandbutton.Name = "ExpandButton"
		expandbutton.Size = UDim2.new(0, 24, 0, 16)
		expandbutton.Position = UDim2.new(1, -28, 0, 13)
		expandbutton.Parent = windowtitle
		local expandbutton2 = Instance.new("ImageLabel")
		expandbutton2.Active = false
		expandbutton2.Size = UDim2.new(0, 9, 0, 4)
		expandbutton2.Image = downloadVapeAsset("vape/assets/UpArrow.png")
		expandbutton2.Position = UDim2.new(0, 8, 0, 6)
		expandbutton2.Name = "ExpandButton2"
		expandbutton2.BackgroundTransparency = 1
		expandbutton2.Parent = expandbutton
		local children = Instance.new("ScrollingFrame")
		children.BackgroundTransparency = 1
		children.BorderSizePixel = 0
		children.ScrollBarThickness = 3
		children.ScrollBarImageTransparency = 0.8
		children.Size = UDim2.new(1, 0, 1, -45)
		children.ClipsDescendants = true
		children.Position = UDim2.new(0, 0, 0, 41)
		children.Visible = false
		children.Parent = windowtitle
		local windowcorner = Instance.new("UICorner")
		windowcorner.CornerRadius = UDim.new(0, 4)
		windowcorner.Parent = windowtitle
		local uilistlayout = Instance.new("UIListLayout")
		uilistlayout.SortOrder = Enum.SortOrder.LayoutOrder
		uilistlayout.Parent = children
		uilistlayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			if children.Visible then
				windowtitle.Size = UDim2.new(0, 220, 0, math.clamp(45 + uilistlayout.AbsoluteContentSize.Y * (1 / GuiLibrary["MainRescale"].Scale), 0, 605))
				children.CanvasSize = UDim2.new(0, 0, 0, uilistlayout.AbsoluteContentSize.Y * (1 / GuiLibrary["MainRescale"].Scale))
				--560
			end
		end)
		local noexpand = false
		dragGUI(windowtitle)
		GuiLibrary.ObjectsThatCanBeSaved[argstablemain2["Name"].."Window"] = {["Object"] = windowtitle, ["ChildrenObject"] = children, ["Type"] = "Window", ["Api"] = windowapi, ["SortOrder"] = 0}

		windowapi["SetVisible"] = function(value)
			windowtitle.Visible = value
		end

		windowapi["ExpandToggle"] = function()
			if noexpand == false then
				children.Visible = not children.Visible
				if children.Visible then
					expandbutton2.Image = downloadVapeAsset("vape/assets/DownArrow.png")
					windowtitle.Size = UDim2.new(0, 220, 0, math.clamp(45 + uilistlayout.AbsoluteContentSize.Y * (1 / GuiLibrary["MainRescale"].Scale), 0, 605))
					children.CanvasSize = UDim2.new(0, 0, 0, uilistlayout.AbsoluteContentSize.Y * (1 / GuiLibrary["MainRescale"].Scale))
				else
					expandbutton2.Image = downloadVapeAsset("vape/assets/UpArrow.png")
					windowtitle.Size = UDim2.new(0, 220, 0, 41)
				end
			end
		end

		windowtitle.MouseButton2Click:Connect(windowapi["ExpandToggle"])
		expandbutton.MouseButton1Click:Connect(windowapi["ExpandToggle"])
		expandbutton.MouseButton2Click:Connect(windowapi["ExpandToggle"])

		windowapi["CreateOptionsButton"] = function(argstablemain)
			local buttonapi = {}
			local amount = #children:GetChildren()
			local button = Instance.new("TextButton")
			local currenttween = tweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(31, 30, 31)})
			button.Name = argstablemain["Name"].."Button"
			button.AutoButtonColor = false
			button.Size = UDim2.new(1, 0, 0, 40)
			button.BorderSizePixel = 0
			button.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
			button.Text = ""
			--button.LayoutOrder = amount
			button.Parent = children
			local buttonactiveborder = Instance.new("Frame")
			buttonactiveborder.BackgroundTransparency = 0.75
			buttonactiveborder.BackgroundColor3 = Color3.new(0, 0, 0)
			buttonactiveborder.BorderSizePixel = 0
			buttonactiveborder.Size = UDim2.new(1, 0, 0, 1)
			buttonactiveborder.Position = UDim2.new(0, 0, 1, -1)
			buttonactiveborder.Visible = false
			buttonactiveborder.Parent = button
			local button2 = Instance.new("ImageButton")
			button2.BackgroundTransparency = 1
			button2.Size = UDim2.new(0, 10, 0, 20)
			button2.Position = UDim2.new(1, -24, 0, 10)
			button2.Name = "OptionsButton"
			button2.Image = downloadVapeAsset("vape/assets/MoreButton1.png")
			button2.Parent = button
			local buttontext = Instance.new("TextLabel")
			buttontext.BackgroundTransparency = 1
			buttontext.Name = "ButtonText"
			buttontext.Text = (translations[argstablemain["Name"]] ~= nil and translations[argstablemain["Name"]] or argstablemain["Name"])
			buttontext.Size = UDim2.new(0, 118, 0, 39)
			buttontext.Active = false
			buttontext.TextColor3 = Color3.fromRGB(160, 160, 160)
			buttontext.TextSize = 14
			buttontext.Font = Enum.Font.Arial
			buttontext.TextXAlignment = Enum.TextXAlignment.Left
			buttontext.Position = UDim2.new(0, 12, 0, 1)
			buttontext.Parent = button
			local children2 = Instance.new("Frame")
			children2.Size = UDim2.new(1, 0, 0, 0)
			children2.BorderSizePixel = 0
			children2.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		--	children2.LayoutOrder = amount
			children2.Visible = false
			children2.Name = argstablemain["Name"].."Children"
			children2.Parent = children
			local uilistlayout2 = Instance.new("UIListLayout")
			uilistlayout2.SortOrder = Enum.SortOrder.LayoutOrder
			uilistlayout2.Parent = children2
			uilistlayout2:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				children2.Size = UDim2.new(0, 220, 0, uilistlayout2.AbsoluteContentSize.Y * (1 / GuiLibrary["MainRescale"].Scale))
				--if children2.Visible then
					--windowtitle.Size = UDim2.new(0, 220, 0, math.clamp(85 + (uilistlayout2.AbsoluteContentSize.Y * (1 / GuiLibrary["MainRescale"].Scale)), 0, 605))
					--children.CanvasSize = UDim2.new(0, 0, 0, (uilistlayout2.AbsoluteContentSize.Y + (40 * GuiLibrary["MainRescale"].Scale)) * (1 / GuiLibrary["MainRescale"].Scale))
				--end
			end)
			local bindbkg = Instance.new("TextButton")
			bindbkg.Text = ""
			bindbkg.AutoButtonColor = false
			bindbkg.Size = UDim2.new(0, 20, 0, 21)
			bindbkg.Position = UDim2.new(1, -56, 0, 9)
			bindbkg.BorderSizePixel = 0
			bindbkg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			bindbkg.BackgroundTransparency = 0.95
			bindbkg.Visible = false
			bindbkg.Parent = button
			local bindbkg2 = bindbkg:Clone()
			bindbkg2.BackgroundTransparency = 1
			bindbkg2.ZIndex = 2
			bindbkg2.Text = "x"
			bindbkg2.TextColor3 = Color3.fromRGB(88, 88, 88)
			bindbkg2.Parent = button
			local bindimg = Instance.new("ImageLabel")
			bindimg.Image = downloadVapeAsset("vape/assets/KeybindIcon.png")
			bindimg.BackgroundTransparency = 1
			bindimg.ImageColor3 = Color3.fromRGB(88, 88, 88)
			bindimg.Size = UDim2.new(0, 12, 0, 12)
			bindimg.Position = UDim2.new(0, 4, 0, 5)
			bindimg.Active = false
			bindimg.Parent = bindbkg
			local bindtext = Instance.new("TextLabel")
			bindtext.Active = false
			bindtext.BackgroundTransparency = 1
			bindtext.Text = ""
			bindtext.TextSize = 14
			bindtext.Parent = bindbkg
			bindtext.Font = Enum.Font.Arial
			bindtext.Size = UDim2.new(1, 0, 1, 0)
			bindtext.TextColor3 = Color3.fromRGB(85, 85, 85)
			bindtext.Visible = false
			local bindtext2 = Instance.new("ImageLabel")
			bindtext2.Size = UDim2.new(0, 156, 0, 39)
			bindtext2.Image = downloadVapeAsset("vape/assets/BindBackground.png")
			bindtext2.BackgroundTransparency = 1
			bindtext2.ScaleType = Enum.ScaleType.Slice
			bindtext2.SliceCenter = Rect.new(0, 0, 140, 40)
			bindtext2.Visible = false
			bindtext2.Parent = button
			local bindtext3 = Instance.new("TextLabel")
			bindtext3.Text = "   PRESS  KEY TO BIND"
			bindtext3.Size = UDim2.new(1, 0, 1, 0)
			bindtext3.Font = Enum.Font.Arial
			bindtext3.TextXAlignment = Enum.TextXAlignment.Left
			bindtext3.TextSize = 14
			bindtext3.TextColor3 = Color3.fromRGB(44, 44, 44)
			bindtext3.BackgroundTransparency = 1
			bindtext3.BorderSizePixel = 0
			bindtext3.Parent = bindtext2
			local bindround = Instance.new("UICorner")
			bindround.CornerRadius = UDim.new(0, 6)
			bindround.Parent = bindbkg
			if argstablemain["HoverText"] and type(argstablemain["HoverText"]) == "string" then
				button.MouseEnter:Connect(function() 
					hoverbox.Visible = (GuiLibrary["ToggleTooltips"] and hoverbox.TextSize ~= 1)
					local textsize = textService:GetTextSize(argstablemain["HoverText"], hoverbox.TextSize, hoverbox.Font, Vector2.new(99999, 99999))
					hoverbox.Text = " "..argstablemain["HoverText"]:gsub("\n", "\n ")
					hoverbox.Size = UDim2.new(0, 8 + textsize.X, 0, textsize.Y + 5)
				end)
				button.MouseMoved:Connect(function(x, y)
					hoverbox.Visible = (GuiLibrary["ToggleTooltips"] and hoverbox.TextSize ~= 1)
					hoverbox.Position = UDim2.new(0, (x + 16) * (1 / GuiLibrary["MainRescale"].Scale), 0,	(y - (hoverbox.Size.Y.Offset / 2) - 26) * (1 / GuiLibrary["MainRescale"].Scale))
				end)
			end
			buttonapi["Enabled"] = false
			buttonapi["Keybind"] = ""
			buttonapi["HoverText"] = argstablemain["HoverText"]
			buttonapi["Children"] = children2
			buttonapi["Name"] = argstablemain["Name"]
			buttonapi["HasExtraText"] = type(argstablemain["ExtraText"]) == "function"
			buttonapi["GetExtraText"] = (buttonapi["HasExtraText"] and argstablemain["ExtraText"] or function() return "" end)
			buttonapi.Connections = {}
			local newsize = UDim2.new(0, 20, 0, 21)
			
			buttonapi["SetKeybind"] = function(key)
				if key == "" then
					buttonapi["Keybind"] = key
					newsize = UDim2.new(0, 20, 0, 21)
					bindbkg.Size = newsize
					bindbkg.Visible = true
					bindbkg.Position = UDim2.new(1, -(36 + newsize.X.Offset), 0, 9)
					bindimg.Visible = true
					bindtext.Visible = false
					bindtext.Text = key
				else
					local textsize = textService:GetTextSize(key, 16, bindtext.Font, Vector2.new(99999, 99999))
					newsize = UDim2.new(0, 11 + textsize.X, 0, 21)
					buttonapi["Keybind"] = key
					bindbkg.Visible = true
					bindbkg.Size = newsize
					bindbkg.Position = UDim2.new(1, -(36 + newsize.X.Offset), 0, 9)
					bindimg.Visible = false
					bindtext.Visible = true
					bindtext.Text = key
				end
			end

			buttonapi["ToggleButton"] = function(clicked, toggle)
				buttonapi["Enabled"] = (toggle or not buttonapi["Enabled"])
				if buttonapi["Enabled"] then
					button.BackgroundColor3 = Color3.fromHSV(GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Hue"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Sat"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Value"])
					currenttween:Cancel()
					buttonactiveborder.Visible = true
					button2.Image = downloadVapeAsset("vape/assets/MoreButton2.png")
					buttontext.TextColor3 = Color3.new(0, 0, 0)
					bindbkg.BackgroundTransparency = 0.9
					bindtext.TextColor3 = Color3.fromRGB(45, 45, 45)
					bindimg.ImageColor3 = Color3.fromRGB(45, 45, 45)
				else
					for i, v in pairs(buttonapi.Connections) do
						if v.Disconnect then pcall(function() v:Disconnect() end) continue end
						if v.disconnect then pcall(function() v:disconnect() end) continue end
					end
					table.clear(buttonapi.Connections)
					button.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
					buttonactiveborder.Visible = false
					button2.Image = downloadVapeAsset("vape/assets/MoreButton1.png")
					buttontext.TextColor3 = Color3.fromRGB(160, 160, 160)
					bindbkg.BackgroundTransparency = 0.95
					bindtext.TextColor3 = Color3.fromRGB(88, 88, 88)
					bindimg.ImageColor3 = Color3.fromRGB(88, 88, 88)
				end
				argstablemain["Function"](buttonapi["Enabled"])
				GuiLibrary["UpdateHudEvent"]:Fire()
			end

			buttonapi["ExpandToggle"] = function()
				children2.Visible = not children2.Visible
				--[[
				if children2.Visible then
					for i,v in pairs(children:GetChildren()) do
						if v:IsA("TextButton") then
							v.Visible = true
						end
					end	
					windowicon.Visible = true
					windowbackbutton.Visible = false
					children2.Visible = false
					noexpand = false
					windowtitle.Size = UDim2.new(0, 220, 0, math.clamp(45 + uilistlayout.AbsoluteContentSize.Y * (1 / GuiLibrary["MainRescale"].Scale), 0, 605))
					children.CanvasSize = UDim2.new(0, 0, 0, uilistlayout.AbsoluteContentSize.Y * (1 / GuiLibrary["MainRescale"].Scale))
				else
					for i,v in pairs(children:GetChildren()) do
						if v:IsA("TextButton") then
							v.Visible = false
						end
					end
					windowicon.Visible = false
					windowbackbutton.Visible = true
					button.Visible = true
					children2.Visible = true
					noexpand = true
					--windowtitle.Size = UDim2.new(0, 220, 0, 85 + uilistlayout2.AbsoluteContentSize.Y * (1 / GuiLibrary["MainRescale"].Scale))
					windowtitle.Size = UDim2.new(0, 220, 0, math.clamp(85 + (uilistlayout2.AbsoluteContentSize.Y * (1 / GuiLibrary["MainRescale"].Scale)), 0, 605))
					children.CanvasSize = UDim2.new(0, 0, 0, (uilistlayout2.AbsoluteContentSize.Y + (40 * GuiLibrary["MainRescale"].Scale)) * (1 / GuiLibrary["MainRescale"].Scale))
					currentexpandedbutton = buttonapi
				end]]
			end

			buttonapi["CreateTextList"] = function(argstable)
				local textGuiLibrary = {}
				local amount = #children2:GetChildren()
				local frame = Instance.new("Frame")
				frame.Size = UDim2.new(0, 220, 0, 40)
				frame.BackgroundTransparency = 1
				frame.ClipsDescendants = true
				frame.LayoutOrder = amount
				frame.Name = argstable["Name"]
				frame.Parent = children2
				local textboxbkg = Instance.new("ImageLabel")
				textboxbkg.BackgroundTransparency = 1
				textboxbkg.Name = "AddBoxBKG"
				textboxbkg.Size = UDim2.new(0, 200, 0, 31)
				textboxbkg.Position = UDim2.new(0, 10, 0, 5)
				textboxbkg.ClipsDescendants = true
				textboxbkg.Image = downloadVapeAsset("vape/assets/TextBoxBKG.png")
				textboxbkg.Parent = frame
				local textbox = Instance.new("TextBox")
				textbox.Size = UDim2.new(0, 159, 1, 0)
				textbox.Position = UDim2.new(0, 11, 0, 0)
				textbox.TextXAlignment = Enum.TextXAlignment.Left
				textbox.Name = "AddBox"
				textbox.BackgroundTransparency = 1
				textbox.TextColor3 = Color3.new(1, 1, 1)
				textbox.PlaceholderColor3 = Color3.fromRGB(200, 200, 200)
				textbox.Font = Enum.Font.SourceSans
				textbox.Text = ""
				textbox.PlaceholderText = argstable["TempText"]
				textbox.TextSize = 17
				textbox.Parent = textboxbkg
				local addbutton = Instance.new("ImageButton")
				addbutton.BorderSizePixel = 0
				addbutton.Name = "AddButton"
				addbutton.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
				addbutton.Position = UDim2.new(0, 174, 0, 8)
				addbutton.AutoButtonColor = false
				addbutton.Size = UDim2.new(0, 16, 0, 16)
				addbutton.ImageColor3 = Color3.fromHSV(0.44, 1, 1)
				addbutton.Image = downloadVapeAsset("vape/assets/AddItem.png")
				addbutton.Parent = textboxbkg
				local scrollframebkg = Instance.new("Frame")
				scrollframebkg.ZIndex = 2
				scrollframebkg.Name = "ScrollingFrameBKG"
				scrollframebkg.Size = UDim2.new(0, 220, 0, 3)
				scrollframebkg.BackgroundTransparency = 1
				scrollframebkg.LayoutOrder = amount
				scrollframebkg.Parent = children2
				local scrollframe = Instance.new("ScrollingFrame")
				scrollframe.ZIndex = 2
				scrollframe.Size = UDim2.new(0, 200, 0, 3)
				scrollframe.Position = UDim2.new(0, 10, 0, 0)
				scrollframe.BackgroundTransparency = 1
				scrollframe.ScrollBarThickness = 0
				scrollframe.ScrollBarImageColor3 = Color3.new(0, 0, 0)
				scrollframe.LayoutOrder = amount
				scrollframe.Parent = scrollframebkg
				local uilistlayout3 = Instance.new("UIListLayout")
				uilistlayout3.Padding = UDim.new(0, 3)
				uilistlayout3.Parent = scrollframe
				uilistlayout3:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
					scrollframe.CanvasSize = UDim2.new(0, 0, 0, uilistlayout3.AbsoluteContentSize.Y)
					scrollframe.Size = UDim2.new(0, 220, 0, math.clamp(uilistlayout3.AbsoluteContentSize.Y, 1, 105))
					scrollframebkg.Size = UDim2.new(0, 220, 0, math.clamp(uilistlayout3.AbsoluteContentSize.Y, 1, 105) + 3)
				end)
		
				textGuiLibrary["Object"] = frame
				textGuiLibrary["ScrollingObject"] = scrollframebkg
				textGuiLibrary["ObjectList"] = {}
				textGuiLibrary["RefreshValues"] = function(tab)
					textGuiLibrary["ObjectList"] = tab
					if argstable["SortFunction"] then
						table.sort(textGuiLibrary["ObjectList"], argstable["SortFunction"])
					end
					for i2,v2 in pairs(scrollframe:GetChildren()) do
						if v2:IsA("TextButton") then v2:Remove() end
					end
					for i,v in pairs(textGuiLibrary["ObjectList"]) do
						local itemframe = Instance.new("TextButton")
						itemframe.Size = UDim2.new(0, 200, 0, 33)
						itemframe.BackgroundColor3 = Color3.fromRGB(31, 30, 31)
						itemframe.BorderSizePixel = 0
						itemframe.Text = ""
						itemframe.AutoButtonColor = false
						itemframe.Parent = scrollframe
						local itemcorner = Instance.new("UICorner")
						itemcorner.CornerRadius = UDim.new(0, 6)
						itemcorner.Parent = itemframe
						local itemtext = Instance.new("TextLabel")
						itemtext.BackgroundTransparency = 1
						itemtext.Size = UDim2.new(0, 193, 0, 33)
						itemtext.Name = "ItemText"
						itemtext.Position = UDim2.new(0, 8, 0, 0)
						itemtext.Font = Enum.Font.SourceSans
						itemtext.TextSize = 17
						itemtext.Text = v
						itemtext.TextXAlignment = Enum.TextXAlignment.Left
						itemtext.TextColor3 = Color3.fromRGB(86, 85, 86)
						itemtext.Parent = itemframe
						local deletebutton = Instance.new("ImageButton")
						deletebutton.Size = UDim2.new(0, 6, 0, 6)
						deletebutton.BackgroundTransparency = 1
						deletebutton.AutoButtonColor = false
						deletebutton.ZIndex = 1
						deletebutton.Image = downloadVapeAsset("vape/assets/AddRemoveIcon1.png")
						deletebutton.Position = UDim2.new(1, -16, 0, 14)
						deletebutton.Parent = itemframe
						deletebutton.MouseButton1Click:Connect(function()
							table.remove(textGuiLibrary["ObjectList"], table.find(textGuiLibrary["ObjectList"], v))
							textGuiLibrary["RefreshValues"](textGuiLibrary["ObjectList"])
							if argstable["RemoveFunction"] then
								argstable["RemoveFunction"](i, v)
							end
						end)
						if argstable["CustomFunction"] then
							argstable["CustomFunction"](itemframe)
						end
					end
				end

                local function AddToList() 
					table.insert(textGuiLibrary["ObjectList"], textbox.Text)
					textGuiLibrary["RefreshValues"](textGuiLibrary["ObjectList"])
					if argstable["AddFunction"] then
						argstable["AddFunction"](textbox.Text) 
					end
                    textbox.Text = ""
				end

				addbutton.MouseButton1Click:Connect(AddToList)
                textbox.FocusLost:Connect(function(enter)
                    if enter then
                        AddToList()
                        textbox:CaptureFocus()
                    end
                end)

				GuiLibrary.ObjectsThatCanBeSaved[argstablemain["Name"]..argstable["Name"].."TextList"] = {["Type"] = "TextList", ["Api"] = textGuiLibrary}
				return textGuiLibrary
			end

			buttonapi["CreateTextBox"] = function(argstable)
				local textGuiLibrary = {}
				local amount = #children2:GetChildren()
				local frame = Instance.new("Frame")
				frame.Size = UDim2.new(0, 220, 0, 40)
				frame.BackgroundTransparency = 1
				frame.ClipsDescendants = true
				frame.LayoutOrder = amount
				frame.Name = argstable["Name"]
				frame.Parent = children2
				local textboxbkg = Instance.new("ImageLabel")
				textboxbkg.BackgroundTransparency = 1
				textboxbkg.Name = "AddBoxBKG"
				textboxbkg.Size = UDim2.new(0, 200, 0, 31)
				textboxbkg.Position = UDim2.new(0, 10, 0, 5)
				textboxbkg.ClipsDescendants = true
				textboxbkg.Image = downloadVapeAsset("vape/assets/TextBoxBKG.png")
				textboxbkg.Parent = frame
				local textbox = Instance.new("TextBox")
				textbox.Size = UDim2.new(0, 159, 1, 0)
				textbox.Position = UDim2.new(0, 11, 0, 0)
				textbox.TextXAlignment = Enum.TextXAlignment.Left
				textbox.Name = "AddBox"
				textbox.ClearTextOnFocus = false
				textbox.BackgroundTransparency = 1
				textbox.TextColor3 = Color3.new(1, 1, 1)
				textbox.PlaceholderColor3 = Color3.fromRGB(200, 200, 200)
				textbox.Font = Enum.Font.SourceSans
				textbox.Text = ""
				textbox.PlaceholderText = argstable["TempText"]
				textbox.TextSize = 17
				textbox.Parent = textboxbkg
				
				textGuiLibrary["Object"] = frame
				textGuiLibrary["Value"] = ""
				textGuiLibrary["SetValue"] = function(val, entered)
					textGuiLibrary["Value"] = val
					textbox.Text = val
					if argstable["FocusLost"] and (not entered) then
						argstable["FocusLost"](false)
					end
				end

				textbox.FocusLost:Connect(function(enter) 
					textGuiLibrary["SetValue"](textbox.Text, true)
					if argstable["FocusLost"] then
						argstable["FocusLost"](enter)
					end
				end)

				GuiLibrary.ObjectsThatCanBeSaved[argstablemain["Name"]..argstable["Name"].."TextBox"] = {["Type"] = "TextBox", ["Api"] = textGuiLibrary, ["Object"] = frame}
				return textGuiLibrary
			end

			buttonapi["CreateTargetWindow"] = function(argstablemain3)
				local buttonapi = {}
				local buttonreturned = {}
				local windowapi = {}
				local amount2 = #children2:GetChildren()
				local frame = Instance.new("Frame")
				frame.Size = UDim2.new(0, 220, 0, 49)
				frame.BackgroundTransparency = 1
				frame.LayoutOrder = amount2
				frame.Name = argstablemain["Name"].."TargetFrame"
				frame.Parent = children2
				local drop1 = Instance.new("TextButton")
				drop1.AutoButtonColor = false
				drop1.Size = UDim2.new(0, 198, 0, 39)
				drop1.Position = UDim2.new(0, 11, 0, 5)
				drop1.Parent = frame
				drop1.BorderSizePixel = 0
				drop1.ZIndex = 2
				drop1.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
				drop1.TextSize = 17
				drop1.TextXAlignment = Enum.TextXAlignment.Left
				drop1.Text = ""
				local targettext = Instance.new("TextLabel")
				targettext.Size = UDim2.new(1, 0, 1, 0)
				targettext.Position = UDim2.new(0, 0, 0, 0)
				targettext.BackgroundTransparency = 1
				targettext.ZIndex = 2
				targettext.TextSize = 17
				targettext.RichText = true
				targettext.TextColor3 = Color3.new(205, 205, 205)
				targettext.Text = "  Target : \n "..'<font color="rgb(151, 151, 151)">Ignore none</font>'
				targettext.Font = Enum.Font.SourceSans
				targettext.TextXAlignment = Enum.TextXAlignment.Left
				targettext.Parent = drop1
				local targetframe = Instance.new("Frame")
				targetframe.Size = UDim2.new(0, 100, 0, 12)
				targetframe.BackgroundTransparency = 1
				targetframe.Position = UDim2.new(0, 53, 0, 6)
				targetframe.ZIndex = 3
				targetframe.Parent = targettext
				local targetlistlayout = Instance.new("UIListLayout")
				targetlistlayout.FillDirection = Enum.FillDirection.Horizontal
				targetlistlayout.SortOrder = Enum.SortOrder.LayoutOrder
				targetlistlayout.Padding = UDim.new(0, 4)
				targetlistlayout.Parent = targetframe
				local thing = Instance.new("Frame")
				thing.Size = UDim2.new(1, 2, 1, 2)
				thing.BorderSizePixel = 0
				thing.Position = UDim2.new(0, -1, 0, -1)
				thing.ZIndex = 1
				thing.BackgroundColor3 = Color3.fromRGB(38, 37, 38)
				thing.Parent = drop1
				local uicorner = Instance.new("UICorner")
				uicorner.CornerRadius = UDim.new(0, 4)
				uicorner.Parent = drop1
				local uicorner2 = Instance.new("UICorner")
				uicorner2.CornerRadius = UDim.new(0, 4)
				uicorner2.Parent = thing
				local windowtitle = Instance.new("TextButton")
				windowtitle.Text = ""
				windowtitle.AutoButtonColor = false
				windowtitle.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
				windowtitle.Size = UDim2.new(0, 220, 0, 41)
				windowtitle.Position = UDim2.new(1, 1, 0, 0)
				windowtitle.Name = argstablemain["Name"].."TargetWindow"
				windowtitle.Visible = false
				windowtitle.ZIndex = 3
				windowtitle.Parent = clickgui
				frame:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
					windowtitle.Position = UDim2.new(0, frame.Size.X.Offset + frame.AbsolutePosition.X + 2, 0, frame.AbsolutePosition.Y)
				end)
				local windowshadow = Instance.new("ImageLabel")
				windowshadow.AnchorPoint = Vector2.new(0.5, 0.5)
				windowshadow.Position = UDim2.new(0.5, 0, 0.5, 0)
				windowshadow.Image = downloadVapeAsset("vape/assets/WindowBlur.png")
				windowshadow.BackgroundTransparency = 1
				windowshadow.ZIndex = -1
				windowshadow.Size = UDim2.new(1, 6, 1, 6)
				windowshadow.ImageColor3 = Color3.new(0, 0, 0)
				windowshadow.ScaleType = Enum.ScaleType.Slice
				windowshadow.SliceCenter = Rect.new(10, 10, 118, 118)
				windowshadow.Parent = windowtitle
				local windowicon = Instance.new("ImageLabel")
				windowicon.Size = UDim2.new(0, 18, 0, 16)
				windowicon.Image = downloadVapeAsset("vape/assets/TargetIcon.png")
				windowicon.ImageColor3 = Color3.fromRGB(200, 200, 200)
				windowicon.ZIndex = 3
				windowicon.Name = "WindowIcon"
				windowicon.BackgroundTransparency = 1
				windowicon.Position = UDim2.new(0, 12, 0, 12)
				windowicon.Parent = windowtitle
				local windowtext = Instance.new("TextLabel")
				windowtext.Size = UDim2.new(0, 155, 0, 41)
				windowtext.BackgroundTransparency = 1
				windowtext.Name = "WindowTitle"
				windowtext.Position = UDim2.new(0, 36, 0, 1)
				windowtext.ZIndex = 3
				windowtext.TextXAlignment = Enum.TextXAlignment.Left
				windowtext.Font = Enum.Font.Arial
				windowtext.TextSize = 14
				windowtext.Text = "Target settings"
				windowtext.TextColor3 = Color3.fromRGB(200, 200, 200)
				windowtext.Parent = windowtitle
				local children = Instance.new("Frame")
				children.BackgroundTransparency = 1
				children.Size = UDim2.new(1, 0, 1, -4)
				children.ZIndex = 3
				children.Position = UDim2.new(0, 0, 0, 41)
				children.Visible = true
				children.Parent = windowtitle
				local buttonframeholder = Instance.new("Frame")
				buttonframeholder.BackgroundTransparency = 1
				buttonframeholder.Size = UDim2.new(1, 0, 0, 40)
				buttonframeholder.LayoutOrder = 0
				buttonframeholder.Parent = children
				local windowcorner = Instance.new("UICorner")
				windowcorner.CornerRadius = UDim.new(0, 4)
				windowcorner.Parent = windowtitle
				local uilistlayout = Instance.new("UIListLayout")
				uilistlayout.SortOrder = Enum.SortOrder.LayoutOrder
				uilistlayout.Parent = children
				uilistlayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
					windowtitle.Size = UDim2.new(0, 220, 0, 45 + uilistlayout.AbsoluteContentSize.Y)
				end)

				buttonreturned["Invisible"] = {["Enabled"] = false}
				buttonreturned["Naked"] = {["Enabled"] = false}
				buttonreturned["Walls"] = {["Enabled"] = false}

				windowapi["UpdateIgnore"] = function()
					if argstablemain3["UpdateFunction"] then
						argstablemain3["UpdateFunction"]()
					end
					targettext.Text = "  Target : \n "..'<font size="'..(buttonreturned["Invisible"]["Enabled"] and buttonreturned["Naked"]["Enabled"] and buttonreturned["Walls"]["Enabled"] and 14 or 17)..'" color="rgb(151, 151, 151)">'.."Ignore "..((buttonreturned["Invisible"]["Enabled"] or buttonreturned["Naked"]["Enabled"] or buttonreturned["Walls"]["Enabled"]) and "" or "none")..(buttonreturned["Invisible"]["Enabled"] and "invisible" or "")..(buttonreturned["Naked"]["Enabled"] and ((buttonreturned["Invisible"]["Enabled"]) and ", " or "").."naked" or "")..(buttonreturned["Walls"]["Enabled"] and ((buttonreturned["Invisible"]["Enabled"] or buttonreturned["Naked"]["Enabled"]) and ", " or "").."behind walls" or "")..'</font>'
				end

				windowapi["CreateToggle"] = function(argstable)
					local buttonapi = {}
					local currentanim
					local amount = #children2:GetChildren()
					local buttontext = Instance.new("TextButton")
					buttontext.AutoButtonColor = false
					buttontext.BackgroundTransparency = 1
					buttontext.Name = "ButtonText"
					buttontext.Text = "          "..(translations[argstable["Name"]] ~= nil and translations[argstable["Name"]] or argstable["Name"])
					buttontext.Name = argstable["Name"]
					buttontext.LayoutOrder = amount
					buttontext.Size = UDim2.new(1, 0, 0, 30)
					buttontext.Active = false
					buttontext.TextColor3 = Color3.fromRGB(160, 160, 160)
					buttontext.TextSize = 14
					buttontext.ZIndex = 3
					buttontext.Font = Enum.Font.Arial
					buttontext.TextXAlignment = Enum.TextXAlignment.Left
					buttontext.Position = UDim2.new(0, (icon and 36 or 10), 0, 0)
					buttontext.Parent = children
					local buttonarrow = Instance.new("ImageLabel")
					buttonarrow.Size = UDim2.new(1, 0, 0, 4)
					buttonarrow.Position = UDim2.new(0, 0, 1, -4)
					buttonarrow.BackgroundTransparency = 1
					buttonarrow.Name = "ToggleArrow"
					buttonarrow.ZIndex = 3
					buttonarrow.Image = downloadVapeAsset("vape/assets/ToggleArrow.png")
					buttonarrow.Visible = false
					buttonarrow.Parent = buttontext
					local toggleframe1 = Instance.new("Frame")
					toggleframe1.Size = UDim2.new(0, 22, 0, 12)
					toggleframe1.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
					toggleframe1.BorderSizePixel = 0
					toggleframe1.ZIndex = 3
					toggleframe1.Name = "ToggleFrame1"
					toggleframe1.Position = UDim2.new(1, -30, 0, 10)
					toggleframe1.Parent = buttontext
					local toggleframe2 = Instance.new("Frame")
					toggleframe2.Size = UDim2.new(0, 8, 0, 8)
					toggleframe2.Active = false
					toggleframe2.ZIndex = 3
					toggleframe2.Position = UDim2.new(0, 2, 0, 2)
					toggleframe2.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
					toggleframe2.BorderSizePixel = 0
					toggleframe2.Parent = toggleframe1
					local uicorner = Instance.new("UICorner")
					uicorner.CornerRadius = UDim.new(0, 16)
					uicorner.Parent = toggleframe1
					local uicorner2 = Instance.new("UICorner")
					uicorner2.CornerRadius = UDim.new(0, 16)
					uicorner2.Parent = toggleframe2

					buttonapi["Enabled"] = false
					buttonapi["Keybind"] = ""
					buttonapi["Default"] = argstable["Default"]
					buttonapi["Object"] = buttontext
					buttonapi["ToggleButton"] = function(toggle, first)
						buttonapi["Enabled"] = toggle
						if buttonapi["Enabled"] then
							if not first then
								tweenService:Create(toggleframe1, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromHSV(GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Hue"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Sat"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Value"])}):Play()
							else
								toggleframe1.BackgroundColor3 = Color3.fromHSV(GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Hue"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Sat"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Value"])
							end
							toggleframe2:TweenPosition(UDim2.new(0, 12, 0, 2), Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.1, true)
						else
							if not first then
								tweenService:Create(toggleframe1, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
							else
								toggleframe1.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
							end
							toggleframe2:TweenPosition(UDim2.new(0, 2, 0, 2), Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.1, true)
						end
						argstable["Function"](buttonapi["Enabled"])
					end
					if argstable["Default"] then
						buttonapi["ToggleButton"](argstable["Default"], true)
					end
					buttontext.MouseButton1Click:Connect(function() buttonapi["ToggleButton"](not buttonapi["Enabled"], false) end)
					buttontext.MouseEnter:Connect(function()
						if argstable["HoverText"] and type(argstable["HoverText"]) == "string" then
							hoverbox.Visible = (GuiLibrary["ToggleTooltips"] and hoverbox.TextSize ~= 1)
							local textsize = textService:GetTextSize(argstable["HoverText"], hoverbox.TextSize, hoverbox.Font, Vector2.new(99999, 99999))
							hoverbox.Text = "  "..argstable["HoverText"]:gsub("\n", "\n  ")
							hoverbox.Size = UDim2.new(0, 13 + textsize.X, 0, textsize.Y + 5)
						end
						if buttonapi["Enabled"] == false then
							tweenService:Create(toggleframe1, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(100, 100, 100)}):Play()
						end
					end)
					if argstable["HoverText"] and type(argstable["HoverText"]) == "string" then
						buttontext.MouseMoved:Connect(function(x, y)
							hoverbox.Visible = (GuiLibrary["ToggleTooltips"] and hoverbox.TextSize ~= 1)
							hoverbox.Position = UDim2.new(0, (x + 16) * (1 / GuiLibrary["MainRescale"].Scale), 0,	(y - (hoverbox.Size.Y.Offset / 2) - 26) * (1 / GuiLibrary["MainRescale"].Scale))
						end)
					end
					buttontext.MouseLeave:Connect(function()
						hoverbox.Visible = false
						if buttonapi["Enabled"] == false then
							tweenService:Create(toggleframe1, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
						end
					end)
			
					GuiLibrary.ObjectsThatCanBeSaved[argstablemain["Name"]..argstable["Name"].."TargetToggle"] = {["Type"] = "Toggle", ["Object"] = buttontext, ["Api"] = buttonapi}
					return buttonapi
				end

				windowapi["CreateButton"] = function(argstable)
					local buttonapi = {}
					local amount = #children:GetChildren()
					local buttontext = Instance.new("TextButton")
					buttontext.Name = argstablemain["Name"]..argstable["Name"].."TargetButton"
					buttontext.LayoutOrder = amount
					buttontext.AutoButtonColor = false
					buttontext.Size = UDim2.new(0, 45, 0, 29)
					buttontext.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
					buttontext.Active = false
					buttontext.Text = ""
					buttontext.ZIndex = 4
					buttontext.Font = Enum.Font.SourceSans
					buttontext.TextXAlignment = Enum.TextXAlignment.Left
					buttontext.Position = argstable["Position"]
					buttontext.Parent = buttonframeholder
					local buttonbkg = Instance.new("Frame")
					buttonbkg.BackgroundColor3 = Color3.fromRGB(38, 37, 38)
					buttonbkg.Size = UDim2.new(0, 47, 0, 31)
					buttonbkg.Position = argstable["Position"] - UDim2.new(0, 1, 0, 1)
					buttonbkg.ZIndex = 3
					buttonbkg.Parent = buttonframeholder
					local buttonimage = Instance.new("ImageLabel")
					buttonimage.BackgroundTransparency = 1
					buttonimage.Position = UDim2.new(0, 14, 0, 7)
					buttonimage.Size = UDim2.new(0, argstable["IconSize"], 0, 16)
					buttonimage.Image = downloadVapeAsset(argstable["Icon"])
					buttonimage.ImageColor3 = Color3.fromRGB(121, 121, 121)
					buttonimage.ZIndex = 5
					buttonimage.Active = false
					buttonimage.Parent = buttontext
					local buttontexticon = Instance.new("ImageLabel")
					buttontexticon.Size = UDim2.new(0, argstable["IconSize"] - 3, 0, 12)
					buttontexticon.Image = downloadVapeAsset(argstable["Icon"])
					buttontexticon.LayoutOrder = amount
					buttontexticon.ZIndex = 4
					buttontexticon.BackgroundTransparency = 1
					buttontexticon.Visible = false
					buttontexticon.Parent = targetframe
					local buttonround1 = Instance.new("UICorner")
					buttonround1.CornerRadius = UDim.new(0, 5)
					buttonround1.Parent = buttontext
					local buttonround2 = Instance.new("UICorner")
					buttonround2.CornerRadius = UDim.new(0, 5)
					buttonround2.Parent = buttonbkg
					buttonapi["Enabled"] = false
					buttonapi["Default"] = argstable["Default"]

					buttonapi["ToggleButton"] = function(toggle, frist)
						buttonapi["Enabled"] = toggle
						buttontexticon.Visible = toggle
						if buttonapi["Enabled"] then
							if not first then
								tweenService:Create(buttontext, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromHSV(GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Hue"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Sat"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Value"])}):Play()
							else
								buttontext.BackgroundColor3 = Color3.fromHSV(GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Hue"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Sat"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Value"])
							end
						else
							if not first then
								tweenService:Create(buttontext, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(26, 25, 26)}):Play()
							else
								buttontext.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
							end
						end
						buttonimage.ImageColor3 = (buttonapi["Enabled"] and Color3.new(1, 1, 1) or Color3.fromRGB(121, 121, 121))
						argstable["Function"](buttonapi["Enabled"])
					end

					if argstable["Default"] then
						buttonapi["ToggleButton"](argstable["Default"], true)
					end
					buttontext.MouseButton1Click:Connect(function() buttonapi["ToggleButton"](not buttonapi["Enabled"], false) end)
					GuiLibrary.ObjectsThatCanBeSaved[argstablemain["Name"]..argstable["Name"].."TargetButton"] = {["Type"] = "TargetButton", ["Object"] = buttontext, ["Api"] = buttonapi}
					return buttonapi
				end

				buttonreturned["Players"] = windowapi["CreateButton"]({
					["Name"] = "PlayersIcon",
					["Position"] = UDim2.new(0, 11, 0, 6),
					["Icon"] = "vape/assets/TargetIcon1.png",
					["IconSize"] = 15,
					["Function"] = function() end,
					["Default"] = true
				})
				buttonreturned["NPCs"] = windowapi["CreateButton"]({
					["Name"] = "NPCsIcon",
					["Position"] = UDim2.new(0, 62, 0, 6),
					["Icon"] = "vape/assets/TargetIcon2.png",
					["IconSize"] = 12,
					["Function"] = function() end,
					["Default"] = false
				})
				buttonreturned["Peaceful"] = windowapi["CreateButton"]({
					["Name"] = "PeacefulIcon",
					["Position"] = UDim2.new(0, 113, 0, 6),
					["Icon"] = "vape/assets/TargetIcon3.png",
					["IconSize"] = 16,
					["Function"] = function() end,
					["Default"] = false
				})
				buttonreturned["Neutral"] = windowapi["CreateButton"]({
					["Name"] = "NeutralIcon",
					["Position"] = UDim2.new(0, 164, 0, 6),
					["Icon"] = "vape/assets/TargetIcon4.png",
					["IconSize"] = 19,
					["Function"] = function() end,
					["Default"] = false
				})

				buttonreturned["Invisible"] = windowapi["CreateToggle"]({
					["Name"] = "Ignore invisible",
					["Function"] = function() windowapi["UpdateIgnore"]() end,
					["Default"] = (argstablemain3["Default1"] or false)
				})
				buttonreturned["Naked"] = windowapi["CreateToggle"]({
					["Name"] = "Ignore naked",
					["Function"] = function() windowapi["UpdateIgnore"]() end,
					["Default"] = (argstablemain3["Default2"] or false)
				})
				buttonreturned["Walls"] = windowapi["CreateToggle"]({
					["Name"] = "Ignore behind walls",
					["Function"] = function() windowapi["UpdateIgnore"]() end,
					["Default"] = (argstablemain3["Default3"] or false)
				})

				drop1.MouseButton1Click:Connect(function()
					windowtitle.Visible = not windowtitle.Visible
					if not windowtitle.Visible then
						tweenService:Create(thing, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(107, 107, 107)}):Play()
					end
				end)
				drop1.MouseEnter:Connect(function()
					if not windowtitle.Visible then
						tweenService:Create(thing, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(107, 107, 107)}):Play()
					end
				end)
				drop1.MouseLeave:Connect(function()
					if not windowtitle.Visible then
						tweenService:Create(thing, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(38, 37, 38)}):Play()
					end
				end)

				GuiLibrary.ObjectsThatCanBeSaved[argstablemain["Name"].."TargetFrame"] = {["Type"] = "TargetFrame", ["Object"] = frame, ["Object2"] = windowtitle, ["Api"] = buttonreturned}

				return buttonreturned
			end

			buttonapi["CreateCircleWindow"] = function(argstablemain3)
				local buttonapi = {}
				local buttonreturned = {}
				local windowapi = {}
				local amount2 = #children2:GetChildren()
				local frame = Instance.new("Frame")
				frame.Size = UDim2.new(0, 220, 0, 49)
				frame.BackgroundTransparency = 1
				frame.LayoutOrder = amount2
				frame.Name = argstablemain["Name"].."TargetFrame"
				frame.Parent = children2
				local drop1 = Instance.new("TextButton")
				drop1.AutoButtonColor = false
				drop1.Size = UDim2.new(0, 198, 0, 39)
				drop1.Position = UDim2.new(0, 11, 0, 5)
				drop1.Parent = frame
				drop1.BorderSizePixel = 0
				drop1.ZIndex = 2
				drop1.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
				drop1.TextSize = 17
				drop1.TextXAlignment = Enum.TextXAlignment.Left
				drop1.Text = ""
				local targeticon = Instance.new("ImageLabel")
				targeticon.Size = UDim2.new(0, 14, 0, 12)
				targeticon.Position = UDim2.new(0, 12, 0, 14)
				targeticon.BackgroundTransparency = 1
				targeticon.Image = downloadVapeAsset("vape/assets/CircleList"..(argstablemain3["Type"] == "Blacklist" and "Blacklist" or "Whitelist")..".png")
				targeticon.ZIndex = 2
				targeticon.Parent = drop1
				local targettext = Instance.new("TextLabel")
				targettext.Size = UDim2.new(0, 190, 1, 0)
				targettext.Position = UDim2.new(0, 29, 0, 0)
				targettext.TextTruncate = Enum.TextTruncate.AtEnd
				targettext.BackgroundTransparency = 1
				targettext.ZIndex = 2
				targettext.TextSize = 17
				targettext.RichText = true
				targettext.TextColor3 = Color3.new(205, 205, 205)
				targettext.Text = "  "..argstablemain3["Name"].." \n "..'<font color="rgb(151, 151, 151)">None</font>'
				targettext.Font = Enum.Font.SourceSans
				targettext.TextXAlignment = Enum.TextXAlignment.Left
				targettext.Parent = drop1
				local thing = Instance.new("Frame")
				thing.Size = UDim2.new(1, 2, 1, 2)
				thing.BorderSizePixel = 0
				thing.Position = UDim2.new(0, -1, 0, -1)
				thing.ZIndex = 1
				thing.BackgroundColor3 = Color3.fromRGB(38, 37, 38)
				thing.Parent = drop1
				local uicorner = Instance.new("UICorner")
				uicorner.CornerRadius = UDim.new(0, 4)
				uicorner.Parent = drop1
				local uicorner2 = Instance.new("UICorner")
				uicorner2.CornerRadius = UDim.new(0, 4)
				uicorner2.Parent = thing
				local windowtitle = Instance.new("TextButton")
				windowtitle.Text = ""
				windowtitle.AutoButtonColor = false
				windowtitle.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
				windowtitle.Size = UDim2.new(0, 220, 0, 41)
				windowtitle.Position = UDim2.new(1, 1, 0, 0)
				windowtitle.Name = "CircleWindow"
				windowtitle.Visible = false
				windowtitle.ZIndex = 3
				windowtitle.Parent = clickgui
				frame:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
					windowtitle.Position = UDim2.new(0, frame.Size.X.Offset + frame.AbsolutePosition.X + 2, 0, frame.AbsolutePosition.Y)
				end)
				local windowshadow = Instance.new("ImageLabel")
				windowshadow.AnchorPoint = Vector2.new(0.5, 0.5)
				windowshadow.Position = UDim2.new(0.5, 0, 0.5, 0)
				windowshadow.Image = downloadVapeAsset("vape/assets/WindowBlur.png")
				windowshadow.BackgroundTransparency = 1
				windowshadow.ZIndex = -1
				windowshadow.Size = UDim2.new(1, 6, 1, 6)
				windowshadow.ImageColor3 = Color3.new(0, 0, 0)
				windowshadow.ScaleType = Enum.ScaleType.Slice
				windowshadow.SliceCenter = Rect.new(10, 10, 118, 118)
				windowshadow.Parent = windowtitle
				local windowicon = Instance.new("ImageLabel")
				windowicon.Size = UDim2.new(0, 18, 0, 16)
				windowicon.Image = downloadVapeAsset("vape/assets/CircleList"..(argstablemain3["Type"] == "Blacklist" and "Blacklist" or "Whitelist")..".png")
				windowicon.ImageColor3 = Color3.fromRGB(200, 200, 200)
				windowicon.ZIndex = 3
				windowicon.Name = "WindowIcon"
				windowicon.BackgroundTransparency = 1
				windowicon.Position = UDim2.new(0, 12, 0, 12)
				windowicon.Parent = windowtitle
				local windowtext = Instance.new("TextLabel")
				windowtext.Size = UDim2.new(0, 155, 0, 41)
				windowtext.BackgroundTransparency = 1
				windowtext.Name = "WindowTitle"
				windowtext.Position = UDim2.new(0, 36, 0, 1)
				windowtext.ZIndex = 3
				windowtext.TextXAlignment = Enum.TextXAlignment.Left
				windowtext.Font = Enum.Font.Arial
				windowtext.TextSize = 14
				windowtext.Text = (translations[argstablemain3["Name"]] ~= nil and translations[argstablemain3["Name"]] or argstablemain3["Name"])
				windowtext.TextColor3 = Color3.fromRGB(200, 200, 200)
				windowtext.Parent = windowtitle
				local children = Instance.new("Frame")
				children.BackgroundTransparency = 1
				children.Size = UDim2.new(1, 0, 1, -4)
				children.ZIndex = 3
				children.Position = UDim2.new(0, 0, 0, 41)
				children.Visible = true
				children.Parent = windowtitle
				local windowcorner = Instance.new("UICorner")
				windowcorner.CornerRadius = UDim.new(0, 4)
				windowcorner.Parent = windowtitle
				local uilistlayout = Instance.new("UIListLayout")
				uilistlayout.SortOrder = Enum.SortOrder.LayoutOrder
				uilistlayout.Parent = children
				uilistlayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
					windowtitle.Size = UDim2.new(0, 220, 0, 45 + uilistlayout.AbsoluteContentSize.Y)
				end)

				windowapi["UpdateIgnore"] = function()
					local str = ""
					for i,v in pairs(buttonreturned["CircleList"]["ObjectList"]) do
						local enabled = buttonreturned["CircleList"]["ObjectListEnabled"][i]
						if enabled then
							str = (str == "" and v or str..", "..v)
						end
					end
					if str == "" then
						str = "None"
					end
					if argstablemain3["UpdateFunction"] then
						argstablemain3["UpdateFunction"]()
					end
					targettext.Text = "  "..argstablemain3["Name"].." \n "..'<font color="rgb(151, 151, 151)">'..str..'</font>'
				end

				windowapi["CreateCircleTextList"] = function(argstable)
					local textGuiLibrary = {}
					local amount = #children:GetChildren()
					local frame = Instance.new("Frame")
					frame.Size = UDim2.new(0, 220, 0, 40)
					frame.BackgroundTransparency = 1
					frame.ZIndex = 5
					frame.ClipsDescendants = true
					frame.LayoutOrder = amount
					frame.Name = argstable["Name"]
					frame.Parent = children
					local textboxbkg = Instance.new("ImageLabel")
					textboxbkg.BackgroundTransparency = 1
					textboxbkg.Name = "AddBoxBKG"
					textboxbkg.Size = UDim2.new(0, (argstable["Name"] == "ProfilesList" and 150 or 200), 0, 31)
					textboxbkg.Position = UDim2.new(0, 10, 0, 5)
					textboxbkg.ZIndex = 6
					textboxbkg.ClipsDescendants = true
					textboxbkg.Image = downloadVapeAsset((argstable["Name"] == "ProfilesList" and "vape/assets/TextBoxBKG2.png" or "vape/assets/TextBoxBKG.png"))
					textboxbkg.Parent = frame
					local textbox = Instance.new("TextBox")
					textbox.Size = UDim2.new(0, 159, 1, 0)
					textbox.Position = UDim2.new(0, 11, 0, 0)
					textbox.ZIndex = 6
					textbox.TextXAlignment = Enum.TextXAlignment.Left
					textbox.Name = "AddBox"
					textbox.BackgroundTransparency = 1
					textbox.TextColor3 = Color3.new(1, 1, 1)
					textbox.PlaceholderColor3 = Color3.fromRGB(200, 200, 200)
					textbox.Font = Enum.Font.SourceSans
					textbox.Text = ""
					textbox.PlaceholderText = "Add entry..."
					textbox.TextSize = 17
					textbox.Parent = textboxbkg
					local addbutton = Instance.new("ImageButton")
					addbutton.BorderSizePixel = 0
					addbutton.Name = "AddButton"
					addbutton.ZIndex = 6
					addbutton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
					addbutton.Position = UDim2.new(0, (argstable["Name"] == "ProfilesList" and 124 or 174), 0, 8)
					addbutton.AutoButtonColor = false
					addbutton.Size = UDim2.new(0, 16, 0, 16)
					addbutton.ImageColor3 = argstable["Color"]
					addbutton.Image = downloadVapeAsset("vape/assets/AddItem.png")
					addbutton.Parent = textboxbkg
					local scrollframebkg = Instance.new("Frame")
					scrollframebkg.ZIndex = 5
					scrollframebkg.Name = "ScrollingFrameBKG"
					scrollframebkg.Size = UDim2.new(0, 220, 0, 3)
					scrollframebkg.BackgroundTransparency = 1
					scrollframebkg.LayoutOrder = amount
					scrollframebkg.Parent = children
					local scrollframe = Instance.new("ScrollingFrame")
					scrollframe.ZIndex = 5
					scrollframe.Size = UDim2.new(0, 200, 0, 3)
					scrollframe.Position = UDim2.new(0, 10, 0, 0)
					scrollframe.BackgroundTransparency = 1
					scrollframe.ScrollBarThickness = 0
					scrollframe.ScrollBarImageColor3 = Color3.new(0, 0, 0)
					scrollframe.LayoutOrder = amount
					scrollframe.Parent = scrollframebkg
					local uilistlayout3 = Instance.new("UIListLayout")
					uilistlayout3.Padding = UDim.new(0, 3)
					uilistlayout3.Parent = scrollframe
					uilistlayout3:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
						scrollframe.CanvasSize = UDim2.new(0, 0, 0, uilistlayout3.AbsoluteContentSize.Y)
						scrollframe.Size = UDim2.new(0, 220, 0, math.clamp(uilistlayout3.AbsoluteContentSize.Y, 1, 105))
						scrollframebkg.Size = UDim2.new(0, 220, 0, math.clamp(uilistlayout3.AbsoluteContentSize.Y, 1, 105) + 3)
					end)
			
					textGuiLibrary["Object"] = frame
					textGuiLibrary["ScrollingObject"] = scrollframebkg
					textGuiLibrary["ObjectList"] = {}
					textGuiLibrary["ObjectListEnabled"] = {}
					local hoveredover = {}
					textGuiLibrary["RefreshValues"] = function(tab, tab2)
						textGuiLibrary["ObjectList"] = tab
						if tab2 then
							textGuiLibrary["ObjectListEnabled"] = tab2
						end
						windowapi["UpdateIgnore"]()
						for i2,v2 in pairs(scrollframe:GetChildren()) do
							if v2:IsA("TextButton") then v2:Remove() end
						end
						for i,v in pairs(textGuiLibrary["ObjectList"]) do
							local objenabled = textGuiLibrary["ObjectListEnabled"][i]
							local itemframe = Instance.new("TextButton")
							itemframe.Size = UDim2.new(0, 200, 0, 33)
							itemframe.Text = ""
							itemframe.AutoButtonColor = false
							itemframe.BackgroundColor3 = (hoveredover[i] and Color3.fromRGB(26, 25, 26) or Color3.fromRGB(31, 30, 31))
							itemframe.BorderSizePixel = 0
							itemframe.ZIndex = 5
							itemframe.Parent = scrollframe
							local itemcorner = Instance.new("UICorner")
							itemcorner.CornerRadius = UDim.new(0, 6)
							itemcorner.Parent = itemframe
							local itemtext = Instance.new("TextLabel")
							itemtext.BackgroundTransparency = 1
							itemtext.Size = UDim2.new(0, 157, 0, 33)
							itemtext.Name = "ItemText"
							itemtext.ZIndex = 5
							itemtext.Position = UDim2.new(0, 36, 0, 0)
							itemtext.Font = Enum.Font.SourceSans
							itemtext.TextSize = 17
							itemtext.Text = v
							itemtext.TextXAlignment = Enum.TextXAlignment.Left
							itemtext.TextColor3 = (objenabled and Color3.fromRGB(160, 160, 160) or Color3.fromRGB(90, 90, 90))
							itemtext.Parent = itemframe
							local friendcircle = Instance.new("Frame")
							friendcircle.Size = UDim2.new(0, 10, 0, 10)
							friendcircle.Name = "FriendCircle"
							friendcircle.ZIndex = 5
							friendcircle.BackgroundColor3 = (objenabled and argstable["Color"] or Color3.fromRGB(120, 120, 120))
							friendcircle.BorderSizePixel = 0
							friendcircle.Position = UDim2.new(0, 10, 0, 13)
							friendcircle.Parent = itemframe
							local friendcorner = Instance.new("UICorner")
							friendcorner.CornerRadius = UDim.new(0, 8)
							friendcorner.Parent = friendcircle
							local friendcircle2 = friendcircle:Clone()
							friendcircle2.Size = UDim2.new(0, 8, 0, 8)
							friendcircle2.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
							friendcircle2.Position = UDim2.new(0, 1, 0, 1)
							friendcircle2.Visible = not objenabled
							friendcircle2.Parent = friendcircle	
							itemframe:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
								friendcircle2.BackgroundColor3 = itemframe.BackgroundColor3
							end)
							itemframe.MouseEnter:Connect(function()
								itemframe.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
								hoveredover[i] = true
							end)
							itemframe.MouseLeave:Connect(function()
								itemframe.BackgroundColor3 = Color3.fromRGB(31, 30, 31)
								hoveredover[i] = nil
							end)
							itemframe.MouseButton1Click:Connect(function()
								textGuiLibrary["ObjectListEnabled"][i] = not textGuiLibrary["ObjectListEnabled"][i]
								textGuiLibrary["RefreshValues"](textGuiLibrary["ObjectList"])
							end)
							itemframe.MouseButton2Click:Connect(function()
								textGuiLibrary["ObjectListEnabled"][i] = not textGuiLibrary["ObjectListEnabled"][i]
								textGuiLibrary["RefreshValues"](textGuiLibrary["ObjectList"])
							end)
							local deletebutton = Instance.new("ImageButton")
							deletebutton.Size = UDim2.new(0, 6, 0, 6)
							deletebutton.BackgroundTransparency = 1
							deletebutton.AutoButtonColor = false
							deletebutton.ZIndex = 5
							deletebutton.Image = downloadVapeAsset("vape/assets/AddRemoveIcon1.png")
							deletebutton.Position = UDim2.new(1, -16, 0, 14)
							deletebutton.Parent = itemframe
							deletebutton.MouseButton1Click:Connect(function()
								table.remove(textGuiLibrary["ObjectList"], i)
								textGuiLibrary["ObjectListEnabled"][i] = nil
								textGuiLibrary["RefreshValues"](textGuiLibrary["ObjectList"])
								if argstable["RemoveFunction"] then
									argstable["RemoveFunction"](i, v)
								end
							end)
						end
					end
			
					GuiLibrary.ObjectsThatCanBeSaved[argstablemain["Name"]..argstable["Name"].."TextCircleList"] = {["Type"] = "TextCircleList", ["Api"] = textGuiLibrary}
					local function AddToList()
                        local num = #textGuiLibrary["ObjectList"] + 1
                        textGuiLibrary["ObjectList"][num] = textbox.Text
                        textGuiLibrary["ObjectListEnabled"][num] = true
                        textGuiLibrary["RefreshValues"](textGuiLibrary["ObjectList"])
                        if argstable["AddFunction"] then
                            argstable["AddFunction"](textbox.Text) 
                        end
                        textbox.Text = ""
                    end
                    addbutton.MouseButton1Click:Connect(AddToList)
                    textbox.FocusLost:Connect(function(enter)
                        if enter then
                            AddToList()
                            textbox:CaptureFocus()
                        end
                    end)
					return textGuiLibrary
				end

				--[[windowapi["CreateButton"] = function(argstable)
					local buttonapi = {}
					local amount = #children:GetChildren()
					local buttontext = Instance.new("TextButton")
					buttontext.Name = argstablemain["Name"]..argstable["Name"].."TargetButton"
					buttontext.LayoutOrder = amount
					buttontext.AutoButtonColor = false
					buttontext.Size = UDim2.new(0, 45, 0, 29)
					buttontext.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
					buttontext.Active = false
					buttontext.Text = ""
					buttontext.ZIndex = 4
					buttontext.Font = Enum.Font.SourceSans
					buttontext.TextXAlignment = Enum.TextXAlignment.Left
					buttontext.Position = argstable["Position"]
					buttontext.Parent = buttonframeholder
					local buttonbkg = Instance.new("Frame")
					buttonbkg.BackgroundColor3 = Color3.fromRGB(38, 37, 38)
					buttonbkg.Size = UDim2.new(0, 47, 0, 31)
					buttonbkg.Position = argstable["Position"] - UDim2.new(0, 1, 0, 1)
					buttonbkg.ZIndex = 3
					buttonbkg.Parent = buttonframeholder
					local buttonimage = Instance.new("ImageLabel")
					buttonimage.BackgroundTransparency = 1
					buttonimage.Position = UDim2.new(0, 14, 0, 7)
					buttonimage.Size = UDim2.new(0, argstable["IconSize"], 0, 16)
					buttonimage.Image = downloadVapeAsset(argstable["Icon"])
					buttonimage.ImageColor3 = Color3.fromRGB(121, 121, 121)
					buttonimage.ZIndex = 5
					buttonimage.Active = false
					buttonimage.Parent = buttontext
					local buttontexticon = Instance.new("ImageLabel")
					buttontexticon.Size = UDim2.new(0, argstable["IconSize"] - 3, 0, 12)
					buttontexticon.Image = downloadVapeAsset(argstable["Icon"])
					buttontexticon.LayoutOrder = amount
					buttontexticon.ZIndex = 4
					buttontexticon.BackgroundTransparency = 1
					buttontexticon.Visible = false
					buttontexticon.Parent = targetframe
					local buttonround1 = Instance.new("UICorner")
					buttonround1.CornerRadius = UDim.new(0, 5)
					buttonround1.Parent = buttontext
					local buttonround2 = Instance.new("UICorner")
					buttonround2.CornerRadius = UDim.new(0, 5)
					buttonround2.Parent = buttonbkg
					buttonapi["Enabled"] = false
					buttonapi["Default"] = argstable["Default"]

					buttonapi["ToggleButton"] = function(toggle, frist)
						buttonapi["Enabled"] = toggle
						buttontexticon.Visible = toggle
						if buttonapi["Enabled"] then
							if not first then
								tweenService:Create(buttontext, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromHSV(GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Hue"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Sat"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Value"])}):Play()
							else
								buttontext.BackgroundColor3 = Color3.fromHSV(GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Hue"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Sat"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Value"])
							end
						else
							if not first then
								tweenService:Create(buttontext, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(26, 25, 26)}):Play()
							else
								buttontext.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
							end
						end
						buttonimage.ImageColor3 = (buttonapi["Enabled"] and Color3.new(1, 1, 1) or Color3.fromRGB(121, 121, 121))
						argstable["Function"](buttonapi["Enabled"])
					end

					if argstable["Default"] then
						buttonapi["ToggleButton"](argstable["Default"], true)
					end
					buttontext.MouseButton1Click:Connect(function() buttonapi["ToggleButton"](not buttonapi["Enabled"], false) end)
					GuiLibrary.ObjectsThatCanBeSaved[argstablemain["Name"]..argstable["Name"].."TargetButton"] = {["Type"] = "TargetButton", ["Object"] = buttontext, ["Api"] = buttonapi}
					return buttonapi
				end]]

				buttonreturned["CircleList"] = windowapi.CreateCircleTextList({
					Name = "CircleList",
					Color = (argstablemain3["Type"] == "Blacklist" and Color3.fromRGB(250, 50, 56) or Color3.fromRGB(5, 134, 105))
				})

				drop1.MouseButton1Click:Connect(function()
					windowtitle.Visible = not windowtitle.Visible
					if not windowtitle.Visible then
						tweenService:Create(thing, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(107, 107, 107)}):Play()
					end
				end)
				drop1.MouseEnter:Connect(function()
					if not windowtitle.Visible then
						tweenService:Create(thing, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(107, 107, 107)}):Play()
					end
				end)
				drop1.MouseLeave:Connect(function()
					if not windowtitle.Visible then
						tweenService:Create(thing, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(38, 37, 38)}):Play()
					end
				end)

				GuiLibrary.ObjectsThatCanBeSaved[argstablemain["Name"].."CircleListFrame"] = {["Type"] = "CircleListFrame", ["Object"] = frame, ["Object2"] = windowtitle, ["Api"] = buttonreturned}

				return buttonreturned
			end

			buttonapi["CreateDropdown"] = function(argstable)
				local dropGuiLibrary = {}
				local list = argstable["List"]
				local amount2 = #children2:GetChildren()
				local frame = Instance.new("Frame")
				frame.Size = UDim2.new(0, 220, 0, 40)
				frame.BackgroundTransparency = 1
				frame.LayoutOrder = amount2
				frame.Name = argstable["Name"]
				frame.Parent = children2
				local drop1 = Instance.new("TextButton")
				drop1.AutoButtonColor = false
				drop1.Size = UDim2.new(0, 198, 0, 29)
				drop1.Position = UDim2.new(0, 11, 0, 5)
				drop1.Parent = frame
				drop1.BorderSizePixel = 0
				drop1.ZIndex = 2
				drop1.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
				drop1.TextSize = 14
				drop1.TextXAlignment = Enum.TextXAlignment.Left
				drop1.TextColor3 = Color3.fromRGB(160, 160, 160)
				drop1.Text = "           "..(translations[argstable["Name"]] ~= nil and translations[argstable["Name"]] or argstable["Name"]).." - "..(list ~= {} and list[1] or "")
				drop1.TextTruncate = Enum.TextTruncate.AtEnd
				drop1.Font = Enum.Font.Arial
				local expandbutton2 = Instance.new("ImageLabel")
				expandbutton2.Active = false
				expandbutton2.Size = UDim2.new(0, 9, 0, 4)
				expandbutton2.Image = downloadVapeAsset("vape/assets/DownArrow.png")
				expandbutton2.ZIndex = 5
				expandbutton2.Position = UDim2.new(1, -19, 1, -16)
				expandbutton2.Name = "ExpandButton2"
				expandbutton2.BackgroundTransparency = 0
				expandbutton2.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
				expandbutton2.BorderSizePixel = 0
				expandbutton2.Parent = drop1
				local drop2 = drop1:Clone()
				drop2.Name = "MainButton"
				drop2.Position = UDim2.new(0, 0, 0, 0)
				drop2.ZIndex = 9
				drop2.BackgroundTransparency = 1
				drop1:GetPropertyChangedSignal("Text"):Connect(function()
					drop2.Text = drop1.Text
				end)
				drop2.ExpandButton2.Image = downloadVapeAsset("vape/assets/UpArrow.png")
				drop2.ExpandButton2.ZIndex = 10
				local thing = Instance.new("Frame")
				thing.Size = UDim2.new(1, 2, 1, 2)
				thing.BorderSizePixel = 0
				thing.Position = UDim2.new(0, -1, 0, -1)
				thing.ZIndex = 1
				thing.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
				thing.Parent = drop1
				local uicorner = Instance.new("UICorner")
				uicorner.CornerRadius = UDim.new(0, 6)
				uicorner.Parent = drop1
				local uicorner2 = Instance.new("UICorner")
				uicorner2.CornerRadius = UDim.new(0, 6)
				uicorner2.Parent = thing
				local dropframe = Instance.new("Frame")
				dropframe.ZIndex = 7
				dropframe.Parent = drop1
				dropframe.Position = UDim2.new(0, 0, 0, 0)
				dropframe.Size = UDim2.new(1, 0, 0, 0)
				dropframe.BackgroundTransparency = 0
				dropframe.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
				dropframe.Visible = false
				local uicorner3 = Instance.new("UICorner")
				uicorner3.CornerRadius = UDim.new(0, 6)
				uicorner3.Parent = dropframe
				local thing2 = thing:Clone()
				thing2.ZIndex = 2
				thing2.BackgroundColor3 = Color3.fromRGB(53, 52, 53)
				thing2.Parent = dropframe
				drop2.Parent = dropframe
				drop2.MouseButton1Click:Connect(function()
					dropframe.Visible = not dropframe.Visible
					local num = (dropframe.Visible and 10 or 0) + (uilistlayout2.AbsoluteContentSize.Y + (dropframe.Visible and #dropframe:GetChildren() * (dropframe.Visible and 13 or 9) * (GuiLibrary["MainRescale"].Scale) or 0) + (40 * GuiLibrary["MainRescale"].Scale)) * (1 / GuiLibrary["MainRescale"].Scale)
					frame.Size = UDim2.new(0, 220, 0, 40)
					--	children.CanvasSize = UDim2.new(0, 0, 0, num)
				--	windowtitle.Size = UDim2.new(0, 220, 0, math.clamp(45 + num, 0, 605))
				end)
				drop1.MouseButton1Click:Connect(function()
					dropframe.Visible = not dropframe.Visible
					local num = (dropframe.Visible and 40 or 0) + (uilistlayout2.AbsoluteContentSize.Y + (dropframe.Visible and #dropframe:GetChildren() * (dropframe.Visible and 13 or 9) * (GuiLibrary["MainRescale"].Scale) or 0) + (40 * GuiLibrary["MainRescale"].Scale)) * (1 / GuiLibrary["MainRescale"].Scale)
					frame.Size = UDim2.new(0, 220, 0, dropframe.Size.Y.Offset + 10)
					--	children.CanvasSize = UDim2.new(0, 0, 0, num)
				--	windowtitle.Size = UDim2.new(0, 220, 0, math.clamp(45 + num, 0, 605))
				end)
				drop1.MouseEnter:Connect(function()
					thing.BackgroundColor3 = Color3.fromRGB(49, 48, 49)
				end)
				drop1.MouseLeave:Connect(function()
					thing.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
				end)
				frame.MouseEnter:Connect(function()
					if argstable["HoverText"] and type(argstable["HoverText"]) == "string" then
						hoverbox.Visible = (GuiLibrary["ToggleTooltips"] and hoverbox.TextSize ~= 1)
						local textsize = textService:GetTextSize(argstable["HoverText"], hoverbox.TextSize, hoverbox.Font, Vector2.new(99999, 99999))
						hoverbox.Text = "  "..argstable["HoverText"]:gsub("\n", "\n  ")
						hoverbox.Size = UDim2.new(0, 13 + textsize.X, 0, textsize.Y + 5)
					end
				end)
				if argstable["HoverText"] and type(argstable["HoverText"]) == "string" then
					frame.MouseMoved:Connect(function(x, y)
						hoverbox.Visible = (GuiLibrary["ToggleTooltips"] and hoverbox.TextSize ~= 1)
						hoverbox.Position = UDim2.new(0, (x + 16) * (1 / GuiLibrary["MainRescale"].Scale), 0,	(y - (hoverbox.Size.Y.Offset / 2) - 26) * (1 / GuiLibrary["MainRescale"].Scale))
					end)
				end
				frame.MouseLeave:Connect(function()
					hoverbox.Visible = false
					if buttonapi["Enabled"] == false then
						pcall(function()
							tweenService:Create(toggleframe1, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
						end)
					end
				end)
				local placeholder = 0
				dropGuiLibrary["Value"] = (list ~= {} and list[1] or "")
				dropGuiLibrary["Default"] = dropGuiLibrary["Value"]
				dropGuiLibrary["Object"] = frame
				dropGuiLibrary["List"] = list
				dropGuiLibrary["UpdateList"] = function(val)
					placeholder = 25
					list = val
					dropGuiLibrary["List"] = val
					if not table.find(list, dropGuiLibrary["Value"]) then
						dropGuiLibrary["Value"] = list[1]
						drop1.Text = "         "..(translations[argstable["Name"]] ~= nil and translations[argstable["Name"]] or argstable["Name"]).." - "..list[1]
						dropframe.Visible = false
						argstable["Function"](list[1])
					end
					for del1, del2 in pairs(dropframe:GetChildren()) do if del2:IsA("TextButton") and del2.Name ~= "MainButton" then del2:Remove() end end
					for numbe, listobj in pairs(val) do
						if listobj == dropGuiLibrary["Value"] then continue end
						local drop2 = Instance.new("TextButton")
						dropframe.Size = UDim2.new(0, 198, 0, placeholder + 21)
						drop2.Text = "       "..listobj
						drop2.LayoutOrder = numbe
						drop2.TextColor3 = Color3.fromRGB(160, 160, 160)
						drop2.AutoButtonColor = false
						drop2.BackgroundTransparency = 1
						drop2.TextXAlignment = Enum.TextXAlignment.Left
						drop2.Size = UDim2.new(0, 198, 0, 21)
						drop2.Position = UDim2.new(0, 2, 0, placeholder - 4)
						drop2.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
						drop2.Font = Enum.Font.Arial
						drop2.TextSize = 14
						drop2.ZIndex = 8
						drop2.BorderSizePixel = 0
						drop2.Name = listobj
						drop2.Parent = dropframe
						drop2.MouseButton1Click:Connect(function()
							dropGuiLibrary["Value"] = listobj
							drop1.Text = "         "..(translations[argstable["Name"]] ~= nil and translations[argstable["Name"]] or argstable["Name"]).." - "..listobj
							dropframe.Visible = false
							local num = (uilistlayout2.AbsoluteContentSize.Y + (dropframe.Visible and #dropframe:GetChildren() * 9 or 0) + (40 * GuiLibrary["MainRescale"].Scale)) * (1 / GuiLibrary["MainRescale"].Scale)
							frame.Size = UDim2.new(0, 220, 0, 40)
							--children.CanvasSize = UDim2.new(0, 0, 0, num)
							--windowtitle.Size = UDim2.new(0, 220, 0, math.clamp(45 + num, 0, 605))
							argstable["Function"](listobj)
							dropGuiLibrary["UpdateList"](list)
							GuiLibrary["UpdateHudEvent"]:Fire()
						end)
						placeholder = placeholder + 21
					end
				end
				dropGuiLibrary["SetValue"] = function(listobj)
					dropGuiLibrary["Value"] = listobj
					drop1.Text = "         "..(translations[argstable["Name"]] ~= nil and translations[argstable["Name"]] or argstable["Name"]).." - "..listobj
					dropframe.Visible = false
					argstable["Function"](listobj)
					dropGuiLibrary["UpdateList"](list)
				end
				dropGuiLibrary["UpdateList"](list)
				if buttonapi["HasExtraText"] then
					GuiLibrary["UpdateHudEvent"]:Fire()
				end
				GuiLibrary.ObjectsThatCanBeSaved[argstablemain["Name"]..argstable["Name"].."Dropdown"] = {["Type"] = "Dropdown", ["Object"] = frame, ["Api"] = dropGuiLibrary}

				return dropGuiLibrary
			end

			buttonapi["CreateColorSlider"] = function(argstable)
				local min, max = 0, 1
				local sliderapi = {}
				local amount2 = #children2:GetChildren()
				local frame = Instance.new("Frame")
				frame.Size = UDim2.new(0, 220, 0, 50)
				frame.BorderSizePixel = 0
				frame.BackgroundTransparency = 1
				frame.LayoutOrder = amount2
				frame.Name = argstable["Name"]
				frame.Parent = children2
				local text1 = Instance.new("TextLabel")
				text1.Font = Enum.Font.Arial
				text1.TextXAlignment = Enum.TextXAlignment.Left
				text1.Text = "          "..(translations[argstable["Name"]] ~= nil and translations[argstable["Name"]] or argstable["Name"])
				text1.Size = UDim2.new(1, 0, 0, 27)
				text1.TextColor3 = Color3.fromRGB(160, 160, 160)
				text1.BackgroundTransparency = 1
				text1.TextSize = 12
				text1.Parent = frame
				local text2 = Instance.new("Frame")
				text2.Size = UDim2.new(0, 12, 0, 12)
				text2.Position = UDim2.new(1, -22, 0, 9)
				text2.BackgroundColor3 = Color3.fromHSV(0.44, 1, 1)
				text2.Parent = frame
				local uicorner4 = Instance.new("UICorner")
				uicorner4.CornerRadius = UDim.new(0, 4)
				uicorner4.Parent = text2
				local slider1 = Instance.new("TextButton")
				slider1.AutoButtonColor = false
				slider1.Text = ""
				slider1.Size = UDim2.new(0, 200, 0, 2)
				slider1.BorderSizePixel = 0
				slider1.BackgroundColor3 = Color3.new(1, 1, 1)
				slider1.Position = UDim2.new(0, 10, 0, 32)
				slider1.Name = "Slider"
				slider1.Parent = frame
				local uigradient = Instance.new("UIGradient")
				uigradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 1, 1)), ColorSequenceKeypoint.new(0.2, Color3.fromHSV(0.2, 1, 1)), ColorSequenceKeypoint.new(0.3, Color3.fromHSV(0.3, 1, 1)), ColorSequenceKeypoint.new(0.4, Color3.fromHSV(0.4, 1, 1)), ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5, 1, 1)), ColorSequenceKeypoint.new(0.6, Color3.fromHSV(0.6, 1, 1)), ColorSequenceKeypoint.new(0.7, Color3.fromHSV(0.7, 1, 1)), ColorSequenceKeypoint.new(0.8, Color3.fromHSV(0.8, 1, 1)), ColorSequenceKeypoint.new(0.9, Color3.fromHSV(0.9, 1, 1)), ColorSequenceKeypoint.new(1, Color3.fromHSV(1, 1, 1))})
				uigradient.Parent = slider1
				local slider3 = Instance.new("ImageButton")
				slider3.AutoButtonColor = false
				slider3.Size = UDim2.new(0, 24, 0, 16)
				slider3.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
				slider3.BorderSizePixel = 0
				slider3.Image = downloadVapeAsset("vape/assets/SliderButton1.png")
				slider3.Position = UDim2.new(0.44, -11, 0, -7)
				slider3.Parent = slider1
				slider3.Name = "ButtonSlider"
				local slidersat = frame:Clone()
				slidersat.TextLabel.Text = "    Saturation"
				slidersat.Name = frame.Name.."Saturation"
				slidersat.BackgroundTransparency = 0
				slidersat.Visible = false
				slidersat.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
				slidersat.Slider.UIGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 0, 1)), ColorSequenceKeypoint.new(1, Color3.fromHSV(0.4, 1, 1))})
				slidersat.Slider.ButtonSlider.Position = UDim2.new(0.95, -11, 0, -7)
				slidersat.Slider.ButtonSlider.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
				slidersat.Frame:Remove()
				slidersat.Parent = children2
				local sliderval = frame:Clone()
				sliderval.TextLabel.Text = "    Vibrance"
				sliderval.Name = frame.Name.."Vibrance"
				sliderval.BackgroundTransparency = 0
				sliderval.Visible = false
				sliderval.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
				sliderval.Slider.UIGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 0, 0)), ColorSequenceKeypoint.new(1, Color3.fromHSV(0.4, 1, 1))})
				sliderval.Slider.ButtonSlider.Position = UDim2.new(0.95, -11, 0, -7)
				sliderval.Slider.ButtonSlider.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
				sliderval.Frame:Remove()
				sliderval.Parent = children2
				local sliderexpand = Instance.new("ImageButton")
				sliderexpand.AutoButtonColor = false
				sliderexpand.Size = UDim2.new(0, 15, 0, 15)
				sliderexpand.BackgroundTransparency = 1
				sliderexpand.Position = UDim2.new(0, textService:GetTextSize(text1.Text, text1.TextSize, text1.Font, Vector2.new(10000, 100000)).X + 3, 0, 6)
				sliderexpand.Image = downloadVapeAsset("vape/assets/HoverArrow3.png")
				sliderexpand.Parent = frame
				sliderexpand.MouseEnter:Connect(function()
					sliderexpand.Image = downloadVapeAsset("vape/assets/HoverArrow4.png")
				end)
				sliderexpand.MouseLeave:Connect(function()
					sliderexpand.Image = downloadVapeAsset("vape/assets/HoverArrow3.png")
				end)
				sliderexpand.MouseButton1Click:Connect(function()
					local val = not slidersat.Visible
					slidersat.Visible = val
					sliderval.Visible = val
					sliderexpand.Rotation = (val and 180 or 0)
				end)
				sliderapi["Hue"] = (argstable["Default"] or 0.44)
				sliderapi["Sat"] = 1
				sliderapi["Value"] = 1
				sliderapi["Object"] = frame
				sliderapi["RainbowValue"] = false
				sliderapi["SetValue"] = function(hue, sat, val)
					hue = (hue or sliderapi["Hue"])
					sat = (sat or sliderapi["Sat"])
					val = (val or sliderapi["Value"])
					text2.BackgroundColor3 = Color3.fromHSV(hue, sat, val)
					pcall(function()
						slidersat.Slider.UIGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 0, val)), ColorSequenceKeypoint.new(1, Color3.fromHSV(hue, 1, val))})
						sliderval.Slider.UIGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 0, 0)), ColorSequenceKeypoint.new(1, Color3.fromHSV(hue, sat, 1))})
						slidersat.Slider.ButtonSlider.Position = UDim2.new(math.clamp(sat, 0.02, 0.95), -9, 0, -7)
						sliderval.Slider.ButtonSlider.Position = UDim2.new(math.clamp(val, 0.02, 0.95), -9, 0, -7)
					end)
					sliderapi["Hue"] = hue
					sliderapi["Sat"] = sat
					sliderapi["Value"] = val
					slider3.Position = UDim2.new(math.clamp(hue, 0.02, 0.95), -9, 0, -7)
					argstable["Function"](hue, sat, val)
				end
				sliderapi["SetRainbow"] = function(val)
					sliderapi["RainbowValue"] = val
					if sliderapi["RainbowValue"] then
						table.insert(GuiLibrary.RainbowSliders, sliderapi)
					else
						table.remove(GuiLibrary.RainbowSliders, table.find(GuiLibrary.RainbowSliders, sliderapi))
					end
				end
				local clicktick = tick()
				local function slidercode(obj, valtochange)
					if clicktick > tick() then
						sliderapi["SetRainbow"](not sliderapi["RainbowValue"])
					end
					clicktick = tick() + 0.3
					local x,y,xscale,yscale,xscale2 = RelativeXY(obj, inputService:GetMouseLocation())
					sliderapi["SetValue"]((valtochange == "Hue" and (min + ((max - min) * xscale)) or false), (valtochange == "Sat" and (min + ((max - min) * xscale)) or false), (valtochange == "Value" and (min + ((max - min) * xscale)) or false))
					obj.ButtonSlider.Position = UDim2.new(math.clamp(xscale2, 0.02, 0.95), -9, 0, -7)
					local move
					local kill
					move = inputService.InputChanged:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseMovement then
							local x,y,xscale,yscale,xscale2 = RelativeXY(obj, inputService:GetMouseLocation())
							sliderapi["SetValue"]((valtochange == "Hue" and (min + ((max - min) * xscale)) or false), (valtochange == "Sat" and (min + ((max - min) * xscale)) or false), (valtochange == "Value" and (min + ((max - min) * xscale)) or false))
							obj.ButtonSlider.Position = UDim2.new(math.clamp(xscale2, 0.02, 0.95), -9, 0, -7)
						end
					end)
					kill = inputService.InputEnded:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 then
							move:Disconnect()
							kill:Disconnect()
						end
					end)
				end
				slider1.MouseButton1Down:Connect(function()
					slidercode(slider1, "Hue")
				end)
				slider3.MouseButton1Down:Connect(function()
					slidercode(slider1, "Hue")
				end)
				slidersat.Slider.MouseButton1Down:Connect(function()
					slidercode(slidersat.Slider, "Sat")
				end)
				slidersat.Slider.ButtonSlider.MouseButton1Down:Connect(function()
					slidercode(slidersat.Slider, "Sat")
				end)
				sliderval.Slider.MouseButton1Down:Connect(function()
					slidercode(sliderval.Slider, "Value")
				end)
				sliderval.Slider.ButtonSlider.MouseButton1Down:Connect(function()
					slidercode(sliderval.Slider, "Value")
				end)
				
				frame.MouseEnter:Connect(function()
					if argstable["HoverText"] and type(argstable["HoverText"]) == "string" then
						hoverbox.Visible = (GuiLibrary["ToggleTooltips"] and hoverbox.TextSize ~= 1)
						local textsize = textService:GetTextSize(argstable["HoverText"], hoverbox.TextSize, hoverbox.Font, Vector2.new(99999, 99999))
						hoverbox.Text = "  "..argstable["HoverText"]:gsub("\n", "\n  ")
						hoverbox.Size = UDim2.new(0, 13 + textsize.X, 0, textsize.Y + 5)
					end
				end)
				if argstable["HoverText"] and type(argstable["HoverText"]) == "string" then
					frame.MouseMoved:Connect(function(x, y)
						hoverbox.Visible = (GuiLibrary["ToggleTooltips"] and hoverbox.TextSize ~= 1)
						hoverbox.Position = UDim2.new(0, (x + 16) * (1 / GuiLibrary["MainRescale"].Scale), 0,	(y - (hoverbox.Size.Y.Offset / 2) - 26) * (1 / GuiLibrary["MainRescale"].Scale))
					end)
				end
				frame.MouseLeave:Connect(function()
					hoverbox.Visible = false
					if buttonapi["Enabled"] == false then
						pcall(function()
							tweenService:Create(toggleframe1, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
						end)
					end
				end)
				GuiLibrary.ObjectsThatCanBeSaved[argstablemain["Name"]..argstable["Name"].."SliderColor"] = {["Type"] = "ColorSlider", ["Object"] = frame, ["Object2"] = slidersat, ["Object3"] = sliderval, ["Api"] = sliderapi}
				return sliderapi
			end

			buttonapi["CreateSlider"] = function(argstable)
				local sliderapi = {}
				local amount2 = #children2:GetChildren()
				local frame = Instance.new("Frame")
				frame.Size = UDim2.new(0, 220, 0, 50)
				frame.BackgroundTransparency = 1
				frame.ClipsDescendants = true
				frame.LayoutOrder = amount2
				frame.Name = argstable["Name"]
				frame.Parent = children2
				local text1 = Instance.new("TextLabel")
				text1.Font = Enum.Font.Arial
				text1.TextXAlignment = Enum.TextXAlignment.Left
				text1.Text = "          "..(translations[argstable["Name"]] ~= nil and translations[argstable["Name"]] or argstable["Name"])
				text1.Size = UDim2.new(1, 0, 0, 25)
				text1.TextColor3 = Color3.fromRGB(160, 160, 160)
				text1.Position = UDim2.new(0, 0, 0, 4)
				text1.BackgroundTransparency = 1
				text1.TextSize = 12
				text1.Parent = frame
				local text2 = Instance.new("TextButton")
				text2.Font = Enum.Font.Arial
				text2.AutoButtonColor = false
				text2.TextXAlignment = Enum.TextXAlignment.Right
				text2.Text = tostring((argstable["Default"] or argstable["Min"])) .. " "..(argstable["Percent"] and "%" or " ").." "
				text2.Size = UDim2.new(0, 40, 0, 25)
				text2.Position = UDim2.new(1, -40, 0, 4)
				text2.TextColor3 = Color3.fromRGB(160, 160, 160)
				text2.BackgroundTransparency = 1
				text2.TextSize = 12
				text2.Parent = frame
				local text3 = Instance.new("TextBox")
				text3.Visible = false
				text3.Font = Enum.Font.Arial
				text3.TextXAlignment = Enum.TextXAlignment.Right
				text3.BackgroundTransparency = 1
				text3.TextColor3 = Color3.fromRGB(160, 160, 160)
				text3.Text = ""
				text3.Position = UDim2.new(1, -40, 0, 4)
				text3.Size = UDim2.new(0, 40, 0, 25)
				text3.TextSize = 12
				text3.Parent = frame
				local textdown = Instance.new("Frame")
				textdown.BackgroundColor3 = Color3.fromRGB(37, 36, 37)
				textdown.Size = UDim2.new(0, 30, 0, 2)
				textdown.Position = UDim2.new(1, -38, 1, -4)
				textdown.Visible = false
				textdown.BorderSizePixel = 0
				textdown.Parent = text2
				local textdown2 = Instance.new("Frame")
				textdown2.BackgroundColor3 = Color3.fromRGB(41, 41, 41)
				textdown2.Size = UDim2.new(0, 30, 0, 2)
				textdown2.Position = UDim2.new(1, -38, 1, -4)
				textdown2.BorderSizePixel = 0
				textdown2.Parent = text3
				local slider1 = Instance.new("Frame")
				slider1.Size = UDim2.new(0, 200, 0, 2)
				slider1.BorderSizePixel = 0
				slider1.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
				slider1.Position = UDim2.new(0, 10, 0, 37)
				slider1.Name = "Slider"
				slider1.Parent = frame
				local slider2 = Instance.new("Frame")
				slider2.BorderSizePixel = 0
				slider2.Size = UDim2.new(math.clamp(((argstable["Default"] or argstable["Min"]) / argstable["Max"]), 0.02, 0.97), 0, 1, 0)
				slider2.BackgroundColor3 = Color3.fromHSV(GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Hue"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Sat"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Value"])
				slider2.Name = "FillSlider"
				slider2.Parent = slider1
				local slider3 = Instance.new("ImageButton")
				slider3.AutoButtonColor = false
				slider3.Size = UDim2.new(0, 24, 0, 16)
				slider3.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
				slider3.BorderSizePixel = 0
				slider3.Image = downloadVapeAsset("vape/assets/SliderButton1.png")
				slider3.Position = UDim2.new(1, -11, 0, -7)
				slider3.Parent = slider2
				slider3.Name = "ButtonSlider"
				sliderapi["Object"] = frame
				sliderapi["Value"] = (argstable["Default"] or argstable["Min"])
				sliderapi["Default"] = (argstable["Default"] or argstable["Min"])
				sliderapi["Min"] = argstable["Min"]
				sliderapi["Max"] = argstable["Max"]
				sliderapi["SetValue"] = function(val)
				--	val = math.clamp(val, argstable["Min"], argstable["Max"])
					sliderapi["Value"] = val
					slider2.Size = UDim2.new(math.clamp((val / argstable["Max"]), 0.02, 0.97), 0, 1, 0)
					local doublecheck = argstable["Double"] and (sliderapi["Value"] / argstable["Double"]) or sliderapi["Value"]
					text2.Text = doublecheck .. " "..(argstable["Percent"] and "%  " or " ").." "
					argstable["Function"](val)
				end
				slider3.MouseButton1Down:Connect(function()
					local x,y,xscale,yscale,xscale2 = RelativeXY(slider1, inputService:GetMouseLocation())
					sliderapi["SetValue"](math.floor(argstable["Min"] + ((argstable["Max"] - argstable["Min"]) * xscale)))
					local doublecheck = argstable["Double"] and (sliderapi["Value"] / argstable["Double"]) or sliderapi["Value"]
					text2.Text = doublecheck .. " "..(argstable["Percent"] and "%  " or " ").." "
					slider2.Size = UDim2.new(xscale2,0,1,0)
					local move
					local kill
					move = inputService.InputChanged:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseMovement then
							local x,y,xscale,yscale,xscale2 = RelativeXY(slider1, inputService:GetMouseLocation())
							sliderapi["SetValue"](math.floor(argstable["Min"] + ((argstable["Max"] - argstable["Min"]) * xscale)))
							local doublecheck = argstable["Double"] and (sliderapi["Value"] / argstable["Double"]) or sliderapi["Value"]
							text2.Text = doublecheck .. " "..(argstable["Percent"] and "%  " or " ").." "
							slider2.Size = UDim2.new(xscale2,0,1,0)
						end
					end)
					kill = inputService.InputEnded:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 then
							move:Disconnect()
							kill:Disconnect()
						end
					end)
				end)
				text2.MouseEnter:Connect(function()
					textdown.Visible = true
				end)
				text2.MouseLeave:Connect(function()
					textdown.Visible = false
				end)
				text2.MouseButton1Click:Connect(function()
					text3.Visible = true
					text2.Visible = false
					text3:CaptureFocus()
					text3.Text = text2.Text
				end)
				text3.FocusLost:Connect(function(enter)
					text3.Visible = false
					text2.Visible = true
					if enter then
						sliderapi["SetValue"](tonumber(text3.Text) * (argstable["Double"] or 1))
					end
				end)
				frame.MouseEnter:Connect(function()
					if argstable["HoverText"] and type(argstable["HoverText"]) == "string" then
						hoverbox.Visible = (GuiLibrary["ToggleTooltips"] and hoverbox.TextSize ~= 1)
						local textsize = textService:GetTextSize(argstable["HoverText"], hoverbox.TextSize, hoverbox.Font, Vector2.new(99999, 99999))
						hoverbox.Text = "  "..argstable["HoverText"]:gsub("\n", "\n  ")
						hoverbox.Size = UDim2.new(0, 13 + textsize.X, 0, textsize.Y + 5)
					end
				end)
				if argstable["HoverText"] and type(argstable["HoverText"]) == "string" then
					frame.MouseMoved:Connect(function(x, y)
						hoverbox.Visible = (GuiLibrary["ToggleTooltips"] and hoverbox.TextSize ~= 1)
						hoverbox.Position = UDim2.new(0, (x + 16) * (1 / GuiLibrary["MainRescale"].Scale), 0,	(y - (hoverbox.Size.Y.Offset / 2) - 26) * (1 / GuiLibrary["MainRescale"].Scale))
					end)
				end
				frame.MouseLeave:Connect(function()
					hoverbox.Visible = false
				end)
				GuiLibrary.ObjectsThatCanBeSaved[argstablemain["Name"]..argstable["Name"].."Slider"] = {["Type"] = "Slider", ["Object"] = frame, ["Api"] = sliderapi}
				return sliderapi
			end

			buttonapi["CreateTwoSlider"] = function(argstable)
				
				local sliderapi = {}
				local amount2 = #children2:GetChildren()
				local frame = Instance.new("Frame")
				frame.Size = UDim2.new(0, 220, 0, 50)
				frame.BackgroundTransparency = 1
				frame.ClipsDescendants = true
				frame.LayoutOrder = amount2
				frame.Name = argstable["Name"]
				frame.Parent = children2
				local text1 = Instance.new("TextLabel")
				text1.Font = Enum.Font.SourceSans
				text1.TextXAlignment = Enum.TextXAlignment.Left
				text1.Text = "   "..(translations[argstable["Name"]] ~= nil and translations[argstable["Name"]] or argstable["Name"])
				text1.Size = UDim2.new(1, 0, 0, 25)
				text1.TextColor3 = Color3.fromRGB(160, 160, 160)
				text1.BackgroundTransparency = 1
				text1.TextSize = 17
				text1.Parent = frame
				local text2 = Instance.new("TextLabel")
				text2.Font = Enum.Font.SourceSans
				text2.TextXAlignment = Enum.TextXAlignment.Right
				local text2string = tostring((argstable["Default2"] or argstable["Max"]) / 10)
				text2.Text = (argstable["Decimal"] and (text2string:len() > 1 and text2string or text2string..".0   ") or (argstable["Default2"] or argstable["Max"]) .. ".0   ")
				text2.Size = UDim2.new(1, 0, 0, 25)
				text2.TextColor3 = Color3.fromRGB(160, 160, 160)
				text2.BackgroundTransparency = 1
				text2.TextSize = 17
				text2.Parent = frame
				local text3 = Instance.new("TextLabel")
				text3.Font = Enum.Font.SourceSans
				text3.TextColor3 = Color3.fromRGB(160, 160, 160)
				text3.BackgroundTransparency = 1
				text3.TextXAlignment = Enum.TextXAlignment.Right
				text3.Size = UDim2.new(1, -77, 0, 25)
				text3.TextSize = 17
				local text3string = tostring((argstable["Default"] or argstable["Min"]) / 10)
				text3.Text = (argstable["Decimal"] and (text3string:len() > 1 and text3string or text3string..".0") or (argstable["Default"] or argstable["Min"]) .. ".0")
				text3.Parent = frame
				local text4 = Instance.new("ImageLabel")
				text4.Size = UDim2.new(0, 12, 0, 6)
				text4.Image = downloadVapeAsset("vape/assets/SliderArrowSeperator.png")
				text4.BackgroundTransparency = 1
				text4.Position = UDim2.new(0, 154, 0, 10)
				text4.Parent = frame
				local slider1 = Instance.new("Frame")
				slider1.Size = UDim2.new(0, 200, 0, 2)
				slider1.BorderSizePixel = 0
				slider1.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
				slider1.Position = UDim2.new(0, 10, 0, 32)
				slider1.Name = "Slider"
				slider1.Parent = frame
				local slider2 = Instance.new("Frame")
				slider2.Size = UDim2.new(1, 0, 1, 0)
				slider2.BorderSizePixel = 0
				slider2.BackgroundColor3 = Color3.fromHSV(GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Hue"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Sat"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Value"])
				slider2.Name = "FillSlider"
				slider2.Parent = slider1
				local slider3 = Instance.new("ImageButton")
				slider3.AutoButtonColor = false
				slider3.Size = UDim2.new(0, 15, 0, 16)
				slider3.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
				slider3.BorderSizePixel = 0
				slider3.Image = downloadVapeAsset("vape/assets/SliderArrow1.png")
				slider3.Position = UDim2.new(1, -7, 1, -9)
				slider3.Parent = slider1
				slider3.Name = "ButtonSlider"
				local slider4 = slider3:Clone()
				slider4.Rotation = 180
				slider4.Name = "ButtonSlider2"
				slider4.Parent = slider1
				slider3:GetPropertyChangedSignal("Position"):Connect(function()
					slider2.Size = UDim2.new(0, slider4.AbsolutePosition.X - slider3.AbsolutePosition.X, 1, 0)
					slider2.Position = UDim2.new(slider3.Position.X.Scale, 0, 0, 0)
				end)
				slider4:GetPropertyChangedSignal("Position"):Connect(function()
					slider2.Size = UDim2.new(0, slider4.AbsolutePosition.X - slider3.AbsolutePosition.X, 1, 0)
					slider2.Position = UDim2.new(slider3.Position.X.Scale, 0, 0, 0)
				end)
				slider3.Position = UDim2.new((argstable["Default"] and (argstable["Default"] == argstable["Min"] and 0 or argstable["Default"]/argstable["Max"]) or 0), -8, 1, -9)
				slider4.Position = UDim2.new((argstable["Default2"] and (argstable["Default2"] == argstable["Max"] and 1 or argstable["Default2"]/argstable["Max"]) or 1), -8, 1, -9)
				slider2.Size = UDim2.new(0, slider4.AbsolutePosition.X - slider3.AbsolutePosition.X, 1, 0)
				slider2.Position = UDim2.new(slider3.Position.X.Scale, 0, 0, 0)
				sliderapi["Object"] = frame
				sliderapi["Value"] = (argstable["Default"] or argstable["Min"])
				sliderapi["Value2"] = (argstable["Default2"] or argstable["Max"])
				sliderapi["Max"] = argstable["Max"]
				sliderapi["SetValue"] = function(val)
					val = math.clamp(val, argstable["Min"], argstable["Max"])
					sliderapi["Value"] = val
					--slider2.Size = UDim2.new(math.clamp((val / max), 0.02, 0.97), 0, 1, 0)
					--slider3.Position = UDim2.new((val / max), -8, 1, -9)
					slider3:TweenPosition(UDim2.new((val / argstable["Max"]), -8, 1, -9), Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.05, true)
					local stringthing = tostring(sliderapi["Value"] / 10)
					text3.Text = (argstable["Decimal"] and (stringthing:len() > 1 and stringthing or stringthing..".0") or sliderapi["Value"] .. ".0")
				end
				sliderapi["SetValue2"] = function(val)
					val = math.clamp(val, argstable["Min"], argstable["Max"])
					sliderapi["Value2"] = val
					--slider2.Size = UDim2.new(math.clamp((val / max), 0.02, 0.97), 0, 1, 0)
					--slider4.Position = UDim2.new((val / max), -8, 1, -9)
					local stringthing = tostring(sliderapi["Value2"] / 10)
					text2.Text = (argstable["Decimal"] and (stringthing:len() > 1 and stringthing or stringthing..".0").."   " or sliderapi["Value2"] .. ".0   ")
				end
				sliderapi["GetRandomValue"] = function()
					return Random.new().NextNumber(Random.new(), sliderapi["Value"], sliderapi["Value2"])
				end
				slider3.MouseButton1Down:Connect(function()
					local x,y,xscale,yscale,xscale2 = RelativeXY(slider1, inputService:GetMouseLocation())
					sliderapi["SetValue"](math.floor(argstable["Min"] + ((argstable["Max"] - argstable["Min"]) * xscale)))
					slider3.Position = UDim2.new(xscale2, -8, 1, -9)
					local move
					local kill
					move = inputService.InputChanged:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseMovement then
							local x,y,xscale,yscale,xscale2 = RelativeXY(slider1, inputService:GetMouseLocation())
							sliderapi["SetValue"](math.floor(argstable["Min"] + ((argstable["Max"] - argstable["Min"]) * xscale)))
						--	slider3.Position = UDim2.new(xscale2, -8, 1, -9)
							slider3:TweenPosition(UDim2.new(xscale2, -8, 1, -9), Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.05, true)
						end
					end)
					kill = inputService.InputEnded:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 then
							move:Disconnect()
							kill:Disconnect()
						end
					end)
				end)
				slider4.MouseButton1Down:Connect(function()
					local x,y,xscale,yscale,xscale2 = RelativeXY(slider1, inputService:GetMouseLocation())
					sliderapi["SetValue2"](math.floor(argstable["Min"] + ((argstable["Max"] - argstable["Min"]) * xscale)))
					slider4.Position = UDim2.new(xscale2, -8, 1, -9)
					local move
					local kill
					move = inputService.InputChanged:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseMovement then
							local x,y,xscale,yscale,xscale2 = RelativeXY(slider1, inputService:GetMouseLocation())
							sliderapi["SetValue2"](math.floor(argstable["Min"] + ((argstable["Max"] - argstable["Min"]) * xscale)))
							--slider4.Position = UDim2.new(xscale2, -8, 1, -9)
							slider4:TweenPosition(UDim2.new(xscale2, -8, 1, -9), Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.05, true)
						end
					end)
					kill = inputService.InputEnded:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 then
							move:Disconnect()
							kill:Disconnect()
						end
					end)
				end)
				GuiLibrary.ObjectsThatCanBeSaved[argstablemain["Name"]..argstable["Name"].."TwoSlider"] = {["Type"] = "TwoSlider", ["Object"] = frame, ["Api"] = sliderapi}
				return sliderapi
			end

			buttonapi["CreateToggle"] = function(argstable)
				local buttonapi = {}
				local currentanim
				local amount = #children2:GetChildren()
				local buttontext = Instance.new("TextButton")
				buttontext.AutoButtonColor = false
				buttontext.BackgroundTransparency = 1
				buttontext.Name = "ButtonText"
				buttontext.Text = "          "..(translations[argstable["Name"]] ~= nil and translations[argstable["Name"]] or argstable["Name"])
				buttontext.Name = argstable["Name"]
				buttontext.LayoutOrder = amount
				buttontext.Size = UDim2.new(1, 0, 0, 30)
				buttontext.Active = false
				buttontext.TextColor3 = Color3.fromRGB(160, 160, 160)
				buttontext.TextSize = 14
				buttontext.Font = Enum.Font.Arial
				buttontext.TextXAlignment = Enum.TextXAlignment.Left
				buttontext.Position = UDim2.new(0, (icon and 36 or 10), 0, 0)
				buttontext.Parent = children2
				local buttonarrow = Instance.new("ImageLabel")
				buttonarrow.Size = UDim2.new(1, 0, 0, 0)
				buttonarrow.Position = UDim2.new(0, 0, 1, -4)
				buttonarrow.BackgroundTransparency = 1
				buttonarrow.Name = "ToggleArrow"
				buttonarrow.Image = downloadVapeAsset("vape/assets/ToggleArrow.png")
				buttonarrow.Visible = false
				buttonarrow.Parent = buttontext
				local toggleframe1 = Instance.new("Frame")
				toggleframe1.Size = UDim2.new(0, 22, 0, 12)
				toggleframe1.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
				toggleframe1.BorderSizePixel = 0
				toggleframe1.Name = "ToggleFrame1"
				toggleframe1.Position = UDim2.new(1, -30, 0, 10)
				toggleframe1.Parent = buttontext
				local toggleframe2 = Instance.new("Frame")
				toggleframe2.Size = UDim2.new(0, 8, 0, 8)
				toggleframe2.Active = false
				toggleframe2.Position = UDim2.new(0, 2, 0, 2)
				toggleframe2.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
				toggleframe2.BorderSizePixel = 0
				toggleframe2.Parent = toggleframe1
				local uicorner = Instance.new("UICorner")
				uicorner.CornerRadius = UDim.new(0, 16)
				uicorner.Parent = toggleframe1
				local uicorner2 = Instance.new("UICorner")
				uicorner2.CornerRadius = UDim.new(0, 16)
				uicorner2.Parent = toggleframe2

				buttonapi["Enabled"] = false
				buttonapi["Keybind"] = ""
				buttonapi["Default"] = argstable["Default"]
				buttonapi["Object"] = buttontext
				buttonapi.Connections = {}
				buttonapi["ToggleButton"] = function(toggle, first)
					buttonapi["Enabled"] = toggle
					if buttonapi["Enabled"] then
						if not first then
							tweenService:Create(toggleframe1, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromHSV(GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Hue"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Sat"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Value"])}):Play()
						else
							toggleframe1.BackgroundColor3 = Color3.fromHSV(GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Hue"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Sat"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Value"])
						end
						toggleframe2:TweenPosition(UDim2.new(0, 12, 0, 2), Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.1, true)
					else
						for i, v in pairs(buttonapi.Connections) do
							if v.Disconnect then pcall(function() v:Disconnect() end) continue end
							if v.disconnect then pcall(function() v:disconnect() end) continue end
						end
						table.clear(buttonapi.Connections)
						if not first then
							tweenService:Create(toggleframe1, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
						else
							toggleframe1.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
						end
						toggleframe2:TweenPosition(UDim2.new(0, 2, 0, 2), Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.1, true)
					end
					argstable["Function"](buttonapi["Enabled"])
				end
				if argstable["Default"] then
					buttonapi["ToggleButton"](argstable["Default"], true)
				end
				buttontext.MouseButton1Click:Connect(function() buttonapi["ToggleButton"](not buttonapi["Enabled"], false) end)
				buttontext.MouseEnter:Connect(function()
					if argstable["HoverText"] and type(argstable["HoverText"]) == "string" then
						hoverbox.Visible = (GuiLibrary["ToggleTooltips"] and hoverbox.TextSize ~= 1)
						local textsize = textService:GetTextSize(argstable["HoverText"], hoverbox.TextSize, hoverbox.Font, Vector2.new(99999, 99999))
						hoverbox.Text = "  "..argstable["HoverText"]:gsub("\n", "\n  ")
						hoverbox.Size = UDim2.new(0, 13 + textsize.X, 0, textsize.Y + 5)
					end
					if buttonapi["Enabled"] == false then
						tweenService:Create(toggleframe1, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(100, 100, 100)}):Play()
					end
				end)
				if argstable["HoverText"] and type(argstable["HoverText"]) == "string" then
					buttontext.MouseMoved:Connect(function(x, y)
						hoverbox.Visible = (GuiLibrary["ToggleTooltips"] and hoverbox.TextSize ~= 1)
						hoverbox.Position = UDim2.new(0, (x + 16) * (1 / GuiLibrary["MainRescale"].Scale), 0,	(y - (hoverbox.Size.Y.Offset / 2) - 26) * (1 / GuiLibrary["MainRescale"].Scale))
					end)
				end
				buttontext.MouseLeave:Connect(function()
					hoverbox.Visible = false
					if buttonapi["Enabled"] == false then
						tweenService:Create(toggleframe1, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
					end
				end)
		
				GuiLibrary.ObjectsThatCanBeSaved[argstablemain["Name"]..argstable["Name"].."Toggle"] = {["Type"] = "Toggle", ["Object"] = buttontext, ["Api"] = buttonapi}
				return buttonapi
			end

			if argstablemain["Default"] then
				buttonapi["ToggleButton"](false, true)
			end
			button.MouseButton1Click:Connect(function() 
				buttonapi["ToggleButton"](true) 
			end)
			if inputService.TouchEnabled then 
				local touched = false
				button.MouseButton1Down:Connect(function()
					touched = true
					local oldbuttonposition = button.AbsolutePosition
					local touchtick = tick()
					repeat 
						task.wait() 
						if button.AbsolutePosition ~= oldbuttonposition then 
							touched = false
							break
						end
					until (tick() - touchtick) > 1 or not touched or not clickgui.Visible
					if touched and clickgui.Visible then 
						clickgui.Visible = false
						legitgui.Visible = not clickgui.Visible
						game:GetService("RunService"):SetRobloxGuiFocused(clickgui.Visible and GuiLibrary["MainBlur"].Size ~= 0 or guiService:GetErrorType() ~= Enum.ConnectionError.OK)
						for _, mobileButton in pairs(GuiLibrary.MobileButtons) do mobileButton.Visible = not clickgui.Visible end	
						local touchconnection
						touchconnection = inputService.InputBegan:Connect(function(inputType)
							if inputType.UserInputType == Enum.UserInputType.Touch then 
								createMobileButton(buttonapi, inputType.Position)
								clickgui.Visible = true
								legitgui.Visible = not clickgui.Visible
								game:GetService("RunService"):SetRobloxGuiFocused(clickgui.Visible and GuiLibrary["MainBlur"].Size ~= 0 or guiService:GetErrorType() ~= Enum.ConnectionError.OK)
								for _, mobileButton in pairs(GuiLibrary.MobileButtons) do mobileButton.Visible = not clickgui.Visible end		
								touchconnection:Disconnect()
							end
						end)
					end
				end)
				button.MouseButton1Up:Connect(function()
					touched = false
				end)
			end
			button.MouseEnter:Connect(function() 
				bindbkg.Visible = true
				if not buttonapi["Enabled"] then
					currenttween = tweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(31, 30, 31)})
					currenttween:Play()
				end
			end)
			button.MouseLeave:Connect(function() 
				hoverbox.Visible = false
				if buttonapi["Keybind"] == "" then
					bindbkg.Visible = false 
				end
				if not buttonapi["Enabled"] then
					currenttween = tweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(26, 25, 26)})
					currenttween:Play()
				end
			end)
			bindbkg2.MouseButton1Click:Connect(function()
				GuiLibrary["PressedKeybindKey"] = buttonapi["Keybind"]
				if buttonapi["Keybind"] == "" then
					GuiLibrary["KeybindCaptured"] = false
					GuiLibrary["PressedKeybindKey"] = "A"
				end
				bindbkg2.Visible = false
			end)
			bindbkg.MouseButton1Click:Connect(function()
				if GuiLibrary["KeybindCaptured"] == false then
					GuiLibrary["KeybindCaptured"] = true
					task.spawn(function()
						bindimg.Visible = false
						bindbkg2.Visible = true
						bindtext2.Visible = true
						bindtext3.Text = "   PRESS A KEY TO BIND"
						bindtext2.Size = UDim2.new(0, 154, 0, 40)
						repeat task.wait() bindtext2.Visible = true until GuiLibrary["PressedKeybindKey"] ~= ""
						if GuiLibrary["KeybindCaptured"] then
							buttonapi["SetKeybind"]((GuiLibrary["PressedKeybindKey"] == buttonapi["Keybind"] and "" or GuiLibrary["PressedKeybindKey"]))
						end
						GuiLibrary["PressedKeybindKey"] = ""
						GuiLibrary["KeybindCaptured"] = false
						bindbkg2.Visible = false
						bindtext3.Text = (buttonapi["Keybind"] == "" and "   BIND REMOVED" or "   BOUND TO "..buttonapi["Keybind"]:upper())
						bindtext2.Size = UDim2.new(0, textService:GetTextSize(bindtext3.Text, bindtext3.TextSize, bindtext3.Font, Vector2.new(10000, 100000)).X + 20, 0, 40)
						task.wait(1)
						bindtext2.Visible = false
					end)
				end
			end)
			bindbkg.MouseEnter:Connect(function() 
				bindimg.Image = downloadVapeAsset("vape/assets/PencilIcon.png") 
				bindimg.Visible = true
				bindtext.Visible = false
				bindbkg.Size = UDim2.new(0, 20, 0, 21)
				bindbkg.Position = UDim2.new(1, -56, 0, 9)
			end)
			bindbkg.MouseLeave:Connect(function() 
				bindimg.Image = downloadVapeAsset("vape/assets/KeybindIcon.png")
				if buttonapi["Keybind"] ~= "" then
					bindimg.Visible = false
					bindtext.Visible = true
					bindbkg.Size = newsize
					bindbkg.Position = UDim2.new(1, -(36 + newsize.X.Offset), 0, 9)
				end
			end)
			button.MouseButton2Click:Connect(buttonapi["ExpandToggle"])
			button2.MouseButton1Click:Connect(buttonapi["ExpandToggle"])
			GuiLibrary.ObjectsThatCanBeSaved[argstablemain["Name"].."OptionsButton"] = {["Type"] = "OptionsButton", ["Object"] = button, ["ChildrenObject"] = children2, ["Api"] = buttonapi, ["SortOrder"] = 0}

			local sorttable1 = {}
			for i,v in pairs(children:GetChildren()) do
				if v:IsA("TextButton") then
					table.insert(sorttable1, v.Name)
				end
			end
			table.sort(sorttable1)
			for i2,v2 in pairs(sorttable1) do
				if v2:find("Button") then 
					local findstr = v2:gsub("Button", "Children")
					local sortnum = i2
					local findstr2 = v2:gsub("Button", "OptionsButton")
					if GuiLibrary.ObjectsThatCanBeSaved[findstr2] then
						GuiLibrary.ObjectsThatCanBeSaved[findstr2]["SortOrder"] = sortnum
					end
					children[v2].LayoutOrder = sortnum
					if children:FindFirstChild(findstr) then
						children[findstr].LayoutOrder = sortnum
					end
				else
					children[v2].LayoutOrder = i2
				end
			end
			GuiLibrary.ObjectsThatCanBeSaved[argstablemain2["Name"].."Window"]["SortOrder"] = #sorttable1

			return buttonapi
		end

		return windowapi
	end

	GuiLibrary["CreateWindow2"] = function(argstablemain)
		local windowapi = {}
		local windowtitle = Instance.new("TextButton")
		windowtitle.Text = ""
		windowtitle.AutoButtonColor = false
		windowtitle.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
		windowtitle.Size = UDim2.new(0, 220, 0, 41)
		windowtitle.Position = UDim2.new(0, 223, 0, 6)
		windowtitle.Name = "MainWindow"
		windowtitle.Visible = false
		windowtitle.Name = argstablemain["Name"]
		windowtitle.Parent = clickgui
		local windowshadow = Instance.new("ImageLabel")
		windowshadow.AnchorPoint = Vector2.new(0.5, 0.5)
		windowshadow.Position = UDim2.new(0.5, 0, 0.5, 0)
		windowshadow.Image = downloadVapeAsset("vape/assets/WindowBlur.png")
		windowshadow.BackgroundTransparency = 1
		windowshadow.ZIndex = -1
		windowshadow.Size = UDim2.new(1, 6, 1, 6)
		windowshadow.ImageColor3 = Color3.new(0, 0, 0)
		windowshadow.ScaleType = Enum.ScaleType.Slice
		windowshadow.SliceCenter = Rect.new(10, 10, 118, 118)
		windowshadow.Parent = windowtitle
		local windowicon = Instance.new("ImageLabel")
		windowicon.Size = UDim2.new(0, argstablemain["IconSize"], 0, 16)
		windowicon.Image = downloadVapeAsset(argstablemain["Icon"])
		windowicon.ImageColor3 = Color3.fromRGB(200, 200, 200)
		windowicon.Name = "WindowIcon"
		windowicon.BackgroundTransparency = 1
		windowicon.Position = UDim2.new(0, 12, 0, 12)
		windowicon.Parent = windowtitle
		local windowtext = Instance.new("TextLabel")
		windowtext.Size = UDim2.new(0, 155, 0, 41)
		windowtext.BackgroundTransparency = 1
		windowtext.Name = "WindowTitle"
		windowtext.Position = UDim2.new(0, 36, 0, 1)
		windowtext.TextXAlignment = Enum.TextXAlignment.Left
		windowtext.Font = Enum.Font.Arial
		windowtext.TextSize = 14
		windowtext.Text = (translations[argstablemain["Name"]] ~= nil and translations[argstablemain["Name"]] or argstablemain["Name"])
		windowtext.TextColor3 = Color3.fromRGB(200, 200, 200)
		windowtext.Parent = windowtitle
		local expandbutton = Instance.new("TextButton")
		expandbutton.Text = ""
		expandbutton.BackgroundTransparency = 1
		expandbutton.BorderSizePixel = 0
		expandbutton.BackgroundColor3 = Color3.new(1, 1, 1)
		expandbutton.Name = "ExpandButton"
		expandbutton.Size = UDim2.new(0, 24, 0, 16)
		expandbutton.Position = UDim2.new(1, -28, 0, 13)
		expandbutton.Parent = windowtitle
		local expandbutton2 = Instance.new("ImageLabel")
		expandbutton2.Active = false
		expandbutton2.Size = UDim2.new(0, 9, 0, 4)
		expandbutton2.Image = downloadVapeAsset("vape/assets/UpArrow.png")
		expandbutton2.Position = UDim2.new(0, 8, 0, 6)
		expandbutton2.Name = "ExpandButton2"
		expandbutton2.BackgroundTransparency = 1
		expandbutton2.Parent = expandbutton
		local settingsbutton = Instance.new("ImageButton")
		settingsbutton.Active = true
		settingsbutton.Size = UDim2.new(0, 16, 0, 16)
		settingsbutton.Image = downloadVapeAsset("vape/assets/SettingsWheel2.png")
		settingsbutton.Position = UDim2.new(1, -53, 0, 13)
		settingsbutton.Name = "OptionsButton"
		settingsbutton.BackgroundTransparency = 1
		settingsbutton.Rotation = 180
		settingsbutton.Parent = windowtitle
		local children = Instance.new("Frame")
		children.BackgroundTransparency = 1
		children.Size = UDim2.new(1, 0, 1, -4)
		children.Position = UDim2.new(0, 0, 0, 41)
		children.Visible = false
		children.Parent = windowtitle
		local children2 = Instance.new("Frame")
		children2.BackgroundTransparency = 1
		children2.Size = UDim2.new(0, 220, 1, -4)
		children2.Name = "SettingsChildren"
		children2.Position = UDim2.new(0, 0, 0, 41)
		children2.Parent = windowtitle
		children2.Visible = false
		local windowcorner = Instance.new("UICorner")
		windowcorner.CornerRadius = UDim.new(0, 4)
		windowcorner.Parent = windowtitle
		local uilistlayout = Instance.new("UIListLayout")
		uilistlayout.SortOrder = Enum.SortOrder.LayoutOrder
		uilistlayout.Parent = children
		local uilistlayout2 = Instance.new("UIListLayout")
		uilistlayout2.SortOrder = Enum.SortOrder.LayoutOrder
		uilistlayout2.Parent = children2
		uilistlayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			if children.Visible then
				windowtitle.Size = UDim2.new(0, 220, 0, 45 + uilistlayout.AbsoluteContentSize.Y * (1 / GuiLibrary["MainRescale"].Scale))
				--560
			end
		end)
		local noexpand = false
		dragGUI(windowtitle)
		GuiLibrary.ObjectsThatCanBeSaved[argstablemain["Name"].."Window"] = {["Object"] = windowtitle, ["ChildrenObject"] = children, ["Type"] = "Window", ["Api"] = windowapi}

		windowapi["SetVisible"] = function(value)
			windowtitle.Visible = value
		end

		windowapi["ExpandToggle"] = function()
			if noexpand == false then
				children.Visible = not children.Visible
				children2.Visible = false
				if children.Visible then
					expandbutton2.Image = downloadVapeAsset("vape/assets/DownArrow.png")
					windowtitle.Size = UDim2.new(0, 220, 0, 45 + uilistlayout.AbsoluteContentSize.Y)
				else
					expandbutton2.Image = downloadVapeAsset("vape/assets/UpArrow.png")
					windowtitle.Size = UDim2.new(0, 220, 0, 41)
				end
			end
		end

		uilistlayout2:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			if children2.Visible then
				windowtitle.Size = UDim2.new(0, 220, 0, 45 + uilistlayout2.AbsoluteContentSize.Y)
			end
		end)
		settingsbutton.MouseButton1Click:Connect(function()
			if children.Visible then
				children.Visible = false
				children2.Visible = true
				windowtitle.Size = UDim2.new(0, 220, 0, 45 + uilistlayout2.AbsoluteContentSize.Y)
			else
				children.Visible = true
				children2.Visible = false
				windowtitle.Size = UDim2.new(0, 220, 0, 45 + uilistlayout.AbsoluteContentSize.Y)
			end
		end)
		windowtitle.MouseButton2Click:Connect(windowapi["ExpandToggle"])
		expandbutton.MouseButton1Click:Connect(windowapi["ExpandToggle"])
		expandbutton.MouseButton2Click:Connect(windowapi["ExpandToggle"])

		windowapi["CreateColorSlider"] = function(argstable)
			local min, max = 0, 1
			local sliderapi = {}
			local amount2 = #children2:GetChildren()
			local frame = Instance.new("Frame")
			frame.Size = UDim2.new(0, 220, 0, 50)
			frame.BorderSizePixel = 0
			frame.BackgroundTransparency = 1
			frame.LayoutOrder = amount2
			frame.Name = argstable["Name"]
			frame.Parent = children2
			local text1 = Instance.new("TextLabel")
			text1.Font = Enum.Font.Arial
			text1.TextXAlignment = Enum.TextXAlignment.Left
			text1.Text = "          "..(translations[argstable["Name"]] ~= nil and translations[argstable["Name"]] or argstable["Name"])
			text1.Size = UDim2.new(1, 0, 0, 27)
			text1.TextColor3 = Color3.fromRGB(160, 160, 160)
			text1.Position = UDim2.new(0, 0, 0, 4)
			text1.BackgroundTransparency = 1
			text1.TextSize = 12
			text1.Parent = frame
			local text2 = Instance.new("Frame")
			text2.Size = UDim2.new(0, 12, 0, 12)
			text2.Position = UDim2.new(1, -22, 0, 9)
			text2.BackgroundColor3 = Color3.fromHSV(0.44, 1, 1)
			text2.Parent = frame
			local uicorner4 = Instance.new("UICorner")
			uicorner4.CornerRadius = UDim.new(0, 4)
			uicorner4.Parent = text2
			local slider1 = Instance.new("TextButton")
			slider1.AutoButtonColor = false
			slider1.Text = ""
			slider1.Size = UDim2.new(0, 200, 0, 2)
			slider1.BorderSizePixel = 0
			slider1.BackgroundColor3 = Color3.new(1, 1, 1)
			slider1.Position = UDim2.new(0, 10, 0, 32)
			slider1.Name = "Slider"
			slider1.Parent = frame
			local uigradient = Instance.new("UIGradient")
			uigradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 1, 1)), ColorSequenceKeypoint.new(0.2, Color3.fromHSV(0.2, 1, 1)), ColorSequenceKeypoint.new(0.3, Color3.fromHSV(0.3, 1, 1)), ColorSequenceKeypoint.new(0.4, Color3.fromHSV(0.4, 1, 1)), ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5, 1, 1)), ColorSequenceKeypoint.new(0.6, Color3.fromHSV(0.6, 1, 1)), ColorSequenceKeypoint.new(0.7, Color3.fromHSV(0.7, 1, 1)), ColorSequenceKeypoint.new(0.8, Color3.fromHSV(0.8, 1, 1)), ColorSequenceKeypoint.new(0.9, Color3.fromHSV(0.9, 1, 1)), ColorSequenceKeypoint.new(1, Color3.fromHSV(1, 1, 1))})
			uigradient.Parent = slider1
			local slider3 = Instance.new("ImageButton")
			slider3.AutoButtonColor = false
			slider3.Size = UDim2.new(0, 24, 0, 16)
			slider3.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
			slider3.BorderSizePixel = 0
			slider3.Image = downloadVapeAsset("vape/assets/SliderButton1.png")
			slider3.Position = UDim2.new(0.44, -11, 0, -7)
			slider3.Parent = slider1
			slider3.Name = "ButtonSlider"
			local slidersat = frame:Clone()
			slidersat.TextLabel.Text = "    Saturation"
			slidersat.Name = frame.Name.."Saturation"
			slidersat.BackgroundTransparency = 0
			slidersat.Visible = false
			slidersat.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			slidersat.Slider.UIGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 0, 1)), ColorSequenceKeypoint.new(1, Color3.fromHSV(0.4, 1, 1))})
			slidersat.Slider.ButtonSlider.Position = UDim2.new(0.95, -11, 0, -7)
			slidersat.Slider.ButtonSlider.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			slidersat.Frame:Remove()
			slidersat.Parent = children2
			local sliderval = frame:Clone()
			sliderval.TextLabel.Text = "    Vibrance"
			sliderval.Name = frame.Name.."Vibrance"
			sliderval.BackgroundTransparency = 0
			sliderval.Visible = false
			sliderval.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			sliderval.Slider.UIGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 0, 0)), ColorSequenceKeypoint.new(1, Color3.fromHSV(0.4, 1, 1))})
			sliderval.Slider.ButtonSlider.Position = UDim2.new(0.95, -11, 0, -7)
			sliderval.Slider.ButtonSlider.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			sliderval.Frame:Remove()
			sliderval.Parent = children2
			local sliderexpand = Instance.new("ImageButton")
			sliderexpand.AutoButtonColor = false
			sliderexpand.Size = UDim2.new(0, 15, 0, 15)
			sliderexpand.BackgroundTransparency = 1
			sliderexpand.Position = UDim2.new(0, textService:GetTextSize(text1.Text, text1.TextSize, text1.Font, Vector2.new(10000, 100000)).X + 3, 0, 6)
			sliderexpand.Image = downloadVapeAsset("vape/assets/HoverArrow.png")
			sliderexpand.Parent = frame
			sliderexpand.MouseEnter:Connect(function()
				sliderexpand.Image = downloadVapeAsset("vape/assets/HoverArrow2.png")
			end)
			sliderexpand.MouseLeave:Connect(function()
				sliderexpand.Image = downloadVapeAsset("vape/assets/HoverArrow.png")
			end)
			sliderexpand.MouseButton1Click:Connect(function()
				local val = not slidersat.Visible
				slidersat.Visible = val
				sliderval.Visible = val
				sliderexpand.Rotation = (val and 180 or 0)
			end)
			sliderapi["Hue"] = 0.44
			sliderapi["Sat"] = 1
			sliderapi["Value"] = 1
			sliderapi["Object"] = frame
			sliderapi["RainbowValue"] = false
			sliderapi["SetValue"] = function(hue, sat, val)
				hue = (hue or sliderapi["Hue"])
				sat = (sat or sliderapi["Sat"])
				val = (val or sliderapi["Value"])
				text2.BackgroundColor3 = Color3.fromHSV(hue, sat, val)
				pcall(function()
					slidersat.Slider.UIGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 0, val)), ColorSequenceKeypoint.new(1, Color3.fromHSV(hue, 1, val))})
					sliderval.Slider.UIGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 0, 0)), ColorSequenceKeypoint.new(1, Color3.fromHSV(hue, sat, 1))})
				end)
				sliderapi["Hue"] = hue
				sliderapi["Sat"] = sat
				sliderapi["Value"] = val
				slider3.Position = UDim2.new(math.clamp(hue, 0.02, 0.95), -9, 0, -7)
				argstable["Function"](hue, sat, val)
			end
			sliderapi["SetRainbow"] = function(val)
				sliderapi["RainbowValue"] = val
				if sliderapi["RainbowValue"] then
					table.insert(GuiLibrary.RainbowSliders, sliderapi)
				else
					table.remove(GuiLibrary.RainbowSliders, table.find(GuiLibrary.RainbowSliders, sliderapi))
				end
			end
			local clicktick = tick()
			local function slidercode(obj, valtochange)
				if clicktick > tick() then
					sliderapi["SetRainbow"](not sliderapi["RainbowValue"])
				end
				clicktick = tick() + 0.3
				local x,y,xscale,yscale,xscale2 = RelativeXY(obj, inputService:GetMouseLocation())
				sliderapi["SetValue"]((valtochange == "Hue" and (min + ((max - min) * xscale)) or false), (valtochange == "Sat" and (min + ((max - min) * xscale)) or false), (valtochange == "Value" and (min + ((max - min) * xscale)) or false))
				obj.ButtonSlider.Position = UDim2.new(math.clamp(xscale2, 0.02, 0.95), -9, 0, -7)
				local move
				local kill
				move = inputService.InputChanged:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseMovement then
						local x,y,xscale,yscale,xscale2 = RelativeXY(obj, inputService:GetMouseLocation())
						sliderapi["SetValue"]((valtochange == "Hue" and (min + ((max - min) * xscale)) or false), (valtochange == "Sat" and (min + ((max - min) * xscale)) or false), (valtochange == "Value" and (min + ((max - min) * xscale)) or false))
						obj.ButtonSlider.Position = UDim2.new(math.clamp(xscale2, 0.02, 0.95), -9, 0, -7)
					end
				end)
				kill = inputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						move:Disconnect()
						kill:Disconnect()
					end
				end)
			end
			slider1.MouseButton1Down:Connect(function()
				slidercode(slider1, "Hue")
			end)
			slider3.MouseButton1Down:Connect(function()
				slidercode(slider1, "Hue")
			end)
			slidersat.Slider.MouseButton1Down:Connect(function()
				slidercode(slidersat.Slider, "Sat")
			end)
			slidersat.Slider.ButtonSlider.MouseButton1Down:Connect(function()
				slidercode(slidersat.Slider, "Sat")
			end)
			sliderval.Slider.MouseButton1Down:Connect(function()
				slidercode(sliderval.Slider, "Value")
			end)
			sliderval.Slider.ButtonSlider.MouseButton1Down:Connect(function()
				slidercode(sliderval.Slider, "Value")
			end)
			
			frame.MouseEnter:Connect(function()
				if argstable["HoverText"] and type(argstable["HoverText"]) == "string" then
					hoverbox.Visible = (GuiLibrary["ToggleTooltips"] and hoverbox.TextSize ~= 1)
					local textsize = textService:GetTextSize(argstable["HoverText"], hoverbox.TextSize, hoverbox.Font, Vector2.new(99999, 99999))
					hoverbox.Text = " "..argstable["HoverText"]:gsub("\n", "\n ")
					hoverbox.Size = UDim2.new(0, 8 + textsize.X, 0, textsize.Y + 5)
				end
			end)
			if argstable["HoverText"] and type(argstable["HoverText"]) == "string" then
				frame.MouseMoved:Connect(function(x, y)
					hoverbox.Visible = (GuiLibrary["ToggleTooltips"] and hoverbox.TextSize ~= 1)
					hoverbox.Position = UDim2.new(0, (x + 16) * (1 / GuiLibrary["MainRescale"].Scale), 0,	(y - (hoverbox.Size.Y.Offset / 2) - 26) * (1 / GuiLibrary["MainRescale"].Scale))
				end)
			end
			frame.MouseLeave:Connect(function()
				hoverbox.Visible = false
				if buttonapi and buttonapi["Enabled"] == false then
					tweenService:Create(toggleframe1, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
				end
			end)
			GuiLibrary.ObjectsThatCanBeSaved[argstable["Name"].."SliderColor"] = {["Type"] = "ColorSlider", ["Object"] = frame, ["Object2"] = slidersat, ["Object3"] = sliderval, ["Api"] = sliderapi}
			return sliderapi
		end

		windowapi["CreateToggle"] = function(argstable)
			local buttonapi = {}
			local currentanim
			local amount = #children2:GetChildren()
			local buttontext = Instance.new("TextButton")
			buttontext.AutoButtonColor = false
			buttontext.BackgroundTransparency = 1
			buttontext.Name = "ButtonText"
			buttontext.Text = "          "..(translations[argstable["Name"]] ~= nil and translations[argstable["Name"]] or argstable["Name"])
			buttontext.Name = argstable["Name"]
			buttontext.LayoutOrder = amount
			buttontext.Size = UDim2.new(1, 0, 0, 30)
			buttontext.Active = false
			buttontext.TextColor3 = Color3.fromRGB(160, 160, 160)
			buttontext.TextSize = 14
			buttontext.Font = Enum.Font.Arial
			buttontext.TextXAlignment = Enum.TextXAlignment.Left
			buttontext.Position = UDim2.new(0, (icon and 36 or 10), 0, 0)
			buttontext.Parent = children2
			local buttonarrow = Instance.new("ImageLabel")
			buttonarrow.Size = UDim2.new(1, 0, 0, 4)
			buttonarrow.Position = UDim2.new(0, 0, 1, -4)
			buttonarrow.BackgroundTransparency = 1
			buttonarrow.Name = "ToggleArrow"
			buttonarrow.Image = downloadVapeAsset("vape/assets/ToggleArrow.png")
			buttonarrow.Visible = false
			buttonarrow.Parent = buttontext
			local toggleframe1 = Instance.new("Frame")
			toggleframe1.Size = UDim2.new(0, 22, 0, 12)
			toggleframe1.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			toggleframe1.BorderSizePixel = 0
			toggleframe1.Name = "ToggleFrame1"
			toggleframe1.Position = UDim2.new(1, -30, 0, 10)
			toggleframe1.Parent = buttontext
			local toggleframe2 = Instance.new("Frame")
			toggleframe2.Size = UDim2.new(0, 8, 0, 8)
			toggleframe2.Active = false
			toggleframe2.Position = UDim2.new(0, 2, 0, 2)
			toggleframe2.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
			toggleframe2.BorderSizePixel = 0
			toggleframe2.Parent = toggleframe1
			local uicorner = Instance.new("UICorner")
			uicorner.CornerRadius = UDim.new(0, 16)
			uicorner.Parent = toggleframe1
			local uicorner2 = Instance.new("UICorner")
			uicorner2.CornerRadius = UDim.new(0, 16)
			uicorner2.Parent = toggleframe2

			buttonapi["Enabled"] = false
			buttonapi["Keybind"] = ""
			buttonapi["Default"] = argstable["Default"]
			buttonapi["Object"] = buttontext
			buttonapi["ToggleButton"] = function(toggle, first)
				buttonapi["Enabled"] = toggle
				if buttonapi["Enabled"] then
					if not first then
						tweenService:Create(toggleframe1, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromHSV(GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Hue"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Sat"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Value"])}):Play()
					else
						toggleframe1.BackgroundColor3 = Color3.fromHSV(GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Hue"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Sat"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Value"])
					end
					toggleframe2:TweenPosition(UDim2.new(0, 12, 0, 2), Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.1, true)
				else
					if not first then
						tweenService:Create(toggleframe1, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
					else
						toggleframe1.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
					end
					toggleframe2:TweenPosition(UDim2.new(0, 2, 0, 2), Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.1, true)
				end
				argstable["Function"](buttonapi["Enabled"])
			end
			if argstable["Default"] then
				buttonapi["ToggleButton"](argstable["Default"], true)
			end
			buttontext.MouseButton1Click:Connect(function() buttonapi["ToggleButton"](not buttonapi["Enabled"], false) end)
			buttontext.MouseEnter:Connect(function()
				if argstable["HoverText"] and type(argstable["HoverText"]) == "string" then
					hoverbox.Visible = (GuiLibrary["ToggleTooltips"] and hoverbox.TextSize ~= 1)
					local textsize = textService:GetTextSize(argstable["HoverText"], hoverbox.TextSize, hoverbox.Font, Vector2.new(99999, 99999))
					hoverbox.Text = " "..argstable["HoverText"]:gsub("\n", "\n ")
					hoverbox.Size = UDim2.new(0, 8 + textsize.X, 0, textsize.Y + 5)
				end
				if buttonapi["Enabled"] == false then
					tweenService:Create(toggleframe1, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(100, 100, 100)}):Play()
				end
			end)
			if argstable["HoverText"] and type(argstable["HoverText"]) == "string" then
				buttontext.MouseMoved:Connect(function(x, y)
					hoverbox.Visible = (GuiLibrary["ToggleTooltips"] and hoverbox.TextSize ~= 1)
					hoverbox.Position = UDim2.new(0, (x + 16) * (1 / GuiLibrary["MainRescale"].Scale), 0,	(y - (hoverbox.Size.Y.Offset / 2) - 26) * (1 / GuiLibrary["MainRescale"].Scale))
				end)
			end
			buttontext.MouseLeave:Connect(function()
				hoverbox.Visible = false
				if buttonapi["Enabled"] == false then
					tweenService:Create(toggleframe1, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
				end
			end)

			GuiLibrary.ObjectsThatCanBeSaved[argstable["Name"].."Toggle"] = {["Type"] = "Toggle", ["Object"] = buttontext, ["Api"] = buttonapi}
			return buttonapi
		end

		windowapi["CreateTextList"] = function(argstable)
			local textGuiLibrary = {}
			local amount = #children:GetChildren()
			local frame = Instance.new("Frame")
			frame.Size = UDim2.new(0, 220, 0, 40)
			frame.BackgroundTransparency = 1
			frame.ClipsDescendants = true
			frame.LayoutOrder = amount
			frame.Name = argstable["Name"]
			frame.Parent = children
			local textboxbkg = Instance.new("ImageLabel")
			textboxbkg.BackgroundTransparency = 1
			textboxbkg.Name = "AddBoxBKG"
			textboxbkg.Size = UDim2.new(0, (argstable["Name"] == "ProfilesList" and 150 or 200), 0, 31)
			textboxbkg.Position = UDim2.new(0, 10, 0, 5)
			textboxbkg.ClipsDescendants = true
			textboxbkg.Image = downloadVapeAsset((argstable["Name"] == "ProfilesList" and "vape/assets/TextBoxBKG2.png" or "vape/assets/TextBoxBKG.png"))
			textboxbkg.Parent = frame
			local textbox = Instance.new("TextBox")
			textbox.Size = UDim2.new(0, 159, 1, 0)
			textbox.Position = UDim2.new(0, 11, 0, 0)
			textbox.TextXAlignment = Enum.TextXAlignment.Left
			textbox.Name = "AddBox"
			textbox.BackgroundTransparency = 1
			textbox.TextColor3 = Color3.new(1, 1, 1)
			textbox.PlaceholderColor3 = Color3.fromRGB(200, 200, 200)
			textbox.Font = Enum.Font.SourceSans
			textbox.Text = ""
			textbox.PlaceholderText = argstable["TempText"]
			textbox.TextSize = 17
			textbox.Parent = textboxbkg
			local addbutton = Instance.new("ImageButton")
			addbutton.BorderSizePixel = 0
			addbutton.Name = "AddButton"
			addbutton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			addbutton.Position = UDim2.new(0, (argstable["Name"] == "ProfilesList" and 124 or 174), 0, 8)
			addbutton.AutoButtonColor = false
			addbutton.Size = UDim2.new(0, 16, 0, 16)
			addbutton.ImageColor3 = Color3.fromHSV(0.44, 1, 1)
			addbutton.Image = downloadVapeAsset("vape/assets/AddItem.png")
			addbutton.Parent = textboxbkg
			local scrollframebkg = Instance.new("Frame")
			scrollframebkg.ZIndex = 2
			scrollframebkg.Name = "ScrollingFrameBKG"
			scrollframebkg.Size = UDim2.new(0, 220, 0, 3)
			scrollframebkg.BackgroundTransparency = 1
			scrollframebkg.LayoutOrder = amount
			scrollframebkg.Parent = children
			local scrollframe = Instance.new("ScrollingFrame")
			scrollframe.ZIndex = 2
			scrollframe.Size = UDim2.new(0, 200, 0, 3)
			scrollframe.Position = UDim2.new(0, 10, 0, 0)
			scrollframe.BackgroundTransparency = 1
			scrollframe.ScrollBarThickness = 0
			scrollframe.BorderSizePixel = 0
			scrollframe.ScrollBarImageColor3 = Color3.new(0, 0, 0)
			scrollframe.LayoutOrder = amount
			scrollframe.Parent = scrollframebkg
			local uilistlayout3 = Instance.new("UIListLayout")
			uilistlayout3.Padding = UDim.new(0, 3)
			uilistlayout3.Parent = scrollframe
			uilistlayout3:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				scrollframe.CanvasSize = UDim2.new(0, 0, 0, uilistlayout3.AbsoluteContentSize.Y * (1 / GuiLibrary["MainRescale"].Scale))
				scrollframe.Size = UDim2.new(0, 220, 0, math.clamp(uilistlayout3.AbsoluteContentSize.Y * (1 / GuiLibrary["MainRescale"].Scale), 1, 105))
				scrollframebkg.Size = UDim2.new(0, 220, 0, math.clamp(uilistlayout3.AbsoluteContentSize.Y * (1 / GuiLibrary["MainRescale"].Scale), 1, 105))
			end)

			textGuiLibrary["Object"] = frame
			textGuiLibrary["ScrollingObject"] = scrollframebkg
			textGuiLibrary["ObjectList"] = {}
			textGuiLibrary["RefreshValues"] = function(tab)
				textGuiLibrary["ObjectList"] = tab
				for i2,v2 in pairs(scrollframe:GetChildren()) do
					if v2:IsA("TextButton") then v2:Remove() end
				end
				for i,v in pairs(textGuiLibrary["ObjectList"]) do
					local itemframe = Instance.new("TextButton")
					itemframe.Size = UDim2.new(0, 200, 0, 33)
					itemframe.Text = ""
					itemframe.AutoButtonColor = false
					itemframe.BackgroundColor3 = Color3.fromRGB(31, 30, 31)
					itemframe.BorderSizePixel = 0
					itemframe.Parent = scrollframe
					local itemcorner = Instance.new("UICorner")
					itemcorner.CornerRadius = UDim.new(0, 6)
					itemcorner.Parent = itemframe
					local itemtext = Instance.new("TextLabel")
					itemtext.BackgroundTransparency = 1
					itemtext.Size = UDim2.new(0, 193, 0, 33)
					itemtext.Name = "ItemText"
					itemtext.Position = UDim2.new(0, 8, 0, 0)
					itemtext.Font = Enum.Font.SourceSans
					itemtext.TextSize = 17
					itemtext.Text = v
					itemtext.TextXAlignment = Enum.TextXAlignment.Left
					itemtext.TextColor3 = Color3.fromRGB(86, 85, 86)
					itemtext.Parent = itemframe
					local deletebutton = Instance.new("ImageButton")
					deletebutton.Size = UDim2.new(0, 6, 0, 6)
					deletebutton.BackgroundTransparency = 1
					deletebutton.AutoButtonColor = false
					deletebutton.ZIndex = 1
					deletebutton.Image = downloadVapeAsset("vape/assets/AddRemoveIcon1.png")
					deletebutton.Position = UDim2.new(1, -16, 0, 14)
					deletebutton.Parent = itemframe
					deletebutton.MouseButton1Click:Connect(function()
						table.remove(textGuiLibrary["ObjectList"], i)
						textGuiLibrary["RefreshValues"](textGuiLibrary["ObjectList"])
						if argstable["RemoveFunction"] then
							argstable["RemoveFunction"](i, v)
						end
					end)
					if argstable["CustomFunction"] then
						argstable["CustomFunction"](itemframe, v)
					end
				end
			end
			if not argstable["NoSave"] then
				GuiLibrary.ObjectsThatCanBeSaved[argstable["Name"].."TextList"] = {["Type"] = "TextList", ["Api"] = textGuiLibrary}
			end

			local function AddToList() 
                table.insert(textGuiLibrary["ObjectList"], textbox.Text)
                textGuiLibrary["RefreshValues"](textGuiLibrary["ObjectList"])
                if argstable["AddFunction"] then
                    argstable["AddFunction"](textbox.Text) 
                end
                textbox.Text = ""
            end

            addbutton.MouseButton1Click:Connect(AddToList)
            textbox.FocusLost:Connect(function(enter)
                if enter then
                    AddToList()
                    textbox:CaptureFocus()
                end
            end)
			return textGuiLibrary
		end

		windowapi["CreateCircleTextList"] = function(argstable)
			local textGuiLibrary = {}
			local amount = #children:GetChildren()
			local frame = Instance.new("Frame")
			frame.Size = UDim2.new(0, 220, 0, 40)
			frame.BackgroundTransparency = 1
			frame.ClipsDescendants = true
			frame.LayoutOrder = amount
			frame.Name = argstable["Name"]
			frame.Parent = children
			local textboxbkg = Instance.new("ImageLabel")
			textboxbkg.BackgroundTransparency = 1
			textboxbkg.Name = "AddBoxBKG"
			textboxbkg.Size = UDim2.new(0, (argstable["Name"] == "ProfilesList" and 150 or 200), 0, 31)
			textboxbkg.Position = UDim2.new(0, 10, 0, 5)
			textboxbkg.ClipsDescendants = true
			textboxbkg.Image = downloadVapeAsset((argstable["Name"] == "ProfilesList" and "vape/assets/TextBoxBKG2.png" or "vape/assets/TextBoxBKG.png"))
			textboxbkg.Parent = frame
			local textbox = Instance.new("TextBox")
			textbox.Size = UDim2.new(0, 159, 1, 0)
			textbox.Position = UDim2.new(0, 11, 0, 0)
			textbox.TextXAlignment = Enum.TextXAlignment.Left
			textbox.Name = "AddBox"
			textbox.BackgroundTransparency = 1
			textbox.TextColor3 = Color3.new(1, 1, 1)
			textbox.PlaceholderColor3 = Color3.fromRGB(200, 200, 200)
			textbox.Font = Enum.Font.SourceSans
			textbox.Text = ""
			textbox.PlaceholderText = argstable["TempText"]
			textbox.TextSize = 17
			textbox.Parent = textboxbkg
			local addbutton = Instance.new("ImageButton")
			addbutton.BorderSizePixel = 0
			addbutton.Name = "AddButton"
			addbutton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			addbutton.Position = UDim2.new(0, (argstable["Name"] == "ProfilesList" and 124 or 174), 0, 8)
			addbutton.AutoButtonColor = false
			addbutton.Size = UDim2.new(0, 16, 0, 16)
			addbutton.ImageColor3 = argstable["Color"]
			addbutton.Image = downloadVapeAsset("vape/assets/AddItem.png")
			addbutton.Parent = textboxbkg
			local scrollframebkg = Instance.new("Frame")
			scrollframebkg.ZIndex = 2
			scrollframebkg.Name = "ScrollingFrameBKG"
			scrollframebkg.Size = UDim2.new(0, 220, 0, 3)
			scrollframebkg.BackgroundTransparency = 1
			scrollframebkg.LayoutOrder = amount
			scrollframebkg.Parent = children
			local scrollframe = Instance.new("ScrollingFrame")
			scrollframe.ZIndex = 2
			scrollframe.Size = UDim2.new(0, 200, 0, 3)
			scrollframe.Position = UDim2.new(0, 10, 0, 0)
			scrollframe.BackgroundTransparency = 1
			scrollframe.ScrollBarThickness = 0
			scrollframe.ScrollBarImageColor3 = Color3.new(0, 0, 0)
			scrollframe.LayoutOrder = amount
			scrollframe.Parent = scrollframebkg
			local uilistlayout3 = Instance.new("UIListLayout")
			uilistlayout3.Padding = UDim.new(0, 3)
			uilistlayout3.Parent = scrollframe
			uilistlayout3:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				scrollframe.CanvasSize = UDim2.new(0, 0, 0, uilistlayout3.AbsoluteContentSize.Y * (1 / GuiLibrary["MainRescale"].Scale))
				scrollframe.Size = UDim2.new(0, 220, 0, math.clamp(uilistlayout3.AbsoluteContentSize.Y * (1 / GuiLibrary["MainRescale"].Scale), 1, 105))
				scrollframebkg.Size = UDim2.new(0, 220, 0, math.clamp(uilistlayout3.AbsoluteContentSize.Y * (1 / GuiLibrary["MainRescale"].Scale), 1, 105) + 3)
			end)

			textGuiLibrary["Object"] = frame
			textGuiLibrary["ScrollingObject"] = scrollframebkg
			textGuiLibrary["ObjectList"] = {}
			textGuiLibrary["ObjectListEnabled"] = {}
			local hoveredover = {}
			textGuiLibrary["RefreshValues"] = function(tab, tab2)
				textGuiLibrary["ObjectList"] = tab
				if tab2 then
					textGuiLibrary["ObjectListEnabled"] = tab2
				end
				for i2,v2 in pairs(scrollframe:GetChildren()) do
					if v2:IsA("TextButton") then v2:Remove() end
				end
				for i,v in pairs(textGuiLibrary["ObjectList"]) do
					local objenabled = textGuiLibrary["ObjectListEnabled"][i]
					local itemframe = Instance.new("TextButton")
					itemframe.Size = UDim2.new(0, 200, 0, 33)
					itemframe.Text = ""
					itemframe.AutoButtonColor = false
					itemframe.BackgroundColor3 = (hoveredover[i] and Color3.fromRGB(26, 25, 26) or Color3.fromRGB(31, 30, 31))
					itemframe.BorderSizePixel = 0
					itemframe.Parent = scrollframe
					local itemcorner = Instance.new("UICorner")
					itemcorner.CornerRadius = UDim.new(0, 6)
					itemcorner.Parent = itemframe
					local itemtext = Instance.new("TextLabel")
					itemtext.BackgroundTransparency = 1
					itemtext.Size = UDim2.new(0, 157, 0, 33)
					itemtext.Name = "ItemText"
					itemtext.Position = UDim2.new(0, 36, 0, 0)
					itemtext.Font = Enum.Font.SourceSans
					itemtext.TextSize = 17
					itemtext.Text = v
					itemtext.TextXAlignment = Enum.TextXAlignment.Left
					itemtext.TextColor3 = (objenabled and Color3.fromRGB(160, 160, 160) or Color3.fromRGB(90, 90, 90))
					itemtext.Parent = itemframe
					local friendcircle = Instance.new("Frame")
					friendcircle.Size = UDim2.new(0, 10, 0, 10)
					friendcircle.Name = "FriendCircle"
					friendcircle.BackgroundColor3 = (objenabled and argstable["Color"] or Color3.fromRGB(120, 120, 120))
					friendcircle.BorderSizePixel = 0
					friendcircle.Position = UDim2.new(0, 10, 0, 13)
					friendcircle.Parent = itemframe
					local friendcorner = Instance.new("UICorner")
					friendcorner.CornerRadius = UDim.new(0, 8)
					friendcorner.Parent = friendcircle
					local friendcircle2 = friendcircle:Clone()
					friendcircle2.Size = UDim2.new(0, 8, 0, 8)
					friendcircle2.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
					friendcircle2.Position = UDim2.new(0, 1, 0, 1)
					friendcircle2.Visible = not objenabled
					friendcircle2.Parent = friendcircle	
					itemframe:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
						friendcircle2.BackgroundColor3 = itemframe.BackgroundColor3
					end)
					itemframe.MouseEnter:Connect(function()
						itemframe.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
						hoveredover[i] = true
					end)
					itemframe.MouseLeave:Connect(function()
						itemframe.BackgroundColor3 = Color3.fromRGB(31, 30, 31)
						hoveredover[i] = nil
					end)
					itemframe.MouseButton1Click:Connect(function()
						textGuiLibrary["ObjectListEnabled"][i] = not textGuiLibrary["ObjectListEnabled"][i]
						textGuiLibrary["RefreshValues"](textGuiLibrary["ObjectList"])
					end)
					itemframe.MouseButton2Click:Connect(function()
						textGuiLibrary["ObjectListEnabled"][i] = not textGuiLibrary["ObjectListEnabled"][i]
						textGuiLibrary["RefreshValues"](textGuiLibrary["ObjectList"])
					end)
					local deletebutton = Instance.new("ImageButton")
					deletebutton.Size = UDim2.new(0, 6, 0, 6)
					deletebutton.BackgroundTransparency = 1
					deletebutton.AutoButtonColor = false
					deletebutton.ZIndex = 2
					deletebutton.Image = downloadVapeAsset("vape/assets/AddRemoveIcon1.png")
					deletebutton.Position = UDim2.new(1, -16, 0, 14)
					deletebutton.Parent = itemframe
					deletebutton.MouseButton1Click:Connect(function()
						table.remove(textGuiLibrary["ObjectList"], i)
						textGuiLibrary["ObjectListEnabled"][i] = nil
						textGuiLibrary["RefreshValues"](textGuiLibrary["ObjectList"])
						if argstable["RemoveFunction"] then
							argstable["RemoveFunction"](i, v)
						end
					end)
				end
			end

			GuiLibrary.ObjectsThatCanBeSaved[argstable["Name"].."TextCircleList"] = {["Type"] = "TextCircleList", ["Api"] = textGuiLibrary}
			local function AddToList()
                local num = #textGuiLibrary["ObjectList"] + 1
                textGuiLibrary["ObjectList"][num] = textbox.Text
                textGuiLibrary["ObjectListEnabled"][num] = true
                textGuiLibrary["RefreshValues"](textGuiLibrary["ObjectList"])
                if argstable["AddFunction"] then
                    argstable["AddFunction"](textbox.Text) 
                end
                textbox.Text = ""
            end
            addbutton.MouseButton1Click:Connect(AddToList)
            textbox.FocusLost:Connect(function(enter)
                if enter then
                    AddToList()
                    textbox:CaptureFocus()
                end
            end)
			return textGuiLibrary
		end


		return windowapi
	end

	GuiLibrary["CreateLegitModule"] = function(legittable)
		local legitapi = {}
		local customlegit = Instance.new("Frame")
		customlegit.Size = UDim2.new(0, 40, 0, 40)
		customlegit.BackgroundTransparency = 1
		customlegit.BackgroundColor3 = Color3.new(0, 1, 0)
		customlegit.BorderSizePixel = 0
		customlegit.Visible = false
		customlegit.Parent = legitgui
		local legitframe = Instance.new("TextButton")
		legitframe.AutoButtonColor = false
		legitframe.Text = ""
		legitframe.BackgroundColor3 = Color3.fromRGB(31, 30, 31)
		legitframe.Size = UDim2.new(0, 163, 0, 114)
		legitframe.Parent = LegitModulesList
		local legitframecorner = Instance.new("UICorner")
		legitframecorner.CornerRadius = UDim.new(0, 5)
		legitframecorner.Parent = legitframe
		local legitframetext = Instance.new("TextLabel")
		legitframetext.Font = Enum.Font.Gotham
		legitframetext.TextSize = 15
		legitframetext.BackgroundTransparency = 1
		legitframetext.TextXAlignment = Enum.TextXAlignment.Left
		legitframetext.TextYAlignment = Enum.TextYAlignment.Top
		legitframetext.TextColor3 = Color3.fromRGB(160, 160, 160)
		legitframetext.Size = UDim2.new(1, -16, 0, 22)
		legitframetext.Position = UDim2.new(0, 16, 0, 83)
		legitframetext.Text = legittable.Name
		legitframetext.Parent = legitframe
		local toggleframe1 = Instance.new("Frame")
		toggleframe1.Size = UDim2.new(0, 22, 0, 12)
		toggleframe1.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		toggleframe1.BorderSizePixel = 0
		toggleframe1.Name = "ToggleFrame1"
		toggleframe1.Position = UDim2.new(1, -57, 0, 14)
		toggleframe1.Parent = legitframe
		local toggleframe2 = Instance.new("Frame")
		toggleframe2.Size = UDim2.new(0, 8, 0, 8)
		toggleframe2.Active = false
		toggleframe2.Position = UDim2.new(0, 2, 0, 2)
		toggleframe2.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
		toggleframe2.BorderSizePixel = 0
		toggleframe2.Parent = toggleframe1
		local uicorner = Instance.new("UICorner")
		uicorner.CornerRadius = UDim.new(0, 16)
		uicorner.Parent = toggleframe1
		local uicorner2 = Instance.new("UICorner")
		uicorner2.CornerRadius = UDim.new(0, 16)
		uicorner2.Parent = toggleframe2
		dragGUI(customlegit, true)
		legitapi.Enabled = false

		legitapi.ToggleButton = function(first)
			legitapi.Enabled = not legitapi.Enabled
			customlegit.Visible = legitapi.Enabled
			if legitapi.Enabled then
				legitframe.BackgroundColor3 = Color3.fromRGB(40, 39, 40)
				legitframetext.TextColor3 = Color3.fromRGB(228, 228, 228)
				if not first then
					tweenService:Create(toggleframe1, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromHSV(GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Hue"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Sat"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Value"])}):Play()
				else
					toggleframe1.BackgroundColor3 = Color3.fromHSV(GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Hue"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Sat"], GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"]["Api"]["Value"])
				end
				toggleframe2:TweenPosition(UDim2.new(0, 12, 0, 2), Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.1, true)
			else
				legitframe.BackgroundColor3 = Color3.fromRGB(31, 30, 31)
				legitframetext.TextColor3 = Color3.fromRGB(160, 160, 160)
				if not first then
					tweenService:Create(toggleframe1, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
				else
					toggleframe1.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
				end
				toggleframe2:TweenPosition(UDim2.new(0, 2, 0, 2), Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.1, true)
			end
			legittable.Function(legitapi.Enabled)
		end
		legitframe.MouseButton1Click:Connect(function() legitapi["ToggleButton"](not legitapi["Enabled"], false) end)
		
		legitapi["GetCustomChildren"] = function()
			return customlegit
		end

		GuiLibrary.ObjectsThatCanBeSaved[legittable.Name.."LegitModule"] = {Api = legitapi, Type = "LegitModule", Object = customlegit, Toggle = toggleframe1}
		return legitapi	
	end

	local function bettertween(obj, newpos, dir, style, tim, override)
		task.spawn(function()
			local frame = Instance.new("Frame")
			frame.Visible = false
			frame.Position = obj.Position
			frame.Parent = GuiLibrary["MainGui"]
			frame:GetPropertyChangedSignal("Position"):Connect(function()
				obj.Position = UDim2.new(obj.Position.X.Scale, obj.Position.X.Offset, frame.Position.Y.Scale, frame.Position.Y.Offset)
			end)
			pcall(function()
				frame:TweenPosition(newpos, dir, style, tim, override)
			end)
			frame.Parent = nil
			task.wait(tim)
			frame:Remove()
		end)
	end

	local function bettertween2(obj, newpos, dir, style, tim, override)
		task.spawn(function()
			local frame = Instance.new("Frame")
			frame.Visible = false
			frame.Position = obj.Position
			frame.Parent = GuiLibrary["MainGui"]
			frame:GetPropertyChangedSignal("Position"):Connect(function()
				obj.Position = UDim2.new(frame.Position.X.Scale, frame.Position.X.Offset, obj.Position.Y.Scale, obj.Position.Y.Offset)
			end)
			pcall(function()
				frame:TweenPosition(newpos, dir, style, tim, override)
			end)
			frame.Parent = nil
			task.wait(tim)
			frame:Remove()
		end)
	end

	notificationwindow.ChildRemoved:Connect(function()
		for i,v in pairs(notificationwindow:GetChildren()) do
			bettertween(v, UDim2.new(1, v.Position.X.Offset, 1, -(150 + 80 * (i - 1))), Enum.EasingDirection.In, Enum.EasingStyle.Sine, 0.15, true)
		end
	end)

	local function removeTags(str)
        str = str:gsub("<br%s*/>", "\n")
        return (str:gsub("<[^<>]->", ""))
    end

	GuiLibrary["CreateNotification"] = function(top, bottom, duration, customicon)
		local size = math.max( textService:GetTextSize(removeTags(bottom), 13, Enum.Font.Gotham, Vector2.new(99999, 99999)).X + 60, 266)
		local offset = #notificationwindow:GetChildren()
		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(0, size, 0, 75)
		frame.Position = UDim2.new(1, 0, 1, -(150 + 80 * offset))
		frame.BackgroundTransparency = 1
		frame.BackgroundColor3 = Color3.new(0, 0,0)
		frame.BorderSizePixel = 0
		frame.Parent = notificationwindow
		frame.Visible = GuiLibrary["Notifications"]
		frame.ClipsDescendants = false
		local image = Instance.new("ImageLabel")
		image.SliceCenter = Rect.new(67, 59, 323, 120)
		image.Position = UDim2.new(0, -61, 0, -50)
		image.BackgroundTransparency = 1
		image.Name = "Frame"
		image.ScaleType = Enum.ScaleType.Slice
		image.Image = downloadVapeAsset("vape/assets/NotificationBackground.png")
		image.Size = UDim2.new(1, 61, 0, 159)
		image.Parent = frame
		local uicorner = Instance.new("UICorner")
		uicorner.CornerRadius = UDim.new(0, 6)
		uicorner.Parent = frame
		local frame2 = Instance.new("ImageLabel")
		frame2.BackgroundColor3 = Color3.new(1, 1, 1)
		frame2.Name = "Frame"
		frame2:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
			frame2.ImageColor3 = frame2.BackgroundColor3
		end)
		frame2.BackgroundTransparency = 1
		frame2.SliceCenter = Rect.new(2, 0, 224, 2)
		frame2.Size = UDim2.new(1, -61, 0, 2)
		frame2.ScaleType = Enum.ScaleType.Slice
		frame2.Position = UDim2.new(0, 63, 1, -36)
		frame2.ZIndex = 2
		frame2.Image = downloadVapeAsset("vape/assets/NotificationBar.png")
		frame2.BorderSizePixel = 0
		frame2.Parent = image
		local icon = Instance.new("ImageLabel")
		icon.Name = "IconLabel"
		icon.Image = downloadVapeAsset(customicon and "vape/"..customicon or "vape/assets/InfoNotification.png")
		icon.BackgroundTransparency = 1
		icon.Position = UDim2.new(0, -6, 0, -6)
		icon.Size = UDim2.new(0, 60, 0, 60)
		icon.Parent = frame
		local icon2 = icon:Clone()
		icon2.ImageColor3 = Color3.new(0, 0, 0)
		icon2.ZIndex = -1
		icon2.Position = UDim2.new(0, 1, 0, 1)
		icon2.ImageTransparency = 0.5
		icon2.Parent = icon
		local textlabel1 = Instance.new("TextLabel")
		textlabel1.Font = Enum.Font.Arial
		textlabel1.TextSize = 14
		textlabel1.RichText = true
		textlabel1.TextTransparency = 0.1
		textlabel1.TextColor3 = Color3.new(1, 1, 1)
		textlabel1.BackgroundTransparency = 1
		textlabel1.Position = UDim2.new(0, 46, 0, 17)
		textlabel1.TextXAlignment = Enum.TextXAlignment.Left
		textlabel1.TextYAlignment = Enum.TextYAlignment.Top
		textlabel1.Text = (translations[top] ~= nil and translations[top] or top)
		textlabel1.Parent = frame
		local textlabel2 = textlabel1:Clone()
		textlabel2.Position = UDim2.new(0, 46, 0, 44)
		textlabel2.Font = Enum.Font.Arial
		textlabel2.TextTransparency = 0
		textlabel2.TextColor3 = Color3.fromRGB(170, 170, 170)
		textlabel2.RichText = true
		textlabel2.Text = bottom
		textlabel2.Parent = frame
		task.spawn(function()
			pcall(function()
				bettertween2(frame, UDim2.new(1, -(size - 4), 1, -(150 + 80 * offset)), Enum.EasingDirection.In, Enum.EasingStyle.Sine, 0.15, true)
				task.wait(0.15)
				frame2:TweenSize(UDim2.new(0, 0, 0, 2), Enum.EasingDirection.In, Enum.EasingStyle.Linear, duration, true)
				task.wait(duration)
				bettertween2(frame, UDim2.new(1, 0, 1, frame.Position.Y.Offset), Enum.EasingDirection.In, Enum.EasingStyle.Sine, 0.15, true)
				task.wait(0.15)
				frame:Remove()
			end)
		end)
		return frame
	end

	GuiLibrary["LoadedAnimation"] = function(enabled)
		if enabled then
			--no cache but its ran 1 time so idc
			local bad = not (inputService:GetPlatform() == Enum.Platform.Windows or inputService:GetPlatform() == Enum.Platform.OSX)
			GuiLibrary.CreateNotification("Finished Loading", bad and GuiLibrary["GUIKeybind"] == "RightShift" and "Press the button in the top right to open GUI" or "Press "..string.upper(GuiLibrary["GUIKeybind"]).." to open GUI", 5)
		end
	end

	local holdingalt = false
	local uninjected = false

	if inputService.TouchEnabled or inputService:GetPlatform() == Enum.Platform.UWP then 
		local button = Instance.new("TextButton")
		button.Position = UDim2.new(1, -30, 0, 0)
		button.Text = "Vape"
		button.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
		button.TextColor3 = Color3.new(1, 1, 1)
		button.Size = UDim2.new(0, 30, 0, 20)
		button.BorderSizePixel = 0
		button.BackgroundTransparency = 0.5
		button.Parent = GuiLibrary.MainGui
		button.MouseButton1Click:Connect(function()
			clickgui.Visible = not clickgui.Visible
			legitgui.Visible = not clickgui.Visible
			inputService.OverrideMouseIconBehavior = (clickgui.Visible and Enum.OverrideMouseIconBehavior.ForceShow or game:GetService("VRService").VREnabled and Enum.OverrideMouseIconBehavior.ForceHide or Enum.OverrideMouseIconBehavior.None)
			game:GetService("RunService"):SetRobloxGuiFocused(clickgui.Visible and GuiLibrary["MainBlur"].Size ~= 0 or guiService:GetErrorType() ~= Enum.ConnectionError.OK)	
			for _, mobileButton in pairs(GuiLibrary.MobileButtons) do mobileButton.Visible = not clickgui.Visible end	
			if OnlineProfilesBigFrame.Visible then
				OnlineProfilesBigFrame.Visible = false
			end
			if LegitModulesBigFrame.Visible then
				LegitModulesBigFrame.Visible = false
				legitgui.Visible = not clickgui.Visible
				for i, v in pairs(legitgui:GetChildren()) do 
					if v:IsA("Frame") then v.BackgroundTransparency = legitgui.Visible and 0.8 or 1 end
				end
			end
		end)
		shared.VapeButton = button
	end

	GuiLibrary["KeyInputHandler"] = inputService.InputBegan:Connect(function(input1)
		if inputService:GetFocusedTextBox() == nil then
			if input1.KeyCode == Enum.KeyCode[GuiLibrary["GUIKeybind"]] and GuiLibrary["KeybindCaptured"] == false then
				clickgui.Visible = not clickgui.Visible
				legitgui.Visible = not clickgui.Visible
				inputService.OverrideMouseIconBehavior = (clickgui.Visible and Enum.OverrideMouseIconBehavior.ForceShow or game:GetService("VRService").VREnabled and Enum.OverrideMouseIconBehavior.ForceHide or Enum.OverrideMouseIconBehavior.None)
				game:GetService("RunService"):SetRobloxGuiFocused(clickgui.Visible and GuiLibrary["MainBlur"].Size ~= 0 or guiService:GetErrorType() ~= Enum.ConnectionError.OK)	
				for _, mobileButton in pairs(GuiLibrary.MobileButtons) do mobileButton.Visible = not clickgui.Visible end	
				if OnlineProfilesBigFrame.Visible then
					OnlineProfilesBigFrame.Visible = false
				end
				if LegitModulesBigFrame.Visible then
					LegitModulesBigFrame.Visible = false
					legitgui.Visible = not clickgui.Visible
					for i, v in pairs(legitgui:GetChildren()) do 
						if v:IsA("Frame") then v.BackgroundTransparency = legitgui.Visible and 0.8 or 1 end
					end
				end
			end
			if input1.KeyCode == Enum.KeyCode.RightAlt then 
				holdingalt = true
			end
			if input1.KeyCode == Enum.KeyCode.Home and holdingalt and (not uninjected) then 
				GuiLibrary["SelfDestruct"]()
				uninjected = true
			end
			if GuiLibrary["KeybindCaptured"] and input1.KeyCode ~= Enum.KeyCode.LeftShift then
				local hah = string.gsub(tostring(input1.KeyCode), "Enum.KeyCode.", "")
				GuiLibrary["PressedKeybindKey"] = (hah ~= "Unknown" and hah or "")
			end
			for modules,aGuiLibrary in pairs(GuiLibrary.ObjectsThatCanBeSaved) do
				if (aGuiLibrary["Type"] == "OptionsButton" or aGuiLibrary["Type"] == "Button") and (aGuiLibrary["Api"]["Keybind"] ~= nil and aGuiLibrary["Api"]["Keybind"] ~= "") and GuiLibrary["KeybindCaptured"] == false then
					if input1.KeyCode == Enum.KeyCode[aGuiLibrary["Api"]["Keybind"]] and aGuiLibrary["Api"]["Keybind"] ~= GuiLibrary["GUIKeybind"] then
						aGuiLibrary["Api"]["ToggleButton"](false)
						if GuiLibrary["ToggleNotifications"] then
							GuiLibrary["CreateNotification"]("Module Toggled", aGuiLibrary["Api"]["Name"]..' <font color="#FFFFFF">has been</font> <font color="'..(aGuiLibrary["Api"]["Enabled"] and '#32CD32' or '#FF6464')..'">'..(aGuiLibrary["Api"]["Enabled"] and "Enabled" or "Disabled")..'</font><font color="#FFFFFF">!</font>', 1)
						end
					end
				end
			end
			for profilenametext, profiletab in pairs(GuiLibrary.Profiles) do
				if (profiletab["Keybind"] ~= nil and profiletab["Keybind"] ~= "") and GuiLibrary["KeybindCaptured"] == false and profilenametext ~= GuiLibrary.CurrentProfile then
					if input1.KeyCode == Enum.KeyCode[profiletab["Keybind"]] then
						GuiLibrary["SwitchProfile"](profilenametext)
					end
				end
			end
		end
	end)

	GuiLibrary["KeyInputHandler2"] = inputService.InputEnded:Connect(function(input1)
		if input1.KeyCode == Enum.KeyCode.RightAlt then
			holdingalt = false
		end
	end)

	searchbar:GetPropertyChangedSignal("Text"):Connect(function()
		searchbarchildren:ClearAllChildren()
		if searchbar.Text == "" then
			searchbarmain.Size = UDim2.new(0, 220, 0, 37)
		else
			local optionbuttons = {}
			for i,v in pairs(GuiLibrary.ObjectsThatCanBeSaved) do
				if i:find("OptionsButton") and i:sub(1, searchbar.Text:len()):lower() == searchbar.Text:lower() then
					local button = Instance.new("TextButton")
					button.Name = v.Object.Name
					button.AutoButtonColor = false
					button.Active = true
					button.Size = UDim2.new(1, 0, 0, 40)
					button.BorderSizePixel = 0
					button.Position = UDim2.new(0, 0, 0, 40 * #optionbuttons)
					button.ZIndex = 10
					button.BackgroundColor3 = v.Object.BackgroundColor3
					button.Text = ""
					button.LayoutOrder = amount
					button.Parent = searchbarchildren
					v.Object:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
						button.BackgroundColor3 = v.Object.BackgroundColor3
					end)
					local buttonactiveborder = Instance.new("Frame")
					buttonactiveborder.BackgroundTransparency = 0.75
					buttonactiveborder.BackgroundColor3 = Color3.new(0, 0, 0)
					buttonactiveborder.BorderSizePixel = 0
					buttonactiveborder.Size = UDim2.new(1, 0, 0, 1)
					buttonactiveborder.Position = UDim2.new(0, 0, 1, -1)
					buttonactiveborder.ZIndex = 10
					buttonactiveborder.Visible = false
					buttonactiveborder.Parent = button
					local button2 = Instance.new("ImageButton")
					button2.BackgroundTransparency = 1
					button2.Size = UDim2.new(0, 10, 0, 20)
					button2.Position = UDim2.new(1, -24, 0, 10)
					button2.Name = "OptionsButton"
					button2.ZIndex = 10
					button2.Image = v.Object.OptionsButton.Image
					button2.Parent = button
					v.Object.OptionsButton:GetPropertyChangedSignal("Image"):Connect(function()
						button2.Image = v.Object.OptionsButton.Image
					end)
					local buttontext = Instance.new("TextLabel")
					buttontext.BackgroundTransparency = 1
					buttontext.Name = "ButtonText"
					buttontext.Text = (translations[v.Object.Name:gsub("Button", "")] ~= nil and translations[v.Object.Name:gsub("Button", "")] or v.Object.Name:gsub("Button", ""))
					buttontext.Size = UDim2.new(0, 118, 0, 39)
					buttontext.Active = false
					buttontext.ZIndex = 10
					buttontext.TextColor3 = v.Object.ButtonText.TextColor3
					v.Object.ButtonText:GetPropertyChangedSignal("TextColor3"):Connect(function()
						buttontext.TextColor3 = v.Object.ButtonText.TextColor3
					end)
					buttontext.TextSize = 17
					buttontext.Font = Enum.Font.SourceSans
					buttontext.TextXAlignment = Enum.TextXAlignment.Left
					buttontext.Position = UDim2.new(0, 12, 0, 0)
					buttontext.Parent = button
					button.MouseButton1Click:Connect(function()
						v["Api"]["ToggleButton"](false)
					end)
					table.insert(optionbuttons, v)
				end
			end
			searchbarmain.Size = UDim2.new(0, 220, 0, 39 + (40 * #optionbuttons))
		end
	end)
	GuiLibrary["MainRescale"]:GetPropertyChangedSignal("Scale"):Connect(function()
		searchbarmain.Position = UDim2.new(0.5 / GuiLibrary["MainRescale"].Scale, -110, 0, -23)
	end)

	searchbaricon2.MouseButton1Click:Connect(function()
		LegitModulesBigFrame.Visible = true
		clickgui.Visible = false
		legitgui.Visible = not clickgui.Visible
		for i, v in pairs(legitgui:GetChildren()) do 
			if v:IsA("Frame") then v.BackgroundTransparency = legitgui.Visible and 0.8 or 1 end
		end
	end)

	return GuiLibrary
end
