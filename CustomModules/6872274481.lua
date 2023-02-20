--[[ 
	Credits
	Infinite Yield - Blink
	DevForum - lots of rotation math because I hate it
	Please notify me if you need credits
]]
local GuiLibrary = shared.GuiLibrary
local players = game:GetService("Players")
local textservice = game:GetService("TextService")
local repstorage = game:GetService("ReplicatedStorage")
local lplr = players.LocalPlayer
local lighting = game:GetService("Lighting")
local cam = workspace.CurrentCamera
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
	cam = (workspace.CurrentCamera or workspace:FindFirstChild("Camera") or Instance.new("Camera"))
end)
local targetinfo = shared.VapeTargetInfo
local collectionservice = game:GetService("CollectionService")
local uis = game:GetService("UserInputService")
local mouse = lplr:GetMouse()
local bedwars = {}
local bedwarsblocks = {}
local blockraycast = RaycastParams.new()
blockraycast.FilterType = Enum.RaycastFilterType.Whitelist
local getfunctions
local oldchar
local oldcloneroot
local matchState = 0
local kit = ""
local antivoidypos = 0
local kills = 0
local beds = 0
local reported = 0
local lagbacks = 0
local otherlagbacks = 0
local matchstatetick = 0
local lagbackevent = Instance.new("BindableEvent")
local allowspeed = true
local antivoiding = false
local textchatservice = game:GetService("TextChatService")
local betterisfile = function(file)
	local suc, res = pcall(function() return readfile(file) end)
	return suc and res ~= nil
end
local requestfunc = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or request or function(tab)
	if tab.Method == "GET" then
		return {
			Body = game:HttpGet(tab.Url, true),
			Headers = {},
			StatusCode = 200
		}
	else
		return {
			Body = "bad exploit",
			Headers = {},
			StatusCode = 404
		}
	end
end 
local queueteleport = syn and syn.queue_on_teleport or queue_on_teleport
local getasset = getsynasset or getcustomasset or function(location) return "rbxasset://"..location end
local storedshahashes = {}
local blocktable
local inventories = {}
local currentinventory = {
	inventory = {
		items = {},
		armor = {},
		hand = nil
	}
}
local Reach = {Enabled = false}
local Killaura = {Enabled = false}
local flyspeed = {Value = 40}
local nobob = {Enabled = false}
local AnticheatBypass = {Enabled = false}
local AnticheatBypassCombatCheck = {Enabled = false}
local combatcheck = false
local combatchecktick = tick()
local disabletpcheck = false
local queueType = "bedwars_test"
local FastConsume = {Enabled = false}
local oldchanneltab
local oldchannelfunc
local oldchanneltabs = {}
local connectionstodisconnect = {}
local anticheatfunnyyes = false
local tpstring
local networkownertick = tick()
local isnetworkowner = isnetworkowner or function(part)
	if gethiddenproperty(part, "NetworkOwnershipRule") == Enum.NetworkOwnership.Manual then 
		sethiddenproperty(part, "NetworkOwnershipRule", Enum.NetworkOwnership.Automatic)
		networkownertick = tick() + 8
	end
	return networkownertick <= tick()
end
local uninjectflag = false
local clients = {
	ChatStrings1 = {
		["KVOP25KYFPPP4"] = "vape",
		["IO12GP56P4LGR"] = "future",
		["RQYBPTYNURYZC"] = "rektsky"
	},
	ChatStrings2 = {
		["vape"] = "KVOP25KYFPPP4",
		["future"] = "IO12GP56P4LGR",
		["rektsky"] = "RQYBPTYNURYZC"
	},
	ClientUsers = {}
}
local entityLibrary = shared.vapeentity
local WhitelistFunctions = shared.vapewhitelist
local AnticheatBypassNumbers = {
	TPSpeed = 0.1,
	TPCombat = 0.3,
	TPLerp = 0.39,
	TPCheck = 15
}

local RunLoops = {RenderStepTable = {}, StepTable = {}, HeartTable = {}}
do
	function RunLoops:BindToRenderStep(name, num, func)
		if RunLoops.RenderStepTable[name] == nil then
			RunLoops.RenderStepTable[name] = game:GetService("RunService").RenderStepped:Connect(func)
		end
	end

	function RunLoops:UnbindFromRenderStep(name)
		if RunLoops.RenderStepTable[name] then
			RunLoops.RenderStepTable[name]:Disconnect()
			RunLoops.RenderStepTable[name] = nil
		end
	end

	function RunLoops:BindToStepped(name, num, func)
		if RunLoops.StepTable[name] == nil then
			RunLoops.StepTable[name] = game:GetService("RunService").Stepped:Connect(func)
		end
	end

	function RunLoops:UnbindFromStepped(name)
		if RunLoops.StepTable[name] then
			RunLoops.StepTable[name]:Disconnect()
			RunLoops.StepTable[name] = nil
		end
	end

	function RunLoops:BindToHeartbeat(name, num, func)
		if RunLoops.HeartTable[name] == nil then
			RunLoops.HeartTable[name] = game:GetService("RunService").Heartbeat:Connect(func)
		end
	end

	function RunLoops:UnbindFromHeartbeat(name)
		if RunLoops.HeartTable[name] then
			RunLoops.HeartTable[name]:Disconnect()
			RunLoops.HeartTable[name] = nil
		end
	end
end


local function LaunchAngle(v: number, g: number, d: number, h: number, higherArc: boolean)
	local v2 = v * v
	local v4 = v2 * v2
	local root = math.sqrt(v4 - g*(g*d*d + 2*h*v2))
	if not higherArc then root = -root end
	return math.atan((v2 + root) / (g * d))
end

local function LaunchDirection(start, target, v, g, higherArc: boolean)
	-- get the direction flattened:
	local horizontal = Vector3.new(target.X - start.X, 0, target.Z - start.Z)
	
	local h = target.Y - start.Y
	local d = horizontal.Magnitude
	local a = LaunchAngle(v, g, d, h, higherArc)
	
	-- NaN ~= NaN, computation couldn't be done (e.g. because it's too far to launch)
	if a ~= a then 
		return g == 0 and (target - start).Unit * v
	end
	
	-- speed if we were just launching at a flat angle:
	local vec = horizontal.Unit * v
	
	-- rotate around the axis perpendicular to that direction...
	local rotAxis = Vector3.new(-horizontal.Z, 0, horizontal.X)
	
	-- ...by the angle amount
	return CFrame.fromAxisAngle(rotAxis, a) * vec
end

local function predictGravity(pos, vel, mag, targetPart, Gravity)
	local newVelocity = vel.Y
	local rootSize = (targetPart.Humanoid.HipHeight + (targetPart.RootPart.Size.Y / 2))
	local check = (tick() - targetPart.JumpTick) < 0.4
	for i = 1, math.floor(mag / 0.016)  do 
		if check then 
			newVelocity = newVelocity - (Gravity * 0.016)
		end
		local floorDetection = workspace:Raycast(pos, Vector3.new(vel.X * 0.016, (newVelocity * 0.016) - rootSize, vel.Z * 0.016), blockraycast)
		if floorDetection then 
			pos = Vector3.new(pos.X, floorDetection.Position.Y + rootSize, pos.Z)
			newVelocity = targetPart.Jumping and targetPart.Humanoid.JumpPower or 0
		end
		pos = pos + Vector3.new(vel.X * 0.016, newVelocity * 0.016, vel.Z * 0.016)
	end
	return pos, Vector3.new(0, 0, 0)
end

local function replaceYLevel(cframe, newylevel)
	local x, y, z, R00, R01, R02, R10, R11, R12, R20, R21, R22 = cframe:GetComponents()
	return CFrame.new(x, newylevel, z, R00, R01, R02, R10, R11, R12, R20, R21, R22)
end

local function runcode(func)
	func()
end

runcode(function()
	local textlabel = Instance.new("TextLabel")
	textlabel.Size = UDim2.new(1, 0, 0, 36)
	textlabel.Text = "Moderators can ban you at any time, Always use alts."
	textlabel.BackgroundTransparency = 1
	textlabel.ZIndex = 10
	textlabel.TextStrokeTransparency = 0
	textlabel.TextScaled = true
	textlabel.Font = Enum.Font.SourceSans
	textlabel.TextColor3 = Color3.new(1, 1, 1)
	textlabel.Position = UDim2.new(0, 0, 0, -36)
	textlabel.Parent = GuiLibrary["MainGui"].ScaledGui.ClickGui
	task.spawn(function()
		repeat task.wait() until matchState ~= 0
		textlabel:Destroy()
	end)
end)

local cachedassets = {}
local function getcustomassetfunc(path)
	if not betterisfile(path) then
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
			textlabel.Parent = GuiLibrary["MainGui"]
			repeat task.wait() until betterisfile(path)
			textlabel:Destroy()
		end)
		local req = requestfunc({
			Url = "https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/"..path:gsub("vape/assets", "assets"),
			Method = "GET"
		})
		writefile(path, req.Body)
	end
	if cachedassets[path] == nil then
		cachedassets[path] = getasset(path) 
	end
	return cachedassets[path]
end

local function CreateAutoHotbarGUI(children2, argstable)
	local buttonapi = {}
	buttonapi["Hotbars"] = {}
	buttonapi["CurrentlySelected"] = 1
	local currentanim
	local amount = #children2:GetChildren()
	local sortableitems = {
		{itemType = "swords", itemDisplayType = "diamond_sword"},
		{itemType = "pickaxes", itemDisplayType = "diamond_pickaxe"},
		{itemType = "axes", itemDisplayType = "diamond_axe"},
		{itemType = "shears", itemDisplayType = "shears"},
		{itemType = "wool", itemDisplayType = "wool_white"},
		{itemType = "iron", itemDisplayType = "iron"},
		{itemType = "diamond", itemDisplayType = "diamond"},
		{itemType = "emerald", itemDisplayType = "emerald"},
		{itemType = "bows", itemDisplayType = "wood_bow"},
	}
	local items = bedwars.ItemTable
	if items then
		for i2,v2 in pairs(items) do
			if (i2:find("axe") == nil or i2:find("void")) and i2:find("bow") == nil and i2:find("shears") == nil and i2:find("wool") == nil and v2.sword == nil and v2.armor == nil and v2["dontGiveItem"] == nil and bedwars.ItemTable[i2] and bedwars.ItemTable[i2].image then
				table.insert(sortableitems, {itemType = i2, itemDisplayType = i2})
			end
		end
	end
	local buttontext = Instance.new("TextButton")
	buttontext.AutoButtonColor = false
	buttontext.BackgroundTransparency = 1
	buttontext.Name = "ButtonText"
	buttontext.Text = ""
	buttontext.Name = argstable["Name"]
	buttontext.LayoutOrder = 1
	buttontext.Size = UDim2.new(1, 0, 0, 40)
	buttontext.Active = false
	buttontext.TextColor3 = Color3.fromRGB(162, 162, 162)
	buttontext.TextSize = 17
	buttontext.Font = Enum.Font.SourceSans
	buttontext.Position = UDim2.new(0, 0, 0, 0)
	buttontext.Parent = children2
	local toggleframe2 = Instance.new("Frame")
	toggleframe2.Size = UDim2.new(0, 200, 0, 31)
	toggleframe2.Position = UDim2.new(0, 10, 0, 4)
	toggleframe2.BackgroundColor3 = Color3.fromRGB(38, 37, 38)
	toggleframe2.Name = "ToggleFrame2"
	toggleframe2.Parent = buttontext
	local toggleframe1 = Instance.new("Frame")
	toggleframe1.Size = UDim2.new(0, 198, 0, 29)
	toggleframe1.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
	toggleframe1.BorderSizePixel = 0
	toggleframe1.Name = "ToggleFrame1"
	toggleframe1.Position = UDim2.new(0, 1, 0, 1)
	toggleframe1.Parent = toggleframe2
	local addbutton = Instance.new("ImageLabel")
	addbutton.BackgroundTransparency = 1
	addbutton.Name = "AddButton"
	addbutton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	addbutton.Position = UDim2.new(0, 93, 0, 9)
	addbutton.Size = UDim2.new(0, 12, 0, 12)
	addbutton.ImageColor3 = Color3.fromRGB(5, 133, 104)
	addbutton.Image = getcustomassetfunc("vape/assets/AddItem.png")
	addbutton.Parent = toggleframe1
	local children3 = Instance.new("Frame")
	children3.Name = argstable["Name"].."Children"
	children3.BackgroundTransparency = 1
	children3.LayoutOrder = amount
	children3.Size = UDim2.new(0, 220, 0, 0)
	children3.Parent = children2
	local uilistlayout = Instance.new("UIListLayout")
	uilistlayout.Parent = children3
	uilistlayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		children3.Size = UDim2.new(1, 0, 0, uilistlayout.AbsoluteContentSize.Y)
	end)
	local uicorner = Instance.new("UICorner")
	uicorner.CornerRadius = UDim.new(0, 5)
	uicorner.Parent = toggleframe1
	local uicorner2 = Instance.new("UICorner")
	uicorner2.CornerRadius = UDim.new(0, 5)
	uicorner2.Parent = toggleframe2
	buttontext.MouseEnter:Connect(function()
		game:GetService("TweenService"):Create(toggleframe2, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(79, 78, 79)}):Play()
	end)
	buttontext.MouseLeave:Connect(function()
		game:GetService("TweenService"):Create(toggleframe2, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(38, 37, 38)}):Play()
	end)
	local ItemListBigFrame = Instance.new("Frame")
	ItemListBigFrame.Size = UDim2.new(1, 0, 1, 0)
	ItemListBigFrame.Name = "ItemList"
	ItemListBigFrame.BackgroundTransparency = 1
	ItemListBigFrame.Visible = false
	ItemListBigFrame.Parent = GuiLibrary["MainGui"]
	local ItemListFrame = Instance.new("Frame")
	ItemListFrame.Size = UDim2.new(0, 660, 0, 445)
	ItemListFrame.Position = UDim2.new(0.5, -330, 0.5, -223)
	ItemListFrame.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
	ItemListFrame.Parent = ItemListBigFrame
	local ItemListExitButton = Instance.new("ImageButton")
	ItemListExitButton.Name = "ItemListExitButton"
	ItemListExitButton.ImageColor3 = Color3.fromRGB(121, 121, 121)
	ItemListExitButton.Size = UDim2.new(0, 24, 0, 24)
	ItemListExitButton.AutoButtonColor = false
	ItemListExitButton.Image = getcustomassetfunc("vape/assets/ExitIcon1.png")
	ItemListExitButton.Visible = true
	ItemListExitButton.Position = UDim2.new(1, -31, 0, 8)
	ItemListExitButton.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
	ItemListExitButton.Parent = ItemListFrame
	local ItemListExitButtonround = Instance.new("UICorner")
	ItemListExitButtonround.CornerRadius = UDim.new(0, 16)
	ItemListExitButtonround.Parent = ItemListExitButton
	ItemListExitButton.MouseEnter:Connect(function()
		game:GetService("TweenService"):Create(ItemListExitButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(60, 60, 60), ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play()
	end)
	ItemListExitButton.MouseLeave:Connect(function()
		game:GetService("TweenService"):Create(ItemListExitButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(26, 25, 26), ImageColor3 = Color3.fromRGB(121, 121, 121)}):Play()
	end)
	ItemListExitButton.MouseButton1Click:Connect(function()
		ItemListBigFrame.Visible = false
		GuiLibrary["MainGui"].ScaledGui.ClickGui.Visible = true
	end)
	local ItemListFrameShadow = Instance.new("ImageLabel")
	ItemListFrameShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	ItemListFrameShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	ItemListFrameShadow.Image = getcustomassetfunc("vape/assets/WindowBlur.png")
	ItemListFrameShadow.BackgroundTransparency = 1
	ItemListFrameShadow.ZIndex = -1
	ItemListFrameShadow.Size = UDim2.new(1, 6, 1, 6)
	ItemListFrameShadow.ImageColor3 = Color3.new(0, 0, 0)
	ItemListFrameShadow.ScaleType = Enum.ScaleType.Slice
	ItemListFrameShadow.SliceCenter = Rect.new(10, 10, 118, 118)
	ItemListFrameShadow.Parent = ItemListFrame
	local ItemListFrameText = Instance.new("TextLabel")
	ItemListFrameText.Size = UDim2.new(1, 0, 0, 41)
	ItemListFrameText.BackgroundTransparency = 1
	ItemListFrameText.Name = "WindowTitle"
	ItemListFrameText.Position = UDim2.new(0, 0, 0, 0)
	ItemListFrameText.TextXAlignment = Enum.TextXAlignment.Left
	ItemListFrameText.Font = Enum.Font.SourceSans
	ItemListFrameText.TextSize = 17
	ItemListFrameText.Text = "    New AutoHotbar"
	ItemListFrameText.TextColor3 = Color3.fromRGB(201, 201, 201)
	ItemListFrameText.Parent = ItemListFrame
	local ItemListBorder1 = Instance.new("Frame")
	ItemListBorder1.BackgroundColor3 = Color3.fromRGB(40, 39, 40)
	ItemListBorder1.BorderSizePixel = 0
	ItemListBorder1.Size = UDim2.new(1, 0, 0, 1)
	ItemListBorder1.Position = UDim2.new(0, 0, 0, 41)
	ItemListBorder1.Parent = ItemListFrame
	local ItemListFrameCorner = Instance.new("UICorner")
	ItemListFrameCorner.CornerRadius = UDim.new(0, 4)
	ItemListFrameCorner.Parent = ItemListFrame
	local ItemListFrame1 = Instance.new("Frame")
	ItemListFrame1.Size = UDim2.new(0, 112, 0, 113)
	ItemListFrame1.Position = UDim2.new(0, 10, 0, 71)
	ItemListFrame1.BackgroundColor3 = Color3.fromRGB(38, 37, 38)
	ItemListFrame1.Name = "ItemListFrame1"
	ItemListFrame1.Parent = ItemListFrame
	local ItemListFrame2 = Instance.new("Frame")
	ItemListFrame2.Size = UDim2.new(0, 110, 0, 111)
	ItemListFrame2.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	ItemListFrame2.BorderSizePixel = 0
	ItemListFrame2.Name = "ItemListFrame2"
	ItemListFrame2.Position = UDim2.new(0, 1, 0, 1)
	ItemListFrame2.Parent = ItemListFrame1
	local ItemListFramePicker = Instance.new("ScrollingFrame")
	ItemListFramePicker.Size = UDim2.new(0, 495, 0, 220)
	ItemListFramePicker.Position = UDim2.new(0, 144, 0, 122)
	ItemListFramePicker.BorderSizePixel = 0
	ItemListFramePicker.ScrollBarThickness = 3
	ItemListFramePicker.ScrollBarImageTransparency = 0.8
	ItemListFramePicker.VerticalScrollBarInset = Enum.ScrollBarInset.None
	ItemListFramePicker.BackgroundTransparency = 1
	ItemListFramePicker.Parent = ItemListFrame
	local ItemListFramePickerGrid = Instance.new("UIGridLayout")
	ItemListFramePickerGrid.CellPadding = UDim2.new(0, 4, 0, 3)
	ItemListFramePickerGrid.CellSize = UDim2.new(0, 51, 0, 52)
	ItemListFramePickerGrid.Parent = ItemListFramePicker
	ItemListFramePickerGrid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		ItemListFramePicker.CanvasSize = UDim2.new(0, 0, 0, ItemListFramePickerGrid.AbsoluteContentSize.Y * (1 / GuiLibrary["MainRescale"].Scale))
	end)
	local ItemListcorner = Instance.new("UICorner")
	ItemListcorner.CornerRadius = UDim.new(0, 5)
	ItemListcorner.Parent = ItemListFrame1
	local ItemListcorner2 = Instance.new("UICorner")
	ItemListcorner2.CornerRadius = UDim.new(0, 5)
	ItemListcorner2.Parent = ItemListFrame2
	local selectedslot = 1
	local hoveredslot = 0
	
	local refreshslots
	local refreshList
	refreshslots = function()
		local startnum = 144
		local oldhovered = hoveredslot
		for i2,v2 in pairs(ItemListFrame:GetChildren()) do
			if v2.Name:find("ItemSlot") then
				v2:Remove()
			end
		end
		for i3,v3 in pairs(ItemListFramePicker:GetChildren()) do
			if v3:IsA("TextButton") then
				v3:Remove()
			end
		end
		for i4,v4 in pairs(sortableitems) do
			local ItemFrame = Instance.new("TextButton")
			ItemFrame.Text = ""
			ItemFrame.BackgroundColor3 = Color3.fromRGB(31, 30, 31)
			ItemFrame.Parent = ItemListFramePicker
			ItemFrame.AutoButtonColor = false
			local ItemFrameIcon = Instance.new("ImageLabel")
			ItemFrameIcon.Size = UDim2.new(0, 32, 0, 32)
			ItemFrameIcon.Image = bedwars.getIcon({itemType = v4.itemDisplayType}, true) 
			ItemFrameIcon.ResampleMode = (bedwars.getIcon({itemType = v4.itemDisplayType}, true):find("rbxasset://") and Enum.ResamplerMode.Pixelated or Enum.ResamplerMode.Default)
			ItemFrameIcon.Position = UDim2.new(0, 10, 0, 10)
			ItemFrameIcon.BackgroundTransparency = 1
			ItemFrameIcon.Parent = ItemFrame
			local ItemFramecorner = Instance.new("UICorner")
			ItemFramecorner.CornerRadius = UDim.new(0, 5)
			ItemFramecorner.Parent = ItemFrame
			ItemFrame.MouseButton1Click:Connect(function()
				for i5,v5 in pairs(buttonapi["Hotbars"][buttonapi["CurrentlySelected"]]["Items"]) do
					if v5.itemType == v4.itemType then
						buttonapi["Hotbars"][buttonapi["CurrentlySelected"]]["Items"][tostring(i5)] = nil
					end
				end
				buttonapi["Hotbars"][buttonapi["CurrentlySelected"]]["Items"][tostring(selectedslot)] = v4
				refreshslots()
				refreshList()
			end)
		end
		for i = 1, 9 do
			local item = buttonapi["Hotbars"][buttonapi["CurrentlySelected"]]["Items"][tostring(i)]
			local ItemListFrame3 = Instance.new("Frame")
			ItemListFrame3.Size = UDim2.new(0, 55, 0, 56)
			ItemListFrame3.Position = UDim2.new(0, startnum - 2, 0, 380)
			ItemListFrame3.BackgroundTransparency = (selectedslot == i and 0 or 1)
			ItemListFrame3.BackgroundColor3 = Color3.fromRGB(35, 34, 35)
			ItemListFrame3.Name = "ItemSlot"
			ItemListFrame3.Parent = ItemListFrame
			local ItemListFrame4 = Instance.new("TextButton")
			ItemListFrame4.Size = UDim2.new(0, 51, 0, 52)
			ItemListFrame4.BackgroundColor3 = (oldhovered == i and Color3.fromRGB(31, 30, 31) or Color3.fromRGB(20, 20, 20))
			ItemListFrame4.BorderSizePixel = 0
			ItemListFrame4.AutoButtonColor = false
			ItemListFrame4.Text = ""
			ItemListFrame4.Name = "ItemListFrame4"
			ItemListFrame4.Position = UDim2.new(0, 2, 0, 2)
			ItemListFrame4.Parent = ItemListFrame3
			local ItemListImage = Instance.new("ImageLabel")
			ItemListImage.Size = UDim2.new(0, 32, 0, 32)
			ItemListImage.BackgroundTransparency = 1
			local img = (item and bedwars.getIcon({itemType = item.itemDisplayType}, true) or "")
			ItemListImage.Image = img
			ItemListImage.ResampleMode = (img:find("rbxasset://") and Enum.ResamplerMode.Pixelated or Enum.ResamplerMode.Default)
			ItemListImage.Position = UDim2.new(0, 10, 0, 10)
			ItemListImage.Parent = ItemListFrame4
			local ItemListcorner3 = Instance.new("UICorner")
			ItemListcorner3.CornerRadius = UDim.new(0, 5)
			ItemListcorner3.Parent = ItemListFrame3
			local ItemListcorner4 = Instance.new("UICorner")
			ItemListcorner4.CornerRadius = UDim.new(0, 5)
			ItemListcorner4.Parent = ItemListFrame4
			ItemListFrame4.MouseEnter:Connect(function()
				ItemListFrame4.BackgroundColor3 = Color3.fromRGB(31, 30, 31)
				hoveredslot = i
			end)
			ItemListFrame4.MouseLeave:Connect(function()
				ItemListFrame4.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
				hoveredslot = 0
			end)
			ItemListFrame4.MouseButton1Click:Connect(function()
				selectedslot = i
				refreshslots()
			end)
			ItemListFrame4.MouseButton2Click:Connect(function()
				buttonapi["Hotbars"][buttonapi["CurrentlySelected"]]["Items"][tostring(i)] = nil
				refreshslots()
				refreshList()
			end)
			startnum = startnum + 55
		end
	end	

	local function createHotbarButton(num, items)
		num = tonumber(num) or #buttonapi["Hotbars"] + 1
		local hotbarbutton = Instance.new("TextButton")
		hotbarbutton.Size = UDim2.new(1, 0, 0, 30)
		hotbarbutton.BackgroundTransparency = 1
		hotbarbutton.LayoutOrder = num
		hotbarbutton.AutoButtonColor = false
		hotbarbutton.Text = ""
		hotbarbutton.Parent = children3
		buttonapi["Hotbars"][num] = {["Items"] = items or {}, Object = hotbarbutton, ["Number"] = num}
		local hotbarframe = Instance.new("Frame")
		hotbarframe.BackgroundColor3 = (num == buttonapi["CurrentlySelected"] and Color3.fromRGB(54, 53, 54) or Color3.fromRGB(31, 30, 31))
		hotbarframe.Size = UDim2.new(0, 200, 0, 27)
		hotbarframe.Position = UDim2.new(0, 10, 0, 1)
		hotbarframe.Parent = hotbarbutton
		local uicorner3 = Instance.new("UICorner")
		uicorner3.CornerRadius = UDim.new(0, 5)
		uicorner3.Parent = hotbarframe
		local startpos = 11
		for i = 1, 9 do
			local item = buttonapi["Hotbars"][num]["Items"][tostring(i)]
			local hotbarbox = Instance.new("ImageLabel")
			hotbarbox.Name = i
			hotbarbox.Size = UDim2.new(0, 17, 0, 18)
			hotbarbox.Position = UDim2.new(0, startpos, 0, 5)
			hotbarbox.BorderSizePixel = 0
			hotbarbox.Image = (item and bedwars.getIcon({itemType = item.itemDisplayType}, true) or "")
			hotbarbox.ResampleMode = ((item and bedwars.getIcon({itemType = item.itemDisplayType}, true) or ""):find("rbxasset://") and Enum.ResamplerMode.Pixelated or Enum.ResamplerMode.Default)
			hotbarbox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			hotbarbox.Parent = hotbarframe
			startpos = startpos + 18
		end
		hotbarbutton.MouseButton1Click:Connect(function()
			if buttonapi["CurrentlySelected"] == num then
				ItemListBigFrame.Visible = true
				GuiLibrary["MainGui"].ScaledGui.ClickGui.Visible = false
				refreshslots()
			end
			buttonapi["CurrentlySelected"] = num
			refreshList()
		end)
		hotbarbutton.MouseButton2Click:Connect(function()
			if buttonapi["CurrentlySelected"] == num then
				buttonapi["CurrentlySelected"] = (num == 2 and 0 or 1)
			end
			table.remove(buttonapi["Hotbars"], num)
			refreshList()
		end)
	end

	refreshList = function()
		local newnum = 0
		local newtab = {}
		for i3,v3 in pairs(buttonapi["Hotbars"]) do
			newnum = newnum + 1
			newtab[newnum] = v3
		end
		buttonapi["Hotbars"] = newtab
		for i,v in pairs(children3:GetChildren()) do
			if v:IsA("TextButton") then
				v:Remove()
			end
		end
		for i2,v2 in pairs(buttonapi["Hotbars"]) do
			createHotbarButton(i2, v2["Items"])
		end
		GuiLibrary["Settings"][children2.Name..argstable["Name"].."ItemList"] = {["Type"] = "ItemList", ["Items"] = buttonapi["Hotbars"], ["CurrentlySelected"] = buttonapi["CurrentlySelected"]}
	end
	buttonapi["RefreshList"] = refreshList

	buttontext.MouseButton1Click:Connect(function()
		createHotbarButton()
	end)

	GuiLibrary["Settings"][children2.Name..argstable["Name"].."ItemList"] = {["Type"] = "ItemList", ["Items"] = buttonapi["Hotbars"], ["CurrentlySelected"] = buttonapi["CurrentlySelected"]}
	GuiLibrary.ObjectsThatCanBeSaved[children2.Name..argstable["Name"].."ItemList"] = {["Type"] = "ItemList", ["Items"] = buttonapi["Hotbars"], ["Api"] = buttonapi, Object = buttontext}

	return buttonapi
end

GuiLibrary.LoadSettingsEvent.Event:Connect(function(res)
	for i,v in pairs(res) do
		local obj = GuiLibrary.ObjectsThatCanBeSaved[i]
		if obj and v["Type"] == "ItemList" and obj.Api then
			obj["Api"]["Hotbars"] = v["Items"]
			obj["Api"]["CurrentlySelected"] = v["CurrentlySelected"]
			obj["Api"]["RefreshList"]()
		end
	end
end)

local function createwarning(title, text, delay)
	local suc, res = pcall(function()
		local frame = GuiLibrary["CreateNotification"](title, text, delay, "assets/WarningNotification.png")
		frame.Frame.Frame.ImageColor3 = Color3.fromRGB(236, 129, 44)
		return frame
	end)
	return (suc and res)
end

local function getItemNear(itemName, inv)
	for i5, v5 in pairs(inv or currentinventory.inventory.items) do
		if v5.itemType:find(itemName) then
			return v5, i5
		end
	end
	return nil
end

local function getItem(itemName, inv)
	for i5, v5 in pairs(inv or currentinventory.inventory.items) do
		if v5.itemType == itemName then
			return v5, i5
		end
	end
	return nil
end

local function getHotbarSlot(itemName)
	for i5, v5 in pairs(currentinventory.hotbar) do
		if v5["item"] and v5["item"].itemType == itemName then
			return i5 - 1
		end
	end
	return nil
end

local function getSword()
	local bestsword, bestswordslot, bestswordnum = nil, nil, 0
	for i5, v5 in pairs(currentinventory.inventory.items) do
		if bedwars.ItemTable[v5.itemType]["sword"] then
			local swordrank = bedwars.ItemTable[v5.itemType]["sword"]["damage"] or 0
			if swordrank > bestswordnum then
				bestswordnum = swordrank
				bestswordslot = i5
				bestsword = v5
			end
		end
	end
	return bestsword, bestswordslot
end

local function getBlock()
	for i5, v5 in pairs(currentinventory.inventory.items) do
		if bedwars.ItemTable[v5.itemType]["block"] then
			return v5.itemType, v5.amount
		end
	end
	return
end

local function getSlotFromItem(item)
	for i,v in pairs(currentinventory.inventory.items) do
		if v.itemType == item.itemType then
			return i
		end
	end
	return nil
end

local function getShield(char)
	local shield = 0
	for i,v in pairs(char:GetAttributes()) do 
		if i:find("Shield") and type(v) == "number" then 
			shield = shield + v
		end
	end
	return shield
end

local function getAxe()
	local bestsword, bestswordslot, bestswordnum = nil, nil, 0
	for i5, v5 in pairs(currentinventory.inventory.items) do
		if v5.itemType:find("axe") and v5.itemType:find("pickaxe") == nil and v5.itemType:find("void") == nil then
			bestswordnum = swordrank
			bestswordslot = i5
			bestsword = v5
		end
	end
	return bestsword, bestswordslot
end

local function getPickaxe()
	return getItemNear("pick")
end

local function getBaguette()
	return getItemNear("baguette")
end

local function getwool()
	local wool = getItemNear("wool")
	return wool and wool.itemType, wool and wool.amount
end

local function isAliveOld(plr, alivecheck)
	if plr then
		return plr and plr.Character and plr.Character.Parent ~= nil and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("Humanoid")
	end
	return entityLibrary.isAlive
end

local function isAlive(plr, alivecheck)
	if plr then
		local ind, tab = entityLibrary.getEntityFromPlayer(plr)
		return ((not alivecheck) or tab and tab.Humanoid:GetState() ~= Enum.HumanoidStateType.Dead) and tab
	end
	return entityLibrary.isAlive
end

local function hashvec(vec)
	return {
		["value"] = vec
	}
end

local function getremote(tab)
	for i,v in pairs(tab) do
		if v == "Client" then
			return tab[i + 1]
		end
	end
	return ""
end

local function betterfind(tab, obj)
	for i,v in pairs(tab) do
		if v == obj or type(v) == "table" and v.hash == obj then
			return v
		end
	end
	return nil
end

local GetNearestHumanoidToMouse = function() end

local function randomString()
	local randomlength = math.random(10,100)
	local array = {}

	for i = 1, randomlength do
		array[i] = string.char(math.random(32, 126))
	end

	return table.concat(array)
end

local function getWhitelistedBed(bed)
	for i,v in pairs(players:GetPlayers()) do
		if v:GetAttribute("Team") and bed and bed:GetAttribute("Team"..v:GetAttribute("Team").."NoBreak") and WhitelistFunctions:CheckWhitelisted(v) then
			return true
		end
	end
	return false
end

local OldClientGet 
local oldbreakremote
local oldbob
local oldzephyr
local zephyrorbs = 0
local globalgroundtouchedtime = tick()
local jumptable = {}
runcode(function()
    getfunctions = function()
		local Flamework = require(repstorage["rbxts_include"]["node_modules"]["@flamework"].core.out).Flamework
        local KnitGotten, KnitClient
		repeat
			task.wait()
			KnitGotten, KnitClient = pcall(function()
				return debug.getupvalue(require(lplr.PlayerScripts.TS.knit).setup, 6)
			end)
		until KnitGotten
		repeat task.wait() until debug.getupvalue(KnitClient.Start, 1) == true
        local Client = require(repstorage.TS.remotes).default.Client
        local InventoryUtil = require(repstorage.TS.inventory["inventory-util"]).InventoryUtil
        OldClientGet = getmetatable(Client).Get
        getmetatable(Client).Get = function(Self, remotename)
			if uninjectflag then return OldClientGet(Self, remotename) end
			local res = OldClientGet(Self, remotename)
			if remotename == "DamageBlock" then
				return {
					["CallServerAsync"] = function(Self, tab)
						local block = bedwars.BlockController:getStore():getBlockAt(tab.blockRef.blockPosition)
						if block and block.Name == "bed" then
							if getWhitelistedBed(block) then
								return {andThen = function(self, func) 
									func("failed")
								end}
							end
						end
						return res:CallServerAsync(tab)
					end,
					["CallServer"] = function(Self, tab)
						local block = bedwars.BlockController:getStore():getBlockAt(tab.blockRef.blockPosition)
						if block and block.Name == "bed" then
							if getWhitelistedBed(block) then
								return {andThen = function(self, func) 
									func("failed")
								end}
							end
						end
						return res:CallServer(tab)
					end
				}
			elseif remotename == bedwars["AttackRemote"] then
				return {
					["instance"] = res["instance"],
					["SendToServer"] = function(Self, tab)
						local suc, plr = pcall(function() return players:GetPlayerFromCharacter(tab.entityInstance) end)
						if suc and plr then
							local playertype, playerattackable = WhitelistFunctions:CheckPlayerType(plr)
							if not playerattackable then 
								return nil
							end
							if Reach.Enabled then
								local selfcheck = entityLibrary.LocalPosition or tab.validate.selfPosition.value
								if (selfcheck - (entityLibrary.OtherPosition[plr] or tab.validate.targetPosition.value)).Magnitude > 18 then return res:SendToServer(tab) end
								local mag = (tab.validate.selfPosition.value - tab.validate.targetPosition.value).magnitude
								local newres = hashvec(tab.validate.selfPosition.value + (mag > 14.4 and (CFrame.lookAt(tab.validate.selfPosition.value, tab.validate.targetPosition.value).lookVector * 4) or Vector3.zero))
								tab.validate.selfPosition = newres
							end
						end
						return res:SendToServer(tab)
					end
				}
			end
            return res
        end
		bedwars = {
			AnimationType = require(repstorage.TS.animation["animation-type"]).AnimationType,
			AnimationUtil = require(repstorage["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out["shared"].util["animation-util"]).AnimationUtil,
			AppController = require(repstorage["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out.client.controllers["app-controller"]).AppController,
			AbilityController = Flamework.resolveDependency("@easy-games/game-core:client/controllers/ability/ability-controller@AbilityController"),
			AttackRemote = getremote(debug.getconstants(getmetatable(KnitClient.Controllers.SwordController)["attackEntity"])),
			BalloonController = KnitClient.Controllers.BalloonController,
			BalanceFile = require(repstorage.TS.balance["balance-file"]).BalanceFile,
			BatteryEffectController = KnitClient.Controllers.BatteryEffectsController,
			BatteryRemote = getremote(debug.getconstants(debug.getproto(debug.getproto(KnitClient.Controllers.BatteryController.KnitStart, 1), 1))),
			BlockBreaker = KnitClient.Controllers.BlockBreakController.blockBreaker,
			BlockController = require(repstorage["rbxts_include"]["node_modules"]["@easy-games"]["block-engine"].out).BlockEngine,
			BlockPlacer = require(repstorage["rbxts_include"]["node_modules"]["@easy-games"]["block-engine"].out.client.placement["block-placer"]).BlockPlacer,
			BlockEngine = require(lplr.PlayerScripts.TS.lib["block-engine"]["client-block-engine"]).ClientBlockEngine,
			BlockEngineClientEvents = require(repstorage["rbxts_include"]["node_modules"]["@easy-games"]["block-engine"].out.client["block-engine-client-events"]).BlockEngineClientEvents,
			BlockPlacementController = KnitClient.Controllers.BlockPlacementController,
			BowConstantsTable = debug.getupvalue(KnitClient.Controllers.ProjectileController.enableBeam, 5),
			ProjectileController = KnitClient.Controllers.ProjectileController,
			ChestController = KnitClient.Controllers.ChestController,
			CannonHandController = KnitClient.Controllers.CannonHandController,
			CannonAimRemote = getremote(debug.getconstants(debug.getproto(KnitClient.Controllers.CannonController.startAiming, 5))),
			ClickHold = require(repstorage["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out.client.ui.lib.util["click-hold"]).ClickHold,
			ClientHandler = Client,
			ClientHandlerDamageBlock = require(repstorage["rbxts_include"]["node_modules"]["@easy-games"]["block-engine"].out.shared.remotes).BlockEngineRemotes.Client,
			ClientStoreHandler = require(lplr.PlayerScripts.TS.ui.store).ClientStore,
			CombatConstant = require(repstorage.TS.combat["combat-constant"]).CombatConstant,
			CombatController = KnitClient.Controllers.CombatController,
			ConstantManager = require(repstorage["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out["shared"].constant["constant-manager"]).ConstantManager,
			ConsumeSoulRemote = getremote(debug.getconstants(KnitClient.Controllers.GrimReaperController.consumeSoul)),
			DamageIndicator = KnitClient.Controllers.DamageIndicatorController.spawnDamageIndicator,
			DamageIndicatorController = KnitClient.Controllers.DamageIndicatorController,
			DefaultKillEffect = require(lplr.PlayerScripts.TS.controllers.game.locker["kill-effect"].effects["default-kill-effect"]),
			DropItem = getmetatable(KnitClient.Controllers.ItemDropController).dropItemInHand,
			DropItemRemote = getremote(debug.getconstants(getmetatable(KnitClient.Controllers.ItemDropController).dropItemInHand)),
			DragonSlayerController = KnitClient.Controllers.DragonSlayerController,
			DragonRemote = getremote(debug.getconstants(debug.getproto(debug.getproto(KnitClient.Controllers.DragonSlayerController.KnitStart, 2), 1))),
			EatRemote = getremote(debug.getconstants(debug.getproto(getmetatable(KnitClient.Controllers.ConsumeController).onEnable, 1))),
			EquipItemRemote = getremote(debug.getconstants(debug.getprotos(shared.oldequipitem or require(repstorage.TS.entity.entities["inventory-entity"]).InventoryEntity.equipItem)[3])),
			EmoteMeta = require(repstorage.TS.locker.emote["emote-meta"]).EmoteMeta,
			FishermanTable = KnitClient.Controllers.FishermanController,
			FovController = KnitClient.Controllers.FovController,
			GameAnimationUtil = require(repstorage.TS.animation["animation-util"]).GameAnimationUtil,
			EntityUtil = require(repstorage.TS.entity["entity-util"]).EntityUtil,
			getIcon = function(item, showinv)
				local itemmeta = bedwars.ItemTable[item.itemType]
				if itemmeta and showinv then
					return itemmeta.image
				end
				return ""
			end,
			getInventory = function(plr)
				local suc, result = pcall(function() 
					return InventoryUtil.getInventory(plr) 
				end)
				return (suc and result or {
					["items"] = {},
					["armor"] = {},
					["hand"] = nil
				})
			end,
			GrimReaperController = KnitClient.Controllers.GrimReaperController,
			GuitarHealRemote = getremote(debug.getconstants(KnitClient.Controllers.GuitarController.performHeal)),
			HangGliderController = KnitClient.Controllers.HangGliderController,
			HighlightController = KnitClient.Controllers.EntityHighlightController,
			ItemTable = debug.getupvalue(require(repstorage.TS.item["item-meta"]).getItemMeta, 1),
			KatanaController = KnitClient.Controllers.DaoController,
			KnockbackUtil = require(repstorage.TS.damage["knockback-util"]).KnockbackUtil,
			LobbyClientEvents = KnitClient.Controllers.QueueController,
			MapController = KnitClient.Controllers.MapController,
			MinerRemote = getremote(debug.getconstants(debug.getproto(getmetatable(KnitClient.Controllers.MinerController).onKitEnabled, 1))),
			MageRemote = getremote(debug.getconstants(debug.getproto(KnitClient.Controllers.MageController.registerTomeInteraction, 1))),
			MageKitUtil = require(repstorage.TS.games.bedwars.kit.kits.mage["mage-kit-util"]).MageKitUtil,
			MageController = KnitClient.Controllers.MageController,
			MissileController = KnitClient.Controllers.GuidedProjectileController,
			PickupMetalRemote = getremote(debug.getconstants(debug.getproto(KnitClient.Controllers.MetalDetectorController.KnitStart, 1))),
			PickupRemote = getremote(debug.getconstants(getmetatable(KnitClient.Controllers.ItemDropController).checkForPickup)),
			ProjectileMeta = require(repstorage.TS.projectile["projectile-meta"]).ProjectileMeta,
			ProjectileRemote = getremote(debug.getconstants(debug.getupvalues(getmetatable(KnitClient.Controllers.ProjectileController)["launchProjectileWithValues"])[2])),
			QueryUtil = require(repstorage["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out).GameQueryUtil,
			QueueCard = require(lplr.PlayerScripts.TS.controllers.global.queue.ui["queue-card"]).QueueCard,
			QueueMeta = require(repstorage.TS.game["queue-meta"]).QueueMeta,
			RavenTable = KnitClient.Controllers.RavenController,
			RelicController = KnitClient.Controllers.RelicVotingController,
			ReportRemote = getremote(debug.getconstants(require(lplr.PlayerScripts.TS.controllers.global.report["report-controller"]).default.reportPlayer)),
			ResetRemote = getremote(debug.getconstants(debug.getproto(KnitClient.Controllers.ResetController.createBindable, 1))),
			Roact = require(repstorage["rbxts_include"]["node_modules"]["@rbxts"]["roact"].src),
			RuntimeLib = require(repstorage["rbxts_include"].RuntimeLib),
			Shop = require(repstorage.TS.games.bedwars.shop["bedwars-shop"]).BedwarsShop,
			ShopItems = debug.getupvalue(debug.getupvalue(require(repstorage.TS.games.bedwars.shop["bedwars-shop"]).BedwarsShop.getShopItem, 1), 2),
			SoundList = require(repstorage.TS.sound["game-sound"]).GameSound,
			SoundManager = require(repstorage["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out).SoundManager,
			SpawnRavenRemote = getremote(debug.getconstants(getmetatable(KnitClient.Controllers.RavenController).spawnRaven)),
			SprintController = KnitClient.Controllers.SprintController,
			StopwatchController = KnitClient.Controllers.StopwatchController,
			SwordController = KnitClient.Controllers.SwordController,
			TreeRemote = getremote(debug.getconstants(debug.getprotos(debug.getprotos(KnitClient.Controllers.BigmanController.KnitStart)[3])[1])),
			TrinityRemote = getremote(debug.getconstants(debug.getproto(getmetatable(KnitClient.Controllers.AngelController).onKitEnabled, 1))),
			ViewmodelController = KnitClient.Controllers.ViewmodelController,
			WeldTable = require(repstorage.TS.util["weld-util"]).WeldUtil,
			ZephyrController = KnitClient.Controllers.WindWalkerController
        }
		oldzephyr = bedwars.ZephyrController.updateJump
		bedwars.ZephyrController.updateJump = function(self, orb, ...)
			zephyrorbs = orb
			return oldzephyr(self, orb, ...)
		end
		oldbob = bedwars.ViewmodelController.playAnimation
        bedwars.ViewmodelController.playAnimation = function(Self, id, ...)
            if id == 19 and nobob.Enabled and entityLibrary.isAlive then
                id = 11
            end
            return oldbob(Self, id, ...)
        end
		blocktable = bedwars["BlockPlacer"].new(bedwars["BlockEngine"], getwool())
		bedwars.placeBlock = function(newpos, customblock)
			if getItem(customblock) then
				blocktable.blockType = customblock
				return blocktable:placeBlock(Vector3.new(newpos.X / 3, newpos.Y / 3, newpos.Z / 3))
			end
		end
		task.spawn(function()
			repeat
				task.wait()
				if entityLibrary.isAlive then
					if entityLibrary.character.Humanoid.FloorMaterial ~= Enum.Material.Air then 
						globalgroundtouchedtime = tick()
					end
				end
				for i,v in pairs(entityLibrary.entityList) do 
					v.JumpTick = v.Humanoid.FloorMaterial == Enum.Material.Air and tick() or v.JumpTick
					v.Jumping = (tick() - v.JumpTick) < 0.4 and v.Jumps > 2
					if (tick() - v.JumpTick) > 0.4 then 
						v.Jumps = 0
					end
				end
			until uninjectflag
		end)
		bedwarsblocks = collectionservice:GetTagged("block")
		connectionstodisconnect[#connectionstodisconnect + 1] = collectionservice:GetInstanceAddedSignal("block"):Connect(function(v) table.insert(bedwarsblocks, v) blockraycast.FilterDescendantsInstances = {bedwarsblocks} end)
		connectionstodisconnect[#connectionstodisconnect + 1] = collectionservice:GetInstanceRemovedSignal("block"):Connect(function(v) local found = table.find(bedwarsblocks, v) if found then table.remove(bedwarsblocks, found) end blockraycast.FilterDescendantsInstances = {bedwarsblocks} end)
		blockraycast.FilterDescendantsInstances = bedwarsblocks
		connectionstodisconnect[#connectionstodisconnect + 1] = bedwars.ClientStoreHandler.changed:connect(function(p3, p4)
			if p3.Game ~= p4.Game then 
				matchState = p3.Game.matchState
				queueType = p3.Game.queueType or "bedwars_test"
			end
			if p3.Kit ~= p4.Kit then 	
				bedwars.BountyHunterTarget = p3.Kit.bountyHunterTarget
			end
			if p3.Bedwars ~= p4.Bedwars then 
				kit = p3.Bedwars.kit ~= "none" and p3.Bedwars.kit or ""
			end
			if p3.Inventory ~= p4.Inventory then
				currentinventory = p3.Inventory.observedInventory
			end
        end)
		local clientstorestate = bedwars.ClientStoreHandler:getState()
        matchState = clientstorestate.Game.matchState or 0
        kit = clientstorestate.Bedwars.kit ~= "none" and clientstorestate.Bedwars.kit or ""
		queueType = clientstorestate.Game.queueType or "bedwars_test"
		bedwars.BountyHunterTarget = clientstorestate.Kit.bountyHunterTarget
		currentinventory = clientstorestate.Inventory.observedInventory
		if not shared.vapebypassed then
			local fakeremote = Instance.new("RemoteEvent")
			fakeremote.Name = "GameAnalyticsError"
			local realremote = repstorage:WaitForChild("GameAnalyticsError")
			realremote.Parent = nil
			fakeremote.Parent = repstorage
			game:GetService("ScriptContext").Error:Connect(function(p1, p2, p3)
				if not p3 then
					return;
				end;
				local u2 = nil;
				local v4, v5 = pcall(function()
					u2 = p3:GetFullName();
				end);
				if not v4 then
					return;
				end;
				if p3.Parent == nil then
					return;
				end
				realremote:FireServer(p1, p2, u2);
			end)
			shared.vapebypassed = true
		end

		task.spawn(function()
			local chatsuc, chatres = pcall(function() return game:GetService("HttpService"):JSONDecode(readfile("vape/Profiles/bedwarssettings.json")) end)
			if chatsuc then
				if chatres.crashed and (not chatres.said) then
					pcall(function()
						createwarning("Vape", "either ur poor or its a exploit moment", 10)
						createwarning("Vape", "getconnections crashed, chat hook not loaded.", 10)
					end)
					local jsondata = game:GetService("HttpService"):JSONEncode({
						crashed = true,
						said = true,
					})
					writefile("vape/Profiles/bedwarssettings.json", jsondata)
				end
				if chatres.crashed then
					return nil
				else
					local jsondata = game:GetService("HttpService"):JSONEncode({
						crashed = true,
						said = false,
					})
					writefile("vape/Profiles/bedwarssettings.json", jsondata)
				end
			else
				local jsondata = game:GetService("HttpService"):JSONEncode({
					crashed = true,
					said = false,
				})
				writefile("vape/Profiles/bedwarssettings.json", jsondata)
			end
			repeat task.wait() until WhitelistFunctions.Loaded
			for i3,v3 in pairs(WhitelistFunctions.WhitelistTable.chattags) do
				if v3.NameColor then
					v3.NameColor = Color3.fromRGB(v3.NameColor.r, v3.NameColor.g, v3.NameColor.b)
				end
				if v3.ChatColor then
					v3.ChatColor = Color3.fromRGB(v3.ChatColor.r, v3.ChatColor.g, v3.ChatColor.b)
				end
				if v3.Tags then
					for i4,v4 in pairs(v3.Tags) do
						if v4.TagColor then
							v4.TagColor = Color3.fromRGB(v4.TagColor.r, v4.TagColor.g, v4.TagColor.b)
						end
					end
				end
			end
			if getconnections then 
				for i,v in pairs(getconnections(repstorage.DefaultChatSystemChatEvents.OnNewMessage.OnClientEvent)) do
					if v.Function and #debug.getupvalues(v.Function) > 0 and type(debug.getupvalues(v.Function)[1]) == "table" and getmetatable(debug.getupvalues(v.Function)[1]) and getmetatable(debug.getupvalues(v.Function)[1]).GetChannel then
						oldchanneltab = getmetatable(debug.getupvalues(v.Function)[1])
						oldchannelfunc = getmetatable(debug.getupvalues(v.Function)[1]).GetChannel
						getmetatable(debug.getupvalues(v.Function)[1]).GetChannel = function(Self, Name)
							local tab = oldchannelfunc(Self, Name)
							if tab and tab.AddMessageToChannel then
								local addmessage = tab.AddMessageToChannel
								if oldchanneltabs[tab] == nil then
									oldchanneltabs[tab] = tab.AddMessageToChannel
								end
								tab.AddMessageToChannel = function(Self2, MessageData)
									if MessageData.FromSpeaker and players[MessageData.FromSpeaker] then
										local plrtype = WhitelistFunctions:CheckPlayerType(players[MessageData.FromSpeaker])
										local hash = WhitelistFunctions:Hash(players[MessageData.FromSpeaker].Name..players[MessageData.FromSpeaker].UserId)
										if plrtype == "VAPE PRIVATE" then
											MessageData.ExtraData = {
												NameColor = players[MessageData.FromSpeaker].Team == nil and Color3.new(0, 1, 1) or players[MessageData.FromSpeaker].TeamColor.Color,
												Tags = {
													table.unpack(MessageData.ExtraData.Tags),
													{
														TagColor = Color3.new(0.7, 0, 1),
														TagText = "VAPE PRIVATE"
													}
												}
											}
										end
										if plrtype == "VAPE OWNER" then
											MessageData.ExtraData = {
												NameColor = players[MessageData.FromSpeaker].Team == nil and Color3.new(1, 0, 0) or players[MessageData.FromSpeaker].TeamColor.Color,
												Tags = {
													table.unpack(MessageData.ExtraData.Tags),
													{
														TagColor = Color3.new(1, 0.3, 0.3),
														TagText = "VAPE OWNER"
													}
												}
											}
										end
										if clients.ClientUsers[tostring(players[MessageData.FromSpeaker])] then
											MessageData.ExtraData = {
												NameColor = players[MessageData.FromSpeaker].Team == nil and Color3.new(1, 0, 0) or players[MessageData.FromSpeaker].TeamColor.Color,
												Tags = {
													table.unpack(MessageData.ExtraData.Tags),
													{
														TagColor = Color3.new(1, 1, 0),
														TagText = clients.ClientUsers[tostring(players[MessageData.FromSpeaker])]
													}
												}
											}
										end
										if WhitelistFunctions.WhitelistTable.chattags[hash] then
											local newdata = {
												NameColor = players[MessageData.FromSpeaker].Team == nil and WhitelistFunctions.WhitelistTable.chattags[hash].NameColor or players[MessageData.FromSpeaker].TeamColor.Color,
												Tags = WhitelistFunctions.WhitelistTable.chattags[hash].Tags
											}
											MessageData.ExtraData = newdata
										end
									end
									return addmessage(Self2, MessageData)
								end
							end
							return tab
						end
					end
				end
			end
			local jsondata = game:GetService("HttpService"):JSONEncode({
				crashed = false,
				said = false,
			})
			writefile("vape/Profiles/bedwarssettings.json", jsondata)
		end)
    end
end)

GuiLibrary.SelfDestructEvent.Event:Connect(function()
	uninjectflag = true
	if OldClientGet then
		getmetatable(bedwars.ClientHandler).Get = OldClientGet
	end
	if oldbob then bedwars.ViewmodelController.playAnimation = oldbob end
	if blocktable then blocktable:disable() end
	if oldchannelfunc and oldchanneltab then oldchanneltab.GetChannel = oldchannelfunc end
	if oldzephyr then bedwars.ZephyrController.updateJump = oldzephyr end
	for i2,v2 in pairs(oldchanneltabs) do i2.AddMessageToChannel = v2 end
	for i3,v3 in pairs(connectionstodisconnect) do
		if v3.Disconnect then pcall(function() v3:Disconnect() end) continue end
		if v3.disconnect then pcall(function() v3:disconnect() end) continue end
	end
end)

task.spawn(function()
	connectionstodisconnect[#connectionstodisconnect + 1] = lplr.PlayerGui:WaitForChild("Chat").Frame.ChatChannelParentFrame["Frame_MessageLogDisplay"].Scroller.ChildAdded:Connect(function(text)
		local textlabel2 = text:WaitForChild("TextLabel")
		if WhitelistFunctions:IsSpecialIngame() then
			local args = textlabel2.Text:split(" ")
			local client = clients.ChatStrings1[#args > 0 and args[#args] or tab.Message]
			if textlabel2.Text:find("You are now chatting") or textlabel2.Text:find("You are now privately chatting") then
				text.Size = UDim2.new(0, 0, 0, 0)
				text:GetPropertyChangedSignal("Size"):Connect(function()
					text.Size = UDim2.new(0, 0, 0, 0)
				end)
			end
			if client then
				if textlabel2.Text:find(clients.ChatStrings2[client]) then
					text.Size = UDim2.new(0, 0, 0, 0)
					text:GetPropertyChangedSignal("Size"):Connect(function()
						text.Size = UDim2.new(0, 0, 0, 0)
					end)
				end
			end
			textlabel2:GetPropertyChangedSignal("Text"):Connect(function()
				local args = textlabel2.Text:split(" ")
				local client = clients.ChatStrings1[#args > 0 and args[#args] or tab.Message]
				if textlabel2.Text:find("You are now chatting") or textlabel2.Text:find("You are now privately chatting") then
					text.Size = UDim2.new(0, 0, 0, 0)
					text:GetPropertyChangedSignal("Size"):Connect(function()
						text.Size = UDim2.new(0, 0, 0, 0)
					end)
				end
				if client then
					if textlabel2.Text:find(clients.ChatStrings2[client]) then
						text.Size = UDim2.new(0, 0, 0, 0)
						text:GetPropertyChangedSignal("Size"):Connect(function()
							text.Size = UDim2.new(0, 0, 0, 0)
						end)
					end
				end
			end)
		end
	end)
end)

connectionstodisconnect[#connectionstodisconnect + 1] = lplr.OnTeleport:Connect(function(State)
    if State == Enum.TeleportState.Started then
		local clientstorestate = bedwars.ClientStoreHandler and bedwars.ClientStoreHandler:getState() or {Party = {members = 0}}
		local queuedstring = ''
		if clientstorestate.Party and clientstorestate.Party.members and #clientstorestate.Party.members > 0 then
        	queuedstring = queuedstring..'shared.vapeteammembers = '..#clientstorestate.Party.members..'\n'
		end
		if tpstring then
			queuedstring = queuedstring..'shared.vapeoverlay = "'..tpstring..'"\n'
		end
		queueteleport(queuedstring)
    end
end)

local function getblock(pos)
	local blockpos = bedwars.BlockController:getBlockPosition(pos)
	return bedwars.BlockController:getStore():getBlockAt(blockpos), blockpos
end

getfunctions()

local function getNametagString(plr)
	local nametag = ""
	local hash = WhitelistFunctions:Hash(plr.Name..plr.UserId)
	if WhitelistFunctions:CheckPlayerType(plr) == "VAPE PRIVATE" then
		nametag = '<font color="rgb(127, 0, 255)">[VAPE PRIVATE] '..(plr.Name)..'</font>'
	end
	if WhitelistFunctions:CheckPlayerType(plr) == "VAPE OWNER" then
		nametag = '<font color="rgb(255, 80, 80)">[VAPE OWNER] '..(plr.DisplayName or plr.Name)..'</font>'
	end
	if clients.ClientUsers[tostring(plr)] then
		nametag = '<font color="rgb(255, 255, 0)">['..clients.ClientUsers[tostring(plr)]..'] '..(plr.DisplayName or plr.Name)..'</font>'
	end
	if WhitelistFunctions.WhitelistTable.chattags[hash] then
		local data = WhitelistFunctions.WhitelistTable.chattags[hash]
		local newnametag = ""
		if data.Tags then
			for i2,v2 in pairs(data.Tags) do
				newnametag = newnametag..'<font color="rgb('..math.floor(v2.TagColor.r * 255)..', '..math.floor(v2.TagColor.g * 255)..', '..math.floor(v2.TagColor.b * 255)..')">['..v2.TagText..']</font> '
			end
		end
		nametag = newnametag..(newnametag.NameColor and '<font color="rgb('..math.floor(newnametag.NameColor.r * 255)..', '..math.floor(newnametag.NameColor.g * 255)..', '..math.floor(newnametag.NameColor.b * 255)..')">' or '')..(plr.DisplayName or plr.Name)..(newnametag.NameColor and '</font>' or '')
	end
	return nametag
end

local function Cape(char, texture)
	for i,v in pairs(char:GetDescendants()) do
		if v.Name == "Cape" then
			v:Remove()
		end
	end
	local hum = char:WaitForChild("Humanoid")
	local torso = nil
	if hum.RigType == Enum.HumanoidRigType.R15 then
	torso = char:WaitForChild("UpperTorso")
	else
	torso = char:WaitForChild("Torso")
	end
	local p = Instance.new("Part", torso.Parent)
	p.Name = "Cape"
	p.Anchored = false
	p.CanCollide = false
	p.TopSurface = 0
	p.BottomSurface = 0
	p.FormFactor = "Custom"
	p.Size = Vector3.new(0.2,0.2,0.2)
	p.Transparency = 1
	local decal = Instance.new("Decal", p)
	decal.Texture = texture
	decal.Face = "Back"
	local msh = Instance.new("BlockMesh", p)
	msh.Scale = Vector3.new(9,17.5,0.5)
	local motor = Instance.new("Motor", p)
	motor.Part0 = p
	motor.Part1 = torso
	motor.MaxVelocity = 0.01
	motor.C0 = CFrame.new(0,2,0) * CFrame.Angles(0,math.rad(90),0)
	motor.C1 = CFrame.new(0,1,0.45) * CFrame.Angles(0,math.rad(90),0)
	local wave = false
	repeat wait(1/44)
		decal.Transparency = torso.Transparency
		local ang = 0.1
		local oldmag = torso.Velocity.magnitude
		local mv = 0.002
		if wave then
			ang = ang + ((torso.Velocity.magnitude/10) * 0.05) + 0.05
			wave = false
		else
			wave = true
		end
		ang = ang + math.min(torso.Velocity.magnitude/11, 0.5)
		motor.MaxVelocity = math.min((torso.Velocity.magnitude/111), 0.04) --+ mv
		motor.DesiredAngle = -ang
		if motor.CurrentAngle < -0.2 and motor.DesiredAngle > -0.2 then
			motor.MaxVelocity = 0.04
		end
		repeat wait() until motor.CurrentAngle == motor.DesiredAngle or math.abs(torso.Velocity.magnitude - oldmag) >= (torso.Velocity.magnitude/10) + 1
		if torso.Velocity.magnitude < 0.1 then
			wait(0.1)
		end
	until not p or p.Parent ~= torso.Parent
end

local function getSpeedMultiplier(reduce)
	local speed = 1
	if lplr.Character then 
		local speedboost = lplr.Character:GetAttribute("SpeedBoost")
		if speedboost and speedboost > 1 then 
			speed = speed + (speedboost - 1)
		end
		if lplr.Character:GetAttribute("GrimReaperChannel") then 
			speed = speed + 0.6
		end
		if lplr.Character:GetAttribute("SpeedPieBuff") then 
			speed = speed + (queueType == "SURVIVAL" and 0.15 or 0.24)
		end
		local armor = currentinventory.inventory.armor[3]
		if type(armor) ~= "table" then armor = {itemType = ""} end
		if armor.itemType == "speed_boots" then 
			speed = speed + 1
		end
		if zephyrorbs ~= 0 then 
			speed = speed + 1
		end
	end
	return reduce and speed ~= 1 and math.max(speed * (0.8 - (0.3 * math.floor(speed))), 1) or speed
end

runcode(function()
	local function disguisechar(char, id)
		task.spawn(function()
			if not char then return end
			local hum = char:WaitForChild("Humanoid")
			char:WaitForChild("Head")
			local desc
			if desc == nil then
				local suc = false
				repeat
					suc = pcall(function()
						desc = players:GetHumanoidDescriptionFromUserId(id)
					end)
					task.wait(1)
				until suc
			end
			desc.HeightScale = hum:WaitForChild("HumanoidDescription").HeightScale
			char.Archivable = true
			local disguiseclone = char:Clone()
			disguiseclone.Name = "disguisechar"
			disguiseclone.Parent = workspace
			for i,v in pairs(disguiseclone:GetChildren()) do 
				if v:IsA("Accessory") or v:IsA("ShirtGraphic") or v:IsA("Shirt") or v:IsA("Pants") then  
					v:Destroy()
				end
			end
			disguiseclone.Humanoid:ApplyDescriptionClientServer(desc)
			for i,v in pairs(char:GetChildren()) do 
				if (v:IsA("Accessory") and v:GetAttribute("InvItem") == nil and v:GetAttribute("ArmorSlot") == nil) or v:IsA("ShirtGraphic") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("BodyColors") then 
					v.Parent = game
				end
			end
			char.ChildAdded:Connect(function(v)
				if ((v:IsA("Accessory") and v:GetAttribute("InvItem") == nil and v:GetAttribute("ArmorSlot") == nil) or v:IsA("ShirtGraphic") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("BodyColors")) and v:GetAttribute("Disguise") == nil then 
					repeat task.wait() v.Parent = game until v.Parent == game
				end
			end)
			for i,v in pairs(disguiseclone:WaitForChild("Animate"):GetChildren()) do 
				v:SetAttribute("Disguise", true)
				local real = char.Animate:FindFirstChild(v.Name)
				if v:IsA("StringValue") and real then 
					real.Parent = game
					v.Parent = char.Animate
				end
			end
			for i,v in pairs(disguiseclone:GetChildren()) do 
				v:SetAttribute("Disguise", true)
				if v:IsA("Accessory") then  
					for i2,v2 in pairs(v:GetDescendants()) do 
						if v2:IsA("Weld") and v2.Part1 then 
							v2.Part1 = char[v2.Part1.Name]
						end
					end
					v.Parent = char
				elseif v:IsA("ShirtGraphic") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("BodyColors") then  
					v.Parent = char
				elseif v.Name == "Head" then 
					char.Head.MeshId = v.MeshId
				end
			end
			local localface = char:FindFirstChild("face", true)
			local cloneface = disguiseclone:FindFirstChild("face", true)
			if localface and cloneface then localface.Parent = game cloneface.Parent = char.Head end
			char.Humanoid.HumanoidDescription:SetEmotes(desc:GetEmotes())
			char.Humanoid.HumanoidDescription:SetEquippedEmotes(desc:GetEquippedEmotes())
			disguiseclone:Destroy()
		end)
	end

	local function renderNametag(plr)
		if (WhitelistFunctions:CheckPlayerType(plr) ~= "DEFAULT" or WhitelistFunctions.WhitelistTable.chattags[WhitelistFunctions:Hash(plr.Name..plr.UserId)]) then
			local playerlist = game:GetService("CoreGui"):FindFirstChild("PlayerList")
			if playerlist then
				pcall(function()
					local playerlistplayers = playerlist.PlayerListMaster.OffsetFrame.PlayerScrollList.SizeOffsetFrame.ScrollingFrameContainer.ScrollingFrameClippingFrame.ScollingFrame.OffsetUndoFrame
					local targetedplr = playerlistplayers:FindFirstChild("p_"..plr.UserId)
					if targetedplr then 
						targetedplr.ChildrenFrame.NameFrame.BGFrame.OverlayFrame.PlayerIcon.Image = getcustomassetfunc("vape/assets/VapeIcon.png")
					end
				end)
			end
			if lplr ~= plr and WhitelistFunctions:CheckPlayerType(lplr) == "DEFAULT" then
				task.spawn(function()
					repeat task.wait() until plr:GetAttribute("LobbyConnected")
					task.wait(4)
					repstorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("/w "..plr.Name.." "..clients.ChatStrings2.vape, "All")
					task.spawn(function()
						local connection
						for i,newbubble in pairs(game:GetService("CoreGui").BubbleChat:GetDescendants()) do
							if newbubble:IsA("TextLabel") and newbubble.Text:find(clients.ChatStrings2.vape) then
								newbubble.Parent.Parent.Visible = false
								repeat task.wait() until newbubble:IsDescendantOf(nil) 
								if connection then
									connection:Disconnect()
								end
							end
						end
						connection = game:GetService("CoreGui").BubbleChat.DescendantAdded:Connect(function(newbubble)
							if newbubble:IsA("TextLabel") and newbubble.Text:find(clients.ChatStrings2.vape) then
								newbubble.Parent.Parent.Visible = false
								repeat task.wait() until newbubble:IsDescendantOf(nil)
								if connection then
									connection:Disconnect()
								end
							end
						end)
					end)
					repstorage.DefaultChatSystemChatEvents.OnMessageDoneFiltering.OnClientEvent:Wait()
					task.wait(0.2)
					if getconnections then
						for i,v in pairs(getconnections(repstorage.DefaultChatSystemChatEvents.OnNewMessage.OnClientEvent)) do
							if v.Function and #debug.getupvalues(v.Function) > 0 and type(debug.getupvalues(v.Function)[1]) == "table" and getmetatable(debug.getupvalues(v.Function)[1]) and getmetatable(debug.getupvalues(v.Function)[1]).GetChannel then
								debug.getupvalues(v.Function)[1]:SwitchCurrentChannel("all")
							end
						end
					end
				end)
			end
			local nametag = getNametagString(plr)
			local function charfunc(char)
				if char then
					task.spawn(function()
						pcall(function() 
							bedwars["EntityUtil"]:getEntity(plr):setNametag(nametag)
							task.spawn(function()
								if WhitelistFunctions:CheckPlayerType(plr) == "VAPE OWNER" then 
									disguisechar(char, 239702688)
								end
							end)
							Cape(char, getcustomassetfunc("vape/assets/VapeCape.png"))
						end)
					end)
				end
			end

			charfunc(plr.Character)
			connectionstodisconnect[#connectionstodisconnect + 1] = plr.CharacterAdded:Connect(charfunc)
		end
	end

	task.spawn(function()
		repeat task.wait() until WhitelistFunctions.Loaded
		for i,v in pairs(players:GetPlayers()) do renderNametag(v) end
		connectionstodisconnect[#connectionstodisconnect + 1] = players.PlayerAdded:Connect(renderNametag)
	end)
end)

local function isFriend(plr, recolor)
	if GuiLibrary.ObjectsThatCanBeSaved["Use FriendsToggle"].Api.Enabled then
		local friend = table.find(GuiLibrary.ObjectsThatCanBeSaved.FriendsListTextCircleList.Api.ObjectList, plr.Name)
		friend = friend and GuiLibrary.ObjectsThatCanBeSaved.FriendsListTextCircleList.Api.ObjectListEnabled[friend]
		if recolor then
			friend = friend and GuiLibrary.ObjectsThatCanBeSaved["Recolor visualsToggle"].Api.Enabled
		end
		return friend
	end
	return nil
end

local function getPlayerColor(plr)
	return (isFriend(plr, true) and Color3.fromHSV(GuiLibrary.ObjectsThatCanBeSaved["Friends ColorSliderColor"]["Api"]["Hue"], GuiLibrary.ObjectsThatCanBeSaved["Friends ColorSliderColor"]["Api"]["Sat"], GuiLibrary.ObjectsThatCanBeSaved["Friends ColorSliderColor"]["Api"].Value) or tostring(plr.TeamColor) ~= "White" and plr.TeamColor.Color)
end

local function targetCheck(plr)
	return plr and plr.Humanoid and plr.Humanoid.Health > 0 and plr.Character:FindFirstChild("ForceField") == nil
end

local cache = {}
do
	entityLibrary.selfDestruct()
	entityLibrary.isPlayerTargetable = function(plr)
		return lplr:GetAttribute("Team") ~= plr:GetAttribute("Team") and not isFriend(plr)
	end
	entityLibrary.characterAdded = function(plr, char, localcheck)
		local id = game:GetService("HttpService"):GenerateGUID(true)
		entityLibrary.entityIds[plr.Name] = id
        if char then
            task.spawn(function()
                local humrootpart = char:WaitForChild("HumanoidRootPart", 10)
                local head = char:WaitForChild("Head", 10)
                local hum = char:WaitForChild("Humanoid", 10)
				if entityLibrary.entityIds[plr.Name] ~= id then return end
                if humrootpart and hum and head then
					local childremoved
                    local newent
                    if localcheck then
                        entityLibrary.isAlive = true
                        entityLibrary.character.Head = head
                        entityLibrary.character.Humanoid = hum
                        entityLibrary.character.HumanoidRootPart = humrootpart
                    else
						newent = {
                            Player = plr,
                            Character = char,
                            HumanoidRootPart = humrootpart,
                            RootPart = humrootpart,
                            Head = head,
                            Humanoid = hum,
                            Targetable = entityLibrary.isPlayerTargetable(plr),
                            Team = plr.Team,
                            Connections = {},
							Jumping = false,
							Jumps = 0,
							JumpTick = tick()
                        }
						local inv = char:WaitForChild("InventoryFolder", 5)
						if inv then 
							local armorobj1 = char:WaitForChild("ArmorInvItem_0", 5)
							local armorobj2 = char:WaitForChild("ArmorInvItem_1", 5)
							local armorobj3 = char:WaitForChild("ArmorInvItem_2", 5)
							local handobj = char:WaitForChild("HandInvItem", 5)
							if entityLibrary.entityIds[plr.Name] ~= id then return end
							if armorobj1 then
								table.insert(newent.Connections, armorobj1.Changed:Connect(function() 
									task.delay(0.3, function() 
										inventories[plr] = bedwars.getInventory(plr) 
										entityLibrary.entityUpdatedEvent:Fire(newent)
									end)
								end))
							end
							if armorobj2 then
								table.insert(newent.Connections, armorobj2.Changed:Connect(function() 
									task.delay(0.3, function() 
										inventories[plr] = bedwars.getInventory(plr) 
										entityLibrary.entityUpdatedEvent:Fire(newent)
									end)
								end))
							end
							if armorobj3 then
								table.insert(newent.Connections, armorobj3.Changed:Connect(function() 
									task.delay(0.3, function() 
										inventories[plr] = bedwars.getInventory(plr) 
										entityLibrary.entityUpdatedEvent:Fire(newent)
									end)
								end))
							end
							if handobj then
								table.insert(newent.Connections, handobj.Changed:Connect(function() 
									task.delay(0.3, function() 
										inventories[plr] = bedwars.getInventory(plr)
										entityLibrary.entityUpdatedEvent:Fire(newent)
									end)
								end))
							end
						end
						if entityLibrary.entityIds[plr.Name] ~= id then return end
						task.delay(0.3, function() 
							inventories[plr] = bedwars.getInventory(plr) 
							entityLibrary.entityUpdatedEvent:Fire(newent)
						end)
						table.insert(newent.Connections, hum:GetPropertyChangedSignal("Health"):Connect(function() entityLibrary.entityUpdatedEvent:Fire(newent) end))
						table.insert(newent.Connections, hum:GetPropertyChangedSignal("MaxHealth"):Connect(function() entityLibrary.entityUpdatedEvent:Fire(newent) end))
						table.insert(newent.Connections, hum.AnimationPlayed:Connect(function(state) 
							if not cache[state.Animation.AnimationId] then 
								cache[state.Animation.AnimationId] = game:GetService("MarketplaceService"):GetProductInfo(tonumber(({state.Animation.AnimationId:gsub("%D+", "")})[1]))
							end
							if cache[state.Animation.AnimationId].Name:lower():find("jump") then
								newent.Jumps = newent.Jumps + 1
							end
						end))
						table.insert(newent.Connections, char.AttributeChanged:Connect(function(attr) if attr:find("Shield") then entityLibrary.entityUpdatedEvent:Fire(newent) end end))
						table.insert(entityLibrary.entityList, newent)
						entityLibrary.entityAddedEvent:Fire(newent)
                    end
					if entityLibrary.entityIds[plr.Name] ~= id then return end
					childremoved = char.ChildRemoved:Connect(function(part)
						if part.Name == "HumanoidRootPart" or part.Name == "Head" or part.Name == "Humanoid" then			
							if localcheck then
								if char == lplr.Character then
									if part.Name == "HumanoidRootPart" then
										entityLibrary.isAlive = false
										local root = char:FindFirstChild("HumanoidRootPart")
										if not root then 
											root = char:WaitForChild("HumanoidRootPart", 3)
										end
										if root then 
											entityLibrary.character.HumanoidRootPart = root
											entityLibrary.isAlive = true
										end
									else
										entityLibrary.isAlive = false
									end
								end
							else
								childremoved:Disconnect()
								entityLibrary.removeEntity(plr)
							end
						end
					end)
					if newent then 
						table.insert(newent.Connections, childremoved)
					end
					table.insert(entityLibrary.entityConnections, childremoved)
                end
            end)
        end
    end
	entityLibrary.entityAdded = function(plr, localcheck, custom)
		table.insert(entityLibrary.entityConnections, plr:GetPropertyChangedSignal("Character"):Connect(function()
            if plr.Character then
                entityLibrary.refreshEntity(plr, localcheck)
            else
                if localcheck then
                    entityLibrary.isAlive = false
                else
                    entityLibrary.removeEntity(plr)
                end
            end
        end))
        table.insert(entityLibrary.entityConnections, plr:GetAttributeChangedSignal("Team"):Connect(function()
			local tab = {}
			for i,v in next, entityLibrary.entityList do
                if v.Targetable ~= entityLibrary.isPlayerTargetable(v.Player) then 
                    table.insert(tab, v)
                end
            end
			for i,v in next, tab do 
				entityLibrary.refreshEntity(v.Player)
			end
            if localcheck then
                entityLibrary.fullEntityRefresh()
            else
				entityLibrary.refreshEntity(plr, localcheck)
            end
        end))
		if plr.Character then
            task.spawn(entityLibrary.refreshEntity, plr, localcheck)
        end
    end
	entityLibrary.fullEntityRefresh()
end

local function switchItem(tool, legit)
	if legit then
		local hotbarslot = getHotbarSlot(tool.Name)
		if hotbarslot then 
			bedwars.ClientStoreHandler:dispatch({
				type = "InventorySelectHotbarSlot", 
				slot = hotbarslot
			})
		end
	end
	pcall(function()
		lplr.Character.HandInvItem.Value = tool
	end)
	bedwars.ClientHandler:Get(bedwars["EquipItemRemote"]):CallServerAsync({
		hand = tool
	})
end

local updateitem = Instance.new("BindableEvent")
runcode(function()
	local inputobj = nil
	local tempconnection
	tempconnection = uis.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			inputobj = input
			tempconnection:Disconnect()
		end
	end)
	connectionstodisconnect[#connectionstodisconnect + 1] = updateitem.Event:Connect(function(inputObj)
		if uis:IsMouseButtonPressed(0) then
			game:GetService("ContextActionService"):CallFunction("block-break", Enum.UserInputState.Begin, inputobj)
		end
	end)
end)

local function getBestTool(block)
    local tool = nil
	local blockmeta = bedwars.ItemTable[block]
	local blockType = blockmeta["block"] and blockmeta["block"]["breakType"]
	if blockType then
		for i,v in pairs(currentinventory.inventory.items) do
			local meta = bedwars.ItemTable[v.itemType]
			if meta["breakBlock"] and meta["breakBlock"][blockType] then
				tool = v
				break
			end
		end
	end
    return tool
end

local function switchToAndUseTool(block, legit)
	local tool = getBestTool(block.Name)
	if tool and (entityLibrary.isAlive and lplr.Character:FindFirstChild("HandInvItem") and lplr.Character.HandInvItem.Value ~= tool["tool"]) then
		if legit then
			if getHotbarSlot(tool.itemType) then
				bedwars.ClientStoreHandler:dispatch({
					type = "InventorySelectHotbarSlot", 
					slot = getHotbarSlot(tool.itemType)
				})
				task.wait(0.1)
				updateitem:Fire(inputobj)
				return true
			else
				return false
			end
		end
		switchItem(tool["tool"])
		task.wait(0.1)
	end
end

local normalsides = {}
for i,v in pairs(Enum.NormalId:GetEnumItems()) do if v.Name ~= "Bottom" then table.insert(normalsides, v) end end

local function isBlockCovered(pos)
	local coveredsides = 0
	for i, v in pairs(normalsides) do
		local blockpos = (pos + (Vector3.FromNormalId(v) * 3))
		local block = getblock(blockpos)
		if block then
			coveredsides = coveredsides + 1
		end
	end
	return coveredsides == #normalsides
end

local blacklistedblocks = {
	bed = true,
	ceramic = true
}
local function getallblocks(pos, normal)
	local blocks = {}
	local lastfound = nil
	for i = 1, 20 do
		local blockpos = (pos + (Vector3.FromNormalId(normal) * (i * 3)))
		local extrablock = getblock(blockpos)
		local covered = isBlockCovered(blockpos)
		if extrablock then
			if bedwars.BlockController:isBlockBreakable({blockPosition = blockpos}, lplr) and (not blacklistedblocks[extrablock.Name]) then
				table.insert(blocks, extrablock.Name)
			end
			lastfound = extrablock
			if not covered then
				break
			end
		else
			break
		end
	end
	return blocks
end

local function getlastblock(pos, normal)
	local lastfound, lastpos = nil, nil
	for i = 1, 20 do
		local blockpos = (pos + (Vector3.FromNormalId(normal) * (i * 3)))
		local extrablock, extrablockpos = getblock(blockpos)
		local covered = isBlockCovered(blockpos)
		if extrablock then
			lastfound, lastpos = extrablock, extrablockpos
			if not covered then
				break
			end
		else
			break
		end
	end
	return lastfound, lastpos
end

local healthbarblocktable = {
	["blockHealth"] = -1,
	["breakingBlockPosition"] = Vector3.zero
}
bedwars.breakBlock = function(pos, effects, normal, bypass, anim)
    if lplr:GetAttribute("DenyBlockBreak") == true then
		return nil
	end
	local block, blockpos = nil, nil
	if not bypass then block, blockpos = getlastblock(pos, normal) end
	if not block then block, blockpos = getblock(pos) end
    if blockpos and block then
        if bedwars["BlockEngineClientEvents"].DamageBlock:fire(block.Name, blockpos, block):isCancelled() then
            return nil
        end
        local blockhealthbarpos = {blockPosition = Vector3.zero}
        local blockdmg = 0
        if block and block.Parent ~= nil then
			if ((oldcloneroot and oldcloneroot.Position or entityLibrary.LocalPosition or entityLibrary.character.HumanoidRootPart.Position) - (blockpos * 3)).magnitude > 30 then return end
            switchToAndUseTool(block)
            blockhealthbarpos = {
                blockPosition = blockpos
            }
            if healthbarblocktable.blockHealth == -1 or blockhealthbarpos.blockPosition ~= healthbarblocktable.breakingBlockPosition then
				local blockdata = bedwars.BlockController:getStore():getBlockData(blockhealthbarpos.blockPosition)
				local blockhealth = blockdata and blockdata:GetAttribute(lplr.Name .. "_Health") or block:GetAttribute("Health")
				healthbarblocktable.blockHealth = blockhealth
				healthbarblocktable.breakingBlockPosition = blockhealthbarpos.blockPosition
			end
            blockdmg = bedwars.BlockController:calculateBlockDamage(lplr, blockhealthbarpos)
		    bedwars["ClientHandlerDamageBlock"]:Get("DamageBlock"):CallServerAsync({
                blockRef = blockhealthbarpos, 
                hitPosition = blockpos * 3, 
                hitNormal = Vector3.FromNormalId(normal)
            }):andThen(function(result)
				if result ~= "failed" then
					healthbarblocktable.blockHealth = math.max(healthbarblocktable.blockHealth - blockdmg, 0)
					if effects then
						bedwars["BlockBreaker"]:updateHealthbar(blockhealthbarpos, healthbarblocktable.blockHealth, block:GetAttribute("MaxHealth"), blockdmg, block)
						if healthbarblocktable.blockHealth <= 0 then
							bedwars["BlockBreaker"].breakEffect:playBreak(block.Name, blockhealthbarpos.blockPosition, lplr)
							bedwars["BlockBreaker"].healthbarMaid:DoCleaning()
							healthbarblocktable.breakingBlockPosition = Vector3.zero
						else
							bedwars["BlockBreaker"].breakEffect:playHit(block.Name, blockhealthbarpos.blockPosition, lplr)
						end
					end
				end
			end)
			local animation
			if anim then
				animation = bedwars["AnimationUtil"]:playAnimation(lplr, bedwars.BlockController:getAnimationController():getAssetId(1))
				bedwars.ViewmodelController:playAnimation(15)
			end
			task.wait(0.3)
			if animation ~= nil then
				animation:Stop()
			end
			if animation ~= nil then
				animation:Destroy()
			end
        end
    end
end	

local function getEquipped()
	local typetext = ""
	local obj = currentinventory.inventory.hand
	if obj then
		local metatab = bedwars.ItemTable[obj.itemType]
		typetext = metatab.sword and "sword" or metatab.block and "block" or obj.itemType:find("bow") and "bow"
	end
    return {Object = obj and obj.tool, ["Type"] = typetext}
end

local function GetAllNearestHumanoidToPosition(player, distance, amount, targetcheck, overridepos, sortfunc, funny)
	local returnedplayer = {}
	local currentamount = 0
    if entityLibrary.isAlive then -- alive check
        for i, v in pairs(entityLibrary.entityList) do -- loop through players
            if (v.Targetable or targetcheck) and targetCheck(v) then -- checks
				local pos = funny and entityLibrary.OtherPosition[v.Player] or v.RootPart.Position
                local mag = (entityLibrary.character.HumanoidRootPart.Position - pos).magnitude
				if overridepos and mag > distance then 
					mag = (overridepos - pos).magnitude
				end
                if mag <= distance then -- mag check
                    table.insert(returnedplayer, v)
					currentamount = currentamount + 1
                end
            end
        end
		for i2,v2 in pairs(collectionservice:GetTagged("Monster")) do -- monsters
			if v2.PrimaryPart and currentamount < amount and v2:GetAttribute("Team") ~= lplr:GetAttribute("Team") then -- no duck
				local mag = (entityLibrary.character.HumanoidRootPart.Position - v2.PrimaryPart.Position).magnitude
				if overridepos and mag > distance then 
					mag = (overridepos - v2.PrimaryPart.Position).magnitude
				end
                if mag <= distance then -- magcheck
                    table.insert(returnedplayer, {Player = {Name = (v2 and v2.Name or "Monster"), UserId = (v2 and v2.Name == "Duck" and 2020831224 or 1443379645)}, Character = v2, RootPart = v2.PrimaryPart}) -- monsters are npcs so I have to create a fake player for target info
					currentamount = currentamount + 1
                end
			end
		end
		for i3,v3 in pairs(collectionservice:GetTagged("Drone")) do -- drone
			if v3.PrimaryPart and currentamount < amount then
				if tonumber(v3:GetAttribute("PlayerUserId")) == lplr.UserId then continue end
				local droneplr = players:GetPlayerByUserId(v3:GetAttribute("PlayerUserId"))
				if droneplr and droneplr.Team == lplr.Team then continue end
				local mag = (entityLibrary.character.HumanoidRootPart.Position - v3.PrimaryPart.Position).magnitude
				if overridepos and mag > distance then 
					mag = (overridepos - v3.PrimaryPart.Position).magnitude
				end
                if mag <= distance then -- magcheck
                    table.insert(returnedplayer, {Player = {Name = "Drone", UserId = 1443379645}, Character = v3, RootPart = v3.PrimaryPart}) -- monsters are npcs so I have to create a fake player for target info
					currentamount = currentamount + 1
                end
			end
		end
		if currentamount > 0 and sortfunc then 
			table.sort(returnedplayer, sortfunc)
			returnedplayer = {returnedplayer[1]}
		end
	end
	return returnedplayer -- table of attackable entities
end

GetNearestHumanoidToMouse = function(player, distance, checkvis)
	local closest, returnedplayer = distance, nil
	if entityLibrary.isAlive then
		for i, v in pairs(entityLibrary.entityList) do
			if v.Targetable then
				local vec, vis = cam:WorldToScreenPoint(v.RootPart.Position)
				if vis and targetCheck(v) then
					local mag = (uis:GetMouseLocation() - Vector2.new(vec.X, vec.Y)).magnitude
					if mag <= (v.Target and distance or closest) then
						closest = mag
						returnedplayer = v
						if v.Target then
							break
						end
					end
				end
			end
		end
	end
	return returnedplayer, closest
end

local function GetNearestHumanoidToPosition(player, distance, overridepos)
	local closest, returnedplayer = distance, nil
    if entityLibrary.isAlive then
        for i, v in pairs(entityLibrary.entityList) do
			if v.Targetable and targetCheck(v) then
				local mag = (entityLibrary.character.HumanoidRootPart.Position - v.RootPart.Position).magnitude
				if overridepos and mag > distance then 
					mag = (overridepos - v.RootPart.Position).magnitude
				end
				if mag <= (v.Target and distance or closest) then
					closest = mag
					returnedplayer = v
					if v.Target then
						break
					end
				end
			end
        end
		for i2,v2 in pairs(collectionservice:GetTagged("Monster")) do -- monsters
			if v2.PrimaryPart and v2:GetAttribute("Team") ~= lplr:GetAttribute("Team") then -- no duck
				local mag = (entityLibrary.character.HumanoidRootPart.Position - v2.PrimaryPart.Position).magnitude
				if overridepos and mag > distance then 
					mag = (overridepos - v2.PrimaryPart.Position).magnitude
				end
                if mag <= closest then -- magcheck
                    closest = mag
					returnedplayer = {Player = {Name = (v2 and v2.Name or "Monster"), UserId = (v2 and v2.Name == "Duck" and 2020831224 or 1443379645)}, Character = v2, RootPart = v2.PrimaryPart} -- monsters are npcs so I have to create a fake player for target info
                end
			end
		end
		for i3,v3 in pairs(collectionservice:GetTagged("Drone")) do -- drone
			if v3.PrimaryPart then
				if tonumber(v3:GetAttribute("PlayerUserId")) == lplr.UserId then continue end
				local droneplr = players:GetPlayerByUserId(v3:GetAttribute("PlayerUserId"))
				if droneplr and droneplr.Team == lplr.Team then continue end
				local mag = (entityLibrary.character.HumanoidRootPart.Position - v3.PrimaryPart.Position).magnitude
				if overridepos and mag > distance then 
					mag = (overridepos - v3.PrimaryPart.Position).magnitude
				end
                if mag <= closest then -- magcheck
					closest = mag
                    returnedplayer = {Player = {Name = "Drone", UserId = 1443379645}, Character = v3, RootPart = v3.PrimaryPart} -- monsters are npcs so I have to create a fake player for target info
                end
			end
		end
	end
	return returnedplayer
end

runcode(function()
	local handsquare = Instance.new("ImageLabel")
	handsquare.Size = UDim2.new(0, 26, 0, 27)
	handsquare.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
	handsquare.Position = UDim2.new(0, 72, 0, 39)
	handsquare.Parent = targetinfo.Object.GetCustomChildren().Frame.MainInfo
	local handround = Instance.new("UICorner")
	handround.CornerRadius = UDim.new(0, 4)
	handround.Parent = handsquare
	local helmetsquare = handsquare:Clone()
	helmetsquare.Position = UDim2.new(0, 100, 0, 39)
	helmetsquare.Parent = targetinfo.Object.GetCustomChildren().Frame.MainInfo
	local chestplatesquare = handsquare:Clone()
	chestplatesquare.Position = UDim2.new(0, 127, 0, 39)
	chestplatesquare.Parent = targetinfo.Object.GetCustomChildren().Frame.MainInfo
	local bootssquare = handsquare:Clone()
	bootssquare.Position = UDim2.new(0, 155, 0, 39)
	bootssquare.Parent = targetinfo.Object.GetCustomChildren().Frame.MainInfo
	local uselesssquare = handsquare:Clone()
	uselesssquare.Position = UDim2.new(0, 182, 0, 39)
	uselesssquare.Parent = targetinfo.Object.GetCustomChildren().Frame.MainInfo
	local oldupdate = targetinfo["UpdateInfo"]
	targetinfo["UpdateInfo"] = function(tab, targetsize)
		local bkgcheck = targetinfo.Object.GetCustomChildren().Frame.MainInfo.BackgroundTransparency == 1
		handsquare.BackgroundTransparency = bkgcheck and 1 or 0
		helmetsquare.BackgroundTransparency = bkgcheck and 1 or 0
		chestplatesquare.BackgroundTransparency = bkgcheck and 1 or 0
		bootssquare.BackgroundTransparency = bkgcheck and 1 or 0
		uselesssquare.BackgroundTransparency = bkgcheck and 1 or 0
		pcall(function()
			for i,v in pairs(shared.VapeTargetInfo.Targets) do
				local inventory = inventories[v.Player] or {}
					if inventory.hand then
						handsquare.Image = bedwars.getIcon(inventory.hand, true)
					else
						handsquare.Image = ""
					end
					if inventory.armor[4] then
						helmetsquare.Image = bedwars.getIcon(inventory.armor[4], true)
					else
						helmetsquare.Image = ""
					end
					if inventory.armor[5] then
						chestplatesquare.Image = bedwars.getIcon(inventory.armor[5], true)
					else
						chestplatesquare.Image = ""
					end
					if inventory.armor[6] then
						bootssquare.Image = bedwars.getIcon(inventory.armor[6], true)
					else
						bootssquare.Image = ""
					end
				break
			end
		end)
		return oldupdate(tab, targetsize)
	end
end)

local function getBow()
	local bestsword, bestswordslot, bestswordnum = nil, nil, 0
	for i5, v5 in pairs(currentinventory.inventory.items) do
		if v5.itemType:find("bow") then 
			local tab = bedwars.ItemTable[v5.itemType].projectileSource
			local ammo = tab.projectileType("arrow")	
			local dmg = bedwars.ProjectileMeta[ammo].combat.damage
			if dmg > bestswordnum then
				bestswordnum = dmg
				bestswordslot = i5
				bestsword = v5
			end
		end
	end
	return bestsword, bestswordslot
end

local function getCustomItem(v2)
	local realitem = v2.itemType
	if realitem == "swords" then
		realitem = getSword() and getSword().itemType or "wood_sword"
	elseif realitem == "pickaxes" then
		realitem = getPickaxe() and getPickaxe().itemType or "wood_pickaxe"
	elseif realitem == "axes" then
		realitem = getAxe() and getAxe().itemType or "wood_axe"
	elseif realitem == "bows" then
		realitem = getBow() and getBow().itemType or "wood_bow"
	elseif realitem == "wool" then
		realitem = getwool() or "wool_white"
	end
	return realitem
end

local function findItemInTable(tab, item)
	for i,v in pairs(tab) do
		if v.itemType then
			local gottenitem, gottenitemnum = getItem(getCustomItem(v))
			if gottenitem and gottenitem.itemType == item.itemType then
				return i
			end
		end
	end
	return nil
end

GuiLibrary.RemoveObject("SilentAimOptionsButton")
GuiLibrary.RemoveObject("ReachOptionsButton")
GuiLibrary.RemoveObject("MouseTPOptionsButton")
GuiLibrary.RemoveObject("PhaseOptionsButton")
GuiLibrary.RemoveObject("AutoClickerOptionsButton")
GuiLibrary.RemoveObject("SpiderOptionsButton")
GuiLibrary.RemoveObject("LongJumpOptionsButton")
GuiLibrary.RemoveObject("HitBoxesOptionsButton")
GuiLibrary.RemoveObject("KillauraOptionsButton")
GuiLibrary.RemoveObject("TriggerBotOptionsButton")
GuiLibrary.RemoveObject("AutoReportOptionsButton")
GuiLibrary.RemoveObject("AutoLeaveOptionsButton")
GuiLibrary.RemoveObject("SpeedOptionsButton")
GuiLibrary.RemoveObject("FlyOptionsButton")
GuiLibrary.RemoveObject("ClientKickDisablerOptionsButton")
GuiLibrary.RemoveObject("NameTagsOptionsButton")
GuiLibrary.RemoveObject("CapeOptionsButton")
GuiLibrary.RemoveObject("SafeWalkOptionsButton")
GuiLibrary.RemoveObject("BlinkOptionsButton")
GuiLibrary.RemoveObject("FOVChangerOptionsButton")
GuiLibrary.RemoveObject("AntiVoidOptionsButton")

runcode(function()
	local AutoHotbarList = {["Hotbars"] = {}, ["CurrentlySelected"] = 1}
	local AutoHotbarMode = {Value = "Toggle"}
	local AutoHotbar = {Enabled = false}
	local AutoHotbarConnection

	local function findinhotbar(item)
		for i,v in pairs(currentinventory.hotbar) do
			if v.item and v.item.itemType == getCustomItem(item) then
				return i, v.item
			end
		end
	end

	local function findininventory(item)
		for i,v in pairs(currentinventory.inventory.items) do
			if v.itemType == item.itemType then
				return v
			end
		end
	end

	local function AutoHotbarSort()
		task.spawn(function()
			task.wait(0.2)
			local items = (AutoHotbarList["Hotbars"][AutoHotbarList["CurrentlySelected"]] and AutoHotbarList["Hotbars"][AutoHotbarList["CurrentlySelected"]]["Items"] or {})
			for i,v in pairs(currentinventory.inventory.items) do 
				local hotbarslot = findItemInTable(items, v)
				if hotbarslot then
					local oldhotbaritem = currentinventory.hotbar[tonumber(hotbarslot)]
					local newhotbaritemslot, newhotbaritem = findinhotbar(v)
					if oldhotbaritem.item and oldhotbaritem.item.itemType == v.itemType then continue end
					if oldhotbaritem.item then 
						bedwars.ClientStoreHandler:dispatch({
							type = "InventoryRemoveFromHotbar", 
							slot = tonumber(hotbarslot) - 1
						})
					end
					if newhotbaritemslot then 
						bedwars.ClientStoreHandler:dispatch({
							type = "InventoryRemoveFromHotbar", 
							slot = newhotbaritemslot - 1
						})
					end
					if oldhotbaritem.item then 
						local nextitem1, nextitem1num = findininventory(oldhotbaritem.item)
						bedwars.ClientStoreHandler:dispatch({
							type = "InventoryAddToHotbar", 
							item = nextitem1, 
							slot = newhotbaritemslot - 1
						})
					end
					local nextitem2, nextitem2num = findininventory(v)
					bedwars.ClientStoreHandler:dispatch({
						type = "InventoryAddToHotbar", 
						item = nextitem2, 
						slot = tonumber(hotbarslot) - 1
					})
				end
			end
		end)
	end

	AutoHotbar = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "AutoHotbar",
		Function = function(callback) 
			if callback then
				AutoHotbarSort()
				if AutoHotbarMode.Value == "On Key" then
					if AutoHotbar.Enabled then 
						AutoHotbar.ToggleButton(false)
					end
				else
					AutoHotbarConnection = repstorage.Inventories.DescendantAdded:Connect(function(p3)
						if p3.Parent.Name == lplr.Name then
							task.wait(0.1)
							local items = (AutoHotbarList["Hotbars"][AutoHotbarList["CurrentlySelected"]] and AutoHotbarList["Hotbars"][AutoHotbarList["CurrentlySelected"]]["Items"] or {})
							local hotbarslot = findItemInTable(items, {itemType = p3.Name})
							if hotbarslot then
								AutoHotbarSort()
							end
						end
					end)
				end
			else
				if AutoHotbarConnection then
					AutoHotbarConnection:Disconnect()
				end
			end
		end,
		HoverText = "Automatically arranges hotbar to your liking."
	})
	AutoHotbarMode = AutoHotbar.CreateDropdown({
		Name = "Activation",
		List = {"On Key", "Toggle"},
		Function = function(val)
			if AutoHotbar.Enabled then
				AutoHotbar.ToggleButton(false)
				AutoHotbar.ToggleButton(false)
			end
		end
	})
	AutoHotbarList = CreateAutoHotbarGUI(AutoHotbar["Children"], {
		Name = "lol"
	})
end)

runcode(function()
	local AimAssist = {Enabled = false}
	local AimAssistClickAim = {Enabled = false}
	local AimAssistStrafe = {Enabled = false}
	local AimSpeed = {Value = 1}
	local AimAssistTargetFrame = {["Players"] = {Enabled = false}}
	AimAssist = GuiLibrary.ObjectsThatCanBeSaved.CombatWindow.Api.CreateOptionsButton({
		Name = "AimAssist",
		Function = function(callback)
			if callback then
				RunLoops:BindToRenderStep("AimAssist", 1, function()
					targetinfo.Targets.AimAssist = nil
					if ((not AimAssistClickAim.Enabled) or (tick() - bedwars.SwordController.lastSwing) < 0.4) then
						local plr = GetNearestHumanoidToPosition(AimAssistTargetFrame["Players"].Enabled, 18)
						if plr then
							targetinfo.Targets.AimAssist = plr
							if getEquipped()["Type"] == "sword" and ((not GuiLibrary.ObjectsThatCanBeSaved["Lobby CheckToggle"]["Api"].Enabled) or matchState ~= 0) and ((not AimAssistTargetFrame["Walls"].Enabled) or bedwars.SwordController:canSee({["instance"] = plr.Character, ["player"] = plr.Player, ["getInstance"] = function() return plr.Character end})) then
								cam.CFrame = cam.CFrame:lerp(CFrame.new(cam.CFrame.p, plr.Character.HumanoidRootPart.Position), (1 / AimSpeed.Value) - (AimAssistStrafe.Enabled and (uis:IsKeyDown(Enum.KeyCode.A) or uis:IsKeyDown(Enum.KeyCode.D)) and 0.01 or 0))
							end
						end
					end
				end)
			else
				RunLoops:UnbindFromRenderStep("AimAssist")
				targetinfo.Targets.AimAssist = nil
			end
		end,
		HoverText = "Smoothly aims to closest valid target with sword"
	})
	AimAssistTargetFrame = AimAssist.CreateTargetWindow({["Default3"] = true})
	AimAssistClickAim = AimAssist.CreateToggle({
		Name = "Click Aim",
		Function = function() end,
		Default = true,
		HoverText = "Only aim while mouse is down"
	})
	AimAssistStrafe = AimAssist.CreateToggle({
		Name = "Strafe increase",
		Function = function() end,
		HoverText = "Increase speed while strafing away from target"
	})
	AimSpeed = AimAssist.CreateSlider({
		Name = "Smoothness",
		Min = 1,
		Max = 100, 
		Function = function(val) end,
		Default = 50
	})
end)

runcode(function()
	local oldenable
	local olddisable
	local blockplacetable = {}
	local blockplaceenabled = false
	local autoclickercps = {["GetRandomValue"] = function() return 1 end}
	local autoclicker = {Enabled = false}
	local autoclickertick = tick()
	local autoclickerblocks = {Enabled = false}
	local autoclickermousedown = false
	local autoclickerconnection1
	local autoclickerconnection2
	local firstclick = tick()
	autoclicker = GuiLibrary.ObjectsThatCanBeSaved.CombatWindow.Api.CreateOptionsButton({
		Name = "AutoClicker",
		Function = function(callback)
			if callback then
				autoclickerconnection1 = uis.InputBegan:Connect(function(input, gameProcessed)
					if gameProcessed and input.UserInputType == Enum.UserInputType.MouseButton1 then
						autoclickermousedown = true
						firstclick = tick() + 0.1
					end
				end)
				autoclickerconnection2 = uis.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						autoclickermousedown = false
					end
				end)

				local function isNotHoveringOverGui()
					local mousepos = uis:GetMouseLocation() - Vector2.new(0, 36)
					for i,v in pairs(lplr.PlayerGui:GetGuiObjectsAtPosition(mousepos.X, mousepos.Y)) do 
						if v.Active then
							return false
						end
					end
					for i,v in pairs(game:GetService("CoreGui"):GetGuiObjectsAtPosition(mousepos.X, mousepos.Y)) do 
						if v.Parent:IsA("ScreenGui") and v.Parent.Enabled then
							if v.Active then
								return false
							end
						end
					end
					return true
				end

				task.spawn(function()
					repeat
						if entityLibrary.isAlive and autoclickermousedown and isNotHoveringOverGui() and #bedwars["AppController"]:getOpenApps() <= (kit == "hannah" and 4 or 3) and GuiLibrary["MainGui"].Parent ~= nil and GuiLibrary["MainGui"].ScaledGui.ClickGui.Visible == false and (GuiLibrary.ObjectsThatCanBeSaved["Lobby CheckToggle"]["Api"].Enabled == false or matchState ~= 0) then
							local equipped = getEquipped()
							if equipped["Type"] == "sword" and bedwars["KatanaController"].chargingMaid == nil then
								task.spawn(function()
									bedwars.SwordController:swingSwordAtMouse()
								end)
								task.wait(math.max((1 / autoclickercps["GetRandomValue"]()), GuiLibrary.ObjectsThatCanBeSaved["NoClickDelayOptionsButton"]["Api"].Enabled and 0 or 0.18))
							end
							if equipped["Type"] == "block" and autoclickerblocks.Enabled and bedwars["BlockPlacementController"].blockPlacer and firstclick <= tick() then 
								local mouseinfo = bedwars["BlockPlacementController"].blockPlacer.clientManager:getBlockSelector():getMouseInfo(0)
								if mouseinfo then
									task.spawn(function()
										if bedwars["BlockPlacementController"].blockPlacer then
											bedwars["BlockPlacementController"].blockPlacer:placeBlock(mouseinfo.placementPosition)
										end
									end)
								end
								task.wait(math.max((1 / autoclickercps["GetRandomValue"]()), 0.084))
							end
						end
						task.wait()
					until (not autoclicker.Enabled)
				end)
			else
				if autoclickerconnection1 then
					autoclickerconnection1:Disconnect()
				end
				if autoclickerconnection2 then
					autoclickerconnection2:Disconnect()
				end
			end
		end,
		HoverText = "Hold attack button to automatically click"
	})
	autoclickercps = autoclicker.CreateTwoSlider({
		Name = "CPS",
		Min = 1,
		Max = 20,
		Function = function(val) end,
		Default = 8,
		Default2 = 12
	})
	autoclickerblocks = autoclicker.CreateToggle({
		Name = "Place Blocks", 
		Function = function() end, 
		Default = true,
		HoverText = "Automatically places blocks when left click is held."
	})

	local noclickfunc
	GuiLibrary.ObjectsThatCanBeSaved.CombatWindow.Api.CreateOptionsButton({
		Name = "NoClickDelay",
		Function = function(callback)
			if callback then
				noclickfunc = bedwars.SwordController.isClickingTooFast
				bedwars.SwordController.isClickingTooFast = function(self) 
					self.lastSwing = tick()
					return false 
				end
				--debug.setconstant(bedwars.SwordController.attackEntity, 23, 0.64)
			else
				bedwars.SwordController.isClickingTooFast = noclickfunc
				--debug.setconstant(bedwars.SwordController.attackEntity, 23, 0.8)
			end
		end,
		HoverText = "Remove the CPS cap"
	})
end)

runcode(function()
	local oldclick
	local reachtping = false
	local reachval = {Value = 14}
	Reach = GuiLibrary.ObjectsThatCanBeSaved.CombatWindow.Api.CreateOptionsButton({
		Name = "Reach",
		Function = function(callback)
			if callback then
				bedwars.CombatConstant.RAYCAST_SWORD_CHARACTER_DISTANCE = reachval.Value
			else
				bedwars.CombatConstant.RAYCAST_SWORD_CHARACTER_DISTANCE = 14.4
			end
		end, 
		HoverText = "Extends attack reach"
	})
	reachval = Reach.CreateSlider({
		Name = "Reach",
		Min = 0,
		Max = 18,
		Function = function(val)
			if Reach.Enabled then
				bedwars.CombatConstant.RAYCAST_SWORD_CHARACTER_DISTANCE = val
			end
		end,
		Default = 18
	})
end)

local oldpos = Vector3.zero
local oldpos2 = Vector3.zero
local Spider = {Enabled = false}

local function getScaffold(vec, diagonaltoggle)
	local realvec = Vector3.new(math.floor((vec.X / 3) + 0.5) * 3, math.floor((vec.Y / 3) + 0.5) * 3, math.floor((vec.Z / 3) + 0.5) * 3) 
	local newpos = (oldpos - realvec)
	local returedpos = realvec
	if entityLibrary.isAlive then
		local angle = math.deg(math.atan2(-entityLibrary.character.Humanoid.MoveDirection.X, -entityLibrary.character.Humanoid.MoveDirection.Z))
		local goingdiagonal = (angle >= 130 and angle <= 150) or (angle <= -35 and angle >= -50) or (angle >= 35 and angle <= 50) or (angle <= -130 and angle >= -150)
		if goingdiagonal and ((newpos.X == 0 and newpos.Z ~= 0) or (newpos.X ~= 0 and newpos.Z == 0)) and diagonaltoggle then
			return oldpos
		end
	end
    return realvec
end

local slowdownspeed = false
local slowdownspeedval = 0.6
local speed = {Enabled = false}
local longjump = {Enabled = false}
local longjumpvelo = Vector3.zero
local spidergoinup = false
local holdingshift = false
local targetstrafevelo = Vector3.new(1, 1, 1)
local targetstrafing = false
local longjumpticktimer = tick()
runcode(function()
	local nocheck = false
	local oldnocheck = false
	local phasedelay = tick()
	local phasedelay2 = tick()
	local phase = {Enabled = false}
	local phasedist = {Value = 1}
	local checktable = {}
	local raycastparameters = RaycastParams.new()
	raycastparameters.FilterType = Enum.RaycastFilterType.Whitelist

	for i,v in pairs(workspace:GetChildren()) do
		if v:IsA("Folder") and v.Name:find("Map") == nil then
			table.insert(checktable, v)
		end
	end

	local function isPointInMapOccupied(p)
		local region = Region3.new(p - Vector3.new(1, 1, 1), p + Vector3.new(1, 1, 1))
		local possible = workspace:FindPartsInRegion3WithIgnoreList(region, {lplr.Character, unpack(checktable)})
		return (#possible == 0)
	end

	phase = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "Phase",
		Function = function(callback)
			if callback then
				RunLoops:BindToHeartbeat("Phase", 1, function()
					if entityLibrary.isAlive and entityLibrary.character.Humanoid.MoveDirection ~= Vector3.zero then
						if phasedelay <= tick() then
							nocheck = false
						end
						if phasedelay2 <= tick() then
							slowdownspeed = false
						end
						if phasedelay <= tick() and phasedelay2 <= tick() and (GuiLibrary.ObjectsThatCanBeSaved["SpiderOptionsButton"]["Api"].Enabled == false or holdingshift) then
							raycastparameters.FilterDescendantsInstances = {bedwarsblocks, collectionservice:GetTagged("spawn-cage"), workspace.SpectatorPlatform}
							local newray = workspace:Raycast(entityLibrary.character.Head.CFrame.p, entityLibrary.character.Humanoid.MoveDirection, raycastparameters)
							if newray then
								local pos = entityLibrary.character.HumanoidRootPart.CFrame.p - Vector3.new(0, 1, 0)
								local pos2 = entityLibrary.character.HumanoidRootPart.CFrame.p + Vector3.new(0, 1, 0)
								if isPointInMapOccupied(getScaffold(pos, false) + (newray.Normal * -(3 + (3 * phasedist.Value)))) and isPointInMapOccupied(getScaffold(pos2, false) + (newray.Normal * -(3 + (3 * phasedist.Value)))) then
									phasedelay = tick() + 0.075
									phasedelay2 = tick() + 5
									slowdownspeed = true
									nocheck = true
									entityLibrary.character.HumanoidRootPart.CFrame = entityLibrary.character.HumanoidRootPart.CFrame + (newray.Normal * -3)
								end
							end
						end
					end
				end)
				RunLoops:BindToStepped("Phase", 1, function()
					if entityLibrary.isAlive and (nocheck ~= oldnocheck or nocheck) then
						oldnocheck = nocheck
						for i,v in pairs(lplr.Character:GetDescendants()) do
							if v:IsA("BasePart") then
								if nocheck and v.Name ~= "HumanoidRootPart" then
									v.CanCollide = false
								end
							end
						end
					end
				end)
			else
				RunLoops:UnbindFromHeartbeat("Phase")
				RunLoops:UnbindFromStepped("Phase")
                slowdownspeed = false
			end
		end,
		HoverText = "Lets you Phase/Clip through walls. (Hold shift to use phase over spider)"
	})
	phasedist = phase.CreateSlider({
		Name = "Blocks",
		Min = 1,
		Max = 3,
		Function = function() end
	})

	local targetstrafe = {Enabled = false}
	local targetstrafespeed = {Value = 40}
	local targetstrafejump = {Value = 40}
	local targetstrafedistance = {Value = 12}
	local targetstrafenum = 0
	local targetstrafepos = Vector3.zero
	local flip = false
	local lastreal
	local old = nil
	local oldmove2
	local part
	local raycastparameters = RaycastParams.new()
	raycastparameters.FilterType = Enum.RaycastFilterType.Whitelist
	targetstrafe = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "TargetStrafe",
		Function = function(callback)
			if callback then
				local controlmodule = require(lplr.PlayerScripts.PlayerModule).controls
				oldmove2 = controlmodule.moveFunction
				controlmodule.moveFunction = function(self, movedir, facecam, ...)
					if targetstrafing and targetstrafepos and entityLibrary.isAlive then 
						movedir = (targetstrafepos - entityLibrary.character.HumanoidRootPart.Position).Unit
						facecam = false
					end
					return oldmove2(self, movedir, facecam, ...)
				end
				task.spawn(function()
					repeat
						task.wait(0.1)
						if (not targetstrafe.Enabled) then break end
						local plr = GetNearestHumanoidToPosition(true, 18)
						targetstrafing = false
						if entityLibrary.isAlive and plr and (not GuiLibrary.ObjectsThatCanBeSaved["ScaffoldOptionsButton"]["Api"].Enabled) and (not GuiLibrary.ObjectsThatCanBeSaved["LongJumpOptionsButton"]["Api"].Enabled) and (not GuiLibrary.ObjectsThatCanBeSaved["FlyOptionsButton"]["Api"].Enabled) and longjumpticktimer <= tick() and (not spidergoinup) then
							local veryoldpos = entityLibrary.character.HumanoidRootPart.CFrame.p
							if plr ~= old then
								old = plr
								local otherone2 = CFrame.lookAt(plr.Character.HumanoidRootPart.Position, entityLibrary.character.HumanoidRootPart.Position)
								local num = -math.atan2(otherone2.LookVector.Z, otherone2.LookVector.X) + math.rad(-90)
								targetstrafenum = math.deg(num)
							end
							raycastparameters.FilterDescendantsInstances = {bedwarsblocks, collectionservice:GetTagged("spawn-cage"), workspace.SpectatorPlatform}
							targetstrafing = false
							lastreal = plr.Character.HumanoidRootPart.Position
							local playerpos = Vector3.new(plr.Character.HumanoidRootPart.Position.X, entityLibrary.character.HumanoidRootPart.Position.Y, plr.Character.HumanoidRootPart.Position.Z)
							local newpos = playerpos + CFrame.Angles(0, math.rad(targetstrafenum), 0).LookVector * targetstrafedistance.Value
							local working = true
							local newray3 = workspace:Raycast(playerpos, CFrame.Angles(0, math.rad(targetstrafenum), 0).LookVector * targetstrafedistance.Value, raycastparameters)
							newpos = newray3 and (playerpos - newray3.Position) * 0.8 or newpos
							local newray2 = workspace:Raycast(newpos, Vector3.new(0, -15, 0), raycastparameters)
							if newray2 == nil then 
								newray2 = workspace:Raycast(playerpos + (playerpos - newpos) * 0.4, Vector3.new(0, -15, 0), raycastparameters)
								if newray2 then 
									newpos = playerpos + ((playerpos - newpos) * 0.4)
								end
							end
							if newray2 ~= nil then
								local newray4 = workspace:Raycast(entityLibrary.character.HumanoidRootPart.Position, (entityLibrary.character.HumanoidRootPart.Position - newpos), raycastparameters)
								if newray4 then 
									flip = not flip
								else
									targetstrafepos = newpos
									targetstrafing = true
								end
							else
								flip = not flip
							end
							if working then
								targetstrafenum = (flip and targetstrafenum - targetstrafespeed.Value or targetstrafenum + targetstrafespeed.Value)
								if targetstrafenum >= 999999 then
									targetstrafenum = 0
								end
								if targetstrafenum < -999999 then
									targetstrafenum = 0
								end
							end
						else
							targetstrafing = false
							old = nil
							lastreal = nil
						end
					until (not targetstrafe.Enabled)
				end)
			else
				targetstrafing = false
				local controlmodule = require(lplr.PlayerScripts.PlayerModule).controls
				controlmodule.moveFunction = oldmove2
			end
		end,
		HoverText = "Automatically moves around attacking players"
	})
	targetstrafespeed = targetstrafe.CreateSlider({
		Name = "Speed",
		Min = 1,
		Max = 80,
		Default = 80,
		Function = function() end
	})
	targetstrafejump = targetstrafe.CreateSlider({
		Name = "Jump Height",
		Min = 1,
		Max = 20,
		Default = 20,
		Function = function() end
	})
	targetstrafedistance = targetstrafe.CreateSlider({
		Name = "Distance",
		Min = 1,
		Max = 12,
		Default = 8,
		Function = function() end
	})
end)

runcode(function()
	local velohorizontal = {Value = 100}
	local velovertical = {Value = 100}
	local Velocity = {Enabled = false}
	local oldvelo
	Velocity = GuiLibrary.ObjectsThatCanBeSaved.CombatWindow.Api.CreateOptionsButton({
		Name = "Velocity",
		Function = function(callback)
			if callback then
				oldvelo = bedwars.KnockbackUtil.applyKnockback
				bedwars.KnockbackUtil.applyKnockback = function(root, mass, dir, knockback, ...)
					knockback = knockback or {}
					if velohorizontal.Value == 0 and velovertical.Value == 0 then return end
					knockback.horizontal = (knockback.horizontal or 1) * (velohorizontal.Value / 100)
					knockback.vertical = (knockback.vertical or 1) * (velovertical.Value / 100)
					return oldvelo(root, mass, dir, knockback, ...)
				end
			else
				bedwars.KnockbackUtil.applyKnockback = oldvelo
			end
		end,
		HoverText = "Reduces knockback taken"
	})
	velohorizontal = Velocity.CreateSlider({
		Name = "Horizontal",
		Min = 0,
		Max = 100,
		Percent = true,
		Function = function(val) end,
		Default = 0
	})
	velovertical = Velocity.CreateSlider({
		Name = "Vertical",
		Min = 0,
		Max = 100,
		Percent = true,
		Function = function(val) end,
		Default = 0
	})
end)

runcode(function()
	local Sprint = {Enabled = false}
	local sprintconnection
	local oldsprint
	Sprint = GuiLibrary.ObjectsThatCanBeSaved.CombatWindow.Api.CreateOptionsButton({
		Name = "Sprint",
		Function = function(callback)
			if callback then
				bedwars.SprintController:startSprinting()
				oldsprint = bedwars.SprintController.stopSprinting
				bedwars.SprintController.stopSprinting = function(...)
					local res = oldsprint(...)
					bedwars.SprintController:startSprinting()
					return res
				end
				sprintconnection = lplr.CharacterAdded:Connect(function(char)
					char:WaitForChild("Humanoid", 9e9)
					task.wait(0.5)
					bedwars.SprintController:stopSprinting()
				end)
			else
				bedwars.SprintController.stopSprinting = oldsprint
				bedwars.SprintController:stopSprinting()
				if sprintconnection then sprintconnection:Disconnect() end
			end
		end,
		HoverText = "Sets your sprinting to true."
	})
	
	local FieldOfViewValue = {Value = 70}
	local oldfov
	local oldfov2
	local FieldOfView = {Enabled = false}
	local FieldOfViewZoom = {Enabled = false}
	FieldOfView = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "FOVChanger",
		Function = function(callback)
			if callback then
				if FieldOfViewZoom.Enabled then
					task.spawn(function()
						repeat
							task.wait()
						until uis:IsKeyDown(Enum.KeyCode[FieldOfView["Keybind"] ~= "" and FieldOfView["Keybind"] or "C"]) == false
						if FieldOfView.Enabled then
							FieldOfView.ToggleButton(false)
						end
					end)
				end
				oldfov = bedwars.FovController.setFOV
				oldfov2 = bedwars.FovController.getFOV
				bedwars.FovController.setFOV = function(self, fov)
					return oldfov(self, FieldOfViewValue.Value)
				end
				bedwars.FovController.getFOV = function(self, fov)
					return oldfov2(self, FieldOfViewValue.Value)
				end
			else
				bedwars.FovController.setFOV = oldfov
				bedwars.FovController.getFOV = oldfov2
			end
			bedwars.FovController:setFOV(bedwars.ClientStoreHandler:getState().Settings.fov)
		end
	})
	FieldOfViewValue = FieldOfView.CreateSlider({
		Name = "FOV",
		Min = 30,
		Max = 120,
		Function = function(val)
			if FieldOfView.Enabled then
				cam.FieldOfView = val * (bedwars.SprintController.sprinting and 1.1 or 1)
			end
		end
	})
	FieldOfViewZoom = FieldOfView.CreateToggle({
		Name = "Zoom",
		Function = function() end,
		HoverText = "optifine zoom lol"
	})
end)

local lagbackedaftertouch = false
local antivoidvelo 
runcode(function()
	local antivoidpart
	local antivoidconnection
	local antitransparent = {Value = 50}
	local anticolor = {["Hue"] = 1, ["Sat"] = 1, Value = 0.55}
	local AntiVoidMode = {Value = "Normal"}
	local AntiVoid = {Enabled = false}
	local lastvalidpos

	local function closestpos(block)
		local startpos = block.Position - (block.Size / 2) + Vector3.new(1.5, 1.5, 1.5)
		local endpos = block.Position + (block.Size / 2) - Vector3.new(1.5, 1.5, 1.5)
		local newpos = block.Position + (entityLibrary.character.HumanoidRootPart.Position - block.Position)
		return Vector3.new(math.clamp(newpos.X, startpos.X, endpos.X), endpos.Y + 3, math.clamp(newpos.Z, startpos.Z, endpos.Z))
	end

	local function getclosesttop(newmag)
		local closest, closestmag = nil, newmag * 3
		if entityLibrary.isAlive then 
			local tops = {}
			for i,v in pairs(bedwarsblocks) do 
				local close = getScaffold(closestpos(v), false)
				if getblock(close) then continue end
				if close.Y < entityLibrary.character.HumanoidRootPart.Position.Y then continue end
				if (close - entityLibrary.character.HumanoidRootPart.Position).magnitude <= newmag * 3 then 
					table.insert(tops, close)
				end
			end
			for i,v in pairs(tops) do 
				local mag = (v - entityLibrary.character.HumanoidRootPart.Position).magnitude
				if mag <= closestmag then 
					closest = v
					closestmag = mag
				end
			end
		end
		return closest
	end

	local function isPointInMapOccupied(p)
		local region = Region3.new(p - Vector3.new(1, 1, 1), p + Vector3.new(1, 1, 1))
		local possible = workspace:FindPartsInRegion3WithWhiteList(region, bedwarsblocks)
		return (#possible == 0)
	end

	AntiVoid = GuiLibrary.ObjectsThatCanBeSaved.WorldWindow.Api.CreateOptionsButton({
		Name = "AntiVoid", 
		Function = function(callback)
			if callback then
				task.spawn(function()
					antivoidpart = Instance.new("Part")
					antivoidpart.CanCollide = false
					antivoidpart.Size = Vector3.new(10000, 1, 10000)
					antivoidpart.Anchored = true
					antivoidpart.Material = Enum.Material.Neon
					antivoidpart.Color = Color3.fromHSV(anticolor["Hue"], anticolor["Sat"], anticolor.Value)
					antivoidpart.Transparency = 1 - (antitransparent.Value / 100)
					antivoidpart.Position = Vector3.new(0, antivoidypos, 0)
					antivoidpart.Parent = workspace
					if AntiVoidMode.Value == "Classic" and antivoidypos == 0 then 
						antivoidpart.Parent = nil
					end
					antivoidconnection = antivoidpart.Touched:Connect(function(touchedpart)
						if touchedpart.Parent == lplr.Character and entityLibrary.isAlive then
							if (not antivoiding) and (not GuiLibrary.ObjectsThatCanBeSaved["FlyOptionsButton"]["Api"].Enabled) and entityLibrary.character.Humanoid.Health > 0 then
								antivoiding = true
								local pos = getclosesttop(1000)
								if pos then
									local lastTeleport = lplr:GetAttribute("LastTeleported")
									RunLoops:BindToHeartbeat("AntiVoid", 1, function(dt)
										if entityLibrary.isAlive and entityLibrary.character.Humanoid.Health > 0 and isnetworkowner(entityLibrary.character.HumanoidRootPart) and (entityLibrary.character.HumanoidRootPart.Position - pos).Magnitude > 1 and AntiVoid.Enabled and lplr:GetAttribute("LastTeleported") == lastTeleport then 
											local hori1 = Vector3.new(entityLibrary.character.HumanoidRootPart.Position.X, 0, entityLibrary.character.HumanoidRootPart.Position.Z)
											local hori2 = Vector3.new(pos.X, 0, pos.Z)
											local newpos = (hori2 - hori1).Unit
											local realnewpos = CFrame.new(newpos == newpos and entityLibrary.character.HumanoidRootPart.CFrame.p + (newpos * (3 * dt)) or Vector3.zero)
											entityLibrary.character.HumanoidRootPart.CFrame = CFrame.new(realnewpos.p.X, pos.Y, realnewpos.p.Z)
											antivoidvelo = newpos == newpos and newpos * 20 or Vector3.zero
											entityLibrary.character.HumanoidRootPart.Velocity = Vector3.new(antivoidvelo.X, entityLibrary.character.HumanoidRootPart.Velocity.Y, antivoidvelo.Z)
											if getblock((entityLibrary.character.HumanoidRootPart.CFrame.p - Vector3.new(0, 1, 0)) + entityLibrary.character.HumanoidRootPart.Velocity.Unit) or getblock(entityLibrary.character.HumanoidRootPart.CFrame.p + Vector3.new(0, 3)) then
												pos = pos + Vector3.new(0, 1, 0)
											end
										else
											RunLoops:UnbindFromHeartbeat("AntiVoid")
											antivoidvelo = nil
                                            antivoiding = false
										end
									end)
								else
                                    entityLibrary.character.HumanoidRootPart.CFrame += Vector3.new(0, 100000, 0)
                                    antivoiding = false
								end
							end
						end
					end)
					repeat
						if entityLibrary.isAlive and AntiVoidMode.Value == "Normal" then 
							local ray = workspace:Raycast(entityLibrary.character.HumanoidRootPart.Position, Vector3.new(0, -1000, 0), blockraycast)
							if ray or GuiLibrary.ObjectsThatCanBeSaved["FlyOptionsButton"]["Api"].Enabled or GuiLibrary.ObjectsThatCanBeSaved["InfiniteFlyOptionsButton"]["Api"].Enabled then 
								antivoidpart.Position = entityLibrary.character.HumanoidRootPart.Position - Vector3.new(0, 21, 0)
							end
						end
						task.wait()
					until (not AntiVoid.Enabled)
				end)
			else
				if antivoidconnection then antivoidconnection:Disconnect() end
				if antivoidpart then
					antivoidpart:Remove() 
				end
			end
		end, 
		HoverText = "Gives you a chance to get on land (Bouncing Twice, abusing, or bad luck will lead to lagbacks)"
	})
	AntiVoidMode = AntiVoid.CreateDropdown({
		Name = "Mode",
		Function = function(val) 
			if val == "Classic" then 
				task.spawn(function()
					repeat task.wait() until matchState ~= 0 or uninjectflag
					if (not uninjectflag) and AntiVoidMode.Value == "Classic" and antivoidypos == 0 then
						local lowestypos = 99999
						for i,v in pairs(bedwarsblocks) do 
							local newray = workspace:Raycast(v.Position + Vector3.new(0, 800, 0), Vector3.new(0, -1000, 0), blockraycast)
							if i % 200 == 0 then 
								task.wait(0.06)
							end
							if newray and newray.Position.Y <= lowestypos then
								lowestypos = newray.Position.Y
							end
						end
						antivoidypos = lowestypos - 8
					end
					if antivoidpart then 
						antivoidpart.Position = Vector3.new(0, antivoidypos, 0)
						antivoidpart.Parent = workspace
					end
				end)
			end
		end,
		List = {"Normal", "Classic"}
	})
	antitransparent = AntiVoid.CreateSlider({
		Name = "Invisible",
		Min = 1,
		Max = 100,
		Default = 50,
		Function = function(val) 
			if antivoidpart then
				antivoidpart.Transparency = 1 - (val / 100)
			end
		end,
	})
	anticolor = AntiVoid.CreateColorSlider({
		Name = "Color",
		Function = function() 
			if antivoidpart then
				antivoidpart.Color = Color3.fromHSV(anticolor["Hue"], anticolor["Sat"], anticolor.Value)
			end
		end
	})
end)


runcode(function()
	local oldenable2
	local olddisable2
	local oldhitblock
	local blockplacetable2 = {}
	local blockplaceenabled2 = false

	local AutoTool = GuiLibrary.ObjectsThatCanBeSaved.WorldWindow.Api.CreateOptionsButton({
		Name = "AutoTool",
		Function = function(callback)
			if callback then
				oldenable2 = bedwars["BlockBreaker"]["enable"]
				olddisable2 = bedwars["BlockBreaker"]["disable"]
				oldhitblock = bedwars["BlockBreaker"]["hitBlock"]
				bedwars["BlockBreaker"]["enable"] = function(Self, tab)
					blockplaceenabled2 = true
					blockplacetable2 = Self
					return oldenable2(Self, tab)
				end
				bedwars["BlockBreaker"]["disable"] = function(Self)
					blockplaceenabled2 = false
					return olddisable2(Self)
				end
				bedwars["BlockBreaker"]["hitBlock"] = function(...)
					if entityLibrary.isAlive and (GuiLibrary.ObjectsThatCanBeSaved["Lobby CheckToggle"]["Api"].Enabled == false or matchState ~= 0) and blockplaceenabled2 then
						local mouseinfo = blockplacetable2.clientManager:getBlockSelector():getMouseInfo(0)
						if mouseinfo and mouseinfo.target then
							if switchToAndUseTool(mouseinfo.target.blockInstance, true) then
								return
							end
						end
					end
					return oldhitblock(...)
				end
			else
				RunLoops:UnbindFromRenderStep("AutoTool")
				bedwars["BlockBreaker"]["enable"] = oldenable2
				bedwars["BlockBreaker"]["disable"] = olddisable2
				bedwars["BlockBreaker"]["hitBlock"] = oldhitblock
				oldenable2 = nil
				olddisable2 = nil
				oldhitblock = nil
			end
		end,
		HoverText = "Automatically swaps your hand to the appropriate tool."
	})
end)

local function getbestside(pos)
	local softest, softestside = 9e9, Enum.NormalId.Top
	for i,v in pairs(normalsides) do
		local sidehardness = 0
		for i2,v2 in pairs(getallblocks(pos, v)) do	
			local blockmeta = bedwars.ItemTable[v2]["block"]
			sidehardness = sidehardness + (blockmeta and blockmeta.health or 10)
            if blockmeta then
                local tool = getBestTool(v2)
                if tool then
                    sidehardness = sidehardness - bedwars.ItemTable[tool.itemType]["breakBlock"][blockmeta.breakType]
                end
            end
		end
		if sidehardness <= softest then
			softest = sidehardness
			softestside = v
		end
	end
	return softestside, softest
end

runcode(function()
	local BedProtector = {Enabled = false}
	local bedprotector1stlayer = {
		Vector3.new(0, 3, 0),
		Vector3.new(0, 3, 3),
		Vector3.new(3, 0, 0),
		Vector3.new(3, 0, 3),
		Vector3.new(-3, 0, 0),
		Vector3.new(-3, 0, 3),
		Vector3.new(0, 0, 6),
		Vector3.new(0, 0, -3)
	}
	local bedprotector2ndlayer = {
		Vector3.new(0, 6, 0),
		Vector3.new(0, 6, 3),
		Vector3.new(0, 3, 6),
		Vector3.new(0, 3, -3),
		Vector3.new(0, 0, -6),
		Vector3.new(0, 0, 9),
		Vector3.new(3, 3, 0),
		Vector3.new(3, 3, 3),
		Vector3.new(3, 0, 6),
		Vector3.new(3, 0, -3),
		Vector3.new(6, 0, 3),
		Vector3.new(6, 0, 0),
		Vector3.new(-3, 3, 3),
		Vector3.new(-3, 3, 0),
		Vector3.new(-6, 0, 3),
		Vector3.new(-6, 0, 0),
		Vector3.new(-3, 0, 6),
		Vector3.new(-3, 0, -3),
	}

	local function getItemFromList(list)
		local selecteditem
		for i3,v3 in pairs(list) do
			local item = getItem(v3)
			if item then 
				selecteditem = item
				break
			end
		end
		return selecteditem
	end

	local function placelayer(layertab, obj, selecteditems)
		for i2,v2 in pairs(layertab) do
			local selecteditem = getItemFromList(selecteditems)
			if selecteditem then
				bedwars["placeBlock"](obj.Position + v2, selecteditem.itemType)
			else
				return false
			end
		end
		return true
	end

	local bedprotectorrange = {Value = 1}
	BedProtector = GuiLibrary.ObjectsThatCanBeSaved.WorldWindow.Api.CreateOptionsButton({
		Name = "BedProtector",
		Function = function(callback)
            if callback then
                task.spawn(function()
                    for i, obj in pairs(collectionservice:GetTagged("bed")) do
                        if entityLibrary.isAlive and obj:GetAttribute("Team"..lplr:GetAttribute("Team").."NoBreak") and obj.Parent ~= nil then
                            if (entityLibrary.character.HumanoidRootPart.Position - obj.Position).magnitude <= bedprotectorrange.Value then
                                local firstlayerplaced = placelayer(bedprotector1stlayer, obj, {"obsidian", "stone_brick", "plank_oak", getwool()})
							    if firstlayerplaced then
									placelayer(bedprotector2ndlayer, obj, {getwool()})
							    end
                            end
                            break
                        end
                    end
                    BedProtector.ToggleButton(false)
                end)
            end
		end,
		HoverText = "Automatically places a bed defense (Toggle)"
	})
	bedprotectorrange = BedProtector.CreateSlider({
		Name = "Place range",
		Min = 1, 
		Max = 20, 
		Function = function(val) end, 
		Default = 20
	})
end)

runcode(function()
	local Nuker = {Enabled = false}
	local nukerrange = {Value = 1}
	local nukereffects = {Enabled = false}
	local nukeranimation = {Enabled = false}
	local nukernofly = {Enabled = false}
	local nukerlegit = {Enabled = false}
	local nukerown = {Enabled = false}
    local nukerluckyblock = {Enabled = false}
    local nukerbeds = {Enabled = false}
	local nukercustom = {["RefreshValues"] = function() end, ["ObjectList"] = {}}
	local nukerconnection
	local nukerconnection2
    local luckyblocktable = {}
	Nuker = GuiLibrary.ObjectsThatCanBeSaved.WorldWindow.Api.CreateOptionsButton({
		Name = "Nuker",
		Function = function(callback)
            if callback then
				for i,v in pairs(bedwarsblocks) do
					if table.find(nukercustom["ObjectList"], v.Name) or (nukerluckyblock.Enabled and v.Name:find("lucky")) then
						table.insert(luckyblocktable, v)
					end
				end
				nukerconnection = collectionservice:GetInstanceAddedSignal("block"):Connect(function(v)
                    if table.find(nukercustom["ObjectList"], v.Name) or (nukerluckyblock.Enabled and v.Name:find("lucky")) then
                        table.insert(luckyblocktable, v)
                    end
                end)
                nukerconnection2 = collectionservice:GetInstanceRemovedSignal("block"):Connect(function(v)
                    if table.find(nukercustom["ObjectList"], v.Name) or (nukerluckyblock.Enabled and v.Name:find("lucky")) then
                        table.remove(luckyblocktable, table.find(luckyblocktable, v))
                    end
                end)
                task.spawn(function()
                    repeat
						if (nukernofly.Enabled == false or GuiLibrary.ObjectsThatCanBeSaved["FlyOptionsButton"]["Api"].Enabled == false) then
							if nukerbeds.Enabled then
								for i, obj in pairs(collectionservice:GetTagged("bed")) do
									if entityLibrary.isAlive then
										if obj and bedwars.BlockController:isBlockBreakable({blockPosition = obj.Position / 3}, lplr) and obj.Parent ~= nil then
											if ((oldcloneroot and oldcloneroot.Position or entityLibrary.LocalPosition or entityLibrary.character.HumanoidRootPart.Position) - obj.Position).magnitude <= nukerrange.Value then
												local tool = (not nukerlegit.Enabled) and {Name = "wood_axe"} or getEquipped().Object
												if tool and bedwars.ItemTable[tool.Name]["breakBlock"] then
													local res, amount = getbestside(obj.Position)
													local res2, amount2 = getbestside(obj.Position + Vector3.new(0, 0, 3))
													bedwars["breakBlock"]((amount < amount2 and obj.Position or obj.Position + Vector3.new(0, 0, 3)), nukereffects.Enabled, (amount < amount2 and res or res2), false, nukeranimation.Enabled)
													break
												end
											end
										end
									end
								end
							end
							for i, obj in pairs(luckyblocktable) do
								if entityLibrary.isAlive then
									if obj and bedwars.BlockController:isBlockBreakable({blockPosition = obj.Position / 3}, lplr) and obj.Parent ~= nil then
										if ((oldcloneroot and oldcloneroot.Position or entityLibrary.LocalPosition or entityLibrary.character.HumanoidRootPart.Position) - obj.Position).magnitude <= nukerrange.Value and (nukerown.Enabled or obj:GetAttribute("PlacedByUserId") ~= lplr.UserId) then
											local tool = (not nukerlegit.Enabled) and {Name = "wood_axe"} or getEquipped().Object
											if tool and bedwars.ItemTable[tool.Name]["breakBlock"] then
												bedwars["breakBlock"](obj.Position, nukereffects.Enabled, getbestside(obj.Position), true, nukeranimation.Enabled)
												break
											end
										end
									end
								end
							end
						end
						task.wait()
                    until (not Nuker.Enabled)
                end)
            else
				nukerconnection:Disconnect()
                nukerconnection2:Disconnect()
                luckyblocktable = {}
            end
		end,
		HoverText = "Automatically destroys beds & luckyblocks around you."
	})
	nukerrange = Nuker.CreateSlider({
		Name = "Break range",
		Min = 1, 
		Max = 30, 
		Function = function(val) end, 
		Default = 30
	})
	nukerlegit = Nuker.CreateToggle({
		Name = "Hand Check",
		Function = function() end
	})
	nukereffects = Nuker.CreateToggle({
		Name = "Show HealthBar & Effects",
		Function = function(callback) 
			if not callback then
				bedwars["BlockBreaker"].healthbarMaid:DoCleaning()
			end
		 end,
		Default = true
	})
	nukeranimation = Nuker.CreateToggle({
		Name = "Break Animation",
		Function = function() end
	})
	nukerown = Nuker.CreateToggle({
		Name = "Self Break",
		Function = function() end,
	})
    nukerbeds = Nuker.CreateToggle({
		Name = "Break Beds",
		Function = function(callback) end,
		Default = true
	})
	nukernofly = Nuker.CreateToggle({
		Name = "Fly Disable",
		Function = function() end
	})
    nukerluckyblock = Nuker.CreateToggle({
		Name = "Break LuckyBlocks",
		Function = function(callback) 
			luckyblocktable = {}
			for i,v in pairs(bedwarsblocks) do
				if table.find(nukercustom["ObjectList"], v.Name) or (nukerluckyblock.Enabled and v.Name:find("lucky")) then
					table.insert(luckyblocktable, v)
				end
			end
		 end,
		Default = true
	})
	nukercustom = Nuker.CreateTextList({
		Name = "NukerList",
		["TempText"] = "block (tesla_trap)",
		["AddFunction"] = function()
			luckyblocktable = {}
			for i,v in pairs(bedwarsblocks) do
				if table.find(nukercustom["ObjectList"], v.Name) or (nukerluckyblock.Enabled and v.Name:find("lucky")) then
					table.insert(luckyblocktable, v)
				end
			end
		end
	})
end)

runcode(function()
	local ChestStealer = {Enabled = false}
	local ChestStealerDistance = {Value = 1}
	local ChestStealerDelay = {Value = 1}
	local ChestStealerOpen = {Enabled = false}
	local ChestStealerSkywars = {Enabled = true}
	local cheststealerdelays = {}
	local cheststealerfuncs = {
		Open = function()
			if bedwars["AppController"]:isAppOpen("ChestApp") then
				local chest = lplr.Character:FindFirstChild("ObservedChestFolder")
				local chestitems = chest and chest.Value and chest.Value:GetChildren() or {}
				if #chestitems > 0 then
					for i3,v3 in pairs(chestitems) do
						if v3:IsA("Accessory") and (cheststealerdelays[v3] == nil or cheststealerdelays[v3] < tick()) then
							task.spawn(function()
								pcall(function()
									cheststealerdelays[v3] = tick() + 0.2
									bedwars.ClientHandler:GetNamespace("Inventory"):Get("ChestGetItem"):CallServer(chest.Value, v3)
								end)
							end)
							task.wait(ChestStealerDelay.Value / 100)
						end
					end
				end
			end
		end,
		Closed = function()
			for i,v in pairs(collectionservice:GetTagged("chest")) do
				if (entityLibrary.character.HumanoidRootPart.Position - v.Position).magnitude <= ChestStealerDistance.Value and v:FindFirstChild("ChestFolderValue") then
					local chest = v:FindFirstChild("ChestFolderValue")
					chest = chest and chest.Value or nil
					local chestitems = chest and chest:GetChildren() or {}
					if #chestitems > 0 then
						bedwars.ClientHandler:GetNamespace("Inventory"):Get("SetObservedChest"):SendToServer(chest)
						for i3,v3 in pairs(chestitems) do
							if v3:IsA("Accessory") then
								task.spawn(function()
									pcall(function()
										bedwars.ClientHandler:GetNamespace("Inventory"):Get("ChestGetItem"):CallServer(v.ChestFolderValue.Value, v3)
									end)
								end)
								task.wait(ChestStealerDelay.Value / 100)
							end
						end
						bedwars.ClientHandler:GetNamespace("Inventory"):Get("SetObservedChest"):SendToServer(nil)
					end
				end
			end
		end
	}

	ChestStealer = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "ChestStealer",
		Function = function(callback)
			if callback then
				task.spawn(function()
					repeat task.wait() until queueType ~= "bedwars_test"
					if (not ChestStealerSkywars.Enabled) or queueType:find("skywars") then
						repeat 
							task.wait(0.1)
							if entityLibrary.isAlive then
								cheststealerfuncs[ChestStealerOpen.Enabled and "Open" or "Closed"]()
							end
						until (not ChestStealer.Enabled)
					end
				end)
			end
		end,
		HoverText = "Grabs items from near chests."
	})
	ChestStealerDistance = ChestStealer.CreateSlider({
		Name = "Range",
		Min = 0,
		Max = 18,
		Function = function() end,
		Default = 18
	})
	ChestStealerDelay = ChestStealer.CreateSlider({
		Name = "Delay",
		Min = 1,
		Max = 50,
		Function = function() end,
		Default = 1
	})
	ChestStealerOpen = ChestStealer.CreateToggle({
		Name = "GUI Check",
		Function = function() end
	})
	ChestStealerSkywars = ChestStealer.CreateToggle({
		Name = "Only Skywars",
		Function = function() end,
		Default = true
	})

	local OpenEnderchest = {Enabled = false}
	OpenEnderchest = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "OpenEnderchest",
		Function = function(callback)
			if callback then
				local echest = repstorage.Inventories:FindFirstChild(lplr.Name.."_personal")
				if echest then
					bedwars["AppController"]:openApp("ChestApp", {})
					bedwars["ChestController"]:openChest(echest)
				else
					createwarning("OpenEnderchest", "Enderchest not found", 5)
				end
				OpenEnderchest.ToggleButton(false)
			end
		end,
		HoverText = "Opens the enderchest"
	})
end)

runcode(function()
	local ChestESPList = {["ObjectList"] = {}, ["RefreshList"] = function() end}
	local function nearchestitem(item)
		for i,v in pairs(ChestESPList["ObjectList"]) do 
			if item:find(v) then return v end
		end
	end
	local function refreshAdornee(v)
		local chest = v.Adornee.ChestFolderValue.Value
        local chestitems = chest and chest:GetChildren() or {}
		for i2,v2 in pairs(v.Frame:GetChildren()) do
			if v2:IsA("ImageLabel") then
				v2:Remove()
			end
		end
		v.Enabled = false
		local alreadygot = {}
		for i3,v3 in pairs(chestitems) do
			if table.find(ChestESPList["ObjectList"], v3.Name) or nearchestitem(v3.Name) and alreadygot[v3.Name] == nil then 
				alreadygot[v3.Name] = true
				v.Enabled = true
                local blockimage = Instance.new("ImageLabel")
                blockimage.Size = UDim2.new(0, 32, 0, 32)
                blockimage.BackgroundTransparency = 1
                blockimage.Image = bedwars.getIcon({itemType = v3.Name}, true)
                blockimage.Parent = v.Frame
            end
		end
	end

	local ChestESPFolder = Instance.new("Folder")
	ChestESPFolder.Name = "ChestESPFolder"
	ChestESPFolder.Parent = GuiLibrary["MainGui"]
	local ChestESP = {Enabled = false}
    local chestconnections = {}
	ChestESP = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "ChestESP",
		Function = function(callback)
			if callback then
				task.spawn(function()

					local function chestfunc(v)
						task.spawn(function()
							local billboard = Instance.new("BillboardGui")
							billboard.Parent = ChestESPFolder
							billboard.Name = "chest"
							billboard.StudsOffsetWorldSpace = Vector3.new(0, 3, 1.5)
							billboard.Size = UDim2.new(0, 42, 0, 42)
							billboard.AlwaysOnTop = true
							billboard.Adornee = v
							local frame = Instance.new("Frame")
							frame.Size = UDim2.new(1, 0, 1, 0)
							frame.BackgroundColor3 = Color3.new(0, 0, 0)
							frame.BackgroundTransparency = 0.5
							frame.Parent = billboard
							local uilistlayout = Instance.new("UIListLayout")
							uilistlayout.FillDirection = Enum.FillDirection.Horizontal
							uilistlayout.Padding = UDim.new(0, 4)
							uilistlayout.VerticalAlignment = Enum.VerticalAlignment.Center
							uilistlayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
							uilistlayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
								billboard.Size = UDim2.new(0, math.max(uilistlayout.AbsoluteContentSize.X + 12, 42), 0, 42)
							end)
							uilistlayout.Parent = frame
							local uicorner = Instance.new("UICorner")
							uicorner.CornerRadius = UDim.new(0, 4)
							uicorner.Parent = frame
							local chest = v:WaitForChild("ChestFolderValue").Value
							if chest then 
								chestconnections[#chestconnections + 1] = chest.ChildAdded:Connect(function(item)
									if table.find(ChestESPList["ObjectList"], item.Name) or nearchestitem(item.Name) then 
										refreshAdornee(billboard)
									end
								end)
								chestconnections[#chestconnections + 1] = chest.ChildRemoved:Connect(function(item)
									if table.find(ChestESPList["ObjectList"], item.Name) or nearchestitem(item.Name) then 
										refreshAdornee(billboard)
									end
								end)
								refreshAdornee(billboard)
							end
						end)
					end

					chestconnections[#chestconnections + 1] = collectionservice:GetInstanceAddedSignal("chest"):Connect(chestfunc)
					for i,v in pairs(collectionservice:GetTagged("chest")) do chestfunc(v) end
				end)
			else
				ChestESPFolder:ClearAllChildren()
                for i,v in pairs(chestconnections) do 
                    v:Disconnect()
                end
			end
		end
	})
	ChestESPList = ChestESP.CreateTextList({
		Name = "ItemList",
		["TempText"] = "item or part of item",
		["AddFunction"] = function()
			if ChestESP.Enabled then 
				ChestESP.ToggleButton(false)
				ChestESP.ToggleButton(false)
			end
		end,
		["RemoveFunction"] = function()
			if ChestESP.Enabled then 
				ChestESP.ToggleButton(false)
				ChestESP.ToggleButton(false)
			end
		end
	})
end)

local autobankapple = false
local autobankballoon = false
local autobankballoonevent = Instance.new("BindableEvent")
runcode(function()
	local AutoBuy = {Enabled = false}
	local AutoBuyArmor = {Enabled = false}
	local AutoBuySword = {Enabled = false}
	local AutoBuyUpgrades = {Enabled = false}
	local AutoBuyGen = {Enabled = false}
	local AutoBuyProt = {Enabled = false}
	local AutoBuySharp = {Enabled = false}
	local AutoBuyBreakSpeed = {Enabled = false}
	local AutoBuyAlarm = {Enabled = false}
    local AutoBuyArmory = {Enabled = false}
    local AutoBuyBrewingStand = {Enabled = false}
	local AutoBuyGui = {Enabled = false}
	local AutoBuyTierSkip = {Enabled = true}
	local AutoBuyRange = {Value = 20}
	local AutoBuyCustom = {ObjectList = {}, RefreshList = function() end}
	local AutoBankDeath = {Enabled = false}
	local AutoBankStay = {Enabled = false}
	local buyingthing = false
	local shoothook
	local bedwarsshopnpcs = {}
	local shopnpcconnection
	task.spawn(function()
		repeat task.wait() until matchState ~= 0
		for i,v in pairs(collectionservice:GetTagged("BedwarsItemShop")) do
			table.insert(bedwarsshopnpcs, {["Position"] = v.Position, ["TeamUpgradeNPC"] = true})
		end
		for i,v in pairs(collectionservice:GetTagged("BedwarsTeamUpgrader")) do
			table.insert(bedwarsshopnpcs, {["Position"] = v.Position, ["TeamUpgradeNPC"] = false})
		end
	end)

	local function nearNPC(range)
		local npc, npccheck, enchant = nil, false, false
		if entityLibrary.isAlive then
			local enchanttab = {}
			for i,v in pairs(collectionservice:GetTagged("broken-enchant-table")) do 
				table.insert(enchanttab, v)
			end
			for i,v in pairs(collectionservice:GetTagged("enchant-table")) do 
				table.insert(enchanttab, v)
			end
			for i,v in pairs(enchanttab) do 
				if (entityLibrary.character.HumanoidRootPart.Position - v.Position).magnitude <= 6 then
					if ((not v:GetAttribute("Team")) or v:GetAttribute("Team") == lplr:GetAttribute("Team")) then
						npc, npccheck, enchant = true, true, true
					end
				end
			end
			for i, v in pairs(bedwarsshopnpcs) do
				if (entityLibrary.character.HumanoidRootPart.Position - v.Position).magnitude <= (range or 20) then
					npc, npccheck, enchant = true, (v.TeamUpgradeNPC or npccheck), false
				end
			end
			local suc, res = pcall(function() return lplr.leaderstats.Bed.Value == "✅"  end)
			if AutoBankDeath.Enabled and (workspace:GetServerTimeNow() - lplr.Character:GetAttribute("LastDamageTakenTime")) < 2 and suc and res then 
				return nil, false, false
			end
			if AutoBankStay.Enabled then 
				return nil, false, false
			end
		end
		return npc, not npccheck, enchant
	end

	local function getShopItem(itemType)
		for i,v in pairs(bedwars["ShopItems"]) do 
			if v.itemType == itemType then return v end
		end
		return nil
	end

	local function buyItem(itemtab, waitdelay)
		local res
		bedwars.ClientHandler:Get("BedwarsPurchaseItem"):CallServerAsync({
			shopItem = itemtab
		}):andThen(function(p11)
			if p11 then
				bedwars.SoundManager:playSound(bedwars.SoundList.BEDWARS_PURCHASE_ITEM)
				bedwars.ClientStoreHandler:dispatch({
					type = "BedwarsAddItemPurchased", 
					itemType = itemtab.itemType
				})
			end
			res = p11
		end)
		if waitdelay then 
			repeat task.wait() until res ~= nil
		end
	end

	local function buyUpgrade(upgradetype, inv, upgrades)
		if not AutoBuyUpgrades.Enabled then return end
		local teamupgrade = bedwars.Shop.getUpgrade(bedwars.Shop.TeamUpgrades, upgradetype)
		local teamtier = teamupgrade["tiers"][upgrades[upgradetype] and upgrades[upgradetype] + 2 or 1]
		if teamtier then 
			local teamcurrency = getItem(teamtier["currency"], inv.items)
			if teamcurrency and teamcurrency["amount"] >= teamtier.price then 
				bedwars.ClientHandler:Get("BedwarsPurchaseTeamUpgrade"):CallServerAsync({
					upgradeId = upgradetype, 
					tier = upgrades[upgradetype] and upgrades[upgradetype] + 1 or 0
				}):andThen(function(suc)
					if suc then
						bedwars.SoundManager:playSound(bedwars.SoundList.BEDWARS_PURCHASE_ITEM)
					end
				end)
			end
		end
	end
	
	local armors = {
		[1] = "leather_chestplate",
		[2] = "iron_chestplate",
		[3] = "diamond_chestplate",
		[4] = "emerald_chestplate"
	}

	local swords = {
		[1] = "wood_sword",
		[2] = "stone_sword",
		[3] = "iron_sword",
		[4] = "diamond_sword",
		[5] = "emerald_sword"
	}

	local buyfunctions = {
		Armor = function(inv, upgrades, shoptype) 
			if AutoBuyArmor.Enabled == false or shoptype ~= "item" then return end
			local currentarmor = (inv.armor[2] ~= "empty" and inv.armor[2].itemType:find("chestplate") ~= nil) and inv.armor[2] or nil
			local armorindex = (currentarmor and table.find(armors, currentarmor.itemType) or 0) + 1
			if armors[armorindex] == nil then return end
			local highestbuyable = nil
			for i = armorindex, #armors, 1 do 
				local shopitem = getShopItem(armors[i])
				if shopitem and (AutoBuyTierSkip.Enabled or i == armorindex) then 
					local currency = getItem(shopitem.currency, inv.items)
					if currency and currency["amount"] >= shopitem.price then 
						highestbuyable = shopitem
						bedwars.ClientStoreHandler:dispatch({
							type = "BedwarsAddItemPurchased", 
							itemType = shopitem.itemType
						})
					end
				end
			end
			if highestbuyable and (highestbuyable.ignoredByKit == nil or table.find(highestbuyable.ignoredByKit, kit) == nil) then 
				buyItem(highestbuyable)
			end
		end,
		Sword = function(inv, upgrades, shoptype)
			if AutoBuySword.Enabled == false or shoptype ~= "item" then return end
			local currentsword = getItemNear("sword", inv.items)
			local swordindex = (currentsword and table.find(swords, currentsword.itemType) or 0) + 1
			if currentsword ~= nil and table.find(swords, currentsword.itemType) == nil then return end
			local highestbuyable = nil
			for i = swordindex, #swords, 1 do 
				local shopitem = getShopItem(swords[i])
				if shopitem then 
					local currency = getItem(shopitem.currency, inv.items)
					if currency and currency["amount"] >= shopitem.price and (shopitem.category ~= "Armory" or upgrades["armory"]) then 
						highestbuyable = shopitem
						bedwars.ClientStoreHandler:dispatch({
							type = "BedwarsAddItemPurchased", 
							itemType = shopitem.itemType
						})
					end
				end
			end
			if highestbuyable and (highestbuyable.ignoredByKit == nil or table.find(highestbuyable.ignoredByKit, kit) == nil) then 
				buyItem(highestbuyable)
			end
		end,
		Protection = function(inv, upgrades)
			if not AutoBuyProt.Enabled then return end
			buyUpgrade("armor", inv, upgrades)
		end,
		Sharpness = function(inv, upgrades)
			if not AutoBuySharp.Enabled then return end
			buyUpgrade("damage", inv, upgrades)
		end,
		Generator = function(inv, upgrades)
			if not AutoBuyGen.Enabled then return end
			buyUpgrade("generator", inv, upgrades)
		end,
		BreakSpeed = function(inv, upgrades)
			if not AutoBuyBreakSpeed.Enabled then return end
			buyUpgrade("break", inv, upgrades)
		end,
		Alarm = function(inv, upgrades)
			if not AutoBuyAlarm.Enabled then return end
			buyUpgrade("alarm", inv, upgrades)
		end,
		Armory = function(inv, upgrades)
			if not AutoBuyArmory.Enabled then return end
			buyUpgrade("armory", inv, upgrades)
		end
	}

	AutoBuy = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "AutoBuy", 
		Function = function(callback)
			if callback then 
				buyingthing = false 
				task.spawn(function()
					repeat
						task.wait()
						local found, npctype, enchant = nearNPC(AutoBuyRange.Value)
						if found then
							local inv = currentinventory.inventory
							local currentupgrades = bedwars.ClientStoreHandler:getState()["Bedwars"].teamUpgrades
							if kit == "dasher" then 
								swords = {
									[1] = "wood_dao",
									[2] = "stone_dao",
									[3] = "iron_dao",
									[4] = "diamond_dao",
									[5] = "emerald_dao"
								}
							elseif kit == "ice_queen" then 
								swords[5] = "ice_sword"
							elseif kit == "ember" then 
								swords[5] = "infernal_saber"
							elseif kit == "lumen" then 
								swords[5] = "light_sword"
							end
							if (AutoBuyGui.Enabled == false or (bedwars["AppController"]:isAppOpen("BedwarsItemShopApp") or bedwars["AppController"]:isAppOpen("BedwarsTeamUpgradeApp"))) and (not enchant) then
								for i,v in pairs(AutoBuyCustom["ObjectList"]) do 
									local autobuyitem = v:split("/")
									if #autobuyitem >= 3 and autobuyitem[4] ~= "true" then 
										local shopitem = getShopItem(autobuyitem[1])
										if shopitem then 
											local currency = getItem(shopitem.currency, inv.items)
											local actualitem = getItem(shopitem.itemType == "wool_white" and getwool() or shopitem.itemType, inv.items)
											if currency and currency["amount"] >= shopitem.price and (actualitem == nil or actualitem["amount"] < tonumber(autobuyitem[2])) then 
												buyItem(shopitem, tonumber(autobuyitem[2]) > 1)
											end
										end
									end
								end
								for i,v in pairs(buyfunctions) do v(inv, currentupgrades, npctype and "upgrade" or "item") end
								for i,v in pairs(AutoBuyCustom["ObjectList"]) do 
									local autobuyitem = v:split("/")
									if #autobuyitem >= 3 and autobuyitem[4] == "true" then 
										local shopitem = getShopItem(autobuyitem[1])
										if shopitem then 
											local currency = getItem(shopitem.currency, inv.items)
											local actualitem = getItem(shopitem.itemType == "wool_white" and getwool() or shopitem.itemType, inv.items)
											if currency and currency["amount"] >= shopitem.price and (actualitem == nil or actualitem["amount"] < tonumber(autobuyitem[2])) then 
												buyItem(shopitem, tonumber(autobuyitem[2]) > 1)
											end
										end
									end
								end
							end
						end
					until (not AutoBuy.Enabled)
				end)
			end
		end,
		HoverText = "Automatically Buys Swords, Armor, and Team Upgrades\nwhen you walk near the NPC"
	})
	AutoBuyRange = AutoBuy.CreateSlider({
		Name = "Range",
		Function = function() end,
		Min = 1,
		Max = 20,
		Default = 20
	})
	AutoBuyArmor = AutoBuy.CreateToggle({
		Name = "Buy Armor",
		Function = function() end, 
		Default = true
	})
	AutoBuySword = AutoBuy.CreateToggle({
		Name = "Buy Sword",
		Function = function() end, 
		Default = true
	})
	AutoBuyUpgrades = AutoBuy.CreateToggle({
		Name = "Buy Team Upgrades",
		Function = function(callback) 
			if AutoBuyUpgrades.Object then
				AutoBuyUpgrades.Object.ToggleArrow.Visible = callback
			end
			if AutoBuyGen.Object then
				AutoBuyGen.Object.Visible = callback
			end
			if AutoBuyProt.Object then
				AutoBuyProt.Object.Visible = callback
			end
			if AutoBuySharp.Object then
				AutoBuySharp.Object.Visible = callback
			end
			if AutoBuyBreakSpeed.Object then
				AutoBuyBreakSpeed.Object.Visible = callback
			end
			if AutoBuyAlarm.Object then
				AutoBuyAlarm.Object.Visible = callback
			end
            if AutoBuyArmory.Object then
				AutoBuyArmory.Object.Visible = callback
			end
		end, 
		Default = true
	})
	AutoBuyGen = AutoBuy.CreateToggle({
		Name = "Buy Team Generator",
		Function = function() end, 
	})
	AutoBuyProt = AutoBuy.CreateToggle({
		Name = "Buy Protection",
		Function = function() end, 
		Default = true
	})
	AutoBuySharp = AutoBuy.CreateToggle({
		Name = "Buy Sharpness",
		Function = function() end, 
		Default = true
	})
	AutoBuyBreakSpeed = AutoBuy.CreateToggle({
		Name = "Buy Break Speed",
		Function = function() end, 
	})
	AutoBuyAlarm = AutoBuy.CreateToggle({
		Name = "Buy Alarm",
		Function = function() end, 
	})
    AutoBuyArmory = AutoBuy.CreateToggle({
		Name = "Buy Armory",
		Function = function() end, 
	})
	AutoBuyGui = AutoBuy.CreateToggle({
		Name = "Shop GUI Check",
		Function = function() end, 	
	})
	AutoBuyTierSkip = AutoBuy.CreateToggle({
		Name = "Tier Skip",
		Function = function() end, 
		Default = true
	})
	AutoBuyGen.Object.BackgroundTransparency = 0
	AutoBuyGen.Object.BorderSizePixel = 0
	AutoBuyGen.Object.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	AutoBuyGen.Object.Visible = AutoBuyUpgrades.Enabled
	AutoBuyProt.Object.BackgroundTransparency = 0
	AutoBuyProt.Object.BorderSizePixel = 0
	AutoBuyProt.Object.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	AutoBuyProt.Object.Visible = AutoBuyUpgrades.Enabled
	AutoBuySharp.Object.BackgroundTransparency = 0
	AutoBuySharp.Object.BorderSizePixel = 0
	AutoBuySharp.Object.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	AutoBuySharp.Object.Visible = AutoBuyUpgrades.Enabled
	AutoBuyBreakSpeed.Object.BackgroundTransparency = 0
	AutoBuyBreakSpeed.Object.BorderSizePixel = 0
	AutoBuyBreakSpeed.Object.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	AutoBuyBreakSpeed.Object.Visible = AutoBuyUpgrades.Enabled
	AutoBuyAlarm.Object.BackgroundTransparency = 0
	AutoBuyAlarm.Object.BorderSizePixel = 0
	AutoBuyAlarm.Object.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	AutoBuyAlarm.Object.Visible = AutoBuyUpgrades.Enabled
    AutoBuyArmory.Object.BackgroundTransparency = 0
	AutoBuyArmory.Object.BorderSizePixel = 0
	AutoBuyArmory.Object.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	AutoBuyArmory.Object.Visible = AutoBuyUpgrades.Enabled
	AutoBuyCustom = AutoBuy.CreateTextList({
		Name = "BuyList",
		["TempText"] = "item/amount/priority/after",
		["SortFunction"] = function(a, b)
			local amount1 = a:split("/")
			local amount2 = b:split("/")
			amount1 = #amount1 and tonumber(amount1[3]) or 1
			amount2 = #amount2 and tonumber(amount2[3]) or 1
			return amount1 < amount2
		end
	})
	AutoBuyCustom.Object.AddBoxBKG.AddBox.TextSize = 14

	local AutoBankConnection
	local AutoBank = {Enabled = false}
	local AutoBankRange = {Value = 20}
	local AutoBankApple = {Enabled = false}
	local AutoBankBalloon = {Enabled = false}
	local AutoBankTransmitted, AutoBankTransmittedType = false, false
	local autobankoldapple
	local autobankoldballoon
	local autobankui

	local function refreshbank()
		if autobankui then
			local echest = repstorage.Inventories:FindFirstChild(lplr.Name.."_personal")
			for i,v in pairs(autobankui:GetChildren()) do 
				if echest:FindFirstChild(v.Name) then 
					v.Amount.Text = echest[v.Name]:GetAttribute("Amount")
				else
					v.Amount.Text = ""
				end
			end
		end
	end

	AutoBank = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "AutoBank",
		Function = function(callback)
			if callback then
				autobankui = Instance.new("Frame")
				autobankui.Size = UDim2.new(0, 240, 0, 40)
				autobankui.Position = UDim2.new(0, 0, 0, -200)
				task.spawn(function()
					repeat
						task.wait()
						if autobankui then 
							local hotbar = lplr.PlayerGui:FindFirstChild("hotbar")
							if hotbar then 
								local healthbar = hotbar["1"]:FindFirstChild("HotbarHealthbarContainer")
								if healthbar then 
									autobankui.Position = UDim2.new(0.5, -120, 0, healthbar.AbsolutePosition.Y - 50)
								end
							end
						else
							break
						end
					until (not AutoBank.Enabled)
				end)
				autobankui.BackgroundTransparency = 1
				autobankui.Parent = GuiLibrary["MainGui"]
				local emerald = Instance.new("ImageLabel")
				emerald.Image = bedwars.getIcon({itemType = "emerald"}, true)
				emerald.Size = UDim2.new(0, 40, 0, 40)
				emerald.Name = "emerald"
				emerald.Position = UDim2.new(0, 80, 0, 0)
				emerald.BackgroundTransparency = 1
				emerald.Parent = autobankui
				local emeraldtext = Instance.new("TextLabel")
				emeraldtext.TextSize = 20
				emeraldtext.BackgroundTransparency = 1
				emeraldtext.Size = UDim2.new(1, 0, 1, 0)
				emeraldtext.Font = Enum.Font.SourceSans
				emeraldtext.TextStrokeTransparency = 0.3
				emeraldtext.Name = "Amount"
				emeraldtext.Text = ""
				emeraldtext.TextColor3 = Color3.new(1, 1, 1)
				emeraldtext.Parent = emerald
				local diamond = emerald:Clone()
				diamond.Image = bedwars.getIcon({itemType = "diamond"}, true)
				diamond.Position = UDim2.new(0, 40, 0, 0)
				diamond.Name = "diamond"
				diamond.Parent = autobankui
				local iron = emerald:Clone()
				iron.Image = bedwars.getIcon({itemType = "iron"}, true)
				iron.Position = UDim2.new(0, 0, 0, 0)
				iron.Name = "iron"
				iron.Parent = autobankui
				local crystal = emerald:Clone()
				crystal.Image = bedwars.getIcon({itemType = "void_crystal"}, true)
				crystal.Position = UDim2.new(0, 120, 0, 0)
				crystal.Name = "void_crystal"
				crystal.Parent = autobankui
				local apple = emerald:Clone()
				apple.Image = bedwars.getIcon({itemType = "apple"}, true)
				apple.Position = UDim2.new(0, 160, 0, 0)
				apple.Name = "apple"
				apple.Parent = autobankui
				local balloon = emerald:Clone()
				balloon.Image = bedwars.getIcon({itemType = "balloon"}, true)
				balloon.Position = UDim2.new(0, 200, 0, 0)
				balloon.Name = "balloon"
				balloon.Parent = autobankui
				local echest = repstorage.Inventories:FindFirstChild(lplr.Name.."_personal")
				if entityLibrary.isAlive and echest then
					local chestitems = currentinventory.inventory.items
					for i3,v3 in pairs(chestitems) do
						if (v3.itemType == "void_crystal" or v3.itemType == "emerald" or v3.itemType == "iron" or v3.itemType == "diamond" or (v3.itemType == "apple" and AutoBankApple.Enabled) or (v3.itemType == "balloon" and AutoBankBalloon.Enabled)) then
							bedwars.ClientHandler:GetNamespace("Inventory"):Get("ChestGiveItem"):CallServer(echest, v3.tool)
							refreshbank()
						end
					end
				end
				refreshbank()
				AutoBankConnection = repstorage.Inventories.DescendantAdded:Connect(function(p3)
					if p3.Parent.Name == lplr.Name then
						if echest == nil then 
							echest = repstorage.Inventories:FindFirstChild(lplr.Name.."_personal")
						end	
						if not echest then return end
						if p3.Name == "apple" and AutoBankApple.Enabled then 
							if autobankapple then return end
						elseif p3.Name == "balloon" and AutoBankBalloon.Enabled then 
							if autobankballoon then autobankballoonevent:Fire() return end
						elseif (p3.Name == "void_crystal" or p3.Name == "emerald" or p3.Name == "iron" or p3.Name == "diamond") then
							if not ((not AutoBankTransmitted) or (AutoBankTransmittedType and p3.Name ~= "diamond")) then return end
						else
							return
						end
						bedwars.ClientHandler:GetNamespace("Inventory"):Get("ChestGiveItem"):CallServer(echest, p3)
						refreshbank()
					end
				end)
				task.spawn(function()
					repeat
						task.wait()
						local found, npctype = nearNPC(AutoBankRange.Value)
						if echest == nil then 
							echest = repstorage.Inventories:FindFirstChild(lplr.Name.."_personal")
						end
						if autobankballoon then 
							local chestitems = echest and echest:GetChildren() or {}
							if #chestitems > 0 then
								for i3,v3 in pairs(chestitems) do
									if v3:IsA("Accessory") and v3.Name == "balloon" then
										if (not getItem("balloon")) then
											task.spawn(function()
												bedwars.ClientHandler:GetNamespace("Inventory"):Get("ChestGetItem"):CallServer(echest, v3)
												refreshbank()
											end)
										end
									end
								end
							end
						end
						if autobankballoon ~= autobankoldballoon and AutoBankBalloon.Enabled then 
							if entityLibrary.isAlive then
								if not autobankballoon then
									local chestitems = currentinventory.inventory.items
									if #chestitems > 0 then
										for i3,v3 in pairs(chestitems) do
											if v3 and v3.itemType == "balloon" then
												task.spawn(function()
													bedwars.ClientHandler:GetNamespace("Inventory"):Get("ChestGiveItem"):CallServer(echest, v3.tool)
													refreshbank()
												end)
											end
										end
									end
								end
							end
							autobankoldballoon = autobankballoon
						end
						if autobankapple then 
							local chestitems = echest and echest:GetChildren() or {}
							if #chestitems > 0 then
								for i3,v3 in pairs(chestitems) do
									if v3:IsA("Accessory") and v3.Name == "apple" then
										if (not getItem("apple")) then
											task.spawn(function()
												bedwars.ClientHandler:GetNamespace("Inventory"):Get("ChestGetItem"):CallServer(echest, v3)
												refreshbank()
											end)
										end
									end
								end
							end
						end
						if (autobankapple ~= autobankoldapple) and AutoBankApple.Enabled then 
							if entityLibrary.isAlive then
								if not autobankapple then
									local chestitems = currentinventory.inventory.items
									if #chestitems > 0 then
										for i3,v3 in pairs(chestitems) do
											if v3 and v3.itemType == "apple" then
												task.spawn(function()
													bedwars.ClientHandler:GetNamespace("Inventory"):Get("ChestGiveItem"):CallServer(echest, v3.tool)
													refreshbank()
												end)
											end
										end
									end
								end
							end
							autobankoldapple = autobankapple
						end
						if found ~= AutoBankTransmitted or npctype ~= AutoBankTransmittedType then
							AutoBankTransmitted, AutoBankTransmittedType = found, npctype
							if entityLibrary.isAlive then
								local chestitems = currentinventory.inventory.items
								if #chestitems > 0 then
									for i3,v3 in pairs(chestitems) do
										if v3 and (v3.itemType == "void_crystal" or v3.itemType == "emerald" or v3.itemType == "iron" or v3.itemType == "diamond") then
											if (not AutoBankTransmitted) or (AutoBankTransmittedType and v3.Name ~= "diamond") then 
												task.spawn(function()
													bedwars.ClientHandler:GetNamespace("Inventory"):Get("ChestGiveItem"):CallServer(echest, v3.tool)
													refreshbank()
												end)
											end
										end
									end
								end
							end
						end
						if found then 
							local chestitems = echest and echest:GetChildren() or {}
							if #chestitems > 0 then
								for i3,v3 in pairs(chestitems) do
									if v3:IsA("Accessory") and ((npctype == false and (v3.Name == "void_crystal" or v3.Name == "emerald" or v3.Name == "iron")) or v3.Name == "diamond") then
										task.spawn(function()
											pcall(function()
												bedwars.ClientHandler:GetNamespace("Inventory"):Get("ChestGetItem"):CallServer(echest, v3)
											end)
											refreshbank()
										end)
									end
								end
							end
						end
					until (not AutoBank.Enabled)
				end)
			else
				if autobankui then
					autobankui:Remove()
					autobankui = nil
				end
				if AutoBankConnection then 
					AutoBankConnection:Disconnect()
				end
				local echest = repstorage.Inventories:FindFirstChild(lplr.Name.."_personal")
				local chestitems = echest and echest:GetChildren() or {}
				if #chestitems > 0 then
					for i3,v3 in pairs(chestitems) do
						if v3:IsA("Accessory") and (v3.Name == "void_crystal" or v3.Name == "emerald" or v3.Name == "iron" or v3.Name == "diamond" or v3.Name == "apple" or v3.Name == "balloon") then
							task.spawn(function()
								pcall(function()
									bedwars.ClientHandler:GetNamespace("Inventory"):Get("ChestGetItem"):CallServer(echest, v3)
								end)
								refreshbank()
							end)
						end
					end
				end
			end
		end
	})
	AutoBankApple = AutoBank.CreateToggle({
		Name = "Apple",
		Function = function(callback) 
			if not callback then 
				local echest = repstorage.Inventories:FindFirstChild(lplr.Name.."_personal")
				local chestitems = echest and echest:GetChildren() or {}
				for i3,v3 in pairs(chestitems) do
					if v3:IsA("Accessory") and v3.Name == "apple" then
						task.spawn(function()
							bedwars.ClientHandler:GetNamespace("Inventory"):Get("ChestGetItem"):CallServer(echest, v3)
							refreshbank()
						end)
					end
				end
			end
		end,
		Default = true
	})
	AutoBankBalloon = AutoBank.CreateToggle({
		Name = "Balloon",
		Function = function(callback) 
			if not callback then 
				local echest = repstorage.Inventories:FindFirstChild(lplr.Name.."_personal")
				local chestitems = echest and echest:GetChildren() or {}
				for i3,v3 in pairs(chestitems) do
					if v3:IsA("Accessory") and v3.Name == "balloon" then
						task.spawn(function()
							bedwars.ClientHandler:GetNamespace("Inventory"):Get("ChestGetItem"):CallServer(echest, v3)
							refreshbank()
						end)
					end
				end
			end
		end,
		Default = true
	})
	AutoBankDeath = AutoBank.CreateToggle({
		Name = "Damage",
		Function = function() end,
		HoverText = "puts away resources when you take damage to prevent losing on death"
	})
	AutoBankStay = AutoBank.CreateToggle({
		Name = "Stay",
		Function = function() end,
		HoverText = "keeps resources until toggled off"
	})
	AutoBankRange = AutoBank.CreateSlider({
		Name = "Range",
		Function = function() end,
		Min = 1,
		Max = 20,
		Default = 20
	})
end)

runcode(function()
	local Schematica = {Enabled = false}
	local SchematicaBox = {Value = ""}
	local SchematicaTransparency = {Value = 30}
	local positions = {}
	local tempfolder
	local tempgui
	local aroundpos = {
		[1] = Vector3.new(0, 3, 0),
		[2] = Vector3.new(-3, 3, 0),
		[3] = Vector3.new(-3, -0, 0),
		[4] = Vector3.new(-3, -3, 0),
		[5] = Vector3.new(0, -3, 0),
		[6] = Vector3.new(3, -3, 0),
		[7] = Vector3.new(3, -0, 0),
		[8] = Vector3.new(3, 3, 0),
		[9] = Vector3.new(0, 3, -3),
		[10] = Vector3.new(-3, 3, -3),
		[11] = Vector3.new(-3, -0, -3),
		[12] = Vector3.new(-3, -3, -3),
		[13] = Vector3.new(0, -3, -3),
		[14] = Vector3.new(3, -3, -3),
		[15] = Vector3.new(3, -0, -3),
		[16] = Vector3.new(3, 3, -3),
		[17] = Vector3.new(0, 3, 3),
		[18] = Vector3.new(-3, 3, 3),
		[19] = Vector3.new(-3, -0, 3),
		[20] = Vector3.new(-3, -3, 3),
		[21] = Vector3.new(0, -3, 3),
		[22] = Vector3.new(3, -3, 3),
		[23] = Vector3.new(3, -0, 3),
		[24] = Vector3.new(3, 3, 3),
		[25] = Vector3.new(0, -0, 3),
		[26] = Vector3.new(0, -0, -3)
	}

	local function isNearBlock(pos)
		for i,v in pairs(aroundpos) do
			if getblock(pos + v) then
				return true
			end
		end
		return false
	end

	local function gethighlightboxatpos(pos)
		if tempfolder then
			for i,v in pairs(tempfolder:GetChildren()) do
				if v.Position == pos then
					return v 
				end
			end
		end
		return nil
	end

	local function removeduplicates(tab)
		local actualpositions = {}
		for i,v in pairs(tab) do
			if table.find(actualpositions, Vector3.new(v.X, v.Y, v.Z)) == nil then
				table.insert(actualpositions, Vector3.new(v.X, v.Y, v.Z))
			else
				table.remove(tab, i)
			end
			if v["blockType"] == "start_block" then
				table.remove(tab, i)
			end
		end
	end

	local function rotate(tab)
		for i,v in pairs(tab) do
			local radvec, radius = entityLibrary.character.HumanoidRootPart.CFrame:ToAxisAngle()
			radius = (radius * 57.2957795)
			radius = math.round(radius / 90) * 90
			if radvec == Vector3.new(0, -1, 0) and radius == 90 then
				radius = 270
			end
			local rot = CFrame.new() * CFrame.fromAxisAngle(Vector3.new(0, 1, 0), math.rad(radius))
			local newpos = CFrame.new(0, 0, 0) * rot * CFrame.new(Vector3.new(v.X, v.Y, v.Z))
			v.X = math.round(newpos.p.X)
			v.Y = math.round(newpos.p.Y)
			v.Z = math.round(newpos.p.Z)
		end
	end

	local function getmaterials(tab)
		local materials = {}
		for i,v in pairs(tab) do
			materials[v["blockType"]] = (materials[v["blockType"]] and materials[v["blockType"]] + 1 or 1)
		end
		return materials
	end

	local function schemplaceblock(pos, blocktype, removefunc)
		local fail = false
		local ok = bedwars["RuntimeLib"].try(function()
			bedwars["ClientHandlerDamageBlock"]:Get("PlaceBlock"):CallServer({
				blockType = blocktype or getwool(),
				position = bedwars.BlockController:getBlockPosition(pos)
			})
		end, function(thing)
			fail = true
		end)
		if (not fail) and bedwars.BlockController:getStore():getBlockAt(bedwars.BlockController:getBlockPosition(pos)) then
			removefunc()
		end
	end

	Schematica = GuiLibrary.ObjectsThatCanBeSaved.WorldWindow.Api.CreateOptionsButton({
		Name = "Schematica",
		Function = function(callback)
			if callback then
				local mouseinfo = bedwars["BlockEngine"]:getBlockSelector():getMouseInfo(0)
				if mouseinfo and betterisfile(SchematicaBox.Value) then
					tempfolder = Instance.new("Folder")
					tempfolder.Parent = workspace
					local newpos = mouseinfo.placementPosition * 3
					positions = game:GetService("HttpService"):JSONDecode(readfile(SchematicaBox.Value))
					if positions["blocks"] == nil then
						positions = {["blocks"] = positions}
					end
					rotate(positions.blocks)
					removeduplicates(positions.blocks)
					if positions["start_block"] == nil then
						bedwars["placeBlock"](newpos)
					end
					for i2,v2 in pairs(positions.blocks) do
						local texturetxt = bedwars.ItemTable[(v2["blockType"] == "wool_white" and getwool() or v2["blockType"])]["block"]["greedyMesh"]["textures"][1]
						local newerpos = (newpos + Vector3.new(v2.X, v2.Y, v2.Z))
						local block = Instance.new("Part")
						block.Position = newerpos
						block.Size = Vector3.new(3, 3, 3)
						block.CanCollide = false
						block.Transparency = (SchematicaTransparency.Value == 10 and 0 or 1)
						block.Anchored = true
						block.Parent = tempfolder
						for i3,v3 in pairs(Enum.NormalId:GetEnumItems()) do
							local texture = Instance.new("Texture")
							texture.Face = v3
							texture.Texture = texturetxt
							texture.Name = tostring(v3)
							texture.Transparency = (SchematicaTransparency.Value == 10 and 0 or (1 / SchematicaTransparency.Value))
							texture.Parent = block
						end
					end
					task.spawn(function()
						repeat
							task.wait(.1)
							for i,v in pairs(positions.blocks) do
								local newerpos = (newpos + Vector3.new(v.X, v.Y, v.Z))
								if entityLibrary.isAlive and (entityLibrary.character.HumanoidRootPart.Position - newerpos).magnitude <= 30 and isNearBlock(newerpos) and bedwars.BlockController:isAllowedPlacement(lplr, getwool(), newerpos / 3, 0) then
									schemplaceblock(newerpos, (v["blockType"] == "wool_white" and getwool() or v["blockType"]), function()
										table.remove(positions.blocks, i)
										if gethighlightboxatpos(newerpos) then
											gethighlightboxatpos(newerpos):Remove()
										end
									end)
								end
							end
						until #positions.blocks == 0 or Schematica.Enabled == false
						if Schematica.Enabled then 
							Schematica.ToggleButton(false)
							createwarning("Schematica", "Finished Placing Blocks", 4)
						end
					end)
				end
			else
				positions = {}
				if tempfolder then
					tempfolder:Remove()
				end
			end
		end,
		HoverText = "Automatically places structure at mouse position."
	})
	SchematicaBox = Schematica.CreateTextBox({
		Name = "File",
		["TempText"] = "File (location in workspace)",
		["FocusLost"] = function(enter) 
			local suc, res = pcall(function() return game:GetService("HttpService"):JSONDecode(readfile(SchematicaBox.Value)) end)
			if tempgui then
				tempgui:Remove()
			end
			if suc then
				if res["blocks"] == nil then
					res = {["blocks"] = res}
				end
				removeduplicates(res.blocks)
				tempgui = Instance.new("Frame")
				tempgui.Name = "SchematicListOfBlocks"
				tempgui.BackgroundTransparency = 1
				tempgui.LayoutOrder = 9999
				tempgui.Parent = SchematicaBox.Object.Parent
				local uilistlayoutschmatica = Instance.new("UIListLayout")
				uilistlayoutschmatica.Parent = tempgui
				connectionstodisconnect[#connectionstodisconnect + 1] = uilistlayoutschmatica:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
					tempgui.Size = UDim2.new(0, 220, 0, uilistlayoutschmatica.AbsoluteContentSize.Y)
				end)
				for i4,v4 in pairs(getmaterials(res.blocks)) do
					local testframe = Instance.new("Frame")
					testframe.Size = UDim2.new(0, 220, 0, 40)
					testframe.BackgroundTransparency = 1
					testframe.Parent = tempgui
					local testimage = Instance.new("ImageLabel")
					testimage.Size = UDim2.new(0, 40, 0, 40)
					testimage.Position = UDim2.new(0, 3, 0, 0)
					testimage.BackgroundTransparency = 1
					testimage.Image = bedwars.getIcon({itemType = i4}, true)
					testimage.Parent = testframe
					local testtext = Instance.new("TextLabel")
					testtext.Size = UDim2.new(1, -50, 0, 40)
					testtext.Position = UDim2.new(0, 50, 0, 0)
					testtext.TextSize = 20
					testtext.Text = v4
					testtext.Font = Enum.Font.SourceSans
					testtext.TextXAlignment = Enum.TextXAlignment.Left
					testtext.TextColor3 = Color3.new(1, 1, 1)
					testtext.BackgroundTransparency = 1
					testtext.Parent = testframe
				end
			end
		end
	})
	SchematicaTransparency = Schematica.CreateSlider({
		Name = "Transparency",
		Min = 0,
		Max = 10,
		Default = 7,
		Function = function()
			if tempfolder then
				for i2,v2 in pairs(tempfolder:GetChildren()) do
					v2.Transparency = (SchematicaTransparency.Value == 10 and 0 or 1)
					for i3,v3 in pairs(v2:GetChildren()) do
						v3.Transparency = (SchematicaTransparency.Value == 10 and 0 or (1 / SchematicaTransparency.Value))
					end
				end
			end
		end
	})
end)

runcode(function()
	local AutoSuffocate = {Enabled = false}
	local AutoSuffocateTransparency = {Value = 30}
	local positions = {}
	local tempfolder
	local tempgui
	local aroundpos = {
		[1] = Vector3.new(0, 3, 0),
		[2] = Vector3.new(-3, 3, 0),
		[3] = Vector3.new(-3, -0, 0),
		[4] = Vector3.new(-3, -3, 0),
		[5] = Vector3.new(0, -3, 0),
		[6] = Vector3.new(3, -3, 0),
		[7] = Vector3.new(3, -0, 0),
		[8] = Vector3.new(3, 3, 0),
		[9] = Vector3.new(0, 3, -3),
		[10] = Vector3.new(-3, 3, -3),
		[11] = Vector3.new(-3, -0, -3),
		[12] = Vector3.new(-3, -3, -3),
		[13] = Vector3.new(0, -3, -3),
		[14] = Vector3.new(3, -3, -3),
		[15] = Vector3.new(3, -0, -3),
		[16] = Vector3.new(3, 3, -3),
		[17] = Vector3.new(0, 3, 3),
		[18] = Vector3.new(-3, 3, 3),
		[19] = Vector3.new(-3, -0, 3),
		[20] = Vector3.new(-3, -3, 3),
		[21] = Vector3.new(0, -3, 3),
		[22] = Vector3.new(3, -3, 3),
		[23] = Vector3.new(3, -0, 3),
		[24] = Vector3.new(3, 3, 3),
		[25] = Vector3.new(0, -0, 3),
		[26] = Vector3.new(0, -0, -3)
	}

	local function isNearBlock(pos)
		for i,v in pairs(aroundpos) do
			if getblock(pos + v) then
				return true
			end
		end
		return false
	end

	local function gethighlightboxatpos(pos)
		if tempfolder then
			for i,v in pairs(tempfolder:GetChildren()) do
				if v.Position == pos then
					return v 
				end
			end
		end
		return nil
	end

	local function removeduplicates(tab)
		local actualpositions = {}
		for i,v in pairs(tab) do
			if table.find(actualpositions, Vector3.new(v.X, v.Y, v.Z)) == nil then
				table.insert(actualpositions, Vector3.new(v.X, v.Y, v.Z))
			else
				table.remove(tab, i)
			end
			if v["blockType"] == "start_block" then
				table.remove(tab, i)
			end
		end
	end

	local function rotate(tab)
		for i,v in pairs(tab) do
			local radvec, radius = entityLibrary.character.HumanoidRootPart.CFrame:ToAxisAngle()
			radius = (radius * 57.2957795)
			radius = math.round(radius / 90) * 90
			if radius == 90 and radvec.Y < -0.9 then
				radius = 270
			end
			local rot = CFrame.new() * CFrame.fromAxisAngle(Vector3.new(0, 1, 0), math.rad(radius))
			local newpos = CFrame.new(0, 0, 0) * rot * CFrame.new(Vector3.new(v.X, v.Y, v.Z))
			v.X = math.round(newpos.p.X)
			v.Y = math.round(newpos.p.Y)
			v.Z = math.round(newpos.p.Z)
		end
	end

	local function getmaterials(tab)
		local materials = {}
		for i,v in pairs(tab) do
			materials[v["blockType"]] = (materials[v["blockType"]] and materials[v["blockType"]] + 1 or 1)
		end
		return materials
	end

	local function schemplaceblock(pos, blocktype, removefunc)
		local fail = false
		local ok = bedwars["RuntimeLib"].try(function()
			bedwars["ClientHandlerDamageBlock"]:Get("PlaceBlock"):CallServer({
				blockType = blocktype or getwool(),
				position = bedwars.BlockController:getBlockPosition(pos)
			})
		end, function(thing)
			fail = true
		end)
		if (not fail) and bedwars.BlockController:getStore():getBlockAt(bedwars.BlockController:getBlockPosition(pos)) then
			removefunc()
		end
	end

	AutoSuffocate = GuiLibrary.ObjectsThatCanBeSaved.WorldWindow.Api.CreateOptionsButton({
		Name = "AutoSuffocate",
		Function = function(callback)
			if callback then
				local mouseinfo = bedwars["BlockEngine"]:getBlockSelector():getMouseInfo(0)
				if mouseinfo then
					tempfolder = Instance.new("Folder")
					tempfolder.Parent = workspace
					local newpos = mouseinfo.placementPosition * 3
					positions = {
                        blocks = {
							[1] = {X = 0, Y = 3, Z = 0, blockType = "wool_white"},
							[2] = {X = 0, Y = 6, Z = 0, blockType = "wool_white"},
							[3] = {X = 0, Y = 9, Z = 0, blockType = "wool_white"},
							[4] = {X = 0, Y = 0, Z = -21, blockType = "wool_white"},
							[5] = {X = 0, Y = 3, Z = -21, blockType = "wool_white"},
							[6] = {X = 0, Y = 6, Z = -21, blockType = "wool_white"},
							[7] = {X = 0, Y = 9, Z = -21, blockType = "wool_white"},
							[8] = {X = 0, Y = 9, Z = -18, blockType = "wool_white"},
							[9] = {X = 0, Y = 9, Z = -15, blockType = "wool_white"},
							[10] = {X = 0, Y = 9, Z = -12, blockType = "wool_white"},
							[11] = {X = 0, Y = 9, Z = -9, blockType = "wool_white"},
							[12] = {X = 0, Y = 9, Z = -6, blockType = "wool_white"},
							[13] = {X = 0, Y = 9, Z = -3, blockType = "wool_white"},
							[14] = {X = 0, Y = 6, Z = -18, blockType = "wool_white"},
							[15] = {X = 0, Y = 6, Z = -15, blockType = "wool_white"},
							[16] = {X = 0, Y = 6, Z = -12, blockType = "wool_white"},
							[17] = {X = 0, Y = 6, Z = -9, blockType = "wool_white"},
							[18] = {X = 0, Y = 6, Z = -6, blockType = "wool_white"},
							[19] = {X = 0, Y = 6, Z = -3, blockType = "wool_white"},
							[20] = {X = 0, Y = 3, Z = -18, blockType = "wool_white"},
							[21] = {X = 0, Y = 3, Z = -15, blockType = "wool_white"},
							[22] = {X = 0, Y = 3, Z = -12, blockType = "wool_white"},
							[23] = {X = 0, Y = 3, Z = -9, blockType = "wool_white"},
							[24] = {X = 0, Y = 3, Z = -6, blockType = "wool_white"},
							[25] = {X = 0, Y = 3, Z = -3, blockType = "wool_white"},
							[26] = {X = 0, Y = 0, Z = -18, blockType = "wool_white"},
							[27] = {X = 0, Y = 0, Z = -15, blockType = "wool_white"},
							[28] = {X = 0, Y = 0, Z = -12, blockType = "wool_white"},
							[29] = {X = 0, Y = 0, Z = -9, blockType = "wool_white"},
							[30] = {X = 0, Y = 0, Z = -6, blockType = "wool_white"},
							[31] = {X = 0, Y = 0, Z = -3, blockType = "wool_white"},
                        }
                    }
					if positions["blocks"] == nil then
						positions = {["blocks"] = positions}
					end
					rotate(positions.blocks)
					removeduplicates(positions.blocks)
					if positions["start_block"] == nil then
						bedwars["placeBlock"](newpos)
					end
					for i2,v2 in pairs(positions.blocks) do
						local texturetxt = bedwars.ItemTable[(v2["blockType"] == "wool_white" and getwool() or v2["blockType"])]["block"]["greedyMesh"]["textures"][1]
						local newerpos = (newpos + Vector3.new(v2.X, v2.Y, v2.Z))
						local block = Instance.new("Part")
						block.Position = newerpos
						block.Size = Vector3.new(3, 3, 3)
						block.CanCollide = false
						block.Transparency = (AutoSuffocateTransparency.Value == 10 and 0 or 1)
						block.Anchored = true
						block.Parent = tempfolder
						for i3,v3 in pairs(Enum.NormalId:GetEnumItems()) do
							local texture = Instance.new("Texture")
							texture.Face = v3
							texture.Texture = texturetxt
							texture.Name = tostring(v3)
							texture.Transparency = (AutoSuffocateTransparency.Value == 10 and 0 or (1 / AutoSuffocateTransparency.Value))
							texture.Parent = block
						end
					end
					task.spawn(function()
						local neededblocks = 0
						repeat
							task.wait()
							neededblocks = 0
							for i,v in pairs(positions.blocks) do
								local newerpos = (newpos + Vector3.new(v.X, v.Y, v.Z))
								if v.placed then continue end
								if AutoSuffocate.Enabled == false then
									break
								end
								neededblocks = neededblocks + 1
								if entityLibrary.isAlive and (entityLibrary.character.HumanoidRootPart.Position - newerpos).magnitude <= 30 and isNearBlock(newerpos) then
									if bedwars.BlockController:isAllowedPlacement(lplr, getwool(), newerpos / 3, 0) then
										schemplaceblock(newerpos, (v["blockType"] == "wool_white" and getwool() or v["blockType"]), function()
											v.placed = true
											if gethighlightboxatpos(newerpos) then
												gethighlightboxatpos(newerpos):Remove()
											end
										end)
									else
										v.placed = true
										if gethighlightboxatpos(newerpos) then
											gethighlightboxatpos(newerpos):Remove()
										end
									end
								end
							end
						until neededblocks == 0 or AutoSuffocate.Enabled == false
						if AutoSuffocate.Enabled then 
							AutoSuffocate.ToggleButton(false)
							createwarning("AutoSuffocate", "Finished Placing Blocks", 4)
						end
					end)
				end
			else
				positions = {}
				if tempfolder then
					tempfolder:Remove()
				end
			end
		end,
		HoverText = "Automatically places structure at mouse position."
	})
	AutoSuffocateTransparency = AutoSuffocate.CreateSlider({
		Name = "Transparency",
		Min = 0,
		Max = 10,
		Default = 7,
		Function = function()
			if tempfolder then
				for i2,v2 in pairs(tempfolder:GetChildren()) do
					v2.Transparency = (AutoSuffocateTransparency.Value == 10 and 0 or 1)
					for i3,v3 in pairs(v2:GetChildren()) do
						v3.Transparency = (AutoSuffocateTransparency.Value == 10 and 0 or (1 / AutoSuffocateTransparency.Value))
					end
				end
			end
		end
	})
end)

runcode(function()
	local damagetimer = 0
	local damagetimertick = 0
	local directionvec
	local longjumpdelay = tick()
	local sliderval2 = {Value = 1.5}

	task.spawn(function()
		bedwars.ClientHandler:WaitFor("EntityDamageEvent"):andThen(function(p6)
			connectionstodisconnect[#connectionstodisconnect + 1] = p6:Connect(function(p7)
				if p7.entityInstance == lplr.Character and longjump.Enabled and (not p7.knockbackMultiplier or not p7.knockbackMultiplier.disabled) then 
					local kbval = p7.knockbackMultiplier and p7.knockbackMultiplier.horizontal and p7.knockbackMultiplier.horizontal * sliderval2.Value or sliderval2.Value
					if damagetimertick < tick() or kbval >= damagetimer then
						damagetimer = kbval
						damagetimertick = tick() + 2.5
						local newpos = entityLibrary.character.HumanoidRootPart.CFrame.lookVector
						directionvec = Vector3.new(newpos.X, 0, newpos.Z).Unit
					end
				end
			end)
		end)
	end)

	local function calculatepos(vec)
		local returned = vec
		if entityLibrary.isAlive then 
			local newray = workspace:Raycast(entityLibrary.character.HumanoidRootPart.Position, returned, blockraycast)
			if newray then returned = (newray.Position - entityLibrary.character.HumanoidRootPart.Position) end
		end
		return returned
	end

	local damagemethods = {
		fireball = function(fireball, pos)
			if not longjump.Enabled then return end
			task.delay(0.4, function()
				if not longjump.Enabled then return end
				pos = pos - (entityLibrary.character.HumanoidRootPart.CFrame.lookVector * 0.2)
				if not (getblock(pos - Vector3.new(0, 3, 0)) or getblock(pos - Vector3.new(0, 6, 0))) then
					local sound = Instance.new("Sound")
					sound.SoundId = "rbxassetid://4809574295"
					sound.Parent = workspace
					sound.Ended:Connect(function()
						sound:Destroy()
					end)
					sound:Play()
				end
				local origpos = pos
				local offsetshootpos = (CFrame.new(pos, pos + Vector3.new(0, -60, 0)) * CFrame.new(Vector3.new(-bedwars.BowConstantsTable.RelX, -bedwars.BowConstantsTable.RelY, -bedwars.BowConstantsTable.RelZ))).p
				bedwars.ProjectileController:createLocalProjectile(bedwars.ProjectileMeta["fireball"], "fireball", "fireball", offsetshootpos, "", Vector3.new(0, -60, 0), {drawDurationSeconds = 1})
				bedwars.ClientHandler:Get(bedwars["ProjectileRemote"]):CallServerAsync(fireball["tool"], "fireball", "fireball", offsetshootpos, pos, Vector3.new(0, -60, 0), game:GetService("HttpService"):GenerateGUID(true), {drawDurationSeconds = 1}, workspace:GetServerTimeNow() - 0.045)
			end)
		end,
		tnt = function(tnt, pos2)
			if not longjump.Enabled then return end
			local pos = Vector3.new(pos2.X, getScaffold(Vector3.new(0, pos2.Y - math.floor(entityLibrary.character.Humanoid.HipHeight, 0))).Y, pos2.Z)
			local block = bedwars["placeBlock"](pos, "tnt")
		end,
		cannon = function(tnt, pos2)
			task.spawn(function()
				local pos = Vector3.new(pos2.X, getScaffold(Vector3.new(0, pos2.Y - math.floor(entityLibrary.character.Humanoid.HipHeight, 0))).Y, pos2.Z)
				local block = bedwars["placeBlock"](pos, "cannon")
				task.delay(0.1, function()
					local block, pos2 = getblock(pos)
					if block and block.Name == "cannon" and (entityLibrary.character.HumanoidRootPart.CFrame.p - block.Position).Magnitude < 20 then 
						local vec = entityLibrary.character.HumanoidRootPart.CFrame.lookVector
						local damage = bedwars.BlockController:calculateBlockDamage(lplr, {
							blockPosition = pos2
						})
						bedwars.ClientHandler:Get(bedwars.CannonAimRemote):SendToServer({
							["cannonBlockPos"] = pos2,
							["lookVector"] = vec
						})
						if damage < block:GetAttribute("Health") then 
							task.spawn(function()
								bedwars.breakBlock(block.Position, true, getbestside(block.Position), true, true)
							end)
						end
						task.delay(0.4, function()
							bedwars.CannonHandController:launchSelf(block)
							task.delay(0.1, function()
								damagetimer = sliderval2.Value * 5
								damagetimertick = tick() + 2.5
								directionvec = Vector3.new(vec.X, 0, vec.Z).Unit
							end)
							bedwars.breakBlock(block.Position, true, getbestside(block.Position), true, true)
						end)
					end
				end)	
			end)
		end,
		wood_dao = function(tnt, pos2)
			task.delay(0.7, function()
				local vec = entityLibrary.character.HumanoidRootPart.CFrame.lookVector
				repstorage["events-@easy-games/game-core:shared/game-core-networking@getEvents.Events"].useAbility:FireServer("dash", {
					direction = vec,
					origin = entityLibrary.character.HumanoidRootPart.CFrame.p,
					weapon = tnt.itemType
				})
				damagetimer = sliderval2.Value
				damagetimertick = tick() + 2.5
				directionvec = Vector3.new(vec.X, 0, vec.Z).Unit
			end)
		end,
		jade_hammer = function(tnt, pos2)
			task.spawn(function()
				repeat task.wait() until bedwars["AbilityController"]:canUseAbility("jade_hammer_jump") or not longjump.Enabled
				task.delay(0.7, function()
					if bedwars["AbilityController"]:canUseAbility("jade_hammer_jump") and longjump.Enabled then
						bedwars["AbilityController"]:useAbility("jade_hammer_jump")
						local vec = entityLibrary.character.HumanoidRootPart.CFrame.lookVector
						damagetimer = sliderval2.Value * 2.5
						damagetimertick = tick() + 2.5
						directionvec = Vector3.new(vec.X, 0, vec.Z).Unit
					end
				end)
			end)
		end,
		void_axe = function(tnt, pos2)
			task.spawn(function()
				repeat task.wait() until bedwars["AbilityController"]:canUseAbility("void_axe_jump") or not longjump.Enabled
				task.delay(0.7, function()
					if bedwars["AbilityController"]:canUseAbility("void_axe_jump") and longjump.Enabled then
						bedwars["AbilityController"]:useAbility("void_axe_jump")
						local vec = entityLibrary.character.HumanoidRootPart.CFrame.lookVector
						damagetimer = sliderval2.Value * 2.5
						damagetimertick = tick() + 2.5
						directionvec = Vector3.new(vec.X, 0, vec.Z).Unit
					end
				end)
			end)
		end
	}
	damagemethods.stone_dao = damagemethods.wood_dao
	damagemethods.iron_dao = damagemethods.wood_dao
	damagemethods.diamond_dao = damagemethods.wood_dao
	damagemethods.emerald_dao = damagemethods.wood_dao

	local oldgrav
	local longjumpacprogressbarframe = Instance.new("Frame")
	longjumpacprogressbarframe.AnchorPoint = Vector2.new(0.5, 0)
	longjumpacprogressbarframe.Position = UDim2.new(0.5, 0, 1, -200)
	longjumpacprogressbarframe.Size = UDim2.new(0.2, 0, 0, 20)
	longjumpacprogressbarframe.BackgroundTransparency = 0.5
	longjumpacprogressbarframe.BorderSizePixel = 0
	longjumpacprogressbarframe.BackgroundColor3 = Color3.new(0, 0, 0)
	longjumpacprogressbarframe.Visible = longjump.Enabled
	longjumpacprogressbarframe.Parent = GuiLibrary["MainGui"]
	local longjumpacprogressbarframe2 = longjumpacprogressbarframe:Clone()
	longjumpacprogressbarframe2.AnchorPoint = Vector2.new(0, 0)
	longjumpacprogressbarframe2.Position = UDim2.new(0, 0, 0, 0)
	longjumpacprogressbarframe2.Size = UDim2.new(1, 0, 0, 20)
	longjumpacprogressbarframe2.BackgroundTransparency = 0
	longjumpacprogressbarframe2.Visible = true
	longjumpacprogressbarframe2.BackgroundColor3 = Color3.new(0.9, 0.9, 0.9)
	longjumpacprogressbarframe2.Parent = longjumpacprogressbarframe
	local longjumpacprogressbartext = Instance.new("TextLabel")
	longjumpacprogressbartext.Text = "2.5s"
	longjumpacprogressbartext.Font = Enum.Font.Gotham
	longjumpacprogressbartext.TextStrokeTransparency = 0
	longjumpacprogressbartext.TextColor3 =  Color3.new(0.9, 0.9, 0.9)
	longjumpacprogressbartext.TextSize = 20
	longjumpacprogressbartext.Size = UDim2.new(1, 0, 1, 0)
	longjumpacprogressbartext.BackgroundTransparency = 1
	longjumpacprogressbartext.Position = UDim2.new(0, 0, -1, 0)
	longjumpacprogressbartext.Parent = longjumpacprogressbarframe
	local sliderval = {Value = 1.5}
	longjump = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "LongJump",
		Function = function(callback)
			if callback then
				task.spawn(function()
					local startpos = entityLibrary.isAlive and entityLibrary.character.HumanoidRootPart.Position
					local tntcheck
					longjumpdelay = tick()
					for i,v in pairs(damagemethods) do 
						local item = getItem(i)
						if item then
							if i == "tnt" then 
								local pos = getScaffold(startpos)
								tntcheck = Vector3.new(pos.X, startpos.Y, pos.Z)
								v(item, pos)
							else
								v(item, startpos)
							end
							break
						end
					end
					local timestart
					local passed = false
					local changecheck
					longjumpacprogressbarframe.Visible = true
					local funnytick = tick() + 0.4
					RunLoops:BindToHeartbeat("LongJump", 1, function(dt)
						if entityLibrary.isAlive then 
							if entityLibrary.character.Humanoid.Health <= 0 then 
								longjump.ToggleButton(false)
								return
							end
							if startpos == nil then 
								startpos = entityLibrary.character.HumanoidRootPart.Position
							end
							local newval = damagetimer ~= 0
							if changecheck ~= newval then 
								if newval then 
									longjumpacprogressbarframe2:TweenSize(UDim2.new(0, 0, 0, 20), Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 2.5, true)
								else
									longjumpacprogressbarframe2:TweenSize(UDim2.new(1, 0, 0, 20), Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0, true)
								end
								changecheck = newval
							end
							if newval then 
								if timestart == nil then
									timestart = tick()
								end
								if (damagetimertick - tick()) < 1.2 then 
									damagetimer = 0.001
								end
								if longjumpacprogressbartext then 
									longjumpacprogressbartext.Text = (math.max(math.floor((damagetimertick - tick()) * 10) / 10, 0)).."s"
								end
								if not passed then 
									passed = getblock(entityLibrary.character.HumanoidRootPart.Position - Vector3.new(0, 3, 0)) == nil
								end
								if directionvec == nil then 
									directionvec = entityLibrary.character.HumanoidRootPart.CFrame.lookVector
								end
								local newpos = Vector3.new(directionvec.X, 0, directionvec.Z)
								local newvelo = newpos.Unit == newpos.Unit and newpos.Unit * (20 * getSpeedMultiplier()) or Vector3.zero
								local val = (sliderval.Value / 10)
								newpos = newpos * (math.max(3, damagetimer * (((damagetimertick - tick()) - val) / (2.5 - val)))) * dt
								local ray = workspace:Raycast(entityLibrary.character.HumanoidRootPart.Position, newpos, blockraycast)
								if ray then 
									newpos = Vector3.zero
									newvelo = Vector3.zero
								end
								entityLibrary.character.HumanoidRootPart.Velocity = newvelo
								entityLibrary.character.HumanoidRootPart.CFrame = entityLibrary.character.HumanoidRootPart.CFrame + newpos
							else
								longjumpacprogressbartext.Text = "2.5s"
								entityLibrary.character.HumanoidRootPart.CFrame = CFrame.new(startpos, startpos + entityLibrary.character.HumanoidRootPart.CFrame.lookVector)
								entityLibrary.character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
								if tntcheck then 
									entityLibrary.character.HumanoidRootPart.CFrame = CFrame.new(tntcheck + entityLibrary.character.HumanoidRootPart.CFrame.lookVector, tntcheck + (entityLibrary.character.HumanoidRootPart.CFrame.lookVector * 2))
								end
							end
						else
							if longjumpacprogressbartext then 
								longjumpacprogressbartext.Text = "2.5s"
							end
							startpos = nil
							tntcheck = nil
						end
					end)
				end)
			else
				longjumpacprogressbarframe.Visible = false
				RunLoops:UnbindFromHeartbeat("LongJump")
				directionvec = nil
				tntcheck = nil
				startpos = nil
				damagetimer = 0
				damagetimertick = 0
			end
		end, 
		HoverText = "Lets you jump farther (Not landing on same level & Spamming can lead to lagbacks)"
	})
	sliderval = longjump.CreateSlider({
		Name = "Slowdown",
		Min = 1,
		Max = 1,
		Double = 10,
		Function = function() end,
		Default = 1,
	})
	sliderval2 = longjump.CreateSlider({
		Name = "Speed",
		Min = 1,
		Max = 60,
		Function = function() end,
		Default = 60
	})
end)

runcode(function()
	local function roundpos(dir, pos, size)
		local suc, res = pcall(function() return Vector3.new(math.clamp(dir.X, pos.X - (size.X / 2), pos.X + (size.X / 2)), math.clamp(dir.Y, pos.Y - (size.Y / 2), pos.Y + (size.Y / 2)), math.clamp(dir.Z, pos.Z - (size.Z / 2), pos.Z + (size.Z / 2))) end)
		return suc and res or Vector3.zero
	end

	local spiderspeed = {Value = 0}
	local spidermode = {Value = "Normal"}
	local spiderpart
	local spiderconnection1
	local spiderconnection2
	Spider = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "Spider",
		Function = function(callback)
			if callback then
				spiderconnection1 = uis.InputBegan:Connect(function(input1)
					if input1.KeyCode == Enum.KeyCode.LeftShift then 
						holdingshift = true
					end
				end)
				spiderconnection2 = uis.InputEnded:Connect(function(input1)
					if input1.KeyCode == Enum.KeyCode.LeftShift then 
						holdingshift = false
					end
				end)
				RunLoops:BindToHeartbeat("Spider", 1, function()
					if entityLibrary.isAlive then
						if spidermode.Value == "Normal" then
							local vec = entityLibrary.character.Humanoid.MoveDirection * 2
							local newray = getblock(entityLibrary.character.HumanoidRootPart.Position + (vec + Vector3.new(0, 0.1, 0)))
							local newray2 = getblock(entityLibrary.character.HumanoidRootPart.Position + (vec - Vector3.new(0, entityLibrary.character.Humanoid.HipHeight, 0)))
							if newray and (not newray.CanCollide) then newray = nil end 
							if newray2 and (not newray2.CanCollide) then newray2 = nil end 
							if spidergoinup and (not newray) and (not newray2) then
								entityLibrary.character.HumanoidRootPart.Velocity = Vector3.new(entityLibrary.character.HumanoidRootPart.Velocity.X, 0, entityLibrary.character.HumanoidRootPart.Velocity.Z)
							end
							spidergoinup = ((newray or newray2) and true or false)
							if (newray or newray2) and (GuiLibrary.ObjectsThatCanBeSaved["PhaseOptionsButton"]["Api"].Enabled == false or holdingshift == false) then
								entityLibrary.character.HumanoidRootPart.Velocity = Vector3.new(newray2 and newray == nil and entityLibrary.character.HumanoidRootPart.Velocity.X or 0, spiderspeed.Value, newray2 and newray == nil and entityLibrary.character.HumanoidRootPart.Velocity.Z or 0)
							end
						else
							if not spiderpart then 
								spiderpart = Instance.new("TrussPart")
								spiderpart.Size = Vector3.new(2, 2, 2)
								spiderpart.Transparency = 1
								spiderpart.Anchored = true
								spiderpart.Parent = cam
							end
							local newray2, newray2pos = getblock(entityLibrary.character.HumanoidRootPart.Position + ((entityLibrary.character.HumanoidRootPart.CFrame.lookVector * 1.5) - Vector3.new(0, entityLibrary.character.Humanoid.HipHeight, 0)))
							if newray2 and (not newray2.CanCollide) then newray2 = nil end 
							if newray2 then 
								newray2pos = newray2pos * 3
								local newpos = roundpos(entityLibrary.character.HumanoidRootPart.Position, Vector3.new(newray2pos.X, math.min(entityLibrary.character.HumanoidRootPart.Position.Y, newray2pos.Y), newray2pos.Z), Vector3.new(1.1, 1.1, 1.1))
								spiderpart.Position = newpos
							else
								spiderpart.Position = Vector3.zero
							end
						end
					end
				end)
			else
				if spiderconnection1 then spiderconnection1:Disconnect() end
				if spiderconnection2 then spiderconnection2:Disconnect() end
				if spiderpart then 
					spiderpart:Remove()
				end
				RunLoops:UnbindFromHeartbeat("Spider")
				holdingshift = false
			end
		end,
		HoverText = "Lets you climb up walls"
	})
	spidermode = Spider.CreateDropdown({
		Name = "Mode",
		List = {"Normal", "Classic"},
		Function = function() 
			if spiderpart then 
				spiderpart:Remove()
			end
		end
	})
	spiderspeed = Spider.CreateSlider({
		Name = "Speed",
		Min = 0,
		Max = 40,
		Function = function() end,
		Default = 40
	})
end)

runcode(function()
	local killauraboxes = {}
    local killauratargetframe = {["Players"] = {Enabled = false}}
	local killaurasortmethod = {Value = "Distance"}
    local killaurarealremote = bedwars.ClientHandler:Get(bedwars["AttackRemote"])["instance"]
    local killauramethod = {Value = "Normal"}
	local killauraothermethod = {Value = "Normal"}
    local killauraanimmethod = {Value = "Normal"}
	local killauraaps = {["GetRandomValue"] = function() return 1 end}
    local killaurarange = {Value = 14}
    local killauraangle = {Value = 360}
    local killauratargets = {Value = 10}
    local killauramouse = {Enabled = false}
    local killauracframe = {Enabled = false}
    local killauragui = {Enabled = false}
    local killauratarget = {Enabled = false}
    local killaurasound = {Enabled = false}
    local killauraswing = {Enabled = false}
    local killaurahandcheck = {Enabled = false}
    local killaurabaguette = {Enabled = false}
    local killauraanimation = {Enabled = false}
	local killauracolor = {Value = 0.44}
	local killauranovape = {Enabled = false}
	local killauratargethighlight = {Enabled = false}
	local killaurarangecircle = {Enabled = false}
	local killaurarangecirclepart
	local killauraaimcircle = {Enabled = false}
	local killauraaimcirclepart
	local killauraparticle = {Enabled = false}
	local killauraprediction = {Enabled = false}
	local killauraparticlepart
	local killaurahitdelay = tick()
    local killauradelay = 0
    local Killauranear = false
    local killauraplaying = false
    local oldplay = function() end
    local oldsound = function() end
    local origC0 = nil
	local killauracurrentanim
	local targettable = {}
	local targetsize = 0
	local animationdelay = tick()

	local function getStrength(plr)
		local inv = inventories[plr.Player]
		local strength = 0
		local strongestsword = 0
		if inv then
			for i,v in pairs(inv.items) do 
				local itemmeta = bedwars.ItemTable[v.itemType]
				if itemmeta and itemmeta.sword and itemmeta.sword.damage > strongestsword then 
					strongestsword = itemmeta.sword.damage / 100
				end	
			end
			strength = strength + strongestsword
			for i,v in pairs(inv.armor) do 
				local itemmeta = bedwars.ItemTable[v.itemType]
				if itemmeta and itemmeta.armor then 
					strength = strength + (itemmeta.armor.damageReductionMultiplier or 0)
				end
			end
			strength = strength
		end
		return strength
	end

	local killaurasortmethods = {
		Distance = function(a, b)
			return (a.RootPart.Position - entityLibrary.character.HumanoidRootPart.Position).Magnitude < (b.RootPart.Position - entityLibrary.character.HumanoidRootPart.Position).Magnitude
		end,
		Health = function(a, b) 
			return a.Humanoid.Health < b.Humanoid.Health
		end,
		Threat = function(a, b) 
			return getStrength(a) > getStrength(b)
		end,
	}
	local lastplr

	local function newAttackEntity(plr, firstplayercodedone, attackedplayers)
		if not entityLibrary.isAlive then
			return nil
		end
		local root = plr.RootPart
		if not root then 
			return nil
		end
		if killauramouse.Enabled and (not uis:IsMouseButtonPressed(0)) then
			return nil
		end
		if killauragui.Enabled and (not (#bedwars["AppController"]:getOpenApps() <= (kit == "hannah" and 4 or 3) and GuiLibrary["MainGui"].ScaledGui.ClickGui.Visible == false)) then
			return nil
		end
		local equipped = getEquipped()
		if killaurahandcheck.Enabled and (equipped["Type"] ~= "sword" or bedwars["KatanaController"].chargingMaid) then
			return nil
		end
		local localfacing = entityLibrary.character.HumanoidRootPart.CFrame.lookVector
		local vec = (plr.RootPart.Position - entityLibrary.character.HumanoidRootPart.Position).unit
		local angle = math.acos(localfacing:Dot(vec))
		if angle >= (math.rad(killauraangle.Value) / 2) then
			return nil
		end
		if killauratargetframe["Walls"].Enabled then
			if not bedwars.SwordController:canSee({["player"] = plr.Player, ["getInstance"] = function() return plr.Character end}) then return nil end
		end
		local sword = killaurahandcheck.Enabled and {tool = equipped.Object} or (equipped.Object and (equipped.Object.Name == "frying_pan" or equipped.Object.Name == "baguette") and {tool = equipped.Object} or getSword())
		local swordmeta = bedwars.ItemTable[sword and sword["tool"] and sword["tool"].Name or "wood_sword"]
		if (not firstplayercodedone.done) then
			killauranear = true
			firstplayercodedone.done = true
			if animationdelay <= tick() then
				animationdelay = tick() + 0.19
				if not killauraswing.Enabled then 
					bedwars.SwordController:playSwordEffect(swordmeta)
				end
			end
		end
		if killauratarget.Enabled then
			table.insert(attackedplayers, plr)
		end
		if not (sword and sword["tool"]) then
			return nil
		end
		if (workspace:GetServerTimeNow() - bedwars.SwordController.lastAttack) < bedwars.ItemTable[sword["tool"].Name].sword.attackSpeed then 
			return nil
		end
		local playertype, playerattackable = WhitelistFunctions:CheckPlayerType(plr.Player)
		if not playerattackable then
			return nil
		end
		if killauranovape.Enabled and clients.ClientUsers[plr.Player.Name] then
			return nil
		end
		if oldcloneroot then 
			if (oldcloneroot.Position - root.Position).Magnitude >= 18 then 
				return nil
			end
		end
		local selfrootpos = entityLibrary.character.HumanoidRootPart.Position
		local selfcheck = oldcloneroot and oldcloneroot.Position or entityLibrary.LocalPosition or selfrootpos
		if (selfcheck - (entityLibrary.OtherPosition[plr.Player] or root.Position)).Magnitude > 18 then 
			return nil
		end
		local selfpos = selfrootpos + (killaurarange.Value > 14 and (selfrootpos - root.Position).magnitude > 14 and (CFrame.lookAt(selfrootpos, root.Position).lookVector * 4) or Vector3.zero)
		bedwars.SwordController.lastAttack = workspace:GetServerTimeNow() - 0.11
		killaurarealremote:FireServer({
			["weapon"] = sword["tool"],
			["chargedAttack"] = {chargeRatio = swordmeta.sword and swordmeta.sword.chargedAttack and swordmeta.sword.chargedAttack.maxChargeTimeSec or 0},
			["entityInstance"] = plr.Character,
			["validate"] = {
				["raycast"] = {
					["cameraPosition"] = hashvec(cam.CFrame.p), 
					["cursorDirection"] = hashvec(Ray.new(cam.CFrame.p, root.Position).Unit.Direction)
				},
				["targetPosition"] = hashvec(root.Position),
				["selfPosition"] = hashvec(selfpos)
			}
		})
	end

	local orig
	local orig2
	local anims = {
		Normal = {
			{CFrame = CFrame.new(0.69, -0.7, 0.6) * CFrame.Angles(math.rad(295), math.rad(55), math.rad(290)), Time = 0.05},
			{CFrame = CFrame.new(0.69, -0.71, 0.6) * CFrame.Angles(math.rad(200), math.rad(60), math.rad(1)), Time = 0.05}
		},
		Slow = {
			{CFrame = CFrame.new(0.69, -0.7, 0.6) * CFrame.Angles(math.rad(295), math.rad(55), math.rad(290)), Time = 0.15},
			{CFrame = CFrame.new(0.69, -0.71, 0.6) * CFrame.Angles(math.rad(200), math.rad(60), math.rad(1)), Time = 0.15}
		},
		New = {
			{CFrame = CFrame.new(0.69, -0.77, 1.47) * CFrame.Angles(math.rad(-33), math.rad(57), math.rad(-81)), Time = 0.12},
			{CFrame = CFrame.new(0.74, -0.92, 0.88) * CFrame.Angles(math.rad(147), math.rad(71), math.rad(53)), Time = 0.12}
		},
		["Vertical Spin"] = {
			{CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(-90), math.rad(8), math.rad(5)), Time = 0.1},
			{CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(180), math.rad(3), math.rad(13)), Time = 0.1},
			{CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(90), math.rad(-5), math.rad(8)), Time = 0.1},
			{CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(0), math.rad(-0), math.rad(-0)), Time = 0.1}
		},
		Exhibition = {
			{CFrame = CFrame.new(0.69, -0.7, 0.6) * CFrame.Angles(math.rad(-30), math.rad(50), math.rad(-90)), Time = 0.1},
			{CFrame = CFrame.new(0.7, -0.71, 0.59) * CFrame.Angles(math.rad(-84), math.rad(50), math.rad(-38)), Time = 0.2}
		},
		["Exhibition Old"] = {
			{CFrame = CFrame.new(0.69, -0.7, 0.6) * CFrame.Angles(math.rad(-30), math.rad(50), math.rad(-90)), Time = 0.15},
			{CFrame = CFrame.new(0.69, -0.7, 0.6) * CFrame.Angles(math.rad(-30), math.rad(50), math.rad(-90)), Time = 0.05},
			{CFrame = CFrame.new(0.7, -0.71, 0.59) * CFrame.Angles(math.rad(-84), math.rad(50), math.rad(-38)), Time = 0.1},
			{CFrame = CFrame.new(0.7, -0.71, 0.59) * CFrame.Angles(math.rad(-84), math.rad(50), math.rad(-38)), Time = 0.05},
			{CFrame = CFrame.new(0.63, -0.1, 1.37) * CFrame.Angles(math.rad(-84), math.rad(50), math.rad(-38)), Time = 0.15}
		}
	}

	local function closestpos(block, pos)
		local blockpos = block:GetRenderCFrame()
		local startpos = (blockpos * CFrame.new(-(block.Size / 2))).p
		local endpos = (blockpos * CFrame.new((block.Size / 2))).p
		local newpos = block.Position + (pos - block.Position)
		local x = startpos.X > endpos.X and endpos.X or startpos.X
		local y = startpos.Y > endpos.Y and endpos.Y or startpos.Y
		local z = startpos.Z > endpos.Z and endpos.Z or startpos.Z
		local x2 = startpos.X < endpos.X and endpos.X or startpos.X
		local y2 = startpos.Y < endpos.Y and endpos.Y or startpos.Y
		local z2 = startpos.Z < endpos.Z and endpos.Z or startpos.Z
		return Vector3.new(math.clamp(newpos.X, x, x2), math.clamp(newpos.Y, y, y2), math.clamp(newpos.Z, z, z2))
	end

    Killaura = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
        Name = "Killaura",
        Function = function(callback)
            if callback then
				if killauraaimcirclepart then 
					killauraaimcirclepart.Parent = cam
				end
				if killaurarangecirclepart then 
					killaurarangecirclepart.Parent = cam
				end
				if killauraparticlepart then 
					killauraparticlepart.Parent = cam
				end
				task.spawn(function()
					repeat
						task.wait()
						if (killauraanimation.Enabled and not killauraswing.Enabled) then
							if killauranear then
								pcall(function()
									if origC0 == nil then
										origC0 = cam.Viewmodel.RightHand.RightWrist.C0
									end
									if killauraplaying == false then
										killauraplaying = true
										for i,v in pairs(anims[killauraanimmethod.Value]) do 
											if (not Killaura.Enabled) or (not killauranear) then break end
											killauracurrentanim = game:GetService("TweenService"):Create(cam.Viewmodel.RightHand.RightWrist, TweenInfo.new(v.Time), {C0 = origC0 * v.CFrame})
											killauracurrentanim:Play()
											task.wait(v.Time - 0.01)
										end
										killauraplaying = false
									end
								end)	
							end
						end
					until Killaura.Enabled == false
				end)
                oldplay = bedwars.ViewmodelController.playAnimation
                oldsound = bedwars.SoundManager["playSound"]
                bedwars.SoundManager["playSound"] = function(tab, soundid, ...)
                    if (soundid == bedwars.SoundList.SWORD_SWING_1 or soundid == bedwars.SoundList.SWORD_SWING_2) and Killaura.Enabled and killaurasound.Enabled and killauranear then
                        return nil
                    end
                    return oldsound(tab, soundid, ...)
                end
                bedwars.ViewmodelController.playAnimation = function(Self, id, ...)
                    if id == 15 and killauranear and killauraswing.Enabled and entityLibrary.isAlive then
                        return nil
                    end
                    if id == 15 and killauranear and killauraanimation.Enabled and entityLibrary.isAlive then
                        return nil
                    end
                    return oldplay(Self, id, ...)
                end
				local targetedplayer
				RunLoops:BindToHeartbeat("Killaura", 1, function()
					for i,v in pairs(killauraboxes) do 
						if v:IsA("BoxHandleAdornment") and v.Adornee then
							local cf = v.Adornee and v.Adornee.CFrame
							local onex, oney, onez = cf:ToEulerAnglesXYZ() 
							v.CFrame = CFrame.new() * CFrame.Angles(-onex, -oney, -onez)
						end
					end
					if entityLibrary.isAlive then
						if killauraaimcirclepart then 
							killauraaimcirclepart.Position = targetedplayer and closestpos(targetedplayer.RootPart, entityLibrary.character.HumanoidRootPart.Position) or Vector3.new(99999, 99999, 99999)
						end
						if killauraparticlepart then 
							killauraparticlepart.Position = targetedplayer and targetedplayer.RootPart.Position or Vector3.new(99999, 99999, 99999)
						end
						local Root = entityLibrary.character.HumanoidRootPart
						if Root then
							if killaurarangecirclepart then 
								killaurarangecirclepart.Position = Root.Position - Vector3.new(0, entityLibrary.character.Humanoid.HipHeight, 0)
							end
							local Neck = entityLibrary.character.Head:FindFirstChild("Neck")
							local LowerTorso = Root.Parent and Root.Parent:FindFirstChild("LowerTorso")
							local RootC0 = LowerTorso and LowerTorso:FindFirstChild("Root")
							if Neck and RootC0 then
								if orig == nil then
									orig = Neck.C0.p
								end
								if orig2 == nil then
									orig2 = RootC0.C0.p
								end
								if orig2 and killauracframe.Enabled then
									if targetedplayer ~= nil then
										local targetPos = targetedplayer.RootPart.Position + Vector3.new(0, 2, 0)
										local direction = (Vector3.new(targetPos.X, targetPos.Y, targetPos.Z) - entityLibrary.character.Head.Position).Unit
										local direction2 = (Vector3.new(targetPos.X, Root.Position.Y, targetPos.Z) - Root.Position).Unit
										local lookCFrame = (CFrame.new(Vector3.zero, (Root.CFrame):VectorToObjectSpace(direction)))
										local lookCFrame2 = (CFrame.new(Vector3.zero, (Root.CFrame):VectorToObjectSpace(direction2)))
										Neck.C0 = CFrame.new(orig) * CFrame.Angles(lookCFrame.LookVector.Unit.y, 0, 0)
										RootC0.C0 = lookCFrame2 + orig2
									else
										Neck.C0 = CFrame.new(orig)
										RootC0.C0 = CFrame.new(orig2)
									end
								end
							end
						end
					end
				end)
                task.spawn(function()
					repeat
						task.wait()
						targetinfo.Targets.Killaura = nil
						if (GuiLibrary.ObjectsThatCanBeSaved["Lobby CheckToggle"]["Api"].Enabled == false or matchState ~= 0) and Killaura.Enabled then
							local plrs = GetAllNearestHumanoidToPosition(killauratargetframe["Players"].Enabled, killaurarange.Value - 0.0001, 1, false, (oldcloneroot and oldcloneroot.Position or entityLibrary.LocalPosition), killaurasortmethods[killaurasortmethod.Value], killauraprediction.Enabled)
							local attackedplayers = {}
							local firstplayercodedone = {done = false}
							for i,plr in pairs(plrs) do
								task.spawn(newAttackEntity, plr, firstplayercodedone, attackedplayers)
								if firstplayercodedone.done then
									targetedplayer = plr
									targetinfo.Targets.Killaura = plr
								end
							end
							for i,v in pairs(killauraboxes) do 
								local attacked = attackedplayers[i]
								v.Adornee = attacked and ((not killauratargethighlight.Enabled) and attacked.RootPart or (not GuiLibrary.ObjectsThatCanBeSaved["ChamsOptionsButton"]["Api"].Enabled) and attacked.Character or nil)
							end
							if (#plrs <= 0) then
								lastplr = nil
								targetedplayer = nil
								killauranear = false
								pcall(function()
									if origC0 == nil then
										origC0 = cam.Viewmodel.RightHand.RightWrist.C0
									end
									if cam.Viewmodel.RightHand.RightWrist.C0 ~= origC0 then
										pcall(function()
											killauracurrentanim:Cancel()
										end)
										killauracurrentanim = game:GetService("TweenService"):Create(cam.Viewmodel.RightHand.RightWrist, TweenInfo.new(0.1), {C0 = origC0})
										killauracurrentanim:Play()
									end
								end)
							end
						end
					until (not Killaura.Enabled)
				end)
            else
				targetinfo.Targets.Killaura = nil
				RunLoops:UnbindFromHeartbeat("Killaura") 
                killauranear = false
				for i,v in pairs(killauraboxes) do 
					v.Adornee = nil
				end
				if killauraaimcirclepart then 
					killauraaimcirclepart.Parent = nil
				end
				if killaurarangecirclepart then 
					killaurarangecirclepart.Parent = nil
				end
				if killauraparticlepart then 
					killauraparticlepart.Parent = nil
				end
                bedwars.ViewmodelController.playAnimation = oldplay
                bedwars.SoundManager["playSound"] = oldsound
                oldplay = nil
				targetinfo.UpdateInfo({}, 0)
                pcall(function()
					if entityLibrary.isAlive then
						local Root = entityLibrary.character.HumanoidRootPart
						if Root then
							local Neck = Root.Parent.Head.Neck
							if orig and orig2 then 
								Neck.C0 = CFrame.new(orig)
								Root.Parent.LowerTorso.Root.C0 = CFrame.new(orig2)
							end
						end
					end
                    if origC0 == nil then
                        origC0 = cam.Viewmodel.RightHand.RightWrist.C0
                    end
                    if cam.Viewmodel.RightHand.RightWrist.C0 ~= origC0 then
						pcall(function()
							killauracurrentanim:Cancel()
						end)
						killauracurrentanim = game:GetService("TweenService"):Create(cam.Viewmodel.RightHand.RightWrist, TweenInfo.new(0.1), {C0 = origC0})
						killauracurrentanim:Play()
                    end
                end)
            end
        end,
        HoverText = "Attack players around you\nwithout aiming at them."
    })
    killauratargetframe = Killaura.CreateTargetWindow({})
	local sortmethods = {"Distance"}
	for i,v in pairs(killaurasortmethods) do if i ~= "Distance" then table.insert(sortmethods, i) end end
	killaurasortmethod = Killaura.CreateDropdown({
		Name = "Sort",
		Function = function() end,
		List = sortmethods
	})
    killaurarange = Killaura.CreateSlider({
        Name = "Attack range",
        Min = 1,
        Max = 18,
        Function = function(val) 
			if killaurarangecirclepart then 
				killaurarangecirclepart.Size = Vector3.new(val * 0.7, 0.01, val * 0.7)
			end
		end, 
        Default = 18
    })
    killauraangle = Killaura.CreateSlider({
        Name = "Max angle",
        Min = 1,
        Max = 360,
        Function = function(val) end,
        Default = 360
    })
    killauraanimmethod = Killaura.CreateDropdown({
        Name = "Animation", 
        List = {"Normal", "Slow", "New", "Vertical Spin", "Exhibition", "Exhibition Old"},
        Function = function(val) end
    })
    killauramouse = Killaura.CreateToggle({
        Name = "Require mouse down",
        Function = function() end,
		HoverText = "Only attacks when left click is held.",
        Default = false
    })
    killauragui = Killaura.CreateToggle({
        Name = "GUI Check",
        Function = function() end,
		HoverText = "Attacks when you are not in a GUI."
    })
    killauratarget = Killaura.CreateToggle({
        Name = "Show target",
        Function = function(callback) 
			if killauratargethighlight.Object then 
				killauratargethighlight.Object.Visible = callback
			end
		end,
		HoverText = "Shows a red box over the opponent."
    })
	killauratargethighlight = Killaura.CreateToggle({
		Name = "Use New Highlight",
		Function = function(callback) 
			for i,v in pairs(killauraboxes) do 
				v:Remove()
			end
			for i = 1, 10 do 
				local killaurabox
				if callback then 
					killaurabox = Instance.new("Highlight")
					killaurabox.FillTransparency = 0.5
					killaurabox.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
					killaurabox.OutlineTransparency = 1
					killaurabox.Parent = GuiLibrary["MainGui"]
				else
					killaurabox = Instance.new("BoxHandleAdornment")
					killaurabox.Transparency = 0.5
					killaurabox.Color3 = Color3.fromHSV(killauracolor["Hue"], killauracolor["Sat"], killauracolor.Value)
					killaurabox.Adornee = nil
					killaurabox.AlwaysOnTop = true
					killaurabox.Size = Vector3.new(3, 6, 3)
					killaurabox.ZIndex = 11
					killaurabox.Parent = GuiLibrary["MainGui"]
				end
				killauraboxes[i] = killaurabox
			end
		end
	})
	killauratargethighlight.Object.BorderSizePixel = 0
	killauratargethighlight.Object.BackgroundTransparency = 0
	killauratargethighlight.Object.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	killauratargethighlight.Object.Visible = false
	killauracolor = Killaura.CreateColorSlider({
		Name = "Target Color",
		Function = function(hue, sat, val) 
			for i,v in pairs(killauraboxes) do 
				v[(killauratargethighlight.Enabled and "FillColor" or "Color3")] = Color3.fromHSV(hue, sat, val)
			end
			if killauraaimcirclepart then 
				killauraaimcirclepart.Color = Color3.fromHSV(hue, sat, val)
			end
			if killaurarangecirclepart then 
				killaurarangecirclepart.Color = Color3.fromHSV(hue, sat, val)
			end
		end,
		Default = 1
	})
	for i = 1, 10 do 
		local killaurabox = Instance.new("BoxHandleAdornment")
		killaurabox.Transparency = 0.5
		killaurabox.Color3 = Color3.fromHSV(killauracolor["Hue"], killauracolor["Sat"], killauracolor.Value)
		killaurabox.Adornee = nil
		killaurabox.AlwaysOnTop = true
		killaurabox.Size = Vector3.new(3, 6, 3)
		killaurabox.ZIndex = 11
		killaurabox.Parent = GuiLibrary["MainGui"]
		killauraboxes[i] = killaurabox
	end
    killauracframe = Killaura.CreateToggle({
        Name = "Face target",
        Function = function() end,
		HoverText = "Makes your character face the opponent."
    })
	killaurarangecircle = Killaura.CreateToggle({
		Name = "Range Visualizer",
		Function = function(callback)
			if callback then 
				killaurarangecirclepart = Instance.new("MeshPart")
				killaurarangecirclepart.MeshId = "rbxassetid://3726303797"
				killaurarangecirclepart.Color = Color3.fromHSV(killauracolor["Hue"], killauracolor["Sat"], killauracolor.Value)
				killaurarangecirclepart.CanCollide = false
				killaurarangecirclepart.Anchored = true
				killaurarangecirclepart.Material = Enum.Material.Neon
				killaurarangecirclepart.Size = Vector3.new(killaurarange.Value * 0.7, 0.01, killaurarange.Value * 0.7)
				killaurarangecirclepart.Parent = cam
				bedwars["QueryUtil"]:setQueryIgnored(killaurarangecirclepart, true)
			else
				if killaurarangecirclepart then 
					killaurarangecirclepart:Destroy()
					killaurarangecirclepart = nil
				end
			end
		end
	})
	killauraaimcircle = Killaura.CreateToggle({
		Name = "Aim Visualizer",
		Function = function(callback)
			if callback then 
				killauraaimcirclepart = Instance.new("Part")
				killauraaimcirclepart.Shape = Enum.PartType.Ball
				killauraaimcirclepart.Color = Color3.fromHSV(killauracolor["Hue"], killauracolor["Sat"], killauracolor.Value)
				killauraaimcirclepart.CanCollide = false
				killauraaimcirclepart.Anchored = true
				killauraaimcirclepart.Material = Enum.Material.Neon
				killauraaimcirclepart.Size = Vector3.new(0.5, 0.5, 0.5)
				killauraaimcirclepart.Parent = cam
				bedwars["QueryUtil"]:setQueryIgnored(killauraaimcirclepart, true)
			else
				if killauraaimcirclepart then 
					killauraaimcirclepart:Destroy()
					killauraaimcirclepart = nil
				end
			end
		end
	})
	killauraparticle = Killaura.CreateToggle({
		Name = "Crit Particle",
		Function = function(callback)
			if callback then 
				killauraparticlepart = Instance.new("Part")
				killauraparticlepart.Transparency = 1
				killauraparticlepart.CanCollide = false
				killauraparticlepart.Anchored = true
				killauraparticlepart.Size = Vector3.new(3, 6, 3)
				killauraparticlepart.Parent = cam
				bedwars["QueryUtil"]:setQueryIgnored(killauraparticlepart, true)
				local particle = Instance.new("ParticleEmitter")
				particle.Lifetime = NumberRange.new(0.5)
				particle.Rate = 500
				particle.Speed = NumberRange.new(0)
				particle.RotSpeed = NumberRange.new(180)
				particle.Enabled = true
				particle.Size = NumberSequence.new(0.3)
				particle.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(67, 10, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 98, 255))})
				particle.Parent = killauraparticlepart
			else
				if killauraparticlepart then 
					killauraparticlepart:Destroy()
					killauraparticlepart = nil
				end
			end
		end
	})
    killaurasound = Killaura.CreateToggle({
        Name = "No Swing Sound",
        Function = function() end,
		HoverText = "Removes the swinging sound."
    })
    killauraswing = Killaura.CreateToggle({
        Name = "No Swing",
        Function = function() end,
		HoverText = "Removes the swinging animation."
    })
    killaurahandcheck = Killaura.CreateToggle({
        Name = "Limit to items",
        Function = function() end,
		HoverText = "Only attacks when your sword is held."
    })
    killaurabaguette = Killaura.CreateToggle({
        Name = "Baguette Aura",
        Function = function() end,
		HoverText = "Uses the baguette instead of the sword."
    })
    killauraanimation = Killaura.CreateToggle({
        Name = "Custom Animation",
        Function = function() end,
		HoverText = "Uses a custom animation for swinging"
    })
	killauraprediction = Killaura.CreateToggle({
        Name = "Prediction",
        Function = function() end,
		HoverText = "Experimental Prediction for Player Movement"
    })
	if WhitelistFunctions:CheckPlayerType(lplr) ~= "DEFAULT" then
		killauranovape = Killaura.CreateToggle({
			Name = "No Vape",
			Function = function() end,
			HoverText = "no hit vape user"
		})
	end
end)

runcode(function()
	local BowAura = {Enabled = false}
	local BowAuraRange = {Value = 40}

	local function shoot(item, ammotypething)
		local plr = GetNearestHumanoidToPosition(true, BowAuraRange.Value, oldcloneroot and oldcloneroot.Position)
		if queueType == "winter_event" and entityLibrary.isAlive then 
			local boss = workspace:FindFirstChild("WinterEventBoss")
			if boss and (boss.PrimaryPart.Position - entityLibrary.character.HumanoidRootPart.Position).Magnitude < 300 then 
				plr = {RootPart = boss.PrimaryPart, Player = {Name = "", UserId = 99999999}, Character = workspace}
			end
		end
		targetinfo.Targets.ProjectileAura = plr
		if plr then 
			local rayparams = RaycastParams.new()
			local tab = {lplr.Character}
			for i,v in pairs(entityLibrary.entityList) do if v.Targetable then table.insert(tab, v.Character) end end
			rayparams.FilterDescendantsInstances = tab
			local rayCheckPos = (CFrame.new(entityLibrary.character.HumanoidRootPart.Position, plr.RootPart.Position) * CFrame.new(Vector3.new(bedwars.BowConstantsTable.RelX, bedwars.BowConstantsTable.RelY, 0))).p
			if bedwars["QueryUtil"]:raycast(rayCheckPos, plr.RootPart.Position - rayCheckPos, rayparams) then return end
			local plrtype, plrattackable = WhitelistFunctions:CheckPlayerType(plr.Player)
			if not plrattackable then return end
			local projsource = bedwars.ItemTable[item.itemType].projectileSource
			local ammo = projsource.projectileType(ammotypething)	
			local projmeta = bedwars.ProjectileMeta[ammo]
			local startPos = (oldcloneroot or entityLibrary.character.HumanoidRootPart).Position
			local offsetStartPos = startPos + Vector3.new(0, 2, 0)
			local prediction = (worldmeta and projmeta.predictionLifetimeSec or projmeta.lifetimeSec or 3)
			local launchvelo = (projmeta.launchVelocity or 100)
			local gravity = (projmeta.gravitationalAcceleration or 196.2)
			local multigrav = gravity
			local pos = plr.RootPart.Position
			local playergrav = workspace.Gravity
			local balloons = plr.Character:GetAttribute("InflatedBalloons")
			if balloons and balloons > 0 then 
				playergrav = (workspace.Gravity * (1 - ((balloons >= 4 and 1.2 or balloons >= 3 and 1 or 0.975))))
			end
			local shootpos, shootvelo = predictGravity(pos, plr.Character.HumanoidRootPart.Velocity, (pos - offsetStartPos).Magnitude / launchvelo, plr, playergrav)
			if projmeta.projectile == "telepearl" then
				shootpos = pos
				shootvelo = Vector3.zero
			end
			local newlook = CFrame.new(offsetStartPos, shootpos) * CFrame.new(Vector3.new(-bedwars.BowConstantsTable.RelX, -bedwars.BowConstantsTable.RelY, 0))
			shootpos = newlook.p + (newlook.lookVector * (offsetStartPos - shootpos).magnitude)
			local calculated = LaunchDirection(offsetStartPos, shootpos, launchvelo, multigrav, false)
			if calculated then 
				local guid = game:GetService("HttpService"):GenerateGUID()
				bedwars.ProjectileController:createLocalProjectile(tab, ammotypething, ammo, offsetStartPos, guid, calculated, {drawDurationSeconds = 1})
				bedwars.ClientHandler:Get(bedwars["ProjectileRemote"]):CallServerAsync(item["tool"], ammotypething, ammo, offsetStartPos, startPos, calculated, guid, {drawDurationSeconds = 1}, workspace:GetServerTimeNow() - 0.045)
				task.wait(projsource.fireDelaySec)
			end
		end
	end

	BowAura = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
        Name = "ProjectileAura",
        Function = function(callback)
			if callback then 
				task.spawn(function()
					repeat
						if (GuiLibrary.ObjectsThatCanBeSaved["Lobby CheckToggle"]["Api"].Enabled == false or matchState ~= 0) and BowAura.Enabled and entityLibrary.isAlive then
							local bow = getBow()
							if bow and getItem("arrow") then
								shoot(bow, "arrow")
							end
						end
						task.wait()
					until (not BowAura.Enabled)
				end)
				task.spawn(function()
					repeat
						if (GuiLibrary.ObjectsThatCanBeSaved["Lobby CheckToggle"]["Api"].Enabled == false or matchState ~= 0) and BowAura.Enabled and entityLibrary.isAlive then
							local snowball = getItem("snowball")
							if snowball then 
								shoot(snowball, "snowball")
							end
						end
						task.wait()
					until (not BowAura.Enabled)
				end)
			else
				targetinfo.Targets.ProjectileAura = nil
			end
		end
	})
	BowAuraRange = BowAura.CreateSlider({
		Name = "Range",
		Function = function() end,
		Min = 1,
		Max = 50,
		Default = 50
	})
end)

runcode(function()
	local shoothook
	local oldchargetime
	local oldclickhold
	local oldclickhold2
	local roact 
	local FastConsumeProjectile = {Enabled = false}
	FastConsume = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "FastConsume",
		Function = function(callback)
			if callback then
				oldclickhold = bedwars["ClickHold"].startClick
				oldclickhold2 = bedwars["ClickHold"].showProgress
				bedwars["ClickHold"].showProgress = function(p5)
					local roact = debug.getupvalue(oldclickhold2, 1)
					local countdown = roact.mount(roact.createElement("ScreenGui", {}, { roact.createElement("Frame", {
						[roact.Ref] = p5.wrapperRef, 
						Size = UDim2.new(0, 0, 0, 0), 
						Position = UDim2.new(0.5, 0, 0.55, 0), 
						AnchorPoint = Vector2.new(0.5, 0), 
						BackgroundColor3 = Color3.fromRGB(0, 0, 0), 
						BackgroundTransparency = 0.8
					}, { roact.createElement("Frame", {
							[roact.Ref] = p5.progressRef, 
							Size = UDim2.new(0, 0, 1, 0), 
							BackgroundColor3 = Color3.fromRGB(255, 255, 255), 
							BackgroundTransparency = 0.5
						}) }) }), lplr:FindFirstChild("PlayerGui"))
					p5.handle = countdown
					local sizetween = game:GetService("TweenService"):Create(p5.wrapperRef:getValue(), TweenInfo.new(0.1), {
						Size = UDim2.new(0.11, 0, 0.005, 0)
					})
					table.insert(p5.tweens, sizetween)
					sizetween:Play()
					local countdowntween = game:GetService("TweenService"):Create(p5.progressRef:getValue(), TweenInfo.new(p5.durationSeconds * (FastConsumeVal.Value / 40), Enum.EasingStyle.Linear), {
						Size = UDim2.new(1, 0, 1, 0)
					})
					table.insert(p5.tweens, countdowntween)
					countdowntween:Play()
					return countdown
				end
				bedwars["ClickHold"].startClick = function(p4)
					p4.startedClickTime = tick()
					local u2 = p4:showProgress()
					local clicktime = p4.startedClickTime
					bedwars["RuntimeLib"].Promise.defer(function()
						task.wait(p4.durationSeconds * (FastConsumeVal.Value / 40))
						if u2 == p4.handle and clicktime == p4.startedClickTime and p4.closeOnComplete then
							p4:hideProgress()
							if p4.onComplete ~= nil then
								p4.onComplete()
							end
							if p4.onPartialComplete ~= nil then
								p4.onPartialComplete(1)
							end
							p4.startedClickTime = -1
						end
					end)
				end
			else
				bedwars["ClickHold"].startClick = oldclickhold
				bedwars["ClickHold"].showProgress = oldclickhold2
				oldchargetime = nil
				oldclickhold = nil
				oldclickhold2 = nil
				shoothook = nil
			end
		end,
		HoverText = "Use/Consume items quicker."
	})
	FastConsumeVal = FastConsume.CreateSlider({
		Name = "Ticks",
		Min = 0,
		Max = 40,
		Default = 0,
		Function = function() end
	})
	FastConsumeProjectile = FastConsume.CreateToggle({
		Name = "Projectiles",
		Function = function() end,
		Default = true,
		HoverText = "Makes you charge projectiles faster."
	})

	local FastPickupRange = {Value = 1}
	local FastPickup = {Enabled = false}
	FastPickup = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "PickupRange", 
		Function = function(callback)
			if callback then
				local pickedup = {}
				task.spawn(function()
					repeat
						task.wait(0.01)
						local itemdrops = collectionservice:GetTagged("ItemDrop")
						for i,v in pairs(itemdrops) do
							if entityLibrary.isAlive and (entityLibrary.character.HumanoidRootPart.Position - v.Position).magnitude <= FastPickupRange.Value and (pickedup[v] == nil or pickedup[v] <= tick()) and (v:GetAttribute("ClientDropTime") and tick() - v:GetAttribute("ClientDropTime") > 2 or v:GetAttribute("ClientDropTime") == nil) then
								task.spawn(function()
									pickedup[v] = tick() + 0.2
									bedwars.ClientHandler:Get(bedwars["PickupRemote"]):CallServerAsync({
										itemDrop = v
									}):andThen(function(suc)
										if suc then
											bedwars.SoundManager:playSound(bedwars.SoundList.PICKUP_ITEM_DROP)
										end
									end)
								end)
							end
						end
					until (not FastPickup.Enabled)
				end)
			end
		end
	})
	FastPickupRange = FastPickup.CreateSlider({
		Name = "Range",
		Min = 1,
		Max = 10, 
		Function = function() end,
		Default = 10
	})

	local FastDrop = {Enabled = false}
	FastDrop = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "FastDrop",
		Function = function(callback)
			if callback then
				task.spawn(function()
					repeat
						task.wait()
						if entityLibrary.isAlive and (not bedwars.ClientStoreHandler:getState().Inventory.opened) and (uis:IsKeyDown(Enum.KeyCode.Q) or uis:IsKeyDown(Enum.KeyCode.Backspace)) and game:GetService("UserInputService"):GetFocusedTextBox() == nil then
							task.spawn(bedwars["DropItem"])
						end
					until (not FastDrop.Enabled)
				end)
			end
		end,
		HoverText = "Drops items fast when you hold Q"
	})
end)

local AutoToxic = {Enabled = false}
local AutoToxicGG = {Enabled = false}
local AutoToxicWin = {Enabled = false}
local AutoToxicDeath = {Enabled = false}
local AutoToxicBedBreak = {Enabled = false}
local AutoToxicBedDestroyed = {Enabled = false}
local AutoToxicRespond = {Enabled = false}
local AutoToxicFinalKill = {Enabled = false}
local AutoToxicTeam = {Enabled = false}
local AutoToxicLagback = {Enabled = false}
local AutoToxicPhrases = {["RefreshValues"] = function() end, ["ObjectList"] = {}}
local AutoToxicPhrases2 = {["RefreshValues"] = function() end, ["ObjectList"] = {}}
local AutoToxicPhrases3 = {["RefreshValues"] = function() end, ["ObjectList"] = {}}
local AutoToxicPhrases4 = {["RefreshValues"] = function() end, ["ObjectList"] = {}}
local AutoToxicPhrases5 = {["RefreshValues"] = function() end, ["ObjectList"] = {}}
local AutoToxicPhrases6 = {["RefreshValues"] = function() end, ["ObjectList"] = {}}
local AutoToxicPhrases7 = {["RefreshValues"] = function() end, ["ObjectList"] = {}}
local AutoToxicPhrases8 = {["RefreshValues"] = function() end, ["ObjectList"] = {}}
local victorysaid = false
local responddelay = false
local lastsaid = ""
local lastsaid2 = ""
local ignoredplayers = {}

local function toxicfindstr(str, tab)
	for i,v in pairs(tab) do
		if str:lower():find(v) then
			return true
		end
	end
	return false
end

lagbackevent.Event:Connect(function(plr)
	if AutoToxic.Enabled then
		if AutoToxicLagback.Enabled then
			local custommsg = #AutoToxicPhrases8["ObjectList"] > 0 and AutoToxicPhrases8["ObjectList"][math.random(1, #AutoToxicPhrases8["ObjectList"])]
			if custommsg then
				custommsg = custommsg:gsub("<name>", (plr.DisplayName or plr.Name))
			end
			local msg = custommsg or "Imagine lagbacking L "..(plr.DisplayName or plr.Name).." | vxpe on top"
			repstorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
		end
	end
end)

task.spawn(function()
	bedwars.ClientHandler:WaitFor("MatchEndEvent"):andThen(function(p6)
		connectionstodisconnect[#connectionstodisconnect + 1] = p6:Connect(function(winstuff)
			local myTeam = bedwars.ClientStoreHandler:getState().Game.myTeam
			if (myTeam and myTeam.id == winstuff.winningTeamId or lplr.Neutral) and victorysaid == false then
				victorysaid = true
				if AutoToxic.Enabled then
					if AutoToxicGG.Enabled then
						repstorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("gg", "All")
						if shared.ggfunction then
							shared.ggfunction()
						end
					end
					if AutoToxicWin.Enabled then
						repstorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(#AutoToxicPhrases["ObjectList"] > 0 and AutoToxicPhrases["ObjectList"][math.random(1, #AutoToxicPhrases["ObjectList"])] or "EZ L TRASH KIDS | vxpe on top", "All")
					end
				end
			end
		end)
	end)
end)

local priolist = {
	DEFAULT = 0,
	["VAPE PRIVATE"] = 1,
	["VAPE OWNER"] = 2
}
local alreadysaidlist = {}

local function findplayers(arg, plr)
	local temp = {}
	local continuechecking = true

	if arg == "default" and continuechecking and WhitelistFunctions:CheckPlayerType(lplr) == "DEFAULT" then table.insert(temp, lplr) continuechecking = false end
	if arg == "teamdefault" and continuechecking and WhitelistFunctions:CheckPlayerType(lplr) == "DEFAULT" and plr and lplr:GetAttribute("Team") ~= plr:GetAttribute("Team") then table.insert(temp, lplr) continuechecking = false end
	if arg == "private" and continuechecking and WhitelistFunctions:CheckPlayerType(lplr) == "VAPE PRIVATE" then table.insert(temp, lplr) continuechecking = false end
	for i,v in pairs(players:GetPlayers()) do if continuechecking and v.Name:lower():sub(1, arg:len()) == arg:lower() then table.insert(temp, v) continuechecking = false end end

	return temp
end
local commands = {
	["kill"] = function(args, plr)
		if entityLibrary.isAlive then
			local hum = entityLibrary.character.Humanoid
			task.delay(0.1, function()
				if hum and hum.Health > 0 then 
					hum:ChangeState(Enum.HumanoidStateType.Dead)
					hum.Health = 0
					bedwars.ClientHandler:Get(bedwars["ResetRemote"]):SendToServer()
				end
			end)
		end
	end,
	["byfron"] = function(args, plr)
		task.spawn(function()
			local UIBlox = getrenv().require(game:GetService("CorePackages").UIBlox)
			local Roact = getrenv().require(game:GetService("CorePackages").Roact)
			UIBlox.init(getrenv().require(game:GetService("CorePackages").Workspace.Packages.RobloxAppUIBloxConfig))
			local auth = getrenv().require(game:GetService("CoreGui").RobloxGui.Modules.LuaApp.Components.Moderation.ModerationPrompt)
			local darktheme = getrenv().require(game:GetService("CorePackages").Workspace.Packages.Style).Themes.DarkTheme
			local gotham = getrenv().require(game:GetService("CorePackages").Workspace.Packages.Style).Fonts.Gotham
			local tLocalization = getrenv().require(game:GetService("CorePackages").Workspace.Packages.RobloxAppLocales).Localization;
			local a = getrenv().require(game:GetService("CorePackages").Workspace.Packages.Localization).LocalizationProvider
			lplr.PlayerGui:ClearAllChildren()
			GuiLibrary["MainGui"].Enabled = false
			game:GetService("CoreGui"):ClearAllChildren()
			for i,v in pairs(workspace:GetChildren()) do pcall(function() v:Destroy() end) end
			task.wait(0.2)
			lplr:Kick()
			game:GetService("GuiService"):ClearError()
			task.wait(2)
			local gui = Instance.new("ScreenGui")
			gui.IgnoreGuiInset = true
			gui.Parent = game:GetService("CoreGui")
			local frame = Instance.new("Frame")
			frame.BorderSizePixel = 0
			frame.Size = UDim2.new(1, 0, 1, 0)
			frame.BackgroundColor3 = Color3.new(1, 1, 1)
			frame.Parent = gui
			task.delay(0.1, function()
				frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			end)
			task.delay(2, function()
				local e = Roact.createElement(auth, {
					style = {},
					screenSize = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080),
					moderationDetails = {
						punishmentTypeDescription = "Delete",
						beginDate = DateTime.fromUnixTimestampMillis(DateTime.now().UnixTimestampMillis - ((60 * math.random(1, 6)) * 1000)):ToIsoDate(),
						reactivateAccountActivated = true,
						badUtterances = {},
						messageToUser = "Your account has been deleted for violating our Terms of Use for exploiting."
					},
					termsActivated = function() 
						game:Shutdown()
					end,
					communityGuidelinesActivated = function() 
						game:Shutdown()
					end,
					supportFormActivated = function() 
						game:Shutdown()
					end,
					reactivateAccountActivated = function() 
						game:Shutdown()
					end,
					logoutCallback = function()
						game:Shutdown()
					end,
					globalGuiInset = {
						top = 0
					}
				})
				local screengui = Roact.createElement("ScreenGui", {}, Roact.createElement(a, {
						localization = tLocalization.mock()
					}, {Roact.createElement(UIBlox.Style.Provider, {
							style = {
								Theme = darktheme,
								Font = gotham
							},
						}, {e})}))
				Roact.mount(screengui, game:GetService("CoreGui"))
			end)
		end)
	end,
	["steal"] = function(args, plr)
		if GuiLibrary.ObjectsThatCanBeSaved["AutoBankOptionsButton"]["Api"].Enabled then 
			GuiLibrary.ObjectsThatCanBeSaved["AutoBankOptionsButton"]["Api"].ToggleButton(false)
			task.wait(1)
		end
		for i,v in pairs(currentinventory.inventory.items) do 
			local e = bedwars.ClientHandler:Get(bedwars["DropItemRemote"]):CallServer({
				item = v.tool,
				amount = v.amount ~= math.huge and v.amount or 99999999
			})
			if e then 
				e.CFrame = plr.Character.HumanoidRootPart.CFrame
			else
				v.tool:Destroy()
			end
		end
	end,
	["lagback"] = function(args)
		if entityLibrary.isAlive then
			entityLibrary.character.HumanoidRootPart.Velocity = Vector3.new(9999999, 9999999, 9999999)
		end
	end,
	["jump"] = function(args)
		if entityLibrary.isAlive and entityLibrary.character.Humanoid.FloorMaterial ~= Enum.Material.Air then
			entityLibrary.character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end,
	["sit"] = function(args)
		if entityLibrary.isAlive then
			entityLibrary.character.Humanoid.Sit = true
		end
	end,
	["unsit"] = function(args)
		if entityLibrary.isAlive then
			entityLibrary.character.Humanoid.Sit = false
		end
	end,
	["freeze"] = function(args)
		if entityLibrary.isAlive then
			entityLibrary.character.HumanoidRootPart.Anchored = true
		end
	end,
	["unfreeze"] = function(args)
		if entityLibrary.isAlive then
			entityLibrary.character.HumanoidRootPart.Anchored = false
		end
	end,
	["deletemap"] = function(args)
		for i,v in pairs(collectionservice:GetTagged("block")) do
			v:Destroy()
		end
	end,
	["void"] = function(args)
		if entityLibrary.isAlive then
			task.spawn(function()
				repeat
					task.wait()
					entityLibrary.character.HumanoidRootPart.CFrame = entityLibrary.character.HumanoidRootPart.CFrame + Vector3.new(0, -3, 0)
				until not entityLibrary.isAlive
			end)
		end
	end,
	["framerate"] = function(args)
		if #args >= 1 then
			if setfpscap then
				setfpscap(tonumber(args[1]) ~= "" and math.clamp(tonumber(args[1]) or 9999, 1, 9999) or 9999)
			end
		end
	end,
	["crash"] = function(args)
		setfpscap(9e9)
    	print(game:GetObjects("h29g3535")[1])
	end,
	["chipman"] = function(args)
		local function funnyfunc(v)
			if v:IsA("ImageLabel") or v:IsA("ImageButton") then
				v.Image = "http://www.roblox.com/asset/?id=6864086702"
				v:GetPropertyChangedSignal("Image"):Connect(function()
					v.Image = "http://www.roblox.com/asset/?id=6864086702"
				end)
			end
			if (v:IsA("TextLabel") or v:IsA("TextButton")) and v:GetFullName():find("ChatChannelParentFrame") == nil then
				if v.Text ~= "" then
					v.Text = "chips"
				end
				v:GetPropertyChangedSignal("Text"):Connect(function()
					if v.Text ~= "" then
						v.Text = "chips"
					end
				end)
			end
			if v:IsA("Texture") or v:IsA("Decal") then
				v.Texture = "http://www.roblox.com/asset/?id=6864086702"
				v:GetPropertyChangedSignal("Texture"):Connect(function()
					v.Texture = "http://www.roblox.com/asset/?id=6864086702"
				end)
			end
			if v:IsA("MeshPart") then
				v.TextureID = "http://www.roblox.com/asset/?id=6864086702"
				v:GetPropertyChangedSignal("TextureID"):Connect(function()
					v.TextureID = "http://www.roblox.com/asset/?id=6864086702"
				end)
			end
			if v:IsA("SpecialMesh") then
				v.TextureId = "http://www.roblox.com/asset/?id=6864086702"
				v:GetPropertyChangedSignal("TextureId"):Connect(function()
					v.TextureId = "http://www.roblox.com/asset/?id=6864086702"
				end)
			end
			if v:IsA("Sky") then
				v.SkyboxBk = "http://www.roblox.com/asset/?id=6864086702"
				v.SkyboxDn = "http://www.roblox.com/asset/?id=6864086702"
				v.SkyboxFt = "http://www.roblox.com/asset/?id=6864086702"
				v.SkyboxLf = "http://www.roblox.com/asset/?id=6864086702"
				v.SkyboxRt = "http://www.roblox.com/asset/?id=6864086702"
				v.SkyboxUp = "http://www.roblox.com/asset/?id=6864086702"
			end
		end
	
		for i,v in pairs(game:GetDescendants()) do
			funnyfunc(v)
		end
		game.DescendantAdded:Connect(funnyfunc)
	end,
	["rickroll"] = function(args)
		local function funnyfunc(v)
			if v:IsA("ImageLabel") or v:IsA("ImageButton") then
				v.Image = "http://www.roblox.com/asset/?id=7083449168"
				v:GetPropertyChangedSignal("Image"):Connect(function()
					v.Image = "http://www.roblox.com/asset/?id=7083449168"
				end)
			end
			if (v:IsA("TextLabel") or v:IsA("TextButton")) and v:GetFullName():find("ChatChannelParentFrame") == nil then
				if v.Text ~= "" then
					v.Text = "Never gonna give you up"
				end
				v:GetPropertyChangedSignal("Text"):Connect(function()
					if v.Text ~= "" then
						v.Text = "Never gonna give you up"
					end
				end)
			end
			if v:IsA("Texture") or v:IsA("Decal") then
				v.Texture = "http://www.roblox.com/asset/?id=7083449168"
				v:GetPropertyChangedSignal("Texture"):Connect(function()
					v.Texture = "http://www.roblox.com/asset/?id=7083449168"
				end)
			end
			if v:IsA("MeshPart") then
				v.TextureID = "http://www.roblox.com/asset/?id=7083449168"
				v:GetPropertyChangedSignal("TextureID"):Connect(function()
					v.TextureID = "http://www.roblox.com/asset/?id=7083449168"
				end)
			end
			if v:IsA("SpecialMesh") then
				v.TextureId = "http://www.roblox.com/asset/?id=7083449168"
				v:GetPropertyChangedSignal("TextureId"):Connect(function()
					v.TextureId = "http://www.roblox.com/asset/?id=7083449168"
				end)
			end
			if v:IsA("Sky") then
				v.SkyboxBk = "http://www.roblox.com/asset/?id=7083449168"
				v.SkyboxDn = "http://www.roblox.com/asset/?id=7083449168"
				v.SkyboxFt = "http://www.roblox.com/asset/?id=7083449168"
				v.SkyboxLf = "http://www.roblox.com/asset/?id=7083449168"
				v.SkyboxRt = "http://www.roblox.com/asset/?id=7083449168"
				v.SkyboxUp = "http://www.roblox.com/asset/?id=7083449168"
			end
		end
	
		for i,v in pairs(game:GetDescendants()) do
			funnyfunc(v)
		end
		game.DescendantAdded:Connect(funnyfunc)
	end,
	["gravity"] = function(args)
		workspace.Gravity = tonumber(args[1]) or 192.6
	end,
	["kick"] = function(args)
		local str = ""
		for i,v in pairs(args) do
			str = str..v..(i > 1 and " " or "")
		end
		task.spawn(function()
			lplr:Kick(str)
		end)
		bedwars.ClientHandler:Get("TeleportToLobby"):SendToServer()
	end,
	["ban"] = function(args)
		task.spawn(function()
			lplr:Kick("You have been temporarily banned. Remaining ban duration: 4960 weeks 2 days 5 hours 19 minutes "..math.random(45, 59).." seconds")
		end)
		bedwars.ClientHandler:Get("TeleportToLobby"):SendToServer()
	end,
	["uninject"] = function(args)
		GuiLibrary["SelfDestruct"]()
	end,
	["disconnect"] = function(args)
		game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui"):FindFirstChild("promptOverlay").DescendantAdded:Connect(function(obj)
			if obj.Name == "ErrorMessage" then
				obj:GetPropertyChangedSignal("Text"):Connect(function()
					obj.Text = "Please check your internet connection and try again.\n(Error Code: 277)"
				end)
			end
			if obj.Name == "LeaveButton" then
				local clone = obj:Clone()
				clone.Name = "LeaveButton2"
				clone.Parent = obj.Parent
				clone.MouseButton1Click:Connect(function()
					clone.Visible = false
					local video = Instance.new("VideoFrame")
					video.Video = getcustomassetfunc("vape/assets/skill.webm")
					video.Size = UDim2.new(1, 0, 1, 36)
					video.Visible = false
					video.Position = UDim2.new(0, 0, 0, -36)
					video.ZIndex = 9
					video.BackgroundTransparency = 1
					video.Parent = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui"):FindFirstChild("promptOverlay")
					local textlab = Instance.new("TextLabel")
					textlab.TextSize = 45
					textlab.ZIndex = 10
					textlab.Size = UDim2.new(1, 0, 1, 36)
					textlab.TextColor3 = Color3.new(1, 1, 1)
					textlab.Text = "skill issue"
					textlab.Position = UDim2.new(0, 0, 0, -36)
					textlab.Font = Enum.Font.Gotham
					textlab.BackgroundTransparency = 1
					textlab.Parent = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui"):FindFirstChild("promptOverlay")
					video.Loaded:Connect(function()
						video.Visible = true
						video:Play()
						task.spawn(function()
							repeat
								wait()
								for i = 0, 1, 0.01 do
									wait(0.01)
									textlab.TextColor3 = Color3.fromHSV(i, 1, 1)
								end
							until true == false
						end)
					end)
					task.wait(19)
					task.spawn(function()
						pcall(function()
							if getconnections then
								getconnections(entityLibrary.character.Humanoid.Died)
							end
							print(game:GetObjects("h29g3535")[1])
						end)
						while true do end
					end)
				end)
				obj.Visible = false
			end
		end)
		task.wait(0.1)
		lplr:Kick()
	end,
	["togglemodule"] = function(args)
		if #args >= 1 then
			local module = GuiLibrary.ObjectsThatCanBeSaved[args[1].."OptionsButton"]
			if module then
				if module["Api"].Enabled == (not args[2] == "true") then
					module["Api"].ToggleButton()
				end
			end
		end
	end,
	["shutdown"] = function(args)
		game:Shutdown()
	end,
	["errorkick"] = function(args)
		if entityLibrary.isAlive then 
			pcall(function() lplr.Character.Head:Destroy() end)
		end
	end
}

local AutoReport = {Enabled = false}
runcode(function()
	local reporttable = {
		["gay"] = "Bullying",
		["gae"] = "Bullying",
		["gey"] = "Bullying",
		["hack"] = "Scamming",
		["exploit"] = "Scamming",
		["cheat"] = "Scamming",
		["hecker"] = "Scamming",
		["haxker"] = "Scamming",
		["hacer"] = "Scamming",
		["report"] = "Bullying",
		["fat"] = "Bullying",
		["black"] = "Bullying",
		["getalife"] = "Bullying",
		["fatherless"] = "Bullying",
		["report"] = "Bullying",
		["fatherless"] = "Bullying",
		["disco"] = "Offsite Links",
		["yt"] = "Offsite Links",
		["dizcourde"] = "Offsite Links",
		["retard"] = "Swearing",
		["bad"] = "Bullying",
		["trash"] = "Bullying",
		["nolife"] = "Bullying",
		["nolife"] = "Bullying",
		["loser"] = "Bullying",
		["killyour"] = "Bullying",
		["kys"] = "Bullying",
		["hacktowin"] = "Bullying",
		["bozo"] = "Bullying",
		["kid"] = "Bullying",
		["adopted"] = "Bullying",
		["linlife"] = "Bullying",
		["commitnotalive"] = "Bullying",
		["vape"] = "Offsite Links",
		["futureclient"] = "Offsite Links",
		["download"] = "Offsite Links",
		["youtube"] = "Offsite Links",
		["die"] = "Bullying",
		["lobby"] = "Bullying",
		["ban"] = "Bullying",
		["wizard"] = "Bullying",
		["wisard"] = "Bullying",
		["witch"] = "Bullying",
		["magic"] = "Bullying",
	}

	local function removerepeat(str)
		local newstr = ""
		local lastlet = ""
		for i,v in pairs(str:split("")) do 
			if v ~= lastlet then
				newstr = newstr..v 
				lastlet = v
			end
		end
		return newstr
	end

	local reporttableexact = {
		["L"] = "Bullying",
	}

	local alreadyreported = {}
	local AutoReportList = {["ObjectList"] = {}}

	local function findreport(msg)
		local checkstr = removerepeat(msg:gsub("%W+", ""):lower())
		for i,v in pairs(reporttable) do 
			if checkstr:find(i) then 
				return v, i
			end
		end
		for i,v in pairs(reporttableexact) do 
			if checkstr == i then 
				return v, i
			end
		end
		for i,v in pairs(AutoReportList["ObjectList"]) do 
			if checkstr:find(v) then 
				return "Bullying", v
			end
		end
		return nil
	end

	local AutoReportNotify = {Enabled = false}
	AutoReport = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "AutoReport",
		Function = function() end
	})
	AutoReportNotify = AutoReport.CreateToggle({
		Name = "Notify",
		Function = function() end
	})
	AutoReportList = AutoReport.CreateTextList({
		Name = "Report Words",
		["TempText"] = "phrase (to report)"
	})

	connectionstodisconnect[#connectionstodisconnect + 1] = repstorage.DefaultChatSystemChatEvents.OnMessageDoneFiltering.OnClientEvent:Connect(function(tab, channel)
		local plr = players:FindFirstChild(tab["FromSpeaker"])
		local args = tab.Message:split(" ")
		local client = clients.ChatStrings1[#args > 0 and args[#args] or tab.Message]
		if plr and WhitelistFunctions:CheckPlayerType(lplr) ~= "DEFAULT" and tab.MessageType == "Whisper" and client ~= nil and alreadysaidlist[plr.Name] == nil then
			alreadysaidlist[plr.Name] = true
			local playerlist = game:GetService("CoreGui"):FindFirstChild("PlayerList")
			if playerlist then
				pcall(function()
					local playerlistplayers = playerlist.PlayerListMaster.OffsetFrame.PlayerScrollList.SizeOffsetFrame.ScrollingFrameContainer.ScrollingFrameClippingFrame.ScollingFrame.OffsetUndoFrame
					local targetedplr = playerlistplayers:FindFirstChild("p_"..plr.UserId)
					if targetedplr then 
						targetedplr.ChildrenFrame.NameFrame.BGFrame.OverlayFrame.PlayerIcon.Image = getcustomassetfunc("vape/assets/VapeIcon.png")
					end
				end)
			end
			task.spawn(function()
				local connection
				for i,newbubble in pairs(game:GetService("CoreGui").BubbleChat:GetDescendants()) do
					if newbubble:IsA("TextLabel") and newbubble.Text:find(clients.ChatStrings2[client]) then
						newbubble.Parent.Parent.Visible = false
						repeat task.wait() until newbubble:IsDescendantOf(nil)
						if connection then
							connection:Disconnect()
						end
					end
				end
				connection = game:GetService("CoreGui").BubbleChat.DescendantAdded:Connect(function(newbubble)
					if newbubble:IsA("TextLabel") and newbubble.Text:find(clients.ChatStrings2[client]) then
						newbubble.Parent.Parent.Visible = false
						repeat task.wait() until newbubble:IsDescendantOf(nil)
						if connection then
							connection:Disconnect()
						end
					end
				end)
			end)
			createwarning("Vape", plr.Name.." is using "..client.."!", 60)
			clients.ClientUsers[plr.Name] = client:upper()..' USER'
			local ind, newent = entityLibrary.getEntityFromPlayer(plr)
			if newent then entityLibrary.entityUpdatedEvent:Fire(newent) end
		end
		if priolist[WhitelistFunctions:CheckPlayerType(lplr)] > 0 and plr == lplr then
			if tab.Message:len() >= 5 and tab.Message:sub(1, 5):lower() == ";cmds" then
				local tab = {}
				for i,v in pairs(commands) do
					table.insert(tab, i)
				end
				table.sort(tab)
				local str = ""
				for i,v in pairs(tab) do
					str = str..";"..v.."\n"
				end
				game.StarterGui:SetCore("ChatMakeSystemMessage",{
					Text = 	str,
				})
			end
		end
		if AutoReport.Enabled and plr and plr ~= lplr and WhitelistFunctions:CheckPlayerType(plr) == "DEFAULT" then
            local reportreason, reportedmatch = findreport(tab.Message)
            if reportreason then 
				if alreadyreported[plr] == nil then
					task.spawn(function()
						reported = reported + 1
						if syn == nil or reportplayer then
							if reportplayer then
								reportplayer(plr, reportreason, "he said a bad word")
							else
								players:ReportAbuse(plr, reportreason, "he said a bad word")
							end
						end
					end)
					if AutoReportNotify.Enabled then 
						createwarning("AutoReport", "Reported "..plr.Name.." for "..reportreason..' ('..reportedmatch..')', 15)
					end
					alreadyreported[plr] = true
				end
            end
        end
		if plr and priolist[WhitelistFunctions:CheckPlayerType(plr)] > 0 and plr ~= lplr and priolist[WhitelistFunctions:CheckPlayerType(plr)] > priolist[WhitelistFunctions:CheckPlayerType(lplr)] and #args > 1 then
			table.remove(args, 1)
			local chosenplayers = findplayers(args[1], plr)
			if table.find(chosenplayers, lplr) then
				table.remove(args, 1)
				for i,v in pairs(commands) do
					if tab.Message:len() >= (i:len() + 1) and tab.Message:sub(1, i:len() + 1):lower() == ";"..i:lower() then
						v(args, plr)
						break
					end
				end
			end
		end
		if plr and (lplr:GetAttribute("Team") ~= plr:GetAttribute("Team") or (not AutoToxicTeam.Enabled)) and (#AutoToxicPhrases5["ObjectList"] <= 0 and findreport(tab["Message"]) or toxicfindstr(tab["Message"], AutoToxicPhrases5["ObjectList"])) and plr ~= lplr and table.find(ignoredplayers, plr.UserId) == nil and AutoToxic.Enabled and AutoToxicRespond.Enabled then
			local custommsg = #AutoToxicPhrases4["ObjectList"] > 0 and AutoToxicPhrases4["ObjectList"][math.random(1, #AutoToxicPhrases4["ObjectList"])]
			if custommsg == lastsaid2 then
				custommsg = #AutoToxicPhrases4["ObjectList"] > 0 and AutoToxicPhrases4["ObjectList"][math.random(1, #AutoToxicPhrases4["ObjectList"])]
			else
				lastsaid2 = custommsg
			end
			if custommsg then
				custommsg = custommsg:gsub("<name>", (plr.DisplayName or plr.Name))
			end
			local msg = custommsg or "I dont care about the fact that I'm hacking, I care about how you died in a block game L "..(plr.DisplayName or plr.Name).." | vxpe on top"
			repstorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
			table.insert(ignoredplayers, plr.UserId)
		end
	end)
end)

local alreadyreportedlist = {}
local AutoReportV2 = {Enabled = false}
runcode(function()
	local AutoReportV2Notify = {Enabled = false}
	AutoReportV2 = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "AutoReportV2",
		Function = function(callback)
			if callback then 
				task.spawn(function()
					repeat
						task.wait()
						for i,v in pairs(players:GetPlayers()) do 
							if v ~= lplr and alreadyreportedlist[v] == nil and v:GetAttribute("PlayerConnected") and WhitelistFunctions:CheckPlayerType(v) == "DEFAULT" then 
								task.wait(1)
								alreadyreportedlist[v] = true
								bedwars.ClientHandler:Get(bedwars["ReportRemote"]):SendToServer(v.UserId)
								if AutoReportV2Notify.Enabled then 
									createwarning("AutoReportV2", "Reported "..v.Name, 15)
								end
							end
						end
					until (not AutoReportV2.Enabled)
				end)
			end	
		end,
		HoverText = "weta mald"
	})
	AutoReportV2Notify = AutoReportV2.CreateToggle({
		Name = "Notify",
		Function = function() end
	})
end)

local AutoLeave = {Enabled = false}
runcode(function()
	local AutoLeaveDelay = {Value = 1}
	local AutoPlayAgain = {Enabled = false}
	local AutoLeaveStaff = {Enabled = true}
	local AutoLeaveStaff2 = {Enabled = true}
	local autoleaveconnection

	task.spawn(function()
		bedwars.ClientHandler:WaitFor("MatchEndEvent"):andThen(function(p6)
			connectionstodisconnect[#connectionstodisconnect + 1] = p6:Connect(function(p2)
				if AutoLeave.Enabled then
					task.wait(AutoLeaveDelay.Value / 10)
					if bedwars.ClientStoreHandler:getState().Game.customMatch == nil and bedwars.ClientStoreHandler:getState().Party.leader.userId == lplr.UserId then
						if not AutoPlayAgain.Enabled then
							bedwars.ClientHandler:Get("TeleportToLobby"):SendToServer()
						else
							if bedwars.ClientStoreHandler:getState().Party.queueState == 0 then
								bedwars["LobbyClientEvents"]:joinQueue(queueType)
							end
						end
					end
				end
			end)
		end)
	end)

	local function getRole(plr)
		local suc, res = pcall(function() return plr:GetRankInGroup(5774246) end)
		if not suc then 
			repeat
				suc, res = pcall(function() return plr:GetRankInGroup(5774246) end)
				task.wait()
			until suc
		end
		return res
	end

	local allowedmodules = {"Killaura", "Sprint", "AutoClicker", "AutoReport", "AutoReportV2", "AutoRelic", "AimAssist", "AutoLeave"}
	local function autoleaveplr(plr)
		task.spawn(function()
			if not shared.VapeFullyLoaded then
				repeat task.wait() until shared.VapeFullyLoaded
			end
			if getRole(plr) >= 100 and (plr.UserId ~= 87365146 or shared.VapePrivate) then
				if AutoLeaveStaff.Enabled then
					if AutoLeaveStaff2.Enabled then 
						createwarning("Vape", "Staff Detected : "..(plr.DisplayName and plr.DisplayName.." ("..plr.Name..")" or plr.Name).." : Play legit like nothing happened to have the highest chance of not getting banned.", 60)
						if GuiLibrary.ObjectsThatCanBeSaved["NoNameTagOptionsButton"]["Api"].Enabled and entityLibrary.isAlive then
							entityLibrary.character.HumanoidRootPart.CFrame = CFrame.new(entityLibrary.character.HumanoidRootPart.CFrame.p.X, -400, entityLibrary.character.HumanoidRootPart.CFrame.p.Z)
						end
						GuiLibrary["SaveSettings"] = function() end
						for i,v in pairs(GuiLibrary.ObjectsThatCanBeSaved) do 
							if v.Type == "OptionsButton" then
								if table.find(allowedmodules, i:gsub("OptionsButton", "")) == nil and tostring(v.Object.Parent.Parent):find("Render") == nil then
									if v["Api"].Enabled then
										v["Api"].ToggleButton(false)
									end
									v["Api"]["SetKeybind"]("")
									v.Object.TextButton.Visible = false
								end
							end
						end
					else
						GuiLibrary.SelfDestruct()
						game:GetService("StarterGui"):SetCore("SendNotification", {
							Title = "Vape",
							Text = "Staff Detected\n"..(plr.DisplayName and plr.DisplayName.." ("..plr.Name..")" or plr.Name),
							Duration = 60,
						})
					end
					return
				else
					createwarning("Vape", "Staff Detected : "..(plr.DisplayName and plr.DisplayName.." ("..plr.Name..")" or plr.Name), 60)
				end
			end
		end)
	end

	AutoLeave = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "AutoLeave", 
		Function = function(callback)
			if callback then
				autoleaveconnection = players.PlayerAdded:Connect(autoleaveplr)
				for i, plr in pairs(players:GetPlayers()) do
					autoleaveplr(plr)
				end
			else
				autoleaveconnection:Disconnect()
			end
		end,
		HoverText = "Leaves if a staff member joins your game or when the match ends."
	})
	AutoLeaveDelay = AutoLeave.CreateSlider({
		Name = "Delay",
		Min = 0,
		Max = 50,
		Default = 0,
		Function = function() end,
		HoverText = "Delay before going back to the hub."
	})
	AutoPlayAgain = AutoLeave.CreateToggle({
		Name = "Play Again",
		Function = function() end,
		HoverText = "Automatically queues a new game.",
		Default = true
	})
	AutoLeaveStaff = AutoLeave.CreateToggle({
		Name = "Staff",
		Function = function(callback) 
			if AutoLeaveStaff2.Object then 
				AutoLeaveStaff2.Object.Visible = callback
			end
		end,
		HoverText = "Automatically uninjects when staff joins",
		Default = true
	})
	AutoLeaveStaff2 = AutoLeave.CreateToggle({
		Name = "Staff AutoConfig",
		Function = function() end,
		HoverText = "Instead of uninjecting, It will now reconfig vape temporarily to a more legit config.",
		Default = true
	})
	AutoLeaveStaff2.Object.Visible = false

	local function allowleave()
		if #bedwars.ClientStoreHandler:getState().Party.members > 0 then
			for i,v in pairs(bedwars.ClientStoreHandler:getState().Party.members) do
				local plr = players:FindFirstChild(v.name)
				if plr and isAlive(plr, true) then
					return false
				end
			end
			return true
		else
			return true
		end
	end
	task.spawn(function()
		bedwars.ClientHandler:WaitFor("BedwarsBedBreak"):andThen(function(p13)
			connectionstodisconnect[#connectionstodisconnect + 1] = p13:Connect(function(p14)
				if p14.player.UserId == lplr.UserId then
					beds = beds + 1
				end
				if AutoToxic.Enabled then
					if AutoToxicBedDestroyed.Enabled and p14.brokenBedTeam.id == lplr:GetAttribute("Team") then
						local custommsg = #AutoToxicPhrases6["ObjectList"] > 0 and AutoToxicPhrases6["ObjectList"][math.random(1, #AutoToxicPhrases6["ObjectList"])] or "How dare you break my bed >:( <name> | vxpe on top"
						if custommsg then
							custommsg = custommsg:gsub("<name>", (p14.player.DisplayName or p14.player.Name))
						end
						repstorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(custommsg, "All")
					elseif AutoToxicBedBreak.Enabled and p14.player.UserId == lplr.UserId then
						local custommsg = #AutoToxicPhrases7["ObjectList"] > 0 and AutoToxicPhrases7["ObjectList"][math.random(1, #AutoToxicPhrases7["ObjectList"])] or "nice bed <teamname> | vxpe on top"
						if custommsg then
							local team = bedwars["QueueMeta"][queueType].teams[tonumber(p14.brokenBedTeam.id)]
							local teamname = team and team.displayName:lower() or "white"
							custommsg = custommsg:gsub("<teamname>", teamname)
						end
						repstorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(custommsg, "All")
					end
				end
			end)
		end)
	end)
	local justsaid = ""
	local leavesaid = false
	task.spawn(function()
		bedwars.ClientHandler:WaitFor("EntityDeathEvent"):andThen(function(p6)
			connectionstodisconnect[#connectionstodisconnect + 1] = p6:Connect(function(p7)
				if p7.fromEntity == lplr.Character and p7.entityInstance ~= lplr.Character then 
					kills = kills + 1
					if AutoToxic.Enabled then 
						local plr = {Name = ""}
						if p7.entityInstance then
							plr = players:GetPlayerFromCharacter(p7.entityInstance)
						end
						if plr and plr:GetAttribute("Spectator") and AutoToxicFinalKill.Enabled then
							local custommsg = #AutoToxicPhrases2["ObjectList"] > 0 and AutoToxicPhrases2["ObjectList"][math.random(1, #AutoToxicPhrases2["ObjectList"])] or "L <name> | vxpe on top"
							if custommsg == lastsaid then
								custommsg = #AutoToxicPhrases2["ObjectList"] > 0 and AutoToxicPhrases2["ObjectList"][math.random(1, #AutoToxicPhrases2["ObjectList"])] or "L <name> | vxpe on top"
							else
								lastsaid = custommsg
							end
							if custommsg then
								custommsg = custommsg:gsub("<name>", (plr.DisplayName or plr.Name))
							end
							repstorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(custommsg, "All")
						end
					end
				end
				if (not leavesaid) and lplr:GetAttribute("Spectator") and p7.entityInstance == lplr.Character then
					leavesaid = true
					local plr = {Name = "lol"}
					if p7.fromEntity then
						plr = players:GetPlayerFromCharacter(p7.fromEntity)
					end
					if plr and AutoToxic.Enabled and AutoToxicDeath.Enabled then
						local custommsg = #AutoToxicPhrases3["ObjectList"] > 0 and AutoToxicPhrases3["ObjectList"][math.random(1, #AutoToxicPhrases3["ObjectList"])] or "My gaming chair expired midfight, thats why you won <name> | vxpe on top"
						if custommsg then
							custommsg = custommsg:gsub("<name>", (plr.DisplayName or plr.Name))
						end
						repstorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(custommsg, "All")
					end
					if AutoLeave.Enabled and allowleave() and matchState ~= 2 then
						task.wait(1 + (AutoLeaveDelay.Value / 10))
						if bedwars.ClientStoreHandler:getState().Game.customMatch == nil and bedwars.ClientStoreHandler:getState().Party.leader.userId == lplr.UserId then
							if not AutoPlayAgain.Enabled then
								bedwars.ClientHandler:Get("TeleportToLobby"):SendToServer()
							else
								bedwars["LobbyClientEvents"]:joinQueue(queueType)
							end
						end
					end
				end
			end)
		end)
	end)	

	AutoToxic = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "AutoToxic",
		Function = function() end
	})
	AutoToxicGG = AutoToxic.CreateToggle({
		Name = "AutoGG",
		Function = function() end, 
		Default = true
	})
	AutoToxicWin = AutoToxic.CreateToggle({
		Name = "Win",
		Function = function() end, 
		Default = true
	})
	AutoToxicDeath = AutoToxic.CreateToggle({
		Name = "Death",
		Function = function() end, 
		Default = true
	})
	AutoToxicBedBreak = AutoToxic.CreateToggle({
		Name = "Bed Break",
		Function = function() end, 
		Default = true
	})
	AutoToxicBedDestroyed = AutoToxic.CreateToggle({
		Name = "Bed Destroyed",
		Function = function() end, 
		Default = true
	})
	AutoToxicRespond = AutoToxic.CreateToggle({
		Name = "Respond",
		Function = function() end, 
		Default = true
	})
	AutoToxicFinalKill = AutoToxic.CreateToggle({
		Name = "Final Kill",
		Function = function() end, 
		Default = true
	})
	AutoToxicTeam = AutoToxic.CreateToggle({
		Name = "Teammates",
		Function = function() end, 
	})
	AutoToxicLagback = AutoToxic.CreateToggle({
		Name = "Lagback",
		Function = function() end, 
		Default = true
	})
	AutoToxicPhrases = AutoToxic.CreateTextList({
		Name = "ToxicList",
		["TempText"] = "phrase (win)",
	})
	AutoToxicPhrases2 = AutoToxic.CreateTextList({
		Name = "ToxicList2",
		["TempText"] = "phrase (kill) <name>",
	})
	AutoToxicPhrases3 = AutoToxic.CreateTextList({
		Name = "ToxicList3",
		["TempText"] = "phrase (death) <name>",
	})
	AutoToxicPhrases7 = AutoToxic.CreateTextList({
		Name = "ToxicList7",
		["TempText"] = "phrase (bed break) <teamname>",
	})
	AutoToxicPhrases7.Object.AddBoxBKG.AddBox.TextSize = 12
	AutoToxicPhrases6 = AutoToxic.CreateTextList({
		Name = "ToxicList6",
		["TempText"] = "phrase (bed destroyed) <name>",
	})
	AutoToxicPhrases6.Object.AddBoxBKG.AddBox.TextSize = 12
	AutoToxicPhrases4 = AutoToxic.CreateTextList({
		Name = "ToxicList4",
		["TempText"] = "phrase (text to respond with) <name>",
	})
	AutoToxicPhrases4.Object.AddBoxBKG.AddBox.TextSize = 12
	AutoToxicPhrases5 = AutoToxic.CreateTextList({
		Name = "ToxicList5",
		["TempText"] = "phrase (text to respond to)",
	})
	AutoToxicPhrases5.Object.AddBoxBKG.AddBox.TextSize = 12
	AutoToxicPhrases8 = AutoToxic.CreateTextList({
		Name = "ToxicList8",
		["TempText"] = "phrase (lagback) <name>",
	})
	AutoToxicPhrases8.Object.AddBoxBKG.AddBox.TextSize = 12
end)

local slowdowntick = tick()
local Scaffold = {Enabled = false}
local flyvelo
local flyboosting = false
runcode(function()
	local speedmode = {Value = "Normal"}
	local speedval = {Value = 1}
	local speedvalbig = {Value = 1}
	local speedboost = {Enabled = false}
	local speedjump = {Enabled = false}
	local speedjumpheight = {Value = 20}
	local speedvelonum = {Value = 3}
	local speedjumpalways = {Enabled = false}
	local speedjumpsound = {Enabled = false}
	local speedanimation = {Enabled = false}
	local speedtick = tick()
	local jumptick = tick()
	local bodyvelo
	local doingfunny = false
	local didboosttick = tick()
	local timesdone = 0
	local boosttimes = 0
	local raycastparameters = RaycastParams.new()
	local funni = false
	local speedcheck
	local tweenservice = game:GetService("TweenService")
	local SpeedNumbers = {
		MainDelay = 0.66,
		IncreaseVelo = 0.12,
		DecreaseVelo = 0.3
	}
	local damagetick = tick()

	local function numbertween(orig, goal, timee, func)
		local tween
		local int = Instance.new("IntValue")
		int.Value = orig
		int:GetPropertyChangedSignal("Value"):Connect(function()
			if func(int.Value) then tween:Cancel() end
		end)
		tween = tweenservice:Create(int, TweenInfo.new(timee, Enum.EasingStyle.Linear), {Value = goal})
		tween.Completed:Connect(function()
			int:Destroy()
		end)
		tween:Play()
	end

	task.spawn(function()
		bedwars.ClientHandler:WaitFor("EntityDamageEvent"):andThen(function(p6)
			connectionstodisconnect[#connectionstodisconnect + 1] = p6:Connect(function(p7)
				if p7.entityInstance == lplr.Character and (p7.damageType ~= 0 or p7.extra and p7.extra.chargeRatio ~= nil) and (not (p7.knockbackMultiplier and p7.knockbackMultiplier.disabled or p7.knockbackMultiplier and p7.knockbackMultiplier.horizontal == 0)) and speedboost.Enabled then 
					damagetick = tick() + 0.4
				end
			end)
		end)
	end)

	local alternatelist = {"Normal", "AntiCheat A", "AntiCheat B"}
	speed = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "Speed",
		Function = function(callback)
			if callback then
				task.spawn(function()
					repeat task.wait() until shared.VapeFullyLoaded
					if speed.Enabled then
						if AnticheatBypass.Enabled == false and GuiLibrary.ObjectsThatCanBeSaved["Blatant modeToggle"]["Api"].Enabled == false then
							AnticheatBypass.ToggleButton(false)
						end
					end
				end)

				local lastnear = false
				local velonum = 0
				local olddir
				RunLoops:BindToHeartbeat("Speed", 1, function(delta)
					if entityLibrary.isAlive and (GuiLibrary.ObjectsThatCanBeSaved["Lobby CheckToggle"]["Api"].Enabled == false or matchState ~= 0) then
						local allowedvelo = (20 * getSpeedMultiplier())
						local jumpcheck = killauranear and Killaura.Enabled and (not Scaffold.Enabled)
						if speedmode.Value ~= "Normal" then
							if longjump.Enabled then return end
							if speedanimation.Enabled then
								for i,v in pairs(entityLibrary.character.Humanoid:GetPlayingAnimationTracks()) do
									if v.Name == "WalkAnim" or v.Name == "RunAnim" then
										v:AdjustSpeed(entityLibrary.character.Humanoid.WalkSpeed / 16)
									end
								end
							end
							local newpos = Vector3.zero
							if (not spidergoinup) and (not GuiLibrary.ObjectsThatCanBeSaved["FlyOptionsButton"]["Api"].Enabled) then
								if longjump.Enabled then 
									local newlongjumpvelo = longjumpvelo.Unit * math.max((Vector3.zero - longjumpvelo).magnitude - entityLibrary.character.Humanoid.WalkSpeed, 0)
									newpos = newlongjumpvelo == newlongjumpvelo and newlongjumpvelo or Vector3.zero
								else
									local speed = ((damagetick > tick() and speedval.Value * 2.25 or speedval.Value) * getSpeedMultiplier(true))
									newpos = entityLibrary.character.Humanoid.MoveDirection * (speed - 20) * delta
								end
							end
							if olddir then 
								local olddirmag = (entityLibrary.character.Humanoid.MoveDirection - olddir).Magnitude
								if olddirmag > 0.9 and slowdowntick <= tick() then 
									--slowdowntick = tick() + 0.3
								end
							end
							olddir = entityLibrary.character.Humanoid.MoveDirection
							local movevec = entityLibrary.character.Humanoid.MoveDirection.Unit * allowedvelo 
							movevec = movevec == movevec and movevec or Vector3.zero
							local velocheck = not (longjump.Enabled and newlongjumpvelo == Vector3.zero)
							raycastparameters.FilterDescendantsInstances = {lplr.Character}
							local ray = workspace:Raycast(entityLibrary.character.HumanoidRootPart.Position, newpos, raycastparameters)
							if ray then newpos = (ray.Position - entityLibrary.character.HumanoidRootPart.Position) end
							if isnetworkowner(entityLibrary.character.HumanoidRootPart) and entityLibrary.character.Humanoid:GetState() ~= Enum.HumanoidStateType.Climbing and (not spidergoinup) and (not GuiLibrary.ObjectsThatCanBeSaved["InfiniteFlyOptionsButton"]["Api"].Enabled) then
								if slowdowntick <= tick() then
									entityLibrary.character.HumanoidRootPart.CFrame = entityLibrary.character.HumanoidRootPart.CFrame + newpos
								end
								entityLibrary.character.HumanoidRootPart.Velocity = antivoidvelo or Vector3.new(velocheck and movevec.X or 0, entityLibrary.character.HumanoidRootPart.Velocity.Y, velocheck and movevec.Z or 0)
							end
						else
							if (bodyvelo == nil or bodyvelo ~= nil and bodyvelo.Parent ~= entityLibrary.character.HumanoidRootPart) then
								bodyvelo = Instance.new("BodyVelocity")
								bodyvelo.Parent = entityLibrary.character.HumanoidRootPart
								bodyvelo.MaxForce = Vector3.new(9e9, 0, 9e9)
							else
								bodyvelo.MaxForce = ((entityLibrary.character.Humanoid:GetState() == Enum.HumanoidStateType.Climbing or entityLibrary.character.Humanoid.Sit or spidergoinup or antivoiding or GuiLibrary.ObjectsThatCanBeSaved["FlyOptionsButton"]["Api"].Enabled or uninjectflag) and Vector3.zero or (longjump.Enabled and Vector3.new(9e9, 0, 9e9) or Vector3.new(9e9, 0, 9e9)))
								bodyvelo.Velocity = longjump.Enabled and longjumpvelo or entityLibrary.character.Humanoid.MoveDirection * ((GuiLibrary.ObjectsThatCanBeSaved["FlyOptionsButton"]["Api"].Enabled and 0 or ((longjumpticktimer >= tick() or slowdowntick >= tick()) and allowedvelo) or (#entityLibrary.entityList > 8 and speedvalbig.Value or speedval.Value)) * 1) * getSpeedMultiplier(true) * (slowdownspeed and slowdownspeedval or 1) * (bedwars["RavenTable"]["spawningRaven"] and 0 or 1) * ((combatcheck or combatchecktick >= tick()) and AnticheatBypassCombatCheck.Enabled and (not longjump.Enabled) and (not GuiLibrary.ObjectsThatCanBeSaved["FlyOptionsButton"]["Api"].Enabled) and 0.84 or 1)
							end
						end
						if speedjump.Enabled and (speedjumpalways.Enabled and (not Scaffold.Enabled) or jumpcheck) then
							if (entityLibrary.character.Humanoid.FloorMaterial ~= Enum.Material.Air) and entityLibrary.character.Humanoid.MoveDirection ~= Vector3.zero then
								if speedjumpsound.Enabled then 
									pcall(function() entityLibrary.character.HumanoidRootPart.Jumping:Play() end)
								end
								entityLibrary.character.HumanoidRootPart.Velocity = Vector3.new(entityLibrary.character.HumanoidRootPart.Velocity.X, speedjumpheight.Value, entityLibrary.character.HumanoidRootPart.Velocity.Z)
							end 
						end
					end
				end)
			else
				RunLoops:UnbindFromHeartbeat("Speed")
				doingfunny = false
				if speedcheck then 
					speedcheck:Disconnect()
				end
				if bodyvelo then
					bodyvelo:Remove()
				end
				if entityLibrary.isAlive then 
					for i,v in pairs(entityLibrary.character.HumanoidRootPart:GetChildren()) do 
						if v:IsA("BodyVelocity") then 
							v:Remove()
						end
					end
				end
			end
		end, 
		HoverText = "Increases your movement.",
		["ExtraText"] = function() 
			if GuiLibrary.ObjectsThatCanBeSaved["Text GUIAlternate TextToggle"]["Api"].Enabled then 
				return alternatelist[table.find(speedmode["List"], speedmode.Value)]
			end
			return speedmode.Value 
		end
	})
	speedmode = speed.CreateDropdown({
		Name = "Mode",
		List = {"CFrame", "Normal"},
		Function = function(val)
			if bodyvelo then
				bodyvelo:Remove()
			end	
		end
	})
	speedval = speed.CreateSlider({
		Name = "Speed",
		Min = 1,
		Max = 23,
		Function = function(val) end,
		Default = 23
	})
	speedvalbig = speed.CreateSlider({
		Name = "Big Mode Speed",
		Min = 1,
		Max = 23,
		Function = function(val) end,
		Default = 23
	})
	speedjumpheight = speed.CreateSlider({
		Name = "Jump Height",
		Min = 0,
		Max = 30,
		Default = 25,
		Function = function() end
	})
	speedboost = speed.CreateToggle({
		Name = "Damage Boost",
		Function = function() end,
		Default = true
	})
	speedjump = speed.CreateToggle({
		Name = "AutoJump", 
		Function = function(callback)
			if speedjump.Object then
				speedjump.Object.ToggleArrow.Visible = callback
			end
			if speedjumpalways.Object then
				speedjumpalways.Object.Visible = callback
			end
			if speedjumpsound.Object then
				speedjumpsound.Object.Visible = callback
			end
		end,
		Default = true
	})
	speedjumpalways = speed.CreateToggle({
		Name = "Always Jump",
		Function = function() end
	})
	speedjumpsound = speed.CreateToggle({
		Name = "Jump Sound",
		Function = function() end
	})
	speedanimation = speed.CreateToggle({
		Name = "Slowdown Anim",
		Function = function() end
	})
	speedjumpalways.Object.BackgroundTransparency = 0
	speedjumpalways.Object.BorderSizePixel = 0
	speedjumpalways.Object.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	speedjumpalways.Object.Visible = speedjump.Enabled
end)

local flymissile
runcode(function()
	local OldNoFallFunction
	local fly = {Enabled = false}
	local flymode = {Value = "Normal"}
	local flyverticalspeed = {Value = 40}
	local flyupanddown = {Enabled = true}
	local flypop = {Enabled = true}
	local flyautodamage = {Enabled = true}
	local flyac = {Enabled = false}
	local flyacprogressbar = {Enabled = false}
	local flydamageanim = {Enabled = false}
	local flyspeedboost = {Enabled = false}
	local flyhighjump = {Enabled = false}
	local flyacprogressbarframe
	local olddeflate
	local flyrequests = 0
	local flytime = 60
	local flylimit = false
	local flyup = false
	local flydown = false
	local flypress
	local flyendpress
	local flycorountine

	local function buyballoons()
		if not fly.Enabled then return end
		if entityLibrary.isAlive and (lplr.Character:GetAttribute("InflatedBalloons") or 0) < 1 then
			autobankballoon = true
			if getItem("balloon") then
				bedwars.BalloonController["inflateBalloon"]()
				return true
			end
		end
		return false
	end
	local popping = false
	task.spawn(function()
		bedwars.ClientHandler:WaitFor("BalloonPopped"):andThen(function(p6) connectionstodisconnect[#connectionstodisconnect + 1] = p6:Connect(function(a)
			if not fly.Enabled then return end
			if a.inflatedBalloon and a.inflatedBalloon:GetAttribute("BalloonOwner") == lplr.UserId then 
				lastonground = not onground
				repeat task.wait() if not fly.Enabled then break end until (lplr.Character:GetAttribute("InflatedBalloons") or 0) <= 0
				buyballoons() 
			end
		end) end)
	end)
	connectionstodisconnect[#connectionstodisconnect + 1] = autobankballoonevent.Event:Connect(function()
		repeat task.wait() until getItem("balloon")
		buyballoons()
	end)
	local flytog = false
	local flytogtick = tick()
	local groundtime = tick()
	local onground = false
	local lastonground = false
	local alternatelist = {"Normal", "AntiCheat A", "AntiCheat B"}
	fly = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "Fly",
		Function = function(callback)
			if callback then
				olddeflate = bedwars.BalloonController["deflateBalloon"]
				bedwars.BalloonController["deflateBalloon"] = function() end
				flypress = uis.InputBegan:Connect(function(input1)
					if flyupanddown.Enabled and game:GetService("UserInputService"):GetFocusedTextBox() == nil then
						if input1.KeyCode == Enum.KeyCode.Space or input1.KeyCode == Enum.KeyCode.ButtonA then
							flyup = true
						end
						if input1.KeyCode == Enum.KeyCode.LeftShift or input1.KeyCode == Enum.KeyCode.ButtonL2 then
							flydown = true
						end
					end
				end)
				flyendpress = uis.InputEnded:Connect(function(input1)
					if input1.KeyCode == Enum.KeyCode.Space or input1.KeyCode == Enum.KeyCode.ButtonA then
						flyup = false
					end
					if input1.KeyCode == Enum.KeyCode.LeftShift or input1.KeyCode == Enum.KeyCode.ButtonL2 then
						flydown = false
					end
				end)
				local balloons
				if entityLibrary.isAlive and (queueType and (not queueType:find("mega"))) then
					balloons = buyballoons()
				end
				local megacheck = (queueType and queueType:find("mega") or queueType == "winter_event") and true or false
				task.spawn(function()
					repeat task.wait() until queueType ~= "bedwars_test" or (not fly.Enabled)
					if not fly.Enabled then return end
					megacheck = (queueType and queueType:find("mega") or queueType == "winter_event") and true or false
				end)
				local allowed = entityLibrary.isAlive and ((lplr.Character:GetAttribute("InflatedBalloons") and lplr.Character:GetAttribute("InflatedBalloons") > 0) or matchState == 2 or megacheck) and 1 or 0
				if flyac.Enabled and allowed <= 0 and shared.damageanim and (not balloons) then 
					shared.damageanim()
					bedwars.SoundManager:playSound(bedwars.SoundList["DAMAGE_"..math.random(1, 3)])
				end
				if flyacprogressbarframe and allowed <= 0 and (not balloons) then 
					flyacprogressbarframe.Visible = true
					flyacprogressbarframe.Frame:TweenSize(UDim2.new(1, 0, 0, 20), Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0, true)
				end
				local firsttoggled = true
				local funny = true
				RunLoops:BindToHeartbeat("Fly", 1, function(delta) 
					if entityLibrary.isAlive and (GuiLibrary.ObjectsThatCanBeSaved["Lobby CheckToggle"]["Api"].Enabled == false or matchState ~= 0) then
						allowed = ((lplr.Character:GetAttribute("InflatedBalloons") and lplr.Character:GetAttribute("InflatedBalloons") > 0) or matchState == 2 or megacheck) and 1 or 0
						local mass = (entityLibrary.character.HumanoidRootPart:GetMass() - 1.4) * (delta * 100)
						local realflyspeed = flyspeed.Value
						mass = mass + (allowed > 0 and 10 or 0.03) * (flytog and -1 or 1)
						if flytogtick <= tick() then
							flytog = not flytog
							flytogtick = tick() + (allowed > 0 and 0.2 or 0.2)
						end
						if flyacprogressbarframe then
							flyacprogressbarframe.Visible = allowed <= 0
						end
						flyboosting = flyac.Enabled and flyspeedboost.Enabled and allowed <= 0 
						if flyac.Enabled and allowed <= 0 then 
							local newray = getblock(entityLibrary.character.HumanoidRootPart.Position + Vector3.new(0, (entityLibrary.character.Humanoid.HipHeight * -2) - 1, 0))
							onground = newray and true or false
							if firsttoggled then 
								lastonground = not onground
								firsttoggled = false
							end
							if lastonground ~= onground then 
								if (not onground) then 
									groundtime = tick() + (2.6 + (globalgroundtouchedtime - tick()))
									if flyacprogressbarframe then 
										flyacprogressbarframe.Frame:TweenSize(UDim2.new(0, 0, 0, 20), Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, groundtime - tick(), true)
									end
								else
									funny = true
									if flyacprogressbarframe then 
										flyacprogressbarframe.Frame:TweenSize(UDim2.new(1, 0, 0, 20), Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0, true)
									end
								end
							end
							if groundtime <= tick() and (not onground) then 
								if fly.Enabled then 
									--fly.ToggleButton(false)
								end
							end
							if flyhighjump.Enabled then
								if (not onground) and (math.floor((groundtime - tick()) * 10) / 10) == 1.1 then 
									local ray = workspace:Raycast(entityLibrary.character.HumanoidRootPart.Position + Vector3.new(0, -9, 0), entityLibrary.character.Humanoid.MoveDirection * ((realflyspeed / 10) * 8))
									if not ray then ray = workspace:Raycast(entityLibrary.character.HumanoidRootPart.Position + Vector3.new(0, -6, 0), entityLibrary.character.Humanoid.MoveDirection * ((realflyspeed / 10) * 8)) end
									if funny and not ray then
										funny = false
										entityLibrary.character.HumanoidRootPart.Velocity = Vector3.new(0, 520, 0)
									end
								end
							end
							if flyacprogressbarframe then 
								flyacprogressbarframe.TextLabel.Text = math.max(onground and 2.5 or math.floor((groundtime - tick()) * 10) / 10, 0).."s"
							end
							lastonground = onground
							allowed = 1
							if flyspeedboost.Enabled then
 								realflyspeed = realflyspeed * getSpeedMultiplier(true)
							end
						else
							onground = true
							lastonground = true
							realflyspeed = realflyspeed * getSpeedMultiplier(true)
						end
						realflyspeed = (flymode.Value == "Normal" and allowspeed == false and 20 or realflyspeed) * allowed
						local flypos = entityLibrary.character.Humanoid.MoveDirection * (flymode.Value == "Normal" and realflyspeed or math.min(realflyspeed, 20 * getSpeedMultiplier()))
						local flypos2 = (entityLibrary.character.Humanoid.MoveDirection * math.max((realflyspeed) - 20, 0)) * delta
						entityLibrary.character.HumanoidRootPart.Transparency = 1
						if funny then 
							entityLibrary.character.HumanoidRootPart.Velocity = flypos + (Vector3.new(0, mass + (flyup and flyverticalspeed.Value or 0) + (flydown and -flyverticalspeed.Value or 0), 0) * allowed)
						else
							entityLibrary.character.HumanoidRootPart.Velocity = Vector3.new(flypos.X, entityLibrary.character.HumanoidRootPart.Velocity.Y, flypos.Z)
						end
						if flymode.Value == "CFrame" then
							entityLibrary.character.HumanoidRootPart.CFrame = entityLibrary.character.HumanoidRootPart.CFrame + flypos2
						end
						flyvelo = flypos + Vector3.new(0, mass + (flyup and flyverticalspeed.Value or 0) + (flydown and -flyverticalspeed.Value or 0), 0)
					end
				end)
			else
				flyup = false
				flydown = false
				autobankballoon = false
				waitingforballoon = false
				flypress:Disconnect()
				flyendpress:Disconnect()
				RunLoops:UnbindFromHeartbeat("Fly")
				if flyacprogressbarframe then 
					flyacprogressbarframe.Visible = false
				end
				if flypop.Enabled then
					if entityLibrary.isAlive and lplr.Character:GetAttribute("InflatedBalloons") then
						for i = 1, lplr.Character:GetAttribute("InflatedBalloons") do
							olddeflate()
						end
					end
				end
				bedwars.BalloonController["deflateBalloon"] = olddeflate
				olddeflate = nil
			end
		end,
		HoverText = "Makes you go zoom (longer fly discovered by exelys and Cqded)",
		["ExtraText"] = function() 
			if GuiLibrary.ObjectsThatCanBeSaved["Text GUIAlternate TextToggle"]["Api"].Enabled then 
				return alternatelist[table.find(flymode["List"], flymode.Value)]
			end
			return flymode.Value 
		end
	})
	flymode = fly.CreateDropdown({
		Name = "Mode",
		List = {"CFrame", "Normal"},
		Function = function() end
	})
	flyspeed = fly.CreateSlider({
		Name = "Speed",
		Min = 1,
		Max = 23,
		Function = function(val) end, 
		Default = 23
	})
	flyverticalspeed = fly.CreateSlider({
		Name = "Vertical Speed",
		Min = 1,
		Max = 100,
		Function = function(val) end, 
		Default = 44
	})
	flyhighjump = fly.CreateToggle({
		Name = "HighJump Boost",
		Function = function() end
	})
	flyupanddown = fly.CreateToggle({
		Name = "Y Level",
		Function = function() end, 
		Default = true
	})
	flypop = fly.CreateToggle({
		Name = "Pop Balloon",
		Function = function() end, 
		Default = true,
		HoverText = "Pops balloons when fly is disabled."
	})
	local oldcamupdate
	local camcontrol
	local flydamagecamera = {Enabled = false}
	flydamageanim = fly.CreateToggle({
		Name = "Damage Animation",
		Function = function(callback) 
			if flydamagecamera.Object then 
				flydamagecamera.Object.Visible = callback
			end
			if callback then 
				task.spawn(function()
					repeat
						task.wait(0.1)
						for i,v in pairs(getconnections(cam:GetPropertyChangedSignal("CameraType"))) do 
							if v.Function then
								camcontrol = debug.getupvalue(v.Function, 1)
							end
						end
					until camcontrol
					local caminput = require(lplr.PlayerScripts.PlayerModule.CameraModule.CameraInput)
					local num = Instance.new("IntValue")
					local numanim
					shared.damageanim = function()
						if numanim then numanim:Cancel() end
						if flydamagecamera.Enabled then
							num.Value = 1000
							numanim = game:GetService("TweenService"):Create(num, TweenInfo.new(0.5), {Value = 0})
							numanim:Play()
						end
					end
					oldcamupdate = camcontrol.Update
					camcontrol.Update = function(self, dt) 
						if camcontrol.activeCameraController then
							camcontrol.activeCameraController:UpdateMouseBehavior()
							local newCameraCFrame, newCameraFocus = camcontrol.activeCameraController:Update(dt)
							cam.CFrame = newCameraCFrame * CFrame.Angles(0, 0, math.rad(num.Value / 100))
							cam.Focus = newCameraFocus
							if camcontrol.activeTransparencyController then
								camcontrol.activeTransparencyController:Update(dt)
							end
							if caminput.getInputEnabled() then
								caminput.resetInputForFrameEnd()
							end
						end
					end
				end)
			else
				shared.damageanim = nil
				if camcontrol then 
					camcontrol.Update = oldcamupdate
				end
			end
		end
	})
	flydamagecamera = fly.CreateToggle({
		Name = "Camera Animation",
		Function = function() end,
		Default = true
	})
	flydamagecamera.Object.BorderSizePixel = 0
	flydamagecamera.Object.BackgroundTransparency = 0
	flydamagecamera.Object.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	flydamagecamera.Object.Visible = false
	flyac = fly.CreateToggle({
		Name = "Fly Anyway",
		Function = function(callback) 
			if flyspeedboost.Object then 
				flyspeedboost.Object.Visible = callback
			end
			if flyacprogressbar.Object then 
				flyacprogressbar.Object.Visible = callback
			end

		end,
		HoverText = "Enables fly without balloons for 1.4s",
		Default = true
	})
	flyspeedboost = fly.CreateToggle({
		Name = "Boost Speed",
		Function = function() end,
		HoverText = "boosts fly anyway speed",
	})
	flyspeedboost.Object.BorderSizePixel = 0
	flyspeedboost.Object.BackgroundTransparency = 0
	flyspeedboost.Object.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	flyspeedboost.Object.Visible = false
	flyacprogressbar = fly.CreateToggle({
		Name = "Progress Bar",
		Function = function(callback) 
			if callback then 
				flyacprogressbarframe = Instance.new("Frame")
				flyacprogressbarframe.AnchorPoint = Vector2.new(0.5, 0)
				flyacprogressbarframe.Position = UDim2.new(0.5, 0, 1, -200)
				flyacprogressbarframe.Size = UDim2.new(0.2, 0, 0, 20)
				flyacprogressbarframe.BackgroundTransparency = 0.5
				flyacprogressbarframe.BorderSizePixel = 0
				flyacprogressbarframe.BackgroundColor3 = Color3.new(0, 0, 0)
				flyacprogressbarframe.Visible = fly.Enabled
				flyacprogressbarframe.Parent = GuiLibrary["MainGui"]
				local flyacprogressbarframe2 = flyacprogressbarframe:Clone()
				flyacprogressbarframe2.AnchorPoint = Vector2.new(0, 0)
				flyacprogressbarframe2.Position = UDim2.new(0, 0, 0, 0)
				flyacprogressbarframe2.Size = UDim2.new(1, 0, 0, 20)
				flyacprogressbarframe2.BackgroundTransparency = 0
				flyacprogressbarframe2.Visible = true
				flyacprogressbarframe2.BackgroundColor3 = Color3.new(0.9, 0.9, 0.9)
				flyacprogressbarframe2.Parent = flyacprogressbarframe
				local flyacprogressbartext = Instance.new("TextLabel")
				flyacprogressbartext.Text = "2s"
				flyacprogressbartext.Font = Enum.Font.Gotham
				flyacprogressbartext.TextStrokeTransparency = 0
				flyacprogressbartext.TextColor3 =  Color3.new(0.9, 0.9, 0.9)
				flyacprogressbartext.TextSize = 20
				flyacprogressbartext.Size = UDim2.new(1, 0, 1, 0)
				flyacprogressbartext.BackgroundTransparency = 1
				flyacprogressbartext.Position = UDim2.new(0, 0, -1, 0)
				flyacprogressbartext.Parent = flyacprogressbarframe
			else
				if flyacprogressbarframe then flyacprogressbarframe:Remove() flyacprogressbarframe = nil end
			end
		end,
		HoverText = "show amount of fly time",
		Default = true
	})
	flyacprogressbar.Object.BorderSizePixel = 0
	flyacprogressbar.Object.BackgroundTransparency = 0
	flyacprogressbar.Object.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	flyacprogressbar.Object.Visible = false
end)

runcode(function()
	local OldNoFallFunction
	local flymode = {Value = "Normal"}
	local flyverticalspeed = {Value = 40}
	local flyupanddown = {Enabled = true}
	local flypop = {Enabled = true}
	local flyautodamage = {Enabled = true}
	local flyac = {Enabled = false}
	local flyacprogressbar = {Enabled = false}
	local flydamageanim = {Enabled = false}
	local flyspeedboost = {Enabled = false}
	local flyhighjump = {Enabled = false}
	local flydelay = {Value = 125}
	local flyacprogressbarframe
	local olddeflate
	local flyrequests = 0
	local flytime = 60
	local flylimit = false
	local flyup = false
	local flydown = false
	local flypress
	local flyendpress
	local flycorountine
	local flytog = false
	local flytogtick = tick()
	local groundtime = tick()
	local onground = false
	local lastonground = false
	local clonesuccess = false
	local disabledproper = true
	local alternatelist = {"Normal", "AntiCheat A", "AntiCheat B"}
	local cloned

	local function disablefunc(part)
		RunLoops:UnbindFromHeartbeat("InfiniteFlyOff")
		disabledproper = true
		part:Destroy()
		lplr.Character.Parent = game
		oldcloneroot.Parent = lplr.Character
		lplr.Character.PrimaryPart = oldcloneroot
		lplr.Character.Parent = workspace
		oldcloneroot.CanCollide = true
		oldcloneroot.Transparency = 1
		for i,v in pairs(lplr.Character:GetDescendants()) do 
			if v:IsA("Weld") or v:IsA("Motor6D") then 
				if v.Part0 == clone then v.Part0 = oldcloneroot end
				if v.Part1 == clone then v.Part1 = oldcloneroot end
			end
			if v:IsA("BodyVelocity") then 
				v:Destroy()
			end
		end
		for i,v in pairs(oldcloneroot:GetChildren()) do 
			if v:IsA("BodyVelocity") then 
				v:Destroy()
			end
		end
		if clone then 
			clone:Destroy()
			clone = nil
		end
		lplr.Character.Humanoid.HipHeight = hip or 2
		oldcloneroot = nil
	end

	fly = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "InfiniteFly",
		Function = function(callback)
			if callback then
				if not disabledproper then 
					createwarning("InfiniteFly", "Wait for the last fly to finish", 3)
					fly.ToggleButton(false)
					return 
				end
				flypress = uis.InputBegan:Connect(function(input1)
					if flyupanddown.Enabled and game:GetService("UserInputService"):GetFocusedTextBox() == nil then
						if input1.KeyCode == Enum.KeyCode.Space or input1.KeyCode == Enum.KeyCode.ButtonA then
							flyup = true
						end
						if input1.KeyCode == Enum.KeyCode.LeftShift or input1.KeyCode == Enum.KeyCode.ButtonL2 then
							flydown = true
						end
					end
				end)
				flyendpress = uis.InputEnded:Connect(function(input1)
					if input1.KeyCode == Enum.KeyCode.Space or input1.KeyCode == Enum.KeyCode.ButtonA then
						flyup = false
					end
					if input1.KeyCode == Enum.KeyCode.LeftShift or input1.KeyCode == Enum.KeyCode.ButtonL2 then
						flydown = false
					end
				end)
				clonesuccess = false
				if entityLibrary.isAlive and entityLibrary.character.Humanoid.Health > 0 and isnetworkowner(entityLibrary.character.HumanoidRootPart) then
					cloned = lplr.Character
					oldcloneroot = entityLibrary.character.HumanoidRootPart
					lplr.Character.Parent = game
					clone = oldcloneroot:Clone()
					clone.Parent = lplr.Character
					oldcloneroot.Parent = cam
					bedwars["QueryUtil"]:setQueryIgnored(oldcloneroot, true)
					oldcloneroot.Transparency = 1
					clone.CFrame = oldcloneroot.CFrame
					lplr.Character.PrimaryPart = clone
					lplr.Character.Parent = workspace
					for i,v in pairs(lplr.Character:GetDescendants()) do 
						if v:IsA("Weld") or v:IsA("Motor6D") then 
							if v.Part0 == oldcloneroot then v.Part0 = clone end
							if v.Part1 == oldcloneroot then v.Part1 = clone end
						end
						if v:IsA("BodyVelocity") then 
							v:Destroy()
						end
					end
					for i,v in pairs(oldcloneroot:GetChildren()) do 
						if v:IsA("BodyVelocity") then 
							v:Destroy()
						end
					end
					if hip then 
						lplr.Character.Humanoid.HipHeight = hip
					end
					hip = lplr.Character.Humanoid.HipHeight
					clonesuccess = true
				end
				if not clonesuccess then 
					createwarning("InfiniteFly", "Character missing", 3)
					fly.ToggleButton(false)
					return 
				end
				local goneup = false
				RunLoops:BindToHeartbeat("InfiniteFly", 1, function(delta) 
					if entityLibrary.isAlive and (GuiLibrary.ObjectsThatCanBeSaved["Lobby CheckToggle"]["Api"].Enabled == false or matchState ~= 0) then
						if isnetworkowner(oldcloneroot) then 
							local newpos = {oldcloneroot.CFrame:GetComponents()}
							newpos[1] = clone.CFrame.X
							if newpos[2] < 1000 or (not goneup) then 
								createwarning("Infinite Fly", "go up", 3)
								newpos[2] = 100000
								goneup = true
							end
							newpos[3] = clone.CFrame.Z
							oldcloneroot.CFrame = CFrame.new(unpack(newpos))
							oldcloneroot.Velocity = Vector3.new(clone.Velocity.X, oldcloneroot.Velocity.Y, clone.Velocity.Z)
						else
							local newpos2 = {oldcloneroot.CFrame:GetComponents()}
							newpos2[2] = clone.CFrame.Y
							clone.CFrame = CFrame.new(unpack(newpos2))
						end
						allowed = 1
						local mass = (entityLibrary.character.HumanoidRootPart:GetMass() - 1.4) * (delta * 100)
						local flypos = entityLibrary.character.Humanoid.MoveDirection * 16
						entityLibrary.character.HumanoidRootPart.Transparency = 1
						entityLibrary.character.HumanoidRootPart.Velocity = flypos + (Vector3.new(0, mass + (flyup and flyverticalspeed.Value or 0) + (flydown and -flyverticalspeed.Value or 0), 0) * allowed)
						flyvelo = flypos + Vector3.new(0, mass + (flyup and flyverticalspeed.Value or 0) + (flydown and -flyverticalspeed.Value or 0), 0)
					end
				end)
			else
				RunLoops:UnbindFromHeartbeat("InfiniteFly")
				if clonesuccess and oldcloneroot and clone and lplr.Character.Parent == workspace and oldcloneroot.Parent ~= nil and disabledproper and cloned == lplr.Character then 
					local ray = workspace:Raycast(Vector3.new(oldcloneroot.Position.X, clone.CFrame.p.Y, oldcloneroot.Position.Z), Vector3.new(0, -1000, 0), blockraycast)
					clone.CFrame = CFrame.new(oldcloneroot.Position.X, ray and ray.Position.Y + (entityLibrary.character.Humanoid.HipHeight + (oldcloneroot.Size.Y / 2)) or clone.CFrame.p.Y, oldcloneroot.Position.Z)
					oldcloneroot.Velocity = Vector3.new(0, -1, 0)
					RunLoops:BindToHeartbeat("InfiniteFlyOff", 1, function()
						if oldcloneroot then 
							oldcloneroot.Velocity = Vector3.new(0, -1, 0)
						end
					end)
					oldcloneroot.CFrame = clone.CFrame
					entityLibrary.character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
					local part = Instance.new("Part")
					part.Anchored = true
					part.CanCollide = false
					part.Size = Vector3.new(1, 1, 1)
					part.Color = Color3.new(0.5, 0.5, 1)
					part.Transparency = 0.5
					part.Shape = Enum.PartType.Ball
					part.TopSurface = Enum.SurfaceType.Smooth
					part.BottomSurface = Enum.SurfaceType.Smooth
					part.Parent = workspace.GameSounds
					part.Position = oldcloneroot.Position
					disabledproper = false
					oldcloneroot.Transparency = 0
					if isnetworkowner(oldcloneroot) then 
						createwarning("InfiniteFly", "Waiting "..(flydelay.Value / 100).."s to not flag", 3)
						task.delay(flydelay.Value / 100, disablefunc, part)
					else
						createwarning("InfiniteFly", "Waiting until not flagged", 10)
						task.spawn(function()
							repeat task.wait() until oldcloneroot and isnetworkowner(oldcloneroot) or oldcloneroot == nil
							local ray = workspace:Raycast(Vector3.new(oldcloneroot.Position.X, clone.CFrame.p.Y, oldcloneroot.Position.Z), Vector3.new(0, -1000, 0), blockraycast)
							oldcloneroot.Velocity = Vector3.new(0, -1, 0)
							oldcloneroot.CFrame = CFrame.new(oldcloneroot.Position.X, ray and ray.Position.Y + (entityLibrary.character.Humanoid.HipHeight + (oldcloneroot.Size.Y / 2)) or clone.CFrame.p.Y, oldcloneroot.Position.Z)
							entityLibrary.character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
							createwarning("InfiniteFly", "Waiting 1.5s to not flag", 3)
							task.wait(1.5)
							disablefunc(part)
						end)
					end
				end
				flyup = false
				flydown = false
				if flypress then flypress:Disconnect() end
				if flyendpress then flyendpress:Disconnect() end
			end
		end,
		HoverText = "Makes you go zoom"
	})
	flydelay = fly.CreateSlider({
		Name = "Land Delay",
		Min = 1,
		Max = 150,
		Default = 150,
		Function = function() end,
		["Double"] = 100
	})
	flyverticalspeed = fly.CreateSlider({
		Name = "Vertical Speed",
		Min = 1,
		Max = 100,
		Function = function(val) end, 
		Default = 44
	})
	flyupanddown = fly.CreateToggle({
		Name = "Y Level",
		Function = function() end, 
		Default = true
	})
end)

runcode(function()
	local scaffoldtext = Instance.new("TextLabel")
	scaffoldtext.Font = Enum.Font.SourceSans
	scaffoldtext.TextSize = 20
	scaffoldtext.BackgroundTransparency = 1
	scaffoldtext.TextColor3 = Color3.fromRGB(255, 0, 0)
	scaffoldtext.Size = UDim2.new(0, 0, 0, 0)
	scaffoldtext.Position = UDim2.new(0.5, 0, 0.5, 30)
	scaffoldtext.Text = "0"
	scaffoldtext.Visible = false
	scaffoldtext.Parent = GuiLibrary["MainGui"]
	local ScaffoldExpand = {Value = 1}
	local ScaffoldDiagonal = {Enabled = false}
	local ScaffoldTower = {Enabled = false}
	local ScaffoldDownwards = {Enabled = false}
	local ScaffoldStopMotion = {Enabled = false}
	local ScaffoldBlockCount = {Enabled = false}
	local ScaffoldHandCheck = {Enabled = false}
	local ScaffoldMouseCheck = {Enabled = false}
	local ScaffoldAnimation = {Enabled = false}
	local scaffoldstopmotionval = false
	local scaffoldposcheck = tick()
	local scaffoldstopmotionpos = Vector3.zero
	local scaffoldposchecklist = {}
	task.spawn(function()
		for x = -3, 3, 3 do 
			for y = -3, 3, 3 do 
				for z = -3, 3, 3 do 
					if Vector3.new(x, y, z) ~= Vector3.new(0, 0, 0) then 
						table.insert(scaffoldposchecklist, Vector3.new(x, y, z)) 
					end 
				end 
			end 
		end
	end)

	local function checkblocks(pos)
		for i,v in pairs(scaffoldposchecklist) do
			if getblock(pos + v) then
				return true
			end
		end
		return false
	end

	local function closestpos(block, pos)
		local startpos = block.Position - (block.Size / 2) - Vector3.new(1.5, 1.5, 1.5)
		local endpos = block.Position + (block.Size / 2) + Vector3.new(1.5, 1.5, 1.5)
		local newpos = block.Position + (pos - block.Position)
		return Vector3.new(math.clamp(newpos.X, startpos.X, endpos.X), math.clamp(newpos.Y, startpos.Y, endpos.Y), math.clamp(newpos.Z, startpos.Z, endpos.Z))
	end

	local function getclosesttop(newmag, pos)
		local closest, closestmag = pos, newmag * 3
		if entityLibrary.isAlive then 
			for i,v in pairs(bedwarsblocks) do 
				local close = closestpos(v, pos)
				local mag = (close - pos).magnitude
				if mag <= closestmag then 
					closest = close
					closestmag = mag
				end
			end
		end
		return closest
	end

	local oldspeed
	Scaffold = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "Scaffold",
		Function = function(callback)
			if callback then
				scaffoldtext.Visible = ScaffoldBlockCount.Enabled
				if entityLibrary.isAlive then 
					scaffoldstopmotionpos = entityLibrary.character.HumanoidRootPart.CFrame.p
				end
				task.spawn(function()
					repeat
						task.wait()
						local equipped = getEquipped()
						if entityLibrary.isAlive and (ScaffoldHandCheck.Enabled and equipped["Type"] == "block" or (not ScaffoldHandCheck.Enabled)) and ((not ScaffoldMouseCheck.Enabled) or uis:IsMouseButtonPressed(0)) then
							local wool, woolamount = getwool()
							if equipped["Type"] == "block" then
								local equippeditem = getItem(equipped.Object.Name)
								wool = equipped.Object.Name
								woolamount = equippeditem and equippeditem["amount"] or 0
							elseif (not wool) then 
								wool, woolamount = getBlock()
							end
							scaffoldtext.Text = (woolamount and tostring(woolamount) or "0")
							scaffoldtext.TextColor3 = woolamount and (woolamount >= 128 and Color3.fromRGB(9, 255, 198) or woolamount >= 64 and Color3.fromRGB(255, 249, 18)) or Color3.fromRGB(255, 0, 0)
							if not wool then continue end
							local towering = ScaffoldTower.Enabled and uis:IsKeyDown(Enum.KeyCode.Space) and game:GetService("UserInputService"):GetFocusedTextBox() == nil
							if towering then
								if (not scaffoldstopmotionval) and ScaffoldStopMotion.Enabled then
									scaffoldstopmotionval = true
									scaffoldstopmotionpos = entityLibrary.character.HumanoidRootPart.CFrame.p
								end
								entityLibrary.character.HumanoidRootPart.Velocity = Vector3.new(entityLibrary.character.HumanoidRootPart.Velocity.X, 28, entityLibrary.character.HumanoidRootPart.Velocity.Z)
								if ScaffoldStopMotion.Enabled and scaffoldstopmotionval then
									entityLibrary.character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(scaffoldstopmotionpos.X, entityLibrary.character.HumanoidRootPart.CFrame.p.Y, scaffoldstopmotionpos.Z))
								end
							else
								scaffoldstopmotionval = false
							end
							for i = 1, ScaffoldExpand.Value do
								local newpos = getScaffold((entityLibrary.character.HumanoidRootPart.Position + ((scaffoldstopmotionval and Vector3.zero or entityLibrary.character.Humanoid.MoveDirection) * (i * 3.5))) + Vector3.new(0, -((entityLibrary.character.HumanoidRootPart.Size.Y / 2) + entityLibrary.character.Humanoid.HipHeight + (uis:IsKeyDown(Enum.KeyCode.LeftShift) and ScaffoldDownwards.Enabled and 4.5 or 1.5))), 0)
								newpos = Vector3.new(newpos.X, newpos.Y - (towering and 4 or 0), newpos.Z)
								if newpos ~= oldpos then
									if not checkblocks(newpos) then
										local oldnewpos = newpos
										newpos = getScaffold(getclosesttop(20, newpos))
										if getblock(newpos) then newpos = oldnewpos end
									end
									if ScaffoldAnimation.Enabled then 
										if not getblock(newpos) then
										bedwars.ViewmodelController:playAnimation(bedwars.AnimationType.FP_USE_ITEM)
										end
									end
									task.spawn(bedwars["placeBlock"], newpos, wool, ScaffoldAnimation.Enabled)
									if ScaffoldExpand.Value > 1 then 
										task.wait()
									end
									oldpos = newpos
								end
							end
						end
					until (not Scaffold.Enabled)
				end)
			else
				scaffoldtext.Visible = false
				oldpos = Vector3.zero
				oldpos2 = Vector3.zero
			end
		end, 
		HoverText = "Helps you make bridges/scaffold walk."
	})
	ScaffoldExpand = Scaffold.CreateSlider({
		Name = "Expand",
		Min = 1,
		Max = 8,
		Function = function(val) end,
		Default = 1,
		HoverText = "Build range"
	})
	ScaffoldDiagonal = Scaffold.CreateToggle({
		Name = "Diagonal", 
		Function = function(callback) end,
		Default = true
	})
	ScaffoldTower = Scaffold.CreateToggle({
		Name = "Tower", 
		Function = function(callback) 
			if ScaffoldStopMotion.Object then
				ScaffoldTower.Object.ToggleArrow.Visible = callback
				ScaffoldStopMotion.Object.Visible = callback
			end
		end
	})
	ScaffoldMouseCheck = Scaffold.CreateToggle({
		Name = "Require mouse down", 
		Function = function(callback) end,
		HoverText = "Only places when left click is held.",
	})
	ScaffoldDownwards  = Scaffold.CreateToggle({
		Name = "Downwards", 
		Function = function(callback) end,
		HoverText = "Goes down when left shift is held."
	})
	ScaffoldStopMotion = Scaffold.CreateToggle({
		Name = "Stop Motion",
		Function = function() end,
		HoverText = "Stops your movement when going up"
	})
	ScaffoldStopMotion.Object.BackgroundTransparency = 0
	ScaffoldStopMotion.Object.BorderSizePixel = 0
	ScaffoldStopMotion.Object.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	ScaffoldStopMotion.Object.Visible = ScaffoldTower.Enabled
	ScaffoldBlockCount = Scaffold.CreateToggle({
		Name = "Block Count",
		Function = function(callback) 
			if Scaffold.Enabled then
				scaffoldtext.Visible = callback 
			end
		end,
		HoverText = "Shows the amount of blocks in the middle."
	})
	ScaffoldHandCheck = Scaffold.CreateToggle({
		Name = "Whitelist Only",
		Function = function() end,
		HoverText = "Only builds with blocks in your hand."
	})
	ScaffoldAnimation = Scaffold.CreateToggle({
		Name = "Animation",
		Function = function() end
	})
end)

local NoFall = {Enabled = false}
local oldfall
NoFall = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
	Name = "NoFall",
	Function = function(callback)
		if callback then
			task.spawn(function()
				repeat
					task.wait(0.5)
					bedwars.ClientHandler:Get("GroundHit"):SendToServer()
				until NoFall.Enabled == false
			end)
		end
	end, 
	HoverText = "Prevents taking fall damage."
})

local NoSlowdown = {Enabled = false}
local OldSetSpeedFunc
NoSlowdown = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
	Name = "NoSlowdown",
	Function = function(callback)
		if callback then
			OldSetSpeedFunc = bedwars["SprintController"]["setSpeed"]
			bedwars["SprintController"]["setSpeed"] = function(tab1, val1)
				local hum = entityLibrary.character.Humanoid
				if hum then
					hum.WalkSpeed = math.max(20 * tab1.moveSpeedMultiplier, 20)
				end
			end
			bedwars["SprintController"]:setSpeed(20)
		else
			bedwars["SprintController"]["setSpeed"] = OldSetSpeedFunc
			bedwars["SprintController"]:setSpeed(20)
			OldSetSpeedFunc = nil
		end
	end, 
	HoverText = "Prevents slowing down when using items."
})

local healthColorToPosition = {
	[0.01] = Color3.fromRGB(255, 28, 0);
	[0.5] = Color3.fromRGB(250, 235, 0);
	[0.99] = Color3.fromRGB(27, 252, 107);
}

local function HealthbarColorTransferFunction(healthPercent)
	healthPercent = math.clamp(healthPercent, 0.01, 0.99)
	local lastcolor = Color3.new(1, 1, 1)
	for samplePoint, colorSampleValue in pairs(healthColorToPosition) do
		local distance = (healthPercent / samplePoint)
		if distance == 1 then
			return colorSampleValue
		elseif distance < 1 then 
			return lastcolor:lerp(colorSampleValue, distance)
		else
			lastcolor = colorSampleValue
		end
	end
	return lastcolor
end

local BedESP = {Enabled = false}
local BedESPFolder = Instance.new("Folder")
BedESPFolder.Name = "BedESPFolder"
BedESPFolder.Parent = GuiLibrary["MainGui"]
local BedESPTable = {}
local BedESPColor = {Value = 0.44}
local BedESPTransparency = {Value = 1}
local BedESPOnTop = {Enabled = true}
BedESP = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
	Name = "BedESP",
	Function = function(callback) 
		if callback then
			RunLoops:BindToRenderStep("BedESP", 500, function()
				if collectionservice:GetTagged("bed") then
					for i,plr in pairs(collectionservice:GetTagged("bed")) do
						local thing
						if plr ~= nil and BedESPTable[plr] then
							thing = BedESPTable[plr]
							for bedespnumber, bedesppart in pairs(thing:GetChildren()) do
								bedesppart.Visible = false
							end
						end
						
						if plr ~= nil and plr.Parent ~= nil and plr:FindFirstChild("Covers") and lplr.Team and plr.Covers.BrickColor ~= lplr.Team.TeamColor then
							if BedESPFolder:FindFirstChild(plr.Name..tostring(plr.Covers.BrickColor)) == nil then
								local Bedfolder = Instance.new("Folder")
								Bedfolder.Name = plr.Name..tostring(plr.Covers.BrickColor)
								Bedfolder.Parent = BedESPFolder
								BedESPTable[plr] = Bedfolder
								thing = Bedfolder
								for bedespnumber, bedesppart in pairs(plr:GetChildren()) do
									local boxhandle = Instance.new("BoxHandleAdornment")
									boxhandle.Size = bedesppart.Size + Vector3.new(.01, .01, .01)
									boxhandle.AlwaysOnTop = true
									boxhandle.ZIndex = (bedesppart.Name == "Covers" and 10 or 8)
									boxhandle.Visible = true
									boxhandle.Color3 = bedesppart.Color
									boxhandle.Name = bedespnumber
									boxhandle.Parent = Bedfolder
								end
							end
							for bedespnumber, bedesppart in pairs(thing:GetChildren()) do
								bedesppart.Visible = true
								if plr:GetChildren()[bedespnumber] then
									bedesppart.Adornee = plr:GetChildren()[bedespnumber]
								else
									bedesppart.Adornee = nil
								end
							end
						end
					end
				end
			end)
		else
			RunLoops:UnbindFromRenderStep("BedESP") 
			BedESPFolder:ClearAllChildren()
		end
	end,
	HoverText = "Render Beds through walls" 
})

runcode(function()
	local old
	local old2
	local oldhitpart 
	local removetextures = {Enabled = false}
	local FPSBoost = {Enabled = false}
	local removetexturessmooth = {Enabled = false}
	local fpsboostdamageindicator = {Enabled = false}
	local fpsboostdamageeffect = {Enabled = false}
	local wasenabled = false

	local function fpsboosttextures()
		task.spawn(function()
			repeat task.wait() until matchState ~= 0
			if not wasenabled then return end
			for i,v in pairs(bedwarsblocks) do
				if v:GetAttribute("PlacedByUserId") == 0 then
					v.Material = FPSBoost.Enabled and removetextures.Enabled and Enum.Material.SmoothPlastic or (v.Name:find("glass") and Enum.Material.SmoothPlastic or Enum.Material.Fabric)
					for i2,v2 in pairs(v:GetChildren()) do
						if v2:IsA("Texture") then
							v2.Transparency = FPSBoost.Enabled and removetextures.Enabled and 1 or 0
						end
					end
				end
			end
		end)
	end

	FPSBoost = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "FPSBoost",
		Function = function(callback)
			local damagetab = debug.getupvalue(bedwars["DamageIndicator"], 2)
			if callback then
				wasenabled = true
				fpsboosttextures()
				if fpsboostdamageindicator.Enabled then 
					damagetab.strokeThickness = 0
					damagetab.textSize = 0
					damagetab.blowUpDuration = 0
					damagetab.blowUpSize = 0
					debug.setupvalue(bedwars["DamageIndicator"], 10, {
						Create = function(self, obj, ...)
							task.spawn(function()
								obj.Parent.Visible = false
							end)
							return game:GetService("TweenService"):Create(obj, ...)
						end
					})
				end
				if fpsboostdamageeffect.Enabled then 
					oldhitpart = bedwars["DamageIndicatorController"].hitEffectPart
					bedwars["DamageIndicatorController"].hitEffectPart = nil
				end
				old = getmetatable(bedwars["HighlightController"])["highlight"]
				old2 = getmetatable(bedwars["StopwatchController"]).tweenOutGhost
				local highlighttable = {}
				getmetatable(bedwars["StopwatchController"]).tweenOutGhost = function(p17, p18)
					p18:Destroy()
				end
				getmetatable(bedwars["HighlightController"])["highlight"] = function() end
			else
				fpsboosttextures()
				if oldhitpart then 
					bedwars["DamageIndicatorController"].hitEffectPart = oldhitpart
				end
				damagetab.strokeThickness = 1.5
				damagetab.textSize = 28
				damagetab.blowUpDuration = 0.125
				damagetab.blowUpSize = 76
				debug.setupvalue(bedwars["DamageIndicator"], 10, game:GetService("TweenService"))
				if bedwars["DamageIndicatorController"].hitEffectPart then 
					bedwars["DamageIndicatorController"].hitEffectPart.Attachment.Cubes.Enabled = true
					bedwars["DamageIndicatorController"].hitEffectPart.Attachment.Shards.Enabled = true
				end
				getmetatable(bedwars["HighlightController"])["highlight"] = old
				getmetatable(bedwars["StopwatchController"]).tweenOutGhost = old2
				old = nil
				old2 = nil
			end
		end
	})
	removetextures = FPSBoost.CreateToggle({
		Name = "Remove Textures",
		Function = function(callback)
			fpsboosttextures()
		end
	})
	fpsboostdamageindicator = FPSBoost.CreateToggle({
		Name = "Remove Damage Indicator",
		Function = function(callback)
			local damagetab = debug.getupvalue(bedwars["DamageIndicator"], 2)
			if FPSBoost.Enabled then 
				if callback then 
					damagetab.strokeThickness = 0
					damagetab.textSize = 0
					damagetab.blowUpDuration = 0
					damagetab.blowUpSize = 0
					debug.setupvalue(bedwars["DamageIndicator"], 10, {
						Create = function(self, obj, ...)
							task.spawn(function()
								obj.Parent.Visible = false
							end)
							return game:GetService("TweenService"):Create(obj, ...)
						end
					})
				else
					damagetab.strokeThickness = 1.5
					damagetab.textSize = 28
					damagetab.blowUpDuration = 0.125
					damagetab.blowUpSize = 76
					debug.setupvalue(bedwars["DamageIndicator"], 10, game:GetService("TweenService"))
				end
			end	
		end
	})
	fpsboostdamageeffect = FPSBoost.CreateToggle({
		Name = "Remove Damage Effect",
		Function = function(callback)
			if FPSBoost.Enabled then 
				if callback then 
					oldhitpart = bedwars["DamageIndicatorController"].hitEffectPart
					bedwars["DamageIndicatorController"].hitEffectPart = nil
				else
					if oldhitpart then 
						bedwars["DamageIndicatorController"].hitEffectPart = oldhitpart
					end
					oldhitpart = nil
				end
			end
		end
	})
end)

runcode(function()
	local nametagconnection
	local nametagconnection2 
	local function removeTags(str)
        str = str:gsub("<br%s*/>", "\n")
        return (str:gsub("<[^<>]->", ""))
    end

	local function floorpos(pos)
		return Vector2.new(math.floor(pos.X), math.floor(pos.Y))
	end

	local kititems = {
		["jade"] = "jade_hammer",
		["archer"] = "tactical_crossbow",
		["angel"] = "",
		["cowgirl"] = "lasso",
		["dasher"] = "wood_dao",
		["axolotl"] = "axolotl",
		["yeti"] = "snowball",
		["smoke"] = "smoke_block",
		["trapper"] = "snap_trap",
		["pyro"] = "flamethrower",
		["daven"] = "cannon",
		["regent"] = "void_axe", 
		["baker"] = "apple",
		["builder"] = "builder_hammer",
		["farmer_cletus"] = "carrot_seeds",
		["melody"] = "guitar",
		["barbarian"] = "rageblade",
		["gingerbread_man"] = "gumdrop_bounce_pad",
		["spirit_catcher"] = "spirit",
		["fisherman"] = "fishing_rod",
		["oil_man"] = "oil_consumable",
		["santa"] = "tnt",
		["miner"] = "miner_pickaxe",
		["sheep_herder"] = "crook",
		["beast"] = "speed_potion",
		["metal_detector"] = "metal_detector",
		["cyber"] = "drone",
		["vesta"] = "damage_banner",
		["lumen"] = "light_sword",
		["ember"] = "infernal_saber"
	}

	local NameTagsFolder = Instance.new("Folder")
	NameTagsFolder.Name = "NameTagsFolder"
	NameTagsFolder.Parent = GuiLibrary["MainGui"]
	local nametagsfolderdrawing = {}
	local NameTagsColor = {Value = 0.44}
	local NameTagsTeammates = {Enabled = false}
	local NameTagsDisplayName = {Enabled = false}
	local NameTagsHealth = {Enabled = false}
	local NameTagsDistance = {Enabled = false}
	local NameTagsBackground = {Enabled = true}
	local NameTagsScale = {Value = 10}
	local NameTagsFont = {Value = "SourceSans"}
	local NameTagsShowInventory = {Enabled = false}
	local NameTagsDrawing = {Enabled = false}
	local NameTagsRangeLimit = {Value = 0}
	local NameTagsAlive = {Enabled = false}
	local fontitems = {"SourceSans"}
	local nametagscache = {}

	local nametagsfunc = {
		Drawing = function(plr)
			if nametagsfolderdrawing[plr.Name] then
				thing = nametagsfolderdrawing[plr.Name]
				thing.Text.Visible = false
				thing.BG.Visible = false
			else
				nametagsfolderdrawing[plr.Name] = {}
				nametagsfolderdrawing[plr.Name].Text = Drawing.new("Text")
				nametagsfolderdrawing[plr.Name].Text.Size = 17	
				nametagsfolderdrawing[plr.Name].Text.Font = 0
				nametagsfolderdrawing[plr.Name].Text.Text = ""
				nametagsfolderdrawing[plr.Name].Text.ZIndex = 2
				nametagsfolderdrawing[plr.Name].BG = Drawing.new("Square")
				nametagsfolderdrawing[plr.Name].BG.Filled = true
				nametagsfolderdrawing[plr.Name].BG.Transparency = 0.5
				nametagsfolderdrawing[plr.Name].BG.Color = Color3.new(0, 0, 0)
				nametagsfolderdrawing[plr.Name].BG.Size = Vector2.new(0, 0)
				nametagsfolderdrawing[plr.Name].BG.ZIndex = 1
				thing = nametagsfolderdrawing[plr.Name]
			end

			local aliveplr = isAlive(plr, NameTagsAlive.Enabled)
			if aliveplr and ((not NameTagsTeammates.Enabled) and plr:GetAttribute("Team") ~= lplr:GetAttribute("Team") or NameTagsTeammates.Enabled) and plr ~= lplr then
				local mag = entityLibrary.isAlive and (entityLibrary.character.HumanoidRootPart.Position - aliveplr.RootPart.Position).magnitude or 0
				local magcheck = NameTagsRangeLimit.Value == 0 or mag <= NameTagsRangeLimit.Value 
				if magcheck then 
					local headPos, headVis = cam:WorldToViewportPoint((aliveplr.RootPart:GetRenderCFrame() * CFrame.new(0, aliveplr.Head.Size.Y + aliveplr.RootPart.Size.Y, 0)).Position)
					
					if headVis then
						thing.Text.Visible = headVis
						thing.Text.Position = floorpos(Vector2.new(headPos.X - thing.Text.TextBounds.X / 2, (headPos.Y - thing.Text.TextBounds.Y)))
						thing.BG.Visible = headVis and NameTagsBackground.Enabled
						thing.BG.Position = floorpos(Vector2.new((headPos.X - 2) - thing.Text.TextBounds.X / 2, (headPos.Y - thing.Text.TextBounds.Y) + 1.5))
					end
				end
			end
		end,
		Normal = function(plr)
			local thing = NameTagsFolder:FindFirstChild(plr.Name)
			if thing then
				thing.Visible = false
			else
				thing = Instance.new("TextLabel")
				thing.BackgroundTransparency = 0.5
				thing.BackgroundColor3 = Color3.new(0, 0, 0)
				thing.BorderSizePixel = 0
				thing.Visible = false
				thing.RichText = true
				thing.Name = plr.Name
				thing.Font = Enum.Font.SourceSans
				thing.TextSize = 14
				local nametagSize = textservice:GetTextSize(plr.Name, thing.TextSize, thing.Font, Vector2.new(9e9, 9e9))
				thing.Size = UDim2.new(0, nametagSize.X + 4, 0, nametagSize.Y)
				thing.Text = plr.Name
				thing.TextColor3 = getPlayerColor(plr) or Color3.fromHSV(NameTagsColor["Hue"], NameTagsColor["Sat"], NameTagsColor.Value)
				thing.Parent = NameTagsFolder
				local hand = Instance.new("ImageLabel")
				hand.Size = UDim2.new(0, 30, 0, 30)
				hand.Name = "Hand"
				hand.BackgroundTransparency = 1
				hand.Position = UDim2.new(0, -30, 0, -30)
				hand.Image = ""
				hand.Parent = thing
				local helmet = hand:Clone()
				helmet.Name = "Helmet"
				helmet.Position = UDim2.new(0, 5, 0, -30)
				helmet.Parent = thing
				local chest = hand:Clone()
				chest.Name = "Chestplate"
				chest.Position = UDim2.new(0, 35, 0, -30)
				chest.Parent = thing
				local boots = hand:Clone()
				boots.Name = "Boots"
				boots.Position = UDim2.new(0, 65, 0, -30)
				boots.Parent = thing
				local kit = hand:Clone()
				kit.Name = "Kit"
				task.spawn(function()
					repeat task.wait() until plr:GetAttribute("PlayingAsKit") ~= ""
					if kit then
						kit.Image = kititems[plr:GetAttribute("PlayingAsKit")] and bedwars.getIcon({itemType = kititems[plr:GetAttribute("PlayingAsKit")]}, NameTagsShowInventory.Enabled) or ""
					end
				end)
				kit.Position = UDim2.new(0, -30, 0, -65)
				kit.Parent = thing
			end

			local aliveplr = isAlive(plr, NameTagsAlive.Enabled)
			if aliveplr and ((not NameTagsTeammates.Enabled) and plr:GetAttribute("Team") ~= lplr:GetAttribute("Team") or NameTagsTeammates.Enabled) and plr ~= lplr then
				local mag = entityLibrary.isAlive and (entityLibrary.character.HumanoidRootPart.Position - aliveplr.RootPart.Position).magnitude or 0
				local magcheck = NameTagsRangeLimit.Value == 0 or mag <= NameTagsRangeLimit.Value 
				if magcheck then 
					local headPos, headVis = cam:WorldToViewportPoint((aliveplr.RootPart:GetRenderCFrame() * CFrame.new(0, aliveplr.Head.Size.Y + aliveplr.RootPart.Size.Y, 0)).Position)
					
					if headVis then
						thing.Visible = headVis
						thing.Position = UDim2.new(0, headPos.X - thing.Size.X.Offset / 2, 0, (headPos.Y - thing.Size.Y.Offset) - 36)
					end
				end
			end
		end
	}
	local nametagsfunc2 = {
		Normal = function(plr)
			plr = plr.Player
			local thing = NameTagsFolder:FindFirstChild(plr.Name)
			if thing then
				local aliveplr = isAlive(plr)
				if aliveplr then
					if NameTagsShowInventory.Enabled then 
						local inventory = inventories[plr] or {armor = {}}
						if inventory.hand then
							thing.Hand.Image = bedwars.getIcon(inventory.hand, NameTagsShowInventory.Enabled)
							if thing.Hand.Image:find("rbxasset://") then
								thing.Hand.ResampleMode = Enum.ResamplerMode.Pixelated
							end
						else
							thing.Hand.Image = ""
						end
						if inventory.armor[4] then
							thing.Helmet.Image = bedwars.getIcon(inventory.armor[4], NameTagsShowInventory.Enabled)
							if thing.Helmet.Image:find("rbxasset://") then
								thing.Helmet.ResampleMode = Enum.ResamplerMode.Pixelated
							end
						else
							thing.Helmet.Image = ""
						end
						if inventory.armor[5] then
							thing.Chestplate.Image = bedwars.getIcon(inventory.armor[5], NameTagsShowInventory.Enabled)
							if thing.Chestplate.Image:find("rbxasset://") then
								thing.Chestplate.ResampleMode = Enum.ResamplerMode.Pixelated
							end
						else
							thing.Chestplate.Image = ""
						end
						if inventory.armor[6] then
							thing.Boots.Image = bedwars.getIcon(inventory.armor[6], NameTagsShowInventory.Enabled)
							if thing.Boots.Image:find("rbxasset://") then
								thing.Boots.ResampleMode = Enum.ResamplerMode.Pixelated
							end
						else
							thing.Boots.Image = ""
						end
					end
					local istarget = false
					if bedwars["BountyHunterTarget"] == plr then
						istarget = true
					end
					local displaynamestr = (NameTagsDisplayName.Enabled and plr.DisplayName ~= nil and plr.DisplayName or plr.Name)
					local displaynamestr2 = displaynamestr
					if WhitelistFunctions:CheckPlayerType(plr) ~= "DEFAULT" or WhitelistFunctions.WhitelistTable.chattags[WhitelistFunctions:Hash(plr.Name..plr.UserId)] or clients.ClientUsers[plr.Name] then
						displaynamestr2 = getNametagString(plr)
						displaynamestr = removeTags(displaynamestr2)
					end
					local blocksaway = math.floor(((entityLibrary.isAlive and entityLibrary.character.HumanoidRootPart.Position or Vector3.new(0, 0, 0)) - aliveplr.RootPart.Position).Magnitude / 3)
					local rawText = (istarget and "[TARGET] " or "")..(NameTagsDistance.Enabled and entityLibrary.isAlive and "["..blocksaway.."] " or "")..displaynamestr..(NameTagsHealth.Enabled and " "..math.floor((aliveplr.Humanoid.Health + getShield(aliveplr.Character))) or "")
					local color = HealthbarColorTransferFunction((aliveplr.Humanoid.Health + getShield(aliveplr.Character)) / aliveplr.Humanoid.MaxHealth)
					local modifiedText = (istarget and '<font color="rgb(255, 0, 0)">[TARGET]</font> ' or '')..(NameTagsDistance.Enabled and entityLibrary.isAlive and '<font color="rgb(85, 255, 85)">[</font><font color="rgb(255, 255, 255)">'..blocksaway..'</font><font color="rgb(85, 255, 85)">]</font> ' or '')..displaynamestr2..(NameTagsHealth.Enabled and ' <font color="rgb('..tostring(math.floor(color.R * 255))..','..tostring(math.floor(color.G * 255))..','..tostring(math.floor(color.B * 255))..')">'..math.floor((aliveplr.Humanoid.Health + getShield(aliveplr.Character))).."</font>" or '')
					local nametagSize = textservice:GetTextSize(rawText, thing.TextSize, thing.Font, Vector2.new(9e9, 9e9))
					thing.Size = UDim2.new(0, nametagSize.X + 4, 0, nametagSize.Y)
					thing.Font = Enum.Font[NameTagsFont.Value]
					thing.TextSize = 14 * (NameTagsScale.Value / 10)
					thing.BackgroundTransparency = NameTagsBackground.Enabled and 0.5 or 1
					thing.Text = modifiedText
					thing.TextColor3 = getPlayerColor(plr) or Color3.fromHSV(NameTagsColor["Hue"], NameTagsColor["Sat"], NameTagsColor.Value)
				end
			end
		end,
		Drawing = function(plr)
			plr = plr.Player
			local thing = nametagsfolderdrawing[plr.Name]
			if thing then
				local aliveplr = isAlive(plr)
				if aliveplr then
					local istarget = false
					if bedwars["BountyHunterTarget"] == plr then
						istarget = true
					end
					local displaynamestr = (NameTagsDisplayName.Enabled and plr.DisplayName ~= nil and plr.DisplayName or plr.Name)
					local displaynamestr2 = displaynamestr
					if WhitelistFunctions:CheckPlayerType(plr) ~= "DEFAULT" or WhitelistFunctions.WhitelistTable.chattags[WhitelistFunctions:Hash(plr.Name..plr.UserId)] or clients.ClientUsers[plr.Name] then
						displaynamestr2 = getNametagString(plr)
						displaynamestr = removeTags(displaynamestr2)
					end
					local blocksaway = math.floor(((entityLibrary.isAlive and entityLibrary.character.HumanoidRootPart.Position or Vector3.new(0, 0, 0)) - aliveplr.RootPart.Position).Magnitude / 3)
					local rawText = (istarget and "[TARGET] " or "")..(NameTagsDistance.Enabled and entityLibrary.isAlive and "["..blocksaway.."] " or "")..displaynamestr..(NameTagsHealth.Enabled and " "..math.floor((aliveplr.Humanoid.Health + getShield(aliveplr.Character))) or "")
					local color = HealthbarColorTransferFunction((aliveplr.Humanoid.Health + getShield(aliveplr.Character)) / aliveplr.Humanoid.MaxHealth)
					local modifiedText = (istarget and '[TARGET] ' or '')..(NameTagsDistance.Enabled and entityLibrary.isAlive and '['..blocksaway..'] ' or '')..displaynamestr2..(NameTagsHealth.Enabled and ' '..math.floor((aliveplr.Humanoid.Health + getShield(aliveplr.Character))).."" or '')
					thing.Text.Text = removeTags(modifiedText)
					thing.Text.Size = 17 * (NameTagsScale.Value / 10)
					thing.Text.Color = getPlayerColor(plr) or Color3.fromHSV(NameTagsColor["Hue"], NameTagsColor["Sat"], NameTagsColor.Value)
					thing.Text.Font = (math.clamp((table.find(fontitems, NameTagsFont.Value) or 1) - 1, 0, 3))
					thing.BG.Size = floorpos(Vector2.new(thing.Text.TextBounds.X + 4, thing.Text.TextBounds.Y))
				end
			end
		end
	}

	local NameTags = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "NameTags",
		Function = function(callback) 
			if callback then
				nametagconnection = players.PlayerRemoving:Connect(function(plr)
					if NameTagsFolder:FindFirstChild(plr.Name) then
						NameTagsFolder[plr.Name]:Remove()
					end
					if nametagsfolderdrawing[plr.Name] then 
						pcall(function()
							nametagsfolderdrawing[plr.Name].Text:Remove()
							nametagsfolderdrawing[plr.Name].BG:Remove()
							nametagsfolderdrawing[plr.Name] = nil
						end)
					end
				end)
				nametagconnection2 = entityLibrary.entityUpdatedEvent:Connect(function(plr)
					nametagsfunc2[NameTagsDrawing.Enabled and "Drawing" or "Normal"](plr)
				end)
				RunLoops:BindToRenderStep("NameTags", 500, function()
					local starttime = tick()
					for i,plr in pairs(players:GetPlayers()) do
						nametagsfunc[NameTagsDrawing.Enabled and "Drawing" or "Normal"](plr)
					end
				end)
			else
				if nametagconnection then nametagconnection:Disconnect() end
				RunLoops:UnbindFromRenderStep("NameTags") 
				NameTagsFolder:ClearAllChildren()
				for i,v in pairs(nametagsfolderdrawing) do 
					pcall(function()
						nametagsfolderdrawing[i].Text:Remove()
						nametagsfolderdrawing[i].BG:Remove()
						nametagsfolderdrawing[i] = nil
					end)
				end
			end
		end,
		HoverText = "Renders nametags on entities through walls."
	})
	for i,v in pairs(Enum.Font:GetEnumItems()) do 
		if v.Name ~= "SourceSans" then 
			table.insert(fontitems, v.Name)
		end
	end
	NameTagsFont = NameTags.CreateDropdown({
		Name = "Font",
		List = fontitems,
		Function = function() end,
	})
	NameTagsColor = NameTags.CreateColorSlider({
		Name = "Player Color",
		Function = function(val) end
	})
	NameTagsScale = NameTags.CreateSlider({
		Name = "Scale",
		Function = function(val) end,
		Default = 10,
		Min = 1,
		Max = 50
	})
	NameTagsRangeLimit = NameTags.CreateSlider({
		Name = "Range",
		Function = function() end,
		Min = 0,
		Max = 1000,
		Default = 0
	})
	NameTagsBackground = NameTags.CreateToggle({
		Name = "Background", 
		Function = function() end,
		Default = true
	})
	NameTagsTeammates = NameTags.CreateToggle({
		Name = "Show Teammates",
		Function = function() end,
		Default = true
	})
	NameTagsDisplayName = NameTags.CreateToggle({
		Name = "Use Display Name",
		Function = function() end,
		Default = true
	})
	NameTagsHealth = NameTags.CreateToggle({
		Name = "Health",
		Function = function() end,
		Default = true
	})
	NameTagsDistance = NameTags.CreateToggle({
		Name = "Distance",
		Function = function(callback) 
			if callback then 
				task.spawn(function()
					repeat
						task.wait()
						for i,v in pairs(entityLibrary.entityList) do 
							entityLibrary.entityUpdatedEvent:Fire(v)
						end
					until (not NameTagsDistance.Enabled)
				end)
			end
		end,
	})
	NameTagsShowInventory = NameTags.CreateToggle({
		Name = "Equipment",
		Function = function() 
			NameTagsFolder:ClearAllChildren()
			for i,v in pairs(nametagsfolderdrawing) do 
				pcall(function()
					nametagsfolderdrawing[i].Text:Remove()
					nametagsfolderdrawing[i].BG:Remove()
					nametagsfolderdrawing[i] = nil
				end)
			end
		end,
		Default = true
	})
	NameTagsDrawing = NameTags.CreateToggle({
		Name = "Drawing",
		Function = function() 
			NameTagsFolder:ClearAllChildren()
			for i,v in pairs(nametagsfolderdrawing) do 
				pcall(function()
					nametagsfolderdrawing[i].Text:Remove()
					nametagsfolderdrawing[i].BG:Remove()
					nametagsfolderdrawing[i] = nil
				end)
			end
		end,
	})
	NameTagsAlive = NameTags.CreateToggle({
		Name = "Alive Check",
		Function = function() end
	})
end)

runcode(function()
	local espadded 
	local espremoved
	local espobjs = {}
	local espfold = Instance.new("Folder")
	espfold.Parent = GuiLibrary["MainGui"]

	local function espadd(v)
		espobjs[v] = Instance.new("ImageLabel")
		espobjs[v].BackgroundTransparency = 0.5
		espobjs[v].BorderSizePixel = 0
		espobjs[v].Image = bedwars.getIcon({itemType = "iron"}, true)
		espobjs[v].BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		espobjs[v].Size = UDim2.new(0, 32, 0, 32)
		espobjs[v].AnchorPoint = Vector2.new(0.5, 0.5)
		espobjs[v].Parent = espfold
		local uicorner = Instance.new("UICorner")
		uicorner.CornerRadius = UDim.new(0, 4)
		uicorner.Parent = espobjs[v]
	end

	GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "MetalESP",
		Function = function(callback) 
			if callback then
				espadded = collectionservice:GetInstanceAddedSignal("hidden-metal"):Connect(function(v)
					espadd(v)
				end)
				espremoved = collectionservice:GetInstanceRemovedSignal("hidden-metal"):Connect(function(v)
					if espobjs[v] then
						table.remove(espobjs, table.find(espobjs, v))
						espobjs[v]:Destroy()
					end
				end)
				for i,v in pairs(collectionservice:GetTagged("hidden-metal")) do 
					espadd(v)
				end
				RunLoops:BindToRenderStep("MetalESP", 1, function()
					for i,v in pairs(espobjs) do 
						if i and i.PrimaryPart then 
							local headPos, headVis = cam:WorldToScreenPoint(i.PrimaryPart:GetRenderCFrame().p)
							v.Visible = headVis
							v.Position = UDim2.new(0, headPos.X, 0, headPos.Y)
						end
					end
				end)
			else
				RunLoops:UnbindFromRenderStep("MetalESP")
				if espadded then espadded:Disconnect() end
				if espremoved then espremoved:Disconnect() end
				espfold:ClearAllChildren()
				espobjs = {}
			end
		end
	})
end)

runcode(function()
	local function getallblocks2(pos, normal)
		local blocks = {}
		local lastfound = nil
		for i = 1, 20 do
			local blockpos = (pos + (Vector3.FromNormalId(normal) * (i * 3)))
			local extrablock = getblock(blockpos)
			local covered = true
			if extrablock and extrablock.Parent ~= nil then
				if bedwars.BlockController:isBlockBreakable({["blockPosition"] = blockpos}, lplr) then
					table.insert(blocks, extrablock.Name)
				else
					table.insert(blocks, "unbreakable")
					break
				end
				lastfound = extrablock
				if covered == false then
					break
				end
			else
				break
			end
		end
		return blocks
	end

	local function getallbedblocks(pos)
		local blocks = {}
		for i,v in pairs(normalsides) do
			for i2,v2 in pairs(getallblocks2(pos, v)) do	
				if table.find(blocks, v2) == nil and v2 ~= "bed" then
					table.insert(blocks, v2)
				end
			end
			for i2,v2 in pairs(getallblocks2(pos + Vector3.new(0, 0, 3), v)) do	
				if table.find(blocks, v2) == nil and v2 ~= "bed" then
					table.insert(blocks, v2)
				end
			end
		end
		return blocks
	end

	local function refreshAdornee(v)
		local bedblocks = getallbedblocks(v.Adornee.Position)
		for i2,v2 in pairs(v.Frame:GetChildren()) do
			if v2:IsA("ImageLabel") then
				v2:Remove()
			end
		end
		for i3,v3 in pairs(bedblocks) do
			local blockimage = Instance.new("ImageLabel")
			blockimage.Size = UDim2.new(0, 32, 0, 32)
			blockimage.BackgroundTransparency = 1
			blockimage.Image = bedwars.getIcon({itemType = v3}, true)
			blockimage.Parent = v.Frame
		end
	end

	local BedPlatesFolder = Instance.new("Folder")
	BedPlatesFolder.Name = "BedPlatesFolder"
	BedPlatesFolder.Parent = GuiLibrary["MainGui"]
	local BedPlates = {Enabled = false}
	task.spawn(function()
		bedwars["ClientHandlerDamageBlock"]:WaitFor("PlaceBlockEvent"):andThen(function(p4)
			connectionstodisconnect[#connectionstodisconnect + 1] = p4:Connect(function(p5)
				if not BedPlates.Enabled then return end
				for i,v in pairs(BedPlatesFolder:GetChildren()) do 
					if v.Adornee then
						if ((p5.blockRef.blockPosition * 3) - v.Adornee.Position).magnitude <= 20 then
							refreshAdornee(v)
						end
					end
				end
			end)
		end)
		bedwars["ClientHandlerDamageBlock"]:WaitFor("BreakBlockEvent"):andThen(function(p4)
			connectionstodisconnect[#connectionstodisconnect + 1] = p4:Connect(function(p5)
				if not BedPlates.Enabled then return end
				for i,v in pairs(BedPlatesFolder:GetChildren()) do 
					if v.Adornee then
						if ((p5.blockRef.blockPosition * 3) - v.Adornee.Position).magnitude <= 20 then
							refreshAdornee(v)
						end
					end
				end
			end)
		end)
	end)
	BedPlates = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "BedPlates",
		Function = function(callback)
			if callback then
				task.spawn(function()
					repeat task.wait() until #collectionservice:GetTagged("bed") > 0
					if BedPlates.Enabled then
						for i,v in pairs(collectionservice:GetTagged("bed")) do
							local billboard = Instance.new("BillboardGui")
							billboard.Parent = BedPlatesFolder
							billboard.Name = "bed"
							billboard.StudsOffsetWorldSpace = Vector3.new(0, 3, 1.5)
							billboard.Size = UDim2.new(0, 42, 0, 42)
							billboard.AlwaysOnTop = true
							billboard.Adornee = v
							local frame = Instance.new("Frame")
							frame.Size = UDim2.new(1, 0, 1, 0)
							frame.BackgroundColor3 = Color3.new(0, 0, 0)
							frame.BackgroundTransparency = 0.5
							frame.Parent = billboard
							local uilistlayout = Instance.new("UIListLayout")
							uilistlayout.FillDirection = Enum.FillDirection.Horizontal
							uilistlayout.Padding = UDim.new(0, 4)
							uilistlayout.VerticalAlignment = Enum.VerticalAlignment.Center
							uilistlayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
							uilistlayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
								billboard.Size = UDim2.new(0, math.max(uilistlayout.AbsoluteContentSize.X + 12, 42), 0, 42)
							end)
							uilistlayout.Parent = frame
							local uicorner = Instance.new("UICorner")
							uicorner.CornerRadius = UDim.new(0, 4)
							uicorner.Parent = frame
							refreshAdornee(billboard)
						end
					end
				end)
			else
				BedPlatesFolder:ClearAllChildren()
			end
		end
	})
end)

runcode(function()
	local MissileTP = {Enabled = false}
	local MissileTeleportDelaySlider = {Value = 30}
	MissileTP = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "MissileTP",
		Function = function(callback)
			if callback then
				task.spawn(function()
					if getItem("guided_missile") then
						local plr = GetNearestHumanoidToMouse(true, 1000)
						if plr then
							local projectile = bedwars["RuntimeLib"].await(bedwars["MissileController"].fireGuidedProjectile:CallServerAsync("guided_missile"))
							if projectile then
								local projectilemodel = projectile.model;
								if not projectilemodel.PrimaryPart then
									projectilemodel:GetPropertyChangedSignal("PrimaryPart"):Wait();
								end;
								local bodyforce = Instance.new("BodyForce")
								bodyforce.Force = Vector3.new(0, projectilemodel.PrimaryPart.AssemblyMass * workspace.Gravity, 0)
								bodyforce.Name = "AntiGravity"
								bodyforce.Parent = projectilemodel.PrimaryPart

								repeat
									task.wait()
									local aliveplr = isAlive(plr, true)
									if projectile.model then
										if aliveplr then
											projectile.model:SetPrimaryPartCFrame(CFrame.new(aliveplr.RootPart.CFrame.p, aliveplr.RootPart.CFrame.p + cam.CFrame.lookVector))
										else
											createwarning("MissileTP", "Player died before it could TP.", 3)
											break
										end
									end
								until projectile.model.Parent == nil
							else
								createwarning("MissileTP", "Missile on cooldown.", 3)
							end
						else
							createwarning("MissileTP", "Player not found.", 3)
						end
					else
						createwarning("MissileTP", "Missile not found.", 3)
					end
				end)
				MissileTP.ToggleButton(true)
			end
		end,
		HoverText = "Spawns and teleports a missile to a player\nnear your mouse."
	})

	local RavenTP = {Enabled = false}
	RavenTP = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "RavenTP",
		Function = function(callback)
			if callback then
				task.spawn(function()
					if getItem("raven") then
						local plr = GetNearestHumanoidToMouse(true, 1000)
						if plr then
							local projectile = bedwars.ClientHandler:Get(bedwars["SpawnRavenRemote"]):CallServerAsync():andThen(function(projectile)
								if projectile then
									local projectilemodel = projectile
									if not projectilemodel then
										projectilemodel:GetPropertyChangedSignal("PrimaryPart"):Wait()
									end
									local bodyforce = Instance.new("BodyForce")
									bodyforce.Force = Vector3.new(0, projectilemodel.PrimaryPart.AssemblyMass * workspace.Gravity, 0)
									bodyforce.Name = "AntiGravity"
									bodyforce.Parent = projectilemodel.PrimaryPart
	
									local aliveplr = isAlive(plr.Player, true)
									if aliveplr then
										projectilemodel:SetPrimaryPartCFrame(CFrame.new(aliveplr.RootPart.CFrame.p, aliveplr.RootPart.CFrame.p + cam.CFrame.lookVector))
										task.wait(0.3)
										bedwars["RavenTable"]:detonateRaven()
									else
										createwarning("RavenTP", "Player died before it could TP.", 3)
									end
								else
									createwarning("RavenTP", "Raven on cooldown.", 3)
								end
							end)
						else
							createwarning("RavenTP", "Player not found.", 3)
						end
					else
						createwarning("RavenTP", "Raven not found.", 3)
					end
				end)
				RavenTP.ToggleButton(true)
			end
		end,
		HoverText = "Spawns and teleports a raven to a player\nnear your mouse."
	})
end)

runcode(function()
	local nobobdepth = {Value = 8}
	local nobobhorizontal = {Value = 8}
	local rotationx = {Value = 0}
	local rotationy = {Value = 0}
	local rotationz = {Value = 0}
	local oldc1
	nobob = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "NoBob",
		Function = function(callback) 
			if cam:FindFirstChild("Viewmodel") then
				if callback then
					lplr.PlayerScripts.TS.controllers.global.viewmodel["viewmodel-controller"]:SetAttribute("ConstantManager_DEPTH_OFFSET", -(nobobdepth.Value / 10))
					lplr.PlayerScripts.TS.controllers.global.viewmodel["viewmodel-controller"]:SetAttribute("ConstantManager_HORIZONTAL_OFFSET", (nobobhorizontal.Value / 10))
					pcall(function()
						for i,v in pairs(cam.Viewmodel.Humanoid.Animator:GetPlayingAnimationTracks()) do 
							v:Stop()
						end
					end)
					bedwars.ViewmodelController:playAnimation(11)
					oldc1 = cam.Viewmodel.RightHand.RightWrist.C1
					cam.Viewmodel.RightHand.RightWrist.C1 = oldc1 * CFrame.Angles(math.rad(rotationx.Value), math.rad(rotationy.Value), math.rad(rotationz.Value))
				else
					lplr.PlayerScripts.TS.controllers.global.viewmodel["viewmodel-controller"]:SetAttribute("ConstantManager_DEPTH_OFFSET", 0)
					lplr.PlayerScripts.TS.controllers.global.viewmodel["viewmodel-controller"]:SetAttribute("ConstantManager_HORIZONTAL_OFFSET", 0)
					pcall(function()
						for i,v in pairs(cam.Viewmodel.Humanoid.Animator:GetPlayingAnimationTracks()) do 
							v:Stop()
						end
					end)
					bedwars.ViewmodelController:playAnimation(11)
					cam.Viewmodel.RightHand.RightWrist.C1 = oldc1
				end
			end
		end,
		HoverText = "Removes the ugly bobbing when you move and makes sword farther"
	})
	nobobdepth = nobob.CreateSlider({
		Name = "Depth",
		Min = 0,
		Max = 24,
		Default = 8,
		Function = function(val)
			if nobob.Enabled then
				lplr.PlayerScripts.TS.controllers.global.viewmodel["viewmodel-controller"]:SetAttribute("ConstantManager_DEPTH_OFFSET", -(val / 10))
			end
		end
	})
	nobobhorizontal = nobob.CreateSlider({
		Name = "Horizontal",
		Min = 0,
		Max = 24,
		Default = 8,
		Function = function(val)
			if nobob.Enabled then
				lplr.PlayerScripts.TS.controllers.global.viewmodel["viewmodel-controller"]:SetAttribute("ConstantManager_HORIZONTAL_OFFSET", (val / 10))
			end
		end
	})
	rotationx = nobob.CreateSlider({
		Name = "RotX",
		Min = 0,
		Max = 360,
		Function = function(val)
			if nobob.Enabled then
				cam.Viewmodel.RightHand.RightWrist.C1 = oldc1 * CFrame.Angles(math.rad(rotationx.Value), math.rad(rotationy.Value), math.rad(rotationz.Value))
			end
		end
	})
	rotationy = nobob.CreateSlider({
		Name = "RotY",
		Min = 0,
		Max = 360,
		Function = function(val)
			if nobob.Enabled then
				cam.Viewmodel.RightHand.RightWrist.C1 = oldc1 * CFrame.Angles(math.rad(rotationx.Value), math.rad(rotationy.Value), math.rad(rotationz.Value))
			end
		end
	})
	rotationz = nobob.CreateSlider({
		Name = "RotZ",
		Min = 0,
		Max = 360,
		Function = function(val)
			if nobob.Enabled then
				cam.Viewmodel.RightHand.RightWrist.C1 = oldc1 * CFrame.Angles(math.rad(rotationx.Value), math.rad(rotationy.Value), math.rad(rotationz.Value))
			end
		end
	})
end)

local oldfish
GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
	Name = "FishermanExploit",
	Function = function(callback) 
		if callback then
			oldfish = bedwars["FishermanTable"].startMinigame
			bedwars["FishermanTable"].startMinigame = function(Self, dropdata, func) func({win = true}) end
		else
			bedwars["FishermanTable"].startMinigame = oldfish
			oldfish = nil
		end
	end,
	HoverText = "Succeeds at fishing everytime"
})

runcode(function()
	local tiered = {}
	local nexttier = {}
	for i,v in pairs(bedwars["ShopItems"]) do
		if type(v) == "table" then 
		if v["tiered"] then
			tiered[v.itemType] = v["tiered"]
		end
		if v["nextTier"] then
			nexttier[v.itemType] = v["nextTier"]
		end
	end
	end
	local TierBypass = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "ShopTierBypass",
		Function = function(callback) 
			if callback then
				for i,v in pairs(bedwars["ShopItems"]) do
					if type(v) == "table" then 
					v["tiered"] = nil
					v["nextTier"] = nil
					end
				end
			else
				for i,v in pairs(bedwars["ShopItems"]) do
					if type(v) == "table" then 
					if tiered[v.itemType] then
						v["tiered"] = tiered[v.itemType]
					end
					if nexttier[v.itemType] then
						v["nextTier"] = nexttier[v.itemType]
					end
				end
				end
			end
		end,
		HoverText = "Allows you to access tiered items early."
	})
end)

runcode(function()
	local antivoidpart
	local antivoidconnection
	local antivoiddelay = {Value = 10}
	local antivoidlegit = {Enabled = false}
	local balloondebounce = false
	local AutoBalloon = {Enabled = false}
	AutoBalloon = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "AutoBalloon", 
		Function = function(callback)
			if callback then
				task.spawn(function()
					repeat task.wait() until matchState ~= 0 or uninjectflag
					if (not uninjectflag) and antivoidypos == 0 and AutoBalloon.Enabled then
						local lowestypos = 99999
						for i,v in pairs(bedwarsblocks) do 
							local newray = workspace:Raycast(v.Position + Vector3.new(0, 800, 0), Vector3.new(0, -1000, 0), blockraycast)
							if i % 200 == 0 then 
								task.wait(0.06)
							end
							if newray and newray.Position.Y <= lowestypos then
								lowestypos = newray.Position.Y
							end
						end
						antivoidypos = lowestypos - 8
					end
				end)
				task.spawn(function()
					repeat task.wait() until antivoidypos ~= 0
					if AutoBalloon.Enabled then
						antivoidpart = Instance.new("Part")
						antivoidpart.CanCollide = false
						antivoidpart.Size = Vector3.new(10000, 1, 10000)
						antivoidpart.Anchored = true
						antivoidpart.Transparency = 1
						antivoidpart.Material = Enum.Material.Neon
						antivoidpart.Color = Color3.fromRGB(135, 29, 139)
						antivoidpart.Position = Vector3.new(0, antivoidypos - 50, 0)
						antivoidconnection = antivoidpart.Touched:Connect(function(touchedpart)
							if entityLibrary.isAlive and touchedpart:IsDescendantOf(lplr.Character) and balloondebounce == false then
								balloondebounce = true
								local oldtool = getEquipped().Object
								for i = 1, 3 do
									if getItem("balloon") and (antivoidlegit.Enabled and getHotbarSlot("balloon") or antivoidlegit.Enabled == false) and (lplr.Character:GetAttribute("InflatedBalloons") and lplr.Character:GetAttribute("InflatedBalloons") < 3 or lplr.Character:GetAttribute("InflatedBalloons") == nil) then
										if antivoidlegit.Enabled then
											if getHotbarSlot("balloon") then
												bedwars.ClientStoreHandler:dispatch({
													type = "InventorySelectHotbarSlot", 
													slot = getHotbarSlot("balloon")
												})
												task.wait(antivoiddelay.Value / 100)
												bedwars.BalloonController["inflateBalloon"]()
											end
										else
											task.wait(antivoiddelay.Value / 100)
											bedwars.BalloonController["inflateBalloon"]()
										end
									end
								end
								if antivoidlegit.Enabled and oldtool and getHotbarSlot(oldtool.Name) then
									task.wait(0.2)
									bedwars.ClientStoreHandler:dispatch({
										type = "InventorySelectHotbarSlot", 
										slot = (getHotbarSlot(oldtool.Name) or 0)
									})
								end
								balloondebounce = false
							end
						end)
						antivoidpart.Parent = workspace
					end
				end)
			else
				if antivoidconnection then antivoidconnection:Disconnect() end
				if antivoidpart then
					antivoidpart:Remove() 
				end
			end
		end, 
		HoverText = "Automatically Inflates Balloons"
	})
	antivoiddelay = AutoBalloon.CreateSlider({
		Name = "Delay",
		Min = 1,
		Max = 50,
		Default = 20,
		Function = function() end,
		HoverText = "Delay to inflate balloons."
	})
	antivoidlegit = AutoBalloon.CreateToggle({
		Name = "Legit Mode",
		Function = function() end,
		HoverText = "Switches to balloons in hotbar and inflates them."
	})
end)

runcode(function()
	local AnticheatBypassTransparent = {Enabled = false}
	local AnticheatBypassAlternate = {Enabled = false}
	local AnticheatBypassNotification = {Enabled = false}
	local AnticheatBypassAnimation = {Enabled = true}
	local AnticheatBypassAnimationCustom = {Value = ""}
	local AnticheatBypassDisguise = {Enabled = false}
	local AnticheatBypassDisguiseCustom = {Value = ""}
	local AnticheatBypassArrowDodge = {Enabled = false}
	local AnticheatBypassAutoConfig = {Enabled = false}
	local AnticheatBypassAutoConfigBig = {Enabled = false}
	local AnticheatBypassAutoConfigSpeed = {Value = 54}
	local AnticheatBypassAutoConfigSpeed2 = {Value = 54}
	local AnticheatBypassTPSpeed = {Value = 13}
	local AnticheatBypassTPLerp = {Value = 50}
	local clone
	local changed = false
	local justteleported = false
	local anticheatconnection
	local anticheatconnection2
	local playedanim = ""
	local hip

	local function finishcframe(cframe)
		return shared.VapeOverrideAnticheatBypassCFrame and shared.VapeOverrideAnticheatBypassCFrame(cframe) or cframe
	end

	local function check()
		if clone and oldcloneroot and (oldcloneroot.Position - clone.Position).magnitude >= (AnticheatBypassNumbers.TPCheck * getSpeedMultiplier()) then
			clone.CFrame = oldcloneroot.CFrame
		end
	end

	local clonesuccess = false
	local doing = false
	local function disablestuff()
		if uninjectflag then return end
		repeat task.wait() until entityLibrary.isAlive
		if not AnticheatBypass.Enabled then doing = false return end
		oldcloneroot = entityLibrary.character.HumanoidRootPart
		lplr.Character.Parent = game
		clone = oldcloneroot:Clone()
		clone.Parent = lplr.Character
		oldcloneroot.Parent = cam
		bedwars["QueryUtil"]:setQueryIgnored(oldcloneroot, true)
		oldcloneroot.Transparency = AnticheatBypassTransparent.Enabled and 1 or 0
		clone.CFrame = oldcloneroot.CFrame
		lplr.Character.PrimaryPart = clone
		lplr.Character.Parent = workspace
		for i,v in pairs(lplr.Character:GetDescendants()) do 
			if v:IsA("Weld") or v:IsA("Motor6D") then 
				if v.Part0 == oldcloneroot then v.Part0 = clone end
				if v.Part1 == oldcloneroot then v.Part1 = clone end
			end
			if v:IsA("BodyVelocity") then 
				v:Destroy()
			end
		end
		for i,v in pairs(oldcloneroot:GetChildren()) do 
			if v:IsA("BodyVelocity") then 
				v:Destroy()
			end
		end
		if hip then 
			lplr.Character.Humanoid.HipHeight = hip
		end
		hip = lplr.Character.Humanoid.HipHeight
		local bodyvelo = Instance.new("BodyVelocity")
		bodyvelo.MaxForce = Vector3.new(0, 9e9, 0)
		bodyvelo.Velocity = Vector3.zero
		bodyvelo.Parent = oldcloneroot
		pcall(function()
			RunLoops:UnbindFromHeartbeat("AnticheatBypass")
		end)
		local oldseat 
		local oldseattab = Instance.new("BindableEvent")
		RunLoops:BindToHeartbeat("AnticheatBypass", 1, function()
			if oldcloneroot and clone then
				oldcloneroot.AssemblyAngularVelocity = clone.AssemblyAngularVelocity
				if disabletpcheck then
					oldcloneroot.Velocity = clone.Velocity
				else
					local sit = entityLibrary.character.Humanoid.Sit
					if sit ~= oldseat then 
						if sit then 
							for i,v in pairs(workspace:GetDescendants()) do 
								if not v:IsA("Seat") then continue end
								local weld = v:FindFirstChild("SeatWeld")
								if weld and weld.Part1 == oldcloneroot then 
									weld.Part1 = clone
									pcall(function()
										for i,v in pairs(getconnections(v:GetPropertyChangedSignal("Occupant"))) do
											local newfunc = debug.getupvalue(debug.getupvalue(v.Function, 1), 3) 
											debug.setupvalue(newfunc, 4, {
												GetPropertyChangedSignal = function(self, prop)
													return oldseattab.Event
												end
											})
											newfunc()
										end
									end)
								end
							end
						else
							oldseattab:Fire(false)
						end
						oldseat = sit	
					end
					local targetvelo = (Vector3.new(clone.Position.X, 0, clone.Position.Z) - Vector3.new(oldcloneroot.Position.X, 0, oldcloneroot.Position.Z))
					local speed = ((sit or bedwars["HangGliderController"].hangGliderActive) and targetvelo.Magnitude or 20 * getSpeedMultiplier())
					targetvelo = (targetvelo.Unit == targetvelo.Unit and targetvelo.Unit or Vector3.zero) * speed
					bodyvelo.Velocity = Vector3.new(0, clone.Velocity.Y, 0)
					oldcloneroot.Velocity = Vector3.new(math.clamp(targetvelo.X, -speed, speed), clone.Velocity.Y, math.clamp(targetvelo.Z, -speed, speed))
				end
			end
		end)
		local lagbacknum = 0
		local lagbackcurrent = false
		local lagbacktime = 0
		local lagbackchanged = false
		local lagbacknotification = false
		local amountoftimes = 0
		local lastseat
		clonesuccess = true
		local pinglist = {}
		local fpslist = {}

		local function getaverageframerate()
			local frames = 0
			for i,v in pairs(fpslist) do 
				frames = frames + v
			end
			return #fpslist > 0 and (frames / (60 * #fpslist)) <= 1.2 or #fpslist <= 0 or AnticheatBypassAlternate.Enabled
		end

		local function didpingspike()
			local currentpingcheck = pinglist[1] or math.floor(tonumber(game:GetService("Stats"):FindFirstChild("PerformanceStats").Ping:GetValue()))
			for i,v in pairs(fpslist) do 
				print("anticheatbypass fps ["..i.."]: "..v)
				if v < 40 then 
					return v.." fps"
				end
			end
			for i,v in pairs(pinglist) do 
				print("anticheatbypass ping ["..i.."]: "..v)
				if v ~= currentpingcheck and math.abs(v - currentpingcheck) >= 100 then 
					return currentpingcheck.." => "..v.." ping"
				else
					currentpingcheck = v
				end
			end
			return nil
		end

		local function notlasso()
			for i,v in pairs(collectionservice:GetTagged("LassoHooked")) do 
				if v == lplr.Character then 
					return false
				end
			end
			return true
		end

		doing = false
		allowspeed = true
		task.spawn(function()
			repeat
				if (not AnticheatBypass.Enabled) then break end
				local ping = math.floor(tonumber(game:GetService("Stats"):FindFirstChild("PerformanceStats").Ping:GetValue()))
				local fps = math.floor(1 / game:GetService("RunService").RenderStepped:Wait())
				if #pinglist >= 10 then 
					table.remove(pinglist, 1)
				end
				if #fpslist >= 10 then 
					table.remove(fpslist, 1)
				end
				table.insert(pinglist, ping)
				table.insert(fpslist, fps)
				task.wait(1)
			until (not AnticheatBypass.Enabled)
		end)
		if anticheatconnection2 then anticheatconnection2:Disconnect() end
		anticheatconnection2 = lplr:GetAttributeChangedSignal("LastTeleported"):Connect(function()
			if not AnticheatBypass.Enabled then if anticheatconnection2 then anticheatconnection2:Disconnect() end end
			if not (clone and oldcloneroot) then return end
			clone.CFrame = oldcloneroot.CFrame
		end)
		shared.VapeRealCharacter = {
			Humanoid = entityLibrary.character.Humanoid,
			Head = entityLibrary.character.Head,
			HumanoidRootPart = oldcloneroot
		}
		if shared.VapeOverrideAnticheatBypassPre then 
			shared.VapeOverrideAnticheatBypassPre(lplr.Character)
		end
		repeat
			task.wait()
			if entityLibrary.isAlive then
				local oldroot = oldcloneroot
				if oldroot then
					local cloneroot = clone
					if cloneroot then
						if oldroot.Parent ~= nil and (not isnetworkowner(oldroot)) then
							if amountoftimes ~= 0 then
								amountoftimes = 0
							end
							if not lagbackchanged then
								lagbackchanged = true
								lagbacktime = tick()
								task.spawn(function()
									local pingspike = didpingspike() 
									if pingspike then
										if AnticheatBypassNotification.Enabled then
											createwarning("AnticheatBypass", "Lagspike Detected : "..pingspike, 10)
										end
									else
										if matchState ~= 2 and notlasso() then
											lagbacks = lagbacks + 1
										end
									end
									task.spawn(function()
										if AnticheatBypass.Enabled then
											AnticheatBypass.ToggleButton(false)
										end
										local oldclonecharcheck = lplr.Character
										repeat task.wait() until lplr.Character == nil or lplr.Character.Parent == nil or oldclonecharcheck ~= lplr.Character or isnetworkowner(oldroot)
										if AnticheatBypass.Enabled == false then
											AnticheatBypass.ToggleButton(false)
										end
									end)
								end)
							end
							if (tick() - lagbacktime) >= 10 and (not lagbacknotification) then
								lagbacknotification = true
								createwarning("AnticheatBypass", "You have been lagbacked for a awfully long time", 10)
							end
							cloneroot.Velocity = Vector3.zero
							oldroot.Velocity = Vector3.zero
							cloneroot.CFrame = oldroot.CFrame
						else
							lagbackchanged = false
							lagbacknotification = false
							if not shared.VapeOverrideAnticheatBypass then
								if entityLibrary.character.Humanoid.Sit ~= true then
									anticheatfunnyyes = true 
									local frameratecheck = getaverageframerate()
									local framerate = AnticheatBypassNumbers.TPSpeed <= 0.3 and frameratecheck and -0.22 or 0
									local framerate2 = AnticheatBypassNumbers.TPSpeed <= 0.3 and frameratecheck and -0.01 or 0
									framerate = math.floor((AnticheatBypassNumbers.TPLerp + framerate) * 100) / 100
									framerate2 = math.floor((AnticheatBypassNumbers.TPSpeed + framerate2) * 100) / 100
									for i = 1, 2 do 
										check()
										task.wait(i % 2 == 0 and 0.01 or 0.02)
										check()
										if oldroot and cloneroot then
											anticheatfunnyyes = false
											if (oldroot.CFrame.p - cloneroot.CFrame.p).magnitude >= 0.01 then
												if (Vector3.new(0, oldroot.CFrame.p.Y, 0) - Vector3.new(0, cloneroot.CFrame.p.Y, 0)).magnitude <= 1 then
													oldroot.CFrame = finishcframe(oldroot.CFrame:lerp(replaceYLevel(cloneroot.CFrame, oldroot.CFrame.p.Y), framerate))
												else
													oldroot.CFrame = finishcframe(oldroot.CFrame:lerp(cloneroot.CFrame, framerate))
												end
											end
										end
										check()
									end
									check()
									task.wait(combatcheck and AnticheatBypassCombatCheck.Enabled and AnticheatBypassNumbers.TPCombat or framerate2)
									check()
									if oldroot and cloneroot then
										if (oldroot.CFrame.p - cloneroot.CFrame.p).magnitude >= 0.01 then
											if (Vector3.new(0, oldroot.CFrame.p.Y, 0) - Vector3.new(0, cloneroot.CFrame.p.Y, 0)).magnitude <= 1 then
												oldroot.CFrame = finishcframe(replaceYLevel(cloneroot.CFrame, oldroot.CFrame.p.Y))
											else
												oldroot.CFrame = finishcframe(cloneroot.CFrame)
											end
										end
									end
									check()
								else
									if oldroot and cloneroot then
										oldroot.CFrame = cloneroot.CFrame
									end
								end
							end
						end
					end
				end
			end
		until AnticheatBypass.Enabled == false or oldcloneroot == nil or oldcloneroot.Parent == nil 
	end

	local spawncoro
	local function anticheatbypassenable()
		task.spawn(function()
			if spawncoro then return end
			spawncoro = true
			allowspeed = false
			shared.VapeRealCharacter = nil
			repeat task.wait() until entityLibrary.isAlive
			task.wait(0.4)
			lplr.Character:WaitForChild("Humanoid", 10)
			lplr.Character:WaitForChild("LeftHand", 10)
			lplr.Character:WaitForChild("RightHand", 10)
			lplr.Character:WaitForChild("LeftFoot", 10)
			lplr.Character:WaitForChild("RightFoot", 10)
			lplr.Character:WaitForChild("LeftLowerArm", 10)
			lplr.Character:WaitForChild("RightLowerArm", 10)
			lplr.Character:WaitForChild("LeftUpperArm", 10)
			lplr.Character:WaitForChild("RightUpperArm", 10)
			lplr.Character:WaitForChild("LeftLowerLeg", 10)
			lplr.Character:WaitForChild("RightLowerLeg", 10)
			lplr.Character:WaitForChild("LeftUpperLeg", 10)
			lplr.Character:WaitForChild("RightUpperLeg", 10)
			lplr.Character:WaitForChild("UpperTorso", 10)
			lplr.Character:WaitForChild("LowerTorso", 10)
			local root = lplr.Character:WaitForChild("HumanoidRootPart", 20)
			local head = lplr.Character:WaitForChild("Head", 20)
			task.wait(0.4)
			spawncoro = false
			if root ~= nil and head ~= nil then
				task.spawn(disablestuff)
			else
				createwarning("AnticheatBypass", "ur root / head no load L", 30)
			end
		end)
		anticheatconnection = lplr.CharacterAdded:Connect(function(char)
			task.spawn(function()
				if spawncoro then return end
				spawncoro = true
				allowspeed = false
				shared.VapeRealCharacter = nil
				repeat task.wait() until entityLibrary.isAlive
				task.wait(0.4)
				char:WaitForChild("Humanoid", 10)
				char:WaitForChild("LeftHand", 10)
				char:WaitForChild("RightHand", 10)
				char:WaitForChild("LeftFoot", 10)
				char:WaitForChild("RightFoot", 10)
				char:WaitForChild("LeftLowerArm", 10)
				char:WaitForChild("RightLowerArm", 10)
				char:WaitForChild("LeftUpperArm", 10)
				char:WaitForChild("RightUpperArm", 10)
				char:WaitForChild("LeftLowerLeg", 10)
				char:WaitForChild("RightLowerLeg", 10)
				char:WaitForChild("LeftUpperLeg", 10)
				char:WaitForChild("RightUpperLeg", 10)
				char:WaitForChild("UpperTorso", 10)
				char:WaitForChild("LowerTorso", 10)
				local root = char:WaitForChild("HumanoidRootPart", 20)
				local head = char:WaitForChild("Head", 20)
				task.wait(0.4)
				spawncoro = false
				if root ~= nil and head ~= nil then
					task.spawn(disablestuff)
				else
					createwarning("AnticheatBypass", "ur root / head no load L", 30)
				end
			end)
		end)
	end

	AnticheatBypass = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "AnticheatBypass",
		Function = function(callback)
			if callback then
				task.spawn(function()
					task.spawn(function()
						repeat task.wait() until shared.VapeFullyLoaded
						if AnticheatBypass.Enabled then
							if not GuiLibrary.ObjectsThatCanBeSaved["FlyBoost SpeedToggle"]["Api"].Enabled then 
								GuiLibrary.ObjectsThatCanBeSaved["FlyBoost SpeedToggle"]["Api"].ToggleButton(true)
							end
							if AutoReport.Enabled == false then
								AutoReport.ToggleButton(false)
							end
							if AutoReportV2.Enabled == false then
								AutoReportV2.ToggleButton(false)
							end
						end
					end)
				--	GuiLibrary.ObjectsThatCanBeSaved["SpeedSpeedSlider"]["Api"]["SetValue"](74)
				--	GuiLibrary.ObjectsThatCanBeSaved["SpeedModeDropdown"]["Api"]["SetValue"]("Heatseeker")
				--	GuiLibrary.ObjectsThatCanBeSaved["FlySpeedSlider"]["Api"]["SetValue"](74)
				--  GuiLibrary.ObjectsThatCanBeSaved["FlyModeDropdown"]["Api"]["SetValue"]("Heatseeker")
				end)
			--	anticheatbypassenable()
			else
				allowspeed = true
				if anticheatconnection then 
					anticheatconnection:Disconnect()
				end
				if anticheatconnection2 then anticheatconnection2:Disconnect() end
				pcall(function() RunLoops:UnbindFromHeartbeat("AnticheatBypass") end)
				if clonesuccess and oldcloneroot and clone and lplr.Character.Parent == workspace and oldcloneroot.Parent ~= nil then 
					lplr.Character.Parent = game
					oldcloneroot.Parent = lplr.Character
					lplr.Character.PrimaryPart = oldcloneroot
					lplr.Character.Parent = workspace
					oldcloneroot.CanCollide = true
					oldcloneroot.Transparency = 1
					for i,v in pairs(lplr.Character:GetDescendants()) do 
						if v:IsA("Weld") or v:IsA("Motor6D") then 
							if v.Part0 == clone then v.Part0 = oldcloneroot end
							if v.Part1 == clone then v.Part1 = oldcloneroot end
						end
						if v:IsA("BodyVelocity") then 
							v:Destroy()
						end
					end
					for i,v in pairs(oldcloneroot:GetChildren()) do 
						if v:IsA("BodyVelocity") then 
							v:Destroy()
						end
					end
					lplr.Character.Humanoid.HipHeight = hip or 2
				end
				if clone then 
					clone:Destroy()
					clone = nil
				end
				oldcloneroot = nil
			end
		end,
		HoverText = "Makes speed check more stupid.\n(thank you to MicrowaveOverflow.cpp#7030 for no more clone crap)",
	})
	local arrowdodgeconnection
	local arrowdodgedata
	
--[[	AnticheatBypassArrowDodge = AnticheatBypass.CreateToggle({
		Name = "Arrow Dodge",
		Function = function(callback)
			if callback then
				task.spawn(function()
					bedwars.ClientHandler:WaitFor("ProjectileLaunch"):andThen(function(p6)
						arrowdodgeconnection = p6:Connect(function(data)
							if oldchar and clone and AnticheatBypass.Enabled and (arrowdodgedata == nil or arrowdodgedata.launchVelocity ~= data.launchVelocity) and entityLibrary.isAlive and tostring(data.projectile):find("arrow") then
								arrowdodgedata = data
								local projmetatab = bedwars.ProjectileMeta[tostring(data.projectile)]
								local prediction = (projmetatab.predictionLifetimeSec or projmetatab.lifetimeSec or 3)
								local gravity = (projmetatab.gravitationalAcceleration or 196.2)
								local multigrav = gravity
								local offsetshootpos = data.position
								local pos = (oldchar.HumanoidRootPart.Position + Vector3.new(0, 0.8, 0)) 
								local calculated2 = FindLeadShot(pos, Vector3.zero, (Vector3.zero - data.launchVelocity).magnitude, offsetshootpos, Vector3.zero, multigrav) 
								local calculated = LaunchDirection(offsetshootpos, pos, (Vector3.zero - data.launchVelocity).magnitude, gravity, false)
								local initialvelo = calculated--(calculated - offsetshootpos).Unit * launchvelo
								local initialvelo2 = (calculated2 - offsetshootpos).Unit * (Vector3.zero - data.launchVelocity).magnitude
								local calculatedvelo = Vector3.new(initialvelo2.X, (initialvelo and initialvelo.Y or initialvelo2.Y), initialvelo2.Z).Unit * (Vector3.zero - data.launchVelocity).magnitude
								if (calculatedvelo - data.launchVelocity).magnitude <= 20 then 
									oldchar.HumanoidRootPart.CFrame = oldchar.HumanoidRootPart.CFrame:lerp(clone.HumanoidRootPart.CFrame, 0.6)
								end
							end
						end)
					end)
				end)
			else
				if arrowdodgeconnection then 
					arrowdodgeconnection:Disconnect()
				end
			end
		end,
		Default = true,
		HoverText = "Dodge arrows (tanqr moment)"
	})]]
	AnticheatBypassAutoConfig = AnticheatBypass.CreateToggle({
		Name = "Auto Config",
		Function = function(callback) 
			if AnticheatBypassAutoConfigSpeed.Object then 
				AnticheatBypassAutoConfigSpeed.Object.Visible = callback
			end
			if AnticheatBypassAutoConfigSpeed2.Object then 
				AnticheatBypassAutoConfigSpeed2.Object.Visible = callback
			end
			if AnticheatBypassAutoConfigBig.Object then 
				AnticheatBypassAutoConfigBig.Object.Visible = callback
			end
		end,
		Default = true
	})
	AnticheatBypassAutoConfigSpeed = AnticheatBypass.CreateSlider({
		Name = "Speed",
		Function = function() end,
		Min = 1,
		Max = GuiLibrary.ObjectsThatCanBeSaved["SpeedSpeedSlider"]["Api"]["Max"],
		Default = GuiLibrary.ObjectsThatCanBeSaved["SpeedSpeedSlider"]["Api"]["Default"]
	})
	AnticheatBypassAutoConfigSpeed.Object.BorderSizePixel = 0
	AnticheatBypassAutoConfigSpeed.Object.BackgroundTransparency = 0
	AnticheatBypassAutoConfigSpeed.Object.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	AnticheatBypassAutoConfigSpeed.Object.Visible = false
	AnticheatBypassAutoConfigSpeed2 = AnticheatBypass.CreateSlider({
		Name = "Big Mode Speed",
		Function = function() end,
		Min = 1,
		Max = GuiLibrary.ObjectsThatCanBeSaved["SpeedSpeedSlider"]["Api"]["Max"],
		Default = GuiLibrary.ObjectsThatCanBeSaved["SpeedSpeedSlider"]["Api"]["Default"]
	})
	AnticheatBypassAutoConfigSpeed2.Object.BorderSizePixel = 0
	AnticheatBypassAutoConfigSpeed2.Object.BackgroundTransparency = 0
	AnticheatBypassAutoConfigSpeed2.Object.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	AnticheatBypassAutoConfigSpeed2.Object.Visible = false
	AnticheatBypassAutoConfigBig = AnticheatBypass.CreateToggle({
		Name = "Big Mode CFrame",
		Function = function() end,
		Default = true
	})
	AnticheatBypassAutoConfigBig.Object.BorderSizePixel = 0
	AnticheatBypassAutoConfigBig.Object.BackgroundTransparency = 0
	AnticheatBypassAutoConfigBig.Object.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	AnticheatBypassAutoConfigBig.Object.Visible = false
	AnticheatBypassAlternate = AnticheatBypass.CreateToggle({
		Name = "Alternate Numbers",
		Function = function() end
	})
	AnticheatBypassTransparent = AnticheatBypass.CreateToggle({
		Name = "Transparent",
		Function = function(callback) 
			if oldcloneroot and AnticheatBypass.Enabled then
				oldcloneroot.Transparency = callback and 1 or 0
			end
		end,
		Default = true
	})
	local changecheck = false
--[[	AnticheatBypassCombatCheck = AnticheatBypass.CreateToggle({
		Name = "Combat Check",
		Function = function(callback) 
			if callback then 
				task.spawn(function()
					repeat 
						task.wait(0.1)
						if (not AnticheatBypassCombatCheck.Enabled) then break end
						if AnticheatBypass.Enabled then 
							local plrs = GetAllNearestHumanoidToPosition(true, 30, 1)
							combatcheck = #plrs > 0 and (not GuiLibrary.ObjectsThatCanBeSaved["LongJumpOptionsButton"]["Api"].Enabled) and (not GuiLibrary.ObjectsThatCanBeSaved["FlyOptionsButton"]["Api"].Enabled)
							if combatcheck ~= changecheck then 
								if not combatcheck then 
									combatchecktick = tick() + 1
								end
								changecheck = combatcheck
							end
						end
					until (not AnticheatBypassCombatCheck.Enabled)
				end)
			else
				combatcheck = false
			end
		end,
		Default = true
	})]]
	AnticheatBypassNotification = AnticheatBypass.CreateToggle({
		Name = "Notifications",
		Function = function() end,
		Default = true
	})
	if shared.VapeDeveloper then 
		AnticheatBypassTPSpeed = AnticheatBypass.CreateSlider({
			Name = "TPSpeed",
			Function = function(val) 
				AnticheatBypassNumbers.TPSpeed = val / 100
			end,
			["Double"] = 100,
			Min = 1,
			Max = 100,
			Default = AnticheatBypassNumbers.TPSpeed * 100,
		})
		AnticheatBypassTPLerp = AnticheatBypass.CreateSlider({
			Name = "TPLerp",
			Function = function(val) 
				AnticheatBypassNumbers.TPLerp = val / 100
			end,
			["Double"] = 100,
			Min = 1,
			Max = 100,
			Default = AnticheatBypassNumbers.TPLerp * 100,
		})
	end
end)

runcode(function()
	local autoheal = {Enabled = false}
	local autohealval = {Value = 100}
	local autohealspeed = {Enabled = true}
	local autohealdelay = tick()

	local function autohealfunc()
		if entityLibrary.isAlive then
			local speedpotion = getItem("speed_potion")
			if lplr.Character:GetAttribute("Health") <= (lplr.Character:GetAttribute("MaxHealth") - (100 - autohealval.Value)) then
				autobankapple = true
				local item = getItem("apple")
				local pot = getItem("heal_splash_potion")
				if (item or pot) and autohealdelay <= tick() then
					if item then
						bedwars.ClientHandler:Get(bedwars["EatRemote"]):CallServerAsync({
							["item"] = item["tool"]
						})
						autohealdelay = tick() + 0.6
					else
						local newray = workspace:Raycast((oldcloneroot or entityLibrary.character.HumanoidRootPart).Position, Vector3.new(0, -76, 0), blockraycast)
						if newray ~= nil then
							bedwars.ClientHandler:Get(bedwars["ProjectileRemote"]):CallServerAsync(pot["tool"], "heal_splash_potion", "heal_splash_potion", (oldcloneroot or entityLibrary.character.HumanoidRootPart).Position, (oldcloneroot or entityLibrary.character.HumanoidRootPart).Position, Vector3.new(0, -70, 0), game:GetService("HttpService"):GenerateGUID(), {drawDurationSeconds = 1})
						end
					end
				end
			else
				autobankapple = false
			end
			if speedpotion and (not lplr.Character:GetAttribute("StatusEffect_speed")) and autohealspeed.Enabled then 
				bedwars.ClientHandler:Get(bedwars["EatRemote"]):CallServerAsync({
					["item"] = speedpotion["tool"]
				})
			end
			if lplr.Character:GetAttribute("Shield_POTION") and ((not lplr.Character:GetAttribute("Shield_POTION")) or lplr.Character:GetAttribute("Shield_POTION") == 0) then
				local shield = getItem("big_shield") or getItem("mini_shield")
				if shield then
					bedwars.ClientHandler:Get(bedwars["EatRemote"]):CallServerAsync({
						["item"] = shield["tool"]
					})
				end
			end
		end
	end

	autoheal = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "AutoConsume",
		Function = function(callback)
			if callback then
				task.spawn(function()
					repeat
						task.wait(0.1)
						autohealfunc()
					until (not autoheal.Enabled)
				end)
			end
		end,
		HoverText = "Automatically heals for you when health or shield is under threshold."
	})
	autohealval = autoheal.CreateSlider({
		Name = "Health",
		Min = 1,
		Max = 99,
		Default = 70,
		Function = function() end
	})
	autohealspeed = autoheal.CreateToggle({
		Name = "Speed Potions",
		Function = function() end,
		Default = true
	})
end)

runcode(function()
	local AutoKit = {Enabled = false}
	local AutoKitTrinity = {Value = "Void"}
	local function GetTeammateThatNeedsMost()
		local plrs = GetAllNearestHumanoidToPosition(true, 30, 1000, true)
		local lowest, lowestplayer = 10000, nil
		for i,v in pairs(plrs) do
			if not v.Targetable then
				if v.Character:GetAttribute("Health") <= lowest and v.Character:GetAttribute("Health") < v.Character:GetAttribute("MaxHealth") then
					lowest = v.Character:GetAttribute("Health")
					lowestplayer = v
				end
			end
		end
		return lowestplayer
	end

	task.spawn(function()
		bedwars.ClientHandler:WaitFor("AngelProgress"):andThen(function(p6)
			connectionstodisconnect[#connectionstodisconnect + 1] = p6:Connect(function(p3)
				task.wait(0.5)
				if not AutoKit.Enabled then return end
				if bedwars.ClientStoreHandler:getState().Kit.angelProgress >= 1 and lplr.Character:GetAttribute("AngelType") == nil then
					bedwars.ClientHandler:Get(bedwars["TrinityRemote"]):SendToServer({
						angel = AutoKitTrinity.Value
					})
				end
			end)
		end)
	end)

	AutoKit = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "AutoKit",
		Function = function(callback)
			if callback then
				task.spawn(function()
					repeat task.wait() until kit ~= ""
					if AutoKit.Enabled then
						if kit == "melody" then
							task.spawn(function()
								repeat
									task.wait(0.1)
									if getItem("guitar") then
										local plr = GetTeammateThatNeedsMost()
										if plr and healtick <= tick() then
											bedwars.ClientHandler:Get(bedwars["GuitarHealRemote"]):SendToServer({
												healTarget = plr.Character
											})
											healtick = tick() + 2
										end
									end
								until (not AutoKit.Enabled)
							end)
						elseif kit == "bigman" then
							task.spawn(function()
								repeat
									task.wait()
									local itemdrops = collectionservice:GetTagged("treeOrb")
									for i,v in pairs(itemdrops) do
										if entityLibrary.isAlive and AutoKit.Enabled and v:FindFirstChild("Spirit") and (entityLibrary.character.HumanoidRootPart.Position - v.Spirit.Position).magnitude <= 20 then
											if bedwars.ClientHandler:Get(bedwars["TreeRemote"]):CallServer({
												treeOrbSecret = v:GetAttribute("TreeOrbSecret")
											}) then
												v:Destroy()
												collectionservice:RemoveTag(v, "treeOrb")
											end
										end
									end
								until (not AutoKit.Enabled)
							end)
						elseif kit == "metal_detector" then
							task.spawn(function()
								repeat
									task.wait()
									local itemdrops = collectionservice:GetTagged("hidden-metal")
									for i,v in pairs(itemdrops) do
										if entityLibrary.isAlive and AutoKit.Enabled and v.PrimaryPart and (entityLibrary.character.HumanoidRootPart.Position - v.PrimaryPart.Position).magnitude <= 20 then
											bedwars.ClientHandler:Get(bedwars["PickupMetalRemote"]):SendToServer({
												id = v:GetAttribute("Id")
											}) 
										end
									end
								until (not AutoKit.Enabled)
							end)
						elseif kit == "battery" then 
							task.spawn(function()
								repeat
									task.wait()
									local itemdrops = bedwars["BatteryEffectController"].liveBatteries
									for i,v in pairs(itemdrops) do
										if entityLibrary.isAlive and AutoKit.Enabled and (entityLibrary.character.HumanoidRootPart.Position - v.position).magnitude <= 10 then
											bedwars.ClientHandler:Get(bedwars["BatteryRemote"]):SendToServer({
												batteryId = i
											})
										end
									end
								until (not AutoKit.Enabled)
							end)
						elseif kit == "grim_reaper" then
							task.spawn(function()
								repeat
									task.wait()
									local itemdrops = bedwars["GrimReaperController"].soulsByPosition
									for i,v in pairs(itemdrops) do
										if entityLibrary.isAlive and AutoKit.Enabled and v.PrimaryPart and (entityLibrary.character.HumanoidRootPart.Position - v.PrimaryPart.Position).magnitude <= 120 and (not lplr.Character:GetAttribute("GrimReaperChannel")) then
											bedwars.ClientHandler:Get(bedwars["ConsumeSoulRemote"]):CallServer({
												secret = v:GetAttribute("GrimReaperSoulSecret")
											})
											v:Destroy()
										end
									end
								until (not AutoKit.Enabled)
							end)
						elseif kit == "farmer_cletus" then 
							task.spawn(function()
								repeat
									task.wait()
									local itemdrops = collectionservice:GetTagged("BedwarsHarvestableCrop")
									for i,v in pairs(itemdrops) do
										if entityLibrary.isAlive and AutoKit.Enabled and (entityLibrary.character.HumanoidRootPart.Position - v.Position).magnitude <= 10 then
											bedwars.ClientHandler:Get("BedwarsHarvestCrop"):CallServerAsync({
												position = bedwars.BlockController:getBlockPosition(v.Position)
											}):andThen(function(suc)
												if suc then
													bedwars["GameAnimationUtil"].playAnimation(lplr.Character, 1)
													bedwars.SoundManager:playSound(bedwars.SoundList.CROP_HARVEST)
												end
											end)
										end
									end
								until (not AutoKit.Enabled)
							end)
						elseif kit == "dragon_slayer" then
							task.spawn(function()
								repeat
									task.wait(0.1)
									if entityLibrary.isAlive then
										for i,v in pairs(bedwars.DragonSlayerController.dragonEmblems) do 
											if v.stackCount >= 3 then 
												bedwars.DragonSlayerController:deleteEmblem(i)
												local localPos = lplr.Character:GetPrimaryPartCFrame().Position
												local punchCFrame = CFrame.new(localPos, (i:GetPrimaryPartCFrame().Position * Vector3.new(1, 0, 1)) + Vector3.new(0, localPos.Y, 0))
												lplr.Character:SetPrimaryPartCFrame(punchCFrame)
												bedwars.DragonSlayerController:playPunchAnimation(punchCFrame - punchCFrame.Position)
												bedwars.ClientHandler:Get(bedwars.DragonRemote):SendToServer({
													target = i
												})
											end
										end
									end
								until (not AutoKit.Enabled)
							end)
						elseif kit == "mage" then
							task.spawn(function()
								repeat
									task.wait(0.1)
									if entityLibrary.isAlive then
										for i, v in pairs(collectionservice:GetTagged("TomeGuidingBeam")) do 
											local obj = v.Parent and v.Parent.Parent and v.Parent.Parent.Parent
											if obj and (entityLibrary.character.HumanoidRootPart.Position - obj.PrimaryPart.Position).Magnitude < 5 and obj:GetAttribute("TomeSecret") then
												local res = bedwars.ClientHandler:Get(bedwars.MageRemote):CallServer({
													secret = obj:GetAttribute("TomeSecret")
												})
												if res.success and res.element then 
													bedwars.GameAnimationUtil.playAnimation(lplr, bedwars.AnimationType.PUNCH)
													bedwars.ViewmodelController:playAnimation(bedwars.AnimationType.FP_USE_ITEM)
													bedwars.MageController:destroyTomeGuidingBeam()
													bedwars.MageController:playLearnLightBeamEffect(lplr, obj)
													local sound = bedwars.MageKitUtil.MageElementVisualizations[res.element].learnSound
													if sound and sound ~= "" then 
														bedwars.SoundManager:playSound(sound)
													end
													task.delay(bedwars.BalanceFile.LEARN_TOME_DURATION, function()
														bedwars.MageController:fadeOutTome(obj)
														if lplr.Character and res.element then
															bedwars.MageKitUtil.changeMageKitAppearance(lplr, lplr.Character, res.element)	
														end
													end)
												end
											end
										end
									end
								until (not AutoKit.Enabled)
							end)
						elseif kit == "miner" then
							task.spawn(function()
								repeat
									task.wait(0.1)
									if entityLibrary.isAlive then
										for i,v in pairs(collectionservice:GetTagged("petrified-player")) do 
											bedwars.ClientHandler:Get(bedwars["MinerRemote"]):SendToServer({
												petrifyId = v:GetAttribute("PetrifyId")
											})
										end
									end
								until (not AutoKit.Enabled)
							end)
						end
					end
				end)
			end
		end,
		HoverText = "Automatically uses a kits ability"
	})
	AutoKitTrinity = AutoKit.CreateDropdown({
		Name = "Angel",
		List = {"Void", "Light"},
		Function = function() end
	})
end)

runcode(function()
	local vapecapeconnection
	local capebox = {Value = ""}
	local Cape = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "Cape",
		Function = function(callback)
			if callback then
				local customlink = capebox.Value:split("/")
				local successfulcustom = false
				if #customlink > 0 and capebox.Value:len() > 3 and capebox.Value:sub(capebox.Value:len() - 3, capebox.Value:len()):lower() == ".png" then
					if (not betterisfile("vape/assets/"..customlink[#customlink])) then 
						local suc, res = pcall(function() writefile("vape/assets/"..customlink[#customlink], game:HttpGet(capebox.Value, true)) end)
						if not suc then 
							createwarning("Cape", "file failed to download : "..res, 5)
						end
					end
					successfulcustom = true
				end
				vapecapeconnection = lplr.CharacterAdded:Connect(function(char)
					task.spawn(function()
						pcall(function() 
							Cape(char, getcustomassetfunc("vape/assets/"..(successfulcustom and customlink[#customlink] or "VapeCape.png")))
						end)
					end)
				end)
				if lplr.Character then
					task.spawn(function()
						pcall(function() 
							Cape(lplr.Character, getcustomassetfunc("vape/assets/"..(successfulcustom and customlink[#customlink] or "VapeCape.png")))
						end)
					end)
				end
			else
				if vapecapeconnection then
					vapecapeconnection:Disconnect()
				end
				if lplr.Character then
					for i,v in pairs(lplr.Character:GetDescendants()) do
						if v.Name == "Cape" then
							v:Remove()
						end
					end
				end
			end
		end
	})
	capebox = Cape.CreateTextBox({
		Name = "File",
		["TempText"] = "File (link)",
		["FocusLost"] = function(enter) 
			if enter then 
				if Cape.Enabled then 
					Cape.ToggleButton(false)
					Cape.ToggleButton(false)
				end
			end
		end
	})
end)

runcode(function()
	local controlmodule = require(lplr.PlayerScripts.PlayerModule).controls
	local oldmove
	local SafeWalk = {Enabled = false}
	local SafeWalkMode = {Value = "Optimized"}
	SafeWalk = GuiLibrary.ObjectsThatCanBeSaved.WorldWindow.Api.CreateOptionsButton({
		Name = "SafeWalk",
		Function = function(callback)
			if callback then
				oldmove = controlmodule.moveFunction
				controlmodule.moveFunction = function(Self, vec, facecam)
					if entityLibrary.isAlive and (not Scaffold.Enabled) and (not GuiLibrary.ObjectsThatCanBeSaved["FlyOptionsButton"]["Api"].Enabled) then
						if SafeWalkMode.Value == "Optimized" then 
							local newpos = (entityLibrary.character.HumanoidRootPart.Position - Vector3.new(0, entityLibrary.character.Humanoid.HipHeight * 2, 0))
							local ray = getblock(newpos + Vector3.new(0, -6, 0) + vec)
							for i = 1, 50 do 
								if ray then break end
								ray = getblock(newpos + Vector3.new(0, -i * 6, 0) + vec)
							end
							local ray2 = getblock(newpos)
							if ray == nil and ray2 then
								local ray3 = getblock(newpos + vec) or getblock(newpos + (vec * 1.5))
								if ray3 == nil then 
									vec = Vector3.zero
								end
							end
						else
							local ray = workspace:Raycast(entityLibrary.character.HumanoidRootPart.Position + vec, Vector3.new(0, -1000, 0), blockraycast)
							local ray2 = workspace:Raycast(entityLibrary.character.HumanoidRootPart.Position, Vector3.new(0, -entityLibrary.character.Humanoid.HipHeight * 2, 0), blockraycast)
							if ray == nil and ray2 then
								local ray3 = workspace:Raycast(entityLibrary.character.HumanoidRootPart.Position + (vec * 1.8), Vector3.new(0, -1000, 0), blockraycast)
								if ray3 == nil then 
									vec = Vector3.zero
								end
							end
						end
					end
					return oldmove(Self, vec, facecam)
				end
			else
				controlmodule.moveFunction = oldmove
			end
		end,
		HoverText = "lets you not walk off because you are bad"
	})
	SafeWalkMode = SafeWalk.CreateDropdown({
		Name = "Mode",
		List = {"Optimized", "Accurate"},
		Function = function() end
	})
end)

runcode(function()
	local oldaim
	local oldplr
	local oldmove
	local zerovelocheck = tick()
	local oldbowx = 0.8
	local otherprojectiles = {Enabled = false}
	local BowAimbotPart = {Value = "HumanoidRootPart"}
	local BowAimbotFOV = {Value = 1000}
	local BowAimbot = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "ProjectileAimbot",
		Function = function(callback)
			if callback then
				oldaim = bedwars.ProjectileController.calculateImportantLaunchValues
				bedwars.ProjectileController.calculateImportantLaunchValues = function(self, projmeta, worldmeta, shootpospart, ...)
					local plr = GetNearestHumanoidToMouse(true, BowAimbotFOV.Value)
					if plr then
						local startPos = self:getLaunchPosition(shootpospart)
						if not startPos then
							return oldaim(self, projmeta, worldmeta, shootpospart, ...)
						end
						if (not otherprojectiles.Enabled) and projmeta.projectile:find("arrow") == nil then
							return oldaim(self, projmeta, worldmeta, shootpospart, ...)
						end
						local projmetatab = projmeta:getProjectileMeta();
						local prediction = (worldmeta and projmetatab.predictionLifetimeSec or projmetatab.lifetimeSec or 3)
						local launchvelo = (projmetatab.launchVelocity or 100)
						local gravity = (projmetatab.gravitationalAcceleration or 196.2)
						local multigrav = gravity * projmeta.gravityMultiplier
						local offsetStartPos = startPos + projmeta.fromPositionOffset
					 	local pos = (plr.Character[BowAimbotPart.Value].Position) 
						oldplr = plr
						if plr ~= oldplr then
							oldmove = nil
						end
						local playergrav = workspace.Gravity
						local balloons = plr.Character:GetAttribute("InflatedBalloons")
						if balloons and balloons > 0 then 
							playergrav = (workspace.Gravity * (1 - ((balloons >= 4 and 1.2 or balloons >= 3 and 1 or 0.975))))
						end
						local shootpos, shootvelo = predictGravity(pos, plr.Character.HumanoidRootPart.Velocity, (pos - offsetStartPos).Magnitude / launchvelo, plr, playergrav)
						if projmeta.projectile == "telepearl" then
							shootpos = pos
							shootvelo = Vector3.zero
						end
						local newlook = CFrame.new(offsetStartPos, shootpos) * CFrame.new(Vector3.new(-bedwars.BowConstantsTable.RelX, -bedwars.BowConstantsTable.RelY, 0))
						shootpos = newlook.p + (newlook.lookVector * (offsetStartPos - shootpos).magnitude)
						local calculated = LaunchDirection(offsetStartPos, shootpos, launchvelo, multigrav, false)
						oldmove = plr.Character.Humanoid.MoveDirection
						if calculated then
							return {
								initialVelocity = calculated,
								positionFrom = offsetStartPos,
								deltaT = prediction,
								gravitationalAcceleration = multigrav,
								drawDurationSeconds = 5
							}
						end
					end
					return oldaim(self, projmeta, worldmeta, shootpospart, ...)
				end
			else
				bedwars.ProjectileController.calculateImportantLaunchValues = oldaim
			end
		end
	})
	BowAimbotPart = BowAimbot.CreateDropdown({
		Name = "Part",
		List = {"HumanoidRootPart", "Head"},
		Function = function() end
	})
	BowAimbotFOV = BowAimbot.CreateSlider({
		Name = "FOV",
		Function = function() end,
		Min = 1,
		Max = 1000,
		Default = 1000
	})
	otherprojectiles = BowAimbot.CreateToggle({
		Name = "Other Projectiles",
		Function = function() end,
		Default = true
	})
end)

runcode(function()
	tpstring = shared.vapeoverlay or nil
	local origtpstring = tpstring
	local Overlay = GuiLibrary.CreateCustomWindow({
		Name = "Overlay", 
		["Icon"] = "vape/assets/TargetIcon1.png",
		["IconSize"] = 16
	})
	local overlayframe = Instance.new("Frame")
	overlayframe.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	overlayframe.Size = UDim2.new(0, 200, 0, 120)
	overlayframe.Position = UDim2.new(0, 0, 0, 5)
	overlayframe.Parent = Overlay.GetCustomChildren()
	local overlayframe2 = Instance.new("Frame")
	overlayframe2.Size = UDim2.new(1, 0, 0, 10)
	overlayframe2.Position = UDim2.new(0, 0, 0, -5)
	overlayframe2.Parent = overlayframe
	local overlayframe3 = Instance.new("Frame")
	overlayframe3.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	overlayframe3.Size = UDim2.new(1, 0, 0, 6)
	overlayframe3.Position = UDim2.new(0, 0, 0, 6)
	overlayframe3.BorderSizePixel = 0
	overlayframe3.Parent = overlayframe2
	local oldguiupdate = GuiLibrary["UpdateUI"]
	GuiLibrary["UpdateUI"] = function(h, s, v, ...)
		overlayframe2.BackgroundColor3 = Color3.fromHSV(h, s, v)
		return oldguiupdate(h, s, v, ...)
	end
	local framecorner1 = Instance.new("UICorner")
	framecorner1.CornerRadius = UDim.new(0, 5)
	framecorner1.Parent = overlayframe
	local framecorner2 = Instance.new("UICorner")
	framecorner2.CornerRadius = UDim.new(0, 5)
	framecorner2.Parent = overlayframe2
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -7, 1, -5)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextYAlignment = Enum.TextYAlignment.Top
	label.Font = Enum.Font.GothamBold
	label.LineHeight = 1.2
	label.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	label.TextSize = 16
	label.Text = ""
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(200, 200, 200)
	label.Position = UDim2.new(0, 7, 0, 5)
	label.Parent = overlayframe
	Overlay["Bypass"] = true
	local oldnetworkowner
	local teleported = {}
	local teleported2 = {}
	local teleportconnections = {}
	local pinglist = {}
	local fpslist = {}
	local matchstatechanged = 0
	local mapname = "Unknown"

	task.spawn(function()
		pcall(function()
		mapname = workspace:WaitForChild("Map"):WaitForChild("Worlds"):GetChildren()[1].Name
		mapname = string.gsub(string.split(mapname, "_")[2] or mapname, "-", "") or "Blank"
		end)
	end)
	task.spawn(function()
		bedwars.ClientHandler:OnEvent("ProjectileImpact", function(p3)
			if uninjectflag then return end
			if p3.projectile == "telepearl" then 
				teleported[p3.shooterPlayer] = true
			elseif p3.projectile == "swap_ball" then
				teleported[p3.shooterPlayer] = true
				if p3.hitEntity then 
					local plr = players:GetPlayerFromCharacter(p3.hitEntity)
					if plr then teleported[plr] = true end
				end
			end
		end)

		local function didpingspike()
			local currentpingcheck = pinglist[1] or math.floor(tonumber(game:GetService("Stats"):FindFirstChild("PerformanceStats").Ping:GetValue()))
			for i,v in pairs(pinglist) do 
				if v ~= currentpingcheck and math.abs(v - currentpingcheck) >= 100 then 
					return currentpingcheck.." => "..v.." ping"
				else
					currentpingcheck = v
				end
			end
			return nil
		end

		local function notlasso()
			for i,v in pairs(collectionservice:GetTagged("LassoHooked")) do 
				if v == lplr.Character then 
					return false
				end
			end
			return true
		end
		repeat
			local ping = math.floor(tonumber(game:GetService("Stats"):FindFirstChild("PerformanceStats").Ping:GetValue()))
			if #pinglist >= 10 then 
				table.remove(pinglist, 1)
			end
			table.insert(pinglist, ping)
			wait(1)
			if matchState ~= matchstatechanged then 
				if matchState == 1 then 
					matchstatetick = tick() + 3
				end
				matchstatechanged = matchState
			end
			if not tpstring then
				tpstring = tick().."/"..kills.."/"..beds.."/"..(victorysaid and 1 or 0).."/"..(1).."/"..(0).."/"..(0).."/"..(0)
				origtpstring = tpstring
			end
			if entityLibrary.isAlive and (not oldcloneroot) then 
				local newnetworkowner = isnetworkowner(entityLibrary.character.HumanoidRootPart)
				if oldnetworkowner ~= nil and oldnetworkowner ~= newnetworkowner and newnetworkowner == false and notlasso() then 
					local respawnflag = math.abs(lplr:GetAttribute("SpawnTime") - lplr:GetAttribute("LastTeleported")) > 3
					if (not teleported[lplr]) and respawnflag then
						task.delay(1, function()
							local falseflag = didpingspike()
							if falseflag then 
								createwarning("Vape", "Lagspike Detected : "..falseflag, 10)
							else
								lagbacks = lagbacks + 1
							end
						end)
					else
						if respawnflag then
							createwarning("Vape", "Telepearl False Flag", 10)
						end
					end
				end
				oldnetworkowner = newnetworkowner
			else
				oldnetworkowner = nil
			end
			teleported[lplr] = nil
			for i,v in pairs(entityLibrary.entityList) do 
				if teleportconnections[v.Player.Name.."1"] then continue end
				teleportconnections[v.Player.Name.."1"] = v.Player:GetAttributeChangedSignal("LastTeleported"):Connect(function()
					if uninjectflag then return end
					for i = 1, 15 do 
						task.wait(0.1)
						if teleported[v.Player] or teleported2[v.Player] or matchstatetick > tick() or math.abs(v.Player:GetAttribute("SpawnTime") - v.Player:GetAttribute("LastTeleported")) < 3 then break end
					end
					if v.Player ~= nil and (not v.Player.Neutral) and teleported[v.Player] == nil and teleported2[v.Player] == nil and math.abs(v.Player:GetAttribute("SpawnTime") - v.Player:GetAttribute("LastTeleported")) > 3 and matchstatetick <= tick() then 
						otherlagbacks = otherlagbacks + 1
						lagbackevent:Fire(v.Player)
					end
					teleported[v.Player] = nil
				end)
				teleportconnections[v.Player.Name.."2"] = v.Player:GetAttributeChangedSignal("PlayerConnected"):Connect(function()
					teleported2[v.Player] = true
					task.delay(5, function()
						teleported2[v.Player] = nil
					end)
				end)
			end
			local splitted = origtpstring:split("/")
			label.Text = "Session Info\nTime Played : "..os.date("!%X",math.floor(tick() - splitted[1])).."\nKills : "..(splitted[2] + kills).."\nBeds : "..(splitted[3] + beds).."\nWins : "..(splitted[4] + (victorysaid and 1 or 0)).."\nGames : "..splitted[5].."\nLagbacks : "..(splitted[6] + lagbacks).."\nUniversal Lagbacks : "..(splitted[7] + otherlagbacks).."\nReported : "..(splitted[8] + reported).."\nMap : "..mapname
			local textsize = textservice:GetTextSize(label.Text, label.TextSize, label.Font, Vector2.new(9e9, 9e9))
			overlayframe.Size = UDim2.new(0, math.max(textsize.X + 19, 200), 0, (textsize.Y * 1.2) + 10)
			tpstring = splitted[1].."/"..(splitted[2] + kills).."/"..(splitted[3] + beds).."/"..(splitted[4] + (victorysaid and 1 or 0)).."/"..(splitted[5] + 1).."/"..(splitted[6] + lagbacks).."/"..(splitted[7] + otherlagbacks).."/"..(splitted[8] + reported)
		until uninjectflag
	end)

	GuiLibrary.ObjectsThatCanBeSaved["GUIWindow"]["Api"].CreateCustomToggle({
		Name = "Overlay", 
		["Icon"] = "vape/assets/TargetIcon1.png", 
		Function = function(callback)
			Overlay.SetVisible(callback) 
		end, 
		["Priority"] = 2
	})
end)

runcode(function()
	local ChinaHat = {Enabled = false}
	local ChinaHatColor = {["Hue"] = 1,["Sat"]=1, Value=0.33}
	local chinahattrail
	local chinahatattachment
	local chinahatattachment2
	ChinaHat = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "ChinaHat",
		Function = function(callback)
			if callback then
				RunLoops:BindToHeartbeat("ChinaHat", 1, function()
					if entityLibrary.isAlive then
						if chinahattrail == nil or chinahattrail.Parent == nil then
							chinahattrail = Instance.new("Part")
							chinahattrail.CFrame = entityLibrary.character.Head.CFrame * CFrame.new(0, 1.1, 0)
							chinahattrail.Size = Vector3.new(3, 0.7, 3)
							chinahattrail.Name = "ChinaHat"
							chinahattrail.Material = Enum.Material.Neon
							chinahattrail.Color = Color3.fromHSV(ChinaHatColor["Hue"], ChinaHatColor["Sat"], ChinaHatColor.Value)
							chinahattrail.CanCollide = false
							chinahattrail.Transparency = 0.3
							local chinahatmesh = Instance.new("SpecialMesh")
							chinahatmesh.Parent = chinahattrail
							chinahatmesh.MeshType = "FileMesh"
							chinahatmesh.MeshId = "http://www.roblox.com/asset/?id=1778999"
							chinahatmesh.Scale = Vector3.new(3, 0.6, 3)
							chinahattrail.Parent = workspace.Camera
						end
						chinahattrail.CFrame = entityLibrary.character.Head.CFrame * CFrame.new(0, 1.1, 0)
						chinahattrail.Velocity = Vector3.zero
						chinahattrail.LocalTransparencyModifier = ((cam.CFrame.Position - cam.Focus.Position).Magnitude <= 0.6 and 1 or 0)
					else
						if chinahattrail then 
							chinahattrail:Remove()
							chinahattrail = nil
						end
					end
				end)
			else
				RunLoops:UnbindFromHeartbeat("ChinaHat")
				if chinahattrail then
					chinahattrail:Remove()
					chinahattrail = nil
				end
			end
		end,
		HoverText = "Puts a china hat on your character (mastadawn ty for)"
	})
	ChinaHatColor = ChinaHat.CreateColorSlider({
		Name = "Hat Color",
		Function = function(h, s, v) 
			if chinahattrail then 
				chinahattrail.Color = Color3.fromHSV(h, s, v)
			end
		end
	})
end)

runcode(function()
	local CameraFix = {Enabled = false}
	CameraFix = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "GameFixer",
		Function = function(callback)
			if callback then
				task.spawn(function()
					repeat task.wait() until matchState ~= 0
					if bedwars.ClientStoreHandler:getState().Game.customMatch == nil and CameraFix.Enabled then 
						debug.setconstant(bedwars["QueueCard"].render, 9, 0.1)
					end
				end)
				UserSettings():GetService("UserGameSettings").RotationType = ((cam.CFrame.Position - cam.Focus.Position).Magnitude <= 0.5 and Enum.RotationType.CameraRelative or Enum.RotationType.MovementRelative)
			else
				debug.setconstant(bedwars["QueueCard"].render, 9, 0.01)
			end
		end,
		HoverText = "Fixes game bugs"
	})
end)

runcode(function()
	local transformed = false
	local OldBedwars = {Enabled = false}
	local themeselected = {Value = "OldBedwars"}

	local themefunctions = {
		Old = function()
			task.spawn(function()
				local oldbedwarstabofblocks = '{"wool_blue":"rbxassetid://5089281898","wool_pink":"rbxassetid://6856183009","clay_pink":"rbxassetid://6856283410","grass":["rbxassetid://6812582110","rbxassetid://6812616868","rbxassetid://6812616868","rbxassetid://6812616868","rbxassetid://6812616868","rbxassetid://6812616868"],"snow":"rbxassetid://6874651192","wool_cyan":"rbxassetid://6177124865","red_sandstone":"rbxassetid://6708703895","wool_green":"rbxassetid://6177123316","clay_black":"rbxassetid://5890435474","sand":"rbxassetid://6187018940","wool_orange":"rbxassetid://6177122584","hickory_log":"rbxassetid://6879467811","wood_plank_birch":"rbxassetid://6768647328","clay_gray":"rbxassetid://7126965624","wood_plank_spruce":"rbxassetid://6768615964","brick":"rbxassetid://6782607284","clay_dark_brown":"rbxassetid://6874651325","stone_brick":"rbxassetid://6710700118","ceramic":"rbxassetid://6875522401","clay_blue":"rbxassetid://4991097126","wood_plank_maple":"rbxassetid://6768632085","diamond_block":"rbxassetid://6734061546","wood_plank_oak":"rbxassetid://6768575772","ice":"rbxassetid://6874651262","marble":"rbxassetid://6594536339","spruce_log":"rbxassetid://6874161124","oak_log":"rbxassetid://6879467811","clay_light_brown":"rbxassetid://6874651634","clay_dark_green":"rbxassetid://6812653448","marble_pillar":["rbxassetid://6909328433","rbxassetid://6909328433","rbxassetid://6909323822","rbxassetid://6909323822","rbxassetid://6909323822","rbxassetid://6909323822"],"slate_brick":"rbxassetid://6708836267","obsidian":"rbxassetid://6855476765","iron_block":"rbxassetid://6734050333","wool_red":"rbxassetid://5089281973","clay_purple":"rbxassetid://6856099740","clay_orange":"rbxassetid://7017703219","clay_red":"rbxassetid://6856283323","wool_yellow":"rbxassetid://6829151816","tnt":["rbxassetid://6889157997","rbxassetid://6889157997","rbxassetid://6855533421","rbxassetid://6855533421","rbxassetid://6855533421","rbxassetid://6855533421"],"clay_yellow":"rbxassetid://4991097283","clay_white":"rbxassetid://7017705325","wool_purple":"rbxassetid://6177125247","sandstone":"rbxassetid://6708657090","wool_white":"rbxassetid://5089287375","clay_light_green":"rbxassetid://6856099550","birch_log":"rbxassetid://6856088949","emerald_block":"rbxassetid://6856082835","clay":"rbxassetid://6856190168","stone":"rbxassetid://6812635290","slime_block":"rbxassetid://6869286145"}'
				local oldbedwarsblocktab = game:GetService("HttpService"):JSONDecode(oldbedwarstabofblocks)
				local oldbedwarstabofimages = '{"clay_orange":"rbxassetid://7017703219","iron":"rbxassetid://6850537969","glass":"rbxassetid://6909521321","log_spruce":"rbxassetid://6874161124","ice":"rbxassetid://6874651262","marble":"rbxassetid://6594536339","zipline_base":"rbxassetid://7051148904","iron_helmet":"rbxassetid://6874272559","marble_pillar":"rbxassetid://6909323822","clay_dark_green":"rbxassetid://6763635916","wood_plank_birch":"rbxassetid://6768647328","watering_can":"rbxassetid://6915423754","emerald_helmet":"rbxassetid://6931675766","pie":"rbxassetid://6985761399","wood_plank_spruce":"rbxassetid://6768615964","diamond_chestplate":"rbxassetid://6874272898","wool_pink":"rbxassetid://6910479863","wool_blue":"rbxassetid://6910480234","wood_plank_oak":"rbxassetid://6910418127","diamond_boots":"rbxassetid://6874272964","clay_yellow":"rbxassetid://4991097283","tnt":"rbxassetid://6856168996","lasso":"rbxassetid://7192710930","clay_purple":"rbxassetid://6856099740","melon_seeds":"rbxassetid://6956387796","apple":"rbxassetid://6985765179","carrot_seeds":"rbxassetid://6956387835","log_oak":"rbxassetid://6763678414","emerald_chestplate":"rbxassetid://6931675868","wool_yellow":"rbxassetid://6910479606","emerald_boots":"rbxassetid://6931675942","clay_light_brown":"rbxassetid://6874651634","balloon":"rbxassetid://7122143895","cannon":"rbxassetid://7121221753","leather_boots":"rbxassetid://6855466456","melon":"rbxassetid://6915428682","wool_white":"rbxassetid://6910387332","log_birch":"rbxassetid://6763678414","clay_pink":"rbxassetid://6856283410","grass":"rbxassetid://6773447725","obsidian":"rbxassetid://6910443317","shield":"rbxassetid://7051149149","red_sandstone":"rbxassetid://6708703895","diamond_helmet":"rbxassetid://6874272793","wool_orange":"rbxassetid://6910479956","log_hickory":"rbxassetid://7017706899","guitar":"rbxassetid://7085044606","wool_purple":"rbxassetid://6910479777","diamond":"rbxassetid://6850538161","iron_chestplate":"rbxassetid://6874272631","slime_block":"rbxassetid://6869284566","stone_brick":"rbxassetid://6910394475","hammer":"rbxassetid://6955848801","ceramic":"rbxassetid://6910426690","wood_plank_maple":"rbxassetid://6768632085","leather_helmet":"rbxassetid://6855466216","stone":"rbxassetid://6763635916","slate_brick":"rbxassetid://6708836267","sandstone":"rbxassetid://6708657090","snow":"rbxassetid://6874651192","wool_red":"rbxassetid://6910479695","leather_chestplate":"rbxassetid://6876833204","clay_red":"rbxassetid://6856283323","wool_green":"rbxassetid://6910480050","clay_white":"rbxassetid://7017705325","wool_cyan":"rbxassetid://6910480152","clay_black":"rbxassetid://5890435474","sand":"rbxassetid://6187018940","clay_light_green":"rbxassetid://6856099550","clay_dark_brown":"rbxassetid://6874651325","carrot":"rbxassetid://3677675280","clay":"rbxassetid://6856190168","iron_boots":"rbxassetid://6874272718","emerald":"rbxassetid://6850538075","zipline":"rbxassetid://7051148904"}'
				local oldbedwarsicontab = game:GetService("HttpService"):JSONDecode(oldbedwarstabofimages)
				local oldbedwarssoundtable = {
					["QUEUE_JOIN"] = "rbxassetid://6691735519",
					["QUEUE_MATCH_FOUND"] = "rbxassetid://6768247187",
					["UI_CLICK"] = "rbxassetid://6732690176",
					["UI_OPEN"] = "rbxassetid://6732607930",
					["BEDWARS_UPGRADE_SUCCESS"] = "rbxassetid://6760677364",
					["BEDWARS_PURCHASE_ITEM"] = "rbxassetid://6760677364",
					["SWORD_SWING_1"] = "rbxassetid://6760544639",
					["SWORD_SWING_2"] = "rbxassetid://6760544595",
					["DAMAGE_1"] = "rbxassetid://6765457325",
					["DAMAGE_2"] = "rbxassetid://6765470975",
					["DAMAGE_3"] = "rbxassetid://6765470941",
					["CROP_HARVEST"] = "rbxassetid://4864122196",
					["CROP_PLANT_1"] = "rbxassetid://5483943277",
					["CROP_PLANT_2"] = "rbxassetid://5483943479",
					["CROP_PLANT_3"] = "rbxassetid://5483943723",
					["ARMOR_EQUIP"] = "rbxassetid://6760627839",
					["ARMOR_UNEQUIP"] = "rbxassetid://6760625788",
					["PICKUP_ITEM_DROP"] = "rbxassetid://6768578304",
					["PARTY_INCOMING_INVITE"] = "rbxassetid://6732495464",
					["ERROR_NOTIFICATION"] = "rbxassetid://6732495464",
					["INFO_NOTIFICATION"] = "rbxassetid://6732495464",
					["END_GAME"] = "rbxassetid://6246476959",
					["GENERIC_BLOCK_PLACE"] = "rbxassetid://4842910664",
					["GENERIC_BLOCK_BREAK"] = "rbxassetid://4819966893",
					["GRASS_BREAK"] = "rbxassetid://5282847153",
					["WOOD_BREAK"] = "rbxassetid://4819966893",
					["STONE_BREAK"] = "rbxassetid://6328287211",
					["WOOL_BREAK"] = "rbxassetid://4842910664",
					["TNT_EXPLODE_1"] = "rbxassetid://7192313632",
					["TNT_HISS_1"] = "rbxassetid://7192313423",
					["FIREBALL_EXPLODE"] = "rbxassetid://6855723746",
					["SLIME_BLOCK_BOUNCE"] = "rbxassetid://6857999096",
					["SLIME_BLOCK_BREAK"] = "rbxassetid://6857999170",
					["SLIME_BLOCK_HIT"] = "rbxassetid://6857999148",
					["SLIME_BLOCK_PLACE"] = "rbxassetid://6857999119",
					["BOW_DRAW"] = "rbxassetid://6866062236",
					["BOW_FIRE"] = "rbxassetid://6866062104",
					["ARROW_HIT"] = "rbxassetid://6866062188",
					["ARROW_IMPACT"] = "rbxassetid://6866062148",
					["TELEPEARL_THROW"] = "rbxassetid://6866223756",
					["TELEPEARL_LAND"] = "rbxassetid://6866223798",
					["CROSSBOW_RELOAD"] = "rbxassetid://6869254094",
					["VOICE_1"] = "rbxassetid://5283866929",
					["VOICE_2"] = "rbxassetid://5283867710",
					["VOICE_HONK"] = "rbxassetid://5283872555",
					["FORTIFY_BLOCK"] = "rbxassetid://6955762535",
					["EAT_FOOD_1"] = "rbxassetid://4968170636",
					["KILL"] = "rbxassetid://7013482008",
					["ZIPLINE_TRAVEL"] = "rbxassetid://7047882304",
					["ZIPLINE_LATCH"] = "rbxassetid://7047882233",
					["ZIPLINE_UNLATCH"] = "rbxassetid://7047882265",
					["SHIELD_BLOCKED"] = "rbxassetid://6955762535",
					["GUITAR_LOOP"] = "rbxassetid://7084168540",
					["GUITAR_HEAL_1"] = "rbxassetid://7084168458",
					["CANNON_MOVE"] = "rbxassetid://7118668472",
					["CANNON_FIRE"] = "rbxassetid://7121064180",
					["BALLOON_INFLATE"] = "rbxassetid://7118657911",
					["BALLOON_POP"] = "rbxassetid://7118657873",
					["FIREBALL_THROW"] = "rbxassetid://7192289445",
					["LASSO_HIT"] = "rbxassetid://7192289603",
					["LASSO_SWING"] = "rbxassetid://7192289504",
					["LASSO_THROW"] = "rbxassetid://7192289548",
					["GRIM_REAPER_CONSUME"] = "rbxassetid://7225389554",
					["GRIM_REAPER_CHANNEL"] = "rbxassetid://7225389512",
					["TV_STATIC"] = "rbxassetid://7256209920",
					["TURRET_ON"] = "rbxassetid://7290176291",
					["TURRET_OFF"] = "rbxassetid://7290176380",
					["TURRET_ROTATE"] = "rbxassetid://7290176421",
					["TURRET_SHOOT"] = "rbxassetid://7290187805",
					["WIZARD_LIGHTNING_CAST"] = "rbxassetid://7262989886",
					["WIZARD_LIGHTNING_LAND"] = "rbxassetid://7263165647",
					["WIZARD_LIGHTNING_STRIKE"] = "rbxassetid://7263165347",
					["WIZARD_ORB_CAST"] = "rbxassetid://7263165448",
					["WIZARD_ORB_TRAVEL_LOOP"] = "rbxassetid://7263165579",
					["WIZARD_ORB_CONTACT_LOOP"] = "rbxassetid://7263165647",
					["BATTLE_PASS_PROGRESS_LEVEL_UP"] = "rbxassetid://7331597283",
					["BATTLE_PASS_PROGRESS_EXP_GAIN"] = "rbxassetid://7331597220",
					["FLAMETHROWER_UPGRADE"] = "rbxassetid://7310273053",
					["FLAMETHROWER_USE"] = "rbxassetid://7310273125",
					["BRITTLE_HIT"] = "rbxassetid://7310273179",
					["EXTINGUISH"] = "rbxassetid://7310273015",
					["RAVEN_SPACE_AMBIENT"] = "rbxassetid://7341443286",
					["RAVEN_WING_FLAP"] = "rbxassetid://7341443378",
					["RAVEN_CAW"] = "rbxassetid://7341443447",
					["JADE_HAMMER_THUD"] = "rbxassetid://7342299402",
					["STATUE"] = "rbxassetid://7344166851",
					["CONFETTI"] = "rbxassetid://7344278405",
					["HEART"] = "rbxassetid://7345120916",
					["SPRAY"] = "rbxassetid://7361499529",
					["BEEHIVE_PRODUCE"] = "rbxassetid://7378100183",
					["DEPOSIT_BEE"] = "rbxassetid://7378100250",
					["CATCH_BEE"] = "rbxassetid://7378100305",
					["BEE_NET_SWING"] = "rbxassetid://7378100350",
					["ASCEND"] = "rbxassetid://7378387334",
					["BED_ALARM"] = "rbxassetid://7396762708",
					["BOUNTY_CLAIMED"] = "rbxassetid://7396751941",
					["BOUNTY_ASSIGNED"] = "rbxassetid://7396752155",
					["BAGUETTE_HIT"] = "rbxassetid://7396760547",
					["BAGUETTE_SWING"] = "rbxassetid://7396760496",
					["TESLA_ZAP"] = "rbxassetid://7497477336",
					["SPIRIT_TRIGGERED"] = "rbxassetid://7498107251",
					["SPIRIT_EXPLODE"] = "rbxassetid://7498107327",
					["ANGEL_LIGHT_ORB_CREATE"] = "rbxassetid://7552134231",
					["ANGEL_LIGHT_ORB_HEAL"] = "rbxassetid://7552134868",
					["ANGEL_VOID_ORB_CREATE"] = "rbxassetid://7552135942",
					["ANGEL_VOID_ORB_HEAL"] = "rbxassetid://7552136927",
					["DODO_BIRD_JUMP"] = "rbxassetid://7618085391",
					["DODO_BIRD_DOUBLE_JUMP"] = "rbxassetid://7618085771",
					["DODO_BIRD_MOUNT"] = "rbxassetid://7618085486",
					["DODO_BIRD_DISMOUNT"] = "rbxassetid://7618085571",
					["DODO_BIRD_SQUAWK_1"] = "rbxassetid://7618085870",
					["DODO_BIRD_SQUAWK_2"] = "rbxassetid://7618085657",
					["SHIELD_CHARGE_START"] = "rbxassetid://7730842884",
					["SHIELD_CHARGE_LOOP"] = "rbxassetid://7730843006",
					["SHIELD_CHARGE_BASH"] = "rbxassetid://7730843142",
					["ROCKET_LAUNCHER_FIRE"] = "rbxassetid://7681584765",
					["ROCKET_LAUNCHER_FLYING_LOOP"] = "rbxassetid://7681584906",
					["SMOKE_GRENADE_POP"] = "rbxassetid://7681276062",
					["SMOKE_GRENADE_EMIT_LOOP"] = "rbxassetid://7681276135",
					["GOO_SPIT"] = "rbxassetid://7807271610",
					["GOO_SPLAT"] = "rbxassetid://7807272724",
					["GOO_EAT"] = "rbxassetid://7813484049",
					["LUCKY_BLOCK_BREAK"] = "rbxassetid://7682005357",
					["AXOLOTL_SWITCH_TARGETS"] = "rbxassetid://7344278405",
					["HALLOWEEN_MUSIC"] = "rbxassetid://7775602786",
					["SNAP_TRAP_SETUP"] = "rbxassetid://7796078515",
					["SNAP_TRAP_CLOSE"] = "rbxassetid://7796078695",
					["SNAP_TRAP_CONSUME_MARK"] = "rbxassetid://7796078825",
					["GHOST_VACUUM_SUCKING_LOOP"] = "rbxassetid://7814995865",
					["GHOST_VACUUM_SHOOT"] = "rbxassetid://7806060367",
					["GHOST_VACUUM_CATCH"] = "rbxassetid://7815151688",
					["FISHERMAN_GAME_START"] = "rbxassetid://7806060544",
					["FISHERMAN_GAME_PULLING_LOOP"] = "rbxassetid://7806060638",
					["FISHERMAN_GAME_PROGRESS_INCREASE"] = "rbxassetid://7806060745",
					["FISHERMAN_GAME_FISH_MOVE"] = "rbxassetid://7806060863",
					["FISHERMAN_GAME_LOOP"] = "rbxassetid://7806061057",
					["FISHING_ROD_CAST"] = "rbxassetid://7806060976",
					["FISHING_ROD_SPLASH"] = "rbxassetid://7806061193",
					["SPEAR_HIT"] = "rbxassetid://7807270398",
					["SPEAR_THROW"] = "rbxassetid://7813485044",
				}
				task.spawn(function()
					for i,v in pairs(collectionservice:GetTagged("block")) do
						if oldbedwarsblocktab[v.Name] then
							if type(oldbedwarsblocktab[v.Name]) == "table" then
								for i2,v2 in pairs(v:GetDescendants()) do
									if v2:IsA("Texture") then
										if v2.Name == "Top" then
											v2.Texture = oldbedwarsblocktab[v.Name][1]
											v2.Color3 = v.Name == "grass" and Color3.fromRGB(115, 255, 28) or Color3.fromRGB(255, 255, 255)
										elseif v2.Name == "Bottom" then
											v2.Texture = oldbedwarsblocktab[v.Name][2]
										else
											v2.Texture = oldbedwarsblocktab[v.Name][3]
										end
									end
								end
							else
								for i2,v2 in pairs(v:GetDescendants()) do
									if v2:IsA("Texture") then
										v2.Texture = oldbedwarsblocktab[v.Name]
									end
								end
							end
						end
					end
				end)
				collectionservice:GetInstanceAddedSignal("block"):Connect(function(v)
					if oldbedwarsblocktab[v.Name] then
						if type(oldbedwarsblocktab[v.Name]) == "table" then
							for i2,v2 in pairs(v:GetDescendants()) do
								if v2:IsA("Texture") then
									if v2.Name == "Top" then
										v2.Texture = oldbedwarsblocktab[v.Name][1]
										v2.Color3 = v.Name == "grass" and Color3.fromRGB(115, 255, 28) or Color3.fromRGB(255, 255, 255)
									elseif v2.Name == "Bottom" then
										v2.Texture = oldbedwarsblocktab[v.Name][2]
									else
										v2.Texture = oldbedwarsblocktab[v.Name][3]
									end
								end
							end
							v.DescendantAdded:Connect(function(v3)
								if v3:IsA("Texture") then
									if v3.Name == "Top" then
										v3.Texture = oldbedwarsblocktab[v.Name][1]
										v3.Color3 = v.Name == "grass" and Color3.fromRGB(115, 255, 28) or Color3.fromRGB(255, 255, 255)
									elseif v3.Name == "Bottom" then
										v3.Texture = oldbedwarsblocktab[v.Name][2]
									else
										v3.Texture = oldbedwarsblocktab[v.Name][3]
									end
								end
							end)
						else
							for i2,v2 in pairs(v:GetDescendants()) do
								if v2:IsA("Texture") then
									v2.Texture = oldbedwarsblocktab[v.Name]
								end
							end
							v.DescendantAdded:Connect(function(v3)
								if v3:IsA("Texture") then
									v3.Texture = oldbedwarsblocktab[v.Name]
								end
							end)
						end
					end
				end)
				collectionservice:GetInstanceAddedSignal("tnt"):Connect(function(v)
					if oldbedwarsblocktab[v.Name] then
						if type(oldbedwarsblocktab[v.Name]) == "table" then
							for i2,v2 in pairs(v:GetDescendants()) do
								if v2:IsA("Texture") then
									if v2.Name == "Top" then
										v2.Texture = oldbedwarsblocktab[v.Name][1]
										v2.Color3 = v.Name == "grass" and Color3.fromRGB(115, 255, 28) or Color3.fromRGB(255, 255, 255)
									elseif v2.Name == "Bottom" then
										v2.Texture = oldbedwarsblocktab[v.Name][2]
									else
										v2.Texture = oldbedwarsblocktab[v.Name][3]
									end
								end
							end
							v.DescendantAdded:Connect(function(v3)
								if v3:IsA("Texture") then
									if v3.Name == "Top" then
										v3.Texture = oldbedwarsblocktab[v.Name][1]
										v3.Color3 = v.Name == "grass" and Color3.fromRGB(115, 255, 28) or Color3.fromRGB(255, 255, 255)
									elseif v3.Name == "Bottom" then
										v3.Texture = oldbedwarsblocktab[v.Name][2]
									else
										v3.Texture = oldbedwarsblocktab[v.Name][3]
									end
								end
							end)
						else
							for i2,v2 in pairs(v:GetDescendants()) do
								if v2:IsA("Texture") then
									v2.Texture = oldbedwarsblocktab[v.Name]
								end
							end
							v.DescendantAdded:Connect(function(v3)
								if v3:IsA("Texture") then
									v3.Texture = oldbedwarsblocktab[v.Name]
								end
							end)
						end
					end
				end)
				for i,v in pairs(bedwars.ItemTable) do 
					if oldbedwarsicontab[i] then 
						v.image = oldbedwarsicontab[i]
					end
				end			
				for i,v in pairs(oldbedwarssoundtable) do 
					local item = bedwars.SoundList[i]
					if item then
						bedwars.SoundList[i] = v
					end
				end	
				local oldweld = bedwars["WeldTable"].weldCharacterAccessories
				local alreadydone = {}
				bedwars["WeldTable"].weldCharacterAccessories = function(self, model, ...)
					for i,v in pairs(model:GetChildren()) do
						local died = v.Name == "HumanoidRootPart" and v:FindFirstChild("Died")
						if died then 
							died.Volume = 0
						end
						if oldbedwarsblocktab[v.Name] then
							task.spawn(function()
								local hand = v:WaitForChild("Handle", 10)
								if hand then
									hand.CastShadow = false
								end
								for i2,v2 in pairs(v:GetDescendants()) do
									if v2:IsA("Texture") then
										if v2.Name == "Top" then
											v2.Texture = (type(oldbedwarsblocktab[v.Name]) == "table" and oldbedwarsblocktab[v.Name][1] or oldbedwarsblocktab[v.Name])
											v2.Color3 = v.Name == "grass" and Color3.fromRGB(115, 255, 28) or Color3.fromRGB(255, 255, 255)
										elseif v2.Name == "Bottom" then
											v2.Texture = (type(oldbedwarsblocktab[v.Name]) == "table" and oldbedwarsblocktab[v.Name][2] or oldbedwarsblocktab[v.Name])
										else
											v2.Texture = (type(oldbedwarsblocktab[v.Name]) == "table" and oldbedwarsblocktab[v.Name][3] or oldbedwarsblocktab[v.Name])
										end
									end
								end
								v.DescendantAdded:Connect(function(v3)
									if v3:IsA("Texture") then
										if v3.Name == "Top" then
											v3.Texture = (type(oldbedwarsblocktab[v.Name]) == "table" and oldbedwarsblocktab[v.Name][1] or oldbedwarsblocktab[v.Name])
											v3.Color3 = v.Name == "grass" and Color3.fromRGB(115, 255, 28) or Color3.fromRGB(255, 255, 255)
										elseif v3.Name == "Bottom" then
											v3.Texture = (type(oldbedwarsblocktab[v.Name]) == "table" and oldbedwarsblocktab[v.Name][2] or oldbedwarsblocktab[v.Name])
										else
											v3.Texture = (type(oldbedwarsblocktab[v.Name]) == "table" and oldbedwarsblocktab[v.Name][3] or oldbedwarsblocktab[v.Name])
										end
									end
								end)
							end)
						end
					end
					return oldweld(self, model, ...)
				end
				local damagetab = debug.getupvalue(bedwars["DamageIndicator"], 2)
				damagetab.strokeThickness = false
				damagetab.textSize = 32
				damagetab.blowUpDuration = 0
				damagetab.baseColor = Color3.fromRGB(214, 0, 0)
				damagetab.blowUpSize = 32
				damagetab.blowUpCompleteDuration = 0
				damagetab.anchoredDuration = 0
				debug.setconstant(bedwars.ViewmodelController.show, 37, "")
				debug.setconstant(bedwars["DamageIndicator"], 83, Enum.Font.LuckiestGuy)
				debug.setconstant(bedwars["DamageIndicator"], 102, "Enabled")
				debug.setconstant(bedwars["DamageIndicator"], 118, 0.3)
				debug.setconstant(bedwars["DamageIndicator"], 128, 0.5)
				debug.setupvalue(bedwars["DamageIndicator"], 10, {
					Create = function(self, obj, ...)
						task.spawn(function()
							obj.Parent.Parent.Parent.Parent.Velocity = Vector3.new((math.random(-50, 50) / 100) * damagetab.velX, (math.random(50, 60) / 100) * damagetab.velY, (math.random(-50, 50) / 100) * damagetab.velZ)
							local textcompare = obj.Parent.TextColor3
							if textcompare ~= Color3.fromRGB(85, 255, 85) then
								local newtween = game:GetService("TweenService"):Create(obj.Parent, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {
									TextColor3 = (textcompare == Color3.fromRGB(76, 175, 93) and Color3.new(0, 0, 0) or Color3.new(1, 1, 1))
								})
								task.wait(0.15)
								newtween:Play()
							end
						end)
						return game:GetService("TweenService"):Create(obj, ...)
					end
				})
				sethiddenproperty(lighting, "Technology", "ShadowMap")
				lighting.Ambient = Color3.fromRGB(69, 69, 69)
				lighting.Brightness = 3
				lighting.EnvironmentDiffuseScale = 1
				lighting.EnvironmentSpecularScale = 1
				lighting.OutdoorAmbient = Color3.fromRGB(69, 69, 69)
				lighting.Atmosphere.Density = 0.1
				lighting.Atmosphere.Offset = 0.25
				lighting.Atmosphere.Color = Color3.fromRGB(198, 198, 198)
				lighting.Atmosphere.Decay = Color3.fromRGB(104, 112, 124)
				lighting.Atmosphere.Glare = 0
				lighting.Atmosphere.Haze = 0
				lighting.ClockTime = 13
				lighting.GeographicLatitude = 0
				lighting.GlobalShadows = false
				lighting.TimeOfDay = "13:00:00"
				lighting.Sky.SkyboxBk = "rbxassetid://7018684000"
				lighting.Sky.SkyboxDn = "rbxassetid://6334928194"
				lighting.Sky.SkyboxFt = "rbxassetid://7018684000"
				lighting.Sky.SkyboxLf = "rbxassetid://7018684000"
				lighting.Sky.SkyboxRt = "rbxassetid://7018684000"
				lighting.Sky.SkyboxUp = "rbxassetid://7018689553"
			end)
		end,
		Winter = function() 
			task.spawn(function()
				for i,v in pairs(lighting:GetChildren()) do
					if v:IsA("Atmosphere") or v:IsA("Sky") or v:IsA("PostEffect") then
						v:Remove()
					end
				end
				local sky = Instance.new("Sky")
				sky.StarCount = 5000
				sky.SkyboxUp = "rbxassetid://8139676647"
				sky.SkyboxLf = "rbxassetid://8139676988"
				sky.SkyboxFt = "rbxassetid://8139677111"
				sky.SkyboxBk = "rbxassetid://8139677359"
				sky.SkyboxDn = "rbxassetid://8139677253"
				sky.SkyboxRt = "rbxassetid://8139676842"
				sky.SunTextureId = "rbxassetid://6196665106"
				sky.SunAngularSize = 11
				sky.MoonTextureId = "rbxassetid://8139665943"
				sky.MoonAngularSize = 30
				sky.Parent = lighting
				local sunray = Instance.new("SunRaysEffect")
				sunray.Intensity = 0.03
				sunray.Parent = lighting
				local bloom = Instance.new("BloomEffect")
				bloom.Threshold = 2
				bloom.Intensity = 1
				bloom.Size = 2
				bloom.Parent = lighting
				local atmosphere = Instance.new("Atmosphere")
				atmosphere.Density = 0.3
				atmosphere.Offset = 0.25
				atmosphere.Color = Color3.fromRGB(198, 198, 198)
				atmosphere.Decay = Color3.fromRGB(104, 112, 124)
				atmosphere.Glare = 0
				atmosphere.Haze = 0
				atmosphere.Parent = lighting
				local damagetab = debug.getupvalue(bedwars["DamageIndicator"], 2)
				damagetab.strokeThickness = false
				damagetab.textSize = 32
				damagetab.blowUpDuration = 0
				damagetab.baseColor = Color3.fromRGB(70, 255, 255)
				damagetab.blowUpSize = 32
				damagetab.blowUpCompleteDuration = 0
				damagetab.anchoredDuration = 0
				debug.setconstant(bedwars["DamageIndicator"], 83, Enum.Font.LuckiestGuy)
				debug.setconstant(bedwars["DamageIndicator"], 102, "Enabled")
				debug.setconstant(bedwars["DamageIndicator"], 118, 0.3)
				debug.setconstant(bedwars["DamageIndicator"], 128, 0.5)
				debug.setupvalue(bedwars["DamageIndicator"], 10, {
					Create = function(self, obj, ...)
						task.spawn(function()
							obj.Parent.Parent.Parent.Parent.Velocity = Vector3.new((math.random(-50, 50) / 100) * damagetab.velX, (math.random(50, 60) / 100) * damagetab.velY, (math.random(-50, 50) / 100) * damagetab.velZ)
							local textcompare = obj.Parent.TextColor3
							if textcompare ~= Color3.fromRGB(85, 255, 85) then
								local newtween = game:GetService("TweenService"):Create(obj.Parent, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {
									TextColor3 = (textcompare == Color3.fromRGB(76, 175, 93) and Color3.new(1, 1, 1) or Color3.new(0, 0, 0))
								})
								task.wait(0.15)
								newtween:Play()
							end
						end)
						return game:GetService("TweenService"):Create(obj, ...)
					end
				})
				debug.setconstant(require(lplr.PlayerScripts.TS.controllers.global.hotbar.ui.healthbar["hotbar-healthbar"]).HotbarHealthbar.render, 16, 4653055)
			end)
			task.spawn(function()
				local snowpart = Instance.new("Part")
				snowpart.Size = Vector3.new(240, 0.5, 240)
				snowpart.Name = "SnowParticle"
				snowpart.Transparency = 1
				snowpart.CanCollide = false
				snowpart.Position = Vector3.new(0, 120, 286)
				snowpart.Anchored = true
				snowpart.Parent = workspace
				local snow = Instance.new("ParticleEmitter")
				snow.RotSpeed = NumberRange.new(300)
				snow.VelocitySpread = 35
				snow.Rate = 28
				snow.Texture = "rbxassetid://8158344433"
				snow.Rotation = NumberRange.new(110)
				snow.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0.16939899325371,0),NumberSequenceKeypoint.new(0.23365999758244,0.62841498851776,0.37158501148224),NumberSequenceKeypoint.new(0.56209099292755,0.38797798752785,0.2771390080452),NumberSequenceKeypoint.new(0.90577298402786,0.51912599802017,0),NumberSequenceKeypoint.new(1,1,0)})
				snow.Lifetime = NumberRange.new(8,14)
				snow.Speed = NumberRange.new(8,18)
				snow.EmissionDirection = Enum.NormalId.Bottom
				snow.SpreadAngle = Vector2.new(35,35)
				snow.Size = NumberSequence.new({NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(0.039760299026966,1.3114800453186,0.32786899805069),NumberSequenceKeypoint.new(0.7554469704628,0.98360699415207,0.44038599729538),NumberSequenceKeypoint.new(1,0,0)})
				snow.Parent = snowpart
				local windsnow = Instance.new("ParticleEmitter")
				windsnow.Acceleration = Vector3.new(0,0,1)
				windsnow.RotSpeed = NumberRange.new(100)
				windsnow.VelocitySpread = 35
				windsnow.Rate = 28
				windsnow.Texture = "rbxassetid://8158344433"
				windsnow.EmissionDirection = Enum.NormalId.Bottom
				windsnow.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0.16939899325371,0),NumberSequenceKeypoint.new(0.23365999758244,0.62841498851776,0.37158501148224),NumberSequenceKeypoint.new(0.56209099292755,0.38797798752785,0.2771390080452),NumberSequenceKeypoint.new(0.90577298402786,0.51912599802017,0),NumberSequenceKeypoint.new(1,1,0)})
				windsnow.Lifetime = NumberRange.new(8,14)
				windsnow.Speed = NumberRange.new(8,18)
				windsnow.Rotation = NumberRange.new(110)
				windsnow.SpreadAngle = Vector2.new(35,35)
				windsnow.Size = NumberSequence.new({NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(0.039760299026966,1.3114800453186,0.32786899805069),NumberSequenceKeypoint.new(0.7554469704628,0.98360699415207,0.44038599729538),NumberSequenceKeypoint.new(1,0,0)})
				windsnow.Parent = snowpart
				repeat
					task.wait()
					if entityLibrary.isAlive then 
						snowpart.Position = entityLibrary.character.HumanoidRootPart.Position + Vector3.new(0, 100, 0)
					end
				until uninjectflag
			end)
		end,
		Halloween = function()
			task.spawn(function()
				for i,v in pairs(lighting:GetChildren()) do
					if v:IsA("Atmosphere") or v:IsA("Sky") or v:IsA("PostEffect") then
						v:Remove()
					end
				end
				lighting.TimeOfDay = "00:00:00"
				pcall(function() workspace.Clouds:Destroy() end)
				local damagetab = debug.getupvalue(bedwars["DamageIndicator"], 2)
				damagetab.strokeThickness = false
				damagetab.textSize = 32
				damagetab.blowUpDuration = 0
				damagetab.baseColor = Color3.fromRGB(255, 100, 0)
				damagetab.blowUpSize = 32
				damagetab.blowUpCompleteDuration = 0
				damagetab.anchoredDuration = 0
				debug.setconstant(bedwars["DamageIndicator"], 83, Enum.Font.LuckiestGuy)
				debug.setconstant(bedwars["DamageIndicator"], 102, "Enabled")
				debug.setconstant(bedwars["DamageIndicator"], 118, 0.3)
				debug.setconstant(bedwars["DamageIndicator"], 128, 0.5)
				debug.setupvalue(bedwars["DamageIndicator"], 10, {
					Create = function(self, obj, ...)
						task.spawn(function()
							obj.Parent.Parent.Parent.Parent.Velocity = Vector3.new((math.random(-50, 50) / 100) * damagetab.velX, (math.random(50, 60) / 100) * damagetab.velY, (math.random(-50, 50) / 100) * damagetab.velZ)
							local textcompare = obj.Parent.TextColor3
							if textcompare ~= Color3.fromRGB(85, 255, 85) then
								local newtween = game:GetService("TweenService"):Create(obj.Parent, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {
									TextColor3 = (textcompare == Color3.fromRGB(76, 175, 93) and Color3.new(0, 0, 0) or Color3.new(0, 0, 0))
								})
								task.wait(0.15)
								newtween:Play()
							end
						end)
						return game:GetService("TweenService"):Create(obj, ...)
					end
				})
				local colorcorrection = Instance.new("ColorCorrectionEffect")
				colorcorrection.TintColor = Color3.fromRGB(255, 185, 81)
				colorcorrection.Brightness = 0.05
				colorcorrection.Parent = lighting
				debug.setconstant(require(lplr.PlayerScripts.TS.controllers.global.hotbar.ui.healthbar["hotbar-healthbar"]).HotbarHealthbar.render, 16, 16737280)
				local bedwarsblockstr = '{"clay_dark_green":"rbxassetid://7872906273", "clay_light_green":"rbxassetid://7872905675","grass":["rbxassetid://11188683914","rbxassetid://11188683041","rbxassetid://11188683041","rbxassetid://11188683041","rbxassetid://11188683041","rbxassetid://11188683041"], "concrete_green":"rbxassetid://7872906273"}'
				local bedwarsblocktab = game:GetService("HttpService"):JSONDecode(bedwarsblockstr)
				task.spawn(function()
					for i,v in pairs(collectionservice:GetTagged("block")) do
						if bedwarsblocktab[v.Name] then
							if type(bedwarsblocktab[v.Name]) == "table" then
								for i2,v2 in pairs(v:GetDescendants()) do
									if v2:IsA("Texture") then
										if v2.Name == "Top" then
											v2.Texture = bedwarsblocktab[v.Name][1]
											v2.Color3 = Color3.fromRGB(255, 255, 255)
										elseif v2.Name == "Bottom" then
											v2.Texture = bedwarsblocktab[v.Name][2]
										else
											v2.Texture = bedwarsblocktab[v.Name][3]
										end
									end
								end
							else
								for i2,v2 in pairs(v:GetDescendants()) do
									if v2:IsA("Texture") then
										v2.Texture = bedwarsblocktab[v.Name]
									end
								end
							end
						end
					end
				end)
				collectionservice:GetInstanceAddedSignal("block"):Connect(function(v)
					if bedwarsblocktab[v.Name] then
						if type(bedwarsblocktab[v.Name]) == "table" then
							for i2,v2 in pairs(v:GetDescendants()) do
								if v2:IsA("Texture") then
									if v2.Name == "Top" then
										v2.Texture = bedwarsblocktab[v.Name][1]
										v2.Color3 = Color3.fromRGB(255, 255, 255)
									elseif v2.Name == "Bottom" then
										v2.Texture = bedwarsblocktab[v.Name][2]
									else
										v2.Texture = bedwarsblocktab[v.Name][3]
									end
								end
							end
							v.DescendantAdded:Connect(function(v3)
								if v3:IsA("Texture") then
									if v3.Name == "Top" then
										v3.Texture = bedwarsblocktab[v.Name][1]
										v3.Color3 = Color3.fromRGB(255, 255, 255)
									elseif v3.Name == "Bottom" then
										v3.Texture = bedwarsblocktab[v.Name][2]
									else
										v3.Texture = bedwarsblocktab[v.Name][3]
									end
								end
							end)
						else
							for i2,v2 in pairs(v:GetDescendants()) do
								if v2:IsA("Texture") then
									v2.Texture = bedwarsblocktab[v.Name]
								end
							end
							v.DescendantAdded:Connect(function(v3)
								if v3:IsA("Texture") then
									v3.Texture = bedwarsblocktab[v.Name]
								end
							end)
						end
					end
				end)
			end)
		end,
		Valentines = function()
			task.spawn(function()
				for i,v in pairs(lighting:GetChildren()) do
					if v:IsA("Atmosphere") or v:IsA("Sky") or v:IsA("PostEffect") then
						v:Remove()
					end
				end
				local sky = Instance.new("Sky")
				sky.SkyboxBk = "rbxassetid://1546230803"
				sky.SkyboxDn = "rbxassetid://1546231143"
				sky.SkyboxFt = "rbxassetid://1546230803"
				sky.SkyboxLf = "rbxassetid://1546230803"
				sky.SkyboxRt = "rbxassetid://1546230803"
				sky.SkyboxUp = "rbxassetid://1546230451"
				sky.Parent = lighting
				pcall(function() workspace.Clouds:Destroy() end)
				local damagetab = debug.getupvalue(bedwars["DamageIndicator"], 2)
				damagetab.strokeThickness = false
				damagetab.textSize = 32
				damagetab.blowUpDuration = 0
				damagetab.baseColor = Color3.fromRGB(255, 132, 178)
				damagetab.blowUpSize = 32
				damagetab.blowUpCompleteDuration = 0
				damagetab.anchoredDuration = 0
				debug.setconstant(bedwars["DamageIndicator"], 83, Enum.Font.LuckiestGuy)
				debug.setconstant(bedwars["DamageIndicator"], 102, "Enabled")
				debug.setconstant(bedwars["DamageIndicator"], 118, 0.3)
				debug.setconstant(bedwars["DamageIndicator"], 128, 0.5)
				debug.setupvalue(bedwars["DamageIndicator"], 10, {
					Create = function(self, obj, ...)
						task.spawn(function()
							obj.Parent.Parent.Parent.Parent.Velocity = Vector3.new((math.random(-50, 50) / 100) * damagetab.velX, (math.random(50, 60) / 100) * damagetab.velY, (math.random(-50, 50) / 100) * damagetab.velZ)
							local textcompare = obj.Parent.TextColor3
							if textcompare ~= Color3.fromRGB(85, 255, 85) then
								local newtween = game:GetService("TweenService"):Create(obj.Parent, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {
									TextColor3 = (textcompare == Color3.fromRGB(76, 175, 93) and Color3.new(0, 0, 0) or Color3.new(0, 0, 0))
								})
								task.wait(0.15)
								newtween:Play()
							end
						end)
						return game:GetService("TweenService"):Create(obj, ...)
					end
				})
				local colorcorrection = Instance.new("ColorCorrectionEffect")
				colorcorrection.TintColor = Color3.fromRGB(255, 199, 220)
				colorcorrection.Brightness = 0.05
				colorcorrection.Parent = lighting
				debug.setconstant(require(lplr.PlayerScripts.TS.controllers.global.hotbar.ui.healthbar["hotbar-healthbar"]).HotbarHealthbar.render, 16, 16745650)
			end)
		end
	}

	OldBedwars = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "GameTheme",
		Function = function(callback) 
			if callback then 
				if not transformed then
					transformed = true
					themefunctions[themeselected.Value]()
				else
					OldBedwars.ToggleButton(false)
				end
			else
				createwarning("GameTheme", "Disabled Next Game", 10)
			end
		end,
		["ExtraText"] = function()
			return themeselected.Value
		end
	})
	themeselected = OldBedwars.CreateDropdown({
		Name = "Theme",
		Function = function() end,
		List = {"Old", "Winter", "Halloween", "Valentines"}
	})
end)

runcode(function()
	local AutoRelicCustom = {["ObjectList"] = {}}

	local function findgoodmeta(relics)
		local tab = #AutoRelicCustom["ObjectList"] > 0 and AutoRelicCustom["ObjectList"] or {
			"embers_anguish",
			"knights_code",
			"quick_forge",
			"glass_cannon"
		}
		for i,v in pairs(relics) do 
			for i2,v2 in pairs(tab) do 
				if v.relic == v2 then
					return v.relic
				end
			end
		end
		return relics[1].relic
	end

	local AutoRelic = {Enabled = false}
	AutoRelic = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "AutoRelic",
		Function = function(callback)
			if callback then 
				task.spawn(function()
					repeat
						task.wait()
						if bedwars["AppController"]:isAppOpen("RelicVotingInterface") then 
							bedwars["AppController"]:closeApp("RelicVotingInterface")
							local relictable = bedwars.ClientStoreHandler:getState().Bedwars.relic.voteState
							if relictable then 
								bedwars["RelicController"]:voteForRelic(findgoodmeta(relictable))
							end
							break
						end
						if matchState ~= 0 then break end
					until (not AutoRelic.Enabled)
				end)
			end
		end
	})
	AutoRelicCustom = AutoRelic.CreateTextList({
		Name = "Custom",
		["TempText"] = "custom (relic id)"
	})
end)

runcode(function()
	local oldkilleffect
	GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "KillEffect",
		Function = function(callback)
			if callback then 
				lplr:SetAttribute("KillEffectType", "none")
				oldkilleffect = bedwars["DefaultKillEffect"].onKill
				bedwars["DefaultKillEffect"].onKill = function(p3, p4, p5, p6)
					p5:BreakJoints()
					task.spawn(function()
						local partvelo = {}
						for i,v in pairs(p5:GetDescendants()) do 
							if v:IsA("BasePart") then 
								partvelo[v.Name] = v.Velocity * 3
							end
						end
						p5.Archivable = true
						local clone = p5:Clone()
						clone.Humanoid.Health = 100
						clone.Parent = workspace
						local nametag = clone:FindFirstChild("Nametag", true)
						if nametag then nametag:Destroy() end
						game:GetService("Debris"):AddItem(clone, 30)
						p5:Destroy()
						task.wait(0.01)
						clone.Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
						clone:BreakJoints()
						task.wait(0.01)
						for i,v in pairs(clone:GetDescendants()) do 
							if v:IsA("BasePart") then 
								local bodyforce = Instance.new("BodyForce")
								bodyforce.Force = Vector3.new(0, (workspace.Gravity - 10) * v:GetMass(), 0)
								bodyforce.Parent = v
								v.CanCollide = true
								v.Velocity = partvelo[v.Name] or Vector3.zero
							end
						end
					end)
				end
			else
				bedwars["DefaultKillEffect"].onKill = oldkilleffect
			end
		end
	})
end)

runcode(function()
	local NoNameTag = {Enabled = false}
	local connection

	local function newchar(char)
		task.spawn(function()
			if char then
				local nametag = char:WaitForChild("Head", 9e9):WaitForChild("Nametag", 9e9)
				if nametag then 
					nametag:Destroy()
				end
			end
		end)
	end

	NoNameTag = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "NoNameTag",
		Function = function(callback)
			if callback then
				newchar(lplr.Character)
				connection = lplr.CharacterAdded:Connect(newchar)
			end
		end
	})
end)

runcode(function()
	local SetEmote = {Enabled = false}
	local SetEmoteList = {Value = ""}
	local oldemote
	local emo2 = {}
	SetEmote = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "SetEmote",
		Function = function(callback)
			if callback then
				oldemote = bedwars.ClientStoreHandler:getState().Locker.selectedSpray
				bedwars.ClientStoreHandler:getState().Locker.selectedSpray = emo2[SetEmoteList.Value]
			else
				if oldemote then 
					bedwars.ClientStoreHandler:getState().Locker.selectedSpray = oldemote
					oldemote = nil 
				end
			end
		end
	})
	local emo = {}
	for i,v in pairs(bedwars.EmoteMeta) do 
		table.insert(emo, v.name)
		emo2[v.name] = i
	end
	SetEmoteList = SetEmote.CreateDropdown({
		Name = "Emote",
		List = emo,
		Function = function()
			if SetEmote.Enabled then 
				bedwars.ClientStoreHandler:getState().Locker.selectedSpray = emo2[SetEmoteList.Value]
			end
		end
	})
end)

runcode(function()
	local tppos2
	local deathtpmod = {["Enabled"] = false}
	connectionstodisconnect[#connectionstodisconnect + 1] = lplr:GetAttributeChangedSignal("LastTeleported"):Connect(function(char)
		if tppos2 then 	
			task.spawn(function()
				task.wait(0.1)
				local root = entityLibrary.isAlive and entityLibrary.character.Humanoid.Health > 0 and entityLibrary.character.HumanoidRootPart
				if root and tppos2 then 
					local check = (lplr:GetAttribute("LastTeleported") - lplr:GetAttribute("SpawnTime")) < 1
					RunLoops:BindToHeartbeat("TPRedirection", 1, function(dt)
						if root and tppos2 then 
							local dist = ((check and 700 or 1200) * dt)
							if (tppos2 - root.CFrame.p).Magnitude > dist then
								root.CFrame = root.CFrame + (tppos2 - root.CFrame.p).Unit * dist
								root.Velocity = (tppos2 - root.CFrame.p).Unit * 20
							else
								root.CFrame = root.CFrame + (tppos2 - root.CFrame.p)
							end
						end
					end)
					RunLoops:BindToStepped("TPRedirection", 1, function()
						if entityLibrary.isAlive then 
							for i,v in pairs(lplr.Character:GetChildren()) do 
								if v:IsA("BasePart") then v.CanCollide = false end
							end
						end
					end)
					repeat
						task.wait()
					until tppos2 == nil or (tppos2 - root.CFrame.p).Magnitude < 1
					RunLoops:UnbindFromHeartbeat("TPRedirection")
					RunLoops:UnbindFromStepped("TPRedirection")
					createwarning("TPRedirection", "Teleported.", 5)
					tppos2 = nil
				end
			end)
		end
	end)
	deathtpmod = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "TPRedirection",
		Function = function(callback)
			if callback then
				local mousepos = lplr:GetMouse().UnitRay
				local rayparams = RaycastParams.new()
				rayparams.FilterDescendantsInstances = {workspace.Map, workspace:FindFirstChild("SpectatorPlatform")}
				rayparams.FilterType = Enum.RaycastFilterType.Whitelist
				local ray = workspace:Raycast(mousepos.Origin, mousepos.Direction * 10000, rayparams)
				if ray then 
					tppos2 = ray.Position
					local warning = createwarning("TPRedirection", "Set TP Position", 3)
				end
				deathtpmod.ToggleButton(false)
			end
		end
	})
end)

local denyregions = {}
runcode(function()
	local ignoreplaceregions = {Enabled = false}
	ignoreplaceregions = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "IgnorePlaceRegions",
		Function = function(callback)
			if callback then
				denyregions = bedwars.MapController.denyRegions
				task.spawn(function()
					repeat
						bedwars.MapController.denyRegions = {}
						task.wait()
					until (not ignoreplaceregions.Enabled)
				end)
			else 
				bedwars.MapController.denyRegions = denyregions
			end
		end
	})
end)

task.spawn(function()
	local url = "https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/CustomModules/bedwarsdata"

	local function createannouncement(announcetab)
		local notifyframereal = Instance.new("TextButton")
		notifyframereal.AnchorPoint = Vector2.new(0.5, 0)
		notifyframereal.BackgroundColor3 = announcetab.Error and Color3.fromRGB(235, 87, 87) or Color3.fromRGB(100, 103, 167)
		notifyframereal.BorderSizePixel = 0
		notifyframereal.AutoButtonColor = false
		notifyframereal.Text = ""
		notifyframereal.Position = UDim2.new(0.5, 0, 0.01, -36)
		notifyframereal.Size = UDim2.new(0.4, 0, 0, 0)
		notifyframereal.Parent = GuiLibrary["MainGui"]
		local notifyframe = Instance.new("Frame")
		notifyframe.BackgroundTransparency = 1
		notifyframe.Size = UDim2.new(1, 0, 1, 0)
		notifyframe.Parent = notifyframereal
		local notifyframecorner = Instance.new("UICorner")
		notifyframecorner.CornerRadius = UDim.new(0, 5)
		notifyframecorner.Parent = notifyframereal
		local notifyframeaspect = Instance.new("UIAspectRatioConstraint")
		notifyframeaspect.AspectRatio = 10
		notifyframeaspect.DominantAxis = Enum.DominantAxis.Height
		notifyframeaspect.Parent = notifyframereal
		local notifyframelist = Instance.new("UIListLayout")
		notifyframelist.SortOrder = Enum.SortOrder.LayoutOrder
		notifyframelist.FillDirection = Enum.FillDirection.Horizontal
		notifyframelist.HorizontalAlignment = Enum.HorizontalAlignment.Left
		notifyframelist.VerticalAlignment = Enum.VerticalAlignment.Center
		notifyframelist.Parent = notifyframe
		local notifyframe2 = Instance.new("Frame")
		notifyframe2.BackgroundTransparency = 1
		notifyframe2.BorderSizePixel = 0
		notifyframe2.LayoutOrder = 1
		notifyframe2.Size = UDim2.new(0.3, 0, 0, 0)
		notifyframe2.SizeConstraint = Enum.SizeConstraint.RelativeYY
		notifyframe2.Parent = notifyframe
		local notifyframesat = Instance.new("ImageLabel")
		notifyframesat.BackgroundTransparency = 1
		notifyframesat.BorderSizePixel = 0
		notifyframesat.Size = UDim2.new(0.7, 0, 0.7, 0)
		notifyframesat.LayoutOrder = 2
		notifyframesat.SizeConstraint = Enum.SizeConstraint.RelativeYY
		notifyframesat.Image = announcetab.Error and "rbxassetid://6768383834" or "rbxassetid://6685538693"
		notifyframesat.Parent = notifyframe
		local notifyframe3 = Instance.new("Frame")
		notifyframe3.BackgroundTransparency = 1
		notifyframe3.BorderSizePixel = 0
		notifyframe3.LayoutOrder = 3
		notifyframe3.Size = UDim2.new(4.1, 0, 0.8, 0)
		notifyframe3.SizeConstraint = Enum.SizeConstraint.RelativeYY
		notifyframe3.Parent = notifyframe
		local notifyframenotifyframelist = Instance.new("UIPadding")
		notifyframenotifyframelist.PaddingBottom = UDim.new(0.08, 0)
		notifyframenotifyframelist.PaddingLeft = UDim.new(0.06, 0)
		notifyframenotifyframelist.PaddingTop = UDim.new(0.08, 0)
		notifyframenotifyframelist.Parent = notifyframe3
		local notifyframeaspectnotifyframeaspect = Instance.new("UIListLayout")
		notifyframeaspectnotifyframeaspect.Parent = notifyframe3
		notifyframeaspectnotifyframeaspect.VerticalAlignment = Enum.VerticalAlignment.Center
		local notifyframelistnotifyframeaspect = Instance.new("TextLabel")
		notifyframelistnotifyframeaspect.BackgroundTransparency = 1
		notifyframelistnotifyframeaspect.BorderSizePixel = 0
		notifyframelistnotifyframeaspect.Size = UDim2.new(1, 0, 0.6, 0)
		notifyframelistnotifyframeaspect.Font = Enum.Font.Roboto
		notifyframelistnotifyframeaspect.Text = "Vape Announcement"
		notifyframelistnotifyframeaspect.TextColor3 = Color3.fromRGB(255, 255, 255)
		notifyframelistnotifyframeaspect.TextScaled = true
		notifyframelistnotifyframeaspect.TextWrapped = true
		notifyframelistnotifyframeaspect.TextXAlignment = Enum.TextXAlignment.Left
		notifyframelistnotifyframeaspect.Parent = notifyframe3
		local notifyframe2notifyframeaspect = Instance.new("TextLabel")
		notifyframe2notifyframeaspect.BackgroundTransparency = 1
		notifyframe2notifyframeaspect.BorderSizePixel = 0
		notifyframe2notifyframeaspect.Size = UDim2.new(1, 0, 0.4, 0)
		notifyframe2notifyframeaspect.Font = Enum.Font.Roboto
		notifyframe2notifyframeaspect.Text = "<b>"..announcetab.Text.."</b>"
		notifyframe2notifyframeaspect.TextColor3 = Color3.fromRGB(255, 255, 255)
		notifyframe2notifyframeaspect.TextScaled = true
		notifyframe2notifyframeaspect.TextWrapped = true
		notifyframe2notifyframeaspect.RichText = true
		notifyframe2notifyframeaspect.TextXAlignment = Enum.TextXAlignment.Left
		notifyframe2notifyframeaspect.Parent = notifyframe3
		local notifyprogress = Instance.new("Frame")
		notifyprogress.Parent = notifyframereal
		notifyprogress.BorderSizePixel = 0
		notifyprogress.BackgroundColor3 = Color3.new(1, 1, 1)
		notifyprogress.Position = UDim2.new(0, 0, 1, -3)
		notifyprogress.Size = UDim2.new(1, 0, 0, 3)
		local notifyprogresscorner = Instance.new("UICorner")
		notifyprogresscorner.CornerRadius = UDim.new(0, 100)
		notifyprogresscorner.Parent = notifyprogress
		game:GetService("TweenService"):Create(notifyframereal, TweenInfo.new(0.12), {Size = UDim2.fromScale(0.4, 0.065)}):Play()
		game:GetService("TweenService"):Create(notifyprogress, TweenInfo.new(announcetab.Time or 20, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 0, 3)}):Play()
		local sound = Instance.new("Sound")
		sound.PlayOnRemove = true
		sound.SoundId = "rbxassetid://6732495464"
		sound.Parent = workspace
		sound:Remove()
		notifyframereal.MouseButton1Click:Connect(function()
			local sound = Instance.new("Sound")
			sound.PlayOnRemove = true
			sound.SoundId = "rbxassetid://6732690176"
			sound.Parent = workspace
			sound:Remove()
			notifyframereal:Remove()
			notifyframereal = nil
		end)
		task.wait(announcetab.Time or 20)
		if notifyframereal then
			notifyframereal:Remove()
		end
	end

	local function rundata(datatab, olddatatab)
		if not olddatatab then
			if datatab.Disabled then 
				coroutine.resume(coroutine.create(function()
					repeat task.wait() until shared.VapeFullyLoaded
					task.wait(1)
					GuiLibrary.SelfDestruct()
				end))
				game:GetService("StarterGui"):SetCore("SendNotification", {
					Title = "Vape",
					Text = "Vape is currently disabled, check the discord for updates discord.gg/vaperoblox",
					Duration = 30,
				})
			end
			if datatab.KickUsers and datatab.KickUsers[tostring(lplr.UserId)] then
				lplr:Kick(datatab.KickUsers[tostring(lplr.UserId)])
			end
		else
			local newdatatab = {}
			for i,v in pairs(datatab) do 
				if not olddatatab or olddatatab[i] ~= v then 
					newdatatab[i] = v
				end
			end
			if newdatatab.Disabled then 
				coroutine.resume(coroutine.create(function()
					repeat task.wait() until shared.VapeFullyLoaded
					task.wait(1)
					GuiLibrary.SelfDestruct()
				end))
				game:GetService("StarterGui"):SetCore("SendNotification", {
					Title = "Vape",
					Text = "Vape is currently disabled, check the discord for updates discord.gg/vaperoblox",
					Duration = 30,
				})
			end
			if newdatatab.KickUsers and newdatatab.KickUsers[tostring(lplr.UserId)] then
				lplr:Kick(newdatatab.KickUsers[tostring(lplr.UserId)])
			end
			if newdatatab.Announcement and newdatatab.Announcement.ExpireTime >= os.time() then 
				task.spawn(function()
					createannouncement(newdatatab.Announcement)
				end)
			end
		end
	end
	task.spawn(function()
		pcall(function()
			if betterisfile("vape/Profiles/bedwarsdata.txt") == false then 
				writefile("vape/Profiles/bedwarsdata.txt", game:HttpGet(url, true))
			end
			local olddata = readfile("vape/Profiles/bedwarsdata.txt")
			local newdata = game:HttpGet(url, true)
			if newdata ~= olddata then 
				rundata(game:GetService("HttpService"):JSONDecode(newdata), game:GetService("HttpService"):JSONDecode(olddata))
				olddata = newdata
				writefile("vape/Profiles/bedwarsdata.txt", newdata)
			else
				rundata(game:GetService("HttpService"):JSONDecode(olddata))
			end
			repeat
				task.wait(60)
				newdata = game:HttpGet(url, true)
				if newdata ~= olddata then 
					rundata(game:GetService("HttpService"):JSONDecode(newdata), game:GetService("HttpService"):JSONDecode(olddata))
					olddata = newdata
					writefile("vape/Profiles/bedwarsdata.txt", newdata)
				end
			until uninjectflag
		end)
	end)
end)

task.spawn(function()
	repeat task.wait() until shared.VapeFullyLoaded
	if GuiLibrary.ObjectsThatCanBeSaved["Blatant modeToggle"]["Api"].Enabled then return end
	if AutoLeave.Enabled == false then
		AutoLeave.ToggleButton(false)
	end
end)