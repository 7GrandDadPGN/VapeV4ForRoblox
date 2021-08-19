repeat wait() until game:IsLoaded() == true

local function GetURL(scripturl)
	if shared.VapeDeveloper then
		return readfile("vape/"..scripturl)
	else
		return game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/"..scripturl, true)
	end
end

local getasset = getsynasset or getcustomasset
local queueteleport = syn and syn.queue_on_teleport or queue_on_teleport
local request = syn and syn.request or http and http.request or http_request
local function getcustomassetfunc(path)
	if not isfile(path) then
		local req = request({
			Url = "https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/"..path:gsub("vape/assets", "assets"),
			Method = "GET"
		})
		writefile(path, req.Body)
	end
	return getasset(path) 
end

local function checkpublicrepo(id)
	local req = request({
		Url = "https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/CustomModules/"..id..".vape",
		Method = "GET"
	})
	if req.StatusCode == 200 then
		return req.Body
	end
	return nil
end

if not (getasset and request and queueteleport) then
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
if isfolder("vape/CustomModules") == false then
	makefolder("vape/CustomModules")
end
if isfolder("vape/Profiles") == false then
	makefolder("vape/Profiles")
end
if isfolder("vape/assets") == false then
	makefolder("vape/assets")
end

local GuiLibrary = loadstring(GetURL("NewGuiLibrary.lua"))()
shared.GuiLibrary = GuiLibrary
local workspace = game:GetService("Workspace")
local cam = workspace.CurrentCamera
local selfdestruct = false
local GUI = GuiLibrary.CreateMainWindow()
local Combat = GuiLibrary.CreateWindow("Combat", "vape/assets/CombatIcon.png", 15, UDim2.new(0, 223, 0, 6), false)
local Blatant = GuiLibrary.CreateWindow("Blatant", "vape/assets/BlatantIcon.png", 16, UDim2.new(0, 223, 0, 6), false)
local Render = GuiLibrary.CreateWindow("Render", "vape/assets/RenderIcon.png", 17, UDim2.new(0, 223, 0, 6), false)
local Utility = GuiLibrary.CreateWindow("Utility", "vape/assets/UtilityIcon.png", 17, UDim2.new(0, 223, 0, 6), false)
local World = GuiLibrary.CreateWindow("World", "vape/assets/WorldIcon.png", 16, UDim2.new(0, 223, 0, 6), false)
local Other = GuiLibrary.CreateWindow("Other", "vape/assets/OtherIcon.png", 20, UDim2.new(0, 223, 0, 6), false)
local Friends = GuiLibrary.CreateWindow2("Friends", "vape/assets/FriendsIcon.png", 17, UDim2.new(0, 177, 0, 6), false)
GUI.CreateDivider()
GUI.CreateButton("Combat", function() Combat.SetVisible(true) end, function() Combat.SetVisible(false) end, "vape/assets/CombatIcon.png", 15)
GUI.CreateButton("Blatant", function() Blatant.SetVisible(true) end, function() Blatant.SetVisible(false) end, "vape/assets/BlatantIcon.png", 16)
GUI.CreateButton("Render", function() Render.SetVisible(true) end, function() Render.SetVisible(false) end, "vape/assets/RenderIcon.png", 17)
GUI.CreateButton("Utility", function() Utility.SetVisible(true) end, function() Utility.SetVisible(false) end, "vape/assets/UtilityIcon.png", 17)
GUI.CreateButton("World", function() World.SetVisible(true) end, function() World.SetVisible(false) end, "vape/assets/WorldIcon.png", 16)
GUI.CreateButton("Other", function() Other.SetVisible(true) end, function() Other.SetVisible(false) end, "vape/assets/OtherIcon.png", 20)
GUI.CreateDivider("MISC")
GUI.CreateButton("Friends", function() Friends.SetVisible(true) end, function() Friends.SetVisible(false) end)
local FriendsTextList = {["RefreshValues"] = function() end}
FriendsTextList = Friends.CreateTextList("FriendsList", "Username / Alias", function(user)
	table.insert(GuiLibrary["FriendsObject"]["Friends"], user)
	FriendsTextList["RefreshValues"](GuiLibrary["FriendsObject"]["Friends"])
	GuiLibrary["SaveFriends"]()
end, function(num) 
	table.remove(GuiLibrary["FriendsObject"]["Friends"], num) 
	FriendsTextList["RefreshValues"](GuiLibrary["FriendsObject"]["Friends"])
	GuiLibrary["SaveFriends"]()
end, function(obj)
	local friendcircle = Instance.new("Frame")
	friendcircle.Size = UDim2.new(0, 10, 0, 10)
	friendcircle.Name = "FriendCircle"
	friendcircle.BackgroundColor3 = Color3.fromHSV(0.44, 1, 1)
	friendcircle.BorderSizePixel = 0
	friendcircle.Position = UDim2.new(0, 10, 0, 13)
	friendcircle.Parent = obj
	local friendcorner = Instance.new("UICorner")
	friendcorner.CornerRadius = UDim.new(0, 8)
	friendcorner.Parent = friendcircle
	obj.ItemText.Position = UDim2.new(0, 36, 0, 0)
	obj.ItemText.Size = UDim2.new(0, 157, 0, 33)
end)
Friends.CreateColorSlider("Friends Color", function(val) 
	GuiLibrary["FriendsObject"]["Color"] = val 
	pcall(function()
		FriendsTextList["Object"].AddBoxBKG.AddButton.ImageColor3 = Color3.fromHSV(GuiLibrary["FriendsObject"]["Color"], 1, 1)
	end)
	for i, v in pairs(FriendsTextList["ScrollingObject"].ScrollingFrame:GetChildren()) do
		pcall(function()
			if v:IsA("Frame") then
				v.FriendCircle.BackgroundColor3 = Color3.fromHSV(GuiLibrary["FriendsObject"]["Color"], 1, 1)
			end
		end)
	end
end)
Friends.CreateToggle("Use Friends", function() end, function() end, false, "")	
Friends.CreateToggle("Use Roblox Friends", function() end, function() end, false, "")
Friends.CreateToggle("Use color", function() end, function() end, false, "")
GuiLibrary["FriendsObject"]["MiddleClickFunc"] = function(user)
	if table.find(GuiLibrary["FriendsObject"]["Friends"], user) == nil then
		table.insert(GuiLibrary["FriendsObject"]["Friends"], user)
		FriendsTextList["RefreshValues"](GuiLibrary["FriendsObject"]["Friends"])
		GuiLibrary["SaveFriends"]()
	else
		table.remove(GuiLibrary["FriendsObject"]["Friends"], table.find(GuiLibrary["FriendsObject"]["Friends"], user)) 
		FriendsTextList["RefreshValues"](GuiLibrary["FriendsObject"]["Friends"])
		GuiLibrary["SaveFriends"]()
	end
end
GUI.CreateDivider()
---GUI.CreateCustomButton("Favorites", "vape/assets/FavoritesListIcon.png", UDim2.new(0, 17, 0, 14), function() end, function() end)
--GUI.CreateCustomButton("Text GUIVertical", "vape/assets/TextGUIIcon3.png", UDim2.new(1, -56, 0, 15), function() end, function() end)
local TextGui = GuiLibrary.CreateCustomWindow("Text GUI", "vape/assets/TextGUIIcon1.png", 21, UDim2.new(0, 177, 0, 6), false)
--GUI.CreateCustomButton("Text GUI", "vape/assets/TextGUIIcon2.png", UDim2.new(1, -23, 0, 15), function() TextGui.SetVisible(true) end, function() TextGui.SetVisible(false) end, "OptionsButton")
GUI.CreateCustomToggle("Text GUI", "vape/assets/TextGUIIcon3.png", function() TextGui.SetVisible(true) end, function() TextGui.SetVisible(false) end, false, "OptionsButton", 2)

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
onething2.Size = UDim2.new(0, 40, 0, 27)
onething2.Name = "Logo2"
onething2.Position = UDim2.new(1, 0, 0, 0)
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
onetext.Font = Enum.Font.Gotham
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
onetext2.Font = Enum.Font.Gotham
onetext2.TextSize = 20
local onetext3 = onetext:Clone()
onetext3.Name = "ExtraText"
onetext3.Position = UDim2.new(0, 0, 0, 0)
onetext3.TextColor3 = Color3.new(0.65, 0.65, 0.65)
onetext3.Parent = onetext
local onetext4 = onetext3.ExtraText
onetext4.TextColor3 = Color3.new(0, 0, 0)
onetext4.TextTransparency = 0.5
onetext3:GetPropertyChangedSignal("Text"):connect(function() onetext4.Text = onetext3.Text end)
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
				table.insert(tableofmodules, {["Text"] = v["Api"]["Name"], ["ExtraText"] = v["Api"]["GetExtraText"]})
			end
		end
	end
	if sortingmethod == "Alphabetical" then
		table.sort(tableofmodules, function(a, b) return a["Text"]:lower() < b["Text"]:lower() end)
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
end

GuiLibrary["UpdateHudEvent"].Event:connect(UpdateHud)

TextGui.CreateToggle("Watermark", function() 
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
end, function() 
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
end)
TextGui.CreateToggle("Shadow", function() onetext2.Visible = true onetext4.Visible = true onething3.Visible = true end, function() onetext2.Visible = false onetext4.Visible = false onething3.Visible = false end)
TextGui.CreateToggle("Render background", function() 
	onething.BackgroundTransparency = 0.5 
	onething2.BackgroundTransparency = 0.5 
	onetext.BackgroundTransparency = 0.5 
end, function() 
	onething.BackgroundTransparency = 1
	onething2.BackgroundTransparency = 1
	onetext.BackgroundTransparency = 1
end)

local TargetInfo = GuiLibrary.CreateCustomWindow("Target Info", "vape/assets/TargetInfoIcon1.png", 16, UDim2.new(0, 177, 0, 6), false)
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
targetname.TextColor3 = Color3.new(1, 1, 1)
targetname.Position = UDim2.new(0, 72, 0, 6)
targetname.BackgroundTransparency = 1
targetname.Size = UDim2.new(0, 80, 0, 14)
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
round3.CornerRadius = UDim.new(0, 4)
round3.Parent = targethealthbkg
local round4 = Instance.new("UICorner")
round4.CornerRadius = UDim.new(0, 4)
round4.Parent = targethealthgreen
local round5 = Instance.new("UICorner")
round5.CornerRadius = UDim.new(0, 4)
round5.Parent = targetimage
TargetInfo.GetCustomChildren().Parent:GetPropertyChangedSignal("Size"):connect(function()
	if TargetInfo.GetCustomChildren().Parent.Size ~= UDim2.new(0, 220, 0, 0) then
		targetinfobkg3.Position = UDim2.new(0, 0, 0, -5)
		targetinfobkg2.BackgroundTransparency = 0
		targetinfobkg1.BackgroundTransparency = 0
	else
		targetinfobkg3.Position = UDim2.new(0, 0, 0, 0)
		targetinfobkg2.BackgroundTransparency = 1
		targetinfobkg1.BackgroundTransparency = 1
	end
end)
shared.VapeTargetInfo = {
	["UpdateInfo"] = function(tab, targetsize)
		targetinfobkg3.Visible = (targetsize > 0) or (TargetInfo.GetCustomChildren().Parent.Size ~= UDim2.new(0, 220, 0, 0))
		for i,v in pairs(tab) do
			targetimage.Image = 'rbxthumb://type=AvatarHeadShot&id='..v["UserId"]..'&w=420&h=420'
			targethealthgreen:TweenSize(UDim2.new(v["Health"] / v["MaxHealth"], 0, 0, 4), Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.05, true)
			targethealth.Text = math.floor(v["Health"]).." hp"
			targetname.Text = i
		end
	end,
	["Object"] = TargetInfo
}
GUI.CreateCustomToggle("Target Info", "vape/assets/TargetInfoIcon2.png", function() TargetInfo.SetVisible(true) end, function() TargetInfo.SetVisible(false) end, false, "OptionsButton", 1)

GUI.CreateDivider2("MODULE SETTINGS")
GUI.CreateToggle("Players", function() end, function() end, true, "")
GUI.CreateToggle("NPCs", function() end, function() end, false, "")
GUI.CreateToggle("Ignore naked", function() end, function() end, false, "")
GUI.CreateToggle("Teams by server", function() end, function() end, false, "")
GUI.CreateToggle("Teams by color", function() end, function() end, true, "")
GUI.CreateToggle("MiddleClick friends", function() GuiLibrary["FriendsObject"]["MiddleClickFriends"] = true end, function() GuiLibrary["FriendsObject"]["MiddleClickFriends"] = false end, false, "")
local blatantmode = GUI.CreateToggle("Blatant mode", function()

end, function()

end, false, "")
GUI.CreateDivider2("GENERAL SETTINGS")
guicolorslider = GUI.CreateColorSlider("GUI Theme", function(val) GuiLibrary["Settings"]["GUIObject"]["Color"] = val GuiLibrary["UpdateUI"]() end)

GuiLibrary["UpdateUI"] = function()
	pcall(function()
		GuiLibrary["ObjectsThatCanBeSaved"]["GUIWindow"]["Object"].Children.Extras.MainButton.ImageColor3 = (GUI["GetVisibleIcons"]() > 0 and Color3.fromHSV(GuiLibrary["Settings"]["GUIObject"]["Color"], 1, 1) or Color3.fromRGB(199, 199, 199))
		GuiLibrary["ObjectsThatCanBeSaved"]["GUIWindow"]["Object"].Logo1.Logo2.ImageColor3 = Color3.fromHSV(GuiLibrary["Settings"]["GUIObject"]["Color"], 1, 1)
		onething.ImageColor3 = Color3.fromHSV(GuiLibrary["Settings"]["GUIObject"]["Color"], 1, 1)
		onetext.TextColor3 = Color3.fromHSV(GuiLibrary["Settings"]["GUIObject"]["Color"], 1, 1)
		local newtext = ""
		local newfirst = false
		for i2,v2 in pairs(textwithoutthing:split("\n")) do
			local rainbowsub = 2
			local rainbowcolor = GuiLibrary["Settings"]["GUIObject"]["Color"] + (-0.015 * i2)
			if rainbowcolor < 0 then rainbowsub = 3 rainbowcolor = rainbowcolor * 0.25 end
			local str = tostring(rainbowcolor)
			local newcol = tonumber("0"..string.sub(str, rainbowsub, string.len(str)))
			local newcolor = Color3.fromHSV(newcol, 1, 1)
			newtext = newtext..(newfirst and "\n" or " ")..'<font color="rgb('..tostring(math.floor(newcolor.R * 255))..","..tostring(math.floor(newcolor.G * 255))..","..tostring(math.floor(newcolor.B * 255))..')">'..v2..'</font>'
			newfirst = true
		end
		onetext.Text = newtext
		for i,v in pairs(GuiLibrary["ObjectsThatCanBeSaved"]) do
			if v["Type"] == "Button" and v["Api"]["Enabled"] then
				v["Object"].ButtonText.TextColor3 = Color3.fromHSV(GuiLibrary["Settings"]["GUIObject"]["Color"], 1, 1)
				if v["Object"]:FindFirstChild("ButtonIcon") then
					v["Object"].ButtonIcon.ImageColor3 = Color3.fromHSV(GuiLibrary["Settings"]["GUIObject"]["Color"], 1, 1)
				end
			end
			if v["Type"] == "OptionsButton" then
				if v["Api"]["Enabled"] then
					v["Object"].BackgroundColor3 = Color3.fromHSV(GuiLibrary["Settings"]["GUIObject"]["Color"], 1, 1)
				end
			end
			if v["Type"] == "ExtrasButton" then
				if v["Api"]["Enabled"] then
					v["Object"].ImageColor3 = Color3.fromHSV(GuiLibrary["Settings"]["GUIObject"]["Color"], 1, 1)
				end
			end
			if v["Type"] == "Toggle" and v["Api"]["Enabled"] then
					v["Object"].ToggleFrame1.BackgroundColor3 = Color3.fromHSV(GuiLibrary["Settings"]["GUIObject"]["Color"], 1, 1)
			end
			if v["Type"] == "Slider" then
				v["Object"].Slider.FillSlider.BackgroundColor3 = Color3.fromHSV(GuiLibrary["Settings"]["GUIObject"]["Color"], 1, 1)
				v["Object"].Slider.FillSlider.ButtonSlider.ImageColor3 = Color3.fromHSV(GuiLibrary["Settings"]["GUIObject"]["Color"], 1, 1)
			end
			if v["Type"] == "TwoSlider" then
				v["Object"].Slider.FillSlider.BackgroundColor3 = Color3.fromHSV(GuiLibrary["Settings"]["GUIObject"]["Color"], 1, 1)
				v["Object"].Slider.ButtonSlider.ImageColor3 = Color3.fromHSV(GuiLibrary["Settings"]["GUIObject"]["Color"], 1, 1)
				v["Object"].Slider.ButtonSlider2.ImageColor3 = Color3.fromHSV(GuiLibrary["Settings"]["GUIObject"]["Color"], 1, 1)
			end
		end
	end)
end

GUI.CreateToggle("Auto-load module states", function() end, function() end, false, "VapeOptions")
GUI.CreateToggle("Blur Background", function() GuiLibrary["MainBlur"].Size = 25 end, function() GuiLibrary["MainBlur"].Size = 0 end, true, "VapeOptions")
local rescale = GUI.CreateToggle("Rescale", function() 
	GuiLibrary["MainRescale"].Scale = cam.ViewportSize.X / 1920
end, function()
	GuiLibrary["MainRescale"].Scale = 1 
end, true, "VapeOptions")
cam:GetPropertyChangedSignal("ViewportSize"):connect(function()
	if rescale["Enabled"] then
		GuiLibrary["MainRescale"].Scale = cam.ViewportSize.X / 1920
	end
end)
GUI.CreateToggle("Enable Multi-Keybinding", function() end, function() end, false, "VapeOptions")
local welcomemsg = GUI.CreateToggle("GUI bind indicator", function() end, function() end, true, "VapeOptions")
GUI.CreateToggle("Smooth font", function()
	for i,v in pairs(GuiLibrary["MainGui"]:GetDescendants()) do
		if (v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("TextBox")) then
			v.Font = Enum.Font.SourceSans
			if v.Name == "DividerLabel" then
				local string1 = v.Text:sub(2, v.Text:len())
				v.Text = "  "..string1
			end
		end
	end
	for i2,v2 in pairs(GuiLibrary["ObjectsThatCanBeSaved"]) do
		if v2["Type"] == "Toggle" then
			v2["Object"].Text = "   "..v2["Object"].Name
			v2["Object"].TextSize = 18
		end
	end
end, function() 
	for i,v in pairs(GuiLibrary["MainGui"]:GetDescendants()) do
		if (v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("TextBox")) then
			v.Font = Enum.Font.Sarpanch
			if v.Name == "DividerLabel" then
				local string1 = v.Text:sub(3, v.Text:len())
				v.Text = " "..string1
			end
		end
	end
	for i2,v2 in pairs(GuiLibrary["ObjectsThatCanBeSaved"]) do
		if v2["Type"] == "Toggle" then
			v2["Object"].Text = "   "..v2["Object"].Name
			v2["Object"].TextSize = 16
		end
	end
end, true, "VapeOptions")
GUI.CreateToggle("Show Tooltips", function() GuiLibrary["ToggleTooltips"] = true end, function() GuiLibrary["ToggleTooltips"] = false end, true, "VapeOptions")
GUI.CreateToggle("Discord integration", function() end, function() end, false, "VapeOptions")
GUI.CreateToggle("Notifications", function() GuiLibrary["ToggleNotifications"] = true end, function() GuiLibrary["ToggleNotifications"] = false end, true, "VapeOptions")

local teleportfunc = game:GetService("Players").LocalPlayer.OnTeleport:Connect(function(State)
    if State == Enum.TeleportState.Started then
        queueteleport('shared.VapeSwitchServers = true if shared.VapeDeveloper then loadstring(readfile("vape/NewMainScript.lua"))() else loadstring(game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/NewMainScript.lua", true))() end')
    end
end)

local SelfDestructButton = {["ToggleButton"] = function() end}
SelfDestructButton = Other.CreateOptionsButton("SelfDestruct", function() 
	selfdestruct = true
	SelfDestructButton["ToggleButton"](false)
	GuiLibrary["SaveSettings"]()
	GuiLibrary["SaveFriends"]()
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
	teleportfunc:Disconnect()
	GuiLibrary["MainGui"]:Remove()
	GuiLibrary["MainBlur"]:Remove()
end, function() end, false)

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
GuiLibrary["LoadFriends"]()
FriendsTextList["RefreshValues"](GuiLibrary["FriendsObject"]["Friends"])
GuiLibrary["UpdateUI"]()
if blatantmode["Enabled"] then
	pcall(function()
		local frame = GuiLibrary["CreateNotification"]("Blatant Enabled", "Vape is now in Blatant Mode.", 4, "⚠️")
		frame.Frame.BackgroundColor3 = Color3.fromRGB(218, 134, 75)
		frame.Frame.Frame.BackgroundColor3 = Color3.fromRGB(218, 134, 75)
	end)
end
if not shared.VapeSwitchServers then
	GuiLibrary["LoadedAnimation"](welcomemsg["Enabled"])
else
	shared.VapeSwitchServers = nil
end

spawn(function()
	while wait(10) do
		if not selfdestruct then
			GuiLibrary["SaveSettings"]()
		end
	end
end)