repeat wait() until game:IsLoaded() == true

local function GetURL(scripturl)
	if shared.VapeDeveloper then
		return readfile("vape/"..scripturl)
	else
		return game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/"..scripturl, true)
	end
end
local getasset = getsynasset or getcustomasset
if getasset == nil and getgenv().getcustomasset == nil then
	getgenv().getcustomasset = function(location) return "rbxasset://"..location end
	getasset = getgenv().getcustomasset
end
local queueteleport = syn and syn.queue_on_teleport or queue_on_teleport or fluxus and fluxus.queue_on_teleport
local requestfunc = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or getgenv().request or request

local function checkassetversion()
	local req = requestfunc({
		Url = "https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/assetsversion.dat",
		Method = "GET"
	})
	if req.StatusCode == 200 then
		return req.Body
	else
		return nil
	end
end

if not (getasset and requestfunc and queueteleport) then
	print("Vape not supported with your exploit.")
	return
end

if shared.VapeExecuted then
	error("Vape Already Injected")
	return
else
	shared.VapeExecuted = true
end

if isfolder("vape") == false then
	makefolder("vape")
end
if isfile("vape/assetsversion.dat") == false then
	writefile("vape/assetsversion.dat", "1")
end
if isfolder("vape/CustomModules") == false then
	makefolder("vape/CustomModules")
end
if isfolder("vape/Profiles") == false then
	makefolder("vape/Profiles")
end
local assetver = checkassetversion()
if assetver and assetver > readfile("vape/assetsversion.dat") then
	if shared.VapeDeveloper == nil then
		if isfolder("vape/assets") then
			if delfolder then
				delfolder("vape/assets")
			end
		end
		writefile("vape/assetsversion.dat", assetver)
	end
end
if isfolder("vape/assets") == false then
	makefolder("vape/assets")
end

local GuiLibrary = loadstring(GetURL("NewGuiLibrary.lua"))()

local checkpublicreponum = 0
local checkpublicrepo
checkpublicrepo = function(id)
	local suc, req = pcall(function() return requestfunc({
		Url = "https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/CustomModules/"..id..".vape",
		Method = "GET"
	}) end)
	if not suc then
		checkpublicreponum = checkpublicreponum + 1
		spawn(function()
			local textlabel = Instance.new("TextLabel")
			textlabel.Size = UDim2.new(1, 0, 0, 36)
			textlabel.Text = "Loading CustomModule Failed!, Attempts : "..checkpublicreponum
			textlabel.BackgroundTransparency = 1
			textlabel.TextStrokeTransparency = 0
			textlabel.TextSize = 30
			textlabel.Font = Enum.Font.SourceSans
			textlabel.TextColor3 = Color3.new(1, 1, 1)
			textlabel.Position = UDim2.new(0, 0, 0, -36)
			textlabel.Parent = GuiLibrary["MainGui"]
			wait(2)
			textlabel:Remove()
		end)
		wait(2)
		return checkpublicrepo(id)
	end
	if req.StatusCode == 200 then
		return req.Body
	end
	return nil
end

local function getcustomassetfunc(path)
	if not isfile(path) then
		spawn(function()
			local textlabel = Instance.new("TextLabel")
			textlabel.Size = UDim2.new(1, 0, 0, 36)
			textlabel.Text = "Downloading "..path
			textlabel.BackgroundTransparency = 1
			textlabel.TextStrokeTransparency = 0
			textlabel.TextSize = 30
			textlabel.Font = Enum.Font.SourceSans
			textlabel.TextColor3 = Color3.new(1, 1, 1)
			textlabel.Position = UDim2.new(0, 0, 0, -36)
			textlabel.Parent = GuiLibrary["MainGui"]
			repeat wait() until isfile(path)
			textlabel:Remove()
		end)
		local req = requestfunc({
			Url = "https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/"..path:gsub("vape/assets", "assets"),
			Method = "GET"
		})
		writefile(path, req.Body)
	end
	return getasset(path) 
end

shared.GuiLibrary = GuiLibrary
local workspace = game:GetService("Workspace")
local cam = workspace.CurrentCamera
local selfdestruct = false
local GUI = GuiLibrary.CreateMainWindow()
local Combat = GuiLibrary.CreateWindow({
	["Name"] = "Combat", 
	["Icon"] = "vape/assets/CombatIcon.png", 
	["IconSize"] = 15
})
local Blatant = GuiLibrary.CreateWindow({
	["Name"] = "Blatant", 
	["Icon"] = "vape/assets/BlatantIcon.png", 
	["IconSize"] = 16
})
local Render = GuiLibrary.CreateWindow({
	["Name"] = "Render", 
	["Icon"] = "vape/assets/RenderIcon.png", 
	["IconSize"] = 17
})
local Utility = GuiLibrary.CreateWindow({
	["Name"] = "Utility", 
	["Icon"] = "vape/assets/UtilityIcon.png", 
	["IconSize"] = 17
})
local World = GuiLibrary.CreateWindow({
	["Name"] = "World", 
	["Icon"] = "vape/assets/WorldIcon.png", 
	["IconSize"] = 16
})
local Friends = GuiLibrary.CreateWindow2({
	["Name"] = "Friends", 
	["Icon"] = "vape/assets/FriendsIcon.png", 
	["IconSize"] = 17
})
local Profiles = GuiLibrary.CreateWindow2({
	["Name"] = "Profiles", 
	["Icon"] = "vape/assets/ProfilesIcon.png", 
	["IconSize"] = 19
})
GUI.CreateDivider()
GUI.CreateButton({
	["Name"] = "Combat", 
	["Function"] = function(callback) Combat.SetVisible(callback) end, 
	["Icon"] = "vape/assets/CombatIcon.png", 
	["IconSize"] = 15
})
GUI.CreateButton({
	["Name"] = "Blatant", 
	["Function"] = function(callback) Blatant.SetVisible(callback) end, 
	["Icon"] = "vape/assets/BlatantIcon.png", 
	["IconSize"] = 16
})
GUI.CreateButton({
	["Name"] = "Render", 
	["Function"] = function(callback) Render.SetVisible(callback) end, 
	["Icon"] = "vape/assets/RenderIcon.png", 
	["IconSize"] = 17
})
GUI.CreateButton({
	["Name"] = "Utility", 
	["Function"] = function(callback) Utility.SetVisible(callback) end, 
	["Icon"] = "vape/assets/UtilityIcon.png", 
	["IconSize"] = 17
})
GUI.CreateButton({
	["Name"] = "World", 
	["Function"] = function(callback) World.SetVisible(callback) end, 
	["Icon"] = "vape/assets/WorldIcon.png", 
	["IconSize"] = 16
})
GUI.CreateDivider("MISC")
GUI.CreateButton({
	["Name"] = "Friends", 
	["Function"] = function(callback) Friends.SetVisible(callback) end, 
})
GUI.CreateButton({
	["Name"] = "Profiles", 
	["Function"] = function(callback) Profiles.SetVisible(callback) end, 
})
local FriendsTextList = {["RefreshValues"] = function() end}
local FriendsColor = {["Value"] = 0.44}
FriendsTextList = Friends.CreateCircleTextList({
	["Name"] = "FriendsList", 
	["TempText"] = "Username / Alias", 
	["Color"] = Color3.fromRGB(5, 133, 104),	
	["CustomFunction"] = function(obj)
		obj.ItemText.TextColor3 = Color3.new(1, 1, 1)
		local friendcircle = Instance.new("Frame")
		friendcircle.Size = UDim2.new(0, 10, 0, 10)
		friendcircle.Name = "FriendCircle"
		friendcircle.BackgroundColor3 = Color3.fromHSV(FriendsColor["Value"], 0.7, 0.9)
		friendcircle.BorderSizePixel = 0
		friendcircle.Position = UDim2.new(0, 10, 0, 13)
		friendcircle.Parent = obj
		local friendcorner = Instance.new("UICorner")
		friendcorner.CornerRadius = UDim.new(0, 8)
		friendcorner.Parent = friendcircle
		obj.ItemText.Position = UDim2.new(0, 36, 0, 0)
		obj.ItemText.Size = UDim2.new(0, 157, 0, 33)
	end
})
Friends.CreateToggle({
	["Name"] = "Use Friends",
	["Function"] = function(callback) end,
	["Default"] = true
})
Friends.CreateToggle({
	["Name"] = "Use Alias",
	["Function"] = function(callback) end,
	["Default"] = true,
})
Friends.CreateToggle({
	["Name"] = "Spoof alias",
	["Function"] = function(callback) end,
})
Friends.CreateToggle({
	["Name"] = "Recolor visuals",
	["Function"] = function(callback) end,
	["Default"] = true
})
FriendsColor = Friends.CreateColorSlider({
	["Name"] = "Friends Color", 
	["Function"] = function(val) 

	end
})
local ProfilesTextList = {["RefreshValues"] = function() end}
local profilesloaded = false
ProfilesTextList = Profiles.CreateTextList({
	["Name"] = "ProfilesList",
	["TempText"] = "Type name", 
	["AddFunction"] = function(user)
		GuiLibrary["Profiles"][user] = {["Keybind"] = "", ["Selected"] = false}
	end, 
	["RemoveFunction"] = function(num) 
		if #ProfilesTextList["ObjectList"] == 0 then
			table.insert(ProfilesTextList["ObjectList"], "default")
			ProfilesTextList["RefreshValues"](ProfilesTextList["ObjectList"])
		end
	end, 
	["CustomFunction"] = function(obj, profilename) 
		if GuiLibrary["Profiles"][profilename] == nil then
			GuiLibrary["Profiles"][profilename] = {["Keybind"] = ""}
		end
		obj.MouseButton1Click:connect(function()
			GuiLibrary["SwitchProfile"](profilename)
		end)
		local newsize = UDim2.new(0, 20, 0, 21)
		local bindbkg = Instance.new("TextButton")
		bindbkg.Text = ""
		bindbkg.AutoButtonColor = false
		bindbkg.Size = UDim2.new(0, 20, 0, 21)
		bindbkg.Position = UDim2.new(1, -50, 0, 6)
		bindbkg.BorderSizePixel = 0
		bindbkg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		bindbkg.BackgroundTransparency = 0.95
		bindbkg.Visible = GuiLibrary["Profiles"][profilename]["Keybind"] ~= ""
		bindbkg.Parent = obj
		local bindimg = Instance.new("ImageLabel")
		bindimg.Image = getcustomassetfunc("vape/assets/KeybindIcon.png")
		bindimg.BackgroundTransparency = 1
		bindimg.Size = UDim2.new(0, 12, 0, 12)
		bindimg.Position = UDim2.new(0, 4, 0, 5)
		bindimg.ImageTransparency = 0.2
		bindimg.Active = false
		bindimg.Visible = (GuiLibrary["Profiles"][profilename]["Keybind"] == "")
		bindimg.Parent = bindbkg
		local bindtext = Instance.new("TextLabel")
		bindtext.Active = false
		bindtext.BackgroundTransparency = 1
		bindtext.TextSize = 16
		bindtext.Parent = bindbkg
		bindtext.Font = Enum.Font.SourceSans
		bindtext.Size = UDim2.new(1, 0, 1, 0)
		bindtext.TextColor3 = Color3.fromRGB(85, 85, 85)
		bindtext.Visible = (GuiLibrary["Profiles"][profilename]["Keybind"] ~= "")
		local bindtext2 = Instance.new("TextLabel")
		bindtext2.Text = "PRESS A KEY TO BIND"
		bindtext2.Size = UDim2.new(0, 150, 0, 33)
		bindtext2.Font = Enum.Font.SourceSans
		bindtext2.TextSize = 17
		bindtext2.TextColor3 = Color3.fromRGB(201, 201, 201)
		bindtext2.BackgroundColor3 = Color3.fromRGB(37, 37, 37)
		bindtext2.BorderSizePixel = 0
		bindtext2.Visible = false
		bindtext2.Parent = obj
		local bindround = Instance.new("UICorner")
		bindround.CornerRadius = UDim.new(0, 4)
		bindround.Parent = bindbkg
		bindbkg.MouseButton1Click:connect(function()
			if GuiLibrary["KeybindCaptured"] == false then
				GuiLibrary["KeybindCaptured"] = true
				spawn(function()
					bindtext2.Visible = true
					repeat wait() until GuiLibrary["PressedKeybindKey"] ~= ""
					local key = (GuiLibrary["PressedKeybindKey"] == GuiLibrary["Profiles"][profilename]["Keybind"] and "" or GuiLibrary["PressedKeybindKey"])
					if key == "" then
						GuiLibrary["Profiles"][profilename]["Keybind"] = key
						newsize = UDim2.new(0, 20, 0, 21)
						bindbkg.Size = newsize
						bindbkg.Visible = true
						bindbkg.Position = UDim2.new(1, -(30 + newsize.X.Offset), 0, 6)
						bindimg.Visible = true
						bindtext.Visible = false
						bindtext.Text = key
					else
						local textsize = game:GetService("TextService"):GetTextSize(key, 16, bindtext.Font, Vector2.new(99999, 99999))
						newsize = UDim2.new(0, 13 + textsize.X, 0, 21)
						GuiLibrary["Profiles"][profilename]["Keybind"] = key
						bindbkg.Visible = true
						bindbkg.Size = newsize
						bindbkg.Position = UDim2.new(1, -(30 + newsize.X.Offset), 0, 6)
						bindimg.Visible = false
						bindtext.Visible = true
						bindtext.Text = key
					end
					GuiLibrary["PressedKeybindKey"] = ""
					GuiLibrary["KeybindCaptured"] = false
					bindtext2.Visible = false
				end)
			end
		end)
		bindbkg.MouseEnter:connect(function() 
			bindimg.Image = getcustomassetfunc("vape/assets/PencilIcon.png") 
			bindimg.Visible = true
			bindtext.Visible = false
			bindbkg.Size = UDim2.new(0, 20, 0, 21)
			bindbkg.Position = UDim2.new(1, -50, 0, 6)
		end)
		bindbkg.MouseLeave:connect(function() 
			bindimg.Image = getcustomassetfunc("vape/assets/KeybindIcon.png")
			if GuiLibrary["Profiles"][profilename]["Keybind"] ~= "" then
				bindimg.Visible = false
				bindtext.Visible = true
				bindbkg.Size = newsize
				bindbkg.Position = UDim2.new(1, -(30 + newsize.X.Offset), 0, 6)
			end
		end)
		obj.MouseEnter:connect(function()
			bindbkg.Visible = true
		end)
		obj.MouseLeave:connect(function()
			bindbkg.Visible = GuiLibrary["Profiles"][profilename]["Keybind"] ~= ""
		end)
		if GuiLibrary["Profiles"][profilename]["Keybind"] ~= "" then

			bindtext.Text = GuiLibrary["Profiles"][profilename]["Keybind"]
			local textsize = game:GetService("TextService"):GetTextSize(GuiLibrary["Profiles"][profilename]["Keybind"], 16, bindtext.Font, Vector2.new(99999, 99999))
			newsize = UDim2.new(0, 13 + textsize.X, 0, 21)
			bindbkg.Size = newsize
			bindbkg.Position = UDim2.new(1, -(30 + newsize.X.Offset), 0, 6)
		end
		if profilename == GuiLibrary["CurrentProfile"] then
			obj.BackgroundColor3 = Color3.fromHSV(GuiLibrary["Settings"]["GUIObject"]["Color"], 0.7, 0.9)
			obj.ImageButton.BackgroundColor3 = Color3.fromHSV(GuiLibrary["Settings"]["GUIObject"]["Color"], 0.7, 0.9)
			obj.ItemText.TextColor3 = Color3.new(1, 1, 1)
			obj.ItemText.TextStrokeTransparency = 0.75
			bindbkg.BackgroundTransparency = 0.9
			bindtext.TextColor3 = Color3.fromRGB(214, 214, 214)
		end
	end
})
local OnlineProfilesButton = Instance.new("TextButton")
OnlineProfilesButton.Name = "OnlineProfilesButton"
OnlineProfilesButton.LayoutOrder = 1
OnlineProfilesButton.AutoButtonColor = false
OnlineProfilesButton.Size = UDim2.new(0, 45, 0, 29)
OnlineProfilesButton.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
OnlineProfilesButton.Active = false
OnlineProfilesButton.Text = ""
OnlineProfilesButton.ZIndex = 4
OnlineProfilesButton.Font = Enum.Font.SourceSans
OnlineProfilesButton.TextXAlignment = Enum.TextXAlignment.Left
OnlineProfilesButton.Position = UDim2.new(0, 166, 0, 6)
OnlineProfilesButton.Parent = ProfilesTextList["Object"]
local OnlineProfilesButtonBKG = Instance.new("Frame")
OnlineProfilesButtonBKG.BackgroundColor3 = Color3.fromRGB(38, 37, 38)
OnlineProfilesButtonBKG.Size = UDim2.new(0, 47, 0, 31)
OnlineProfilesButtonBKG.Position = UDim2.new(0, 165, 0, 5)
OnlineProfilesButtonBKG.ZIndex = 3
OnlineProfilesButtonBKG.Parent = ProfilesTextList["Object"]
local OnlineProfilesButtonImage = Instance.new("ImageLabel")
OnlineProfilesButtonImage.BackgroundTransparency = 1
OnlineProfilesButtonImage.Position = UDim2.new(0, 14, 0, 7)
OnlineProfilesButtonImage.Size = UDim2.new(0, 17, 0, 16)
OnlineProfilesButtonImage.Image = getcustomassetfunc("vape/assets/OnlineProfilesButton.png")
OnlineProfilesButtonImage.ImageColor3 = Color3.fromRGB(121, 121, 121)
OnlineProfilesButtonImage.ZIndex = 5
OnlineProfilesButtonImage.Active = false
OnlineProfilesButtonImage.Parent = OnlineProfilesButton
local OnlineProfilesbuttonround1 = Instance.new("UICorner")
OnlineProfilesbuttonround1.CornerRadius = UDim.new(0, 5)
OnlineProfilesbuttonround1.Parent = OnlineProfilesButton
local OnlineProfilesbuttonround2 = Instance.new("UICorner")
OnlineProfilesbuttonround2.CornerRadius = UDim.new(0, 5)
OnlineProfilesbuttonround2.Parent = OnlineProfilesButtonBKG
local OnlineProfilesFrame = Instance.new("Frame")
OnlineProfilesFrame.Size = UDim2.new(0, 660, 0, 445)
OnlineProfilesFrame.Position = UDim2.new(0.5, -330, 0.5, -223)
OnlineProfilesFrame.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
OnlineProfilesFrame.Parent = GuiLibrary["MainGui"].ScaledGui.OnlineProfiles
local OnlineProfilesExitButton = Instance.new("ImageButton")
OnlineProfilesExitButton.Name = "OnlineProfilesExitButton"
OnlineProfilesExitButton.ImageColor3 = Color3.fromRGB(121, 121, 121)
OnlineProfilesExitButton.Size = UDim2.new(0, 24, 0, 24)
OnlineProfilesExitButton.AutoButtonColor = false
OnlineProfilesExitButton.Image = getcustomassetfunc("vape/assets/ExitIcon1.png")
OnlineProfilesExitButton.Visible = true
OnlineProfilesExitButton.Position = UDim2.new(1, -31, 0, 8)
OnlineProfilesExitButton.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
OnlineProfilesExitButton.Parent = OnlineProfilesFrame
local OnlineProfilesExitButtonround = Instance.new("UICorner")
OnlineProfilesExitButtonround.CornerRadius = UDim.new(0, 16)
OnlineProfilesExitButtonround.Parent = OnlineProfilesExitButton
OnlineProfilesExitButton.MouseEnter:connect(function()
	game:GetService("TweenService"):Create(OnlineProfilesExitButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(60, 60, 60), ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play()
end)
OnlineProfilesExitButton.MouseLeave:connect(function()
	game:GetService("TweenService"):Create(OnlineProfilesExitButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(26, 25, 26), ImageColor3 = Color3.fromRGB(121, 121, 121)}):Play()
end)
local OnlineProfilesFrameShadow = Instance.new("ImageLabel")
OnlineProfilesFrameShadow.AnchorPoint = Vector2.new(0.5, 0.5)
OnlineProfilesFrameShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
OnlineProfilesFrameShadow.Image = getcustomassetfunc("vape/assets/WindowBlur.png")
OnlineProfilesFrameShadow.BackgroundTransparency = 1
OnlineProfilesFrameShadow.ZIndex = -1
OnlineProfilesFrameShadow.Size = UDim2.new(1, 6, 1, 6)
OnlineProfilesFrameShadow.ImageColor3 = Color3.new(0, 0, 0)
OnlineProfilesFrameShadow.ScaleType = Enum.ScaleType.Slice
OnlineProfilesFrameShadow.SliceCenter = Rect.new(10, 10, 118, 118)
OnlineProfilesFrameShadow.Parent = OnlineProfilesFrame
local OnlineProfilesFrameIcon = Instance.new("ImageLabel")
OnlineProfilesFrameIcon.Size = UDim2.new(0, 19, 0, 16)
OnlineProfilesFrameIcon.Image = getcustomassetfunc("vape/assets/ProfilesIcon.png")
OnlineProfilesFrameIcon.Name = "WindowIcon"
OnlineProfilesFrameIcon.BackgroundTransparency = 1
OnlineProfilesFrameIcon.Position = UDim2.new(0, 10, 0, 13)
OnlineProfilesFrameIcon.ImageColor3 = Color3.fromRGB(200, 200, 200)
OnlineProfilesFrameIcon.Parent = OnlineProfilesFrame
local OnlineProfilesFrameText = Instance.new("TextLabel")
OnlineProfilesFrameText.Size = UDim2.new(0, 155, 0, 41)
OnlineProfilesFrameText.BackgroundTransparency = 1
OnlineProfilesFrameText.Name = "WindowTitle"
OnlineProfilesFrameText.Position = UDim2.new(0, 36, 0, 0)
OnlineProfilesFrameText.TextXAlignment = Enum.TextXAlignment.Left
OnlineProfilesFrameText.Font = Enum.Font.SourceSans
OnlineProfilesFrameText.TextSize = 17
OnlineProfilesFrameText.Text = "Profiles"
OnlineProfilesFrameText.TextColor3 = Color3.fromRGB(201, 201, 201)
OnlineProfilesFrameText.Parent = OnlineProfilesFrame
local OnlineProfilesFrameText2 = Instance.new("TextLabel")
OnlineProfilesFrameText2.TextSize = 15
OnlineProfilesFrameText2.TextColor3 = Color3.fromRGB(85, 84, 85)
OnlineProfilesFrameText2.Text = "YOUR PROFILES"
OnlineProfilesFrameText2.Font = Enum.Font.SourceSans
OnlineProfilesFrameText2.BackgroundTransparency = 1
OnlineProfilesFrameText2.TextXAlignment = Enum.TextXAlignment.Left
OnlineProfilesFrameText2.TextYAlignment = Enum.TextYAlignment.Top
OnlineProfilesFrameText2.Size = UDim2.new(1, 0, 0, 20)
OnlineProfilesFrameText2.Position = UDim2.new(0, 10, 0, 48)
OnlineProfilesFrameText2.Parent = OnlineProfilesFrame
local OnlineProfilesFrameText3 = Instance.new("TextLabel")
OnlineProfilesFrameText3.TextSize = 15
OnlineProfilesFrameText3.TextColor3 = Color3.fromRGB(85, 84, 85)
OnlineProfilesFrameText3.Text = "PUBLIC PROFILES"
OnlineProfilesFrameText3.Font = Enum.Font.SourceSans
OnlineProfilesFrameText3.BackgroundTransparency = 1
OnlineProfilesFrameText3.TextXAlignment = Enum.TextXAlignment.Left
OnlineProfilesFrameText3.TextYAlignment = Enum.TextYAlignment.Top
OnlineProfilesFrameText3.Size = UDim2.new(1, 0, 0, 20)
OnlineProfilesFrameText3.Position = UDim2.new(0, 231, 0, 48)
OnlineProfilesFrameText3.Parent = OnlineProfilesFrame
local OnlineProfilesBorder1 = Instance.new("Frame")
OnlineProfilesBorder1.BackgroundColor3 = Color3.fromRGB(40, 39, 40)
OnlineProfilesBorder1.BorderSizePixel = 0
OnlineProfilesBorder1.Size = UDim2.new(1, 0, 0, 1)
OnlineProfilesBorder1.Position = UDim2.new(0, 0, 0, 41)
OnlineProfilesBorder1.Parent = OnlineProfilesFrame
local OnlineProfilesBorder2 = Instance.new("Frame")
OnlineProfilesBorder2.BackgroundColor3 = Color3.fromRGB(40, 39, 40)
OnlineProfilesBorder2.BorderSizePixel = 0
OnlineProfilesBorder2.Size = UDim2.new(0, 1, 1, -41)
OnlineProfilesBorder2.Position = UDim2.new(0, 220, 0, 41)
OnlineProfilesBorder2.Parent = OnlineProfilesFrame
local OnlineProfilesList = Instance.new("ScrollingFrame")
OnlineProfilesList.BackgroundTransparency = 1
OnlineProfilesList.Size = UDim2.new(0, 408, 0, 319)
OnlineProfilesList.Position = UDim2.new(0, 230, 0, 122)
OnlineProfilesList.CanvasSize = UDim2.new(0, 408, 0, 319)
OnlineProfilesList.Parent = OnlineProfilesFrame
local OnlineProfilesListGrid = Instance.new("UIGridLayout")
OnlineProfilesListGrid.CellSize = UDim2.new(0, 134, 0, 144)
OnlineProfilesListGrid.CellPadding = UDim2.new(0, 4, 0, 4)
OnlineProfilesListGrid.Parent = OnlineProfilesList
local OnlineProfilesFrameCorner = Instance.new("UICorner")
OnlineProfilesFrameCorner.CornerRadius = UDim.new(0, 4)
OnlineProfilesFrameCorner.Parent = OnlineProfilesFrame
OnlineProfilesButton.MouseButton1Click:connect(function()
	GuiLibrary["MainGui"].ScaledGui.OnlineProfiles.Visible = true
	GuiLibrary["MainGui"].ScaledGui.ClickGui.Visible = false
	if profilesloaded == false then
		local onlineprofiles = {}
		local success, result = pcall(function()
			return game:GetService("HttpService"):JSONDecode((shared.VapeDeveloper and readfile("vape/OnlineProfiles.vapeonline") or game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/OnlineProfiles.vapeonline", true)))
		end)
		onlineprofiles = (success and result or {})
		for i2,v2 in pairs(onlineprofiles) do
			if v2["ProfileGame"] == game.PlaceId then
				local profilebox = Instance.new("Frame")
				profilebox.BackgroundColor3 = Color3.fromRGB(31, 30, 31)
				profilebox.Parent = OnlineProfilesList
				local profiletext = Instance.new("TextLabel")
				profiletext.TextSize = 15
				profiletext.TextColor3 = Color3.fromRGB(137, 136, 137)
				profiletext.Size = UDim2.new(0, 100, 0, 20)
				profiletext.Position = UDim2.new(0, 18, 0, 25)
				profiletext.Font = Enum.Font.SourceSans
				profiletext.TextXAlignment = Enum.TextXAlignment.Left
				profiletext.TextYAlignment = Enum.TextYAlignment.Top
				profiletext.BackgroundTransparency = 1
				profiletext.Text = i2
				profiletext.Parent = profilebox
				local profiledownload = Instance.new("TextButton")
				profiledownload.BackgroundColor3 = Color3.fromRGB(31, 30, 31)
				profiledownload.Size = UDim2.new(0, 69, 0, 31)
				profiledownload.Font = Enum.Font.SourceSans
				profiledownload.TextColor3 = Color3.fromRGB(200, 200, 200)
				profiledownload.TextSize = 15
				profiledownload.AutoButtonColor = false
				profiledownload.Text = "DOWNLOAD"
				profiledownload.Position = UDim2.new(0, 14, 0, 96)
				profiledownload.Visible = false 
				profiledownload.Parent = profilebox
				profiledownload.ZIndex = 2
				local profiledownloadbkg = Instance.new("Frame")
				profiledownloadbkg.Size = UDim2.new(0, 71, 0, 33)
				profiledownloadbkg.BackgroundColor3 = Color3.fromRGB(42, 41, 42)
				profiledownloadbkg.Position = UDim2.new(0, 13, 0, 95)
				profiledownloadbkg.ZIndex = 1
				profiledownloadbkg.Visible = false
				profiledownloadbkg.Parent = profilebox
				profilebox.MouseEnter:connect(function()
					profiletext.TextColor3 = Color3.fromRGB(200, 200, 200)
					profiledownload.Visible = true 
					profiledownloadbkg.Visible = true
				end)
				profilebox.MouseLeave:connect(function()
					profiletext.TextColor3 = Color3.fromRGB(137, 136, 137)
					profiledownload.Visible = false
					profiledownloadbkg.Visible = false
				end)
				profiledownload.MouseEnter:connect(function()
					profiledownload.BackgroundColor3 = Color3.fromRGB(5, 134, 105)
				end)
				profiledownload.MouseLeave:connect(function()
					profiledownload.BackgroundColor3 = Color3.fromRGB(31, 30, 31)
				end)
				profiledownload.MouseButton1Click:connect(function()
					writefile("vape/Profiles/"..v2["ProfileName"]..tostring(game.PlaceId)..".vapeprofile", (shared.VapeDeveloper and readfile("vape/OnlineProfiles/"..v2["OnlineProfileName"]) or game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/OnlineProfiles/"..v2["OnlineProfileName"], true)))
					GuiLibrary["Profiles"][v2["ProfileName"]] = {["Keybind"] = "", ["Selected"] = false}
					if table.find(ProfilesTextList["ObjectList"], v2["ProfileName"]) == nil then
						table.insert(ProfilesTextList["ObjectList"], v2["ProfileName"])
					end
					ProfilesTextList["RefreshValues"](ProfilesTextList["ObjectList"])
				end)
				local profileround = Instance.new("UICorner")
				profileround.CornerRadius = UDim.new(0, 4)
				profileround.Parent = profilebox
				local profileround2 = Instance.new("UICorner")
				profileround2.CornerRadius = UDim.new(0, 4)
				profileround2.Parent = profiledownload
				local profileround3 = Instance.new("UICorner")
				profileround3.CornerRadius = UDim.new(0, 4)
				profileround3.Parent = profiledownloadbkg
			end
		end
		profilesloaded = true
	end
end)
OnlineProfilesExitButton.MouseButton1Click:connect(function()
	GuiLibrary["MainGui"].ScaledGui.OnlineProfiles.Visible = false
	GuiLibrary["MainGui"].ScaledGui.ClickGui.Visible = true
end)

GUI.CreateDivider()
---GUI.CreateCustomButton("Favorites", "vape/assets/FavoritesListIcon.png", UDim2.new(0, 17, 0, 14), function() end, function() end)
--GUI.CreateCustomButton("Text GUIVertical", "vape/assets/TextGUIIcon3.png", UDim2.new(1, -56, 0, 15), function() end, function() end)
local TextGui = GuiLibrary.CreateCustomWindow({
	["Name"] = "Text GUI", 
	["Icon"] = "vape/assets/TextGUIIcon1.png", 
	["IconSize"] = 21
})
local TextGuiCircleObject = {["CircleList"] = {}}
--GUI.CreateCustomButton("Text GUI", "vape/assets/TextGUIIcon2.png", UDim2.new(1, -23, 0, 15), function() TextGui.SetVisible(true) end, function() TextGui.SetVisible(false) end, "OptionsButton")
GUI.CreateCustomToggle({
	["Name"] = "Text GUI", 
	["Icon"] = "vape/assets/TextGUIIcon3.png",
	["Function"] = function(callback) TextGui.SetVisible(callback) end,
	["Priority"] = 2
})	

local rainbowval = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 0, 1)), ColorSequenceKeypoint.new(1, Color3.fromHSV(0, 0, 1))})
local rainbowval2 = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 0, 0.42)), ColorSequenceKeypoint.new(1, Color3.fromHSV(0, 0, 0.42))})
local rainbowval3 = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 0, 1)), ColorSequenceKeypoint.new(1, Color3.fromHSV(0, 0, 1))})
local guicolorslider = {["RainbowValue"] = false}

local onething = Instance.new("ImageLabel")
onething.Parent = TextGui.GetCustomChildren()
onething.Name = "Logo"
onething.Size = UDim2.new(0, 100, 0, 27)
onething.Position = UDim2.new(1, -140, 0, 3)
onething.BackgroundColor3 = Color3.new(0, 0, 0)
onething.BorderSizePixel = 0
onething.BackgroundTransparency = 1
onething.Visible = false
onething.Image = getcustomassetfunc("vape/assets/VapeLogo3.png")
local onething2 = Instance.new("ImageLabel")
onething2.Parent = onething
onething2.Size = UDim2.new(0, 41, 0, 24)
onething2.Name = "Logo2"
onething2.Position = UDim2.new(1, 0, 0, 1)
onething2.BorderSizePixel = 0
onething2.BackgroundColor3 = Color3.new(0, 0, 0)
onething2.BackgroundTransparency = 1
onething2.Image = getcustomassetfunc("vape/assets/VapeLogo4.png")
local onething3 = onething:Clone()
onething3.ImageColor3 = Color3.new(0, 0, 0)
onething3.ImageTransparency = 0.5
onething3.ZIndex = 0
onething3.Position = UDim2.new(0, 1, 0, 1)
onething3.Visible = false
onething3.Parent = onething
onething3.Logo2.ImageColor3 = Color3.new(0, 0, 0)
onething3.Logo2.ZIndex = 0
onething3.Logo2.ImageTransparency = 0.5
local onetext = Instance.new("TextLabel")
onetext.Parent = TextGui.GetCustomChildren()
onetext.Size = UDim2.new(1, 0, 1, 0)
onetext.Position = UDim2.new(1, -154, 0, 35)
onetext.TextColor3 = Color3.new(1, 1, 1)
onetext.RichText = true
onetext.BackgroundTransparency = 1
onetext.TextXAlignment = Enum.TextXAlignment.Left
onetext.TextYAlignment = Enum.TextYAlignment.Top
onetext.BorderSizePixel = 0
onetext.BackgroundColor3 = Color3.new(0, 0, 0)
onetext.Font = Enum.Font.SourceSans
onetext.Text = ""
onetext.TextSize = 20
local onetext2 = Instance.new("TextLabel")
onetext2.Name = "ExtraText"
onetext2.Parent = onetext
onetext2.Size = UDim2.new(1, 0, 1, 0)
onetext2.Position = UDim2.new(0, 1, 0, 1)
onetext2.BorderSizePixel = 0
onetext2.Visible = false
onetext2.ZIndex = 0
onetext2.Text = ""
onetext2.BackgroundTransparency = 1
onetext2.TextTransparency = 0.5
onetext2.TextXAlignment = Enum.TextXAlignment.Left
onetext2.TextYAlignment = Enum.TextYAlignment.Top
onetext2.TextColor3 = Color3.new(0, 0, 0)
onetext2.Font = Enum.Font.SourceSans
onetext2.TextSize = 20
local onetext3 = onetext:Clone()
onetext3.Name = "ExtraText"
onetext3.Position = UDim2.new(0, 0, 0, 0)
onetext3.TextColor3 = Color3.new(0.65, 0.65, 0.65)
onetext3.Parent = onetext
local onetext4 = onetext3.ExtraText
onetext4.TextColor3 = Color3.new(0, 0, 0)
onetext4.TextTransparency = 0.5
local onebackground = Instance.new("Frame")
onebackground.BackgroundTransparency = 0.5
onebackground.BorderSizePixel = 0
onebackground.BackgroundColor3 = Color3.new(0, 0, 0)
onebackground.Visible = false 
onebackground.Parent = TextGui.GetCustomChildren()
onebackground.ZIndex = 0
onetext3:GetPropertyChangedSignal("Text"):connect(function() onetext4.Text = onetext3.Text end)
onetext:GetPropertyChangedSignal("Size"):connect(function()
	onebackground.Position = onething.Position - UDim2.new(0, (onetext.Position.X.Offset == -154 and 10 or 0), 0, 0)
	onebackground.Size = UDim2.new(0, onetext.Size.X.Offset, 0, onetext.Size.Y.Offset + (onething.Visible and 27 or 0))
end)
onetext:GetPropertyChangedSignal("Position"):connect(function()
	onebackground.Position = onething.Position - UDim2.new(0, (onetext.Position.X.Offset == -154 and 10 or 0), 0, 0)
	onebackground.Size = UDim2.new(0, onetext.Size.X.Offset, 0, onetext.Size.Y.Offset + (onething.Visible and 27 or 0))
end)
TextGui.GetCustomChildren().Parent:GetPropertyChangedSignal("Position"):connect(function()
	if (TextGui.GetCustomChildren().Parent.Position.X.Offset + TextGui.GetCustomChildren().Parent.Size.X.Offset / 2) >= (cam.ViewportSize.X / 2) then
		onetext.TextXAlignment = Enum.TextXAlignment.Right
		onetext2.TextXAlignment = Enum.TextXAlignment.Right
		onetext3.TextXAlignment = Enum.TextXAlignment.Right
		onetext4.TextXAlignment = Enum.TextXAlignment.Right
		onetext2.Position = UDim2.new(0, 1, 0, 1)
		onething.Position = UDim2.new(1, -142, 0, 8)
		onetext.Position = UDim2.new(1, -154, 0, (onething.Visible and 35 or 5))
	else
		onetext.TextXAlignment = Enum.TextXAlignment.Left
		onetext2.TextXAlignment = Enum.TextXAlignment.Left
		onetext2.Position = UDim2.new(0, 4, 0, 1)
		onetext3.TextXAlignment = Enum.TextXAlignment.Left
		onetext4.TextXAlignment = Enum.TextXAlignment.Left
		onething.Position = UDim2.new(0, 2, 0, 8)
		onetext.Position = UDim2.new(0, 6, 0, (onething.Visible and 35 or 5))
	end
end)

onething.Visible = true onetext.Position = UDim2.new(0, 0, 0, 35)

local sortingmethod = "Alphabetical"
local textwithoutthing = ""
local function getSpaces(str)
		local strSize = game:GetService("TextService"):GetTextSize(str, 20, Enum.Font.SourceSans, Vector2.new(10000, 10000))
		return math.ceil(strSize.X / 3)
end
local function UpdateHud()
	local text = ""
	local text2 = ""
	local tableofmodules = {}
	local first = true
	
	for i,v in pairs(GuiLibrary["ObjectsThatCanBeSaved"]) do
		if v["Type"] == "OptionsButton" and v["Api"]["Name"] ~= "Text GUI" then
			if v["Api"]["Enabled"] then
				local blacklisted = table.find(TextGuiCircleObject["CircleList"]["ObjectList"], v["Api"]["Name"]) and TextGuiCircleObject["CircleList"]["ObjectListEnabled"][table.find(TextGuiCircleObject["CircleList"]["ObjectList"], v["Api"]["Name"])]
				if not blacklisted then
					table.insert(tableofmodules, {["Text"] = v["Api"]["Name"], ["ExtraText"] = v["Api"]["GetExtraText"]})
				end
			end
		end
	end
	if sortingmethod == "Alphabetical" then
		table.sort(tableofmodules, function(a, b) return a["Text"]:lower() < b["Text"]:lower() end)
	else
		table.sort(tableofmodules, function(a, b) 
			local textsize1 = a["Text"]..(a["ExtraText"] and a["ExtraText"]() or "")
			local textsize2 = b["Text"]..(b["ExtraText"] and b["ExtraText"]() or "")
			textsize1 = game:GetService("TextService"):GetTextSize(textsize1, onetext.TextSize, onetext.Font, Vector2.new(1000000, 1000000))
			textsize2 = game:GetService("TextService"):GetTextSize(textsize2, onetext.TextSize, onetext.Font, Vector2.new(1000000, 1000000))
			return textsize1.X > textsize2.X 
		end)
	end
	for i2,v2 in pairs(tableofmodules) do
		if first then
			text = v2["Text"]..string.rep(" ", getSpaces(v2["ExtraText"]()))
			text2 = string.rep(" ", getSpaces(v2["Text"]))..v2["ExtraText"]()
			first = false
		else
			text = text..'\n'..v2["Text"]..string.rep(" ", getSpaces(v2["ExtraText"]()))
			text2 = text2..'\n'..string.rep(" ", getSpaces(v2["Text"]))..v2["ExtraText"]()
		end
	end
	textwithoutthing = text
	onetext.Text = text
	onetext2.Text = text
	onetext3.Text = text2
	local newsize = game:GetService("TextService"):GetTextSize(text, onetext.TextSize, onetext.Font, Vector2.new(1000000, 1000000))
	if text == "" then
		newsize = Vector2.new(0, 0)
	end
	onetext.Size = UDim2.new(0, 154, 0, newsize.Y)
	onetext3.Size = UDim2.new(0, 154, 0, newsize.Y)
	if TextGui.GetCustomChildren().Parent then
		if (TextGui.GetCustomChildren().Parent.Position.X.Offset + TextGui.GetCustomChildren().Parent.Size.X.Offset / 2) >= (cam.ViewportSize.X / 2) then
			onetext.TextXAlignment = Enum.TextXAlignment.Right
			onetext2.Position = UDim2.new(0, 1, 0, 1)
			onetext2.TextXAlignment = Enum.TextXAlignment.Right
			onetext3.TextXAlignment = Enum.TextXAlignment.Right
			onetext4.TextXAlignment = Enum.TextXAlignment.Right
			onething.Position = UDim2.new(1, -142, 0, 8)
			onetext.Position = UDim2.new(1, -154, 0, (onething.Visible and 35 or 5))
		else
			onetext.TextXAlignment = Enum.TextXAlignment.Left
			onetext2.TextXAlignment = Enum.TextXAlignment.Left
			onetext2.Position = UDim2.new(0, 4, 0, 1)
			onetext3.TextXAlignment = Enum.TextXAlignment.Left
			onetext4.TextXAlignment = Enum.TextXAlignment.Left
			onething.Position = UDim2.new(0, 2, 0, 8)
			onetext.Position = UDim2.new(0, 6, 0, (onething.Visible and 35 or 5))
		end
	end
	GuiLibrary["UpdateUI"]()
end

GuiLibrary["UpdateHudEvent"].Event:connect(UpdateHud)
TextGui.CreateDropdown({
	["Name"] = "Sort",
	["List"] = {"Alphabetical", "Length"},
	["Function"] = function(val)
		sortingmethod = val
		GuiLibrary["UpdateHudEvent"]:Fire()
	end
})
TextGui.CreateToggle({
	["Name"] = "Shadow", 
	["Function"] = function(callback) onetext2.Visible = callback onetext4.Visible = callback onething3.Visible = callback end,
	["HoverText"] = "Renders shadowed text."
})
local TextGuiUseCategoryColor = TextGui.CreateToggle({
	["Name"] = "Use Category Color", 
	["Function"] = function(callback) GuiLibrary["UpdateUI"]() end
})
TextGui.CreateToggle({
	["Name"] = "Watermark", 
	["Function"] = function(callback) 
		if callback then
			onething.Visible = true 
			if (TextGui.GetCustomChildren().Parent.Position.X.Offset + TextGui.GetCustomChildren().Parent.Size.X.Offset / 2) >= (cam.ViewportSize.X / 2) then
				onetext.TextXAlignment = Enum.TextXAlignment.Right
				onetext2.TextXAlignment = Enum.TextXAlignment.Right
				onetext2.Position = UDim2.new(0, 1, 0, 1)
				onetext3.TextXAlignment = Enum.TextXAlignment.Right
				onetext4.TextXAlignment = Enum.TextXAlignment.Right
				onething.Position = UDim2.new(1, -142, 0, 8)
				onetext.Position = UDim2.new(1, -154, 0, (onething.Visible and 35 or 5))
			else
				onetext.TextXAlignment = Enum.TextXAlignment.Left
				onetext2.TextXAlignment = Enum.TextXAlignment.Left
				onetext2.Position = UDim2.new(0, 4, 0, 1)
				onetext3.TextXAlignment = Enum.TextXAlignment.Left
				onetext4.TextXAlignment = Enum.TextXAlignment.Left
				onething.Position = UDim2.new(0, 2, 0, 8)
				onetext.Position = UDim2.new(0, 6, 0, (onething.Visible and 35 or 5))
			end
		else
			onething.Visible = false
			if (TextGui.GetCustomChildren().Parent.Position.X.Offset + TextGui.GetCustomChildren().Parent.Size.X.Offset / 2) >= (cam.ViewportSize.X / 2) then
				onetext.TextXAlignment = Enum.TextXAlignment.Right
				onetext2.TextXAlignment = Enum.TextXAlignment.Right
				onetext2.Position = UDim2.new(0, 1, 0, 1)
				onetext3.TextXAlignment = Enum.TextXAlignment.Right
				onetext4.TextXAlignment = Enum.TextXAlignment.Right
				onething.Position = UDim2.new(1, -142, 0, 8)
				onetext.Position = UDim2.new(1, -154, 0, (onething.Visible and 35 or 5))
			else
				onetext.TextXAlignment = Enum.TextXAlignment.Left
				onetext2.TextXAlignment = Enum.TextXAlignment.Left
				onetext2.Position = UDim2.new(0, 4, 0, 1)
				onetext3.TextXAlignment = Enum.TextXAlignment.Left
				onetext4.TextXAlignment = Enum.TextXAlignment.Left
				onething.Position = UDim2.new(0, 2, 0, 8)
				onetext.Position = UDim2.new(0, 6, 0, (onething.Visible and 35 or 5))
			end
		end
	end,
	["HoverText"] = "Renders a vape watermark"
})
TextGui.CreateToggle({
	["Name"] = "Render background", 
	["Function"] = function(callback)
		onebackground.Visible = callback
	end
})
TextGuiCircleObject = TextGui.CreateCircleWindow({
	["Name"] = "Blacklist",
	["Type"] = "Blacklist",
	["UpdateFunction"] = function()
		GuiLibrary["UpdateHudEvent"]:Fire()
	end
})

local healthColorToPosition = {
	[Vector3.new(Color3.fromRGB(255, 28, 0).r,
  Color3.fromRGB(255, 28, 0).g,
  Color3.fromRGB(255, 28, 0).b)] = 0.1;
	[Vector3.new(Color3.fromRGB(250, 235, 0).r,
  Color3.fromRGB(250, 235, 0).g,
  Color3.fromRGB(250, 235, 0).b)] = 0.5;
	[Vector3.new(Color3.fromRGB(27, 252, 107).r,
  Color3.fromRGB(27, 252, 107).g,
  Color3.fromRGB(27, 252, 107).b)] = 0.8;
}
local min = 0.1
local minColor = Color3.fromRGB(255, 28, 0)
local max = 0.8
local maxColor = Color3.fromRGB(27, 252, 107)

local function HealthbarColorTransferFunction(healthPercent)
	if healthPercent < min then
		return minColor
	elseif healthPercent > max then
		return maxColor
	end


	local numeratorSum = Vector3.new(0,0,0)
	local denominatorSum = 0
	for colorSampleValue, samplePoint in pairs(healthColorToPosition) do
		local distance = healthPercent - samplePoint
		if distance == 0 then
			
			return Color3.new(colorSampleValue.x, colorSampleValue.y, colorSampleValue.z)
		else
			local wi = 1 / (distance*distance)
			numeratorSum = numeratorSum + wi * colorSampleValue
			denominatorSum = denominatorSum + wi
		end
	end
	local result = numeratorSum / denominatorSum
	return Color3.new(result.x, result.y, result.z)
end

local TargetInfo = GuiLibrary.CreateCustomWindow({
	["Name"] = "Target Info",
	["Icon"] = "vape/assets/TargetInfoIcon1.png",
	["IconSize"] = 16
})
local TargetInfoDisplayNames = TargetInfo.CreateToggle({
	["Name"] = "Use Display Name",
	["Function"] = function() end,
	["Default"] = true
})
local targetinfobkg1 = Instance.new("Frame")
targetinfobkg1.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
targetinfobkg1.BorderSizePixel = 0
targetinfobkg1.Size = UDim2.new(0, 220, 0, 72)
targetinfobkg1.Position = UDim2.new(0, 0, 0, 0)
targetinfobkg1.Parent = TargetInfo.GetCustomChildren()
local targetinfobkg2 = targetinfobkg1:Clone()
targetinfobkg2.ZIndex = 0
targetinfobkg2.Position = UDim2.new(0, 0, 0, -6)
targetinfobkg2.Size = UDim2.new(0, 220, 0, 86)
targetinfobkg2.Parent = targetinfobkg1
local targetinfobkg3 = Instance.new("Frame")
targetinfobkg3.BackgroundColor3 = Color3.fromRGB(31, 30, 31)
targetinfobkg3.Size = UDim2.new(0, 220, 0, 80)
targetinfobkg3.Position = UDim2.new(0, 0, 0, -5)
targetinfobkg3.Name = "MainInfo"
targetinfobkg3.Parent = targetinfobkg1
local targetname = Instance.new("TextLabel")
targetname.TextSize = 17
targetname.Font = Enum.Font.SourceSans
targetname.TextColor3 = Color3.fromRGB(162, 162, 162)
targetname.Position = UDim2.new(0, 72, 0, 7)
targetname.TextStrokeTransparency = 0.75
targetname.BackgroundTransparency = 1
targetname.Size = UDim2.new(0, 80, 0, 16)
targetname.TextScaled = true
targetname.Text = "Target name"
targetname.ZIndex = 2
targetname.TextXAlignment = Enum.TextXAlignment.Left
targetname.TextYAlignment = Enum.TextYAlignment.Top
targetname.Parent = targetinfobkg3
local targethealth = Instance.new("TextLabel")
targethealth.TextColor3 = Color3.fromRGB(95, 94, 95)
targethealth.Font = Enum.Font.SourceSans
targethealth.Size = UDim2.new(0, 0, 0, 0)
targethealth.TextSize = 17
targethealth.Position = UDim2.new(0, 210, 0, 6)
targethealth.BackgroundTransparency = 1
targethealth.Text = '20'..' hp'
targethealth.TextScaled = false
targethealth.ZIndex = 2
targethealth.TextXAlignment = Enum.TextXAlignment.Right
targethealth.TextYAlignment = Enum.TextYAlignment.Top
targethealth.Parent = targetinfobkg3
local targethealthbkg = Instance.new("Frame")
targethealthbkg.BackgroundColor3 = Color3.fromRGB(43, 42, 43)
targethealthbkg.Size = UDim2.new(0, 138, 0, 4)
targethealthbkg.Position = UDim2.new(0, 72, 0, 29)
targethealthbkg.Parent = targetinfobkg3
local targethealthgreen = Instance.new("Frame")
targethealthgreen.BackgroundColor3 = Color3.fromRGB(40, 137, 109)
targethealthgreen.Size = UDim2.new(1, 0, 0, 4)
targethealthgreen.ZIndex = 3
targethealthgreen.Parent = targethealthbkg
local targetimage = Instance.new("ImageLabel")
targetimage.Size = UDim2.new(0, 61, 0, 61)
targetimage.BackgroundTransparency = 1
targetimage.Image = 'rbxthumb://type=AvatarHeadShot&id='..game:GetService("Players").LocalPlayer.UserId..'&w=420&h=420'
targetimage.Position = UDim2.new(0, 5, 0, 10)
targetimage.Parent = targetinfobkg3
local round1 = Instance.new("UICorner")
round1.CornerRadius = UDim.new(0, 4)
round1.Parent = targetinfobkg2
local round2 = Instance.new("UICorner")
round2.CornerRadius = UDim.new(0, 4)
round2.Parent = targetinfobkg3
local round3 = Instance.new("UICorner")
round3.CornerRadius = UDim.new(0, 8)
round3.Parent = targethealthbkg
local round4 = Instance.new("UICorner")
round4.CornerRadius = UDim.new(0, 8)
round4.Parent = targethealthgreen
local round5 = Instance.new("UICorner")
round5.CornerRadius = UDim.new(0, 4)
round5.Parent = targetimage
local oldhealth = 100
local allowedtween = true
TargetInfo.GetCustomChildren().Parent:GetPropertyChangedSignal("Size"):connect(function()
	if TargetInfo.GetCustomChildren().Parent.Size ~= UDim2.new(0, 220, 0, 0) then
		targetinfobkg3.Position = UDim2.new(0, 0, 0, -5)
		targetinfobkg2.BackgroundTransparency = 0
		targetinfobkg1.BackgroundTransparency = 0
	else
		targetinfobkg3.Position = UDim2.new(0, 0, 0, 40)
		targetinfobkg2.BackgroundTransparency = 1
		targetinfobkg1.BackgroundTransparency = 1
	end
end)
shared.VapeTargetInfo = {
	["UpdateInfo"] = function(tab, targetsize)
		targetinfobkg3.Visible = (targetsize > 0) or (TargetInfo.GetCustomChildren().Parent.Size ~= UDim2.new(0, 220, 0, 0))
		for i,v in pairs(tab) do
			local plr = game:GetService("Players"):FindFirstChild(i)
			targetimage.Image = 'rbxthumb://type=AvatarHeadShot&id='..v["UserId"]..'&w=420&h=420'
			targethealthgreen:TweenSize(UDim2.new(v["Health"] / v["MaxHealth"], 0, 0, 4), Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.05, true)
			targethealth.Text = (math.floor((v["Health"] / 5) * 10) / 10).." hp"
			targethealthgreen.BackgroundColor3 = HealthbarColorTransferFunction(v["Health"] / v["MaxHealth"])
			targetname.Text = (TargetInfoDisplayNames["Enabled"] and plr and plr.DisplayName or i)
		end
	end,
	["Object"] = TargetInfo
}
GUI.CreateCustomToggle({
	["Name"] = "Target Info", 
	["Icon"] = "vape/assets/TargetInfoIcon2.png", 
	["Function"] = function(callback) TargetInfo.SetVisible(callback) end,
	["Priority"] = 1
})
local GeneralSettings = GUI.CreateDivider2("General Settings")
local ModuleSettings = GUI.CreateDivider2("Module Settings")
local GUISettings = GUI.CreateDivider2("GUI Settings")
ModuleSettings.CreateToggle({
	["Name"] = "Teams by server", 
	["Function"] = function() end,
})
ModuleSettings.CreateToggle({
	["Name"] = "Teams by color", 
	["Function"] = function() end,
	["Default"] = true,
	["HoverText"] = "Ignore players with the selected name color"
})
local MiddleClickInput
ModuleSettings.CreateToggle({
	["Name"] = "MiddleClick friends", 
	["Function"] = function(callback) 
		if callback then
			MiddleClickInput = game:GetService("UserInputService").InputBegan:connect(function(input1)
				if input1.UserInputType == Enum.UserInputType.MouseButton3 then
					if mouse.Target.Parent:FindFirstChild("HumanoidRootPart") or mouse.Target.Parent:IsA("Accessory") and mouse.Target.Parent.Parent:FindFirstChild("HumanoidRootPart") then
						local user = (mouse.Target.Parent:IsA("Accessory") and mouse.Target.Parent.Parent.Name or mouse.Target.Parent.Name)
						if table.find(FriendsTextList["ObjectList"], user) == nil then
							table.insert(FriendsTextList["ObjectList"], user)
							FriendsTextList["RefreshValues"](FriendsTextList["ObjectList"])
						else
							table.remove(FriendsTextList["ObjectList"], table.find(FriendsTextList["ObjectList"], user)) 
							FriendsTextList["RefreshValues"](FriendsTextList["ObjectList"])
						end
					end
				end
			end)
		else
			if MiddleClickInput then
				MiddleClickInput:Disconnect()
			end
		end
	end,
	["HoverText"] = "Click middle mouse button to add the player you are hovering over as a friend"
})
ModuleSettings.CreateToggle({
	["Name"] = "Lobby Check",
	["Function"] = function() end,
	["Default"] = true,
	["HoverText"] = "Temporarily disables certain features in server lobbies."
})
local blatantmode = GUI.CreateToggle({
	["Name"] = "Blatant mode",
	["Function"] = function() end,
	["HoverText"] = "Required for certain features."
})
guicolorslider = GUI.CreateColorSlider("GUI Theme", function(val) GuiLibrary["Settings"]["GUIObject"]["Color"] = val GuiLibrary["UpdateUI"]() end)
local tabsortorder = {
	["CombatButton"] = 1,
	["BlatantButton"] = 2,
	["RenderButton"] = 3,
	["UtilityButton"] = 4,
	["WorldButton"] = 5,
	["FriendsButton"] = 6,
	["ProfilesButton"] = 7
}

local tabcategorycolor = {
	["CombatWindow"] = Color3.fromRGB(214, 27, 6),
	["BlatantWindow"] = Color3.fromRGB(219, 21, 133),
	["RenderWindow"] = Color3.fromRGB(0, 255, 0),
	["UtilityWindow"] = Color3.fromRGB(0, 193, 22),
	["WorldWindow"] = Color3.fromRGB(231, 6, 112)
}

GuiLibrary["UpdateUI"] = function()
	pcall(function()
		GuiLibrary["ObjectsThatCanBeSaved"]["GUIWindow"]["Object"].Logo1.Logo2.ImageColor3 = Color3.fromHSV(GuiLibrary["Settings"]["GUIObject"]["Color"], 0.7, 0.9)
		onething.ImageColor3 = Color3.fromHSV(GuiLibrary["Settings"]["GUIObject"]["Color"], 0.7, 0.9)
		onetext.TextColor3 = Color3.fromHSV(GuiLibrary["Settings"]["GUIObject"]["Color"], 0.7, 0.9)
		local newtext = ""
		local newfirst = false
		for i2,v2 in pairs(textwithoutthing:split("\n")) do
			local rainbowcolor = GuiLibrary["Settings"]["GUIObject"]["Color"] + (GuiLibrary["ObjectsThatCanBeSaved"]["Gui ColorSliderColor"]["Api"]["RainbowValue"] and (-0.025 * i2) or 0)
			if rainbowcolor < 0 then rainbowcolor = 1 + rainbowcolor end
			local newcolor = Color3.fromHSV(rainbowcolor, 0.7, 0.9)
			if TextGuiUseCategoryColor["Enabled"] and GuiLibrary["ObjectsThatCanBeSaved"][v2:gsub(" ", "").."OptionsButton"] and tabcategorycolor[GuiLibrary["ObjectsThatCanBeSaved"][v2:gsub(" ", "").."OptionsButton"]["Object"].Parent.Parent.Name.."Window"] then
				newcolor = tabcategorycolor[GuiLibrary["ObjectsThatCanBeSaved"][v2:gsub(" ", "").."OptionsButton"]["Object"].Parent.Parent.Name.."Window"]
			end
			newtext = newtext..(newfirst and "\n" or " ")..'<font color="rgb('..tostring(math.floor(newcolor.R * 255))..","..tostring(math.floor(newcolor.G * 255))..","..tostring(math.floor(newcolor.B * 255))..')">'..v2..'</font>'
			newfirst = true
		end
		onetext.Text = newtext
		local buttons = 0
		for i,v in pairs(GuiLibrary["ObjectsThatCanBeSaved"]) do
			if v["Type"] == "TargetFrame" then
				if v["Object2"].Visible then
					v["Object"].TextButton.Frame.BackgroundColor3 = Color3.fromHSV(GuiLibrary["Settings"]["GUIObject"]["Color"], 0.7, 0.9)
				end
			end
			if v["Type"] == "TargetButton" then
				if v["Api"]["Enabled"] then
					v["Object"].BackgroundColor3 = Color3.fromHSV(GuiLibrary["Settings"]["GUIObject"]["Color"], 0.7, 0.9)
				end
			end
			if v["Type"] == "CircleListFrame" then
				if v["Object2"].Visible then
					v["Object"].TextButton.Frame.BackgroundColor3 = Color3.fromHSV(GuiLibrary["Settings"]["GUIObject"]["Color"], 0.7, 0.9)
				end
			end
			if (v["Type"] == "Button" or v["Type"] == "ButtonMain") and v["Api"]["Enabled"] then
				buttons = buttons + 1
				local rainbowcolor = GuiLibrary["Settings"]["GUIObject"]["Color"] + (GuiLibrary["ObjectsThatCanBeSaved"]["Gui ColorSliderColor"]["Api"]["RainbowValue"] and (-0.025 * tabsortorder[i]) or 0)
				if rainbowcolor < 0 then rainbowcolor = 1 + rainbowcolor end
				local newcolor = Color3.fromHSV(rainbowcolor, 0.7, 0.9)
				v["Object"].ButtonText.TextColor3 = newcolor
				if v["Object"]:FindFirstChild("ButtonIcon") then
					v["Object"].ButtonIcon.ImageColor3 = newcolor
				end
			end
			if v["Type"] == "OptionsButton" then
				if v["Api"]["Enabled"] then
					v["Object"].BackgroundColor3 = Color3.fromHSV(GuiLibrary["Settings"]["GUIObject"]["Color"], 0.7, 0.9)
				end
			end
			if v["Type"] == "ExtrasButton" then
				if v["Api"]["Enabled"] then
					local rainbowcolor = GuiLibrary["Settings"]["GUIObject"]["Color"] + (GuiLibrary["ObjectsThatCanBeSaved"]["Gui ColorSliderColor"]["Api"]["RainbowValue"] and (-0.025 * buttons) or 0)
					if rainbowcolor < 0 then rainbowcolor = 1 + rainbowcolor end
					local newcolor = Color3.fromHSV(rainbowcolor, 0.7, 0.9)
					v["Object"].ImageColor3 = newcolor
				end
			end
			if (v["Type"] == "Toggle" or v["Type"] == "ToggleMain") and v["Api"]["Enabled"] then
					v["Object"].ToggleFrame1.BackgroundColor3 = Color3.fromHSV(GuiLibrary["Settings"]["GUIObject"]["Color"], 0.7, 0.9)
			end
			if v["Type"] == "Slider" then
				v["Object"].Slider.FillSlider.BackgroundColor3 = Color3.fromHSV(GuiLibrary["Settings"]["GUIObject"]["Color"], 0.7, 0.9)
				v["Object"].Slider.FillSlider.ButtonSlider.ImageColor3 = Color3.fromHSV(GuiLibrary["Settings"]["GUIObject"]["Color"], 0.7, 0.9)
			end
			if v["Type"] == "TwoSlider" then
				v["Object"].Slider.FillSlider.BackgroundColor3 = Color3.fromHSV(GuiLibrary["Settings"]["GUIObject"]["Color"], 0.7, 0.9)
				v["Object"].Slider.ButtonSlider.ImageColor3 = Color3.fromHSV(GuiLibrary["Settings"]["GUIObject"]["Color"], 0.7, 0.9)
				v["Object"].Slider.ButtonSlider2.ImageColor3 = Color3.fromHSV(GuiLibrary["Settings"]["GUIObject"]["Color"], 0.7, 0.9)
			end
		end
		local rainbowcolor = GuiLibrary["Settings"]["GUIObject"]["Color"] + (GuiLibrary["ObjectsThatCanBeSaved"]["Gui ColorSliderColor"]["Api"]["RainbowValue"] and (-0.025 * buttons) or 0)
		if rainbowcolor < 0 then rainbowcolor = 1 + rainbowcolor end
		GuiLibrary["ObjectsThatCanBeSaved"]["GUIWindow"]["Object"].Children.Extras.MainButton.ImageColor3 = (GUI["GetVisibleIcons"]() > 0 and Color3.fromHSV(rainbowcolor, 0.7, 0.9) or Color3.fromRGB(199, 199, 199))
		for i3, v3 in pairs(ProfilesTextList["ScrollingObject"].ScrollingFrame:GetChildren()) do
		--	pcall(function()
				if v3:IsA("TextButton") and v3.ItemText.Text == GuiLibrary["CurrentProfile"] then
					v3.BackgroundColor3 = Color3.fromHSV(GuiLibrary["Settings"]["GUIObject"]["Color"], 0.7, 0.9)
					v3.ImageButton.BackgroundColor3 = Color3.fromHSV(GuiLibrary["Settings"]["GUIObject"]["Color"], 0.7, 0.9)
					v3.ItemText.TextColor3 = Color3.new(1, 1, 1)
					v3.ItemText.TextStrokeTransparency = 0.75
				end
		--	end)
		end
	end)
end

GeneralSettings.CreateToggle({
	["Name"] = "Auto-load module states", 
	["Function"] = function() end,
	["HoverText"] = "Automatically enable saved module states upon loading profiles.\n(You can save module states by shift-clicking a profile button)"
})
GUISettings.CreateToggle({
	["Name"] = "Blur Background", 
	["Function"] = function(callback) GuiLibrary["MainBlur"].Size = (callback and 25 or 0) end,
	["Default"] = true,
	["HoverText"] = "Blur the background of the GUI"
})
local rescale = GUISettings.CreateToggle({
	["Name"] = "Rescale", 
	["Function"] = function(callback) 
		GuiLibrary["MainRescale"].Scale = (callback and math.clamp(cam.ViewportSize.X / 1920, 0.5, 1) or 0.99)
		wait(0.01)
		GuiLibrary["MainRescale"].Scale = (callback and math.clamp(cam.ViewportSize.X / 1920, 0.5, 1) or 1)
	end,
	["Default"] = true
})
cam:GetPropertyChangedSignal("ViewportSize"):connect(function()
	if rescale["Enabled"] then
		GuiLibrary["MainRescale"].Scale = math.clamp(cam.ViewportSize.X / 1920, 0.5, 1)
	end
end)
GeneralSettings.CreateToggle({
	["Name"] = "Enable Multi-Keybinding", 
	["Function"] = function() end
})
local welcomemsg = GUISettings.CreateToggle({
	["Name"] = "GUI bind indicator", 
	["Function"] = function() end, 
	["Default"] = true,
	["HoverText"] = 'Displays a message indicating your GUI keybind upon injecting.\nI.E "Press RIGHTSHIFT to open GUI"'
})
GUISettings.CreateToggle({
	["Name"] = "Show Tooltips", 
	["Function"] = function(callback) GuiLibrary["ToggleTooltips"] = callback end,
	["Default"] = true,
	["HoverText"] = "Toggles visibility of these"
})
GeneralSettings.CreateToggle({
	["Name"] = "Discord integration", 
	["Function"] = function() end
})
local ToggleNotifications = {["Object"] = nil}
local Notifications = {}
Notifications = GeneralSettings.CreateToggle({
	["Name"] = "Notifications", 
	["Function"] = function(callback) 
		GuiLibrary["Notifications"] = callback 
	end,
	["Default"] = true,
	["HoverText"] = "Shows notifications"
})
ToggleNotifications = GUISettings.CreateToggle({
	["Name"] = "Toggle Alert", 
	["Function"] = function(callback) GuiLibrary["ToggleNotifications"] = callback end,
	["Default"] = true,
	["HoverText"] = "Notifies you if a module is enabled/disabled."
})
ToggleNotifications["Object"].BackgroundTransparency = 0
ToggleNotifications["Object"].BorderSizePixel = 0
ToggleNotifications["Object"].BackgroundColor3 = Color3.fromRGB(20, 20, 20)

local GUIbind = GUI.CreateGUIBind()

local teleportfunc = game:GetService("Players").LocalPlayer.OnTeleport:Connect(function(State)
    if State == Enum.TeleportState.Started then
		GuiLibrary["SaveSettings"]()
        queueteleport('shared.VapeSwitchServers = true wait(1) if shared.VapeDeveloper then loadstring(readfile("vape/NewMainScript.lua"))() else loadstring(game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/NewMainScript.lua", true))() end')
    end
end)

GuiLibrary["SelfDestruct"] = function()
	game:GetService("UserInputService").OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.None
	GuiLibrary["SelfDestructEvent"]:Fire()
	selfdestruct = true
	GuiLibrary["SaveSettings"]()
	for i,v in pairs(GuiLibrary["ObjectsThatCanBeSaved"]) do
		if (v["Type"] == "Button" or v["Type"] == "OptionsButton") and v["Api"]["Enabled"] then
			v["Api"]["ToggleButton"](false)
		end
	end
	shared.VapeExecuted = nil
	shared.VapeSwitchServers = nil
	shared.GuiLibrary = nil
	GuiLibrary["KeyInputHandler"]:Disconnect()
	GuiLibrary["KeyInputHandler2"]:Disconnect()
	if MiddleClickInput then
		MiddleClickInput:Disconnect()
	end
	teleportfunc:Disconnect()
	GuiLibrary["MainGui"]:Remove()
	GuiLibrary["MainBlur"]:Remove()
end

ModuleSettings.CreateButton2({
	["Name"] = "RESET CURRENT PROFILE", 
	["Function"] = function()
		GuiLibrary["SelfDestruct"]()
		delfile("vape/Profiles/"..(GuiLibrary["CurrentProfile"] == "default" and "" or GuiLibrary["CurrentProfile"])..game.PlaceId..".vapeprofile")
		shared.VapeSwitchServers = true
		shared.VapeOpenGui = true
		loadstring(GetURL("NewMainScript.lua"))()
	end
})
GUISettings.CreateButton2({
	["Name"] = "RESET GUI POSITIONS", 
	["Function"] = function()
		for i,v in pairs(GuiLibrary["ObjectsThatCanBeSaved"]) do
			if (v["Type"] == "Window" or v["Type"] == "CustomWindow") and GuiLibrary["findObjectInTable"](GuiLibrary["ObjectsThatCanBeSaved"], i) then
				v["Object"].Position = (i == "GUIWindow" and UDim2.new(0, 6, 0, 6) or UDim2.new(0, 223, 0, 6))
			end
		end
	end
})
GUISettings.CreateButton2({
	["Name"] = "SORT GUI", 
	["Function"] = function()
		local sorttable = {}
		local movedown = false
		local sortordertable = {
			["GUIWindow"] = 1,
			["CombatWindow"] = 2,
			["BlatantWindow"] = 3,
			["RenderWindow"] = 4,
			["UtilityWindow"] = 5,
			["WorldWindow"] = 6,
			["FriendsWindow"] = 7,
			["ProfilesWindow"] = 8,
			["Text GUICustomWindow"] = 9,
			["TargetInfoCustomWindow"] = 10,
			["RadarCustomWindow"] = 11,
		}
		local storedpos = {}
		local num = 6
		for i,v in pairs(GuiLibrary["ObjectsThatCanBeSaved"]) do
			if v["Type"] == "Window" and GuiLibrary["findObjectInTable"](GuiLibrary["ObjectsThatCanBeSaved"], i) and v["Object"].Visible then
				local sortordernum = (sortordertable[i] or #sorttable)
				sorttable[sortordernum] = v["Object"]
			end
		end
		for i2,v2 in pairs(sorttable) do
			if num > 1697 then
				movedown = true
				num = 6
			end
			v2.Position = UDim2.new(0, num, 0, (movedown and (storedpos[num] and (storedpos[num] + 9) or 400) or 6))
			if not storedpos[num] then
				storedpos[num] = v2.AbsoluteSize.Y
				if v2.Name == "MainWindow" then
					storedpos[num] = 400
				end
			end
			num = num + 223
		end
	end
})
GeneralSettings.CreateButton2({
	["Name"] = "UNINJECT",
	["Function"] = GuiLibrary["SelfDestruct"]
})

loadstring(GetURL("AnyGame.vape"))()
if pcall(function() readfile("vape/CustomModules/"..game.PlaceId..".vape") end) then
	loadstring(readfile("vape/CustomModules/"..game.PlaceId..".vape"))()
else
	local publicrepo = checkpublicrepo(game.PlaceId)
	if publicrepo then
		loadstring(publicrepo)()
	end
end

GuiLibrary["LoadSettings"]()
if #ProfilesTextList["ObjectList"] == 0 then
	table.insert(ProfilesTextList["ObjectList"], "default")
	ProfilesTextList["RefreshValues"](ProfilesTextList["ObjectList"])
end
GUIbind["Reload"]()
GuiLibrary["UpdateUI"]()
if not shared.VapeSwitchServers then
	if blatantmode["Enabled"] then
		pcall(function()
			local frame = GuiLibrary["CreateNotification"]("Blatant Enabled", "Vape is now in Blatant Mode.", 4, "assets/WarningNotification.png")
			frame.Frame.BackgroundColor3 = Color3.fromRGB(236, 129, 44)
			frame.Frame.Frame.BackgroundColor3 = Color3.fromRGB(236, 129, 44)
		end)
	end
	GuiLibrary["LoadedAnimation"](welcomemsg["Enabled"])
else
	shared.VapeSwitchServers = nil
end
if shared.VapeOpenGui then
	GuiLibrary["MainGui"].ScaledGui.ClickGui.Visible = true
	GuiLibrary["MainBlur"].Enabled = true	
	shared.VapeOpenGui = nil
end

spawn(function()
	while wait(10) do
		if not selfdestruct then
			GuiLibrary["SaveSettings"]()
		end
	end
end)