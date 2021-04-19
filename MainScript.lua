if shared.VapeExecuted then
	return
else
	shared.VapeExecuted = true
end

local function GetURL(scripturl)
	if shared.VapeDeveloper then
		return readfile("vape/"..scripturl)
	else
		return game:HttpGet("https://github.com/7GrandDadPGN/VapeV4ForRoblox/"..scripturl, true)
	end
end

local GuiLibrary = loadstring(GetURL("GuiLibrary.lua"))()
shared.GuiLibrary = GuiLibrary
local workspace = game:GetService("Workspace")
local cam = workspace.CurrentCamera
local selfdestruct = false
local GUI = GuiLibrary.CreateWindow("GUI", "🖥", UDim2.new(0, 6, 0, 6), true)
local Combat = GuiLibrary.CreateWindow("Combat", "⚔", UDim2.new(0, 177, 0, 6), false)
local Blatant = GuiLibrary.CreateWindow("Blatant", "⚠", UDim2.new(0, 177, 0, 6), false)
local Render = GuiLibrary.CreateWindow("Render", "👁", UDim2.new(0, 177, 0, 6), false)
local Utility = GuiLibrary.CreateWindow("Utility", "🛠", UDim2.new(0, 177, 0, 6), false)
local World = GuiLibrary.CreateWindow("World", "🌎", UDim2.new(0, 177, 0, 6), false)
local Other = GuiLibrary.CreateWindow("Other", "❔", UDim2.new(0, 177, 0, 6), false)
local Settings = GuiLibrary.CreateWindow("Settings", "⚙", UDim2.new(0, 177, 0, 6), false)
local Friends = GuiLibrary.CreateWindow("Friends", "👨‍👦", UDim2.new(0, 177, 0, 6), false)
local TextGui = GuiLibrary.CreateCustomWindow("Text GUI", "📄", UDim2.new(0, 177, 0, 6), false)

local rainbowval = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 0, 1)), ColorSequenceKeypoint.new(1, Color3.fromHSV(0, 0, 1))})
local rainbowval2 = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 0, 0.42)), ColorSequenceKeypoint.new(1, Color3.fromHSV(0, 0, 0.42))})
local guicolorslider = {["RainbowValue"] = false}
spawn(function()
	local counter = 0
	local w = math.pi / 12
	local CS = {}
	local CS2 = {}
	--3
	local num = 4 
	local frames = 0
	repeat
		wait()
		if guicolorslider["RainbowValue"] then
			if math.fmod(frames, 2) == 0 then
				for i = 0, num do
					local c = Color3.fromRGB(127 * math.sin(w*i + counter) + 128, 127 * math.sin(w*i + 2 * math.pi/3 + counter) + 128, 127*math.sin(w*i + 4*math.pi/3 + counter) + 128)
					table.insert(CS, i+1, ColorSequenceKeypoint.new(i/num, c))
					local h, s, v = c:ToHSV()
					table.insert(CS2, i+1, ColorSequenceKeypoint.new(i/num, Color3.fromHSV(h, s, 0.42)))
				end
				rainbowval = ColorSequence.new(CS)
				rainbowval2 = ColorSequence.new(CS2)
				pcall(function()
					TextGui.GetCustomChildren().Logo.Gradient.Color = rainbowval
					TextGui.GetCustomChildren().Logo.ImageLabel.Gradient.Color = rainbowval
					TextGui.GetCustomChildren().TextLabel.Gradient.Color = rainbowval
					TextGui.GetCustomChildren().TextLabel.TextLabel.Gradient.Color = rainbowval2
				end)
				CS = {}
				CS2 = {}
				counter = counter + math.pi/40
				if (counter >= math.pi * 2) then
					counter = 0
				end
			end
			if frames >= 1000 then
				frames = 0
			end
			frames = frames + 2
		end
	until selfdestruct
end)

local onething = Instance.new("ImageLabel")
onething.Parent = TextGui.GetCustomChildren()
onething.Name = "Logo"
onething.Size = UDim2.new(0, 77, 0, 32)
onething.Position = UDim2.new(1, -154, 0, 3)
onething.BackgroundColor3 = Color3.new(0, 0, 0)
onething.BorderSizePixel = 0
onething.BackgroundTransparency = 1
onething.Visible = false
onething.Image = "http://www.roblox.com/asset/?id=5093061259"
local onething2 = Instance.new("ImageLabel")
onething2.Parent = onething
onething2.Size = UDim2.new(0, 77, 0, 32)
onething2.Position = UDim2.new(1, 0, 0, 0)
onething2.BorderSizePixel = 0
onething2.BackgroundColor3 = Color3.new(0, 0, 0)
onething2.BackgroundTransparency = 1
onething2.Image = "http://www.roblox.com/asset/?id=5093114878"
local onetext = Instance.new("TextLabel")
onetext.Parent = TextGui.GetCustomChildren()
onetext.Size = UDim2.new(1, 0, 1, 0)
onetext.Position = UDim2.new(1, -154, 0, 35)
onetext.TextColor3 = Color3.new(1, 1, 1)
onetext.BackgroundTransparency = 1
onetext.TextXAlignment = Enum.TextXAlignment.Left
onetext.TextYAlignment = Enum.TextYAlignment.Top
onetext.BorderSizePixel = 0
onetext.BackgroundColor3 = Color3.new(0, 0, 0)
onetext.Font = Enum.Font.SourceSans
onetext.Text = ""
onetext.TextSize = 20
local onetext2 = Instance.new("TextLabel")
onetext2.Parent = onetext
onetext2.Size = UDim2.new(1, 0, 1, 0)
onetext2.Position = UDim2.new(0, 1, 0, 1)
onetext2.BorderSizePixel = 0
onetext2.Visible = false
onetext2.ZIndex = 0
onetext2.Text = ""
onetext2.BackgroundTransparency = 1
onetext2.TextXAlignment = Enum.TextXAlignment.Left
onetext2.TextYAlignment = Enum.TextYAlignment.Top
onetext2.TextColor3 = Color3.new(1, 1, 1)
onetext2.Font = Enum.Font.SourceSans
onetext:GetPropertyChangedSignal("Text"):connect(function() onetext2.Text = onetext.Text end)
onetext2.TextSize = 20
for i2,v2 in pairs(TextGui.GetCustomChildren():GetDescendants()) do
	local gradient = Instance.new("UIGradient")
	gradient.Rotation = 270
	gradient.Name = "Gradient"
	gradient.Parent = v2
end
onetext.Gradient.Offset = Vector2.new(0, -32)
onetext2.Gradient.Offset = Vector2.new(0, -32)
TextGui.GetCustomChildren().Parent:GetPropertyChangedSignal("Position"):connect(function()
	if (TextGui.GetCustomChildren().Parent.Position.X.Offset + TextGui.GetCustomChildren().Parent.Size.X.Offset / 2) >= (cam.ViewportSize.X / 2) then
		onetext.TextXAlignment = Enum.TextXAlignment.Right
		onetext2.TextXAlignment = Enum.TextXAlignment.Right
		onething.Position = UDim2.new(1, -154, 0, 3)
		onetext.Position = UDim2.new(1, -154, 0, (onething.Visible and 35 or 3))
	else
		onetext.TextXAlignment = Enum.TextXAlignment.Left
		onetext2.TextXAlignment = Enum.TextXAlignment.Left
		onething.Position = UDim2.new(0, 3, 0, 3)
		onetext.Position = UDim2.new(0, 3, 0, (onething.Visible and 35 or 3))
	end
end)

local sortingmethod = "Alphabetical"
local function UpdateHud()
	local text = ""
	local tableofmodules = {}
	local first = true
	
	for i,v in pairs(GuiLibrary["ObjectsThatCanBeSaved"]) do
		if v["Type"] == "OptionsButton" and v["Api"]["Name"] ~= "Text GUI" then
			if v["Api"]["Enabled"] then
				table.insert(tableofmodules, v["Api"]["Name"])
			end
		end
	end
	if sortingmethod == "Alphabetical" then
		table.sort(tableofmodules, function(a, b) return a:lower() < b:lower() end)
	end
	for i2,v2 in pairs(tableofmodules) do
		if first then
			text = v2
			first = false
		else
			text = text..'\n'..v2
		end
	end
	onetext.Text = text
	local newsize = game:GetService("TextService"):GetTextSize(text, onetext.TextSize, onetext.Font, Vector2.new(1000000, 1000000))
	onetext.Size = UDim2.new(0, 154, 0, newsize.Y)
	if (TextGui.GetCustomChildren().Parent.Position.X.Offset + TextGui.GetCustomChildren().Parent.Size.X.Offset / 2) >= (cam.ViewportSize.X / 2) then
		onetext.TextXAlignment = Enum.TextXAlignment.Right
		onetext2.TextXAlignment = Enum.TextXAlignment.Right
		onething.Position = UDim2.new(1, -154, 0, 3)
		onetext.Position = UDim2.new(1, -154, 0, (onething.Visible and 35 or 3))
	else
		onetext.TextXAlignment = Enum.TextXAlignment.Left
		onetext2.TextXAlignment = Enum.TextXAlignment.Left
		onething.Position = UDim2.new(0, 3, 0, 3)
		onetext.Position = UDim2.new(0, 3, 0, (onething.Visible and 35 or 3))
	end
end

GuiLibrary["UpdateHudEvent"].Event:connect(UpdateHud)


GUI.CreateButton("Combat", function() Combat.SetVisible(true) end, function() Combat.SetVisible(false) end)
GUI.CreateButton("Blatant", function() Blatant.SetVisible(true) end, function() Blatant.SetVisible(false) end)
GUI.CreateButton("Render", function() Render.SetVisible(true) end, function() Render.SetVisible(false) end)
GUI.CreateButton("Utility", function() Utility.SetVisible(true) end, function() Utility.SetVisible(false) end)
GUI.CreateButton("World", function() World.SetVisible(true) end, function() World.SetVisible(false) end)
GUI.CreateButton("Other", function() Other.SetVisible(true) end, function() Other.SetVisible(false) end)
GUI.CreateButton("Settings", function() Settings.SetVisible(true) end, function() Settings.SetVisible(false) end)
GUI.CreateButton("Friends", function() Friends.SetVisible(true) end, function() Friends.SetVisible(false) end)
Friends.CreateColorSlider("Friends Color", function(val) GuiLibrary["FriendsObject"]["Color"] = val end)
Friends.CreateToggle("Use color", function() end, function() end)
Friends.CreateToggle("Use Friends", function() end, function() end)	
local FriendsTextList = {["RefreshValues"] = function() end}
FriendsTextList = Friends.CreateTextList("FriendList", "<username>", function(user)
	table.insert(GuiLibrary["FriendsObject"]["Friends"], user)
	FriendsTextList["RefreshValues"](GuiLibrary["FriendsObject"]["Friends"])
	GuiLibrary["SaveFriends"]()
end, function(num) 
	table.remove(GuiLibrary["FriendsObject"]["Friends"], num) 
	FriendsTextList["RefreshValues"](GuiLibrary["FriendsObject"]["Friends"])
	GuiLibrary["SaveFriends"]()
end)
local TextGUI = GUI.CreateOptionsButton("Text GUI", function() TextGui.SetVisible(true) end, function() TextGui.SetVisible(false) end, true)
TextGUI.CreateDropdown("Mode", {"Alphabetical", "Random"}, function(val) sortingmethod = val UpdateHud() end)
TextGUI.CreateToggle("Watermark", function() onething.Visible = true onetext.Position = UDim2.new(0, 0, 0, 35) end, function() onething.Visible = false onetext.Position = UDim2.new(0, 0, 0, 0) end)
TextGUI.CreateToggle("Shadow", function() onetext2.Visible = true end, function() onetext2.Visible = false end)
TextGUI.CreateToggle("Render background", function() 
	onething.BackgroundTransparency = 0.5 
	onething2.BackgroundTransparency = 0.5 
	onetext.BackgroundTransparency = 0.5 
end, function() 
	onething.BackgroundTransparency = 1
	onething2.BackgroundTransparency = 1
	onetext.BackgroundTransparency = 1
end)
local SelfDestructButton = {["ToggleButton"] = function() end}
Other.CreateOptionsButton("Anti-AFK", function()
	local GC = getconnections or get_signal_cons
	if GC then
		for i,v in pairs(GC(game.Players.LocalPlayer.Idled)) do
			if v["Disable"] then
				v["Disable"](v)
			elseif v["Disconnect"] then
				v["Disconnect"](v)
			end
		end
	end
end, function() end, false)
SelfDestructButton = Other.CreateOptionsButton("SelfDestruct", function() 
	selfdestruct = true
	SelfDestructButton["ToggleButton"](false)
	GuiLibrary["SaveSettings"]()
	for i,v in pairs(GuiLibrary["ObjectsThatCanBeSaved"]) do
		if (v["Type"] == "Button" or v["Type"] == "OptionsButton") and v["Api"]["Enabled"] then
			v["Api"]["ToggleButton"](false)
		end
	end
	shared.VapeExecuted = nil
	GuiLibrary["KeyInputHandler"]:Disconnect()
	GuiLibrary["KeyInputHandler2"]:Disconnect()
	GuiLibrary["MainGui"]:Remove()
	GuiLibrary["MainBlur"]:Remove()
end, function() end, false)
SelfDestructButton["Bindable"] = false

guicolorslider = Settings.CreateColorSlider("Gui Color", function(val) GuiLibrary["Settings"]["GUIObject"]["Color"] = val GuiLibrary["UpdateUI"]() end)
GuiLibrary["UpdateUI"] = function()
	pcall(function()
		if not guicolorslider["RainbowValue"] then
			onething.Gradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHSV(GuiLibrary["Settings"]["GUIObject"]["Color"], 1, 1)), ColorSequenceKeypoint.new(1, Color3.fromHSV(GuiLibrary["Settings"]["GUIObject"]["Color"], 1, 1))})
			onething2.Gradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHSV(GuiLibrary["Settings"]["GUIObject"]["Color"], 1, 1)), ColorSequenceKeypoint.new(1, Color3.fromHSV(GuiLibrary["Settings"]["GUIObject"]["Color"], 1, 1))})
			onetext.Gradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHSV(GuiLibrary["Settings"]["GUIObject"]["Color"], 1, 1)), ColorSequenceKeypoint.new(1, Color3.fromHSV(GuiLibrary["Settings"]["GUIObject"]["Color"], 1, 1))})
			onetext2.Gradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHSV(GuiLibrary["Settings"]["GUIObject"]["Color"], 1, 0.42)), ColorSequenceKeypoint.new(1, Color3.fromHSV(GuiLibrary["Settings"]["GUIObject"]["Color"], 1, 0.42))})
		end
		for i,v in pairs(GuiLibrary["ObjectsThatCanBeSaved"]) do
			if v["Type"] == "Button" and v["Api"]["Enabled"] then
				v["Object"].BackgroundColor3 = Color3.fromHSV(GuiLibrary["Settings"]["GUIObject"]["Color"], 1, 1)
				v["Object"].TextColor3 = GuiLibrary["Settings"]["GUIObject"]["Color"] < 0.5 and Color3.new(0, 0, 0) or Color3.fromRGB(255, 255, 255)
			end
			if v["Type"] == "OptionsButton" then
				if v["Api"]["Enabled"] then
					v["Object"].BackgroundColor3 = Color3.fromHSV(GuiLibrary["Settings"]["GUIObject"]["Color"], 1, 1)
					v["Object"].TextColor3 = GuiLibrary["Settings"]["GUIObject"]["Color"] < 0.5 and Color3.new(0, 0, 0) or Color3.new(1, 1, 1)
				end
			end
			if (v["Type"] == "Toggle" or v["Type"] == "NewToggle") and v["Api"]["Enabled"] then
				v["Object"].BackgroundColor3 = Color3.fromHSV(GuiLibrary["Settings"]["GUIObject"]["Color"], 1, 1)
			end
			if v["Type"] == "Slider" then
				v["Object"].Slider.FillSlider.BackgroundColor3 = Color3.fromHSV(GuiLibrary["Settings"]["GUIObject"]["Color"], 1, 1)
			end
		end
	end)
end

local playertoggle = Settings.CreateToggle("Players", function() end, function() end)
local npctoggle = Settings.CreateToggle("NPCs", function() end, function() end)
local nakedtoggle = Settings.CreateToggle("Ignore naked", function() end, function() end)
local teamsbyservertoggle = Settings.CreateToggle("Teams by server", function() end, function() end)
local teamsbycolortoggle = Settings.CreateToggle("Teams by color", function() end, function() end)
local middleclickfriendstoggle = Settings.CreateToggle("MiddleClick friends", function() end, function() end)
local blatanttoggle = Settings.CreateToggle("Blatant mode", function() end, function() end)

if isfolder("vape") == false then
	makefolder("vape")
end
if isfolder("vape/CustomModules") == false then
	makefolder("vape/CustomModules")
end
if isfolder("vape/Profiles") == false then
	makefolder("vape/Profiles")
end

if pcall(function() readfile("vape/CustomModules/"..game.PlaceId..".vape") end) then
	loadstring(readfile("vape/CustomModules/"..game.PlaceId..".vape"))()
else
	loadstring(GetURL("AnyGame.vape"))()
end

GuiLibrary["LoadSettings"]()
GuiLibrary["LoadFriends"]()
FriendsTextList["RefreshValues"](GuiLibrary["FriendsObject"]["Friends"])
GuiLibrary["UpdateUI"]()
GuiLibrary["LoadedAnimation"]()

spawn(function()
	while wait(10) do
		if not selfdestruct then
			GuiLibrary["SaveSettings"]()
		end
	end
end)