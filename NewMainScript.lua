if shared.VapeExecuted then
	error("Vape Already Injected")
	return
else
	shared.VapeExecuted = true
end

local function GetURL(scripturl)
	if shared.VapeDeveloper then
		return readfile("vape/"..scripturl)
	else
		return game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/"..scripturl, true)
	end
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
GUI.CreateDivider()
GUI.CreateButton("Combat", function() Combat.SetVisible(true) end, function() Combat.SetVisible(false) end, "vape/assets/CombatIcon.png", 15)
GUI.CreateButton("Blatant", function() Blatant.SetVisible(true) end, function() Blatant.SetVisible(false) end, "vape/assets/BlatantIcon.png", 16)
GUI.CreateButton("Render", function() Render.SetVisible(true) end, function() Render.SetVisible(false) end, "vape/assets/RenderIcon.png", 17)
GUI.CreateButton("Utility", function() Utility.SetVisible(true) end, function() Utility.SetVisible(false) end, "vape/assets/UtilityIcon.png", 17)
GUI.CreateButton("World", function() World.SetVisible(true) end, function() World.SetVisible(false) end, "vape/assets/WorldIcon.png", 16)
GUI.CreateButton("Other", function() Other.SetVisible(true) end, function() Other.SetVisible(false) end, "vape/assets/OtherIcon.png", 20)
GUI.CreateDivider("MISC")
GUI.CreateButton("Friends", function() end, function() end)
GUI.CreateDivider()
GUI.CreateCustomButton("Favorites", "vape/assets/FavoritesListIcon.png", UDim2.new(0, 17, 0, 14), function() end, function() end)
GUI.CreateCustomButton("Text GUIVertical", "vape/assets/TextGUIIcon3.png", UDim2.new(1, -56, 0, 15), function() end, function() end)
local TextGui = GuiLibrary.CreateCustomWindow("Text GUI", "vape/assets/TextGUIIcon1.png", 21, UDim2.new(0, 177, 0, 6), false)
GUI.CreateCustomButton("Text GUI", "vape/assets/TextGUIIcon2.png", UDim2.new(1, -23, 0, 15), function() TextGui.SetVisible(true) end, function() TextGui.SetVisible(false) end, "OptionsButton")

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
onething.Image = getsynasset("vape/assets/VapeLogo3.png")
local onething2 = Instance.new("ImageLabel")
onething2.Parent = onething
onething2.Size = UDim2.new(0, 40, 0, 27)
onething2.Name = "Logo2"
onething2.Position = UDim2.new(1, 0, 0, 0)
onething2.BorderSizePixel = 0
onething2.BackgroundColor3 = Color3.new(0, 0, 0)
onething2.BackgroundTransparency = 1
onething2.Image = getsynasset("vape/assets/VapeLogo4.png")
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

GUI.CreateDivider2("MODULE SETTINGS")
GUI.CreateToggle("Players", function() end, function() end, false, "")
GUI.CreateToggle("NPCs", function() end, function() end, false, "")
GUI.CreateToggle("Ignore naked", function() end, function() end, false, "")
GUI.CreateToggle("Teams by server", function() end, function() end, false, "")
GUI.CreateToggle("Teams by color", function() end, function() end, false, "")
GUI.CreateToggle("MiddleClick friends", function() GuiLibrary["FriendsObject"]["MiddleClickFriends"] = true end, function() GuiLibrary["FriendsObject"]["MiddleClickFriends"] = false end, false, "")
GUI.CreateToggle("Blatant mode", function() end, function() end, false, "")
GUI.CreateToggle("Use Friends", function() end, function() end, false, "")
GUI.CreateToggle("Use color", function() end, function() end, false, "")
GUI.CreateDivider2("GENERAL SETTINGS")
guicolorslider = GUI.CreateColorSlider("GUI Theme", function(val) GuiLibrary["Settings"]["GUIObject"]["Color"] = val GuiLibrary["UpdateUI"]() end)

GuiLibrary["UpdateUI"] = function()
	pcall(function()
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
		if (v:IsA("TextLabel") or v:IsA("TextButton")) then
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
		if (v:IsA("TextLabel") or v:IsA("TextButton")) then
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
GUI.CreateToggle("Show Tooltips", function() end, function() end, true, "VapeOptions")
GUI.CreateToggle("Discord integration", function() end, function() end, false, "VapeOptions")
GUI.CreateToggle("Notifications", function() end, function() end, true, "VapeOptions")

local XrayAdd
local Xray = GuiLibrary["ObjectsThatCanBeSaved"]["WorldWindow"]["Api"].CreateOptionsButton("Xray", function() 
	XrayAdd = workspace.DescendantAdded:connect(function(v)
		if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") and not v.Parent.Parent:FindFirstChild("Humanoid") then
			v.LocalTransparencyModifier = 0.5
		end
	end)
	for i, v in pairs(workspace:GetDescendants()) do
		if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") and not v.Parent.Parent:FindFirstChild("Humanoid") then
			v.LocalTransparencyModifier = 0.5
		end
	end
end, function()
	for i, v in pairs(workspace:GetDescendants()) do
		if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") and not v.Parent.Parent:FindFirstChild("Humanoid") then
			v.LocalTransparencyModifier = 0
		end
	end
	XrayAdd:Disconnect()
end, false)

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
	shared.GuiLibrary = nil
	GuiLibrary["KeyInputHandler"]:Disconnect()
	GuiLibrary["KeyInputHandler2"]:Disconnect()
	GuiLibrary["MainGui"]:Remove()
	GuiLibrary["MainBlur"]:Remove()
end, function() end, false)

if pcall(function() readfile("vape/CustomModules/"..game.PlaceId..".vape") end) then
	loadstring(readfile("vape/CustomModules/"..game.PlaceId..".vape"))()
else
	loadstring(GetURL("AnyGame.vape"))()
end

GuiLibrary["LoadSettings"]()
GuiLibrary["LoadFriends"]()
GuiLibrary["UpdateUI"]()
GuiLibrary["LoadedAnimation"](welcomemsg["Enabled"])

spawn(function()
	while wait(10) do
		if not selfdestruct then
			GuiLibrary["SaveSettings"]()
		end
	end
end)