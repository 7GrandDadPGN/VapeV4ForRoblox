local VERSION = "v4.00"
local rainbowvalue = 0
local cam = game:GetService("Workspace").CurrentCamera
local mouse = game:GetService("Players").LocalPlayer:GetMouse()
local api = {
	["Settings"] = {["GUIObject"] = {["Type"] = "Custom", ["GUIKeybind"] = "RightShift", ["BlatantMode"] = false, ["Color"] = 0.44}, ["SearchObject"] = {["Type"] = "Custom", ["List"] = {}}},
	["FriendsObject"] = {["Color"] = 0.44, ["Friends"] = {}, ["MiddleClickFriends"] = false, ["MiddleClickFunc"] = function(plr) end},
	["ObjectsThatCanBeSaved"] = {},
}

coroutine.resume(coroutine.create(function()
	repeat
		for i = 0, 1, 0.01 do
			wait(0.01)
			rainbowvalue = i
		end
	until true == false
end))

local holdingshift = false
local captured = false
local pressedkey = ""
local capturedslider = nil

local function randomString()
	local randomlength = math.random(10,100)
	local array = {}

	for i = 1, randomlength do
		array[i] = string.char(math.random(32, 126))
	end

	return table.concat(array)
end

api["findObjectInTable"] = function(temp, object)
    for i,v in pairs(temp) do
        if i == object or v == object then
            return true
        end
    end
    return false
end

local function RelativeXY(GuiObject, location)
	local x, y = location.X - GuiObject.AbsolutePosition.X, location.Y - GuiObject.AbsolutePosition.Y
	local xm, ym = GuiObject.AbsoluteSize.X, GuiObject.AbsoluteSize.Y
	x = math.clamp(x, 0, xm)
	y = math.clamp(y, 0, ym)
	return x, y, x/xm, y/ym
end

local function dragGUI(gui)
	spawn(function()
		local dragging
		local dragInput
		local dragStart = Vector3.new(0,0,0)
		local startPos
		local function update(input)
			local delta = input.Position - dragStart
			local Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			game:GetService("TweenService"):Create(gui, TweenInfo.new(.20), {Position = Position}):Play()
		end
		gui.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch and dragging == false then
				dragging = true
				dragStart = input.Position
				startPos = gui.Position
				
				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
					end
				end)
			end
		end)
		gui.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				dragInput = input
			end
		end)
		game:GetService("UserInputService").InputChanged:Connect(function(input)
			if input == dragInput and dragging then
				update(input)
			end
		end)
	end)
end

if not game:IsLoaded() then
    game.Loaded:Wait()
end

if not is_sirhurt_closure and syn and syn.protect_gui then
    local gui = Instance.new("ScreenGui")
    gui.Name = randomString()
    gui.DisplayOrder = 999
    syn.protect_gui(gui)
    gui.Parent = game:GetService("CoreGui")
    api["MainGui"] = gui
	shared.gui = gui
elseif PROTOSMASHER_LOADED and get_hidden_gui then
    local gui = Instance.new("ScreenGui")
    gui.Name = randomString()
    gui.DisplayOrder = 999
    gui.Parent = get_hidden_gui()
    api["MainGui"] = gui
elseif elysianexecute and gethui then
    local gui = Instance.new("ScreenGui")
    gui.Name = randomString()
    gui.DisplayOrder = 999
    gui.Parent = gethui()
    api["MainGui"] = gui
elseif game:GetService("CoreGui"):FindFirstChild('RobloxGui') then
    api["MainGui"] = game:GetService("CoreGui").RobloxGui
else
    local gui = Instance.new("ScreenGui")
    gui.Name = randomString()
    gui.DisplayOrder = 999
    gui.Parent = game:GetService("ScreenGui")
    api["MainGui"] = gui
end

api["UpdateHudEvent"] = Instance.new("BindableEvent")

local clickgui = Instance.new("Frame")
clickgui.Name = "ClickGui"
clickgui.Size = UDim2.new(1, 0, 1, 0)
clickgui.BackgroundTransparency = 1
clickgui.Visible = false
clickgui.Parent = api["MainGui"]
local vertext = Instance.new("TextLabel")
vertext.Name = "Version"
vertext.Size = UDim2.new(0, 100, 0, 20)
vertext.Font = Enum.Font.SourceSans
vertext.TextColor3 = Color3.new(1, 1, 1)
vertext.Active = false
vertext.TextSize = 25
vertext.BackgroundTransparency = 1
vertext.Text = VERSION
vertext.TextXAlignment = Enum.TextXAlignment.Right
vertext.TextYAlignment = Enum.TextYAlignment.Bottom
vertext.Position = UDim2.new(1, -105, 1, -25)
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
local topbar = Instance.new("Frame")
topbar.Size = UDim2.new(0, 180, 0, 40)
topbar.Position = UDim2.new(0.5, -90, 0, -36)
topbar.BackgroundColor3 = Color3.fromRGB(36, 39, 43)
topbar.BorderSizePixel = 0
topbar.ZIndex = -1
topbar.Name = "TopBar"
topbar.Parent = clickgui
local vapelogoL = Instance.new("ImageLabel")
vapelogoL.Size = UDim2.new(0, 46, 0, 25)
vapelogoL.Position = UDim2.new(0, 11, 0, 8)
vapelogoL.BackgroundTransparency = 1
vapelogoL.Image = "http://www.roblox.com/asset/?id=6083846452"
vapelogoL.Name = "VapeLogoLeft"
vapelogoL.Parent = topbar
local vapelogoR = Instance.new("ImageLabel")
vapelogoR.Size = UDim2.new(0, 46, 0, 25)
vapelogoR.Position = UDim2.new(0, 57, 0, 8)
vapelogoR.BackgroundTransparency = 1
vapelogoR.Image = "http://www.roblox.com/asset/?id=6083888864"
vapelogoR.Name = "VapeLogoRight"
vapelogoR.Parent = topbar
local vapelogoC = Instance.new("Frame")
vapelogoC.Size = UDim2.new(0, 4, 0, 12)
vapelogoC.Position = UDim2.new(0, 57, 0, 8)
vapelogoC.BackgroundColor3 = Color3.fromRGB(36, 39, 43)
vapelogoC.BorderSizePixel = 0
vapelogoC.Name = "VapeLogoCoverup"
vapelogoC.ZIndex = 2
vapelogoC.Parent = topbar
local vapeoptionsbutton = Instance.new("TextButton")
vapeoptionsbutton.AutoButtonColor = false
vapeoptionsbutton.BorderSizePixel = 0
vapeoptionsbutton.Position = UDim2.new(0, 108, 0, 4)
vapeoptionsbutton.BackgroundColor3 = Color3.fromRGB(15, 20, 26)
vapeoptionsbutton.TextSize = 26
vapeoptionsbutton.Font = Enum.Font.SourceSans
vapeoptionsbutton.Text = "⚙"
vapeoptionsbutton.Size = UDim2.new(0, 32, 0, 32)
vapeoptionsbutton.Name = "OptionsButton"
vapeoptionsbutton.Parent = topbar
local vapeoptionsframe = Instance.new("Frame")
vapeoptionsframe.ZIndex = 10
vapeoptionsframe.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
vapeoptionsframe.Size = UDim2.new(0, 181, 0, 338)
vapeoptionsframe.Position = UDim2.new(0, 109, 1, 0)
vapeoptionsframe.BorderSizePixel = 0
vapeoptionsframe.Visible = false
vapeoptionsframe.Parent = topbar
local uilistlayout = Instance.new("UIListLayout")
uilistlayout.SortOrder = Enum.SortOrder.LayoutOrder
uilistlayout.Parent = vapeoptionsframe
uilistlayout:GetPropertyChangedSignal("AbsoluteContentSize"):connect(function()
	vapeoptionsframe.Size = UDim2.new(0, 181, 0, uilistlayout.AbsoluteContentSize.Y)
end)
local vapesearchbutton = vapeoptionsbutton:Clone()
vapesearchbutton.Text = "🔍"
vapesearchbutton.Name = "SearchButton"
vapesearchbutton.Position = UDim2.new(0, 144, 0, 4)
vapesearchbutton.Parent = topbar
local hudgui = Instance.new("Frame")
hudgui.Name = "HudGui"
hudgui.Size = UDim2.new(1, 0, 1, 0)
hudgui.BackgroundTransparency = 1
hudgui.Visible = true
hudgui.Parent = api["MainGui"]

local function CreateTopBarOption(typeval, name, ...)
	local args = {...}
	if typeval == "Toggle" then
		local buttonapi = {}
		local amount = #vapeoptionsframe:GetChildren()
		local frame = Instance.new("Frame")
		frame.BorderSizePixel = 0
		frame.BackgroundTransparency = 1
		frame.LayoutOrder = amount
		frame.Size = UDim2.new(0, 181, 0, 22)
		frame.Name = name
		frame.Visible = true
		frame.Parent = vapeoptionsframe
		local button = Instance.new("TextButton")
		button.Name = "Toggle"
		button.AutoButtonColor = false
		button.Text = ""
		button.BackgroundColor3 = (args[3] and Color3.fromHSV(api["Settings"]["GUIObject"]["Color"], 1, 1)) or Color3.fromRGB(89, 89, 89)
		button.BorderSizePixel = 0
		button.Size = UDim2.new(0, 22, 0, 15)
		button.Position = UDim2.new(0, 5, 0, 3)
		button.ZIndex = 12
		button.Parent = frame
		local uicorner = Instance.new("UICorner")
		uicorner.CornerRadius = UDim.new(0, 32)
		uicorner.Parent = button
		local frame2 = Instance.new("Frame")
		frame2.Active = false
		frame2.Size = UDim2.new(0, 12, 0, 11)
		frame2.Position = (args[3] and UDim2.new(0, 8, 0, 2)) or UDim2.new(0, 3, 0, 2)
		frame2.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
		frame2.BorderSizePixel = 0
		frame2.ZIndex = 13
		frame2.Parent = button
		local uicorner2 = Instance.new("UICorner")
		uicorner2.CornerRadius = UDim.new(0, 32)
		uicorner2.Parent = frame2
		local textlabel = Instance.new("TextLabel")
		textlabel.BackgroundTransparency = 1
		textlabel.Font = Enum.Font.SourceSans
		textlabel.Active = false
		textlabel.TextSize = 14
		textlabel.TextColor3 = Color3.new(1, 1, 1)
		textlabel.Size = UDim2.new(0, 140, 0, 19)
		textlabel.TextXAlignment = Enum.TextXAlignment.Left
		textlabel.Name = name
		textlabel.Text = "                "..name
		textlabel.ZIndex = 13
		textlabel.Parent = frame
		buttonapi["Enabled"] = false
		buttonapi["Keybind"] = ""
		buttonapi["Default"] = args[3]
		buttonapi["ToggleButton"] = function(toggle)
			buttonapi["Enabled"] = toggle
			if buttonapi["Enabled"] then
				button.BackgroundColor3 = Color3.fromHSV(api["Settings"]["GUIObject"]["Color"], 1, 1)
				frame2.Position = UDim2.new(0, 8, 0, 2)
				args[1]()
			else
				button.BackgroundColor3 = Color3.fromRGB(89, 89, 89)
				frame2.Position = UDim2.new(0, 3, 0, 2)
				frame2.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
				args[2]()
			end
		end
		buttonapi["ToggleButton"](args[3])
		button.MouseButton1Click:connect(function() buttonapi["ToggleButton"](not buttonapi["Enabled"]) end)
		api["ObjectsThatCanBeSaved"]["VapeOptions"..name.."Toggle"] = {["Type"] = "NewToggle", ["Object"] = button, ["Api"] = buttonapi}

		return buttonapi
	end
	if typeval == "GUIButton" then
		local buttonapi = {}
		local amount = #vapeoptionsframe:GetChildren()
		local frame = Instance.new("Frame")
		frame.BorderSizePixel = 0
		frame.BackgroundTransparency = 1
		frame.LayoutOrder = amount
		frame.Size = UDim2.new(0, 181, 0, 25)
		frame.Name = name
		frame.Visible = true
		frame.Parent = vapeoptionsframe
		local textbutton = Instance.new("TextButton")
		textbutton.Size = UDim2.new(0, 173, 0, 20)
		textbutton.AutoButtonColor = false
		textbutton.BorderSizePixel = 0
		textbutton.Position = UDim2.new(0, 4, 0, 1)
		textbutton.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
		textbutton.Font = Enum.Font.SourceSans
		textbutton.TextSize = 18
		textbutton.TextColor3 = Color3.new(1, 1, 1)
		textbutton.Name = name
		textbutton.Text = name
		textbutton.ZIndex = 13
		textbutton.Parent = frame
		buttonapi["Object"] = textbutton
		
		textbutton.MouseButton1Click:connect(function() args[1]() end)
		api["ObjectsThatCanBeSaved"]["VapeOptions"..name.."Button"] = {["Type"] = "NewButton", ["Object"] = textbutton, ["Api"] = buttonapi}

		return buttonapi
	end
	if typeval == "Button" then
		local buttonapi = {}
		local amount = #vapeoptionsframe:GetChildren()
		local frame = Instance.new("Frame")
		frame.BorderSizePixel = 0
		frame.BackgroundTransparency = 1
		frame.LayoutOrder = amount
		frame.Size = UDim2.new(0, 181, 0, 22)
		frame.Name = name
		frame.Visible = true
		frame.Parent = vapeoptionsframe
		local textbutton = Instance.new("TextButton")
		textbutton.Size = UDim2.new(0, 162, 0, 18)
		textbutton.AutoButtonColor = false
		textbutton.TextXAlignment = Enum.TextXAlignment.Left
		textbutton.BorderSizePixel = 0
		textbutton.Position = UDim2.new(0, 5, 0, 2)
		textbutton.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
		textbutton.Font = Enum.Font.SourceSans
		textbutton.TextSize = 14
		textbutton.TextColor3 = Color3.new(1, 1, 1)
		textbutton.Name = name
		textbutton.Text = "    "..name
		textbutton.ZIndex = 13
		textbutton.Parent = frame
		buttonapi["Object"] = textbutton
		
		textbutton.MouseButton1Click:connect(function() args[1]() end)
		api["ObjectsThatCanBeSaved"]["VapeOptions"..name.."Button"] = {["Type"] = "NewButton", ["Object"] = textbutton, ["Api"] = buttonapi}

		return buttonapi
	end
end

vapeoptionsbutton.MouseButton1Click:connect(function()
	vapeoptionsframe.Visible = not vapeoptionsframe.Visible
end)

api["SaveFriends"] = function()
	writefile("vape/Profiles/friends.vapefriends", game:GetService("HttpService"):JSONEncode(api["FriendsObject"]["Friends"]))
end

api["LoadFriends"] = function()
	local success, result = pcall(function()
		return game:GetService("HttpService"):JSONDecode(readfile("vape/Profiles/friends.vapefriends"))
	end)
	if success and type(result) == "table" then
		api["FriendsObject"]["Friends"] = result
	end
end

api["SaveSettings"] = function()
	for i,v in pairs(api["ObjectsThatCanBeSaved"]) do
		if v["Type"] == "Window" then
			api["Settings"][i] = {["Type"] = "Window", ["Visible"] = v["Object"].Visible, ["Expanded"] = v["ChildrenObject"].Visible, ["Position"] = {v["Object"].Position.X.Scale, v["Object"].Position.X.Offset, v["Object"].Position.Y.Scale, v["Object"].Position.Y.Offset}}
		end
		if v["Type"] == "CustomWindow" then
			api["Settings"][i] = {["Type"] = "CustomWindow", ["Visible"] = v["Object"].Visible, ["Pinned"] = v["Api"]["Pinned"], ["Position"] = {v["Object"].Position.X.Scale, v["Object"].Position.X.Offset, v["Object"].Position.Y.Scale, v["Object"].Position.Y.Offset}}
		end
		if (v["Type"] == "Button" or v["Type"] == "Toggle") then
			api["Settings"][i] = {["Type"] = "Button", ["Enabled"] = v["Api"]["Enabled"], ["Keybind"] = v["Api"]["Keybind"]}
		end
		if v["Type"] == "NewToggle" then
			api["Settings"][i] = {["Type"] = "NewToggle", ["Enabled"] = v["Api"]["Enabled"], ["Keybind"] = v["Api"]["Keybind"]}
		end
		if v["Type"] == "Dropdown" then
			api["Settings"][i] = {["Type"] = "Dropdown", ["Value"] = v["Api"]["Value"]}
		end
		if v["Type"] == "OptionsButton" then
			api["Settings"][i] = {["Type"] = "OptionsButton", ["Enabled"] = v["Api"]["Enabled"], ["Expanded"] = v["Api"]["Expanded"], ["Keybind"] = v["Api"]["Keybind"]}
		end
		if v["Type"] == "Slider" then
			api["Settings"][i] = {["Type"] = "Slider", ["Value"] = v["Api"]["Value"]}
		end
		if v["Type"] == "ColorSlider" then
			api["Settings"][i] = {["Type"] = "ColorSlider", ["Value"] = v["Api"]["Value"], ["RainbowValue"] = v["Api"]["RainbowValue"]}
		end
	end
	writefile("vape/Profiles/"..game.PlaceId..".vapeprofile", game:GetService("HttpService"):JSONEncode(api["Settings"]))
end

api["LoadSettings"] = function()
	local success, result = pcall(function()
		return game:GetService("HttpService"):JSONDecode(readfile("vape/Profiles/"..game.PlaceId..".vapeprofile"))
	end)
	if success and type(result) == "table" then
		api["Settings"]["GUIObject"]["BlatantMode"] = result["GUIObject"]["BlatantMode"]
		for i,v in pairs(result) do
			if v["Type"] == "Window" and api["findObjectInTable"](api["ObjectsThatCanBeSaved"], i) then
				api["ObjectsThatCanBeSaved"][i]["Object"].Position = UDim2.new(v["Position"][1], v["Position"][2], v["Position"][3], v["Position"][4])
				api["ObjectsThatCanBeSaved"][i]["Object"].Visible = v["Visible"]
				api["ObjectsThatCanBeSaved"][i]["Api"]["RealVis"] = v["Visible"]
				if v["Expanded"] then
					api["ObjectsThatCanBeSaved"][i]["Api"]["ExpandToggle"]()
				end
			end
			if v["Type"] == "Custom" and api["findObjectInTable"](api["Settings"], i) then
				api["Settings"][i] = v
			end
			if v["Type"] == "CustomWindow" and api["findObjectInTable"](api["ObjectsThatCanBeSaved"], i) then
				api["ObjectsThatCanBeSaved"][i]["Object"].Position = UDim2.new(v["Position"][1], v["Position"][2], v["Position"][3], v["Position"][4])
				api["ObjectsThatCanBeSaved"][i]["Object"].Visible = v["Visible"]
				if v["Pinned"] then
					api["ObjectsThatCanBeSaved"][i]["Api"]["PinnedToggle"]()
				end
				api["ObjectsThatCanBeSaved"][i]["Api"]["CheckVis"]()
			end
			if v["Type"] == "Button" and i:match("VapeOptions") and api["findObjectInTable"](api["ObjectsThatCanBeSaved"], i) then
				v["Type"] = "NewToggle"
			end
			if (v["Type"] == "Button" or v["Type"] == "Toggle") and v["Enabled"] and api["findObjectInTable"](api["ObjectsThatCanBeSaved"], i) then
				api["ObjectsThatCanBeSaved"][i]["Api"]["ToggleButton"](false)
				if v["Keybind"] ~= "" then
					api["ObjectsThatCanBeSaved"][i]["Api"]["Keybind"] = v["Keybind"]
				end
			end
			if v["Type"] == "NewToggle" and api["findObjectInTable"](api["ObjectsThatCanBeSaved"], i) then
				api["ObjectsThatCanBeSaved"][i]["Api"]["ToggleButton"](v["Enabled"])
			end
			if v["Type"] == "Dropdown" and api["findObjectInTable"](api["ObjectsThatCanBeSaved"], i) then
				api["ObjectsThatCanBeSaved"][i]["Api"]["SetValue"](v["Value"])
			end
			if v["Type"] == "OptionsButton" and api["findObjectInTable"](api["ObjectsThatCanBeSaved"], i) then
				if v["Enabled"] then
					api["ObjectsThatCanBeSaved"][i]["Api"]["ToggleButton"](false)
				end
				if v["Expanded"] then
					api["ObjectsThatCanBeSaved"][i]["Api"]["ToggleExpanded"]()
				end
				if v["Keybind"] ~= "" then
					api["ObjectsThatCanBeSaved"][i]["Api"]["Keybind"] = v["Keybind"]
				end
			end
			if v["Type"] == "Slider" and api["findObjectInTable"](api["ObjectsThatCanBeSaved"], i) then
				api["ObjectsThatCanBeSaved"][i]["Api"]["SetValue"](v["Value"] < api["ObjectsThatCanBeSaved"][i]["Api"]["Max"] and v["Value"] or api["ObjectsThatCanBeSaved"][i]["Api"]["Max"])
				api["ObjectsThatCanBeSaved"][i]["Object"].Slider.FillSlider.Size = UDim2.new((v["Value"] < api["ObjectsThatCanBeSaved"][i]["Api"]["Max"] and v["Value"] or api["ObjectsThatCanBeSaved"][i]["Api"]["Max"]) / api["ObjectsThatCanBeSaved"][i]["Api"]["Max"], 0, 1, 0)
			end
			if v["Type"] == "ColorSlider" and api["findObjectInTable"](api["ObjectsThatCanBeSaved"], i) then
				api["ObjectsThatCanBeSaved"][i]["Api"]["SetValue"](v["Value"])
				api["ObjectsThatCanBeSaved"][i]["Api"]["SetRainbow"](v["RainbowValue"])
				api["ObjectsThatCanBeSaved"][i]["Object"].Slider.ButtonSlider.Position = UDim2.new(v["Value"], -1, 0, 0)
			end
		end
	end
end

api["CreateCustomWindow"] = function(name, icon, position, visible)
	local windowapi = {}
	local windowtitle = Instance.new("TextButton")
	windowtitle.AutoButtonColor = false
	windowtitle.BackgroundColor3 = Color3.fromRGB(34, 35, 38)
	windowtitle.BorderSizePixel = 0
	windowtitle.BackgroundTransparency = 0.1
	windowtitle.TextSize = 20
	windowtitle.Font = Enum.Font.SourceSans
	windowtitle.Size = UDim2.new(0, 165, 0, 40)
	windowtitle.Visible = false
	windowtitle.Position = position
	windowtitle.Text = name
	windowtitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	windowtitle.Name = name
	windowtitle.Visible = visible
	windowtitle.Parent = hudgui
	local iconlabel = Instance.new("TextLabel")
	iconlabel.Active = false
	iconlabel.Font = Enum.Font.SourceSans
	iconlabel.Size = UDim2.new(0, 36, 0, 39)
	iconlabel.TextSize = 24
	iconlabel.Text = icon
	iconlabel.Name = "IconLabel"
	iconlabel.BackgroundTransparency = 1
	iconlabel.TextColor3 = Color3.new(1, 1, 1)
	iconlabel.Parent = windowtitle
	local expandbutton = Instance.new("TextButton")
	expandbutton.Active = true
	expandbutton.AutoButtonColor = false
	expandbutton.Font = Enum.Font.SourceSans
	expandbutton.TextSize = 20
	expandbutton.Size = UDim2.new(0, 25, 0, 40)
	expandbutton.Position = UDim2.new(1, -25, 0, 0)
	expandbutton.Text = "📍"
	expandbutton.Name = "PinButton"
	expandbutton.BackgroundTransparency = 1
	expandbutton.TextTransparency = 0.3
	expandbutton.TextColor3 = Color3.new(1, 1, 1)
	expandbutton.Parent = windowtitle
	dragGUI(windowtitle)

	local children = Instance.new("Frame")
	children.Name = "Children"
	children.Size = UDim2.new(0, 165, 0, 300)
	children.Position = UDim2.new(0, 0, 1, 0)
	children.BackgroundTransparency = 1
	children.Visible = true
	children.BorderSizePixel = 0
	children.ClipsDescendants = false
	children.Parent = windowtitle
	windowapi["Pinned"] = false
	windowapi["RealVis"] = false
	
	windowapi["CheckVis"] = function()
		if windowapi["RealVis"] then
			if clickgui.Visible then
				windowtitle.Visible = true
				windowtitle.Text = name
				windowtitle.Size = UDim2.new(0, 165, 0, 40)
				iconlabel.Visible = true
				expandbutton.Visible = true
			else
				if windowapi["Pinned"] then
					windowtitle.Visible = true
					windowtitle.Text = ""
					windowtitle.Size = UDim2.new(0, 165, 0, 0)
					iconlabel.Visible = false
					expandbutton.Visible = false
				else
					windowtitle.Visible = false
				end
			end
		else
			windowtitle.Visible = false
		end
	end
	
	windowapi["SetVisible"] = function(value)
		windowapi["RealVis"] = value
		windowapi["CheckVis"]()
	end
	
	windowapi["PinnedToggle"] = function()
		windowapi["Pinned"] = not windowapi["Pinned"]
		if windowapi["Pinned"] then
			expandbutton.TextTransparency = 0
		else
			expandbutton.TextTransparency = 0.3
		end
	end
	
	clickgui:GetPropertyChangedSignal("Visible"):connect(windowapi["CheckVis"])
	windowapi["CheckVis"]()
	
	windowapi["GetCustomChildren"] = function()
		return children
	end
	
	expandbutton.MouseButton1Click:connect(windowapi["PinnedToggle"])
	api["ObjectsThatCanBeSaved"][name.."CustomWindow"] = {["Object"] = windowtitle, ["ChildrenObject"] = children, ["Type"] = "CustomWindow", ["Api"] = windowapi}
	
	return windowapi
end

api["CreateWindow"] = function(name, icon, position, visible)
	local windowapi = {}
	local windowtitle = Instance.new("TextButton")
	windowtitle.AutoButtonColor = false
	windowtitle.BackgroundColor3 = Color3.fromRGB(34, 35, 38)
	windowtitle.BorderSizePixel = 0
	windowtitle.BackgroundTransparency = 0.1
	windowtitle.TextSize = 20
	windowtitle.Font = Enum.Font.SourceSans
	windowtitle.Size = UDim2.new(0, 165, 0, 40)
	windowtitle.Position = position
	windowtitle.Text = name
	windowtitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	windowtitle.Name = name
	windowtitle.Visible = visible
	windowtitle.Parent = clickgui
	local iconlabel = Instance.new("TextLabel")
	iconlabel.Active = false
	iconlabel.Font = Enum.Font.SourceSans
	iconlabel.Size = UDim2.new(0, 36, 0, 39)
	iconlabel.TextSize = 24
	iconlabel.Text = icon
	iconlabel.Name = "IconLabel"
	iconlabel.BackgroundTransparency = 1
	iconlabel.TextColor3 = Color3.new(1, 1, 1)
	iconlabel.Parent = windowtitle
	local expandbutton = Instance.new("TextButton")
	expandbutton.Active = true
	expandbutton.AutoButtonColor = false
	expandbutton.Font = Enum.Font.SourceSans
	expandbutton.TextSize = 20
	expandbutton.Size = UDim2.new(0, 25, 0, 40)
	expandbutton.Position = UDim2.new(1, -25, 0, 0)
	expandbutton.Text = "+"
	expandbutton.Name = "ExpandButton"
	expandbutton.BackgroundTransparency = 1
	expandbutton.TextColor3 = Color3.new(1, 1, 1)
	expandbutton.Parent = windowtitle
	dragGUI(windowtitle)

	local children = Instance.new("ScrollingFrame")
	children.Name = "Children"
	children.Size = UDim2.new(0, 165, 0, 420)
	children.Position = UDim2.new(0, 0, 1, 0)
	children.BackgroundTransparency = 1
	children.Visible = false
	children.BorderSizePixel = 0
	children.ScrollBarThickness = 10
	children.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
	children.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
	children.ScrollBarImageTransparency = 0
	children.ScrollBarImageColor3 = Color3.new(0, 0, 0)
	children.Parent = windowtitle
	children.ZIndex = 2
	local childrenscrollbarbkg = Instance.new("Frame")
	childrenscrollbarbkg.Position = UDim2.new(0, 165, 0, 40)
	childrenscrollbarbkg.Size = UDim2.new(0, 10, 0, 420)
	childrenscrollbarbkg.BackgroundColor3 = Color3.fromRGB(42, 45, 46)
	childrenscrollbarbkg.BackgroundTransparency = 0.1
	childrenscrollbarbkg.BorderSizePixel = 0
	childrenscrollbarbkg.ZIndex = 1
	childrenscrollbarbkg.Visible = false
	childrenscrollbarbkg.Parent = windowtitle
	api["ObjectsThatCanBeSaved"][name.."Window"] = {["Object"] = windowtitle, ["ChildrenObject"] = children, ["Type"] = "Window", ["Api"] = windowapi}

	local uilistlayout = Instance.new("UIListLayout")
	uilistlayout.SortOrder = Enum.SortOrder.LayoutOrder
	uilistlayout.Parent = children
	children.CanvasSize = UDim2.new(0, 0, 0, uilistlayout.AbsoluteContentSize.Y)
	uilistlayout:GetPropertyChangedSignal("AbsoluteContentSize"):connect(function()
		children.CanvasSize = UDim2.new(0, 0, 0, uilistlayout.AbsoluteContentSize.Y)
		if uilistlayout.AbsoluteContentSize.Y >= 420 then
			windowtitle.Size = UDim2.new(0, 175, 0, 40)
			children.Size = UDim2.new(0, 175, 0, 420)
			childrenscrollbarbkg.Visible = true
		else
			windowtitle.Size = UDim2.new(0, 165, 0, 40)
			childrenscrollbarbkg.Visible = false
		end
	end)

	windowapi["SetVisible"] = function(value)
		windowtitle.Visible = value
	end

	windowapi["ExpandToggle"] = function()
		children.Visible = not children.Visible
		if children.Visible then
			expandbutton.Text = "-"
			if uilistlayout.AbsoluteContentSize.Y >= 420 then
				childrenscrollbarbkg.Visible = true
			else
				childrenscrollbarbkg.Visible = false
			end
		else
			expandbutton.Text = "+"
			childrenscrollbarbkg.Visible = false
		end
	end

	windowtitle.MouseButton2Click:connect(windowapi["ExpandToggle"])
	expandbutton.MouseButton1Click:connect(windowapi["ExpandToggle"])
	expandbutton.MouseButton2Click:connect(windowapi["ExpandToggle"])

	windowapi["CreateButton"] = function(name, temporaryfunction, temporaryfunction2)
		local buttonapi = {}
		local amount = #children:GetChildren()
		local button = Instance.new("TextButton")
		button.AutoButtonColor = false
		button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		button.BorderSizePixel = 0
		button.BackgroundTransparency = 0.275
		button.TextSize = 20
		button.LayoutOrder = amount
		button.Font = Enum.Font.SourceSans
		button.Size = UDim2.new(0, 165, 0, 30)
		button.Text = name
		button.TextColor3 = Color3.fromRGB(255, 255, 255)
		button.Name = name
		button.Visible = true
		button.Parent = children
		buttonapi["Enabled"] = false
		buttonapi["Keybind"] = ""
		buttonapi["ToggleButton"] = function(clicked)
			if clicked and holdingshift then
				if captured == false then
					captured = true
					spawn(function()
						if buttonapi["Keybind"] ~= "" then
							button.Text = "Unbound"
							buttonapi["Keybind"] = ""
							captured = false
							wait(1)
							button.Text = name
						else
							button.Text = "Press a key"
							repeat wait() until pressedkey ~= ""
							buttonapi["Keybind"] = pressedkey
							pressedkey = ""
							button.Text = "Bound to "..buttonapi["Keybind"]
							captured = false
							wait(1)
							button.Text = name
						end
					end)
				end
			else
				buttonapi["Enabled"] = not buttonapi["Enabled"]
				if buttonapi["Enabled"] then
					button.BackgroundColor3 = Color3.fromHSV(api["Settings"]["GUIObject"]["Color"], 1, 1)
					button.BackgroundTransparency = 0
					button.TextColor3 = Color3.new(0, 0, 0)
					temporaryfunction()
				else
					button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
					button.BackgroundTransparency = 0.275
					button.TextColor3 = Color3.new(1, 1, 1)
					temporaryfunction2()
				end
				api["UpdateHudEvent"]:Fire()
			end
		end
		button.MouseButton1Click:connect(function() buttonapi["ToggleButton"](true) end)
		api["ObjectsThatCanBeSaved"][name.."Button"] = {["Type"] = "Button", ["Object"] = button, ["Api"] = buttonapi}

		return buttonapi
	end

	windowapi["CreateOptionsButton"] = function(naame, temporaryfunction, temporaryfunction2, expandedmenu, temporaryfunction3, blatantmode)
		local buttonapi = {}
		local amount = #children:GetChildren()
		local button = Instance.new("TextButton")
		button.AutoButtonColor = false
		button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		button.BorderSizePixel = 0
		button.BackgroundTransparency = 0.275
		button.TextSize = 20
		button.LayoutOrder = amount
		button.Font = Enum.Font.SourceSans
		button.Size = UDim2.new(0, 145, 0, 30)
		button.Text = naame
		button.TextColor3 = (blatantmode and Color3.fromRGB(128, 128, 128) or Color3.fromRGB(255, 255, 255))
		button.Name = naame
		button.Visible = true
		button.Parent = children
		local button2 = Instance.new("TextButton")
		button2.AutoButtonColor = false
		button2.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		button2.BorderSizePixel = 0
		button2.BackgroundTransparency = 0.275
		button2.TextSize = 6
		button2.TextColor3 = Color3.new(1, 1, 1)
		button2.Size = UDim2.new(0, 20, 0, 30)
		button2.Position = UDim2.new(1, 0, 0, 0)
		button2.Name = "OptionsButton"
		button2.Font = Enum.Font.GothamBold
		button2.Parent = button
		local visual1 = Instance.new("Frame")
		visual1.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		visual1.BorderSizePixel = 0
		visual1.BackgroundTransparency = 0.275
		visual1.Size = UDim2.new(0, 3, 0, 0)
		visual1.Visible = false
		visual1.Name = naame.."Children2"
		visual1.LayoutOrder = amount
		visual1.Parent = children
		local visual2 = Instance.new("Frame")
		visual2.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		visual2.BorderSizePixel = 0
		visual2.BackgroundTransparency = 0.275
		visual2.Size = UDim2.new(0, 3, 1, 0)
		visual2.Position = UDim2.new(0, 163, 0, 0)
		visual2.Visible = true
		visual2.LayoutOrder = amount
		visual2.Parent = visual1
		local children2 = Instance.new("Frame")
		children2.BackgroundColor3 = Color3.new(0, 0, 0)
		children2.BorderSizePixel = 0
		children2.Visible = true
		children2.Name = "Children2"
		children2.BackgroundTransparency = 0.1
		children2.Size = UDim2.new(0, 161, 1, 0)
		children2.Position = UDim2.new(0, 2, 0, 0)
		children2.Parent = visual1
		local uilistlayout2 = Instance.new("UIListLayout")
		uilistlayout2.SortOrder = Enum.SortOrder.LayoutOrder
		uilistlayout2.Parent = children2
		uilistlayout2:GetPropertyChangedSignal("AbsoluteContentSize"):connect(function()
			visual1.Size = UDim2.new(0, 4, 0, uilistlayout2.AbsoluteContentSize.Y)
		end)
		buttonapi["Enabled"] = false
		buttonapi["Keybind"] = ""
		buttonapi["Bindable"] = true
		buttonapi["Name"] = naame
		buttonapi["Expanded"] = false
		buttonapi["Blatant"] = blatantmode
		buttonapi["HasExtraText"] = type(temporaryfunction3) == "function"
		buttonapi["GetExtraText"] = (buttonapi["HasExtraText"] and temporaryfunction3 or function() return "" end)
		buttonapi["ToggleButton"] = function(clicked, force)
			if ((blatantmode and api["Settings"]["GUIObject"]["BlatantMode"] or force) or (not blatantmode)) then
				if clicked and holdingshift and buttonapi["Bindable"] then
					if captured == false then
						captured = true
						spawn(function()
							if buttonapi["Keybind"] ~= "" then
								button.Text = "Unbound"
								buttonapi["Keybind"] = ""
								captured = false
								wait(1)
								button.Text = naame
							else
								button.Text = "Press a key"
								repeat wait() until pressedkey ~= ""
								buttonapi["Keybind"] = pressedkey
								pressedkey = ""
								button.Text = "Bound to "..buttonapi["Keybind"]
								captured = false
								wait(1)
								button.Text = naame
							end
						end)
					end
				else
					buttonapi["Enabled"] = not buttonapi["Enabled"]
					api["UpdateHudEvent"]:Fire()
					if buttonapi["Enabled"] then
						button.BackgroundColor3 = Color3.fromHSV(api["Settings"]["GUIObject"]["Color"], 1, 1)
						button.BackgroundTransparency = 0
						button.TextColor3 = Color3.new(0, 0, 0)
						temporaryfunction()
					else
						button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
						button.BackgroundTransparency = 0.275
						button.TextColor3 = Color3.new(1, 1, 1)
						temporaryfunction2()
					end
				end
			end
		end
		buttonapi["ToggleExpanded"] = function()
			buttonapi["Expanded"] = not buttonapi["Expanded"]
			visual1.Visible = buttonapi["Expanded"]
			if buttonapi["Expanded"] then
				button2.BackgroundColor3 = Color3.new(0, 0, 0)
			else
				button2.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			end
		end
		if expandedmenu then
			button2.Text = "·\n·\n·"
		else
			button2.Text = ""
			buttonapi["ToggleExpanded"] = function() end
		end
		button.MouseButton1Click:connect(function() buttonapi["ToggleButton"](true) end)
		button.MouseButton2Click:connect(buttonapi["ToggleExpanded"])
		button2.MouseButton1Click:connect(buttonapi["ToggleExpanded"])
		buttonapi["CreateColorSlider"] = function(name, temporaryfunction)
			local min, max = 0, 1
			local def = math.floor((min + max) / 2)
			local defsca = (def - min)/(max - min)
			local click = false
			local sliderapi = {}
			local amount = #children:GetChildren()
			local frame = Instance.new("Frame")
			frame.Size = UDim2.new(0, 161, 0, 30)
			frame.BackgroundTransparency = 1
			frame.LayoutOrder = amount2
			frame.BorderSizePixel = 0
			frame.Name = name
			frame.Parent = children2
			local textlabel = Instance.new("TextLabel")
			textlabel.Size = UDim2.new(0, 161, 0, 15)
			textlabel.BackgroundTransparency = 1
			textlabel.Font = Enum.Font.SourceSans
			textlabel.TextSize = 16
			textlabel.TextColor3 = Color3.new(1, 1, 1)
			textlabel.Text = name
			textlabel.Parent = frame
			local slider1 = Instance.new("TextButton")
			slider1.Size = UDim2.new(0, 156, 0, 14)
			slider1.BackgroundColor3 = Color3.new(1, 1, 1)
			slider1.AutoButtonColor = false
			slider1.Text = ""
			slider1.BorderSizePixel = 0
			slider1.Position = UDim2.new(0, 3, 0, 16)
			slider1.Name = "Slider"
			slider1.Parent = frame
			local uigradient = Instance.new("UIGradient")
			uigradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 1, 1)), ColorSequenceKeypoint.new(0.1, Color3.fromHSV(0.1, 1, 1)), ColorSequenceKeypoint.new(0.2, Color3.fromHSV(0.2, 1, 1)), ColorSequenceKeypoint.new(0.3, Color3.fromHSV(0.3, 1, 1)), ColorSequenceKeypoint.new(0.4, Color3.fromHSV(0.4, 1, 1)), ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5, 1, 1)), ColorSequenceKeypoint.new(0.6, Color3.fromHSV(0.6, 1, 1)), ColorSequenceKeypoint.new(0.7, Color3.fromHSV(0.7, 1, 1)), ColorSequenceKeypoint.new(0.8, Color3.fromHSV(0.8, 1, 1)), ColorSequenceKeypoint.new(0.9, Color3.fromHSV(0.9, 1, 1)), ColorSequenceKeypoint.new(1, Color3.fromHSV(1, 1, 1))})
			uigradient.Parent = slider1
			local slider3 = Instance.new("Frame")
			slider3.Size = UDim2.new(0, 2, 0, 14)
			slider3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			slider3.Position = UDim2.new(0.44,-1,0,0)
			slider3.Parent = slider1
			slider3.BorderSizePixel = 0
			slider3.Name = "ButtonSlider"
			sliderapi["Value"] = 0.44
			sliderapi["RainbowValue"] = false
			sliderapi["SetValue"] = function(val)
				val = math.clamp(val, min, max)
				sliderapi["Value"] = val
				slider3.Position = UDim2.new(val, -1, 0, 0)
				temporaryfunction(val)
			end
			sliderapi["SetRainbow"] = function(val)
				sliderapi["RainbowValue"] = val
				if sliderapi["RainbowValue"] then
					local heh
					heh = coroutine.resume(coroutine.create(function()
						repeat
							wait()
							if sliderapi["RainbowValue"] then
								sliderapi["SetValue"](rainbowvalue)
							else
								coroutine.yield(heh)
							end
						until sliderapi["RainbowValue"] == false
					end))
				end
			end
			slider1.MouseButton1Down:Connect(function()
				spawn(function()
					click = true
					wait(0.3)
					click = false
				end)
				if click then
					sliderapi["SetRainbow"](not sliderapi["RainbowValue"])
				end
				local x,y,xscale,yscale = RelativeXY(slider1, game:GetService("UserInputService"):GetMouseLocation())
				sliderapi["SetValue"](min + ((max - min) * xscale))
				slider3.Position = UDim2.new(xscale, -1, 0, 0)
				local move
				local kill
				move = game:GetService("UserInputService").InputChanged:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseMovement then
						local x,y,xscale,yscale = RelativeXY(slider1, game:GetService("UserInputService"):GetMouseLocation())
						sliderapi["SetValue"](min + ((max - min) * xscale))
					end
				end)
				kill = game:GetService("UserInputService").InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						capturedslider = {["Type"] = "ColorSlider", ["Object"] = frame, ["Api"] = sliderapi}
						move:Disconnect()
						kill:Disconnect()
					end
				end)
			end)
			api["ObjectsThatCanBeSaved"][naame..name.."SliderColor"] = {["Type"] = "ColorSlider", ["Object"] = frame, ["Api"] = sliderapi}

			return sliderapi
		end
		buttonapi["CreateSlider"] = function(name, min, max, temporaryfunction, defaultvalue)
			local def = math.floor((min + max) / 2)
			local defsca = (def - min)/(max - min)
			local sliderapi = {}
			local amount2 = #children2:GetChildren()
			local frame = Instance.new("Frame")
			frame.Size = UDim2.new(0, 161, 0, 30)
			frame.BackgroundTransparency = 1
			frame.LayoutOrder = amount2
			frame.BorderSizePixel = 0
			frame.Name = name
			frame.Parent = children2
			local textlabel = Instance.new("TextLabel")
			textlabel.Size = UDim2.new(0, 161, 0, 15)
			textlabel.BackgroundTransparency = 1
			textlabel.Font = Enum.Font.SourceSans
			textlabel.TextSize = 16
			textlabel.TextColor3 = Color3.new(1, 1, 1)
			textlabel.Text = " "..name
			textlabel.TextXAlignment = Enum.TextXAlignment.Left
			textlabel.Parent = frame
			local textlabel2 = Instance.new("TextLabel")
			textlabel2.Size = UDim2.new(0, 161, 0, 15)
			textlabel2.BackgroundTransparency = 1
			textlabel2.Font = Enum.Font.SourceSans
			textlabel2.TextSize = 16
			textlabel2.TextColor3 = Color3.new(1, 1, 1)
			textlabel2.Text = tostring((defaultvalue or min)) .. " "
			textlabel2.TextXAlignment = Enum.TextXAlignment.Right
			textlabel2.Parent = frame
			local slider1 = Instance.new("Frame")
			slider1.Size = UDim2.new(0, 145, 0, 9)
			slider1.BackgroundColor3 = Color3.new(0, 0, 0)
			slider1.Position = UDim2.new(0, 8, 0, 18)
			slider1.Name = "Slider"
			slider1.Parent = frame
			local uicorner = Instance.new("UICorner")
			uicorner.CornerRadius = UDim.new(0, 32)
			uicorner.Parent = slider1
			local slider2 = Instance.new("Frame")
			slider2.Size = UDim2.new(((defaultvalue or min) / max), 0, 1, 0)
			slider2.BackgroundColor3 = Color3.fromHSV(api["Settings"]["GUIObject"]["Color"], 1, 1)
			slider2.Name = "FillSlider"
			slider2.Parent = slider1
			local uicorner2 = Instance.new("UICorner")
			uicorner2.CornerRadius = UDim.new(0, 32)
			uicorner2.Parent = slider2
			local slider3 = Instance.new("TextButton")
			slider3.Size = UDim2.new(0, 11, 0, 11)
			slider3.Text = ""
			slider3.AutoButtonColor = false
			slider3.BackgroundColor3 = Color3.fromRGB(89, 89, 89)
			slider3.Position = UDim2.new(1, -6, 0, -1)
			slider3.Parent = slider2
			slider3.Name = "ButtonSlider"
			local uicorner3 = Instance.new("UICorner")
			uicorner3.CornerRadius = UDim.new(0, 32)
			uicorner3.Parent = slider3
			sliderapi["Value"] = (defaultvalue or min)
			sliderapi["Max"] = max
			sliderapi["SetValue"] = function(val)
				val = math.clamp(val, min, max)
				sliderapi["Value"] = val
				textlabel2.Text = sliderapi["Value"].." "
				temporaryfunction(val)
			end
			slider3.MouseButton1Down:Connect(function()
				local x,y,xscale,yscale = RelativeXY(slider1, game:GetService("UserInputService"):GetMouseLocation())
				sliderapi["SetValue"](math.floor(min + ((max - min) * xscale)))
				textlabel2.Text = sliderapi["Value"].." "
				slider2.Size = UDim2.new(xscale,0,1,0)
				local move
				local kill
				move = game:GetService("UserInputService").InputChanged:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseMovement then
						local x,y,xscale,yscale = RelativeXY(slider1, game:GetService("UserInputService"):GetMouseLocation())
						sliderapi["SetValue"](math.floor(min + ((max - min) * xscale)))
						textlabel2.Text = sliderapi["Value"].." "
						slider2.Size = UDim2.new(xscale,0,1,0)
					end
				end)
				kill = game:GetService("UserInputService").InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						capturedslider = {["Type"] = "Slider", ["Object"] = frame, ["Api"] = sliderapi}
						move:Disconnect()
						kill:Disconnect()
					end
				end)
			end)
			api["ObjectsThatCanBeSaved"][naame..name.."Slider"] = {["Type"] = "Slider", ["Object"] = frame, ["Api"] = sliderapi}

			return sliderapi
		end
		buttonapi["CreateDropdown"] = function(name, tab, temporaryfunction)
			local dropapi = {}
			local list = tab
			local amount2 = #children2:GetChildren()
			local frame = Instance.new("Frame")
			frame.Size = UDim2.new(0, 161, 0, 30)
			frame.BackgroundTransparency = 1
			frame.BorderSizePixel = 0
			frame.LayoutOrder = amount2
			frame.Name = name
			frame.Parent = children2
			local textlabel = Instance.new("TextLabel")
			textlabel.Size = UDim2.new(0, 161, 0, 15)
			textlabel.BackgroundTransparency = 1
			textlabel.Font = Enum.Font.SourceSans
			textlabel.TextSize = 16
			textlabel.TextColor3 = Color3.new(1, 1, 1)
			textlabel.Text = name
			textlabel.Parent = frame
			local drop1 = Instance.new("TextButton")
			drop1.Text = (list ~= {} and list[1] or "")
			drop1.TextColor3 = Color3.new(1, 1, 1)
			drop1.AutoButtonColor = false
			drop1.Size = UDim2.new(0, 157, 0, 13)
			drop1.BackgroundColor3 = Color3.fromRGB(42, 45, 46)
			drop1.Position = UDim2.new(0, 2, 0, 16)
			drop1.BorderSizePixel = 0
			drop1.Font = Enum.Font.SourceSans
			drop1.TextSize = 14
			drop1.Name = "DropdownButton"
			drop1.Parent = frame
			local dropframe = Instance.new("Frame")
			dropframe.LayoutOrder = amount2
			dropframe.Parent = children2
			dropframe.BackgroundColor3 = Color3.new(0, 0, 0)
			dropframe.BorderSizePixel = 0
			dropframe.Visible = false
			drop1.MouseButton1Click:connect(function()
				dropframe.Visible = not dropframe.Visible
			end)
			local placeholder = 0
			dropapi["Value"] = (list ~= {} and list[1] or "")
			dropapi["Default"] = dropapi["Value"]
			dropapi["UpdateList"] = function(val)
				placeholder = 0
				list = val
				for del1, del2 in pairs(dropframe:GetChildren()) do if del2:IsA("TextButton") then del2:Remove() end end
				for numbe, listobj in pairs(val) do
					if listobj ~= dropapi["Value"] then
						local drop2 = Instance.new("TextButton")
						dropframe.Size = UDim2.new(0, 157, 0, placeholder + 13)
						drop2.Text = listobj
						drop2.LayoutOrder = numbe
						drop2.TextColor3 = Color3.new(1, 1, 1)
						drop2.AutoButtonColor = false
						drop2.Size = UDim2.new(0, 157, 0, 13)
						drop2.Position = UDim2.new(0, 2, 0, placeholder - 1)
						drop2.BackgroundColor3 = Color3.fromRGB(42, 45, 46)
						drop2.Font = Enum.Font.SourceSans
						drop2.TextSize = 14
						drop2.BorderSizePixel = 0
						drop2.Name = listobj
						drop2.Parent = dropframe
						drop2.MouseButton1Click:connect(function()
							dropapi["Value"] = listobj
							drop1.Text = listobj
							dropframe.Visible = false
							temporaryfunction(listobj)
							dropapi["UpdateList"](list)
							if buttonapi["HasExtraText"] then
								api["UpdateHudEvent"]:Fire()
							end
						end)
						placeholder = placeholder + 13
					end
				end
			end
			dropapi["SetValue"] = function(listobj)
				dropapi["Value"] = listobj
				drop1.Text = listobj
				dropframe.Visible = false
				temporaryfunction(listobj)
				dropapi["UpdateList"](list)
				if buttonapi["HasExtraText"] then
					api["UpdateHudEvent"]:Fire()
				end
			end
			dropapi["UpdateList"](list)
			if buttonapi["HasExtraText"] then
				api["UpdateHudEvent"]:Fire()
			end
			api["ObjectsThatCanBeSaved"][naame..name.."Dropdown"] = {["Type"] = "Dropdown", ["Object"] = frame, ["Api"] = dropapi}

			return dropapi
		end
		buttonapi["CreateToggle"] = function(name, temporaryfunction, temporaryfunction2)
			local buttonapi = {}
			local amount = #children2:GetChildren()
			local frame = Instance.new("Frame")
			frame.BorderSizePixel = 0
			frame.BackgroundTransparency = 1
			frame.LayoutOrder = amount
			frame.Size = UDim2.new(0, 161, 0, 26)
			frame.Name = name
			frame.Visible = true
			frame.Parent = children2
			local button = Instance.new("TextButton")
			button.Name = "Toggle"
			button.AutoButtonColor = false
			button.Text = ""
			button.BackgroundColor3 = Color3.fromRGB(89, 89, 89)
			button.BorderSizePixel = 0
			button.Size = UDim2.new(0, 23, 0, 15)
			button.Position = UDim2.new(0, 4, 0, 5)
			button.Parent = frame
			local uicorner = Instance.new("UICorner")
			uicorner.CornerRadius = UDim.new(0, 32)
			uicorner.Parent = button
			local frame2 = Instance.new("Frame")
			frame2.Active = false
			frame2.Size = UDim2.new(0, 13, 0, 13)
			frame2.Position = UDim2.new(0, 1, 0, 1)
			frame2.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
			frame2.BorderSizePixel = 0
			frame2.Parent = button
			local uicorner2 = Instance.new("UICorner")
			uicorner2.CornerRadius = UDim.new(0, 32)
			uicorner2.Parent = frame2
			local textlabel = Instance.new("TextLabel")
			textlabel.BackgroundTransparency = 1
			textlabel.Font = Enum.Font.SourceSans
			textlabel.Active = false
			textlabel.TextSize = 18
			textlabel.TextColor3 = Color3.new(1, 1, 1)
			textlabel.Size = UDim2.new(0, 140, 0, 24)
			textlabel.TextXAlignment = Enum.TextXAlignment.Left
			textlabel.Name = name
			textlabel.Text = "          "..name
			textlabel.Parent = frame
			buttonapi["Enabled"] = false
			buttonapi["Keybind"] = ""
			buttonapi["ToggleButton"] = function()
				buttonapi["Enabled"] = not buttonapi["Enabled"]
				if buttonapi["Enabled"] then
					button.BackgroundColor3 = Color3.fromHSV(api["Settings"]["GUIObject"]["Color"], 1, 1)
					frame2.Position = UDim2.new(0, 9, 0, 1)
					temporaryfunction()
				else
					button.BackgroundColor3 = Color3.fromRGB(89, 89, 89)
					frame2.Position = UDim2.new(0, 1, 0, 1)
					temporaryfunction2()
				end
			end
			button.MouseButton1Click:connect(buttonapi["ToggleButton"])
			api["ObjectsThatCanBeSaved"][naame..name.."Toggle"] = {["Type"] = "Toggle", ["Object"] = button, ["Api"] = buttonapi}

			return buttonapi
		end
		api["ObjectsThatCanBeSaved"][naame.."OptionsButton"] = {["Type"] = "OptionsButton", ["Object"] = button, ["Api"] = buttonapi}

		return buttonapi
	end

	windowapi["CreateSlider"] = function(name, min, max, temporaryfunction)
		local def = math.floor((min + max) / 2)
		local defsca = (def - min)/(max - min)
		local sliderapi = {}
		local amount = #children:GetChildren()
		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(0, 165, 0, 30)
		frame.BackgroundColor3 = Color3.fromRGB(29, 31, 32)
		frame.BackgroundTransparency = 0.1
		frame.LayoutOrder = amount
		frame.BorderSizePixel = 0
		frame.Name = name
		frame.Parent = children
		local textlabel = Instance.new("TextLabel")
		textlabel.Size = UDim2.new(0, 165, 0, 15)
		textlabel.BackgroundTransparency = 1
		textlabel.Font = Enum.Font.SourceSans
		textlabel.TextSize = 16
		textlabel.TextColor3 = Color3.new(1, 1, 1)
		textlabel.Text = " "..name
		textlabel.TextXAlignment = Enum.TextXAlignment.Left
		textlabel.Parent = frame
		local textlabel2 = Instance.new("TextLabel")
		textlabel2.Size = UDim2.new(0, 165, 0, 15)
		textlabel2.BackgroundTransparency = 1
		textlabel2.Font = Enum.Font.SourceSans
		textlabel2.TextSize = 16
		textlabel2.TextColor3 = Color3.new(1, 1, 1)
		textlabel2.Text = "0".." "
		textlabel2.TextXAlignment = Enum.TextXAlignment.Right
		textlabel2.Parent = frame
		local slider1 = Instance.new("Frame")
		slider1.Size = UDim2.new(0, 148, 0, 9)
		slider1.BackgroundColor3 = Color3.new(0, 0, 0)
		slider1.Position = UDim2.new(0, 8, 0, 18)
		slider1.Name = "Slider"
		slider1.Parent = frame
		local uicorner = Instance.new("UICorner")
		uicorner.CornerRadius = UDim.new(0, 32)
		uicorner.Parent = slider1
		local slider2 = Instance.new("Frame")
		slider2.Size = UDim2.new(0, 0, 1, 0)
		slider2.BackgroundColor3 = Color3.fromHSV(api["Settings"]["GUIObject"]["Color"], 1, 1)
		slider2.Name = "FillSlider"
		slider2.Parent = slider1
		local uicorner2 = Instance.new("UICorner")
		uicorner2.CornerRadius = UDim.new(0, 32)
		uicorner2.Parent = slider2
		local slider3 = Instance.new("TextButton")
		slider3.Size = UDim2.new(0, 12, 0, 12)
		slider3.Text = ""
		slider3.AutoButtonColor = false
		slider3.BackgroundColor3 = Color3.fromRGB(89, 89, 89)
		slider3.Position = UDim2.new(1, -6, 0, -2)
		slider3.Parent = slider2
		slider3.Name = "ButtonSlider"
		local uicorner3 = Instance.new("UICorner")
		uicorner3.CornerRadius = UDim.new(0, 32)
		uicorner3.Parent = slider3
		sliderapi["Value"] = 0
		sliderapi["SetValue"] = function(val)
			val = math.clamp(val, min, max)
			sliderapi["Value"] = val
			textlabel2.Text = sliderapi["Value"].." "
			temporaryfunction(val)
		end
		slider3.MouseButton1Down:Connect(function()
			local x,y,xscale,yscale = RelativeXY(slider1, game:GetService("UserInputService"):GetMouseLocation())
			sliderapi["SetValue"](math.floor(min + ((max - min) * xscale)))
			textlabel2.Text = sliderapi["Value"].." "
			slider2.Size = UDim2.new(xscale,0,1,0)
			
			local move
			local kill
			move = game:GetService("UserInputService").InputChanged:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement then
					local x,y,xscale,yscale = RelativeXY(slider1, game:GetService("UserInputService"):GetMouseLocation())
					sliderapi["SetValue"](math.floor(min + ((max - min) * xscale)))
					textlabel2.Text = sliderapi["Value"].." "
					
					slider2.Size = UDim2.new(xscale,0,1,0)
				end
			end)
			kill = game:GetService("UserInputService").InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					capturedslider = {["Type"] = "Slider", ["Object"] = frame, ["Api"] = sliderapi}
					move:Disconnect()
					kill:Disconnect()
				end
			end)
		end)
		api["ObjectsThatCanBeSaved"][name.."Slider"] = {["Type"] = "Slider", ["Object"] = frame, ["Api"] = sliderapi}

		return sliderapi
	end

	windowapi["CreateColorSlider"] = function(name, temporaryfunction)
		local min, max = 0, 1
		local def = math.floor((min + max) / 2)
		local defsca = (def - min)/(max - min)
		local click = false
		local sliderapi = {}
		local amount = #children:GetChildren()
		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(0, 165, 0, 30)
		frame.BackgroundColor3 = Color3.fromRGB(29, 31, 32)
		frame.BackgroundTransparency = 0.1
		frame.BorderSizePixel = 0
		frame.Name = name
		frame.LayoutOrder = amount
		frame.Parent = children
		local textlabel = Instance.new("TextLabel")
		textlabel.Size = UDim2.new(0, 165, 0, 15)
		textlabel.BackgroundTransparency = 1
		textlabel.Font = Enum.Font.SourceSans
		textlabel.TextSize = 16
		textlabel.TextColor3 = Color3.new(1, 1, 1)
		textlabel.Text = name
		textlabel.Parent = frame
		local slider1 = Instance.new("TextButton")
		slider1.Size = UDim2.new(0, 159, 0, 14)
		slider1.BackgroundColor3 = Color3.new(1, 1, 1)
		slider1.AutoButtonColor = false
		slider1.Text = ""
		slider1.BorderSizePixel = 0
		slider1.Position = UDim2.new(0, 3, 0, 16)
		slider1.Name = "Slider"
		slider1.Parent = frame
		local uigradient = Instance.new("UIGradient")
		uigradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 1, 1)), ColorSequenceKeypoint.new(0.1, Color3.fromHSV(0.1, 1, 1)), ColorSequenceKeypoint.new(0.2, Color3.fromHSV(0.2, 1, 1)), ColorSequenceKeypoint.new(0.3, Color3.fromHSV(0.3, 1, 1)), ColorSequenceKeypoint.new(0.4, Color3.fromHSV(0.4, 1, 1)), ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5, 1, 1)), ColorSequenceKeypoint.new(0.6, Color3.fromHSV(0.6, 1, 1)), ColorSequenceKeypoint.new(0.7, Color3.fromHSV(0.7, 1, 1)), ColorSequenceKeypoint.new(0.8, Color3.fromHSV(0.8, 1, 1)), ColorSequenceKeypoint.new(0.9, Color3.fromHSV(0.9, 1, 1)), ColorSequenceKeypoint.new(1, Color3.fromHSV(1, 1, 1))})
		uigradient.Parent = slider1
		local slider3 = Instance.new("Frame")
		slider3.Size = UDim2.new(0, 2, 0, 15)
		slider3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		slider3.Position = UDim2.new(0.44,-1,0,0)
		slider3.Parent = slider1
		slider3.BorderSizePixel = 0
		slider3.Name = "ButtonSlider"
		sliderapi["Value"] = 0.44
		sliderapi["RainbowValue"] = false
		sliderapi["SetValue"] = function(val)
			val = math.clamp(val, min, max)
			sliderapi["Value"] = val
			slider3.Position = UDim2.new(val, -1, 0, 0)
			temporaryfunction(val)
		end
		sliderapi["SetRainbow"] = function(val)
			sliderapi["RainbowValue"] = val
			if sliderapi["RainbowValue"] then
				local heh
				heh = coroutine.resume(coroutine.create(function()
					repeat
						wait()
						if sliderapi["RainbowValue"] then
							sliderapi["SetValue"](rainbowvalue)
						else
							coroutine.yield(heh)
						end
					until sliderapi["RainbowValue"] == false
				end))
			end
		end
		slider1.MouseButton1Down:Connect(function()
			spawn(function()
				click = true
				wait(0.3)
				click = false
			end)
			if click then
				sliderapi["SetRainbow"](not sliderapi["RainbowValue"])
			end
			local x,y,xscale,yscale = RelativeXY(slider1, game:GetService("UserInputService"):GetMouseLocation())
			sliderapi["SetValue"](min + ((max - min) * xscale))
			slider3.Position = UDim2.new(xscale, -1, 0, 0)
			local move
			local kill
			move = game:GetService("UserInputService").InputChanged:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement then
					local x,y,xscale,yscale = RelativeXY(slider1, game:GetService("UserInputService"):GetMouseLocation())
					sliderapi["SetValue"](min + ((max - min) * xscale))
				end
			end)
			kill = game:GetService("UserInputService").InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					capturedslider = {["Type"] = "ColorSlider", ["Object"] = frame, ["Api"] = sliderapi}
					move:Disconnect()
					kill:Disconnect()
				end
			end)
		end)
		api["ObjectsThatCanBeSaved"][name.."SliderColor"] = {["Type"] = "ColorSlider", ["Object"] = frame, ["Api"] = sliderapi}

		return sliderapi
	end

	windowapi["CreateTextList"] = function(name, temptext, temporaryfunction, temporaryfunction2)
		local textapi = {}
		local amount = #children:GetChildren()
		local frame = Instance.new("Frame")
		frame.BackgroundColor3 = Color3.fromRGB(29, 31, 32)
		frame.BorderSizePixel = 0
		frame.BackgroundTransparency = 0.1
		frame.LayoutOrder = amount
		frame.Size = UDim2.new(0, 165, 0, 29)
		frame.Name = name
		frame.Visible = true
		frame.Parent = children
		local frame2 = Instance.new("Frame")
		frame2.Size = UDim2.new(0, 115, 0, 24)
		frame2.Position = UDim2.new(0, 4, 0, 4)
		frame2.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		frame2.BackgroundTransparency = 0.275
		frame2.BorderSizePixel = 0
		frame2.Parent = frame
		local textbox = Instance.new("TextBox")
		textbox.BackgroundTransparency = 1
		textbox.TextSize = 20
		textbox.Font = Enum.Font.SourceSans
		textbox.PlaceholderText = temptext
		textbox.Text = ""
		textbox.TextColor3 = Color3.new(1, 1, 1)
		textbox.PlaceholderColor3 = Color3.fromRGB(200, 200, 200)
		textbox.Size = UDim2.new(1, -8, 1, 0)
		textbox.Position = UDim2.new(0, 8, 0, 0)
		textbox.TextXAlignment = Enum.TextXAlignment.Left
		textbox.Parent = frame2
		local addbutton = Instance.new("TextButton")
		addbutton.Size = UDim2.new(0, 46, 0, 24)
		addbutton.Position = UDim2.new(1, -46, 0, 4)
		addbutton.TextSize = 22
		addbutton.Text = "Add"
		addbutton.BackgroundTransparency = 1
		addbutton.Font = Enum.Font.SourceSans
		addbutton.TextColor3 = Color3.new(1, 1, 1)
		addbutton.Parent = frame
		local scrollframe = Instance.new("ScrollingFrame")
		scrollframe.BackgroundColor3 = Color3.fromRGB(29, 31, 32)
		scrollframe.BorderSizePixel = 0
		scrollframe.ZIndex = 2
		scrollframe.Size = UDim2.new(0, 165, 0, 0)
		scrollframe.BackgroundTransparency = 0.1
		scrollframe.ScrollBarThickness = 0
		scrollframe.ScrollBarImageColor3 = Color3.new(0, 0, 0)
		scrollframe.LayoutOrder = amount
		scrollframe.Parent = children
		local uilistlayout3 = Instance.new("UIListLayout")
		uilistlayout3.Parent = scrollframe
		uilistlayout3:GetPropertyChangedSignal("AbsoluteContentSize"):connect(function()
			scrollframe.CanvasSize = UDim2.new(0, 0, 0, uilistlayout3.AbsoluteContentSize.Y)
			scrollframe.Size = UDim2.new(1, 0, 0, math.clamp(uilistlayout3.AbsoluteContentSize.Y, 1, 120))
		end)

		textapi["RefreshValues"] = function(tab)
			for i2,v2 in pairs(scrollframe:GetChildren()) do
				if v2:IsA("TextLabel") then v2:Remove() end
			end
			for i,v in pairs(tab) do
				local label = Instance.new("TextLabel")
				label.Font = Enum.Font.SourceSans
				label.TextSize = 18
				label.Size = UDim2.new(0, 165, 0, 20)
				label.Text = " "..v
				label.ZIndex = 2
				label.TextColor3 = Color3.new(1, 1, 1)
				label.TextXAlignment = Enum.TextXAlignment.Left
				label.Parent = scrollframe
				label.BackgroundTransparency = 1
				local deletebutton = Instance.new("TextButton")
				deletebutton.Size = UDim2.new(0, 20, 0, 20)
				deletebutton.BackgroundTransparency = 1
				deletebutton.TextColor3 = Color3.new(1, 1, 1)
				deletebutton.Font = Enum.Font.SourceSans
				deletebutton.TextSize = 18
				deletebutton.ZIndex = 2
				deletebutton.Text = "X"
				deletebutton.Position = UDim2.new(1, -20, 0, 0)
				deletebutton.Parent = label
				deletebutton.MouseButton1Click:connect(function()
					temporaryfunction2(i)
				end)
			end
		end

		addbutton.MouseButton1Click:connect(function() temporaryfunction(textbox.Text) end)

		return textapi
	end

	windowapi["CreateToggle"] = function(name, temporaryfunction, temporaryfunction2, goback)
		local buttonapi = {}
		local amount = #children:GetChildren()
		local frame = Instance.new("Frame")
		frame.BackgroundColor3 = Color3.fromRGB(29, 31, 32)
		frame.BorderSizePixel = 0
		frame.BackgroundTransparency = 0.1
		frame.LayoutOrder = amount
		frame.Size = UDim2.new(0, 165, 0, 26)
		frame.Name = name
		frame.Visible = true
		frame.Parent = children
		local button = Instance.new("TextButton")
		button.Name = "Toggle"
		button.AutoButtonColor = false
		button.Text = ""
		button.BackgroundColor3 = Color3.fromRGB(89, 89, 89)
		button.BorderSizePixel = 0
		button.Size = UDim2.new(0, 23, 0, 15)
		button.Position = UDim2.new(0, 4, 0, 5)
		button.Parent = frame
		local uicorner = Instance.new("UICorner")
		uicorner.CornerRadius = UDim.new(0, 32)
		uicorner.Parent = button
		local frame2 = Instance.new("Frame")
		frame2.Active = false
		frame2.Size = UDim2.new(0, 13, 0, 13)
		frame2.Position = UDim2.new(0, 1, 0, 1)
		frame2.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
		frame2.BorderSizePixel = 0
		frame2.Parent = button
		local uicorner2 = Instance.new("UICorner")
		uicorner2.CornerRadius = UDim.new(0, 32)
		uicorner2.Parent = frame2
		local textlabel = Instance.new("TextLabel")
		textlabel.BackgroundTransparency = 1
		textlabel.Font = Enum.Font.SourceSans
		textlabel.Active = false
		textlabel.TextSize = 18
		textlabel.TextColor3 = Color3.new(1, 1, 1)
		textlabel.Size = UDim2.new(0, 140, 0, 24)
		textlabel.TextXAlignment = Enum.TextXAlignment.Left
		textlabel.Name = name
		textlabel.Text = "          "..name
		textlabel.Parent = frame
		buttonapi["Enabled"] = false
		buttonapi["Keybind"] = ""
		buttonapi["ToggleButton"] = function()
			if goback and buttonapi["Enabled"] == false or (not goback) then
				buttonapi["Enabled"] = not buttonapi["Enabled"]
				if buttonapi["Enabled"] then
					button.BackgroundColor3 = Color3.fromHSV(api["Settings"]["GUIObject"]["Color"], 1, 1)
					frame2.Position = UDim2.new(0, 9, 0, 1)
					temporaryfunction()
				else
					button.BackgroundColor3 = Color3.fromRGB(89, 89, 89)
					frame2.Position = UDim2.new(0, 1, 0, 1)
					temporaryfunction2()
				end
			end
		end
		button.MouseButton1Click:connect(buttonapi["ToggleButton"])
		api["ObjectsThatCanBeSaved"][name.."Toggle"] = {["Type"] = "Toggle", ["Object"] = button, ["Api"] = buttonapi}

		return buttonapi
	end

	return windowapi
end

api["UpdateUI"] = function()
	for i,v in pairs(api["ObjectsThatCanBeSaved"]) do
		if v["Type"] == "Button" and v["Api"]["Enabled"] then
			v["Object"].BackgroundColor3 = Color3.fromHSV(api["Settings"]["GUIObject"]["Color"], 1, 1)
			v["Object"].TextColor3 = Color3.new(0, 0, 0)
		end
		if v["Type"] == "OptionsButton" then
			if v["Api"]["Enabled"] then
				v["Object"].BackgroundColor3 = Color3.fromHSV(api["Settings"]["GUIObject"]["Color"], 1, 1)
				v["Object"].TextColor3 = Color3.new(0, 0, 0)
			end
		end
		if v["Type"] == "Toggle" and v["Api"]["Enabled"] then
			v["Object"].BackgroundColor3 = Color3.fromHSV(api["Settings"]["GUIObject"]["Color"], 1, 1)
			v["Object"].Frame.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
		end
		if v["Type"] == "Slider" then
			v["Object"].Slider.FillSlider.BackgroundColor3 = Color3.fromHSV(api["Settings"]["GUIObject"]["Color"], 1, 1)
		end
	end
end

api["MainBlur"] = Instance.new("BlurEffect")
api["MainBlur"].Size = 0
api["MainBlur"].Parent = game:GetService("Lighting")
api["MainBlur"].Enabled = false
api["MainRescale"] = Instance.new("UIScale")
api["MainRescale"].Parent = clickgui

CreateTopBarOption("Toggle", "Auto-load module states", function() end, function() end, false)
CreateTopBarOption("Toggle", "Blur Background", function() api["MainBlur"].Size = 25 end, function() api["MainBlur"].Size = 0 end, true)
local rescale = CreateTopBarOption("Toggle", "Rescale", function() 
	api["MainRescale"].Scale = cam.ViewportSize.X / 1920
end, function()
	api["MainRescale"].Scale = 1 
end, true)
cam:GetPropertyChangedSignal("ViewportSize"):connect(function()
	if rescale["Enabled"] then
		api["MainRescale"].Scale = cam.ViewportSize.X / 1920
	end
end)
CreateTopBarOption("Toggle", "Enable Multi-Keybinding", function() end, function() end, false)
local welcomemsg = CreateTopBarOption("Toggle", "GUI bind indicator", function() end, function() end, true)
CreateTopBarOption("Toggle", "Smooth font", function()
	for i,v in pairs(api["MainGui"]:GetDescendants()) do
		if (v:IsA("TextLabel") or v:IsA("TextButton")) and v.Name ~= "IconLabel" then
			v.Font = Enum.Font.SourceSans
		end
	end
	for i2,v2 in pairs(api["ObjectsThatCanBeSaved"]) do
		if v2["Type"] == "NewToggle" then
			v2["Object"].Parent:GetChildren()[2].Text = "                "..v2["Object"].Parent:GetChildren()[2].Name
		end
		if v2["Type"] == "NewButton" then
			v2["Object"].Text = v2["Object"].TextXAlignment == Enum.TextXAlignment.Left and "    "..v2["Object"].Name or v2["Object"].Name
		end
		if v2["Type"] == "Toggle" then
			v2["Object"].Parent:GetChildren()[2].Text = "          "..v2["Object"].Parent:GetChildren()[2].Name
		end
	end
end, function() 
	for i,v in pairs(api["MainGui"]:GetDescendants()) do
		if (v:IsA("TextLabel") or v:IsA("TextButton")) and v.Name ~= "IconLabel" then
			v.Font = Enum.Font.Sarpanch
		end
	end
	for i2,v2 in pairs(api["ObjectsThatCanBeSaved"]) do
		if v2["Type"] == "NewToggle" then
			v2["Object"].Parent:GetChildren()[2].Text = "           "..v2["Object"].Parent:GetChildren()[2].Name
		end
		if v2["Type"] == "NewButton" then
			v2["Object"].Text = v2["Object"].TextXAlignment == Enum.TextXAlignment.Left and "   "..v2["Object"].Name or v2["Object"].Name
		end
		if v2["Type"] == "Toggle" then
			v2["Object"].Parent:GetChildren()[2].Text = "       "..v2["Object"].Parent:GetChildren()[2].Name
		end
	end
end, true)
CreateTopBarOption("Toggle", "Show Tooltips", function() end, function() end, true)
CreateTopBarOption("Toggle", "Discord integration", function() end, function() end, false)
CreateTopBarOption("Toggle", "Notifications", function() end, function() end, true)
CreateTopBarOption("Button", "Reset current profile", function()
	for i,v in pairs(api["ObjectsThatCanBeSaved"]) do
		if (v["Type"] == "Button" or v["Type"] == "OptionsButton" or v["Type"] == "Toggle") and v["Api"]["Enabled"] then
			v["Api"]["ToggleButton"](false)
			if v["Type"] == "OptionsButton" and v["Api"]["Expanded"] then
				v["Api"]["ToggleExpanded"]()
			end
		end
		if v["Type"] == "NewToggle" then
			v["Api"]["ToggleButton"](v["Api"]["Default"])
		end
		if v["Type"] == "Dropdown" then
			v["Api"]["SetValue"](v["Api"]["Default"])
		end
		if v["Type"] == "Slider" then
			v["Object"].Slider.FillSlider.Size = UDim2.new(0, 0, 1, 0)
			v["Api"]["SetValue"](0)
		end
		if v["Type"] == "ColorSlider" then
			v["Api"]["SetValue"](0.44)
			v["Api"]["SetRainbow"](false)
		end
		if v["Type"] == "CustomWindow" then
			if v["Api"]["Pinned"] then
				v["Api"]["PinnedToggle"]()
			end
		end
		if i ~= "GUIWindow" then
			if v["Type"]:match("Window") then
				v["Object"].Position = UDim2.new(0, 177, 0, 6)
				if v["Api"]["Expanded"] then
					v["Api"]["ExpandToggle"]()
				end
			end
		else
			v["Object"].Position = UDim2.new(0, 6, 0, 6)
		end
	end
end)
CreateTopBarOption("Button", "Reset GUI positions", function() end)
CreateTopBarOption("Button", "Sort GUI", function()
	local tableofmodules = {}
	local pos = UDim2.new(0, 6, 0, 6)
	for i,v in pairs(api["ObjectsThatCanBeSaved"]) do
		if v["Type"]:match("Window") and v["Object"].Visible then
			table.insert(tableofmodules, v["Object"])
		end
	end
	table.sort(tableofmodules, function(a, b) return (a.Children:FindFirstChild("UIListLayout") and a.Children.UIListLayout.AbsoluteContentSize.Y or a.Children.AbsoluteSize.Y) > (b.Children:FindFirstChild("UIListLayout") and b.Children.UIListLayout.AbsoluteContentSize.Y or b.Children.AbsoluteSize.Y) end)
	for i2,v2 in pairs(tableofmodules) do
		v2.Position = pos
		pos = UDim2.new(pos.X.Scale, pos.X.Offset + (v2.Size.X.Offset + 6), pos.Y.Scale, pos.Y.Offset)
	end
end)
CreateTopBarOption("Button", "Edit GUI", function() end)
--over engieneering in a nutshell
local RebindFunc = function() end
local RebindGUI = CreateTopBarOption("GUIButton", "Rebind GUI", function()
	RebindFunc()
end)
RebindFunc = function()
	if holdingshift then
		if captured == false then
			captured = true
			spawn(function()
				local button = RebindGUI["Object"]
				button.Text = "Press a key"
				repeat wait() until pressedkey ~= ""
				api["Settings"]["GUIObject"]["GUIKeybind"] = pressedkey
				pressedkey = ""
				button.Text = "Bound to "..api["Settings"]["GUIObject"]["GUIKeybind"]
				captured = false
				wait(1)
				button.Text = "Rebind GUI"
			end)
		end
	end
end

api["LoadedAnimation"] = function()
	if welcomemsg["Enabled"] then
		local welcomeguitext = Instance.new("TextLabel")
		welcomeguitext.Name = "WelcomeText"
		welcomeguitext.Size = UDim2.new(0, 230, 0, 25)
		welcomeguitext.TextXAlignment = Enum.TextXAlignment.Left
		welcomeguitext.Position = UDim2.new(0, 2, 0.05, 1)
		welcomeguitext.BackgroundTransparency = 1
		welcomeguitext.TextSize = 25
		welcomeguitext.Text = "Press "..api["Settings"]["GUIObject"]["GUIKeybind"].." to open GUI"
		welcomeguitext.TextColor3 = Color3.fromRGB(27, 42, 53)
		welcomeguitext.Font = Enum.Font.SourceSans
		welcomeguitext.Parent = api["MainGui"]
		local welcomeguitext2 = welcomeguitext:Clone()
		welcomeguitext2.Position = UDim2.new(0, -1, 0, -1)
		welcomeguitext2.TextColor3 = Color3.fromRGB(0, 219, 180)
		welcomeguitext2:GetPropertyChangedSignal("TextTransparency"):connect(function()
			welcomeguitext.TextTransparency = welcomeguitext2.TextTransparency
		end)
		welcomeguitext2.Parent = welcomeguitext
		local welcomeframe = Instance.new("Frame")
		welcomeframe.Name = "WelcomeFrame"
		welcomeframe.Size = UDim2.new(0, 232, 0, 41)
		welcomeframe.BackgroundTransparency = 0.1
		welcomeframe.BackgroundColor3 = Color3.fromRGB(34, 35, 38)
		welcomeframe.BorderSizePixel = 0
		welcomeframe.Position = UDim2.new(1, 0, 0.9, -40)
		welcomeframe.Parent = api["MainGui"]
		local welcomeicon = Instance.new("TextLabel")
		welcomeicon.Name = "WelcomeIcon"
		welcomeicon.BackgroundTransparency = 1
		welcomeicon.TextSize = 28
		welcomeicon.Text = "ℹ️"
		welcomeicon.Position = UDim2.new(0, 1, 0, 2)
		welcomeicon.Size = UDim2.new(0, 30, 0, 36)
		welcomeicon.Font = Enum.Font.SourceSans
		welcomeicon.Parent = welcomeframe
		local welcometext = Instance.new("TextLabel")
		welcometext.Name = "WelcomeText"
		welcometext.BackgroundTransparency = 1
		welcometext.TextSize = 21 - (api["Settings"]["GUIObject"]["GUIKeybind"]:len() > 5 and 4 or 0)
		welcometext.Text = "Finished Loading\nPress "..string.upper(api["Settings"]["GUIObject"]["GUIKeybind"]).." to open GUI"
		welcometext.Position = UDim2.new(0, 32, 0, (api["Settings"]["GUIObject"]["GUIKeybind"]:len() > 5 and -1 or -3))
		welcometext.Size = UDim2.new(0, 232, 0, 39)
		welcometext.Font = Enum.Font.SourceSans
		welcometext.TextXAlignment = Enum.TextXAlignment.Left
		welcometext.TextYAlignment = Enum.TextYAlignment.Top
		welcometext.TextColor3 = Color3.new(1, 1, 1)
		welcometext.Parent = welcomeframe
		local welcomebar = Instance.new("Frame")
		welcomebar.Name = "WelcomeTimeBar"
		welcomebar.Size = UDim2.new(1, 0, 0, 2)
		welcomebar.Position = UDim2.new(0, 0, 1, -2)
		welcomebar.BorderSizePixel = 0
		welcomebar.BackgroundColor3 = Color3.new(1, 1, 1)
		welcomebar.BackgroundTransparency = 0.1
		welcomebar.Parent = welcomeframe
		spawn(function()
			pcall(function()
				wait(2.5)
				game:GetService("TweenService"):Create(welcomeguitext2, TweenInfo.new(2), {TextTransparency = 1}):Play()
				wait(2)
				welcomeguitext:Remove()
			end)
		end)
		spawn(function()
			pcall(function()
				welcomeframe:TweenPosition(UDim2.new(1, -232, 0.9, -40), Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.5)
				wait(0.5)
				welcomebar:TweenSize(UDim2.new(0, 0, 0, 2), Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 4)
				wait(4)
				welcomeframe:TweenPosition(UDim2.new(1, 0, 0.9, -40), Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.5)
				wait(0.5)
				welcomeframe:Remove()
			end)
		end)
	end
end

local holdingcontrol = false

api["KeyInputHandler"] = game:GetService("UserInputService").InputBegan:connect(function(input1)
	if game:GetService("UserInputService"):GetFocusedTextBox() == nil then
		if input1.KeyCode == Enum.KeyCode[api["Settings"]["GUIObject"]["GUIKeybind"]] then
			clickgui.Visible = not clickgui.Visible
			api["MainBlur"].Enabled = clickgui.Visible
		end
		if input1.KeyCode == Enum.KeyCode.LeftShift then
			holdingshift = true
		end
		if input1.KeyCode == Enum.KeyCode.LeftControl then
			holdingcontrol = true
		end
		if input1.UserInputType == Enum.UserInputType.MouseButton3 and api["FriendsObject"]["MiddleClickFriends"] then
			if mouse.Target.Parent:FindFirstChild("HumanoidRootPart") or mouse.Target.Parent:IsA("Accessory") and mouse.Target.Parent.Parent:FindFirstChild("HumanoidRootPart") then
				api["FriendsObject"]["MiddleClickFunc"](mouse.Target.Parent:IsA("Accessory") and mouse.Target.Parent.Parent.Name or mouse.Target.Parent.Name)
			end
		end
		if holdingcontrol and (input1.KeyCode == Enum.KeyCode.Left or input1.KeyCode == Enum.KeyCode.Right) and capturedslider ~= nil then
			if capturedslider["Type"] == "Slider" then
				capturedslider["Api"]["SetValue"](capturedslider["Api"]["Value"] + (input1.KeyCode == Enum.KeyCode.Left and -1 or 1))
			end
			if capturedslider["Type"] == "ColorSlider" then
				capturedslider["Api"]["SetValue"](capturedslider["Api"]["Value"] + (input1.KeyCode == Enum.KeyCode.Left and -0.01 or 0.01))
			end
		end
		if captured and input1.KeyCode ~= Enum.KeyCode.LeftShift then
			local hah = string.gsub(tostring(input1.KeyCode), "Enum.KeyCode.", "")
			pressedkey = hah
		end
		for modules,aapi in pairs(api["ObjectsThatCanBeSaved"]) do
			if (aapi["Type"] == "OptionsButton" or aapi["Type"] == "Button") and (aapi["Api"]["Keybind"] ~= nil and aapi["Api"]["Keybind"] ~= "") then
				if input1.KeyCode == Enum.KeyCode[aapi["Api"]["Keybind"]] and aapi["Api"]["Keybind"] ~= api["Settings"]["GUIObject"]["GUIKeybind"] then
					aapi["Api"]["ToggleButton"](false)
				end
			end
		end
	end
end)

api["KeyInputHandler2"] = game:GetService("UserInputService").InputEnded:connect(function(input1)
	if input1.KeyCode == Enum.KeyCode.LeftShift then
		holdingshift = false
	end
	if input1.KeyCode == Enum.KeyCode.LeftControl then
		holdingcontrol = false
	end
end)

return api