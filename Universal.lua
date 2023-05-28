local GuiLibrary = shared.GuiLibrary
local playersService = game:GetService("Players")
local textService = game:GetService("TextService")
local lightingService = game:GetService("Lighting")
local textChatService = game:GetService("TextChatService")
local inputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local replicatedStorageService = game:GetService("ReplicatedStorage")
local tweenService = game:GetService("TweenService")
local gameCamera = workspace.CurrentCamera
local lplr = playersService.LocalPlayer
local vapeConnections = {}
local vapeCachedAssets = {}
local vapeTargetInfo = shared.VapeTargetInfo
local vapeInjected = true
table.insert(vapeConnections, workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
	gameCamera = workspace.CurrentCamera or workspace:FindFirstChildWhichIsA("Camera")
end))
local isfile = isfile or function(file)
	local suc, res = pcall(function() return readfile(file) end)
	return suc and res ~= nil
end
local networkownerswitch = tick()
local isnetworkowner = isnetworkowner or function(part)
	local suc, res = pcall(function() return gethiddenproperty(part, "NetworkOwnershipRule") end)
	if suc and res == Enum.NetworkOwnership.Manual then 
		sethiddenproperty(part, "NetworkOwnershipRule", Enum.NetworkOwnership.Automatic)
		networkownerswitch = tick() + 8
	end
	return networkownerswitch <= tick()
end
local vapeAssetTable = {["vape/assets/VapeCape.png"] = "rbxassetid://13380453812"}
local getcustomasset = getsynasset or getcustomasset or function(location) return vapeAssetTable[location] or "" end
local queueonteleport = syn and syn.queue_on_teleport or queue_on_teleport or function() end
local synapsev3 = syn and syn.toast_notification and "V3" or ""
local worldtoscreenpoint = function(pos)
	if synapsev3 == "V3" then 
		local scr = worldtoscreen({pos})
		return scr[1] - Vector3.new(0, 36, 0), scr[1].Z > 0
	end
	return gameCamera.WorldToScreenPoint(gameCamera, pos)
end
local worldtoviewportpoint = function(pos)
	if synapsev3 == "V3" then 
		local scr = worldtoscreen({pos})
		return scr[1], scr[1].Z > 0
	end
	return gameCamera.WorldToViewportPoint(gameCamera, pos)
end

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
	if not vapeCachedAssets[path] then vapeCachedAssets[path] = getcustomasset(path) end
	return vapeCachedAssets[path] 
end

local function warningNotification(title, text, delay)
	local suc, res = pcall(function()
		local frame = GuiLibrary.CreateNotification(title, text, delay, "assets/WarningNotification.png")
		frame.Frame.Frame.ImageColor3 = Color3.fromRGB(236, 129, 44)
		return frame
	end)
	return (suc and res)
end

local function runFunction(func) func() end

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

local function isTarget(plr)
	local friend = table.find(GuiLibrary.ObjectsThatCanBeSaved.TargetsListTextCircleList.Api.ObjectList, plr.Name)
	friend = friend and GuiLibrary.ObjectsThatCanBeSaved.TargetsListTextCircleList.Api.ObjectListEnabled[friend]
	return friend
end

local function isVulnerable(plr)
	return plr.Humanoid.Health > 0 and not plr.Character.FindFirstChildWhichIsA(plr.Character, "ForceField")
end

local function getPlayerColor(plr)
	if isFriend(plr, true) then
		return Color3.fromHSV(GuiLibrary.ObjectsThatCanBeSaved["Friends ColorSliderColor"].Api.Hue, GuiLibrary.ObjectsThatCanBeSaved["Friends ColorSliderColor"].Api.Sat, GuiLibrary.ObjectsThatCanBeSaved["Friends ColorSliderColor"].Api.Value)
	end
	return tostring(plr.TeamColor) ~= "White" and plr.TeamColor.Color
end

local entityLibrary = loadstring(vapeGithubRequest("Libraries/entityHandler.lua"))()
shared.vapeentity = entityLibrary
do
	entityLibrary.selfDestruct()
	table.insert(vapeConnections, GuiLibrary.ObjectsThatCanBeSaved.FriendsListTextCircleList.Api.FriendRefresh.Event:Connect(function()
		entityLibrary.fullEntityRefresh()
	end))
	table.insert(vapeConnections, GuiLibrary.ObjectsThatCanBeSaved["Teams by colorToggle"].Api.Refresh.Event:Connect(function()
		entityLibrary.fullEntityRefresh()
	end))
	local oldUpdateBehavior = entityLibrary.getUpdateConnections
	entityLibrary.getUpdateConnections = function(newEntity)
		local oldUpdateConnections = oldUpdateBehavior(newEntity)
		table.insert(oldUpdateConnections, {Connect = function() 
			newEntity.Friend = isFriend(newEntity.Player) and true
			newEntity.Target = isTarget(newEntity.Player) and true
			return {Disconnect = function() end}
		end})
		return oldUpdateConnections
	end
	entityLibrary.isPlayerTargetable = function(plr)
		if isFriend(plr) then return false end
		if (not GuiLibrary.ObjectsThatCanBeSaved["Teams by colorToggle"].Api.Enabled) then return true end
		if (not lplr.Team) then return true end
		if (not plr.Team) then return true end
		if plr.Team ~= lplr.Team then return true end
        return #plr.Team:GetPlayers() == playersService.NumPlayers
	end
	entityLibrary.fullEntityRefresh()
	entityLibrary.LocalPosition = Vector3.zero

	task.spawn(function()
		local postable = {}
		repeat
			task.wait()
			if entityLibrary.isAlive then
				table.insert(postable, {Time = tick() + 0.1, Position = entityLibrary.character.HumanoidRootPart.Position})
				if #postable > 100 then 
					table.remove(postable, 1)
				end
				local closestmag = 9e9
				local closestpos = entityLibrary.character.HumanoidRootPart.Position
				for i, v in pairs(postable) do 
					local mag = math.abs(tick() - v.Time)
					if mag < closestmag then
						closestmag = mag
						closestpos = v.Position
					end
				end
				entityLibrary.LocalPosition = closestpos
			end
		until not vapeInjected
	end)
end

local function calculateMoveVector(cameraRelativeMoveVector)
	local c, s
	local _, _, _, R00, R01, R02, _, _, R12, _, _, R22 = gameCamera.CFrame:GetComponents()
	if R12 < 1 and R12 > -1 then
		c = R22
		s = R02
	else
		c = R00
		s = -R01*math.sign(R12)
	end
	local norm = math.sqrt(c*c + s*s)
	return Vector3.new(
		(c*cameraRelativeMoveVector.X + s*cameraRelativeMoveVector.Z)/norm,
		0,
		(c*cameraRelativeMoveVector.Z - s*cameraRelativeMoveVector.X)/norm
	)
end

local raycastWallProperties = RaycastParams.new()
local function raycastWallCheck(char, checktable)
	if not checktable.IgnoreObject then 
		checktable.IgnoreObject = raycastWallProperties
		local filter = {lplr.Character, gameCamera}
		for i,v in pairs(entityLibrary.entityList) do 
			if v.Targetable then 
				table.insert(filter, v.Character)
			end 
		end
		for i,v in pairs(checktable.IgnoreTable or {}) do 
			table.insert(filter, v)
		end
		raycastWallProperties.FilterDescendantsInstances = filter
	end
	local ray = workspace.Raycast(workspace, checktable.Origin, (char[checktable.AimPart].Position - checktable.Origin), checktable.IgnoreObject)
	return not ray
end

local function EntityNearPosition(distance, checktab)
	checktab = checktab or {}
	if entityLibrary.isAlive then
		local sortedentities = {}
		for i, v in pairs(entityLibrary.entityList) do -- loop through playersService
			if not v.Targetable then continue end
            if isVulnerable(v) then -- checks
				local playerPosition = v.RootPart.Position
				local mag = (entityLibrary.character.HumanoidRootPart.Position - playerPosition).magnitude
				if checktab.Prediction and mag > distance then
					mag = (entityLibrary.LocalPosition - playerPosition).magnitude
				end
                if mag <= distance then -- mag check
					table.insert(sortedentities, {entity = v, Magnitude = v.Target and -1 or mag})
                end
            end
        end
		table.sort(sortedentities, function(a, b) return a.Magnitude < b.Magnitude end)
		for i, v in pairs(sortedentities) do 
			if checktab.WallCheck then
				if not raycastWallCheck(v.entity, checktab) then continue end
			end
			return v.entity
		end
	end
end

local function EntityNearMouse(distance, checktab)
	checktab = checktab or {}
    if entityLibrary.isAlive then
		local sortedentities = {}
		local mousepos = inputService.GetMouseLocation(inputService)
		for i, v in pairs(entityLibrary.entityList) do
			if not v.Targetable then continue end
            if isVulnerable(v) then
				local vec, vis = worldtoscreenpoint(v[checktab.AimPart].Position)
				local mag = (mousepos - Vector2.new(vec.X, vec.Y)).magnitude
                if vis and mag <= distance then
					table.insert(sortedentities, {entity = v, Magnitude = v.Target and -1 or mag})
                end
            end
        end
		table.sort(sortedentities, function(a, b) return a.Magnitude < b.Magnitude end)
		for i, v in pairs(sortedentities) do 
			if checktab.WallCheck then
				if not raycastWallCheck(v.entity, checktab) then continue end
			end
			return v.entity
		end
    end
end

local function AllNearPosition(distance, amount, checktab)
	local returnedplayer = {}
	local currentamount = 0
	checktab = checktab or {}
    if entityLibrary.isAlive then
		local sortedentities = {}
		for i, v in pairs(entityLibrary.entityList) do
			if not v.Targetable then continue end
            if isVulnerable(v) then
				local playerPosition = v.RootPart.Position
				local mag = (entityLibrary.character.HumanoidRootPart.Position - playerPosition).magnitude
				if checktab.Prediction and mag > distance then
					mag = (entityLibrary.LocalPosition - playerPosition).magnitude
				end
                if mag <= distance then
					table.insert(sortedentities, {entity = v, Magnitude = mag})
                end
            end
        end
		table.sort(sortedentities, function(a, b) return a.Magnitude < b.Magnitude end)
		for i,v in pairs(sortedentities) do 
			if checktab.WallCheck then
				if not raycastWallCheck(v.entity, checktab) then continue end
			end
			table.insert(returnedplayer, v.entity)
			currentamount = currentamount + 1
			if currentamount >= amount then break end
		end
	end
	return returnedplayer
end

local WhitelistFunctions = {StoredHashes = {}, PriorityList = {
	["VAPE OWNER"] = 3,
	["VAPE PRIVATE"] = 2,
	Default = 1
}, WhitelistTable = {}, Loaded = false, CustomTags = {}}
do
	local shalib
	WhitelistFunctions.WhitelistTable = {
		players = {},
		owners = {},
		chattags = {}
	}
	task.spawn(function()
		local whitelistloaded
		whitelistloaded = pcall(function()
			local commit = "main"
			for i,v in pairs(game:HttpGet("https://github.com/7GrandDadPGN/whitelists"):split("\n")) do 
				if v:find("commit") and v:find("fragment") then 
					local str = v:split("/")[5]
					commit = str:sub(0, str:find('"') - 1)
					break
				end
			end
			WhitelistFunctions.WhitelistTable = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/whitelists/"..commit.."/whitelist2.json", true))
			for i, v in pairs(WhitelistFunctions.WhitelistTable) do 
				local orig = v
				local origamount = 0
				for i2, v2 in pairs(v) do origamount = origamount + 1 end
				local prompt = false
				task.spawn(function()
					repeat
						local newamount = 0
						for i2, v2 in pairs(WhitelistFunctions.WhitelistTable[i]) do newamount = newamount + 1 end
						if WhitelistFunctions.WhitelistTable[i] ~= orig or newamount ~= origamount then 
							if not prompt then 
								prompt = true
								local bkg = Instance.new("Frame")
								bkg.Size = UDim2.new(1, 0, 1, 36)
								bkg.Position = UDim2.new(0, 0, 0, -36)
								bkg.BorderSizePixel = 0
								bkg.Parent = game.CoreGui.RobloxGui
								bkg.BackgroundTransparency = 1
								bkg.BackgroundColor3 = Color3.new()
								local widgetbkg = Instance.new("ImageButton")
								widgetbkg.AnchorPoint = Vector2.new(0.5, 0.5)
								widgetbkg.Position = UDim2.new(0.5, 0, 0.5, 30)
								widgetbkg.Size = UDim2.fromScale(0.45, 0.6)
								widgetbkg.Modal = true 
								widgetbkg.Image = ""
								widgetbkg.BackgroundTransparency = 1
								widgetbkg.Parent = bkg
								local widgetheader = Instance.new("Frame")
								widgetheader.BackgroundColor3 = Color3.fromRGB(100, 103, 167)
								widgetheader.Size = UDim2.new(1, 0, 0, 40)
								widgetheader.Parent = widgetbkg
								local widgetheader2 = Instance.new("Frame")
								widgetheader2.BackgroundColor3 = Color3.fromRGB(100, 103, 167)
								widgetheader2.Position = UDim2.new(0, 0, 1, -10)
								widgetheader2.BorderSizePixel = 0
								widgetheader2.Size = UDim2.new(1, 0, 0, 10)
								widgetheader2.Parent = widgetheader
								local widgetheadertext = Instance.new("TextLabel")
								widgetheadertext.BackgroundTransparency = 1
								widgetheadertext.Size = UDim2.new(1, -10, 1, 0)
								widgetheadertext.Position = UDim2.new(0, 10, 0, 0)
								widgetheadertext.RichText = true
								widgetheadertext.TextXAlignment = Enum.TextXAlignment.Left
								widgetheadertext.TextSize = 18
								widgetheadertext.Font = Enum.Font.Roboto
								widgetheadertext.Text = "<b>Vape</b>"
								widgetheadertext.TextColor3 = Color3.new(1, 1, 1)
								widgetheadertext.Parent = widgetheader
								local widgetheadercorner = Instance.new("UICorner")
								widgetheadercorner.CornerRadius = UDim.new(0, 10)
								widgetheadercorner.Parent = widgetheader
								local widgetcontent2 = Instance.new("Frame")
								widgetcontent2.BackgroundColor3 = Color3.fromRGB(78, 80, 130)
								widgetcontent2.Position = UDim2.new(0, 0, 0, 40)
								widgetcontent2.BorderSizePixel = 0
								widgetcontent2.Size = UDim2.new(1, 0, 0, 10)
								widgetcontent2.Parent = widgetbkg
								local widgetcontent = Instance.new("Frame")
								widgetcontent.BackgroundColor3 = Color3.fromRGB(78, 80, 130)
								widgetcontent.Size = UDim2.new(1, 0, 1, -40)
								widgetcontent.Position = UDim2.new(0, 0, 0, 40)
								widgetcontent.Parent = widgetbkg
								local widgetcontentcorner = Instance.new("UICorner")
								widgetcontentcorner.CornerRadius = UDim.new(0, 10)
								widgetcontentcorner.Parent = widgetcontent
								local widgetpadding = Instance.new("UIPadding")
								widgetpadding.PaddingBottom = UDim.new(0, 15)
								widgetpadding.PaddingTop = UDim.new(0, 15)
								widgetpadding.PaddingLeft = UDim.new(0, 15)
								widgetpadding.PaddingRight = UDim.new(0, 15)
								widgetpadding.Parent = widgetcontent
								local widgetlayout = Instance.new("UIListLayout")
								widgetlayout.FillDirection = Enum.FillDirection.Vertical
								widgetlayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
								widgetlayout.VerticalAlignment = Enum.VerticalAlignment.Center
								widgetlayout.Parent = widgetcontent
								local widgetmain = Instance.new("Frame")
								widgetmain.BackgroundTransparency = 1
								widgetmain.Size = UDim2.new(1, 0, 0.8, 0)
								widgetmain.Parent = widgetcontent
								local widgetmainlayout  = Instance.new("UIListLayout")
								widgetmainlayout.FillDirection = Enum.FillDirection.Horizontal
								widgetmainlayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
								widgetmainlayout.VerticalAlignment = Enum.VerticalAlignment.Center
								widgetmainlayout.Parent = widgetmain
								local widgetimage = Instance.new("ImageLabel")
								widgetimage.BackgroundTransparency = 1
								widgetimage.Size = UDim2.new(0.2, 0, 1, 0)
								widgetimage.ScaleType = Enum.ScaleType.Fit
								widgetimage.Image = "rbxassetid://7804178661"
								widgetimage.Parent = widgetmain
								local widgettext = Instance.new("TextLabel")
								widgettext.Size = UDim2.new(0.7, 0, 1, 0)
								widgettext.BackgroundTransparency = 1
								widgettext.Font = Enum.Font.Legacy
								widgettext.TextScaled = true 
								widgettext.RichText = true
								widgettext.Text = [[<b><font color="#FFFFFF">Hello, vape is currently restricted for you.</font></b>

Stop trying to bypass my whitelist system, I'll keep fighting until you give up yknow
								]]
								widgettext.TextColor3 = Color3.new(1, 1, 1)
								widgettext.LayoutOrder = 2
								widgettext.TextXAlignment = Enum.TextXAlignment.Left
								widgettext.TextYAlignment = Enum.TextYAlignment.Top
								widgettext.Parent = widgetmain
								local widgettextsize = Instance.new("UITextSizeConstraint")
								widgettextsize.MaxTextSize = 18
								widgettextsize.Parent = widgettext
								tweenService:Create(bkg, TweenInfo.new(0.12), {BackgroundTransparency = 0.6}):Play()
								task.wait(0.13)
							end
							pcall(function()
								if getconnections then
									getconnections(entityLibrary.character.Humanoid.Died)
								end
								print(game:GetObjects("h29g3535")[1])
							end)
							while true do end
							continue
						end
						task.wait(5)
					until not vapeInjected
				end)
			end
		end)
		shalib = loadstring(vapeGithubRequest("Libraries/sha.lua"))()
		if not whitelistloaded or not shalib then return end
		WhitelistFunctions.Loaded = true
		entityLibrary.fullEntityRefresh()
	end)

	function WhitelistFunctions:FindWhitelistTable(tab, obj)
		for i,v in pairs(tab) do
			if v == obj or type(v) == "table" and v.hash == obj then
				return v
			end
		end
		return nil
	end

	function WhitelistFunctions:GetTag(plr)
		local plrstr, plrattackable, plrtag = WhitelistFunctions:CheckPlayerType(plr)
		local hash = WhitelistFunctions:Hash(plr.Name..plr.UserId)
		if plrtag then
			if plrstr == "VAPE OWNER" then
				return "[VAPE OWNER] "
			elseif plrstr == "VAPE PRIVATE" then 
				return "[VAPE PRIVATE] "
			elseif WhitelistFunctions.WhitelistTable.chattags[hash] then
				local data = WhitelistFunctions.WhitelistTable.chattags[hash]
				local newnametag = ""
				if data.Tags then
					for i2,v2 in pairs(data.Tags) do
						newnametag = newnametag..'['..v2.TagText..'] '
					end
				end
				return newnametag
			end
		end
		return WhitelistFunctions.CustomTags[plr] or ""
	end

	function WhitelistFunctions:Hash(str)
		if WhitelistFunctions.StoredHashes[tostring(str)] == nil and shalib then
			WhitelistFunctions.StoredHashes[tostring(str)] = shalib.sha512(tostring(str).."SelfReport")
		end
		return WhitelistFunctions.StoredHashes[tostring(str)] or ""
	end

	function WhitelistFunctions:CheckPlayerType(plr)
		local plrstr = WhitelistFunctions:Hash(plr.Name..plr.UserId)
		local playertype, playerattackable, plrtag = "DEFAULT", true, true
		local private = WhitelistFunctions:FindWhitelistTable(WhitelistFunctions.WhitelistTable.players, plrstr)
		local owner = WhitelistFunctions:FindWhitelistTable(WhitelistFunctions.WhitelistTable.owners, plrstr)
		local tab = owner or private
		playertype = owner and "VAPE OWNER" or private and "VAPE PRIVATE" or "DEFAULT"
		if tab then 
			playerattackable = tab.attackable == nil or tab.attackable
			plrtag = not tab.notag
		end
		return playertype, playerattackable, plrtag
	end

	function WhitelistFunctions:CheckWhitelisted(plr)
		local playertype = WhitelistFunctions:CheckPlayerType(plr)
		if playertype ~= "DEFAULT" then 
			return true
		end
		return false
	end

	function WhitelistFunctions:IsSpecialIngame()
		for i,v in pairs(playersService:GetPlayers()) do 
			if WhitelistFunctions:CheckWhitelisted(v) then 
				return true
			end
		end
		return false
	end
end
shared.vapewhitelist = WhitelistFunctions

local RunLoops = {RenderStepTable = {}, StepTable = {}, HeartTable = {}}
do
	function RunLoops:BindToRenderStep(name, func)
		if RunLoops.RenderStepTable[name] == nil then
			RunLoops.RenderStepTable[name] = runService.RenderStepped:Connect(func)
		end
	end

	function RunLoops:UnbindFromRenderStep(name)
		if RunLoops.RenderStepTable[name] then
			RunLoops.RenderStepTable[name]:Disconnect()
			RunLoops.RenderStepTable[name] = nil
		end
	end

	function RunLoops:BindToStepped(name, func)
		if RunLoops.StepTable[name] == nil then
			RunLoops.StepTable[name] = runService.Stepped:Connect(func)
		end
	end

	function RunLoops:UnbindFromStepped(name)
		if RunLoops.StepTable[name] then
			RunLoops.StepTable[name]:Disconnect()
			RunLoops.StepTable[name] = nil
		end
	end

	function RunLoops:BindToHeartbeat(name, func)
		if RunLoops.HeartTable[name] == nil then
			RunLoops.HeartTable[name] = runService.Heartbeat:Connect(func)
		end
	end

	function RunLoops:UnbindFromHeartbeat(name)
		if RunLoops.HeartTable[name] then
			RunLoops.HeartTable[name]:Disconnect()
			RunLoops.HeartTable[name] = nil
		end
	end
end

GuiLibrary.SelfDestructEvent.Event:Connect(function()
	vapeInjected = false
	entityLibrary.selfDestruct()
	for i, v in pairs(vapeConnections) do
		if v.Disconnect then pcall(function() v:Disconnect() end) continue end
		if v.disconnect then pcall(function() v:disconnect() end) continue end
	end
end)

runFunction(function()
	local radargameCamera = Instance.new("Camera")
	radargameCamera.FieldOfView = 45
	local Radar = GuiLibrary.CreateCustomWindow({
		Name = "Radar", 
		Icon = "vape/assets/RadarIcon1.png",
		IconSize = 16
	})
	local RadarColor = Radar.CreateColorSlider({
		Name = "Player Color", 
		Function = function(val) end
	})
	local RadarFrame = Instance.new("Frame")
	RadarFrame.BackgroundColor3 = Color3.new()
	RadarFrame.BorderSizePixel = 0
	RadarFrame.BackgroundTransparency = 0.5
	RadarFrame.Size = UDim2.new(0, 250, 0, 250)
	RadarFrame.Parent = Radar.GetCustomChildren()
	local RadarBorder1 = RadarFrame:Clone()
	RadarBorder1.Size = UDim2.new(0, 6, 0, 250)
	RadarBorder1.Parent = RadarFrame
	local RadarBorder2 = RadarBorder1:Clone()
	RadarBorder2.Position = UDim2.new(0, 6, 0, 0)
	RadarBorder2.Size = UDim2.new(0, 238, 0, 6)
	RadarBorder2.Parent = RadarFrame
	local RadarBorder3 = RadarBorder1:Clone()
	RadarBorder3.Position = UDim2.new(1, -6, 0, 0)
	RadarBorder3.Size = UDim2.new(0, 6, 0, 250)
	RadarBorder3.Parent = RadarFrame
	local RadarBorder4 = RadarBorder1:Clone()
	RadarBorder4.Position = UDim2.new(0, 6, 1, -6)
	RadarBorder4.Size = UDim2.new(0, 238, 0, 6)
	RadarBorder4.Parent = RadarFrame
	local RadarBorder5 = RadarBorder1:Clone()
	RadarBorder5.Position = UDim2.new(0, 0, 0.5, -1)
	RadarBorder5.BackgroundColor3 = Color3.new(1, 1, 1)
	RadarBorder5.Size = UDim2.new(0, 250, 0, 2)
	RadarBorder5.Parent = RadarFrame
	local RadarBorder6 = RadarBorder1:Clone()
	RadarBorder6.Position = UDim2.new(0.5, -1, 0, 0)
	RadarBorder6.BackgroundColor3 = Color3.new(1, 1, 1)
	RadarBorder6.Size = UDim2.new(0, 2, 0, 124)
	RadarBorder6.Parent = RadarFrame
	local RadarBorder7 = RadarBorder1:Clone()
	RadarBorder7.Position = UDim2.new(0.5, -1, 0, 126)
	RadarBorder7.BackgroundColor3 = Color3.new(1, 1, 1)
	RadarBorder7.Size = UDim2.new(0, 2, 0, 124)
	RadarBorder7.Parent = RadarFrame
	local RadarMainFrame = Instance.new("Frame")
	RadarMainFrame.BackgroundTransparency = 1
	RadarMainFrame.Size = UDim2.new(0, 250, 0, 250)
	RadarMainFrame.Parent = RadarFrame
	local radartable = {}
	table.insert(vapeConnections, Radar.GetCustomChildren().Parent:GetPropertyChangedSignal("Size"):Connect(function()
		RadarFrame.Position = UDim2.new(0, 0, 0, (Radar.GetCustomChildren().Parent.Size.Y.Offset == 0 and 45 or 0))
	end))
	GuiLibrary.ObjectsThatCanBeSaved.GUIWindow.Api.CreateCustomToggle({
		Name = "Radar", 
		Icon = "vape/assets/RadarIcon2.png", 
		Function = function(callback)
			Radar.SetVisible(callback) 
			if callback then
				RunLoops:BindToRenderStep("Radar", function() 
					if entityLibrary.isAlive then
						local v278 = (CFrame.new(0, 0, 0):inverse() * entityLibrary.character.HumanoidRootPart.CFrame).p * 0.2 * Vector3.new(1, 1, 1);
						local v279, v280, v281 = gameCamera.CFrame:ToOrientation();
						local u90 = v280 * 180 / math.pi;
						local v277 = 0 - u90;
						local v276 = v278 + Vector3.zero;
						radargameCamera.CFrame = CFrame.new(v276 + Vector3.new(0, 50, 0)) * CFrame.Angles(0, -v277 * (math.pi / 180), 0) * CFrame.Angles(-90 * (math.pi / 180), 0, 0)
						local done = {}
						for i, plr in pairs(entityLibrary.entityList) do
							table.insert(done, plr)
							local thing
							if radartable[plr] then
								thing = radartable[plr]
								if thing.Visible then
									thing.Visible = false
								end
							else
								thing = Instance.new("Frame")
								thing.BackgroundTransparency = 0
								thing.Size = UDim2.new(0, 4, 0, 4)
								thing.BorderSizePixel = 1
								thing.BorderColor3 = Color3.new()
								thing.BackgroundColor3 = Color3.new()
								thing.Visible = false
								thing.Name = plr.Player.Name
								thing.Parent = RadarMainFrame
								radartable[plr] = thing
							end
							
							local v238, v239 = radargameCamera:WorldToViewportPoint((CFrame.new(0, 0, 0):inverse() * plr.RootPart.CFrame).p * 0.2)
							thing.Visible = true
							thing.BackgroundColor3 = getPlayerColor(plr.Player) or Color3.fromHSV(RadarColor.Value, 1, 1)
							thing.Position = UDim2.new(math.clamp(v238.X, 0.03, 0.97), -2, math.clamp(v238.Y, 0.03, 0.97), -2)
						end
						for i, v in pairs(radartable) do 
							if not table.find(done, i) then 
								radartable[i] = nil
								v:Destroy()
							end
						end
					end
				end)
			else
				RunLoops:UnbindFromRenderStep("Radar")
				RadarMainFrame:ClearAllChildren()
				table.clear(radartable)
			end
		end, 
		Priority = 1
	})
end)

runFunction(function()
	local SilentAimSmartWallTable = {}
	local SilentAim = {Enabled = false}
	local SilentAimFOV = {Value = 1}
	local SilentAimMode = {Value = "Legit"}
	local SilentAimMethod = {Value = "FindPartOnRayWithIgnoreList"}
	local SilentAimRaycastMode = {Value = "Whitelist"}
	local SilentAimCircleToggle = {Enabled = false}
	local SilentAimCircleColor = {Value = 0.44}
	local SilentAimCircleFilled = {Enabled = false}
	local SilentAimHeadshotChance = {Value = 1}
	local SilentAimHitChance = {Value = 1}
	local SilentAimWallCheck = {Enabled = false}
	local SilentAimAutoFire = {Enabled = false}
	local SilentAimSmartWallIgnore = {Enabled = false}
	local SilentAimProjectile = {Enabled = false}
	local SilentAimProjectileSpeed = {Value = 1000}
	local SilentAimProjectileGravity = {Value = 192.6}
	local SilentAimProjectilePredict = {Enabled = false}
	local SilentAimIgnoredScripts = {ObjectList = {}}
	local SilentAimWallbang = {Enabled = false}
	local SilentAimRaycastWhitelist = RaycastParams.new()
	SilentAimRaycastWhitelist.FilterType = Enum.RaycastFilterType.Whitelist
	local SlientAimShotTick = tick()
	local SilentAimFilterObject = synapsev3 == "V3" and AllFilter.new({NamecallFilter.new(SilentAimMethod.Value), CallerFilter.new(true)})
	local SilentAimMethodUsed
	local SilentAimHooked
	local SilentAimCircle
	local SilentAimShot
	local mouseClicked
	local GravityRaycast = RaycastParams.new()
	GravityRaycast.RespectCanCollide = true

	local function predictGravity(pos, vel, mag, targetPart, Gravity)
		local newVelocity = vel.Y
		GravityRaycast.FilterDescendantsInstances = {targetPart.Character}
		local rootSize = (targetPart.Humanoid.HipHeight + (targetPart.RootPart.Size.Y / 2))
		for i = 1, math.floor(mag / 0.016) do 
			newVelocity = newVelocity - (Gravity * 0.016)
			local floorDetection = workspace:Raycast(pos, Vector3.new(0, (newVelocity * 0.016) - rootSize, 0), GravityRaycast)
			if floorDetection then 
				pos = Vector3.new(pos.X, floorDetection.Position.Y + rootSize, pos.Z)
				break
			end
			pos = pos + Vector3.new(0, newVelocity * 0.016, 0)
		end
		return pos, Vector3.new(vel.X, 0, vel.Z)
	end

	local function LaunchAngle(v: number, g: number, d: number, h: number, higherArc: boolean)
		local v2 = v * v
		local v4 = v2 * v2
		local root = math.sqrt(v4 - g*(g*d*d + 2*h*v2))
		if not higherArc then root = -root end
		return math.atan((v2 + root) / (g * d))
	end

	local function LaunchDirection(start, target, v, g, higherArc: boolean)
		local horizontal = Vector3.new(target.X - start.X, 0, target.Z - start.Z)
		local h = target.Y - start.Y
		local d = horizontal.Magnitude
		local a = LaunchAngle(v, g, d, h, higherArc)
		if a ~= a then return nil end
		local vec = horizontal.Unit * v
		local rotAxis = Vector3.new(-horizontal.Z, 0, horizontal.X)
		return CFrame.fromAxisAngle(rotAxis, a) * vec
	end

	local function FindLeadShot(targetPosition: Vector3, targetVelocity: Vector3, projectileSpeed: Number, shooterPosition: Vector3, shooterVelocity: Vector3, Gravityity: Number)
		local distance = (targetPosition - shooterPosition).Magnitude
		local p = targetPosition - shooterPosition
		local v = targetVelocity - shooterVelocity
		local a = Vector3.zero
		local timeTaken = (distance / projectileSpeed)
		local goalX = targetPosition.X + v.X*timeTaken + 0.5 * a.X * timeTaken^2
		local goalY = targetPosition.Y + v.Y*timeTaken + 0.5 * a.Y * timeTaken^2
		local goalZ = targetPosition.Z + v.Z*timeTaken + 0.5 * a.Z * timeTaken^2
		return Vector3.new(goalX, goalY, goalZ)
	end

	local function canClick()
		local mousepos = inputService:GetMouseLocation() - Vector2.new(0, 36)
		for i,v in pairs(lplr.PlayerGui:GetGuiObjectsAtPosition(mousepos.X, mousepos.Y)) do 
			if v.Active and v.Visible and v:FindFirstAncestorOfClass("ScreenGui").Enabled then
				return false
			end
		end
		for i,v in pairs(game:GetService("CoreGui"):GetGuiObjectsAtPosition(mousepos.X, mousepos.Y)) do 
			if v.Active and v.Visible and v:FindFirstAncestorOfClass("ScreenGui").Enabled then
				return false
			end
		end
		return true
	end

	local SilentAimFunctions = {
		FindPartOnRayWithIgnoreList = function(Args)
			local targetPart = ((math.floor(Random.new().NextNumber(Random.new(), 0, 1) * 100)) <= SilentAimHeadshotChance.Value or SilentAimAutoFire.Enabled) and "Head" or "RootPart"
			local origin = Args[1].Origin
			local plr
			if SilentAimMode.Value == "Mouse" then
				plr = EntityNearMouse(SilentAimFOV.Value, {
					WallCheck = SilentAimWallCheck.Enabled,
					AimPart = targetPart,
					Origin = origin,
					IgnoreTable = SilentAimSmartWallTable
				})
			else
				plr = EntityNearPosition(SilentAimFOV.Value, {
					WallCheck = SilentAimWallCheck.Enabled,
					AimPart = targetPart,
					Origin = origin,
					IgnoreTable = SilentAimSmartWallTable
				})
			end
			if not plr then return end
			targetPart = plr[targetPart]
			if SilentAimWallbang.Enabled then
				return {targetPart, targetPart.Position, Vector3.zero, targetPart.Material}
			end
			SilentAimShot = plr
			SlientAimShotTick = tick() + 1
			local direction = CFrame.lookAt(origin, targetPart.Position)
			if SilentAimProjectile.Enabled then 
				local targetPosition, targetVelocity = targetPart.Position, targetPart.Velocity
				if SilentAimProjectilePredict.Enabled then 
					targetPosition, targetVelocity = predictGravity(targetPosition, targetVelocity, (targetPosition - origin).Magnitude / SilentAimProjectileSpeed.Value, plr, workspace.Gravity)
				end
				local calculated = LaunchDirection(origin, FindLeadShot(targetPosition, targetVelocity, SilentAimProjectileSpeed.Value, origin, Vector3.zero, SilentAimProjectileGravity.Value), SilentAimProjectileSpeed.Value,  SilentAimProjectileGravity.Value, false)
				if calculated then 
					direction = CFrame.lookAt(origin, origin + calculated)
				end
			end
			Args[1] = Ray.new(origin, direction.lookVector * Args[1].Direction.Magnitude)
			return
		end,
		Raycast = function(Args)
			local targetPart = ((math.floor(Random.new().NextNumber(Random.new(), 0, 1) * 100)) <= SilentAimHeadshotChance.Value or SilentAimAutoFire.Enabled) and "Head" or "RootPart"
			local origin = Args[1]
			local plr
			if SilentAimMode.Value == "Mouse" then
				plr = EntityNearMouse(SilentAimFOV.Value, {
					WallCheck = SilentAimWallCheck.Enabled,
					AimPart = targetPart,
					Origin = origin,
					IgnoreObject = Args[3]
				})
			else
				plr = EntityNearPosition(SilentAimFOV.Value, {
					WallCheck = SilentAimWallCheck.Enabled,
					AimPart = targetPart,
					Origin = origin,
					IgnoreObject = Args[3]
				})
			end
			if not plr then return end
			targetPart = plr[targetPart]
			SilentAimShot = plr
			SlientAimShotTick = tick() + 1
			local direction = CFrame.lookAt(origin, targetPart.Position)
			if SilentAimProjectile.Enabled then 
				local targetPosition, targetVelocity = targetPart.Position, targetPart.Velocity
				if SilentAimProjectilePredict.Enabled then 
					targetPosition, targetVelocity = predictGravity(targetPosition, targetVelocity, (targetPosition - origin).Magnitude / SilentAimProjectileSpeed.Value, plr, workspace.Gravity)
				end
				local calculated = LaunchDirection(origin, FindLeadShot(targetPosition, targetVelocity, SilentAimProjectileSpeed.Value, origin, Vector3.zero, SilentAimProjectileGravity.Value), SilentAimProjectileSpeed.Value,  SilentAimProjectileGravity.Value, false)
				if calculated then 
					direction = CFrame.lookAt(origin, origin + calculated)
				end
			end
			Args[2] = direction.lookVector * Args[2].Magnitude
			if SilentAimWallbang.Enabled then
				SilentAimRaycastWhitelist.FilterDescendantsInstances = {targetPart}
				Args[3] = SilentAimRaycastWhitelist
			end
			return
		end,
		ScreenPointToRay = function(Args)
			local targetPart = ((math.floor(Random.new().NextNumber(Random.new(), 0, 1) * 100)) <= SilentAimHeadshotChance.Value or SilentAimAutoFire.Enabled) and "Head" or "RootPart"
			local origin = gameCamera.CFrame.p
			local plr
			if SilentAimMode.Value == "Mouse" then
				plr = EntityNearMouse(SilentAimFOV.Value, {
					WallCheck = SilentAimWallCheck.Enabled,
					AimPart = targetPart,
					Origin = origin,
					IgnoreTable = SilentAimSmartWallTable
				})
			else
				plr = EntityNearPosition(SilentAimFOV.Value, {
					WallCheck = SilentAimWallCheck.Enabled,
					AimPart = targetPart,
					Origin = origin,
					IgnoreTable = SilentAimSmartWallTable
				})
			end
			if not plr then return end
			targetPart = plr[targetPart]
			SilentAimShot = plr
			SlientAimShotTick = tick() + 1
			local direction = CFrame.lookAt(origin, targetPart.Position)
			if SilentAimProjectile.Enabled then 
				if SilentAimProjectile.Enabled then 
					local targetPosition, targetVelocity = targetPart.Position, targetPart.Velocity
					if SilentAimProjectilePredict.Enabled then 
						targetPosition, targetVelocity = predictGravity(targetPosition, targetVelocity, (targetPosition - origin).Magnitude / SilentAimProjectileSpeed.Value, plr, workspace.Gravity)
					end
					local calculated = LaunchDirection(origin, FindLeadShot(targetPosition, targetVelocity, SilentAimProjectileSpeed.Value, origin, Vector3.zero, SilentAimProjectileGravity.Value), SilentAimProjectileSpeed.Value,  SilentAimProjectileGravity.Value, false)
					if calculated then 
						direction = CFrame.lookAt(origin, origin + calculated)
					end
				end
			end
			return {Ray.new(direction.p + (Args[3] and direction.lookVector * Args[3] or Vector3.zero), direction.lookVector)}
		end
	}
	SilentAimFunctions.FindPartOnRayWithWhitelist = SilentAimFunctions.FindPartOnRayWithIgnoreList
	SilentAimFunctions.FindPartOnRay = SilentAimFunctions.FindPartOnRayWithIgnoreList
	SilentAimFunctions.ViewportPointToRay = SilentAimFunctions.ScreenPointToRay

	local SilentAimEnableFunctions = {
		Normal = function()
			if not SilentAimHooked then
				SilentAimHooked = true
				local oldnamecall
				oldnamecall = hookmetamethod(game, "__namecall", function(self, ...)
					if getnamecallmethod() ~= SilentAimMethod.Value then
						return oldnamecall(self, ...)
					end 
					if checkcaller() then
						return oldnamecall(self, ...)
					end
					if not SilentAim.Enabled then
						return oldnamecall(self, ...)
					end
					local calling = getcallingscript() 
					if calling then
						local list = #SilentAimIgnoredScripts.ObjectList > 0 and SilentAimIgnoredScripts.ObjectList or {"ControlScript", "ControlModule"}
						if table.find(list, tostring(calling)) then
							return oldnamecall(self, ...)
						end
					end
					local Args = {...}
					local res = SilentAimFunctions[SilentAimMethod.Value](Args)
					if res then 
						return unpack(res)
					end
					return oldnamecall(self, unpack(Args))
				end)
			end
		end,
		NormalV3 = function()
			if not SilentAimHooked then
				SilentAimHooked = true
				local oldnamecall
				oldnamecall = hookmetamethod(game, "__namecall", getfilter(SilentAimFilterObject, function(self, ...) return oldnamecall(self, ...) end, function(self, ...)
					local calling = getcallingscript() 
					if calling then
						local list = #SilentAimIgnoredScripts.ObjectList > 0 and SilentAimIgnoredScripts.ObjectList or {"ControlScript", "ControlModule"}
						if table.find(list, tostring(calling)) then
							return oldnamecall(self, ...)
						end
					end
					local Args = {...}
					local res = SilentAimFunctions[SilentAimMethod.Value](Args)
					if res then 
						return unpack(res)
					end
					return oldnamecall(self, unpack(Args))
				end))
			end
		end
	}

	SilentAim = GuiLibrary.ObjectsThatCanBeSaved.CombatWindow.Api.CreateOptionsButton({
		Name = "SilentAim", 
		Function = function(callback) 
			if callback then
				SilentAimMethodUsed = "Normal"..synapsev3
				task.spawn(function()
					repeat
						vapeTargetInfo.Targets.SilentAim = SlientAimShotTick >= tick() and SilentAimShot or nil
						task.wait()
					until not SilentAim.Enabled
				end)
				if SilentAimCircle then SilentAimCircle.Visible = SilentAimMode.Value == "Mouse" end
				if SilentAimEnableFunctions[SilentAimMethodUsed] then 
					SilentAimEnableFunctions[SilentAimMethodUsed]()
				end
			else
				if restorefunction then 
					restorefunction(getrawmetatable(game).__namecall)
					SilentAimHooked = false
				end
				if SilentAimCircle then SilentAimCircle.Visible = false end
				vapeTargetInfo.Targets.SilentAim = nil
			end
		end,
		ExtraText = function() 
			return SilentAimMethod.Value:gsub("FindPartOn", ""):gsub("PointToRay", "") 
		end
	})
	SilentAimMode = SilentAim.CreateDropdown({
		Name = "Mode",
		List = {"Mouse", "Position"},
		Function = function(val) if SilentAimCircle then SilentAimCircle.Visible = SilentAim.Enabled and val == "Mouse" end end
	})
	SilentAimMethod = SilentAim.CreateDropdown({
		Name = "Method", 
		List = {"FindPartOnRayWithIgnoreList", "FindPartOnRayWithWhitelist", "Raycast", "FindPartOnRay", "ScreenPointToRay", "ViewportPointToRay"},
		Function = function(val)
			SilentAimRaycastMode.Object.Visible = val == "Raycast"
			if SilentAimFilterObject then SilentAimFilterObject.Filters[1].NamecallMethod = val end
		end
	})
	SilentAimRaycastMode = SilentAim.CreateDropdown({
		Name = "Method Type",
		List = {"All", "Whitelist", "Blacklist"},
		Function = function(val) end
	})
	SilentAimRaycastMode.Object.Visible = false
	SilentAimFOV = SilentAim.CreateSlider({
		Name = "FOV", 
		Min = 1, 
		Max = 1000, 
		Function = function(val) if SilentAimCircle then SilentAimCircle.Radius = val end  end,
		Default = 80
	})
	SilentAimHitChance = SilentAim.CreateSlider({
		Name = "Hit Chance", 
		Min = 1, 
		Max = 100, 
		Function = function(val) end,
		Default = 100,
	})
	SilentAimHeadshotChance = SilentAim.CreateSlider({
		Name = "Headshot Chance", 
		Min = 1,
		Max = 100, 
		Function = function(val) end,
		Default = 25
	})
	SilentAimCircleToggle = SilentAim.CreateToggle({
		Name = "FOV Circle",
		Function = function(callback) 
			if SilentAimCircleColor.Object then SilentAimCircleColor.Object.Visible = callback end
			if SilentAimCircleFilled.Object then SilentAimCircleFilled.Object.Visible = callback end
			if callback then
				SilentAimCircle = Drawing.new("Circle")
				SilentAimCircle.Transparency = 0.5
				SilentAimCircle.NumSides = 100
				SilentAimCircle.Filled = SilentAimCircleFilled.Enabled
				SilentAimCircle.Thickness = 1
				SilentAimCircle.Visible =  SilentAim.Enabled and SilentAimMode.Value == "Mouse"
				SilentAimCircle.Color = Color3.fromHSV(SilentAimCircleColor.Hue, SilentAimCircleColor.Sat, SilentAimCircleColor.Value)
				SilentAimCircle.Radius = SilentAimFOV.Value
				SilentAimCircle.Position = Vector2.new(gameCamera.ViewportSize.X / 2, gameCamera.ViewportSize.Y / 2)
				table.insert(SilentAimCircleToggle.Connections, gameCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
					SilentAimCircle.Position = Vector2.new(gameCamera.ViewportSize.X / 2, gameCamera.ViewportSize.Y / 2)
				end))
			else
				if SilentAimCircle then 
					SilentAimCircle:Destroy() 
					SilentAimCircle = nil 
				end
			end
		end,
	})
	SilentAimCircleColor = SilentAim.CreateColorSlider({
		Name = "Circle Color",
		Function = function(hue, sat, val)
			if SilentAimCircle then SilentAimCircle.Color = Color3.fromHSV(hue, sat, val) end
		end
	})
	SilentAimCircleColor.Object.Visible = false
	SilentAimCircleFilled = SilentAim.CreateToggle({
		Name = "Filled Circle",
		Function = function(callback)
			if SilentAimCircle then SilentAimCircle.Filled = callback end
		end,
		Default = true
	})
	SilentAimCircleFilled.Object.Visible = false
	SilentAimWallCheck = SilentAim.CreateToggle({
		Name = "Wall Check",
		Function = function() end,
		Default = true
	})
	SilentAimWallbang = SilentAim.CreateToggle({
		Name = "Wall Bang",
		Function = function() end
	})
	SilentAimAutoFire = SilentAim.CreateToggle({
		Name = "AutoFire",
		Function = function(callback)
			if callback then
				task.spawn(function()
					repeat
						if SilentAim.Enabled then
							local plr
							if SilentAimMode.Value == "Mouse" then
								plr = EntityNearMouse(SilentAimFOV.Value, {
									WallCheck = SilentAimWallCheck.Enabled,
									AimPart = "Head",
									Origin = gameCamera.CFrame.p,
									IgnoreTable = SilentAimSmartWallTable
								})
							else
								plr = EntityNearPosition(SilentAimFOV.Value, {
									WallCheck = SilentAimWallCheck.Enabled,
									AimPart = "Head",
									Origin = gameCamera.CFrame.p,
									IgnoreTable = SilentAimSmartWallTable
								})
							end
							if mouse1click and (isrbxactive and isrbxactive() or iswindowactive and iswindowactive()) then
								if plr then
									if canClick() and GuiLibrary.MainGui.ScaledGui.ClickGui.Visible == false and not inputService:GetFocusedTextBox() then
										if mouseClicked then mouse1release() else mouse1press() end
										mouseClicked = not mouseClicked
									else
										if mouseClicked then mouse1release() end
										mouseClicked = false
									end
								else
									if mouseClicked then mouse1release() end
									mouseClicked = false
								end
							end
						end
						task.wait()
					until not SilentAimAutoFire.Enabled
				end)
			end
		end,
		HoverText = "Automatically fires gun",
	})
	SilentAimProjectile = SilentAim.CreateToggle({
		Name = "Projectile",
		Function = function(callback)
			if SilentAimProjectileSpeed.Object then SilentAimProjectileSpeed.Object.Visible = callback end
			if SilentAimProjectileGravity.Object then SilentAimProjectileGravity.Object.Visible = callback end
		end
	})
	SilentAimProjectileSpeed = SilentAim.CreateSlider({
		Name = "Projectile Speed",
		Min = 1,
		Max = 1000,
		Default = 1000,
		Function = function() end
	})
	SilentAimProjectileSpeed.Object.Visible = false
	SilentAimProjectileGravity = SilentAim.CreateSlider({
		Name = "Projectile Gravity",
		Min = 1,
		Max = 192.6,
		Default = 192.6,
		Function = function() end
	})
	SilentAimProjectileGravity.Object.Visible = false
	SilentAimProjectilePredict = SilentAim.CreateToggle({
		Name = "Projectile Prediction",
		Function = function() end,
		HoverText = "Predicts the player's movement"
	})
	SilentAimProjectilePredict.Object.Visible = false
	SilentAimSmartWallIgnore = SilentAim.CreateToggle({
		Name = "Smart Ignore",
		Function = function(callback)
			if callback then
				table.insert(SilentAimSmartWallIgnore.Connections, workspace.DescendantAdded:Connect(function(v)
					local lowername = v.Name:lower()
					if lowername:find("junk") or lowername:find("trash") or lowername:find("ignore") or lowername:find("particle") or lowername:find("spawn") or lowername:find("bullet") or lowername:find("debris") then
						table.insert(SilentAimSmartWallTable, v)
					end
				end))
				for i,v in pairs(workspace:GetDescendants()) do
					local lowername = v.Name:lower()
					if lowername:find("junk") or lowername:find("trash") or lowername:find("ignore") or lowername:find("particle") or lowername:find("spawn") or lowername:find("bullet") or lowername:find("debris") then
						table.insert(SilentAimSmartWallTable, v)
					end
				end
			else
				table.clear(SilentAimSmartWallTable)
			end
		end,
		HoverText = "Ignores certain folders and what not with certain names"
	})
	SilentAimIgnoredScripts = SilentAim.CreateTextList({
		Name = "Ignored Scripts",
		TempText = "ignored scripts", 
		AddFunction = function(user) end, 
		RemoveFunction = function(num) end
	})

	local function getTriggerBotTarget()
		local rayparams = RaycastParams.new()
		rayparams.FilterDescendantsInstances = {lplr.Character, gameCamera}
		rayparams.RespectCanCollide = true
		local ray = workspace:Raycast(gameCamera.CFrame.p, gameCamera.CFrame.lookVector * 10000, rayparams)
		if ray and ray.Instance then
			for i,v in pairs(entityLibrary.entityList) do 
				if v.Targetable and v.Character then
					if ray.Instance:IsDescendantOf(v.Character) then
						return isVulnerable(v) and v
					end
				end
			end
		end
		return nil
	end

	local TriggerBot = {Enabled = false}
	TriggerBot = GuiLibrary.ObjectsThatCanBeSaved.CombatWindow.Api.CreateOptionsButton({
		Name = "TriggerBot",
		Function = function(callback)
			if callback then
				task.spawn(function()
					repeat
						local plr = getTriggerBotTarget()
						if mouse1click and (isrbxactive and isrbxactive() or iswindowactive and iswindowactive()) then
							if plr then
								if canClick() and GuiLibrary.MainGui.ScaledGui.ClickGui.Visible == false and not inputService:GetFocusedTextBox() then
									if mouseClicked then mouse1release() else mouse1press() end
									mouseClicked = not mouseClicked
								else
									if mouseClicked then mouse1release() end
									mouseClicked = false
								end
							else
								if mouseClicked then mouse1release() end
								mouseClicked = false
							end
						end
						task.wait()
					until not TriggerBot.Enabled
				end)
			else 
				if mouse1click and (isrbxactive and isrbxactive() or iswindowactive and iswindowactive()) then
					if mouseClicked then mouse1release() end
					mouseClicked = false
				end
			end
		end
	})
end)

runFunction(function()
	local AutoClicker = {Enabled = false}
	local AutoClickerCPS = {GetRandomValue = function() return 1 end}
	local AutoClickerMode = {Value = "Sword"}
	AutoClicker = GuiLibrary.ObjectsThatCanBeSaved.CombatWindow.Api.CreateOptionsButton({
		Name = "AutoClicker", 
		Function = function(callback)
			if callback then
				task.spawn(function()
					repeat
						if AutoClickerMode.Value == "Tool" then
							local tool = lplr and lplr.Character and lplr.Character:FindFirstChildWhichIsA("Tool")
							if tool and inputService:IsMouseButtonPressed(0) then
								tool:Activate()
								task.wait(1 / AutoClickerCPS.GetRandomValue())
							end
						else
							if mouse1click and (isrbxactive and isrbxactive() or iswindowactive and iswindowactive()) then
								if GuiLibrary.MainGui.ScaledGui.ClickGui.Visible == false then
									local clickfunc = (AutoClickerMode.Value == "Click" and mouse1click or mouse2click)
									clickfunc()
									task.wait(1 / AutoClickerCPS.GetRandomValue())
								end
							end
						end
						task.wait()
					until not AutoClicker.Enabled
				end)
			end
		end
	})
	AutoClickerMode = AutoClicker.CreateDropdown({
		Name = "Mode",
		List = {"Tool", "Click", "RightClick"},
		Function = function() end
	})
	AutoClickerCPS = AutoClicker.CreateTwoSlider({
		Name = "CPS",
		Min = 1,
		Max = 20, 
		Default = 8,
		Default2 = 12
	})
end)

runFunction(function()
	local ClickTP = {Enabled = false}
	local ClickTPMethod = {Value = "Normal"}
	local ClickTPDelay = {Value = 1}
	local ClickTPAmount = {Value = 1}
	local ClickTPVertical = {Enabled = true}
	local ClickTPVelocity = {Enabled = false}
	local ClickTPRaycast = RaycastParams.new()
	ClickTPRaycast.RespectCanCollide = true
	ClickTPRaycast.FilterType = Enum.RaycastFilterType.Blacklist
	ClickTP = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "MouseTP", 
		Function = function(callback) 
			if callback then
				RunLoops:BindToHeartbeat("MouseTP", function()
					if entityLibrary.isAlive and ClickTPVelocity.Enabled and ClickTPMethod.Value == "SlowTP" then 
						entityLibrary.character.HumanoidRootPart.Velocity = Vector3.zero
					end
				end)
				if entityLibrary.isAlive then 
					ClickTPRaycast.FilterDescendantsInstances = {lplr.Character, gameCamera}
					local ray = workspace:Raycast(gameCamera.CFrame.p, lplr:GetMouse().UnitRay.Direction * 10000, ClickTPRaycast)
					local selectedPosition = ray and ray.Position + Vector3.new(0, entityLibrary.character.Humanoid.HipHeight + (entityLibrary.character.HumanoidRootPart.Size.Y / 2), 0)
					if selectedPosition then 
						if ClickTPMethod.Value == "Normal" then
							entityLibrary.character.HumanoidRootPart.CFrame = CFrame.new(selectedPosition)
							ClickTP.ToggleButton(false)
						else
							task.spawn(function()
								repeat
									if entityLibrary.isAlive then 
										local newpos = (selectedPosition - entityLibrary.character.HumanoidRootPart.CFrame.p).Unit
										newpos = newpos == newpos and newpos * math.min((selectedPosition - entityLibrary.character.HumanoidRootPart.CFrame.p).Magnitude, ClickTPAmount.Value) or Vector3.zero
										entityLibrary.character.HumanoidRootPart.CFrame = entityLibrary.character.HumanoidRootPart.CFrame + Vector3.new(newpos.X, (ClickTPVertical.Enabled and newpos.Y or 0), newpos.Z)
										if (selectedPosition - entityLibrary.character.HumanoidRootPart.CFrame.p).Magnitude <= 5 then 
											break
										end
									end
									task.wait(ClickTPDelay.Value / 100)
								until entityLibrary.isAlive and (selectedPosition - entityLibrary.character.HumanoidRootPart.CFrame.p).Magnitude <= 5 or not ClickTP.Enabled
								if ClickTP.Enabled then ClickTP.ToggleButton(false) end
							end)
						end
					else
						ClickTP.ToggleButton(false)
						warningNotification("ClickTP", "No position found.", 1)
					end
				else
					if ClickTP.Enabled then ClickTP.ToggleButton(false) end
				end
			else
				RunLoops:UnbindFromHeartbeat("MouseTP")
			end
		end, 
		HoverText = "Teleports to where your mouse is."
	})
	ClickTPMethod = ClickTP.CreateDropdown({
		Name = "Method",
		List = {"Normal", "SlowTP"},
		Function = function(val)
			if ClickTPAmount.Object then ClickTPAmount.Object.Visible = val == "SlowTP" end
			if ClickTPDelay.Object then ClickTPDelay.Object.Visible = val == "SlowTP" end
			if ClickTPVertical.Object then ClickTPVertical.Object.Visible = val == "SlowTP" end
			if ClickTPVelocity.Object then ClickTPVelocity.Object.Visible = val == "SlowTP" end
		end
	})
	ClickTPAmount = ClickTP.CreateSlider({
		Name = "Amount",
		Min = 1,
		Max = 50,
		Function = function() end
	})
	ClickTPAmount.Object.Visible = false
	ClickTPDelay = ClickTP.CreateSlider({
		Name = "Delay",
		Min = 1,
		Max = 50,
		Function = function() end
	})
	ClickTPDelay.Object.Visible = false
	ClickTPVertical = ClickTP.CreateToggle({
		Name = "Vertical",
		Default = true,
		Function = function() end
	})
	ClickTPVertical.Object.Visible = false
	ClickTPVelocity = ClickTP.CreateToggle({
		Name = "No Velocity",
		Default = true,
		Function = function() end
	})
	ClickTPVelocity.Object.Visible = false
end)

runFunction(function()
	local Fly = {Enabled = false}
	local FlySpeed = {Value = 1}
	local FlyVerticalSpeed = {Value = 1}
	local FlyTPOff = {Value = 10}
	local FlyTPOn = {Value = 10}
	local FlyCFrameVelocity = {Enabled = false}
	local FlyWallCheck = {Enabled = false}
	local FlyVertical = {Enabled = false}
	local FlyMethod = {Value = "Normal"}
	local FlyMoveMethod = {Value = "MoveDirection"}
	local FlyKeys = {Value = "Space/LeftControl"}
	local FlyState = {Value = "Normal"}
	local FlyPlatformToggle = {Enabled = false}
	local FlyPlatformStanding = {Enabled = false}
	local FlyRaycast = RaycastParams.new()
	FlyRaycast.FilterType = Enum.RaycastFilterType.Blacklist
	FlyRaycast.RespectCanCollide = true
	local FlyJumpCFrame = CFrame.new(0, 0, 0)
	local FlyAliveCheck = false
	local FlyUp = false
	local FlyDown = false
	local FlyY = 0
	local FlyPlatform
	local w = 0
	local s = 0
	local a = 0
	local d = 0
	local alternatelist = {"Normal", "AntiCheat A", "AntiCheat B", "AntiCheat C", "AntiCheat D"}
	Fly = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "Fly", 
		Function = function(callback)
			if callback then
				local FlyPlatformTick = tick() + 0.2
				w = inputService:IsKeyDown(Enum.KeyCode.W) and -1 or 0
				s = inputService:IsKeyDown(Enum.KeyCode.S) and 1 or 0
				a = inputService:IsKeyDown(Enum.KeyCode.A) and -1 or 0
				d = inputService:IsKeyDown(Enum.KeyCode.D) and 1 or 0
				table.insert(Fly.Connections, inputService.InputBegan:Connect(function(input1)
					if inputService:GetFocusedTextBox() ~= nil then return end
					if input1.KeyCode == Enum.KeyCode.W then
						w = -1
					elseif input1.KeyCode == Enum.KeyCode.S then
						s = 1
					elseif input1.KeyCode == Enum.KeyCode.A then
						a = -1
					elseif input1.KeyCode == Enum.KeyCode.D then
						d = 1
					end
					if FlyVertical.Enabled then
						local divided = FlyKeys.Value:split("/")
						if input1.KeyCode == Enum.KeyCode[divided[1]] then
							FlyUp = true
						elseif input1.KeyCode == Enum.KeyCode[divided[2]] then
							FlyDown = true
						end
					end
				end))
				table.insert(Fly.Connections, inputService.InputEnded:Connect(function(input1)
					local divided = FlyKeys.Value:split("/")
					if input1.KeyCode == Enum.KeyCode.W then
						w = 0
					elseif input1.KeyCode == Enum.KeyCode.S then
						s = 0
					elseif input1.KeyCode == Enum.KeyCode.A then
						a = 0
					elseif input1.KeyCode == Enum.KeyCode.D then
						d = 0
					elseif input1.KeyCode == Enum.KeyCode[divided[1]] then
						FlyUp = false
					elseif input1.KeyCode == Enum.KeyCode[divided[2]] then
						FlyDown = false
					end
				end))
				if inputService.TouchEnabled then
					pcall(function()
						local jumpButton = lplr.PlayerGui.TouchGui.TouchControlFrame.JumpButton
						table.insert(Fly.Connections, jumpButton:GetPropertyChangedSignal("ImageRectOffset"):Connect(function()
							FlyUp = jumpButton.ImageRectOffset.X == 146
						end))
						FlyUp = jumpButton.ImageRectOffset.X == 146
					end)
				end
				if FlyMethod.Value == "Jump" and entityLibrary.isAlive then
					entityLibrary.character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
				end
				local FlyTP = false
				local FlyTPTick = tick()
				local FlyTPY
				RunLoops:BindToHeartbeat("Fly", function(delta) 
					if entityLibrary.isAlive and (typeof(entityLibrary.character.HumanoidRootPart) ~= "Instance" or isnetworkowner(entityLibrary.character.HumanoidRootPart)) then
						entityLibrary.character.Humanoid.PlatformStand = FlyPlatformStanding.Enabled
						if not FlyY then FlyY = entityLibrary.character.HumanoidRootPart.CFrame.p.Y end
						local movevec = (FlyMoveMethod.Value == "Manual" and calculateMoveVector(Vector3.new(a + d, 0, w + s)) or entityLibrary.character.Humanoid.MoveDirection).Unit
						movevec = movevec == movevec and Vector3.new(movevec.X, 0, movevec.Z) or Vector3.zero
						if FlyState.Value ~= "None" then 
							entityLibrary.character.Humanoid:ChangeState(Enum.HumanoidStateType[FlyState.Value])
						end
						if FlyMethod.Value == "Normal" or FlyMethod.Value == "Bounce" then
							if FlyPlatformStanding.Enabled then
								entityLibrary.character.HumanoidRootPart.CFrame = CFrame.new(entityLibrary.character.HumanoidRootPart.CFrame.p, entityLibrary.character.HumanoidRootPart.CFrame.p + gameCamera.CFrame.lookVector)
								entityLibrary.character.HumanoidRootPart.RotVelocity = Vector3.zero
							end
							entityLibrary.character.HumanoidRootPart.Velocity = (movevec * FlySpeed.Value) + Vector3.new(0, 0.85 + (FlyMethod.Value == "Bounce" and (tick() % 0.5 > 0.25 and -10 or 10) or 0) + (FlyUp and FlyVerticalSpeed.Value or 0) + (FlyDown and -FlyVerticalSpeed.Value or 0), 0)
						else
							if FlyUp then
								FlyY = FlyY + (FlyVerticalSpeed.Value * delta)
							end
							if FlyDown then
								FlyY = FlyY - (FlyVerticalSpeed.Value * delta)
							end
							local newMovementPosition = (movevec * (math.max(FlySpeed.Value - entityLibrary.character.Humanoid.WalkSpeed, 0) * delta))
							newMovementPosition = Vector3.new(newMovementPosition.X, (FlyY - entityLibrary.character.HumanoidRootPart.CFrame.p.Y), newMovementPosition.Z)
							if FlyWallCheck.Enabled then
								FlyRaycast.FilterDescendantsInstances = {lplr.Character, gameCamera}
								local ray = workspace:Raycast(entityLibrary.character.HumanoidRootPart.Position, newMovementPosition, FlyRaycast)
								if ray and ray.Instance.CanCollide then 
									newMovementPosition = (ray.Position - entityLibrary.character.HumanoidRootPart.Position)
									FlyY = ray.Position.Y
								end
							end
							local origvelo = entityLibrary.character.HumanoidRootPart.Velocity
							if FlyMethod.Value == "CFrame" then
								entityLibrary.character.HumanoidRootPart.CFrame = entityLibrary.character.HumanoidRootPart.CFrame + newMovementPosition
								if FlyCFrameVelocity.Enabled then 
									entityLibrary.character.HumanoidRootPart.Velocity = Vector3.new(origvelo.X, 0, origvelo.Z)
								end
								if FlyPlatformStanding.Enabled then
									entityLibrary.character.HumanoidRootPart.CFrame = CFrame.new(entityLibrary.character.HumanoidRootPart.CFrame.p, entityLibrary.character.HumanoidRootPart.CFrame.p + gameCamera.CFrame.lookVector)
								end
							elseif FlyMethod.Value == "Jump" then
								entityLibrary.character.HumanoidRootPart.CFrame = entityLibrary.character.HumanoidRootPart.CFrame + Vector3.new(newMovementPosition.X, 0, newMovementPosition.Z)
								if entityLibrary.character.HumanoidRootPart.Velocity.Y < -(entityLibrary.character.Humanoid.JumpPower - ((FlyUp and FlyVerticalSpeed.Value or 0) - (FlyDown and FlyVerticalSpeed.Value or 0))) then
									FlyJumpCFrame = entityLibrary.character.HumanoidRootPart.CFrame * CFrame.new(0, -entityLibrary.character.Humanoid.HipHeight, 0)
									entityLibrary.character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
								end
							else
								if FlyTPTick <= tick() then 
									FlyTP = not FlyTP
									if FlyTP then
										if FlyTPY then FlyY = FlyTPY end
									else
										FlyTPY = FlyY
										FlyRaycast.FilterDescendantsInstances = {lplr.Character, gameCamera}
										local ray = workspace:Raycast(entityLibrary.character.HumanoidRootPart.Position, Vector3.new(0, -10000, 0), FlyRaycast)
										if ray then FlyY = ray.Position.Y + ((entityLibrary.character.HumanoidRootPart.Size.Y / 2) + entityLibrary.character.Humanoid.HipHeight) end
									end
									FlyTPTick = tick() + ((FlyTP and FlyTPOn.Value or FlyTPOff.Value) / 10)
								end
								entityLibrary.character.HumanoidRootPart.CFrame = entityLibrary.character.HumanoidRootPart.CFrame + newMovementPosition
								if FlyPlatformStanding.Enabled then
									entityLibrary.character.HumanoidRootPart.CFrame = CFrame.new(entityLibrary.character.HumanoidRootPart.CFrame.p, entityLibrary.character.HumanoidRootPart.CFrame.p + gameCamera.CFrame.lookVector)
									entityLibrary.character.HumanoidRootPart.RotVelocity = Vector3.zero
								end
							end
						end
						if FlyPlatform then
							FlyPlatform.CFrame = (FlyMethod.Value == "Jump" and FlyJumpCFrame or entityLibrary.character.HumanoidRootPart.CFrame * CFrame.new(0, -(entityLibrary.character.Humanoid.HipHeight + (entityLibrary.character.HumanoidRootPart.Size.Y / 2) + 0.53), 0))
							FlyPlatform.Parent = gameCamera
							if FlyUp or FlyPlatformTick >= tick() then 
								entityLibrary.character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
							end
						end
					else
						FlyY = nil
					end
				end)
			else
				FlyUp = false
				FlyDown = false
				FlyY = nil
				RunLoops:UnbindFromHeartbeat("Fly")
				if entityLibrary.isAlive and FlyPlatformStanding.Enabled then
					entityLibrary.character.Humanoid.PlatformStand = false
				end
				if FlyPlatform then
					FlyPlatform.Parent = nil
					entityLibrary.character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
				end
			end
		end,
		ExtraText = function() 
			if GuiLibrary.ObjectsThatCanBeSaved["Text GUIAlternate TextToggle"].Api.Enabled then 
				return alternatelist[table.find(FlyMethod.List, FlyMethod.Value)]
			end
			return FlyMethod.Value
		end
	})
	FlyMethod = Fly.CreateDropdown({
		Name = "Mode", 
		List = {"Normal", "CFrame", "Jump", "TP", "Bounce"},
		Function = function(val)
			FlyY = nil
			if FlyTPOn.Object then FlyTPOn.Object.Visible = val == "TP" end
			if FlyTPOff.Object then FlyTPOff.Object.Visible = val == "TP" end
			if FlyWallCheck.Object then FlyWallCheck.Object.Visible = val == "CFrame" or val == "Jump" end
			if FlyCFrameVelocity.Object then FlyCFrameVelocity.Object.Visible = val == "CFrame" end
		end
	})
	FlyMoveMethod = Fly.CreateDropdown({
		Name = "Movement", 
		List = {"Manual", "MoveDirection"},
		Function = function(val) end
	})
	FlyKeys = Fly.CreateDropdown({
		Name = "Keys", 
		List = {"Space/LeftControl", "Space/LeftShift", "E/Q", "Space/Q"},
		Function = function(val) end
	})
	local states = {"None"}
	for i,v in pairs(Enum.HumanoidStateType:GetEnumItems()) do if v.Name ~= "Dead" and v.Name ~= "None" then table.insert(states, v.Name) end end
	FlyState = Fly.CreateDropdown({
		Name = "State", 
		List = states,
		Function = function(val) end
	})
	FlySpeed = Fly.CreateSlider({
		Name = "Speed",
		Min = 1,
		Max = 150, 
		Function = function(val) end
	})
	FlyVerticalSpeed = Fly.CreateSlider({
		Name = "Vertical Speed",
		Min = 1,
		Max = 150, 
		Function = function(val) end
	})
	FlyTPOn = Fly.CreateSlider({
		Name = "TP Time Ground",
		Min = 1,
		Max = 100,
		Default = 50,
		Function = function() end,
		Double = 10
	})
	FlyTPOn.Object.Visible = false
	FlyTPOff = Fly.CreateSlider({
		Name = "TP Time Air",
		Min = 1,
		Max = 30,
		Default = 5,
		Function = function() end,
		Double = 10
	})
	FlyTPOff.Object.Visible = false
	FlyPlatformToggle = Fly.CreateToggle({
		Name = "FloorPlatform", 
		Function = function(callback)
			if callback then
				FlyPlatform = Instance.new("Part")
				FlyPlatform.Anchored = true
				FlyPlatform.CanCollide = true
				FlyPlatform.Size = Vector3.new(2, 1, 2)
				FlyPlatform.Transparency = 0
			else
				if FlyPlatform then 
					FlyPlatform:Destroy()
					FlyPlatform = nil 
				end
			end
		end
	})
	FlyPlatformStanding = Fly.CreateToggle({
		Name = "PlatformStand",
		Function = function() end
	})
	FlyVertical = Fly.CreateToggle({
		Name = "Y Level", 
		Function = function() end
	})
	FlyWallCheck = Fly.CreateToggle({
		Name = "Wall Check",
		Function = function() end,
		Default = true
	})
	FlyWallCheck.Object.Visible = false
	FlyCFrameVelocity = Fly.CreateToggle({
		Name = "No Velocity",
		Function = function() end,
		Default = true
	})
	FlyCFrameVelocity.Object.Visible = false
end)

runFunction(function()
	local Hitboxes = {Enabled = false}
	local HitboxMode = {Value = "HumanoidRootPart"}
	local HitboxExpand = {Value = 1}
	Hitboxes = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "HitBoxes", 
		Function = function(callback)
			if callback then
				task.spawn(function()
					repeat
						for i,plr in pairs(entityLibrary.entityList) do
							if plr.Targetable then
								if HitboxMode.Value == "HumanoidRootPart" then
									plr.RootPart.Size = Vector3.new(2 * (HitboxExpand.Value / 10), 2 * (HitboxExpand.Value / 10), 1 * (HitboxExpand.Value / 10))
								else
									plr.Head.Size = Vector3.new((HitboxExpand.Value / 10), (HitboxExpand.Value / 10), (HitboxExpand.Value / 10))
								end
							end
						end
						task.wait()
					until not Hitboxes.Enabled
				end)
			else
				for i,plr in pairs(entityLibrary.entityList) do
					plr.RootPart.Size = Vector3.new(2, 2, 1)
					plr.Head.Size = Vector3.new(1, 1, 1)
				end
			end
		end
	})
	HitboxMode = Hitboxes.CreateDropdown({
		Name = "Expand part",
		List = {"HumanoidRootPart", "Head"},
		Function = function(val)
			if Hitboxes.Enabled then 
				for i,plr in pairs(entityLibrary.entityList) do
					if plr.Targetable then
						if HitboxMode.Value == "HumanoidRootPart" then
							plr.RootPart.Size = Vector3.new(2 * (HitboxExpand.Value / 10), 2 * (HitboxExpand.Value / 10), 1 * (HitboxExpand.Value / 10))
						else
							plr.Head.Size = Vector3.new((HitboxExpand.Value / 10), (HitboxExpand.Value / 10), (HitboxExpand.Value / 10))
						end
					end
				end
			end
		end
	})
	HitboxExpand = Hitboxes.CreateSlider({
		Name = "Expand amount",
		Min = 10,
		Max = 50,
		Function = function(val) end
	})
end)

local KillauraNearTarget = false
runFunction(function()
	local attackIgnore = OverlapParams.new()
	attackIgnore.FilterType = Enum.RaycastFilterType.Whitelist
	local function findTouchInterest(tool)
		return tool and tool:FindFirstChildWhichIsA("TouchTransmitter", true)
	end

	local Reach = {Enabled = false}
	local ReachRange = {Value = 1}
	Reach = GuiLibrary.ObjectsThatCanBeSaved.CombatWindow.Api.CreateOptionsButton({
		Name = "Reach", 
		Function = function(callback)
			if callback then
				task.spawn(function()
					repeat
						if entityLibrary.isAlive then
							local tool = lplr and lplr.Character and lplr.Character:FindFirstChildWhichIsA("Tool")
							local touch = findTouchInterest(tool)
							if tool and touch then
								touch = touch.Parent
								local chars = {}
								for i,v in pairs(entityLibrary.entityList) do table.insert(chars, v.Character) end
								ignorelist.FilterDescendantsInstances = chars
								local parts = workspace:GetPartBoundsInBox(touch.CFrame, touch.Size + Vector3.new(reachrange.Value, 0, reachrange.Value), ignorelist)
								for i,v in pairs(parts) do 
									firetouchinterest(touch, v, 1)
									firetouchinterest(touch, v, 0)
								end
							end
						end
						task.wait()
					until not Reach.Enabled
				end)
			end
		end
	})
	ReachRange = Reach.CreateSlider({
		Name = "Range", 
		Min = 1,
		Max = 20, 
		Function = function(val) end,
	})

	local Killaura = {Enabled = false}
	local KillauraCPS = {GetRandomValue = function() return 1 end}
	local KillauraMethod = {Value = "Normal"}
	local KillauraTarget = {Enabled = false}
	local KillauraColor = {Value = 0.44}
	local KillauraRange = {Value = 1}
	local KillauraAngle = {Value = 90}
	local KillauraFakeAngle = {Enabled = false}
	local KillauraPrediction = {Enabled = true}	
	local KillauraButtonDown = {Enabled = false}
	local KillauraTargetHighlight = {Enabled = false}
	local KillauraRangeCircle = {Enabled = false}
	local KillauraRangeCirclePart
	local KillauraSwingTick = tick()
	local KillauraBoxes = {}
	local OriginalNeckC0
	local OriginalRootC0
	for i = 1, 10 do 
		local KillauraBox = Instance.new("BoxHandleAdornment")
		KillauraBox.Transparency = 0.5
		KillauraBox.Color3 = Color3.fromHSV(KillauraColor.Hue, KillauraColor.Sat, KillauraColor.Value)
		KillauraBox.Adornee = nil
		KillauraBox.AlwaysOnTop = true
		KillauraBox.Size = Vector3.new(3, 6, 3)
		KillauraBox.ZIndex = 11
		KillauraBox.Parent = GuiLibrary.MainGui
		KillauraBoxes[i] = KillauraBox
	end

	Killaura = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "Killaura", 
		Function = function(callback)
			if callback then
				if KillauraRangeCirclePart then KillauraRangeCirclePart.Parent = gameCamera end
				RunLoops:BindToHeartbeat("Killaura", function()
					for i,v in pairs(KillauraBoxes) do 
						if v.Adornee then
							local onex, oney, onez = v.Adornee.CFrame:ToEulerAnglesXYZ() 
							v.CFrame = CFrame.new() * CFrame.Angles(-onex, -oney, -onez)
						end
					end
					if entityLibrary.isAlive then 
						if KillauraRangeCirclePart then
							KillauraRangeCirclePart.CFrame = entityLibrary.character.HumanoidRootPart.CFrame - Vector3.new(0, entityLibrary.character.Humanoid.HipHeight + (entityLibrary.character.HumanoidRootPart.Size.Y / 2) - 0.3, 0)
						end
						if KillauraFakeAngle.Enabled then 
							local Neck = entityLibrary.character.Head:FindFirstChild("Neck")
							local LowerTorso = entityLibrary.character.HumanoidRootPart.Parent and entityLibrary.character.HumanoidRootPart.Parent:FindFirstChild("LowerTorso")
							local RootC0 = LowerTorso and LowerTorso:FindFirstChild("Root")
							if Neck and RootC0 then
								if not OriginalNeckC0 then OriginalNeckC0 = Neck.C0.p end
								if not OriginalRootC0 then OriginalRootC0 = RootC0.C0.p end
								if OriginalRootC0 then
									if targetedplayer ~= nil then
										local targetPos = targetedplayer.RootPart.Position + Vector3.new(0, targetedplayer.Humanoid.HipHeight + (targetedplayer.RootPart.Size.Y / 2), 0)
										local lookCFrame = (CFrame.new(Vector3.zero, (Root.CFrame):VectorToObjectSpace((Vector3.new(targetPos.X, targetPos.Y, targetPos.Z) - entityLibrary.character.Head.Position).Unit)))
										Neck.C0 = CFrame.new(OriginalNeckC0) * CFrame.Angles(lookCFrame.LookVector.Unit.y, 0, 0)
										RootC0.C0 = (CFrame.new(Vector3.zero, (Root.CFrame):VectorToObjectSpace((Vector3.new(targetPos.X, Root.Position.Y, targetPos.Z) - Root.Position).Unit))) + OriginalRootC0
									else
										Neck.C0 = CFrame.new(OriginalNeckC0)
										RootC0.C0 = CFrame.new(OriginalRootC0)
									end
								end
							end
						end
					end
				end)
				task.spawn(function()
					repeat
						local attackedplayers = {}
						KillauraNearTarget = false
						vapeTargetInfo.Targets.Killaura = nil
						if entityLibrary.isAlive and (not KillauraButtonDown.Enabled or inputService:IsMouseButtonPressed(0)) then
							local plrs = AllNearPosition(KillauraRange.Value, 100, {Prediction = KillauraPrediction.Enabled})
							if #plrs > 0 then
								local tool = lplr.Character:FindFirstChildWhichIsA("Tool")
								local touch = findTouchInterest(tool)
								if tool and touch then
									for i,v in pairs(plrs) do
										if math.acos(entityLibrary.character.HumanoidRootPart.CFrame.lookVector:Dot((v.RootPart.Position - entityLibrary.character.HumanoidRootPart.Position).Unit)) >= (math.rad(KillauraAngle.Value) / 2) then continue end
										KillauraNearTarget = true
										if KillauraTarget.Enabled then
											table.insert(attackedplayers, v)
										end
										vapeTargetInfo.Targets.Killaura = v
										local playertype, playerattackable = WhitelistFunctions:CheckPlayerType(v.Player)
										if not playerattackable then
											continue
										end
										KillauraNearTarget = true
										if KillauraPrediction.Enabled then
											if (entityLibrary.LocalPosition - v.RootPart.Position).Magnitude > KillauraRange.Value then
												continue
											end
										end
										if KillauraSwingTick <= tick() then
											tool:Activate()
											KillauraSwingTick = tick() + (1 / KillauraCPS.GetRandomValue())
										end
										if KillauraMethod.Value == "Bypass" then 
											attackIgnore.FilterDescendantsInstances = {v.Character}
											local parts = workspace:GetPartBoundsInBox(v.RootPart.CFrame, v.Character:GetExtentsSize(), attackIgnore)
											for i,v2 in pairs(parts) do 
												firetouchinterest(touch.Parent, v2, 1)
												firetouchinterest(touch.Parent, v2, 0)
											end
										elseif KillauraMethod.Value == "Normal" then
											for i,v2 in pairs(v.Character:GetChildren()) do 
												if v2:IsA("BasePart") then
													firetouchinterest(touch.Parent, v2, 1)
													firetouchinterest(touch.Parent, v2, 0)
												end
											end
										else
											firetouchinterest(touch.Parent, v.RootPart, 1)
											firetouchinterest(touch.Parent, v.RootPart, 0)
										end
									end
								end
							end
						end
						for i,v in pairs(KillauraBoxes) do 
							local attacked = attackedplayers[i]
							v.Adornee = attacked and attacked.RootPart
						end
						task.wait()
					until not Killaura.Enabled
				end)
			else
				RunLoops:UnbindFromHeartbeat("Killaura") 
                KillauraNearTarget = false
				vapeTargetInfo.Targets.Killaura = nil
				for i,v in pairs(KillauraBoxes) do v.Adornee = nil end
				if KillauraRangeCirclePart then KillauraRangeCirclePart.Parent = nil end
			end
		end,
		HoverText = "Attack players around you\nwithout aiming at them."
	})
	KillauraMethod = Killaura.CreateDropdown({
		Name = "Mode",
		List = {"Normal", "Bypass", "Root Only"},
		Function = function() end
	})
	KillauraCPS = Killaura.CreateTwoSlider({
		Name = "Attacks per second",
		Min = 1,
		Max = 20,
		Default = 8,
		Default2 = 12
	})
	KillauraRange = Killaura.CreateSlider({
		Name = "Attack range",
		Min = 1,
		Max = 150, 
		Function = function(val) 
			if KillauraRangeCirclePart then 
				KillauraRangeCirclePart.Size = Vector3.new(val * 0.7, 0.01, val * 0.7)
			end
		end
	})
	KillauraAngle = Killaura.CreateSlider({
		Name = "Max angle",
		Min = 1,
		Max = 360, 
		Function = function(val) end,
		Default = 90
	})
	KillauraColor = Killaura.CreateColorSlider({
		Name = "Target Color",
		Function = function(hue, sat, val) 
			for i,v in pairs(KillauraBoxes) do 
				v.Color3 = Color3.fromHSV(hue, sat, val)
			end
			if KillauraRangeCirclePart then 
				KillauraRangeCirclePart.Color = Color3.fromHSV(hue, sat, val)
			end
		end,
		Default = 1
	})
	KillauraButtonDown = Killaura.CreateToggle({
		Name = "Require mouse down", 
		Function = function() end
	})
	KillauraTarget = Killaura.CreateToggle({
        Name = "Show target",
        Function = function(callback) end,
		HoverText = "Shows a red box over the opponent."
    })
	KillauraPrediction = Killaura.CreateToggle({
		Name = "Prediction",
		Function = function() end
	})
	KillauraFakeAngle = Killaura.CreateToggle({
        Name = "Face target",
        Function = function() end,
		HoverText = "Makes your character face the opponent."
    })
	KillauraRangeCircle = Killaura.CreateToggle({
		Name = "Range Visualizer",
		Function = function(callback)
			if callback then 
				KillauraRangeCirclePart = Instance.new("MeshPart")
				KillauraRangeCirclePart.MeshId = "rbxassetid://3726303797"
				KillauraRangeCirclePart.Color = Color3.fromHSV(KillauraColor.Hue, KillauraColor.Sat, KillauraColor.Value)
				KillauraRangeCirclePart.CanCollide = false
				KillauraRangeCirclePart.Anchored = true
				KillauraRangeCirclePart.Material = Enum.Material.Neon
				KillauraRangeCirclePart.Size = Vector3.new(KillauraRange.Value * 0.7, 0.01, KillauraRange.Value * 0.7)
				KillauraRangeCirclePart.Parent = gameCamera
			else
				if KillauraRangeCirclePart then 
					KillauraRangeCirclePart:Destroy()
					KillauraRangeCirclePart = nil
				end
			end
		end
	})
end)

runFunction(function()
	local LongJump = {Enabled = false}
	local LongJumpBoost = {Value = 1}
	local LongJumpChange = true
	LongJump = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "LongJump", 
		Function = function(callback)
			if callback then
				if entityLibrary.isAlive and entityLibrary.character.Humanoid.FloorMaterial ~= Enum.Material.Air then
					entityLibrary.character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
				end
				RunLoops:BindToHeartbeat("LongJump", function() 
					if entityLibrary.isAlive then
						if (entityLibrary.character.Humanoid:GetState() == Enum.HumanoidStateType.Freefall or entityLibrary.character.Humanoid:GetState() == Enum.HumanoidStateType.Jumping) and entityLibrary.character.Humanoid.MoveDirection ~= Vector3.zero then
							local velo = entityLibrary.character.Humanoid.MoveDirection * LongJumpBoost.Value
							entityLibrary.character.HumanoidRootPart.Velocity = Vector3.new(velo.X, entityLibrary.character.HumanoidRootPart.Velocity.Y, velo.Z)
						end
						local check = entityLibrary.character.Humanoid.FloorMaterial ~= Enum.Material.Air
						if LongJumpChange ~= check then 
							if check then LongJump.ToggleButton(true) end
							LongJumpChange = check
						end
					end
				end)
			else
				RunLoops:UnbindFromHeartbeat("LongJump")
				LongJumpChange = true
			end
		end
	})
	LongJumpBoost = LongJump.CreateSlider({
		Name = "Boost",
		Min = 1,
		Max = 150, 
		Function = function(val) end
	})

	local HighJump = {Enabled = false}
	local HighJumpMethod = {Value = "Toggle"}
	local HighJumpMode = {Value = "Normal"}
	local HighJumpBoost = {Value = 1}
	local HighJumpDelay = {Value = 20}
	local HighJumpTick = tick()
	local highjumpBound = true
	HighJump = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "HighJump", 
		Function = function(callback)
			if callback then
				if HighJumpMethod.Value == "Toggle" then
					if HighJumpTick > tick()  then
						warningNotification("HighJump", "Wait "..(math.floor((HighJumpTick - tick()) * 10) / 10).."s before retoggling.", 1)
						HighJump.ToggleButton(false)
						return
					end
					if entityLibrary.isAlive and entityLibrary.character.Humanoid.FloorMaterial ~= Enum.Material.Air then
						HighJumpTick = tick() + (HighJumpDelay.Value / 10)
						if HighJumpMode.Value == "Normal" then  
							entityLibrary.character.HumanoidRootPart.Velocity = entityLibrary.character.HumanoidRootPart.Velocity + Vector3.new(0, HighJumpBoost.Value, 0)
						else
							task.spawn(function()
								local start = HighJumpBoost.Value
								repeat
									entityLibrary.character.HumanoidRootPart.CFrame += Vector3.new(0, start * 0.016, 0)
									start = start - (workspace.Gravity * 0.016)
									task.wait()
								until start <= 0
							end)
						end
					end
					HighJump.ToggleButton(false)
				else
					local debounce = 0
					RunLoops:BindToRenderStep("HighJump", function()
						if entityLibrary.isAlive and entityLibrary.character.Humanoid.FloorMaterial ~= Enum.Material.Air and inputService:IsKeyDown(Enum.KeyCode.Space) and (tick() - debounce) > 0.3 then
							debounce = tick()
							if HighJumpMode.Value == "Normal" then  
								entityLibrary.character.HumanoidRootPart.Velocity = entityLibrary.character.HumanoidRootPart.Velocity + Vector3.new(0, HighJumpBoost.Value, 0)
							else
								task.spawn(function()
									local start = HighJumpBoost.Value
									repeat
										entityLibrary.character.HumanoidRootPart.CFrame += Vector3.new(0, start * 0.016, 0)
										start = start - (workspace.Gravity * 0.016)
										task.wait()
									until start <= 0
								end)
							end
						end
					end)
				end
			else
				RunLoops:UnbindFromRenderStep("HighJump")
			end
		end,
		HoverText = "Lets you jump higher"
	})
	HighJumpMethod = HighJump.CreateDropdown({
		Name = "Method", 
		List = {"Toggle", "Normal"},
		Function = function(val) end
	})
	HighJumpMode = HighJump.CreateDropdown({
		Name = "Mode", 
		List = {"Normal", "CFrame"},
		Function = function(val) end
	})
	HighJumpBoost = HighJump.CreateSlider({
		Name = "Boost",
		Min = 1,
		Max = 150, 
		Function = function(val) end,
		Default = 100
	})
	HighJumpDelay = HighJump.CreateSlider({
		Name = "Delay",
		Min = 0,
		Max = 50, 
		Function = function(val) end,
	})
end)

local spiderHoldingShift = false
local Spider = {Enabled = false}
local Phase = {Enabled = false}
runFunction(function()
	local PhaseMode = {Value = "Normal"}
	local PhaseStudLimit = {Value = 1}
	local PhaseModifiedParts = {}
	local PhaseRaycast = RaycastParams.new()
	PhaseRaycast.RespectCanCollide = true
	PhaseRaycast.FilterType = Enum.RaycastFilterType.Blacklist
	local PhaseOverlap = OverlapParams.new()
	PhaseOverlap.MaxParts = 9e9
	PhaseOverlap.FilterDescendantsInstances = {}

	local PhaseFunctions = {
		Part = function()
			local chars = {gameCamera, lplr.Character}
			for i, v in pairs(entityLibrary.entityList) do table.insert(chars, v.Character) end
			PhaseOverlap.FilterDescendantsInstances = chars
			local rootpos = entityLibrary.character.HumanoidRootPart.CFrame.p
			local parts = workspace:GetPartBoundsInRadius(rootpos, 2, PhaseOverlap)
			for i, v in pairs(parts) do 
				if v.CanCollide and (v.Position.Y + (v.Size.Y / 2)) > (rootpos.Y - entityLibrary.character.Humanoid.HipHeight) and (not Spider.Enabled or spiderHoldingShift) then 
					PhaseModifiedParts[v] = true
					v.CanCollide = false
				end
			end
			for i,v in pairs(PhaseModifiedParts) do 
				if not table.find(parts, i) then
					PhaseModifiedParts[i] = nil
					i.CanCollide = true
				end
			end
		end,
		Character = function()
			for i, part in pairs(lplr.Character:GetDescendants()) do
				if part:IsA("BasePart") and part.CanCollide and (not Spider.Enabled or spiderHoldingShift) then
					PhaseModifiedParts[part] = true
					part.CanCollide = Spider.Enabled and not spiderHoldingShift
				end
			end
		end,
		TP = function()
			local chars = {gameCamera, lplr.Character}
			for i, v in pairs(entityLibrary.entityList) do table.insert(chars, v.Character) end
			PhaseRaycast.FilterDescendantsInstances = chars
			local phaseRayCheck = workspace:Raycast(entityLibrary.character.Head.CFrame.p, entityLibrary.character.Humanoid.MoveDirection * 1.1, PhaseRaycast)
			if phaseRayCheck and (not Spider.Enabled or spiderHoldingShift) then
				local phaseDirection = phaseRayCheck.Normal.Z ~= 0 and "Z" or "X"
				if phaseRayCheck.Instance.Size[phaseDirection] <= PhaseStudLimit.Value then
					entityLibrary.character.HumanoidRootPart.CFrame = entityLibrary.character.HumanoidRootPart.CFrame + (phaseRayCheck.Normal * (-(phaseRayCheck.Instance.Size[phaseDirection]) - (entityLibrary.character.HumanoidRootPart.Size.X / 1.5)))
				end
			end
		end
	}

	Phase = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "Phase", 
		Function = function(callback)
			if callback then
				RunLoops:BindToStepped("Phase", function() -- has to be ran on stepped idk why
					if entityLibrary.isAlive then
						PhaseFunctions[PhaseMode.Value]()
					end
				end)
			else
				RunLoops:UnbindFromStepped("Phase")
				for i,v in pairs(PhaseModifiedParts) do if i then i.CanCollide = true end end
				table.clear(PhaseModifiedParts)
			end
		end,
		HoverText = "Lets you Phase/Clip through walls. (Hold shift to use Phase over spider)"
	})
	PhaseMode = Phase.CreateDropdown({
		Name = "Mode",
		List = {"Part", "Character", "TP"},
		Function = function(val) 
			if PhaseStudLimit.Object then
				PhaseStudLimit.Object.Visible = val == "TP"
			end
		end
	})
	PhaseStudLimit = Phase.CreateSlider({
		Name = "Studs",
		Function = function() end,
		Min = 1,
		Max = 20,
		Default = 5,
	})
end)

runFunction(function()
	local SpiderSpeed = {Value = 0}
	local SpiderState = {Enabled = false}
	local SpiderMode = {Value = "Normal"}
	local SpiderRaycast = RaycastParams.new()
	SpiderRaycast.RespectCanCollide = true
	SpiderRaycast.FilterType = Enum.RaycastFilterType.Blacklist
	local SpiderActive
	local SpiderPart

	local function clampSpiderPosition(dir, pos, size)
		local suc, res = pcall(function() return Vector3.new(math.clamp(dir.X, pos.X - (size.X / 2), pos.X + (size.X / 2)), math.clamp(dir.Y, pos.Y - (size.Y / 2), pos.Y + (size.Y / 2)), math.clamp(dir.Z, pos.Z - (size.Z / 2), pos.Z + (size.Z / 2))) end)
		return suc and res or Vector3.zero
	end

	Spider = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "Spider",
		Function = function(callback)
			if callback then
				if SpiderPart then SpiderPart.Parent = gameCamera end
				RunLoops:BindToHeartbeat("Spider", function(delta)
					if entityLibrary.isAlive then
						local chars = {gameCamera, lplr.Character, SpiderPart}
						for i, v in pairs(entityLibrary.entityList) do table.insert(chars, v.Character) end
						SpiderRaycast.FilterDescendantsInstances = chars
						if SpiderMode.Value ~= "Classic" then
							local vec = entityLibrary.character.Humanoid.MoveDirection * 2
							local newray = workspace:Raycast(entityLibrary.character.HumanoidRootPart.Position, vec + Vector3.new(0, 0.1, 0), SpiderRaycast)
							local newray2 = workspace:Raycast(entityLibrary.character.HumanoidRootPart.Position, vec - Vector3.new(0, entityLibrary.character.Humanoid.HipHeight, 0), SpiderRaycast)
							if SpiderActive and not newray and not newray2 then
								entityLibrary.character.HumanoidRootPart.Velocity = Vector3.new(entityLibrary.character.HumanoidRootPart.Velocity.X, 0, entityLibrary.character.HumanoidRootPart.Velocity.Z)
							end
							SpiderActive = ((newray or newray2) and true or false)
							spiderHoldingShift = inputService:IsKeyDown(Enum.KeyCode.LeftShift)
							if SpiderActive and (newray or newray2).Normal.Y == 0 then
								if not Phase.Enabled or not spiderHoldingShift then
									if SpiderState.Enabled then entityLibrary.character.Humanoid:ChangeState(Enum.HumanoidStateType.Climbing) end
									if SpiderMode.Value == "CFrame" then 
										entityLibrary.character.HumanoidRootPart.CFrame = entityLibrary.character.HumanoidRootPart.CFrame + Vector3.new(-(entityLibrary.character.HumanoidRootPart.CFrame.lookVector.X * 18) * delta, SpiderSpeed.Value * delta, -(entityLibrary.character.HumanoidRootPart.CFrame.lookVector.Z * 18) * delta)
									else
										entityLibrary.character.HumanoidRootPart.Velocity = Vector3.new(entityLibrary.character.HumanoidRootPart.Velocity.X - (entityLibrary.character.HumanoidRootPart.CFrame.lookVector.X / 2), SpiderSpeed.Value, entityLibrary.character.HumanoidRootPart.Velocity.Z - (entityLibrary.character.HumanoidRootPart.CFrame.lookVector.Z / 2))
									end
								end
							end
						else
							local vec = entityLibrary.character.HumanoidRootPart.CFrame.lookVector * 1.5
							local newray2 = workspace:Raycast(entityLibrary.character.HumanoidRootPart.Position, (vec - Vector3.new(0, entityLibrary.character.Humanoid.HipHeight, 0)), SpiderRaycast)
							spiderHoldingShift = inputService:IsKeyDown(Enum.KeyCode.LeftShift)
							if newray2 and (not Phase.Enabled or not spiderHoldingShift) then 
								local newray2pos = newray2.Instance.Position
								local newpos = clampSpiderPosition(entityLibrary.character.HumanoidRootPart.Position, Vector3.new(newray2pos.X, math.min(entityLibrary.character.HumanoidRootPart.Position.Y, newray2pos.Y), newray2pos.Z), newray2.Instance.Size - Vector3.new(1.9, 1.9, 1.9))
								SpiderPart.Position = newpos
							else
								SpiderPart.Position = Vector3.zero
							end
						end
					end
				end)
			else
				if SpiderPart then SpiderPart.Parent = nil end
				RunLoops:UnbindFromHeartbeat("Spider")
			end
		end,
		HoverText = "Lets you climb up walls"
	})
	SpiderMode = Spider.CreateDropdown({
		Name = "Mode",
		List = {"Normal", "CFrame", "Classic"},
		Function = function(val) 
			if SpiderPart then SpiderPart:Destroy() SpiderPart = nil end
			if val == "Classic" then 
				SpiderPart = Instance.new("TrussPart")
				SpiderPart.Size = Vector3.new(2, 2, 2)
				SpiderPart.Transparency = 1
				SpiderPart.Anchored = true
				SpiderPart.Parent = Spider.Enabled and gameCamera or nil
			end
		end
	})
	SpiderSpeed = Spider.CreateSlider({
		Name = "Speed",
		Min = 0,
		Max = 100,
		Function = function() end,
		Default = 30
	})
	SpiderState = Spider.CreateToggle({
		Name = "Climb State",
		Function = function() end
	})
end)

runFunction(function()
	local Speed = {Enabled = false}
	local SpeedValue = {Value = 1}
	local SpeedMethod = {Value = "AntiCheat A"}
	local SpeedMoveMethod = {Value = "MoveDirection"}
	local SpeedDelay = {Value = 0.7}
	local SpeedPulseDuration = {Value = 100}
	local SpeedWallCheck = {Enabled = true}
	local SpeedJump = {Enabled = false}
	local SpeedJumpHeight = {Value = 20}
	local SpeedJumpVanilla = {Enabled = false}
	local SpeedJumpAlways = {Enabled = false}
	local SpeedAnimation = {Enabled = false}
	local SpeedDelayTick = tick()
	local SpeedRaycast = RaycastParams.new()
	SpeedRaycast.FilterType = Enum.RaycastFilterType.Blacklist
	SpeedRaycast.RespectCanCollide = true
	local oldWalkSpeed
	local SpeedDown
	local SpeedUp
	local w = 0
	local s = 0
	local a = 0
	local d = 0

	local alternatelist = {"Normal", "AntiCheat A", "AntiCheat B", "AntiCheat C", "AntiCheat D"}
	Speed = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "Speed", 
		Function = function(callback)
			if callback then
				w = inputService:IsKeyDown(Enum.KeyCode.W) and -1 or 0
				s = inputService:IsKeyDown(Enum.KeyCode.S) and 1 or 0
				a = inputService:IsKeyDown(Enum.KeyCode.A) and -1 or 0
				d = inputService:IsKeyDown(Enum.KeyCode.D) and 1 or 0
				table.insert(Speed.Connections, inputService.InputBegan:Connect(function(input1)
					if inputService:GetFocusedTextBox() == nil then
						if input1.KeyCode == Enum.KeyCode.W then
							w = -1
						end
						if input1.KeyCode == Enum.KeyCode.S then
							s = 1
						end
						if input1.KeyCode == Enum.KeyCode.A then
							a = -1
						end
						if input1.KeyCode == Enum.KeyCode.D then
							d = 1
						end
					end
				end))
				table.insert(Speed.Connections, inputService.InputEnded:Connect(function(input1)
					if input1.KeyCode == Enum.KeyCode.W then
						w = 0
					end
					if input1.KeyCode == Enum.KeyCode.S then
						s = 0
					end
					if input1.KeyCode == Enum.KeyCode.A then
						a = 0
					end
					if input1.KeyCode == Enum.KeyCode.D then
						d = 0
					end
				end))
				local pulsetick = tick()
				task.spawn(function()
					repeat
						pulsetick = tick() + (SpeedPulseDuration.Value / 100)
						task.wait((SpeedDelay.Value / 10) + (SpeedPulseDuration.Value / 100))
					until (not Speed.Enabled)
				end)
				RunLoops:BindToHeartbeat("Speed", function(delta)
					if entityLibrary.isAlive and (typeof(entityLibrary.character.HumanoidRootPart) ~= "Instance" or isnetworkowner(entityLibrary.character.HumanoidRootPart)) then
						local movevec = (SpeedMoveMethod.Value == "Manual" and calculateMoveVector(Vector3.new(a + d, 0, w + s)) or entityLibrary.character.Humanoid.MoveDirection).Unit
						movevec = movevec == movevec and Vector3.new(movevec.X, 0, movevec.Z) or Vector3.zero
						SpeedRaycast.FilterDescendantsInstances = {lplr.Character, cam}
						if SpeedMethod.Value == "Velocity" then
							if SpeedAnimation.Enabled then
								for i,v in pairs(entityLibrary.character.Humanoid:GetPlayingAnimationTracks()) do
									if v.Name == "WalkAnim" or v.Name == "RunAnim" then
										v:AdjustSpeed(entityLibrary.character.Humanoid.WalkSpeed / 16)
									end
								end
							end
							local newvelo = movevec * SpeedValue.Value
							entityLibrary.character.HumanoidRootPart.Velocity = Vector3.new(newvelo.X, entityLibrary.character.HumanoidRootPart.Velocity.Y, newvelo.Z)
						elseif SpeedMethod.Value == "CFrame" then
							local newpos = (movevec * (math.max(SpeedValue.Value - entityLibrary.character.Humanoid.WalkSpeed, 0) * delta))
							if SpeedWallCheck.Enabled then
								local ray = workspace:Raycast(entityLibrary.character.HumanoidRootPart.Position, newpos, SpeedRaycast)
								if ray then newpos = (ray.Position - entityLibrary.character.HumanoidRootPart.Position) end
							end
							entityLibrary.character.HumanoidRootPart.CFrame = entityLibrary.character.HumanoidRootPart.CFrame + newpos
						elseif SpeedMethod.Value == "TP" then
							if SpeedDelayTick <= tick() then
								SpeedDelayTick = tick() + (SpeedDelay.Value / 10)
								local newpos = (movevec * SpeedValue.Value)
								if SpeedWallCheck.Enabled then
									local ray = workspace:Raycast(entityLibrary.character.HumanoidRootPart.Position, newpos, SpeedRaycast)
									if ray then newpos = (ray.Position - entityLibrary.character.HumanoidRootPart.Position) end
								end
								entityLibrary.character.HumanoidRootPart.CFrame = entityLibrary.character.HumanoidRootPart.CFrame + newpos
							end
						elseif SpeedMethod.Value == "Pulse" then 
							local pulsenum = (SpeedPulseDuration.Value / 100)
							local newvelo = movevec * (SpeedValue.Value + (entityLibrary.character.Humanoid.WalkSpeed - SpeedValue.Value) * (1 - (math.max(pulsetick - tick(), 0)) / pulsenum))
							entityLibrary.character.HumanoidRootPart.Velocity = Vector3.new(newvelo.X, entityLibrary.character.HumanoidRootPart.Velocity.Y, newvelo.Z)
						elseif SpeedMethod.Value == "WalkSpeed" then 
							if oldWalkSpeed == nil then
								oldWalkSpeed = entityLibrary.character.Humanoid.WalkSpeed
							end
							entityLibrary.character.Humanoid.WalkSpeed = SpeedValue.Value
						end
						if SpeedJump.Enabled and (SpeedJumpAlways.Enabled or KillauraNearTarget) then
							if (entityLibrary.character.Humanoid.FloorMaterial ~= Enum.Material.Air) and entityLibrary.character.Humanoid.MoveDirection ~= Vector3.zero then
								if SpeedJumpVanilla.Enabled then 
									entityLibrary.character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
								else
									entityLibrary.character.HumanoidRootPart.Velocity = Vector3.new(entityLibrary.character.HumanoidRootPart.Velocity.X, SpeedJumpHeight.Value, entityLibrary.character.HumanoidRootPart.Velocity.Z)
								end
							end
						end
					end
				end)
			else
				SpeedDelayTick = 0
				if oldWalkSpeed then
					entityLibrary.character.Humanoid.WalkSpeed = oldWalkSpeed
					oldWalkSpeed = nil
				end
				RunLoops:UnbindFromHeartbeat("Speed")
			end
		end,
		ExtraText = function() 
			if GuiLibrary.ObjectsThatCanBeSaved["Text GUIAlternate TextToggle"].Api.Enabled then 
				return alternatelist[table.find(SpeedMethod.List, SpeedMethod.Value)]
			end
			return SpeedMethod.Value
		end
	})
	SpeedMethod = Speed.CreateDropdown({
		Name = "Mode", 
		List = {"Velocity", "CFrame", "TP", "Pulse", "WalkSpeed"},
		Function = function(val)
			if oldWalkSpeed then
				entityLibrary.character.Humanoid.WalkSpeed = oldWalkSpeed
				oldWalkSpeed = nil
			end
			SpeedDelay.Object.Visible = val == "TP" or val == "Pulse"
			SpeedWallCheck.Object.Visible = val == "CFrame" or val == "TP"
			SpeedPulseDuration.Object.Visible = val == "Pulse"
			SpeedAnimation.Object.Visible = val == "Velocity"
		end
	})
	SpeedMoveMethod = Speed.CreateDropdown({
		Name = "Movement", 
		List = {"Manual", "MoveDirection"},
		Function = function(val) end
	})
	SpeedValue = Speed.CreateSlider({
		Name = "Speed", 
		Min = 1,
		Max = 150, 
		Function = function(val) end
	})
	SpeedDelay = Speed.CreateSlider({
		Name = "Delay", 
		Min = 1,
		Max = 50, 
		Function = function(val)
			SpeedDelayTick = tick() + (val / 10)
		end,
		Default = 7,
		Double = 10
	})
	SpeedPulseDuration = Speed.CreateSlider({
		Name = "Pulse Duration",
		Min = 1,
		Max = 100,
		Function = function() end,
		Default = 50,
		Double = 100
	})
	SpeedJump = Speed.CreateToggle({
		Name = "AutoJump", 
		Function = function(callback) 
			if SpeedJumpHeight.Object then SpeedJumpHeight.Object.Visible = callback end
			if SpeedJumpAlways.Object then
				SpeedJump.Object.ToggleArrow.Visible = callback
				SpeedJumpAlways.Object.Visible = callback
			end
			if SpeedJumpVanilla.Object then SpeedJumpVanilla.Object.Visible = callback end
		end,
		Default = true
	})
	SpeedJumpHeight = Speed.CreateSlider({
		Name = "Jump Height",
		Min = 0,
		Max = 30,
		Default = 25,
		Function = function() end
	})
	SpeedJumpAlways = Speed.CreateToggle({
		Name = "Always Jump",
		Function = function() end
	})
	SpeedJumpVanilla = Speed.CreateToggle({
		Name = "Real Jump",
		Function = function() end
	})
	SpeedWallCheck = Speed.CreateToggle({
		Name = "Wall Check",
		Function = function() end,
		Default = true
	})
	SpeedAnimation = Speed.CreateToggle({
		Name = "Slowdown Anim",
		Function = function() end
	})
end)

runFunction(function()
	local SpinBot = {Enabled = false}
	local SpinBotX = {Enabled = false}
	local SpinBotY = {Enabled = false}
	local SpinBotZ = {Enabled = false}
	local SpinBotSpeed = {Value = 1}
	SpinBot = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "SpinBot",
		Function = function(callback)
			if callback then
				RunLoops:BindToHeartbeat("SpinBot", function()
					if entityLibrary.isAlive then
						local originalRotVelocity = entityLibrary.character.HumanoidRootPart.RotVelocity
						entityLibrary.character.HumanoidRootPart.RotVelocity = Vector3.new(SpinBotX.Enabled and SpinBotSpeed.Value or originalRotVelocity.X, SpinBotY.Enabled and SpinBotSpeed.Value or originalRotVelocity.Y, SpinBotZ.Enabled and SpinBotSpeed.Value or originalRotVelocity.Z)
					end
				end)
			else
				RunLoops:UnbindFromHeartbeat("SpinBot")
			end
		end,
		HoverText = "Makes your character spin around in circles (does not work in first person)"
	})
	SpinBotSpeed = SpinBot.CreateSlider({
		Name = "Speed",
		Min = 1,
		Max = 100,
		Default = 40,
		Function = function() end
	})
	SpinBotX = SpinBot.CreateToggle({
		Name = "Spin X",
		Function = function() end
	})
	SpinBotY = SpinBot.CreateToggle({
		Name = "Spin Y",
		Function = function() end,
		Default = true
	})
	SpinBotZ = SpinBot.CreateToggle({
		Name = "Spin Z",
		Function = function() end
	})
end)

local GravityChangeTick = tick()
runFunction(function()
	local Gravity = {Enabled = false}
	local GravityValue = {Value = 100}
	local oldGravity
	Gravity = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "Gravity",
		Function = function(callback)
			if callback then
				oldGravity = workspace.Gravity
				workspace.Gravity = GravityValue.Value
				table.insert(Gravity.Connections, workspace:GetPropertyChangedSignal("Gravity"):Connect(function()
					if GravityChangeTick > tick() then return end 
					oldGravity = workspace.Gravity
					GravityChangeTick = tick() + 0.1
					workspace.Gravity = GravityValue.Value
				end))
			else
				workspace.Gravity = oldGravity
			end
		end,
		HoverText = "Changes workspace gravity"
	})
	GravityValue = Gravity.CreateSlider({
		Name = "Gravity",
		Min = 0,
		Max = 192,
		Function = function(val) 
			if Gravity.Enabled then
				GravityChangeTick = tick() + 0.1
				workspace.Gravity = val
			end
		end,
		Default = 192
	})
end)

runFunction(function()
    local ArrowsFolder = Instance.new("Folder")
    ArrowsFolder.Name = "ArrowsFolder"
    ArrowsFolder.Parent = GuiLibrary.MainGui
    local ArrowsFolderTable = {}
    local ArrowsColor = {Value = 0.44}
    local ArrowsTeammate = {Enabled = true}

    local arrowAddFunction = function(plr)
        if ArrowsTeammate.Enabled and (not plr.Targetable) and (not plr.Friend) then return end
        local arrowObject = Instance.new("ImageLabel")
        arrowObject.BackgroundTransparency = 1
        arrowObject.BorderSizePixel = 0
        arrowObject.Size = UDim2.new(0, 256, 0, 256)
        arrowObject.AnchorPoint = Vector2.new(0.5, 0.5)
        arrowObject.Position = UDim2.new(0.5, 0, 0.5, 0)
        arrowObject.Visible = false
        arrowObject.Image = downloadVapeAsset("vape/assets/ArrowIndicator.png")
		arrowObject.ImageColor3 = getPlayerColor(plr.Player) or Color3.fromHSV(ArrowsColor.Hue, ArrowsColor.Sat, ArrowsColor.Value)
        arrowObject.Name = plr.Player.Name
        arrowObject.Parent = ArrowsFolder
        ArrowsFolderTable[plr.Player] = {entity = plr, Main = arrowObject}
    end

    local arrowRemoveFunction = function(ent)
        local v = ArrowsFolderTable[ent]
        ArrowsFolderTable[ent] = nil
        if v then v.Main:Destroy() end
    end

    local arrowColorFunction = function(hue, sat, val)
        local color = Color3.fromHSV(hue, sat, val)
        for i,v in pairs(ArrowsFolderTable) do 
            v.Main.ImageColor3 = getPlayerColor(v.entity.Player) or color
        end
    end

    local arrowLoopFunction = function()
        for i,v in pairs(ArrowsFolderTable) do 
            local rootPos, rootVis = worldtoscreenpoint(v.entity.RootPart.Position)
            if rootVis then 
                v.Main.Visible = false
                continue
            end
            local camcframeflat = CFrame.new(gameCamera.CFrame.p, gameCamera.CFrame.p + gameCamera.CFrame.lookVector * Vector3.new(1, 0, 1))
            local pointRelativeToCamera = camcframeflat:pointToObjectSpace(v.entity.RootPart.Position)
            local unitRelativeVector = (pointRelativeToCamera * Vector3.new(1, 0, 1)).unit
            local rotation = math.atan2(unitRelativeVector.Z, unitRelativeVector.X)
            v.Main.Visible = true
            v.Main.Rotation = math.deg(rotation)
        end
    end

    local Arrows = {Enabled = false}
	Arrows = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
        Name = "Arrows", 
        Function = function(callback) 
            if callback then
				table.insert(Arrows.Connections, entityLibrary.entityRemovedEvent:Connect(arrowRemoveFunction))
				for i,v in pairs(entityLibrary.entityList) do 
                    if ArrowsFolderTable[v.Player] then arrowRemoveFunction(v.Player) end
                    arrowAddFunction(v)
                end
                table.insert(Arrows.Connections, entityLibrary.entityAddedEvent:Connect(function(ent)
                    if ArrowsFolderTable[ent.Player] then arrowRemoveFunction(ent.Player) end
                    arrowAddFunction(ent)
                end))
				table.insert(Arrows.Connections, GuiLibrary.ObjectsThatCanBeSaved.FriendsListTextCircleList.Api.FriendColorRefresh.Event:Connect(function()
                    arrowColorFunction(ESPColor.Hue, ESPColor.Sat, ESPColor.Value)
                end))
				RunLoops:BindToRenderStep("Arrows", arrowLoopFunction)
            else
                RunLoops:UnbindFromRenderStep("Arrows") 
				for i,v in pairs(ArrowsFolderTable) do 
                    arrowRemoveFunction(i)
                end
            end
        end, 
        HoverText = "Draws arrows on screen when entities\nare out of your field of view."
    })
    ArrowsColor = Arrows.CreateColorSlider({
        Name = "Player Color", 
        Function = function(hue, sat, val) 
			if Arrows.Enabled then 
				arrowColorFunction(hue, sat, val)
			end
		end,
    })
    ArrowsTeammate = Arrows.CreateToggle({
        Name = "Teammate",
        Function = function() end,
        Default = true
    })
end)


runFunction(function()
	local Disguise = {Enabled = false}
	local DisguiseId = {Value = ""}
	local DisguiseDescription
	
	local function Disguisechar(char)
		task.spawn(function()
			if not char then return end
			local hum = char:WaitForChild("Humanoid", 9e9)
			char:WaitForChild("Head", 9e9)
			local DisguiseDescription
			if DisguiseDescription == nil then
				local suc = false
				repeat
					suc = pcall(function()
						DisguiseDescription = playersService:GetHumanoidDescriptionFromUserId(DisguiseId.Value == "" and 239702688 or tonumber(DisguiseId.Value))
					end)
					if suc then break end
					task.wait(1)
				until suc or (not Disguise.Enabled)
			end
			if (not Disguise.Enabled) then return end
			local desc = hum:WaitForChild("HumanoidDescription", 2) or {HeightScale = 1, SetEmotes = function() end, SetEquippedEmotes = function() end}
			DisguiseDescription.HeightScale = desc.HeightScale
			char.Archivable = true
			local Disguiseclone = char:Clone()
			Disguiseclone.Name = "Disguisechar"
			Disguiseclone.Parent = workspace
			for i,v in pairs(Disguiseclone:GetChildren()) do 
				if v:IsA("Accessory") or v:IsA("ShirtGraphic") or v:IsA("Shirt") or v:IsA("Pants") then  
					v:Destroy()
				end
			end
			if not Disguiseclone:FindFirstChildWhichIsA("Humanoid") then 
				Disguiseclone:Destroy()
				return 
			end
			Disguiseclone.Humanoid:ApplyDescriptionClientServer(DisguiseDescription)
			for i,v in pairs(char:GetChildren()) do 
				if (v:IsA("Accessory") and v:GetAttribute("InvItem") == nil and v:GetAttribute("ArmorSlot") == nil) or v:IsA("ShirtGraphic") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("BodyColors") or v:IsA("Folder") or v:IsA("Model") then 
					v.Parent = game
				end
			end
			char.ChildAdded:Connect(function(v)
				if ((v:IsA("Accessory") and v:GetAttribute("InvItem") == nil and v:GetAttribute("ArmorSlot") == nil) or v:IsA("ShirtGraphic") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("BodyColors")) and v:GetAttribute("Disguise") == nil then 
					repeat task.wait() v.Parent = game until v.Parent == game
				end
			end)
			for i,v in pairs(Disguiseclone:WaitForChild("Animate"):GetChildren()) do 
				v:SetAttribute("Disguise", true)
				if not char:FindFirstChild("Animate") then return end
				local real = char.Animate:FindFirstChild(v.Name)
				if v:IsA("StringValue") and real then 
					real.Parent = game
					v.Parent = char.Animate
				end
			end
			for i,v in pairs(Disguiseclone:GetChildren()) do 
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
				elseif v.Name == "Head" and char.Head:IsA("MeshPart") then 
					char.Head.MeshId = v.MeshId
				end
			end
			local localface = char:FindFirstChild("face", true)
			local cloneface = Disguiseclone:FindFirstChild("face", true)
			if localface and cloneface then localface.Parent = game cloneface.Parent = char.Head end
			desc:SetEmotes(DisguiseDescription:GetEmotes())
			desc:SetEquippedEmotes(DisguiseDescription:GetEquippedEmotes())
			Disguiseclone:Destroy()
		end)
	end

	Disguise = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "Disguise",
		Function = function(callback)
			if callback then 
				table.insert(Disguise.Connections, lplr.CharacterAdded:Connect(Disguisechar))
				Disguisechar(lplr.Character)
			end
		end
	})
	DisguiseId = Disguise.CreateTextBox({
		Name = "Disguise",
		TempText = "Disguise User Id",
		FocusLost = function(enter) 
			if Disguise.Enabled then 
				Disguise.ToggleButton(false)
				Disguise.ToggleButton(false)
			end
		end
	})
end)

runFunction(function()
	local ESPColor = {Value = 0.44}
	local ESPHealthBar = {Enabled = false}
	local ESPBoundingBox = {Enabled = true}
	local ESPName = {Enabled = true}
	local ESPMethod = {Value = "2D"}
	local ESPTeammates = {Enabled = true}
	local espfolderdrawing = {}
	local espconnections = {}
	local methodused

	local function floorESPPosition(pos)
		return Vector2.new(math.floor(pos.X), math.floor(pos.Y))
	end

	local function ESPWorldToViewport(pos)
		local newpos = worldtoviewportpoint(gameCamera.CFrame:pointToWorldSpace(gameCamera.CFrame:pointToObjectSpace(pos)))
		return Vector2.new(newpos.X, newpos.Y)
	end

	local espfuncs1 = {
		Drawing2D = function(plr)
			if ESPTeammates.Enabled and (not plr.Targetable) and (not plr.Friend) then return end
			local thing = {}
			thing.Quad1 = Drawing.new("Square")
			thing.Quad1.Transparency = ESPBoundingBox.Enabled and 1 or 0
			thing.Quad1.ZIndex = 2
			thing.Quad1.Filled = false
			thing.Quad1.Thickness = 1
			thing.Quad1.Color = getPlayerColor(plr.Player) or Color3.fromHSV(ESPColor.Hue, ESPColor.Sat, ESPColor.Value)
			thing.QuadLine2 = Drawing.new("Square")
			thing.QuadLine2.Transparency = ESPBoundingBox.Enabled and 0.5 or 0
			thing.QuadLine2.ZIndex = 1
			thing.QuadLine2.Thickness = 1
			thing.QuadLine2.Filled = false
			thing.QuadLine2.Color = Color3.new()
			thing.QuadLine3 = Drawing.new("Square")
			thing.QuadLine3.Transparency = ESPBoundingBox.Enabled and 0.5 or 0
			thing.QuadLine3.ZIndex = 1
			thing.QuadLine3.Thickness = 1
			thing.QuadLine3.Filled = false
			thing.QuadLine3.Color = Color3.new()
			if ESPHealthBar.Enabled then 
				thing.Quad3 = Drawing.new("Line")
				thing.Quad3.Thickness = 1
				thing.Quad3.ZIndex = 2
				thing.Quad3.Color = Color3.new(0, 1, 0)
				thing.Quad4 = Drawing.new("Line")
				thing.Quad4.Thickness = 3
				thing.Quad4.Transparency = 0.5
				thing.Quad4.ZIndex = 1
				thing.Quad4.Color = Color3.new()
			end
			if ESPName.Enabled then 
				thing.Drop = Drawing.new("Text")
				thing.Drop.Color = Color3.new()
				thing.Drop.Text = WhitelistFunctions:GetTag(plr.Player)..(plr.Player.DisplayName or plr.Player.Name)
				thing.Drop.ZIndex = 1
				thing.Drop.Center = true
				thing.Drop.Size = 20
				thing.Text = Drawing.new("Text")
				thing.Text.Text = thing.Drop.Text
				thing.Text.ZIndex = 2
				thing.Text.Color = thing.Quad1.Color
				thing.Text.Center = true
				thing.Text.Size = 20
			end
			espfolderdrawing[plr.Player] = {entity = plr, Main = thing}
		end,
		Drawing2DV3 = function(plr)
			if ESPTeammates.Enabled and (not plr.Targetable) and (not plr.Friend) then return end
			local toppoint = PointInstance.new(plr.RootPart, CFrame.new(2, 3, 0))
			local bottompoint = PointInstance.new(plr.RootPart, CFrame.new(-2, -3.5, 0))
			local newobj = RectDynamic.new(toppoint)
			newobj.BottomRight = bottompoint
			newobj.Outlined = ESPBoundingBox.Enabled
			newobj.Opacity = ESPBoundingBox.Enabled and 1 or 0
			newobj.OutlineOpacity = 0.5
			newobj.Color = getPlayerColor(plr.Player) or Color3.fromHSV(ESPColor.Hue, ESPColor.Sat, ESPColor.Value)
			local newobj2 = {}
			local newobj3 = {}
			if ESPHealthBar.Enabled then 
				local topoffset = PointOffset.new(PointInstance.new(plr.RootPart, CFrame.new(-2, 3, 0)), Vector2.new(-5, -1))
				local bottomoffset = PointOffset.new(PointInstance.new(plr.RootPart, CFrame.new(-2, -3.5, 0)), Vector2.new(-3, 1))
				local healthoffset = PointOffset.new(bottomoffset, Vector2.new(0, -1))
				local healthoffset2 = PointOffset.new(bottomoffset, Vector2.new(-1, -((bottomoffset.ScreenPos.Y - topoffset.ScreenPos.Y) - 1)))
				newobj2.Bkg = RectDynamic.new(topoffset)
				newobj2.Bkg.Filled = true
				newobj2.Bkg.Opacity = 0.5
				newobj2.Bkg.BottomRight = bottomoffset
				newobj2.Line = RectDynamic.new(healthoffset)
				newobj2.Line.Filled = true
				newobj2.Line.YAlignment = YAlignment.Bottom
				newobj2.Line.BottomRight = healthoffset2
				newobj2.Line.Color = Color3.fromHSV(math.clamp(plr.Humanoid.Health / plr.Humanoid.MaxHealth, 0, 1) / 2.5, 0.89, 1)
				newobj2.Offset = healthoffset2
				newobj2.TopOffset = topoffset
				newobj2.BottomOffset = bottomoffset
			end
			if ESPName.Enabled then 
				local nameoffset1 = PointOffset.new(PointInstance.new(plr.RootPart, CFrame.new(0, 3, 0)), Vector2.new(0, -15))
				local nameoffset2 = PointOffset.new(nameoffset1, Vector2.new(1, 1))
				newobj3.Text = TextDynamic.new(nameoffset1)
				newobj3.Text.Text = WhitelistFunctions:GetTag(plr.Player)..(plr.Player.DisplayName or plr.Player.Name)
				newobj3.Text.Color = newobj.Color
				newobj3.Text.ZIndex = 2
				newobj3.Text.Size = 20
				newobj3.Drop = TextDynamic.new(nameoffset2)
				newobj3.Drop.Text = newobj3.Text.Text
				newobj3.Drop.Color = Color3.new()
				newobj3.Drop.ZIndex = 1
				newobj3.Drop.Size = 20
			end
			espfolderdrawing[plr.Player] = {entity = plr, Main = newobj, HealthBar = newobj2, Name = newobj3}
		end,
		DrawingSkeleton = function(plr)
			if ESPTeammates.Enabled and (not plr.Targetable) and (not plr.Friend) then return end
			local thing = {}
			thing.Head = Drawing.new("Line")
			thing.Head2 = Drawing.new("Line")
			thing.Torso = Drawing.new("Line")
			thing.Torso2 = Drawing.new("Line")
			thing.Torso3 = Drawing.new("Line")
			thing.LeftArm = Drawing.new("Line")
			thing.RightArm = Drawing.new("Line")
			thing.LeftLeg = Drawing.new("Line")
			thing.RightLeg = Drawing.new("Line")
			local color = getPlayerColor(plr.Player) or Color3.fromHSV(ESPColor.Hue, ESPColor.Sat, ESPColor.Value)
			for i,v in pairs(thing) do v.Thickness = 2 v.Color = color end
			espfolderdrawing[plr.Player] = {entity = plr, Main = thing}
		end,
		DrawingSkeletonV3 = function(plr)
			if ESPTeammates.Enabled and (not plr.Targetable) and (not plr.Friend) then return end
			local thing = {Main = {}, entity = plr}
			local rigcheck = plr.Humanoid.RigType == Enum.HumanoidRigType.R6
			local head = PointInstance.new(plr.Head)
			head.RotationType = CFrameRotationType.TargetRelative
			local headfront = PointInstance.new(plr.Head, CFrame.new(0, 0, -0.5))
			headfront.RotationType = CFrameRotationType.TargetRelative
			local toplefttorso = PointInstance.new(plr.Character[(rigcheck and "Torso" or "UpperTorso")], CFrame.new(-1.5, 0.8, 0))
			toplefttorso.RotationType = CFrameRotationType.TargetRelative
			local toprighttorso = PointInstance.new(plr.Character[(rigcheck and "Torso" or "UpperTorso")], CFrame.new(1.5, 0.8, 0))
			toprighttorso.RotationType = CFrameRotationType.TargetRelative
			local toptorso = PointInstance.new(plr.Character[(rigcheck and "Torso" or "UpperTorso")], CFrame.new(0, 0.8, 0))
			toptorso.RotationType = CFrameRotationType.TargetRelative
			local bottomtorso = PointInstance.new(plr.Character[(rigcheck and "Torso" or "UpperTorso")], CFrame.new(0, -0.8, 0))
			bottomtorso.RotationType = CFrameRotationType.TargetRelative
			local bottomlefttorso = PointInstance.new(plr.Character[(rigcheck and "Torso" or "UpperTorso")], CFrame.new(-0.5, -0.8, 0))
			bottomlefttorso.RotationType = CFrameRotationType.TargetRelative
			local bottomrighttorso = PointInstance.new(plr.Character[(rigcheck and "Torso" or "UpperTorso")], CFrame.new(0.5, -0.8, 0))
			bottomrighttorso.RotationType = CFrameRotationType.TargetRelative
			local leftarm = PointInstance.new(plr.Character[(rigcheck and "Left Arm" or "LeftHand")], CFrame.new(0, -0.8, 0))
			leftarm.RotationType = CFrameRotationType.TargetRelative
			local rightarm = PointInstance.new(plr.Character[(rigcheck and "Right Arm" or "RightHand")], CFrame.new(0, -0.8, 0))
			rightarm.RotationType = CFrameRotationType.TargetRelative
			local leftleg = PointInstance.new(plr.Character[(rigcheck and "Left Leg" or "LeftFoot")], CFrame.new(0, -0.8, 0))
			leftleg.RotationType = CFrameRotationType.TargetRelative
			local rightleg = PointInstance.new(plr.Character[(rigcheck and "Right Leg" or "RightFoot")], CFrame.new(0, -0.8, 0))
			rightleg.RotationType = CFrameRotationType.TargetRelative
			thing.Main.Head = LineDynamic.new(toptorso, head)
			thing.Main.Head2 = LineDynamic.new(head, headfront)
			thing.Main.Torso = LineDynamic.new(toplefttorso, toprighttorso)
			thing.Main.Torso2 = LineDynamic.new(toptorso, bottomtorso)
			thing.Main.Torso3 = LineDynamic.new(bottomlefttorso, bottomrighttorso)
			thing.Main.LeftArm = LineDynamic.new(toplefttorso, leftarm)
			thing.Main.RightArm = LineDynamic.new(toprighttorso, rightarm)
			thing.Main.LeftLeg = LineDynamic.new(bottomlefttorso, leftleg)
			thing.Main.RightLeg = LineDynamic.new(bottomrighttorso, rightleg)
			local color = getPlayerColor(plr.Player) or Color3.fromHSV(ESPColor.Hue, ESPColor.Sat, ESPColor.Value)
			for i,v in pairs(thing.Main) do v.Thickness = 2 v.Color = color end
			espfolderdrawing[plr.Player] = thing
		end,
		Drawing3D = function(plr)
			if ESPTeammates.Enabled and (not plr.Targetable) and (not plr.Friend) then return end
			local thing = {}
			thing.Line1 = Drawing.new("Line")
			thing.Line2 = Drawing.new("Line")
			thing.Line3 = Drawing.new("Line")
			thing.Line4 = Drawing.new("Line")
			thing.Line5 = Drawing.new("Line")
			thing.Line6 = Drawing.new("Line")
			thing.Line7 = Drawing.new("Line")
			thing.Line8 = Drawing.new("Line")
			thing.Line9 = Drawing.new("Line")
			thing.Line10 = Drawing.new("Line")
			thing.Line11 = Drawing.new("Line")
			thing.Line12 = Drawing.new("Line")
			local color = getPlayerColor(plr.Player) or Color3.fromHSV(ESPColor.Hue, ESPColor.Sat, ESPColor.Value)
			for i,v in pairs(thing) do v.Thickness = 1 v.Color = color end
			espfolderdrawing[plr.Player] = {entity = plr, Main = thing}
		end,
		Drawing3DV3 = function(plr)
			if ESPTeammates.Enabled and (not plr.Targetable) and (not plr.Friend) then return end
			local thing = {}
			local point1 = PointInstance.new(plr.RootPart, CFrame.new(1.5, 3, 1.5))
			point1.RotationType = CFrameRotationType.Ignore
			local point2 = PointInstance.new(plr.RootPart, CFrame.new(1.5, -3, 1.5))
			point2.RotationType = CFrameRotationType.Ignore
			local point3 = PointInstance.new(plr.RootPart, CFrame.new(-1.5, 3, 1.5))
			point3.RotationType = CFrameRotationType.Ignore
			local point4 = PointInstance.new(plr.RootPart, CFrame.new(-1.5, -3, 1.5))
			point4.RotationType = CFrameRotationType.Ignore
			local point5 = PointInstance.new(plr.RootPart, CFrame.new(1.5, 3, -1.5))
			point5.RotationType = CFrameRotationType.Ignore
			local point6 = PointInstance.new(plr.RootPart, CFrame.new(1.5, -3, -1.5))
			point6.RotationType = CFrameRotationType.Ignore
			local point7 = PointInstance.new(plr.RootPart, CFrame.new(-1.5, 3, -1.5))
			point7.RotationType = CFrameRotationType.Ignore
			local point8 = PointInstance.new(plr.RootPart, CFrame.new(-1.5, -3, -1.5))
			point8.RotationType = CFrameRotationType.Ignore
			thing.Line1 = LineDynamic.new(point1, point2)
			thing.Line2 = LineDynamic.new(point3, point4)
			thing.Line3 = LineDynamic.new(point5, point6)
			thing.Line4 = LineDynamic.new(point7, point8)
			thing.Line5 = LineDynamic.new(point1, point3)
			thing.Line6 = LineDynamic.new(point1, point5)
			thing.Line7 = LineDynamic.new(point5, point7)
			thing.Line8 = LineDynamic.new(point7, point3)
			thing.Line9 = LineDynamic.new(point2, point4)
			thing.Line10 = LineDynamic.new(point2, point6)
			thing.Line11 = LineDynamic.new(point6, point8)
			thing.Line12 = LineDynamic.new(point8, point4)
			local color = getPlayerColor(plr.Player) or Color3.fromHSV(ESPColor.Hue, ESPColor.Sat, ESPColor.Value)
			for i,v in pairs(thing) do v.Thickness = 1 v.Color = color end
			espfolderdrawing[plr.Player] = {entity = plr, Main = thing}
		end
	}
	local espfuncs2 = {
		Drawing2D = function(ent)
			local v = espfolderdrawing[ent]
			espfolderdrawing[ent] = nil
			if v then 
				for i2,v2 in pairs(v.Main) do
					pcall(function() v2.Visible = false v2:Remove() end)
				end
			end
		end,
		Drawing2DV3 = function(ent)
			local v = espfolderdrawing[ent]
			espfolderdrawing[ent] = nil
			if v then
				v.Main.Visible = false
				for i2,v2 in pairs(v.HealthBar) do
					if typeof(v2):find("Point") == nil then 
						v2.Visible = false
					end
				end
				for i2,v2 in pairs(v.Name) do
					if typeof(v2):find("Point") == nil then 
						v2.Visible = false
					end
				end
			end
		end,
		Drawing3D = function(ent)
			local v = espfolderdrawing[ent]
			espfolderdrawing[ent] = nil
			if v then 
				for i2,v2 in pairs(v.Main) do
					pcall(function() v2.Visible = false v2:Remove() end)
				end
			end
		end,
		Drawing3DV3 = function(ent)
			local v = espfolderdrawing[ent]
			espfolderdrawing[ent] = nil
			if v then
				for i2,v2 in pairs(v.Main) do
					if typeof(v2):find("Dynamic") then 
						v2.Visible = false
					end
				end
			end
		end,
		DrawingSkeleton = function(ent)
			local v = espfolderdrawing[ent]
			espfolderdrawing[ent] = nil
			if v then 
				for i2,v2 in pairs(v.Main) do
					pcall(function() v2.Visible = false v2:Remove() end)
				end
			end
		end,
		DrawingSkeletonV3 = function(ent)
			local v = espfolderdrawing[ent]
			espfolderdrawing[ent] = nil
			if v then 
				for i2,v2 in pairs(v.Main) do
					if typeof(v2):find("Dynamic") then 
						v2.Visible = false
					end
				end
			end
		end
	}
	local espupdatefuncs = {
		Drawing2D = function(ent)
			local v = espfolderdrawing[ent.Player]
			if v and v.Main.Quad3 then 
				local color = Color3.fromHSV(math.clamp(ent.Humanoid.Health / ent.Humanoid.MaxHealth, 0, 1) / 2.5, 0.89, 1)
				v.Main.Quad3.Color = color
			end
			if v and v.Text then 
				v.Text.Text = WhitelistFunctions:GetTag(ent.Player)..(ent.Player.DisplayName or ent.Player.Name)
				v.Drop.Text = v.Text.Text
			end
		end,
		Drawing2DV3 = function(ent)
			local v = espfolderdrawing[ent.Player]
			if v and v.HealthBar.Line then 
				local health = ent.Humanoid.Health / ent.Humanoid.MaxHealth
				local color = Color3.fromHSV(math.clamp(health, 0, 1) / 2.5, 0.89, 1)
				v.HealthBar.Line.Color = color
			end
			if v and v.Name and v.Name.Text then 
				v.Name.Text.Text = WhitelistFunctions:GetTag(ent.Player)..(ent.Player.DisplayName or ent.Player.Name)
				v.Name.Drop.Text = v.Name.Text.Text
			end
		end
	}
	local espcolorfuncs = {
		Drawing2D = function(hue, sat, value)
			local color = Color3.fromHSV(hue, sat, value)
			for i,v in pairs(espfolderdrawing) do 
				v.Main.Quad1.Color = getPlayerColor(v.entity.Player) or color
				if v.Main.Text then 
					v.Main.Text.Color = v.Main.Quad1.Color
				end
			end
		end,
		Drawing2DV3 = function(hue, sat, value)
			local color = Color3.fromHSV(hue, sat, value)
			for i,v in pairs(espfolderdrawing) do 
				v.Main.Color = getPlayerColor(v.entity.Player) or color
				if v.Name.Text then 
					v.Name.Text.Color = v.Main.Color
				end
			end
		end,
		Drawing3D = function(hue, sat, value)
			local color = Color3.fromHSV(hue, sat, value)
			for i,v in pairs(espfolderdrawing) do 
				local newcolor = getPlayerColor(v.entity.Player) or color
				for i2,v2 in pairs(v.Main) do
					v2.Color = newcolor
				end
			end
		end,
		Drawing3DV3 = function(hue, sat, value)
			local color = Color3.fromHSV(hue, sat, value)
			for i,v in pairs(espfolderdrawing) do 
				local newcolor = getPlayerColor(v.entity.Player) or color
				for i2,v2 in pairs(v.Main) do
					if typeof(v2):find("Dynamic") then 
						v2.Color = newcolor
					end
				end
			end
		end,
		DrawingSkeleton = function(hue, sat, value)
			local color = Color3.fromHSV(hue, sat, value)
			for i,v in pairs(espfolderdrawing) do 
				local newcolor = getPlayerColor(v.entity.Player) or color
				for i2,v2 in pairs(v.Main) do
					v2.Color = newcolor
				end
			end
		end,
		DrawingSkeletonV3 = function(hue, sat, value)
			local color = Color3.fromHSV(hue, sat, value)
			for i,v in pairs(espfolderdrawing) do 
				local newcolor = getPlayerColor(v.entity.Player) or color
				for i2,v2 in pairs(v.Main) do
					if typeof(v2):find("Dynamic") then 
						v2.Color = newcolor
					end
				end
			end
		end,
	}
	local esploop = {
		Drawing2D = function()
			for i,v in pairs(espfolderdrawing) do 
				local rootPos, rootVis = worldtoviewportpoint(v.entity.RootPart.Position)
				if not rootVis then 
					v.Main.Quad1.Visible = false
					v.Main.QuadLine2.Visible = false
					v.Main.QuadLine3.Visible = false
					if v.Main.Quad3 then 
						v.Main.Quad3.Visible = false
						v.Main.Quad4.Visible = false
					end
					if v.Main.Text then 
						v.Main.Text.Visible = false
						v.Main.Drop.Visible = false
					end
					continue 
				end
				local topPos, topVis = worldtoviewportpoint((CFrame.new(v.entity.RootPart.Position, v.entity.RootPart.Position + gameCamera.CFrame.lookVector) * CFrame.new(2, 3, 0)).p)
				local bottomPos, bottomVis = worldtoviewportpoint((CFrame.new(v.entity.RootPart.Position, v.entity.RootPart.Position + gameCamera.CFrame.lookVector) * CFrame.new(-2, -3.5, 0)).p)
				local sizex, sizey = topPos.X - bottomPos.X, topPos.Y - bottomPos.Y
				local posx, posy = (rootPos.X - sizex / 2),  ((rootPos.Y - sizey / 2))
				v.Main.Quad1.Position = floorESPPosition(Vector2.new(posx, posy))
				v.Main.Quad1.Size = floorESPPosition(Vector2.new(sizex, sizey))
				v.Main.Quad1.Visible = true
				v.Main.QuadLine2.Position = floorESPPosition(Vector2.new(posx - 1, posy + 1))
				v.Main.QuadLine2.Size = floorESPPosition(Vector2.new(sizex + 2, sizey - 2))
				v.Main.QuadLine2.Visible = true
				v.Main.QuadLine3.Position = floorESPPosition(Vector2.new(posx + 1, posy - 1))
				v.Main.QuadLine3.Size = floorESPPosition(Vector2.new(sizex - 2, sizey + 2))
				v.Main.QuadLine3.Visible = true
				if v.Main.Quad3 then 
					local healthposy = sizey * math.clamp(v.entity.Humanoid.Health / v.entity.Humanoid.MaxHealth, 0, 1)
					v.Main.Quad3.Visible = v.entity.Humanoid.Health > 0
					v.Main.Quad3.From = floorESPPosition(Vector2.new(posx - 4, posy + (sizey - (sizey - healthposy))))
					v.Main.Quad3.To = floorESPPosition(Vector2.new(posx - 4, posy))
					v.Main.Quad4.Visible = true
					v.Main.Quad4.From = floorESPPosition(Vector2.new(posx - 4, posy))
					v.Main.Quad4.To = floorESPPosition(Vector2.new(posx - 4, (posy + sizey)))
				end
				if v.Main.Text then 
					v.Main.Text.Visible = true
					v.Main.Drop.Visible = true
					v.Main.Text.Position = floorESPPosition(Vector2.new(posx + (sizex / 2), posy + (sizey - 25)))
					v.Main.Drop.Position = v.Main.Text.Position + Vector2.new(1, 1)
				end
			end
		end,
		Drawing2DV3 = function()
			for i,v in pairs(espfolderdrawing) do 
				if v.HealthBar.Offset then 
					v.HealthBar.Offset.Offset = Vector2.new(-1, -(((v.HealthBar.BottomOffset.ScreenPos.Y - v.HealthBar.TopOffset.ScreenPos.Y) - 1) * (v.entity.Humanoid.Health / v.entity.Humanoid.MaxHealth)))
					v.HealthBar.Line.Visible = v.entity.Humanoid.Health > 0
				end
			end
		end,
		Drawing3D = function()
			for i,v in pairs(espfolderdrawing) do 
				local rootPos, rootVis = worldtoviewportpoint(v.entity.RootPart.Position)
				if not rootVis then 
					for i,v in pairs(v.Main) do 
						v.Visible = false
					end
					continue 
				end
				for i,v in pairs(v.Main) do 
					v.Visible = true
				end
				local point1 = ESPWorldToViewport(v.entity.RootPart.Position + Vector3.new(1.5, 3, 1.5))
				local point2 = ESPWorldToViewport(v.entity.RootPart.Position + Vector3.new(1.5, -3, 1.5))
				local point3 = ESPWorldToViewport(v.entity.RootPart.Position + Vector3.new(-1.5, 3, 1.5))
				local point4 = ESPWorldToViewport(v.entity.RootPart.Position + Vector3.new(-1.5, -3, 1.5))
				local point5 = ESPWorldToViewport(v.entity.RootPart.Position + Vector3.new(1.5, 3, -1.5))
				local point6 = ESPWorldToViewport(v.entity.RootPart.Position + Vector3.new(1.5, -3, -1.5))
				local point7 = ESPWorldToViewport(v.entity.RootPart.Position + Vector3.new(-1.5, 3, -1.5))
				local point8 = ESPWorldToViewport(v.entity.RootPart.Position + Vector3.new(-1.5, -3, -1.5))
				v.Main.Line1.From = point1
				v.Main.Line1.To = point2
				v.Main.Line2.From = point3
				v.Main.Line2.To = point4
				v.Main.Line3.From = point5
				v.Main.Line3.To = point6
				v.Main.Line4.From = point7
				v.Main.Line4.To = point8
				v.Main.Line5.From = point1
				v.Main.Line5.To = point3
				v.Main.Line6.From = point1
				v.Main.Line6.To = point5
				v.Main.Line7.From = point5
				v.Main.Line7.To = point7
				v.Main.Line8.From = point7
				v.Main.Line8.To = point3
				v.Main.Line9.From = point2
				v.Main.Line9.To = point4
				v.Main.Line10.From = point2
				v.Main.Line10.To = point6
				v.Main.Line11.From = point6
				v.Main.Line11.To = point8
				v.Main.Line12.From = point8
				v.Main.Line12.To = point4
			end
		end,
		DrawingSkeleton = function()
			for i,v in pairs(espfolderdrawing) do 
				local rootPos, rootVis = worldtoviewportpoint(v.entity.RootPart.Position)
				if not rootVis then 
					for i,v in pairs(v.Main) do 
						v.Visible = false
					end
					continue 
				end
				for i,v in pairs(v.Main) do 
					v.Visible = true
				end
				local rigcheck = v.entity.Humanoid.RigType == Enum.HumanoidRigType.R6
				local head = ESPWorldToViewport((v.entity.Head.CFrame).p)
				local headfront = ESPWorldToViewport((v.entity.Head.CFrame * CFrame.new(0, 0, -0.5)).p)
				local toplefttorso = ESPWorldToViewport((v.entity.Character[(rigcheck and "Torso" or "UpperTorso")].CFrame * CFrame.new(-1.5, 0.8, 0)).p)
				local toprighttorso = ESPWorldToViewport((v.entity.Character[(rigcheck and "Torso" or "UpperTorso")].CFrame * CFrame.new(1.5, 0.8, 0)).p)
				local toptorso = ESPWorldToViewport((v.entity.Character[(rigcheck and "Torso" or "UpperTorso")].CFrame * CFrame.new(0, 0.8, 0)).p)
				local bottomtorso = ESPWorldToViewport((v.entity.Character[(rigcheck and "Torso" or "UpperTorso")].CFrame * CFrame.new(0, -0.8, 0)).p)
				local bottomlefttorso = ESPWorldToViewport((v.entity.Character[(rigcheck and "Torso" or "UpperTorso")].CFrame * CFrame.new(-0.5, -0.8, 0)).p)
				local bottomrighttorso = ESPWorldToViewport((v.entity.Character[(rigcheck and "Torso" or "UpperTorso")].CFrame * CFrame.new(0.5, -0.8, 0)).p)
				local leftarm = ESPWorldToViewport((v.entity.Character[(rigcheck and "Left Arm" or "LeftHand")].CFrame * CFrame.new(0, -0.8, 0)).p)
				local rightarm = ESPWorldToViewport((v.entity.Character[(rigcheck and "Right Arm" or "RightHand")].CFrame * CFrame.new(0, -0.8, 0)).p)
				local leftleg = ESPWorldToViewport((v.entity.Character[(rigcheck and "Left Leg" or "LeftFoot")].CFrame * CFrame.new(0, -0.8, 0)).p)
				local rightleg = ESPWorldToViewport((v.entity.Character[(rigcheck and "Right Leg" or "RightFoot")].CFrame * CFrame.new(0, -0.8, 0)).p)
				v.Main.Torso.From = toplefttorso
				v.Main.Torso.To = toprighttorso
				v.Main.Torso2.From = toptorso
				v.Main.Torso2.To = bottomtorso
				v.Main.Torso3.From = bottomlefttorso
				v.Main.Torso3.To = bottomrighttorso
				v.Main.LeftArm.From = toplefttorso
				v.Main.LeftArm.To = leftarm
				v.Main.RightArm.From = toprighttorso
				v.Main.RightArm.To = rightarm
				v.Main.LeftLeg.From = bottomlefttorso
				v.Main.LeftLeg.To = leftleg
				v.Main.RightLeg.From = bottomrighttorso
				v.Main.RightLeg.To = rightleg
				v.Main.Head.From = toptorso
				v.Main.Head.To = head
				v.Main.Head2.From = head
				v.Main.Head2.To = headfront
			end
		end
	}

	local ESP = {Enabled = false}
	ESP = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "ESP", 
		Function = function(callback) 
			if callback then
				methodused = "Drawing"..ESPMethod.Value..synapsev3
				if espfuncs2[methodused] then
					table.insert(ESP.Connections, entityLibrary.entityRemovedEvent:Connect(espfuncs2[methodused]))
				end
				if espfuncs1[methodused] then
					local addfunc = espfuncs1[methodused]
					for i,v in pairs(entityLibrary.entityList) do 
						if espfolderdrawing[v.Player] then espfuncs2[methodused](v.Player) end
						addfunc(v)
					end
					table.insert(ESP.Connections, entityLibrary.entityAddedEvent:Connect(function(ent)
						if espfolderdrawing[ent.Player] then espfuncs2[methodused](ent.Player) end
						addfunc(ent)
					end))
				end
				if espupdatefuncs[methodused] then
					table.insert(ESP.Connections, entityLibrary.entityUpdatedEvent:Connect(espupdatefuncs[methodused]))
					for i,v in pairs(entityLibrary.entityList) do 
						espupdatefuncs[methodused](v)
					end
				end
				if espcolorfuncs[methodused] then 
					table.insert(ESP.Connections, GuiLibrary.ObjectsThatCanBeSaved.FriendsListTextCircleList.Api.FriendColorRefresh.Event:Connect(function()
						espcolorfuncs[methodused](ESPColor.Hue, ESPColor.Sat, ESPColor.Value)
					end))
				end
				if esploop[methodused] then 
					RunLoops:BindToRenderStep("ESP", esploop[methodused])
				end
			else
				RunLoops:UnbindFromRenderStep("ESP")
				if espfuncs2[methodused] then
					for i,v in pairs(espfolderdrawing) do 
						espfuncs2[methodused](i)
					end
				end
			end
		end,
		HoverText = "Extra Sensory Perception\nRenders an ESP on players."
	})
	ESPColor = ESP.CreateColorSlider({
		Name = "Player Color", 
		Function = function(hue, sat, val) 
			if ESP.Enabled and espcolorfuncs[methodused] then 
				espcolorfuncs[methodused](hue, sat, val)
			end
		end
	})
	ESPMethod = ESP.CreateDropdown({
		Name = "Mode",
		List = {"2D", "3D", "Skeleton"},
		Function = function(val)
			if ESP.Enabled then ESP.ToggleButton(true) ESP.ToggleButton(true) end
			ESPBoundingBox.Object.Visible = (val == "2D")
			ESPHealthBar.Object.Visible = (val == "2D")
			ESPName.Object.Visible = (val == "2D")
		end,
	})
	ESPBoundingBox = ESP.CreateToggle({
		Name = "Bounding Box",
		Function = function() if ESP.Enabled then ESP.ToggleButton(true) ESP.ToggleButton(true) end end,
		Default = true
	})
	ESPTeammates = ESP.CreateToggle({
		Name = "Priority Only",
		Function = function() if ESP.Enabled then ESP.ToggleButton(true) ESP.ToggleButton(true) end end,
		Default = true
	})
	ESPHealthBar = ESP.CreateToggle({
		Name = "Health Bar", 
		Function = function(callback) if ESP.Enabled then ESP.ToggleButton(true) ESP.ToggleButton(true) end end
	})
	ESPName = ESP.CreateToggle({
		Name = "Name", 
		Function = function(callback) if ESP.Enabled then ESP.ToggleButton(true) ESP.ToggleButton(true) end end
	})
end)


runFunction(function()
	local ChamsFolder = Instance.new("Folder")
	ChamsFolder.Name = "ChamsFolder"
	ChamsFolder.Parent = GuiLibrary.MainGui
	local chamstable = {}
	local ChamsColor = {Value = 0.44}
	local ChamsOutlineColor = {Value = 0.44}
	local ChamsTransparency = {Value = 1}
	local ChamsOutlineTransparency = {Value = 1}
	local ChamsOnTop = {Enabled = true}
	local ChamsTeammates = {Enabled = true}

	local function addfunc(ent)
		local chamfolder = Instance.new("Highlight")
		chamfolder.Name = ent.Player.Name
		chamfolder.Enabled = true
		chamfolder.Adornee = ent.Character
		chamfolder.OutlineTransparency = ChamsOutlineTransparency.Value / 100
		chamfolder.DepthMode = Enum.HighlightDepthMode[(ChamsOnTop.Enabled and "AlwaysOnTop" or "Occluded")]
		chamfolder.FillColor = getPlayerColor(ent.Player) or Color3.fromHSV(ChamsColor.Hue, ChamsColor.Sat, ChamsColor.Value)
		chamfolder.OutlineColor = getPlayerColor(ent.Player) or Color3.fromHSV(ChamsOutlineColor.Hue, ChamsOutlineColor.Sat, ChamsOutlineColor.Value)
		chamfolder.FillTransparency = ChamsTransparency.Value / 100
		chamfolder.Parent = ChamsFolder
		chamstable[ent.Player] = {Main = chamfolder, entity = ent}
	end

	local function removefunc(ent)
		local v = chamstable[ent]
		chamstable[ent] = nil
		if v then
			v.Main:Destroy()
		end
	end

	local Chams = {Enabled = false}
	Chams = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "Chams", 
		Function = function(callback) 
			if callback then
				table.insert(Chams.Connections, entityLibrary.entityRemovedEvent:Connect(removefunc))
				for i,v in pairs(entityLibrary.entityList) do 
					if chamstable[v.Player] then removefunc(v.Player) end
					addfunc(v)
				end
				table.insert(Chams.Connections, entityLibrary.entityAddedEvent:Connect(function(ent)
					if chamstable[ent.Player] then removefunc(ent.Player) end
					addfunc(ent)
				end))
				table.insert(Chams.Connections, GuiLibrary.ObjectsThatCanBeSaved.FriendsListTextCircleList.Api.FriendColorRefresh.Event:Connect(function()
					for i,v in pairs(chamstable) do 
						v.Main.FillColor = getPlayerColor(i) or Color3.fromHSV(ChamsColor.Hue, ChamsColor.Sat, ChamsColor.Value)
						v.Main.OutlineColor = getPlayerColor(i) or Color3.fromHSV(ChamsOutlineColor.Hue, ChamsOutlineColor.Sat, ChamsOutlineColor.Value)
					end
				end))
			else
				for i,v in pairs(chamstable) do 
					removefunc(i)
				end
			end
		end,
		HoverText = "Render players through walls"
	})
	ChamsColor = Chams.CreateColorSlider({
		Name = "Player Color", 
		Function = function(val) 
			for i,v in pairs(chamstable) do 
				v.Main.FillColor = getPlayerColor(i) or Color3.fromHSV(ChamsColor.Hue, ChamsColor.Sat, ChamsColor.Value)
			end
		end
	})
	ChamsOutlineColor = Chams.CreateColorSlider({
		Name = "Outline Player Color", 
		Function = function(val)
			for i,v in pairs(chamstable) do 
				v.Main.OutlineColor = getPlayerColor(i) or Color3.fromHSV(ChamsOutlineColor.Hue, ChamsOutlineColor.Sat, ChamsOutlineColor.Value)
			end
		end
	})
	ChamsTransparency = Chams.CreateSlider({
		Name = "Transparency", 
		Min = 1,
		Max = 100, 
		Function = function(callback) if Chams.Enabled then Chams.ToggleButton(true) Chams.ToggleButton(true) end end,
		Default = 50
	})
	ChamsOutlineTransparency = Chams.CreateSlider({
		Name = "Outline Transparency", 
		Min = 1,
		Max = 100, 
		Function = function(callback) if Chams.Enabled then Chams.ToggleButton(true) Chams.ToggleButton(true) end end,
		Default = 1
	})
	ChamsTeammates = Chams.CreateToggle({
		Name = "Teammates",
		Function = function(callback) if Chams.Enabled then Chams.ToggleButton(true) Chams.ToggleButton(true) end end,
		Default = true
	})
	ChamsOnTop = Chams.CreateToggle({
		Name = "Bypass Walls", 
		Function = function(callback) if Chams.Enabled then Chams.ToggleButton(true) Chams.ToggleButton(true) end end
	})
end)

runFunction(function()
	local lightingsettings = {}
	local lightingchanged = false
	local Fullbright = {Enabled = false}
	Fullbright = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "Fullbright",
		Function = function(callback)
			if callback then 
				lightingsettings.Brightness = lightingService.Brightness
				lightingsettings.ClockTime = lightingService.ClockTime
				lightingsettings.FogEnd = lightingService.FogEnd
				lightingsettings.GlobalShadows = lightingService.GlobalShadows
				lightingsettings.OutdoorAmbient = lightingService.OutdoorAmbient
				lightingchanged = true
				lightingService.Brightness = 2
				lightingService.ClockTime = 14
				lightingService.FogEnd = 100000
				lightingService.GlobalShadows = false
				lightingService.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
				lightingchanged = false
				table.insert(Fullbright.Connections, lightingService.Changed:Connect(function()
					if not lightingchanged then
						lightingsettings.Brightness = lightingService.Brightness
						lightingsettings.ClockTime = lightingService.ClockTime
						lightingsettings.FogEnd = lightingService.FogEnd
						lightingsettings.GlobalShadows = lightingService.GlobalShadows
						lightingsettings.OutdoorAmbient = lightingService.OutdoorAmbient
						lightingchanged = true
						lightingService.Brightness = 2
						lightingService.ClockTime = 14
						lightingService.FogEnd = 100000
						lightingService.GlobalShadows = false
						lightingService.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
						lightingchanged = false
					end
				end))
			else
				for name, val in pairs(lightingsettings) do 
					lightingService[name] = val
				end
			end
		end
	})
end)

runFunction(function()
	local Health = {Enabled = false}
	Health =  GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "Health", 
		Function = function(callback) 
			if callback then
				HealthText = Drawing.new("Text")
				HealthText.Size = 20
				HealthText.Text = "100HP"
				HealthText.Position = Vector2.new(0, 0)
				HealthText.Color = Color3.fromRGB(0, 255, 0)
				HealthText.Center = true
				HealthText.Visible = true
				task.spawn(function()
					repeat
						if entityLibrary.isAlive then
							HealthText.Text = tostring(math.round(entityLibrary.character.Humanoid.Health)).."HP"
							HealthText.Color = Color3.fromHSV(math.clamp(entityLibrary.character.Humanoid.Health / entityLibrary.character.Humanoid.MaxHealth, 0, 1) / 2.5, 0.89, 1)
						end
						HealthText.Position = Vector2.new(gameCamera.ViewportSize.X / 2, gameCamera.ViewportSize.Y / 2 + 70)
						task.wait(0.1)
					until not Health.Enabled
				end)
			else
				if HealthText then HealthText:Remove() end
				RunLoops:UnbindFromRenderStep("Health")
			end
		end,
		HoverText = "Displays your health in the center of your screen."
	})
end)

runFunction(function()
	local function floorNameTagPosition(pos)
		return Vector2.new(math.floor(pos.X), math.floor(pos.Y))
	end

	local function removeTags(str)
        str = str:gsub("<br%s*/>", "\n")
        return (str:gsub("<[^<>]->", ""))
    end

	local NameTagsFolder = Instance.new("Folder")
	NameTagsFolder.Name = "NameTagsFolder"
	NameTagsFolder.Parent = GuiLibrary.MainGui
	local nametagsfolderdrawing = {}
	local NameTagsColor = {Value = 0.44}
	local NameTagsDisplayName = {Enabled = false}
	local NameTagsHealth = {Enabled = false}
	local NameTagsDistance = {Enabled = false}
	local NameTagsBackground = {Enabled = true}
	local NameTagsScale = {Value = 10}
	local NameTagsFont = {Value = "SourceSans"}
	local NameTagsTeammates = {Enabled = true}
	local fontitems = {"SourceSans"}
	local nametagstrs = {}
	local nametagsizes = {}

	local nametagfuncs1 = {
		Normal = function(plr)
			if NameTagsTeammates.Enabled and (not plr.Targetable) and (not plr.Friend) then return end
			local thing = Instance.new("TextLabel")
			thing.BackgroundColor3 = Color3.new()
			thing.BorderSizePixel = 0
			thing.Visible = false
			thing.RichText = true
			thing.AnchorPoint = Vector2.new(0.5, 1)
			thing.Name = plr.Player.Name
			thing.Font = Enum.Font[NameTagsFont.Value]
			thing.TextSize = 14 * (NameTagsScale.Value / 10)
			thing.BackgroundTransparency = NameTagsBackground.Enabled and 0.5 or 1
			nametagstrs[plr.Player] = WhitelistFunctions:GetTag(plr.Player)..(NameTagsDisplayName.Enabled and plr.Player.DisplayName or plr.Player.Name)
			if NameTagsHealth.Enabled then
				local color = Color3.fromHSV(math.clamp(plr.Humanoid.Health / plr.Humanoid.MaxHealth, 0, 1) / 2.5, 0.89, 1)
				nametagstrs[plr.Player] = nametagstrs[plr.Player]..' <font color="rgb('..tostring(math.floor(color.R * 255))..','..tostring(math.floor(color.G * 255))..','..tostring(math.floor(color.B * 255))..')">'..math.round(plr.Humanoid.Health).."</font>"
			end
			if NameTagsDistance.Enabled then 
				nametagstrs[plr.Player] = '<font color="rgb(85, 255, 85)">[</font><font color="rgb(255, 255, 255)">%s</font><font color="rgb(85, 255, 85)">]</font> '..nametagstrs[plr.Player]
			end
			local nametagSize = textService:GetTextSize(removeTags(nametagstrs[plr.Player]), thing.TextSize, thing.Font, Vector2.new(100000, 100000))
			thing.Size = UDim2.new(0, nametagSize.X + 4, 0, nametagSize.Y)
			thing.Text = nametagstrs[plr.Player]
			thing.TextColor3 = getPlayerColor(plr.Player) or Color3.fromHSV(NameTagsColor.Hue, NameTagsColor.Sat, NameTagsColor.Value)
			thing.Parent = NameTagsFolder
			nametagsfolderdrawing[plr.Player] = {entity = plr, Main = thing}
		end,
		Drawing = function(plr)
			if NameTagsTeammates.Enabled and (not plr.Targetable) and (not plr.Friend) then return end
			local thing = {Main = {}, entity = plr}
			thing.Main.Text = Drawing.new("Text")
			thing.Main.Text.Size = 17 * (NameTagsScale.Value / 10)
			thing.Main.Text.Font = (math.clamp((table.find(fontitems, NameTagsFont.Value) or 1) - 1, 0, 3))
			thing.Main.Text.ZIndex = 2
			thing.Main.BG = Drawing.new("Square")
			thing.Main.BG.Filled = true
			thing.Main.BG.Transparency = 0.5
			thing.Main.BG.Visible = NameTagsBackground.Enabled
			thing.Main.BG.Color = Color3.new()
			thing.Main.BG.ZIndex = 1
			nametagstrs[plr.Player] = WhitelistFunctions:GetTag(plr.Player)..(NameTagsDisplayName.Enabled and plr.Player.DisplayName or plr.Player.Name)
			if NameTagsHealth.Enabled then
				local color = Color3.fromHSV(math.clamp(plr.Humanoid.Health / plr.Humanoid.MaxHealth, 0, 1) / 2.5, 0.89, 1)
				nametagstrs[plr.Player] = nametagstrs[plr.Player]..' '..math.round(plr.Humanoid.Health)
			end
			if NameTagsDistance.Enabled then 
				nametagstrs[plr.Player] = '[%s] '..nametagstrs[plr.Player]
			end
			thing.Main.Text.Text = nametagstrs[plr.Player]
			thing.Main.BG.Size = Vector2.new(thing.Main.Text.TextBounds.X + 4, thing.Main.Text.TextBounds.Y)
			thing.Main.Text.Color = getPlayerColor(plr.Player) or Color3.fromHSV(NameTagsColor.Hue, NameTagsColor.Sat, NameTagsColor.Value)
			nametagsfolderdrawing[plr.Player] = thing
		end
	}

	local nametagfuncs2 = {
		Normal = function(ent)
			local v = nametagsfolderdrawing[ent]
			nametagsfolderdrawing[ent] = nil
			if v then 
				v.Main:Destroy()
			end
		end,
		Drawing = function(ent)
			local v = nametagsfolderdrawing[ent]
			nametagsfolderdrawing[ent] = nil
			if v then 
				for i2,v2 in pairs(v.Main) do
					pcall(function() v2.Visible = false v2:Remove() end)
				end
			end
		end
	}

	local nametagupdatefuncs = {
		Normal = function(ent)
			local v = nametagsfolderdrawing[ent.Player]
			if v then 
				nametagstrs[ent.Player] = WhitelistFunctions:GetTag(ent.Player)..(NameTagsDisplayName.Enabled and ent.Player.DisplayName or ent.Player.Name)
				if NameTagsHealth.Enabled then
					local color = Color3.fromHSV(math.clamp(ent.Humanoid.Health / ent.Humanoid.MaxHealth, 0, 1) / 2.5, 0.89, 1)
					nametagstrs[ent.Player] = nametagstrs[ent.Player]..' <font color="rgb('..tostring(math.floor(color.R * 255))..','..tostring(math.floor(color.G * 255))..','..tostring(math.floor(color.B * 255))..')">'..math.round(ent.Humanoid.Health).."</font>"
				end
				if NameTagsDistance.Enabled then 
					nametagstrs[ent.Player] = '<font color="rgb(85, 255, 85)">[</font><font color="rgb(255, 255, 255)">%s</font><font color="rgb(85, 255, 85)">]</font> '..nametagstrs[ent.Player]
				end
				local nametagSize = textService:GetTextSize(removeTags(nametagstrs[ent.Player]), v.Main.TextSize, v.Main.Font, Vector2.new(100000, 100000))
				v.Main.Size = UDim2.new(0, nametagSize.X + 4, 0, nametagSize.Y)
				v.Main.Text = nametagstrs[ent.Player]
			end
		end,
		Drawing = function(ent)
			local v = nametagsfolderdrawing[ent.Player]
			if v then 
				nametagstrs[ent.Player] = WhitelistFunctions:GetTag(ent.Player)..(NameTagsDisplayName.Enabled and ent.Player.DisplayName or ent.Player.Name)
				if NameTagsHealth.Enabled then
					nametagstrs[ent.Player] = nametagstrs[ent.Player]..' '..math.round(ent.Humanoid.Health)
				end
				if NameTagsDistance.Enabled then 
					nametagstrs[ent.Player] = '[%s] '..nametagstrs[ent.Player]
					v.Main.Text.Text = entityLibrary.isAlive and string.format(nametagstrs[ent.Player], math.floor((entityLibrary.character.HumanoidRootPart.Position - ent.RootPart.Position).Magnitude)) or nametagstrs[ent.Player]
				else
					v.Main.Text.Text = nametagstrs[ent.Player]
				end
				v.Main.BG.Size = Vector2.new(v.Main.Text.TextBounds.X + 4, v.Main.Text.TextBounds.Y)
				v.Main.Text.Color = getPlayerColor(ent.Player) or Color3.fromHSV(NameTagsColor.Hue, NameTagsColor.Sat, NameTagsColor.Value)
			end
		end
	}

	local nametagcolorfuncs = {
		Normal = function(hue, sat, value)
			local color = Color3.fromHSV(hue, sat, value)
			for i,v in pairs(nametagsfolderdrawing) do 
				v.Main.TextColor3 = getPlayerColor(v.entity.Player) or color
			end
		end,
		Drawing = function(hue, sat, value)
			local color = Color3.fromHSV(hue, sat, value)
			for i,v in pairs(nametagsfolderdrawing) do 
				v.Main.Text.Color = getPlayerColor(v.entity.Player) or color
			end
		end
	}

	local nametagloop = {
		Normal = function()
			for i,v in pairs(nametagsfolderdrawing) do 
				local headPos, headVis = worldtoscreenpoint((v.entity.RootPart:GetRenderCFrame() * CFrame.new(0, v.entity.Head.Size.Y + v.entity.RootPart.Size.Y, 0)).Position)
				if not headVis then 
					v.Main.Visible = false
					continue
				end
				if NameTagsDistance.Enabled and entityLibrary.isAlive then
					local mag = math.floor((entityLibrary.character.HumanoidRootPart.Position - v.entity.RootPart.Position).Magnitude)
					local stringsize = tostring(mag):len()
					if nametagsizes[v.entity.Player] ~= stringsize then 
						local nametagSize = textService:GetTextSize(removeTags(string.format(nametagstrs[v.entity.Player], mag)), v.Main.TextSize, v.Main.Font, Vector2.new(100000, 100000))
						v.Main.Size = UDim2.new(0, nametagSize.X + 4, 0, nametagSize.Y)
					end
					nametagsizes[v.entity.Player] = stringsize
					v.Main.Text = string.format(nametagstrs[v.entity.Player], mag)
				end
				v.Main.Position = UDim2.new(0, headPos.X, 0, headPos.Y)
				v.Main.Visible = true
			end
		end,
		Drawing = function()
			for i,v in pairs(nametagsfolderdrawing) do 
				local headPos, headVis = worldtoscreenpoint((v.entity.RootPart:GetRenderCFrame() * CFrame.new(0, v.entity.Head.Size.Y + v.entity.RootPart.Size.Y, 0)).Position)
				if not headVis then 
					v.Main.Text.Visible = false
					v.Main.BG.Visible = false
					continue
				end
				if NameTagsDistance.Enabled and entityLibrary.isAlive then
					local mag = math.floor((entityLibrary.character.HumanoidRootPart.Position - v.entity.RootPart.Position).Magnitude)
					local stringsize = tostring(mag):len()
					v.Main.Text.Text = string.format(nametagstrs[v.entity.Player], mag)
					if nametagsizes[v.entity.Player] ~= stringsize then 
						v.Main.BG.Size = Vector2.new(v.Main.Text.TextBounds.X + 4, v.Main.Text.TextBounds.Y)
					end
					nametagsizes[v.entity.Player] = stringsize
				end
				v.Main.BG.Position = Vector2.new(headPos.X - (v.Main.BG.Size.X / 2), (headPos.Y + v.Main.BG.Size.Y))
				v.Main.Text.Position = v.Main.BG.Position + Vector2.new(2, 0)
				v.Main.Text.Visible = true
				v.Main.BG.Visible = NameTagsBackground.Enabled
			end
		end
	}

	local methodused

	local NameTags = {Enabled = false}
	NameTags = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "NameTags", 
		Function = function(callback) 
			if callback then
				methodused = NameTagsDrawing.Enabled and "Drawing" or "Normal"
				if nametagfuncs2[methodused] then
					table.insert(NameTags.Connections, entityLibrary.entityRemovedEvent:Connect(nametagfuncs2[methodused]))
				end
				if nametagfuncs1[methodused] then
					local addfunc = nametagfuncs1[methodused]
					for i,v in pairs(entityLibrary.entityList) do 
						if nametagsfolderdrawing[v.Player] then nametagfuncs2[methodused](v.Player) end
						addfunc(v)
					end
					table.insert(NameTags.Connections, entityLibrary.entityAddedEvent:Connect(function(ent)
						if nametagsfolderdrawing[ent.Player] then nametagfuncs2[methodused](ent.Player) end
						addfunc(ent)
					end))
				end
				if nametagupdatefuncs[methodused] then
					table.insert(NameTags.Connections, entityLibrary.entityUpdatedEvent:Connect(nametagupdatefuncs[methodused]))
					for i,v in pairs(entityLibrary.entityList) do 
						nametagupdatefuncs[methodused](v)
					end
				end
				if nametagcolorfuncs[methodused] then 
					table.insert(NameTags.Connections, GuiLibrary.ObjectsThatCanBeSaved.FriendsListTextCircleList.Api.FriendColorRefresh.Event:Connect(function()
						nametagcolorfuncs[methodused](NameTagsColor.Hue, NameTagsColor.Sat, NameTagsColor.Value)
					end))
				end
				if nametagloop[methodused] then 
					RunLoops:BindToRenderStep("NameTags", nametagloop[methodused])
				end
			else
				RunLoops:UnbindFromRenderStep("NameTags")
				if nametagfuncs2[methodused] then
					for i,v in pairs(nametagsfolderdrawing) do 
						nametagfuncs2[methodused](i)
					end
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
		Function = function() if NameTags.Enabled then NameTags.ToggleButton(false) NameTags.ToggleButton(false) end end,
	})
	NameTagsColor = NameTags.CreateColorSlider({
		Name = "Player Color", 
		Function = function(hue, sat, val) 
			if NameTags.Enabled and nametagcolorfuncs[methodused] then 
				nametagcolorfuncs[methodused](hue, sat, val)
			end
		end
	})
	NameTagsScale = NameTags.CreateSlider({
		Name = "Scale",
		Function = function() if NameTags.Enabled then NameTags.ToggleButton(false) NameTags.ToggleButton(false) end end,
		Default = 10,
		Min = 1,
		Max = 50
	})
	NameTagsBackground = NameTags.CreateToggle({
		Name = "Background", 
		Function = function() if NameTags.Enabled then NameTags.ToggleButton(false) NameTags.ToggleButton(false) end end,
		Default = true
	})
	NameTagsDisplayName = NameTags.CreateToggle({
		Name = "Use Display Name", 
		Function = function() if NameTags.Enabled then NameTags.ToggleButton(false) NameTags.ToggleButton(false) end end,
		Default = true
	})
	NameTagsHealth = NameTags.CreateToggle({
		Name = "Health", 
		Function = function() if NameTags.Enabled then NameTags.ToggleButton(false) NameTags.ToggleButton(false) end end
	})
	NameTagsDistance = NameTags.CreateToggle({
		Name = "Distance", 
		Function = function() if NameTags.Enabled then NameTags.ToggleButton(false) NameTags.ToggleButton(false) end end
	})
	NameTagsTeammates = NameTags.CreateToggle({
		Name = "Teammates", 
		Function = function() if NameTags.Enabled then NameTags.ToggleButton(false) NameTags.ToggleButton(false) end end,
		Default = true
	})
	NameTagsDrawing = NameTags.CreateToggle({
		Name = "Drawing",
		Function = function() if NameTags.Enabled then NameTags.ToggleButton(false) NameTags.ToggleButton(false) end end,
	})
end)

runFunction(function()
	local Search = {Enabled = false}
	local SearchTextList = {RefreshValues = function() end, ObjectList = {}}
	local SearchColor = {Value = 0.44}
	local SearchFolder = Instance.new("Folder")
	SearchFolder.Name = "SearchFolder"
	SearchFolder.Parent = GuiLibrary.MainGui
	local function searchFindBoxHandle(part)
		for i,v in pairs(SearchFolder:GetChildren()) do
			if v.Adornee == part then
				return v
			end
		end
		return nil
	end
	local searchRefresh = function()
		SearchFolder:ClearAllChildren()
		if Search.Enabled then
			for i,v in pairs(workspace:GetDescendants()) do
				if (v:IsA("BasePart") or v:IsA("Model")) and table.find(SearchTextList.ObjectList, v.Name) and searchFindBoxHandle(v) == nil then
					local highlight = Instance.new("Highlight")
					highlight.Name = v.Name
					highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
					highlight.FillColor = Color3.fromHSV(SearchColor.Hue, SearchColor.Sat, SearchColor.Value)
					highlight.Adornee = v
					highlight.Parent = SearchFolder
				end
			end
		end
	end
	Search = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "Search", 
		Function = function(callback) 
			if callback then
				searchRefresh()
				table.insert(Search.Connections, workspace.DescendantAdded:Connect(function(v)
					if (v:IsA("BasePart") or v:IsA("Model")) and table.find(SearchTextList.ObjectList, v.Name) and searchFindBoxHandle(v) == nil then
						local highlight = Instance.new("Highlight")
						highlight.Name = v.Name
						highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
						highlight.FillColor = Color3.fromHSV(SearchColor.Hue, SearchColor.Sat, SearchColor.Value)
						highlight.Adornee = v
						highlight.Parent = SearchFolder
					end
				end))
				table.insert(Search.Connections, workspace.DescendantRemoving:Connect(function(v)
					if v:IsA("BasePart") or v:IsA("Model") then
						local boxhandle = searchFindBoxHandle(v)
						if boxhandle then
							boxhandle:Remove()
						end
					end
				end))
			else
				SearchFolder:ClearAllChildren()
			end
		end,
		HoverText = "Draws a box around selected parts\nAdd parts in Search frame"
	})
	SearchColor = Search.CreateColorSlider({
		Name = "new part color", 
		Function = function(hue, sat, val)
			for i,v in pairs(SearchFolder:GetChildren()) do
				v.FillColor = Color3.fromHSV(hue, sat, val)
			end
		end
	})
	SearchTextList = Search.CreateTextList({
		Name = "SearchList",
		TempText = "part name", 
		AddFunction = function(user)
			searchRefresh()
		end, 
		RemoveFunction = function(num) 
			searchRefresh()
		end
	})
end)

runFunction(function()
	local Xray = {Enabled = false}
	Xray = GuiLibrary.ObjectsThatCanBeSaved.WorldWindow.Api.CreateOptionsButton({
		Name = "Xray", 
		Function = function(callback) 
			if callback then
				table.insert(Xray.Connections, workspace.DescendantAdded:Connect(function(v)
					if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") and not v.Parent.Parent:FindFirstChild("Humanoid") then
						v.LocalTransparencyModifier = 0.5
					end
				end))
				for i, v in pairs(workspace:GetDescendants()) do
					if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") and not v.Parent.Parent:FindFirstChild("Humanoid") then
						v.LocalTransparencyModifier = 0.5
					end
				end
			else
				for i, v in pairs(workspace:GetDescendants()) do
					if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") and not v.Parent.Parent:FindFirstChild("Humanoid") then
						v.LocalTransparencyModifier = 0
					end
				end
			end
		end
	})
end)

runFunction(function()
	local TracersColor = {Value = 0.44}
	local TracersTransparency = {Value = 1}
	local TracersStartPosition = {Value = "Middle"}
	local TracersEndPosition = {Value = "Head"}
	local TracersTeammates = {Enabled = true}
	local tracersfolderdrawing = {}
	local methodused

	local tracersfuncs1 = {
		Drawing = function(plr)
			if TracersTeammates.Enabled and (not plr.Targetable) and (not plr.Friend) then return end
			local newobj = Drawing.new("Line")
			newobj.Thickness = 1
			newobj.Transparency = 1 - (TracersTransparency.Value / 100)
			newobj.Color = getPlayerColor(plr.Player) or Color3.fromHSV(TracersColor.Hue, TracersColor.Sat, TracersColor.Value)
			tracersfolderdrawing[plr.Player] = {entity = plr, Main = newobj}
		end,
		DrawingV3 = function(plr)
			if TracersTeammates.Enabled and (not plr.Targetable) and (not plr.Friend) then return end
			local toppoint = PointInstance.new(plr[TracersEndPosition.Value == "Torso" and "RootPart" or "Head"])
			local bottompoint = TracersStartPosition.Value == "Mouse" and PointMouse.new() or Point2D.new(UDim2.new(0.5, 0, TracersStartPosition.Value == "Middle" and 0.5 or 1, 0))
			local newobj = LineDynamic.new(toppoint, bottompoint)
			newobj.Opacity = 1 - (TracersTransparency.Value / 100)
			newobj.Color = getPlayerColor(plr.Player) or Color3.fromHSV(TracersColor.Hue, TracersColor.Sat, TracersColor.Value)
			tracersfolderdrawing[plr.Player] = {entity = plr, Main = newobj}
		end,
	}
	local tracersfuncs2 = {
		Drawing = function(ent)
			local v = tracersfolderdrawing[ent]
			tracersfolderdrawing[ent] = nil
			if v then 
				pcall(function() v.Main.Visible = false v.Main:Remove() end)
			end
		end,
	}
	local tracerscolorfuncs = {
		Drawing = function(hue, sat, value)
			local color = Color3.fromHSV(hue, sat, value)
			for i,v in pairs(tracersfolderdrawing) do 
				v.Main.Color = getPlayerColor(v.entity.Player) or color
			end
		end
	}
	tracerscolorfuncs.DrawingV3 = tracerscolorfuncs.Drawing
	tracersfuncs2.DrawingV3 = tracersfuncs2.Drawing
	local tracersloop = {
		Drawing = function()
			for i,v in pairs(tracersfolderdrawing) do 
				local rootPart = v.entity[TracersEndPosition.Value == "Torso" and "RootPart" or "Head"].Position
				local rootPos, rootVis = worldtoviewportpoint(rootPart)
				local screensize = gameCamera.ViewportSize
				local startVector = TracersStartPosition.Value == "Mouse" and inputService:GetMouseLocation() or Vector2.new(screensize.X / 2, (TracersStartPosition.Value == "Middle" and screensize.Y / 2 or screensize.Y))
				local endVector = Vector2.new(rootPos.X, rootPos.Y)
				v.Main.Visible = rootVis
				v.Main.From = startVector
				v.Main.To = endVector
			end
		end,
	}

	local Tracers = {Enabled = false}
	Tracers = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "Tracers", 
		Function = function(callback) 
			if callback then
				methodused = "Drawing"..synapsev3
				if tracersfuncs2[methodused] then
					table.insert(Tracers.Connections, entityLibrary.entityRemovedEvent:Connect(tracersfuncs2[methodused]))
				end
				if tracersfuncs1[methodused] then
					local addfunc = tracersfuncs1[methodused]
					for i,v in pairs(entityLibrary.entityList) do 
						if tracersfolderdrawing[v.Player] then tracersfuncs2[methodused](v.Player) end
						addfunc(v)
					end
					table.insert(Tracers.Connections, entityLibrary.entityAddedEvent:Connect(function(ent)
						if tracersfolderdrawing[ent.Player] then tracersfuncs2[methodused](ent.Player) end
						addfunc(ent)
					end))
				end
				if tracerscolorfuncs[methodused] then 
					table.insert(Tracers.Connections, GuiLibrary.ObjectsThatCanBeSaved.FriendsListTextCircleList.Api.FriendColorRefresh.Event:Connect(function()
						tracerscolorfuncs[methodused](TracersColor.Hue, TracersColor.Sat, TracersColor.Value)
					end))
				end
				if tracersloop[methodused] then 
					RunLoops:BindToRenderStep("Tracers", tracersloop[methodused])
				end
			else
				RunLoops:UnbindFromRenderStep("Tracers")
				for i,v in pairs(tracersfolderdrawing) do 
					if tracersfuncs2[methodused] then
						tracersfuncs2[methodused](i)
					end
				end
			end
		end,
		HoverText = "Extra Sensory Perception\nRenders an Tracers on players."
	})
	TracersStartPosition = Tracers.CreateDropdown({
		Name = "Start Position",
		List = {"Middle", "Bottom", "Mouse"},
		Function = function() if Tracers.Enabled then Tracers.ToggleButton(true) Tracers.ToggleButton(true) end end
	})
	TracersEndPosition = Tracers.CreateDropdown({
		Name = "End Position",
		List = {"Head", "Torso"},
		Function = function() if Tracers.Enabled then Tracers.ToggleButton(true) Tracers.ToggleButton(true) end end
	})
	TracersColor = Tracers.CreateColorSlider({
		Name = "Player Color", 
		Function = function(hue, sat, val) 
			if Tracers.Enabled and tracerscolorfuncs[methodused] then 
				tracerscolorfuncs[methodused](hue, sat, val)
			end
		end
	})
	TracersTransparency = Tracers.CreateSlider({
		Name = "Transparency", 
		Min = 1,
		Max = 100, 
		Function = function(val) 
			for i,v in pairs(tracersfolderdrawing) do 
				if v.Main then 
					v.Main[methodused == "DrawingV3" and "Opacity" or "Transparency"] = 1 - (val / 100)
				end
			end
		end,
		Default = 0
	})
	TracersTeammates = Tracers.CreateToggle({
		Name = "Priority Only",
		Function = function() if Tracers.Enabled then Tracers.ToggleButton(true) Tracers.ToggleButton(true) end end,
		Default = true
	})
end)

runFunction(function()
	Spring = {} do
		Spring.__index = Spring

		function Spring.new(freq, pos)
			local self = setmetatable({}, Spring)
			self.f = freq
			self.p = pos
			self.v = pos*0
			return self
		end

		function Spring:Update(dt, goal)
			local f = self.f*2*math.pi
			local p0 = self.p
			local v0 = self.v

			local offset = goal - p0
			local decay = math.exp(-f*dt)

			local p1 = goal + (v0*dt - offset*(f*dt + 1))*decay
			local v1 = (f*dt*(offset*f - v0) + v0)*decay

			self.p = p1
			self.v = v1

			return p1
		end

		function Spring:Reset(pos)
			self.p = pos
			self.v = pos*0
		end
	end

	local cameraPos = Vector3.zero
	local cameraRot = Vector2.new()
	local velSpring = Spring.new(5, Vector3.zero)
	local panSpring = Spring.new(5, Vector2.new())

	Input = {} do

		keyboard = {
			W = 0,
			A = 0,
			S = 0,
			D = 0,
			E = 0,
			Q = 0,
			Up = 0,
			Down = 0,
			LeftShift = 0,
		}

		mouse = {
			Delta = Vector2.new(),
		}

		NAV_KEYBOARD_SPEED = Vector3.new(1, 1, 1)
		PAN_MOUSE_SPEED = Vector2.new(3, 3)*(math.pi/64)
		NAV_ADJ_SPEED = 0.75
		NAV_SHIFT_MUL = 0.25

		navSpeed = 1

		function Input.Vel(dt)
			navSpeed = math.clamp(navSpeed + dt*(keyboard.Up - keyboard.Down)*NAV_ADJ_SPEED, 0.01, 4)

			local kKeyboard = Vector3.new(
				keyboard.D - keyboard.A,
				keyboard.E - keyboard.Q,
				keyboard.S - keyboard.W
			)*NAV_KEYBOARD_SPEED

			local shift = inputService:IsKeyDown(Enum.KeyCode.LeftShift)

			return (kKeyboard)*(navSpeed*(shift and NAV_SHIFT_MUL or 1))
		end

		function Input.Pan(dt)
			local kMouse = mouse.Delta*PAN_MOUSE_SPEED
			mouse.Delta = Vector2.new()
			return kMouse
		end

		do
			function Keypress(action, state, input)
				keyboard[input.KeyCode.Name] = state == Enum.UserInputState.Begin and 1 or 0
				return Enum.ContextActionResult.Sink
			end

			function MousePan(action, state, input)
				local delta = input.Delta
				mouse.Delta = Vector2.new(-delta.y, -delta.x)
				return Enum.ContextActionResult.Sink
			end

			function Zero(t)
				for k, v in pairs(t) do
					t[k] = v*0
				end
			end

			function Input.StartCapture()
				game:GetService("ContextActionService"):BindActionAtPriority("FreecamKeyboard",Keypress,false,Enum.ContextActionPriority.High.Value,
				Enum.KeyCode.W,
				Enum.KeyCode.A,
				Enum.KeyCode.S,
				Enum.KeyCode.D,
				Enum.KeyCode.E,
				Enum.KeyCode.Q,
				Enum.KeyCode.Up,
				Enum.KeyCode.Down
				)
				game:GetService("ContextActionService"):BindActionAtPriority("FreecamMousePan",MousePan,false,Enum.ContextActionPriority.High.Value,Enum.UserInputType.MouseMovement)
			end

			function Input.StopCapture()
				navSpeed = 1
				Zero(keyboard)
				Zero(mouse)
				game:GetService("ContextActionService"):UnbindAction("FreecamKeyboard")
				game:GetService("ContextActionService"):UnbindAction("FreecamMousePan")
			end
		end
	end

	local function GetFocusDistance(cameraFrame)
		local znear = 0.1
		local viewport = gameCamera.ViewportSize
		local projy = 2*math.tan(cameraFov/2)
		local projx = viewport.x/viewport.y*projy
		local fx = cameraFrame.rightVector
		local fy = cameraFrame.upVector
		local fz = cameraFrame.lookVector

		local minVect = Vector3.zero
		local minDist = 512

		for x = 0, 1, 0.5 do
			for y = 0, 1, 0.5 do
				local cx = (x - 0.5)*projx
				local cy = (y - 0.5)*projy
				local offset = fx*cx - fy*cy + fz
				local origin = cameraFrame.p + offset*znear
				local _, hit = workspace:FindPartOnRay(Ray.new(origin, offset.unit*minDist))
				local dist = (hit - origin).magnitude
				if minDist > dist then
					minDist = dist
					minVect = offset.unit
				end
			end
		end

		return fz:Dot(minVect)*minDist
	end

	local playerstate = {} do
		mouseBehavior = ""
		mouseIconEnabled = ""
		cameraType = ""
		cameraFocus = ""
		cameraCFrame = ""
		cameraFieldOfView = ""

		function playerstate.Push()
			cameraFieldOfView = gameCamera.FieldOfView
			gameCamera.FieldOfView = 70

			cameraType = gameCamera.CameraType
			gameCamera.CameraType = Enum.CameraType.Custom

			cameraCFrame = gameCamera.CFrame
			cameraFocus = gameCamera.Focus

			mouseBehavior = inputService.MouseBehavior
			inputService.MouseBehavior = Enum.MouseBehavior.Default

			mouseIconEnabled = inputService.MouseIconEnabled
			inputService.MouseIconEnabled = true
		end

		function playerstate.Pop()
			gameCamera.FieldOfView = cameraFieldOfView
			cameraFieldOfView = nil

			gameCamera.CameraType = cameraType
			cameraType = nil

			gameCamera.CFrame = cameraCFrame
			cameraCFrame = nil

			gameCamera.Focus = cameraFocus
			cameraFocus = nil

			inputService.MouseIconEnabled = mouseIconEnabled
			mouseIconEnabled = nil

			inputService.MouseBehavior = mouseBehavior
			mouseBehavior = nil
		end
	end

	local Freecam = GuiLibrary.ObjectsThatCanBeSaved.WorldWindow.Api.CreateOptionsButton({
		Name = "Freecam", 
		Function = function(callback)
			if callback then
				local cameraCFrame = gameCamera.CFrame
				local pitch, yaw, roll = cameraCFrame:ToEulerAnglesYXZ()
				cameraRot = Vector2.new(pitch, yaw)
				cameraPos = cameraCFrame.p
				cameraFov = gameCamera.FieldOfView

				velSpring:Reset(Vector3.zero)
				panSpring:Reset(Vector2.new())

				playerstate.Push()
				RunLoops:BindToRenderStep("Freecam", function(dt)
					local vel = velSpring:Update(dt, Input.Vel(dt))
					local pan = panSpring:Update(dt, Input.Pan(dt))

					local zoomFactor = math.sqrt(math.tan(math.rad(70/2))/math.tan(math.rad(cameraFov/2)))

					cameraRot = cameraRot + pan*Vector2.new(0.75, 1)*8*(dt/zoomFactor)
					cameraRot = Vector2.new(math.clamp(cameraRot.x, -math.rad(90), math.rad(90)), cameraRot.y%(2*math.pi))

					local cameraCFrame = CFrame.new(cameraPos)*CFrame.fromOrientation(cameraRot.x, cameraRot.y, 0)*CFrame.new(vel*Vector3.new(1, 1, 1)*64*dt)
					cameraPos = cameraCFrame.p

					gameCamera.CFrame = cameraCFrame
					gameCamera.Focus = cameraCFrame*CFrame.new(0, 0, -GetFocusDistance(cameraCFrame))
					gameCamera.FieldOfView = cameraFov
				end)
				Input.StartCapture()
			else
				Input.StopCapture()
				RunLoops:UnbindFromRenderStep("Freecam")
				playerstate.Pop()
			end
		end,
		HoverText = "Lets you fly and clip through walls freely\nwithout moving your player server-sided."
	})
	Freecam.CreateSlider({
		Name = "Speed",
		Min = 1,
		Max = 150,
		Function = function(val) NAV_KEYBOARD_SPEED = Vector3.new(val / 75,  val / 75, val / 75) end,
		Default = 75
	})
end)

runFunction(function()
	local Panic = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "Panic", 
		Function = function(callback)
			if callback then
				for i,v in pairs(GuiLibrary.ObjectsThatCanBeSaved) do
					if v.Type == "OptionsButton" then
						if v.Api.Enabled then
							v.Api.ToggleButton()
						end
					end
				end
			end
		end
	}) 
end)

runFunction(function()
	local ChatSpammer = {Enabled = false}
	local ChatSpammerDelay = {Value = 10}
	local ChatSpammerHideWait = {Enabled = true}
	local ChatSpammerMessages = {ObjectList = {}}
	local chatspammerfirstexecute = true
	local chatspammerhook = false
	local oldchanneltab
	local oldchannelfunc
	local oldchanneltabs = {}
	local waitnum = 0
	ChatSpammer = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "ChatSpammer",
		Function = function(callback)
			if callback then
				if textChatService.ChatVersion == Enum.ChatVersion.TextChatService then 
					task.spawn(function()
						repeat
							if ChatSpammer.Enabled then
								pcall(function()
									textChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync((#ChatSpammerMessages.ObjectList > 0 and ChatSpammerMessages.ObjectList[math.random(1, #ChatSpammerMessages.ObjectList)] or "vxpe on top"))
								end)
							end
							if waitnum ~= 0 then
								task.wait(waitnum)
								waitnum = 0
							else
								task.wait(ChatSpammerDelay.Value / 10)
							end
						until not ChatSpammer.Enabled
					end)
				else
					task.spawn(function()
						if chatspammerfirstexecute then
							lplr.PlayerGui:WaitForChild("Chat", 10)
							chatspammerfirstexecute = false
						end
						if lplr.PlayerGui:FindFirstChild("Chat") and lplr.PlayerGui.Chat:FindFirstChild("Frame") and lplr.PlayerGui.Chat.Frame:FindFirstChild("ChatChannelParentFrame") and replicatedStorageService:FindFirstChild("DefaultChatSystemChatEvents") then
							if not chatspammerhook then
								task.spawn(function()
									chatspammerhook = true
									for i,v in pairs(getconnections(replicatedStorageService.DefaultChatSystemChatEvents.OnNewMessage.OnClientEvent)) do
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
														if MessageData.MessageType == "System" then
															if MessageData.Message:find("You must wait") and ChatSpammer.Enabled then
																return nil
															end
														end
														return addmessage(Self2, MessageData)
													end
												end
												return tab
											end
										end
									end
								end)
							end
							task.spawn(function()
								repeat
									pcall(function()
										replicatedStorageService.DefaultChatSystemChatEvents.SayMessageRequest:FireServer((#ChatSpammerMessages.ObjectList > 0 and ChatSpammerMessages.ObjectList[math.random(1, #ChatSpammerMessages.ObjectList)] or "vxpe on top"), "All")
									end)
									if waitnum ~= 0 then
										task.wait(waitnum)
										waitnum = 0
									else
										task.wait(ChatSpammerDelay.Value / 10)
									end
								until not ChatSpammer.Enabled
							end)				
						else
							warningNotification("ChatSpammer", "Default chat not found.", 3)
							if ChatSpammer.Enabled then ChatSpammer.ToggleButton(false) end
						end
					end)
				end
			else
				waitnum = 0
			end
		end,
		HoverText = "Spams chat with text of your choice (Default Chat Only)"
	})
	ChatSpammerDelay = ChatSpammer.CreateSlider({
		Name = "Delay",
		Min = 1,
		Max = 50,
		Default = 10,
		Function = function() end
	})
	ChatSpammerHideWait = ChatSpammer.CreateToggle({
		Name = "Hide Wait Message",
		Function = function() end,
		Default = true
	})
	ChatSpammerMessages = ChatSpammer.CreateTextList({
		Name = "Message",
		TempText = "message to spam",
		Function = function() end
	})
end)

runFunction(function()
	local controlmodule
	local oldmove
	local SafeWalk = {Enabled = false}
	local SafeWalkRaycast = RaycastParams.new()
	SafeWalkRaycast.RespectCanCollide = true
	SafeWalkRaycast.FilterType = Enum.RaycastFilterType.Blacklist
	SafeWalk = GuiLibrary.ObjectsThatCanBeSaved.WorldWindow.Api.CreateOptionsButton({
		Name = "SafeWalk",
		Function = function(callback)
			if callback then
				if not controlmodule then
					local suc = pcall(function() controlmodule = require(lplr.PlayerScripts.PlayerModule).controls end)
					if not suc then controlmodule = {} end
				end
				oldmove = controlmodule.moveFunction
				controlmodule.moveFunction = function(Self, vec, facecam)
					if entityLibrary.isAlive then
						SafeWalkRaycast.FilterDescendantsInstances = {lplr.Character}
						local ray = workspace:Raycast(entityLibrary.character.HumanoidRootPart.Position + (vec * 0.5), Vector3.new(0, -1000, 0), SafeWalkRaycast)
						if not ray then
							if workspace:Raycast(entityLibrary.character.HumanoidRootPart.Position, Vector3.new(0, -((entityLibrary.character.Humanoid.HipHeight + (entityLibrary.character.HumanoidRootPart.Size.Y / 2)) + 1), 0), SafeWalkRaycast) then
								vec = Vector3.zero
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
end)

runFunction(function()
	local function capeFunction(char, texture)
		for i,v in pairs(char:GetDescendants()) do
			if v.Name == "Cape" then
				v:Destroy()
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
		p.Size = Vector3.new(0.2,0.2,0.08)
		p.Transparency = 1
		local decal
		local video = false
		if texture:find(".webm") then 
			video = true
			local decal2 = Instance.new("SurfaceGui", p)
			decal2.Adornee = p
			decal2.CanvasSize = Vector2.new(1, 1)
			decal2.Face = "Back"
			decal = Instance.new("VideoFrame", decal2)
			decal.Size = UDim2.new(0, 9, 0, 17)
			decal.BackgroundTransparency = 1
			decal.Position = UDim2.new(0, -4, 0, -8)
			decal.Video = texture
			decal.Looped = true
			decal:Play()
		else
			decal = Instance.new("Decal", p)
			decal.Texture = texture
			decal.Face = "Back"
		end
		local msh = Instance.new("BlockMesh", p)
		msh.Scale = Vector3.new(9, 17.5, 0.5)
		local motor = Instance.new("Motor", p)
		motor.Part0 = p
		motor.Part1 = torso
		motor.MaxVelocity = 0.01
		motor.C0 = CFrame.new(0, 2, 0) * CFrame.Angles(0, math.rad(90), 0)
		motor.C1 = CFrame.new(0, 1, 0.45) * CFrame.Angles(0, math.rad(90), 0)
		local wave = false
		repeat task.wait(1/44)
			if video then 
				decal.Visible = torso.LocalTransparencyModifier ~= 1
			else
				decal.Transparency = torso.Transparency
			end
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
			repeat task.wait() until motor.CurrentAngle == motor.DesiredAngle or math.abs(torso.Velocity.magnitude - oldmag) >= (torso.Velocity.magnitude/10) + 1
			if torso.Velocity.magnitude < 0.1 then
				task.wait(0.1)
			end
		until not p or p.Parent ~= torso.Parent
	end

	local Cape = {Enabled = false}
	local CapeBox = {Value = ""}
	Cape = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "Cape",
		Function = function(callback)
			if callback then
				local successfulcustom = false
				if CapeBox.Value ~= "" then
					successfulcustom = true
					if (not isfile(CapeBox.Value)) then 
						warningNotification("Cape", "Missing file", 5)
						successfulcustom = false
					end
				end
				table.insert(Cape.Connections, lplr.CharacterAdded:Connect(function(char)
					task.spawn(function()
						pcall(function() 
							capeFunction(char, (successfulcustom and getcustomasset(CapeBox.Value) or downloadVapeAsset("vape/assets/VapeCape.png")))
						end)
					end)
				end))
				if lplr.Character then
					task.spawn(function()
						pcall(function() 
							capeFunction(lplr.Character, (successfulcustom and getcustomasset(CapeBox.Value) or downloadVapeAsset("vape/assets/VapeCape.png")))
						end)
					end)
				end
			else
				if lplr.Character then
					for i,v in pairs(lplr.Character:GetDescendants()) do
						if v.Name == "Cape" then
							v:Destroy()
						end
					end
				end
			end
		end
	})
	CapeBox = Cape.CreateTextBox({
		Name = "File",
		TempText = "File (link)",
		FocusLost = function(enter) 
			if enter then 
				if Cape.Enabled then 
					Cape.ToggleButton(false)
					Cape.ToggleButton(false)
				end
			end
		end
	})
end)

runFunction(function()
	local ChinaHat = {Enabled = false}
	local ChinaHatColor = {Hue = 1, Sat=1, Value=0.33}
	local chinahattrail
	local chinahatattachment
	local chinahatattachment2
	ChinaHat = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "ChinaHat",
		Function = function(callback)
			if callback then
				RunLoops:BindToHeartbeat("ChinaHat", function()
					if entityLibrary.isAlive then
						if chinahattrail == nil or chinahattrail.Parent == nil then
							chinahattrail = Instance.new("Part")
							chinahattrail.CFrame = entityLibrary.character.Head.CFrame * CFrame.new(0, 1.1, 0)
							chinahattrail.Size = Vector3.new(3, 0.7, 3)
							chinahattrail.Name = "ChinaHat"
							chinahattrail.Material = Enum.Material.Neon
							chinahattrail.Color = Color3.fromHSV(ChinaHatColor.Hue, ChinaHatColor.Sat, ChinaHatColor.Value)
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
						chinahattrail.LocalTransparencyModifier = ((gameCamera.CFrame.Position - gameCamera.Focus.Position).Magnitude <= 0.6 and 1 or 0)
					else
						if chinahattrail then 
							chinahattrail:Destroy()
							chinahattrail = nil
						end
					end
				end)
			else
				RunLoops:UnbindFromHeartbeat("ChinaHat")
				if chinahattrail then
					chinahattrail:Destroy()
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

runFunction(function()
	local FieldOfView = {Enabled = false}
	local FieldOfViewZoom = {Enabled = false}
	local FieldOfViewValue = {Value = 70}
	local oldfov
	FieldOfView = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "FOVChanger",
		Function = function(callback)
			if callback then
				oldfov = gameCamera.FieldOfView
				if FieldOfViewZoom.Enabled then
					task.spawn(function()
						repeat
							task.wait()
						until inputService:IsKeyDown(Enum.KeyCode[FieldOfView.Keybind ~= "" and FieldOfView.Keybind or "C"]) == false
						if FieldOfView.Enabled then
							FieldOfView.ToggleButton(false)
						end
					end)
				end
				task.spawn(function()
					repeat
						gameCamera.FieldOfView = FieldOfViewValue.Value
						task.wait()
					until (not FieldOfView.Enabled)
				end)
			else
				gameCamera.FieldOfView = oldfov
			end
		end
	})
	FieldOfViewValue = FieldOfView.CreateSlider({
		Name = "FOV",
		Min = 30,
		Max = 120,
		Function = function(val) end
	})
	FieldOfViewZoom = FieldOfView.CreateToggle({
		Name = "Zoom",
		Function = function() end,
		HoverText = "optifine zoom lol"
	})
end)

runFunction(function()
	local Swim = {Enabled = false}
	local SwimVertical = {Value = 1}
	local swimconnection
	local oldgravity

	Swim = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "Swim",
		Function = function(callback)
			if callback then
				oldgravity = workspace.Gravity
				if entityLibrary.isAlive then
					GravityChangeTick = tick() + 0.1
					workspace.Gravity = 0
					local enums = Enum.HumanoidStateType:GetEnumItems()
					table.remove(enums, table.find(enums, Enum.HumanoidStateType.None))
					for i,v in pairs(enums) do
						entityLibrary.character.Humanoid:SetStateEnabled(v, false)
					end
					entityLibrary.character.Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
					RunLoops:BindToHeartbeat("Swim", function()
						local rootvelo = entityLibrary.character.HumanoidRootPart.Velocity
						local moving = entityLibrary.character.Humanoid.MoveDirection ~= Vector3.zero
						entityLibrary.character.HumanoidRootPart.Velocity = ((moving or inputService:IsKeyDown(Enum.KeyCode.Space)) and Vector3.new(moving and rootvelo.X or 0, inputService:IsKeyDown(Enum.KeyCode.Space) and SwimVertical.Value or rootvelo.Y, moving and rootvelo.Z or 0) or Vector3.zero)
					end)
				end
			else 
				GravityChangeTick = tick() + 0.1
				workspace.Gravity = oldgravity
				RunLoops:UnbindFromHeartbeat("Swim")
				if entityLibrary.isAlive then
					local enums = Enum.HumanoidStateType:GetEnumItems()
					table.remove(enums, table.find(enums, Enum.HumanoidStateType.None))
					for i,v in pairs(enums) do
						entityLibrary.character.Humanoid:SetStateEnabled(v, true)
					end
				end
			end
		end
	})
	SwimVertical = Swim.CreateSlider({
		Name = "Y Speed",
		Min = 1,
		Max = 50,
		Default = 50,
		Function = function() end
	})
end)


runFunction(function()
	local Breadcrumbs = {Enabled = false}
	local BreadcrumbsLifetime = {Value = 20}
	local BreadcrumbsThickness = {Value = 7}
	local BreadcrumbsFadeIn = {Value = 0.44}
	local BreadcrumbsFadeOut = {Value = 0.44}
	local breadcrumbtrail
	local breadcrumbattachment
	local breadcrumbattachment2
	Breadcrumbs = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "Breadcrumbs",
		Function = function(callback)
			if callback then
				task.spawn(function()
					repeat
						if entityLibrary.isAlive then
							if not breadcrumbtrail then
								breadcrumbattachment = Instance.new("Attachment")
								breadcrumbattachment.Position = Vector3.new(0, 0.07 - 2.7, 0)
								breadcrumbattachment2 = Instance.new("Attachment")
								breadcrumbattachment2.Position = Vector3.new(0, -0.07 - 2.7, 0)
								breadcrumbtrail = Instance.new("Trail")
								breadcrumbtrail.Attachment0 = breadcrumbattachment 
								breadcrumbtrail.Attachment1 = breadcrumbattachment2
								breadcrumbtrail.Color = ColorSequence.new(Color3.fromHSV(BreadcrumbsFadeIn.Hue, BreadcrumbsFadeIn.Sat, BreadcrumbsFadeIn.Value), Color3.fromHSV(BreadcrumbsFadeOut.Hue, BreadcrumbsFadeOut.Sat, BreadcrumbsFadeOut.Value))
								breadcrumbtrail.FaceCamera = true
								breadcrumbtrail.Lifetime = BreadcrumbsLifetime.Value / 10
								breadcrumbtrail.Enabled = true
							else
								local suc = pcall(function()
									breadcrumbattachment.Parent = entityLibrary.character.HumanoidRootPart
									breadcrumbattachment2.Parent = entityLibrary.character.HumanoidRootPart
									breadcrumbtrail.Parent = gameCamera
								end)
								if not suc then 
									if breadcrumbtrail then breadcrumbtrail:Destroy() breadcrumbtrail = nil end
									if breadcrumbattachment then breadcrumbattachment:Destroy() breadcrumbattachment = nil end
									if breadcrumbattachment2 then breadcrumbattachment2:Destroy() breadcrumbattachment2 = nil end
								end
							end
						end
						task.wait(0.3)
					until not Breadcrumbs.Enabled
				end)
			else
				if breadcrumbtrail then breadcrumbtrail:Destroy() breadcrumbtrail = nil end
				if breadcrumbattachment then breadcrumbattachment:Destroy() breadcrumbattachment = nil end
				if breadcrumbattachment2 then breadcrumbattachment2:Destroy() breadcrumbattachment2 = nil end
			end
		end,
		HoverText = "Shows a trail behind your character"
	})
	BreadcrumbsFadeIn = Breadcrumbs.CreateColorSlider({
		Name = "Fade In",
		Function = function(hue, sat, val)
			if breadcrumbtrail then 
				breadcrumbtrail.Color = ColorSequence.new(Color3.fromHSV(hue, sat, val), Color3.fromHSV(BreadcrumbsFadeOut.Hue, BreadcrumbsFadeOut.Sat, BreadcrumbsFadeOut.Value))
			end
		end
	})
	BreadcrumbsFadeOut = Breadcrumbs.CreateColorSlider({
		Name = "Fade Out",
		Function = function(hue, sat, val)
			if breadcrumbtrail then 
				breadcrumbtrail.Color = ColorSequence.new(Color3.fromHSV(BreadcrumbsFadeIn.Hue, BreadcrumbsFadeIn.Sat, BreadcrumbsFadeIn.Value), Color3.fromHSV(hue, sat, val))
			end
		end
	})
	BreadcrumbsLifetime = Breadcrumbs.CreateSlider({
		Name = "Lifetime",
		Min = 1,
		Max = 100,
		Function = function(val) 
			if breadcrumbtrail then 
				breadcrumbtrail.Lifetime = val / 10
			end
		end,
		Default = 20,
		Double = 10
	})
	BreadcrumbsThickness = Breadcrumbs.CreateSlider({
		Name = "Thickness",
		Min = 1,
		Max = 30,
		Function = function(val) 
			if breadcrumbattachment then 
				breadcrumbattachment.Position = Vector3.new(0, (val / 100) - 2.7, 0)
			end
			if breadcrumbattachment2 then 
				breadcrumbattachment2.Position = Vector3.new(0, -(val / 100) - 2.7, 0)
			end
		end,
		Default = 7,
		Double = 10
	})
end)

runFunction(function()
	local AutoReport = {Enabled = false}
	local AutoReportList = {ObjectList = {}}
	local AutoReportNotify = {Enabled = false}
	local alreadyreported = {}

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

	local reporttable = {
		gay = "Bullying",
		gae = "Bullying",
		gey = "Bullying",
		hack = "Scamming",
		exploit = "Scamming",
		cheat = "Scamming",
		hecker = "Scamming",
		haxker = "Scamming",
		hacer = "Scamming",
		report = "Bullying",
		fat = "Bullying",
		black = "Bullying",
		getalife = "Bullying",
		fatherless = "Bullying",
		report = "Bullying",
		fatherless = "Bullying",
		disco = "Offsite Links",
		yt = "Offsite Links",
		dizcourde = "Offsite Links",
		retard = "Swearing",
		bad = "Bullying",
		trash = "Bullying",
		nolife = "Bullying",
		nolife = "Bullying",
		loser = "Bullying",
		killyour = "Bullying",
		kys = "Bullying",
		hacktowin = "Bullying",
		bozo = "Bullying",
		kid = "Bullying",
		adopted = "Bullying",
		linlife = "Bullying",
		commitnotalive = "Bullying",
		vape = "Offsite Links",
		futureclient = "Offsite Links",
		download = "Offsite Links",
		youtube = "Offsite Links",
		die = "Bullying",
		lobby = "Bullying",
		ban = "Bullying",
		wizard = "Bullying",
		wisard = "Bullying",
		witch = "Bullying",
		magic = "Bullying",
	}
	local reporttableexact = {
		L = "Bullying",
	}
	

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
		for i,v in pairs(AutoReportList.ObjectList) do 
			if checkstr:find(v) then 
				return "Bullying", v
			end
		end
		return nil
	end

	AutoReport = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "AutoReport",
		Function = function(callback) 
			if callback then 
				if textChatService.ChatVersion == Enum.ChatVersion.TextChatService then 
					table.insert(AutoReport.Connections, textChatService.MessageReceived:Connect(function(tab)
						local plr = tab.TextSource
						local args = tab.Text:split(" ")
						if plr and plr ~= lplr and WhitelistFunctions:CheckPlayerType(plr) == "DEFAULT" then
							local reportreason, reportedmatch = findreport(tab.Text)
							if reportreason then 
								if alreadyreported[plr] then return end
								task.spawn(function()
									if syn == nil or reportplayer then
										if reportplayer then
											reportplayer(plr, reportreason, "he said a bad word")
										else
											playersService:ReportAbuse(plr, reportreason, "he said a bad word")
										end
									end
								end)
								if AutoReportNotify.Enabled then 
									warningNotification("AutoReport", "Reported "..plr.Name.." for "..reportreason..' ('..reportedmatch..')', 15)
								end
								alreadyreported[plr] = true
							end
						end
					end))
				else 
					if replicatedStorageService:FindFirstChild("DefaultChatSystemChatEvents") then
						table.insert(AutoReport.Connections, replicatedStorageService.DefaultChatSystemChatEvents.OnMessageDoneFiltering.OnClientEvent:Connect(function(tab, channel)
							local plr = playersService:FindFirstChild(tab.FromSpeaker)
							local args = tab.Message:split(" ")
							if plr and plr ~= lplr and WhitelistFunctions:CheckPlayerType(plr) == "DEFAULT" then
								local reportreason, reportedmatch = findreport(tab.Message)
								if reportreason then 
									if alreadyreported[plr] then return end
									task.spawn(function()
										if syn == nil or reportplayer then
											if reportplayer then
												reportplayer(plr, reportreason, "he said a bad word")
											else
												playersService:ReportAbuse(plr, reportreason, "he said a bad word")
											end
										end
									end)
									if AutoReportNotify.Enabled then 
										warningNotification("AutoReport", "Reported "..plr.Name.." for "..reportreason..' ('..reportedmatch..')', 15)
									end
									alreadyreported[plr] = true
								end
							end
						end))
					else
						warningNotification("AutoReport", "Default chat not found.", 5)
						AutoReport.ToggleButton(false)
					end
				end
			end
		end
	})
	AutoReportNotify = AutoReport.CreateToggle({
		Name = "Notify",
		Function = function() end
	})
	AutoReportList = AutoReport.CreateTextList({
		Name = "Report Words",
		TempText = "phrase (to report)"
	})
end)

runFunction(function()
	local targetstrafe = {Enabled = false}
	local targetstraferange = {Value = 0}
	local oldmove
	local controlmodule
	targetstrafe = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "TargetStrafe",
		Function = function(callback)
			if callback then
				if not controlmodule then
					local suc = pcall(function() controlmodule = require(lplr.PlayerScripts.PlayerModule).controls end)
					if not suc then controlmodule = {} end
				end
				oldmove = controlmodule.moveFunction
				controlmodule.moveFunction = function(Self, vec, facecam, ...)
					if entityLibrary.isAlive then
						local plr = EntityNearPosition(targetstraferange.Value, {
							WallCheck = false,
							AimPart = "RootPart"
						})
						if plr then 
							facecam = false
							--code stolen from roblox since the way I tried to make it apparently sucks
							local c, s
							local plrCFrame = CFrame.lookAt(entityLibrary.character.HumanoidRootPart.Position, Vector3.new(plr.RootPart.Position.X, 0, plr.RootPart.Position.Z))
							local _, _, _, R00, R01, R02, _, _, R12, _, _, R22 = plrCFrame:GetComponents()
							if R12 < 1 and R12 > -1 then
								c = R22
								s = R02
							else
								c = R00
								s = -R01*math.sign(R12)
							end
							local norm = math.sqrt(c*c + s*s)
							local cameraRelativeMoveVector = controlmodule:GetMoveVector()
							vec = Vector3.new(
								(c*cameraRelativeMoveVector.X + s*cameraRelativeMoveVector.Z)/norm,
								0,
								(c*cameraRelativeMoveVector.Z - s*cameraRelativeMoveVector.X)/norm
							)
						end
					end
					return oldmove(Self, vec, facecam, ...)
				end
			else
				controlmodule.moveFunction = oldmove
			end
		end
	})
	targetstraferange = targetstrafe.CreateSlider({
		Name = "Range",
		Function = function() end,
		Min = 0,
		Max = 100,
		Default = 14
	})
end)

runFunction(function()
	local AutoLeave = {Enabled = false}
	local AutoLeaveMode = {Value = "UnInject"}
	local AutoLeaveGroupId = {Value = "0"}
	local AutoLeaveRank = {Value = "1"}
	local getrandomserver
	local alreadyjoining = false
	getrandomserver = function(pointer)
		alreadyjoining = true
		local decodeddata = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Desc&limit=100"..(pointer and "&cursor="..pointer or "")))
		local chosenServer
		for i, v in pairs(decodeddata.data) do
			if (tonumber(v.playing) < tonumber(playersService.MaxPlayers)) and tonumber(v.ping) < 300 and v.id ~= game.JobId then 
				chosenServer = v.id
				break
			end
		end
		if chosenServer then 
			alreadyjoining = false
			game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, chosenServer, lplr)
		else
			if decodeddata.nextPageCursor then
				getrandomserver(decodeddata.nextPageCursor)
			else
				alreadyjoining = false
			end
		end
	end

	local function getRole(plr, id)
		local suc, res = pcall(function() return plr:GetRankInGroup(id) end)
		if not suc then 
			repeat
				suc, res = pcall(function() return plr:GetRankInGroup(id) end)
				task.wait()
			until suc
		end
		return res
	end

	local function autoleaveplradded(plr)
		task.spawn(function()
			pcall(function()
				if AutoLeaveGroupId.Value == "" or AutoLeaveRank.Value == "" then return end
				if getRole(plr, tonumber(AutoLeaveGroupId.Value) or 0) >= (tonumber(AutoLeaveRank.Value) or 1) then
					WhitelistFunctions.CustomTags[plr] = "[GAME STAFF] "
					local _, ent = entityLibrary.getEntityFromPlayer(plr)
					if ent then 
						entityLibrary.entityUpdatedEvent:Fire(ent)
					end
					if AutoLeaveMode.Value == "UnInject" then 
						task.spawn(function()
							if not shared.VapeFullyLoaded then
								repeat task.wait() until shared.VapeFullyLoaded
							end
							GuiLibrary.SelfDestruct()
						end)
						game:GetService("StarterGui"):SetCore("SendNotification", {
							Title = "AutoLeave",
							Text = "Staff Detected\n"..(plr.DisplayName and plr.DisplayName.." ("..plr.Name..")" or plr.Name),
							Duration = 60,
						})
					elseif AutoLeaveMode.Value == "Rejoin" then 
						getrandomserver()
					else
						createwarning("AutoLeave", "Staff Detected : "..(plr.DisplayName and plr.DisplayName.." ("..plr.Name..")" or plr.Name), 60)
					end
				end
			end)
		end)
	end

	local function autodetect(roles)
		local highest = 9e9
		for i,v in pairs(roles) do 
			local low = v.Name:lower()
			if (low:find("admin") or low:find("mod") or low:find("dev")) and v.Rank < highest then 
				highest = v.Rank
			end
		end
		return highest
	end

	AutoLeave = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "AutoLeave",
		Function = function(callback)
			if callback then 
				if AutoLeaveGroupId.Value == "" or AutoLeaveRank.Value == "" then 
					task.spawn(function()
						local placeinfo = {Creator = {CreatorTargetId = tonumber(AutoLeaveGroupId.Value)}}
						if AutoLeaveGroupId.Value == "" then
							placeinfo = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
							if placeinfo.Creator.CreatorType ~= "Group" then 
								local desc = placeinfo.Description:split("\n")
								for i, str in pairs(desc) do 
									local _, begin = str:find("roblox.com/groups/")
									if begin then 
										local endof = str:find("/", begin + 1)
										placeinfo = {Creator = {CreatorType = "Group", CreatorTargetId = str:sub(begin + 1, endof - 1)}}
									end
								end
							end
							if placeinfo.Creator.CreatorType ~= "Group" then 
								warningNotification("AutoLeave", "Automatic Setup Failed (no group detected)", 60)
								return
							end
						end
						local groupinfo = game:GetService("GroupService"):GetGroupInfoAsync(placeinfo.Creator.CreatorTargetId)
						AutoLeaveGroupId.SetValue(placeinfo.Creator.CreatorTargetId)
						AutoLeaveRank.SetValue(autodetect(groupinfo.Roles))
						if AutoLeave.Enabled then
							AutoLeave.ToggleButton(false)
							AutoLeave.ToggleButton(false)
						end
					end)
					table.insert(AutoLeave.Connections, playersService.PlayerAdded:Connect(autoleaveplradded))
					for i, plr in pairs(playersService:GetPlayers()) do 
						autoleaveplradded(plr)
					end
				end
			else
				for i,v in pairs(WhitelistFunctions.CustomTags) do 
					if v == "[GAME STAFF] " then 
						WhitelistFunctions.CustomTags[i] = nil
						local _, ent = entityLibrary.getEntityFromPlayer(i)
						if ent then 
							entityLibrary.entityUpdatedEvent:Fire(ent)
						end
					end
				end
			end
		end,
		HoverText = "Leaves if a staff member joins your game."
	})
	AutoLeaveMode = AutoLeave.CreateDropdown({
		Name = "Mode",
		List = {"UnInject", "Rejoin", "Notify"},
		Function = function() end
	})
	AutoLeaveGroupId = AutoLeave.CreateTextBox({
		Name = "Group Id",
		TempText = "0 (group id)",
		Function = function() end
	})
	AutoLeaveRank = AutoLeave.CreateTextBox({
		Name = "Rank Id",
		TempText = "1 (rank id)",
		Function = function() end
	})
end)

runFunction(function()
	GuiLibrary.ObjectsThatCanBeSaved.WorldWindow.Api.CreateOptionsButton({
		Name = "AntiVoid", 
		Function = function(callback)
			if callback then 
				local rayparams = RaycastParams.new()
				rayparams.RespectCanCollide = true
				local lastray
				RunLoops:BindToHeartbeat("AntiVoid", function()
					if entityLibrary.isAlive then
						rayparams.FilterDescendantsInstances = {gameCamera, lplr.Character} 
						lastray = entityLibrary.character.Humanoid.FloorMaterial ~= Enum.Material.Air and entityLibrary.character.HumanoidRootPart.CFrame or lastray
						if (entityLibrary.character.HumanoidRootPart.Position.Y + (entityLibrary.character.HumanoidRootPart.Velocity.Y * 0.016)) <= (workspace.FallenPartsDestroyHeight + 5) then
							local comp = {entityLibrary.character.HumanoidRootPart.CFrame:GetComponents()}
							comp[2] = (workspace.FallenPartsDestroyHeight + 20)
							if lastray then
								comp[1] = lastray.Position.X
								comp[2] = lastray.Position.Y + (entityLibrary.character.Humanoid.HipHeight + (entityLibrary.character.HumanoidRootPart.Size.Y / 2))
								comp[3] = lastray.Position.Z
							end
							entityLibrary.character.HumanoidRootPart.CFrame = CFrame.new(unpack(comp))
							entityLibrary.character.HumanoidRootPart.Velocity = Vector3.new(entityLibrary.character.HumanoidRootPart.Velocity.X, 0, entityLibrary.character.HumanoidRootPart.Velocity.Z)
						end
					end
				end)
			else
				RunLoops:UnbindFromHeartbeat("AntiVoid")
			end
		end
	})
end)

runFunction(function()
	local Blink = {Enabled = false}
	Blink = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "Blink",
		Function = function(callback)
			if callback then 
				if sethiddenproperty then
					RunLoops:BindToHeartbeat("Blink", function()
						if entityLibrary.isAlive then 
							sethiddenproperty(entityLibrary.character.HumanoidRootPart, "NetworkIsSleeping", true)
						end
					end)
				else
					warningNotification("Blink", "missing function", 5)
					Blink.ToggleButton(false)
				end
			else
				RunLoops:UnbindFromHeartbeat("Blink")
			end
		end
	})
end)

runFunction(function()
	local AnimationPlayer = {Enabled = false}
	local AnimationPlayerBox = {Value = ""}
	local AnimationPlayerSpeed = {Speed = 1}
	local playedanim
	AnimationPlayer = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "AnimationPlayer",
		Function = function(callback)
			if callback then 
				if entityLibrary.isAlive then 
					if playedanim then 
						playedanim:Stop() 
						playedanim.Animation:Destroy()
						playedanim = nil 
					end
					local anim = Instance.new("Animation")
					local suc, id = pcall(function() return string.match(game:GetObjects("rbxassetid://"..AnimationPlayerBox.Value)[1].AnimationId, "%?id=(%d+)") end)
                    if not suc then
                        id = AnimationPlayerBox.Value
                    end
                    anim.AnimationId = "rbxassetid://"..id
					local suc, res = pcall(function() playedanim = entityLibrary.character.Humanoid.Animator:LoadAnimation(anim) end)
					if suc then
						playedanim.Priority = Enum.AnimationPriority.Action4
						playedanim.Looped = true
						playedanim:Play()
						playedanim:AdjustSpeed(AnimationPlayerSpeed.Value / 10)
						table.insert(AnimationPlayer.Connections, playedanim.Stopped:Connect(function()
							if AnimationPlayer.Enabled then
								AnimationPlayer.ToggleButton(false)
								AnimationPlayer.ToggleButton(false)
							end
						end))
					else
						warningNotification("AnimationPlayer", "failed to load anim : "..(res or "invalid animation id"), 5)
					end
				end
				table.insert(AnimationPlayer.Connections, lplr.CharacterAdded:Connect(function()
					repeat task.wait() until entityLibrary.isAlive or not AnimationPlayer.Enabled
					task.wait(0.5)
					if not AnimationPlayer.Enabled then return end
					if playedanim then 
						playedanim:Stop() 
						playedanim.Animation:Destroy()
						playedanim = nil 
					end
					local anim = Instance.new("Animation")
					local suc, id = pcall(function() return string.match(game:GetObjects("rbxassetid://"..AnimationPlayerBox.Value)[1].AnimationId, "%?id=(%d+)") end)
                    if not suc then
                        id = AnimationPlayerBox.Value
                    end
                    anim.AnimationId = "rbxassetid://"..id
					local suc, res = pcall(function() playedanim = entityLibrary.character.Humanoid.Animator:LoadAnimation(anim) end)
					if suc then
						playedanim.Priority = Enum.AnimationPriority.Action4
						playedanim.Looped = true
						playedanim:Play()
						playedanim:AdjustSpeed(AnimationPlayerSpeed.Value / 10)
						playedanim.Stopped:Connect(function()
							if AnimationPlayer.Enabled then
								AnimationPlayer.ToggleButton(false)
								AnimationPlayer.ToggleButton(false)
							end
						end)
					else
						warningNotification("AnimationPlayer", "failed to load anim : "..(res or "invalid animation id"), 5)
					end
				end))
			else
				if playedanim then playedanim:Stop() playedanim = nil end
			end
		end
	})
	AnimationPlayerBox = AnimationPlayer.CreateTextBox({
		Name = "Animation",
		TempText = "anim (num only)",
		Function = function(enter) 
			if enter and AnimationPlayer.Enabled then 
				AnimationPlayer.ToggleButton(false)
				AnimationPlayer.ToggleButton(false)
			end
		end
	})
	AnimationPlayerSpeed = AnimationPlayer.CreateSlider({
		Name = "Speed",
		Function = function(val)
			if playedanim then 
				playedanim:AdjustSpeed(val / 10)
			end
		end,
		Min = 1,
		Max = 20,
		Double = 10
	})
end)

runFunction(function()
	local GamingChair = {Enabled = false}
	local GamingChairColor = {Value = 1}
	local chair
	local chairanim
	local chairhighlight
	local movingsound
	local flyingsound
	local wheelpositions = {
		Vector3.new(-0.8, -0.6, -0.18),
		Vector3.new(0.1, -0.6, -0.88),
		Vector3.new(0, -0.6, 0.7)
	}
	local currenttween
	GamingChair = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "GamingChair",
		Function = function(callback)
			if callback then 
				chair = Instance.new("MeshPart")
				chair.Color = Color3.fromRGB(21, 21, 21)
				chair.Size = Vector3.new(2.16, 3.6, 2.3) / Vector3.new(12.37, 20.636, 13.071)
				chair.CanCollide = false
				chair.MeshId = "rbxassetid://12972961089"
				chair.Material = Enum.Material.SmoothPlastic
				chair.Parent = workspace
				movingsound = Instance.new("Sound")
				movingsound.SoundId = downloadVapeAsset("vape/assets/ChairRolling.mp3")
				movingsound.Volume = 0.4
				movingsound.Looped = true
				movingsound.Parent = workspace
				flyingsound = Instance.new("Sound")
				flyingsound.SoundId = downloadVapeAsset("vape/assets/ChairFlying.mp3")
				flyingsound.Volume = 0.4
				flyingsound.Looped = true
				flyingsound.Parent = workspace
				local chairweld = Instance.new("WeldConstraint")
				chairweld.Part0 = chair
				chairweld.Parent = chair
				if entityLibrary.isAlive then 
					chair.CFrame = entityLibrary.character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(-90), 0)
					chairweld.Part1 = entityLibrary.character.HumanoidRootPart
				end
				chairhighlight = Instance.new("Highlight")
				chairhighlight.FillTransparency = 1
				chairhighlight.OutlineColor = Color3.fromHSV(GamingChairColor.Hue, GamingChairColor.Sat, GamingChairColor.Value)
				chairhighlight.DepthMode = Enum.HighlightDepthMode.Occluded
				chairhighlight.OutlineTransparency = 0.2
				chairhighlight.Parent = chair
				local chairarms = Instance.new("MeshPart")
				chairarms.Color = chair.Color
				chairarms.Size = Vector3.new(1.39, 1.345, 2.75) / Vector3.new(97.13, 136.216, 234.031)
				chairarms.CFrame = chair.CFrame * CFrame.new(-0.169, -1.129, -0.013)
				chairarms.MeshId = "rbxassetid://12972673898"
				chairarms.CanCollide = false
				chairarms.Parent = chair
				local chairarmsweld = Instance.new("WeldConstraint")
				chairarmsweld.Part0 = chairarms
				chairarmsweld.Part1 = chair
				chairarmsweld.Parent = chair
				local chairlegs = Instance.new("MeshPart")
				chairlegs.Color = chair.Color
				chairlegs.Name = "Legs"
				chairlegs.Size = Vector3.new(1.8, 1.2, 1.8) / Vector3.new(10.432, 8.105, 9.488)
				chairlegs.CFrame = chair.CFrame * CFrame.new(0.047, -2.324, 0)
				chairlegs.MeshId = "rbxassetid://13003181606"
				chairlegs.CanCollide = false
				chairlegs.Parent = chair
				local chairfan = Instance.new("MeshPart")
				chairfan.Color = chair.Color
				chairfan.Name = "Fan"
				chairfan.Size = Vector3.zero
				chairfan.CFrame = chair.CFrame * CFrame.new(0, -1.873, 0)
				chairfan.MeshId = "rbxassetid://13004977292"
				chairfan.CanCollide = false
				chairfan.Parent = chair
				local trails = {}
				for i,v in pairs(wheelpositions) do 
					local attachment = Instance.new("Attachment")
					attachment.Position = v
					attachment.Parent = chairlegs
					local attachment2 = Instance.new("Attachment")
					attachment2.Position = v + Vector3.new(0, 0, 0.18)
					attachment2.Parent = chairlegs
					local trail = Instance.new("Trail")
					trail.Texture = "http://www.roblox.com/asset/?id=13005168530"
					trail.TextureMode = Enum.TextureMode.Static
					trail.Transparency = NumberSequence.new(0.5)
					trail.Color = ColorSequence.new(Color3.new(0.5, 0.5, 0.5))
					trail.Attachment0 = attachment
					trail.Attachment1 = attachment2
					trail.Lifetime = 20
					trail.MaxLength = 60
					trail.MinLength = 0.1
					trail.Parent = chairlegs
					table.insert(trails, trail)
				end
				chairanim = {Stop = function() end}
				local oldmoving = false
				local oldflying = false
				task.spawn(function()
					repeat
						task.wait()
						if not GamingChair.Enabled then break end
						if entityLibrary.isAlive and entityLibrary.character.Humanoid.Health > 0 then
							if not chairanim.IsPlaying then 
								local temp2 = Instance.new("Animation")
								temp2.AnimationId = "http://www.roblox.com/asset/?id=2506281703"
								chairanim = entityLibrary.character.Humanoid:LoadAnimation(temp2)
								chairanim.Priority = Enum.AnimationPriority.Movement
								chairanim.Looped = true
								chairanim:Play()
							end
							--welds didn't work for these idk why so poop code :troll:
							chair.CFrame = entityLibrary.character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(-90), 0)
							chairweld.Part1 = entityLibrary.character.HumanoidRootPart
							chairlegs.Velocity = Vector3.zero
							chairlegs.CFrame = chair.CFrame * CFrame.new(0.047, -2.324, 0)
							chairfan.Velocity = Vector3.zero
							chairfan.CFrame = chair.CFrame * CFrame.new(0.047, -1.873, 0) * CFrame.Angles(0, math.rad(tick() * 180 % 360), math.rad(180))
							local moving = entityLibrary.character.Humanoid:GetState() == Enum.HumanoidStateType.Running and entityLibrary.character.Humanoid.MoveDirection ~= Vector3.zero
							local flying = GuiLibrary.ObjectsThatCanBeSaved.FlyOptionsButton.Api.Enabled or GuiLibrary.ObjectsThatCanBeSaved.LongJumpOptionsButton and GuiLibrary.ObjectsThatCanBeSaved.LongJumpOptionsButton.Api.Enabled or GuiLibrary.ObjectsThatCanBeSaved.InfiniteFlyOptionsButton and GuiLibrary.ObjectsThatCanBeSaved.InfiniteFlyOptionsButton.Api.Enabled
							if movingsound.TimePosition > 1.9 then 
								movingsound.TimePosition = 0.2
							end
							movingsound.PlaybackSpeed = (entityLibrary.character.HumanoidRootPart.Velocity * Vector3.new(1, 0, 1)).Magnitude / 16
							for i,v in pairs(trails) do 
								v.Enabled = not flying and moving
								v.Color = ColorSequence.new(movingsound.PlaybackSpeed > 1.5 and Color3.new(1, 0.5, 0) or Color3.new())
							end
							if moving ~= oldmoving then 
								if movingsound.IsPlaying then 
									if not moving then movingsound:Stop() end
								else
									if not flying and moving then movingsound:Play() end
								end
								oldmoving = moving
							end
							if flying ~= oldflying then 
								if flying then 
									if movingsound.IsPlaying then 
										movingsound:Stop()
									end
									if not flyingsound.IsPlaying then 
										flyingsound:Play()
									end
									if currenttween then currenttween:Cancel() end
									tween = tweenService:Create(chairlegs, TweenInfo.new(0.15), {Size = Vector3.zero})
									tween.Completed:Connect(function(state)
										if state == Enum.PlaybackState.Completed then 
											chairfan.Transparency = 0
											chairlegs.Transparency = 1
											tween = tweenService:Create(chairfan, TweenInfo.new(0.15), {Size = Vector3.new(1.534, 0.328, 1.537) / Vector3.new(791.138, 168.824, 792.027)})
											tween:Play()
										end
									end)
									tween:Play()
								else
									if flyingsound.IsPlaying then 
										flyingsound:Stop()
									end
									if not movingsound.IsPlaying and moving then 
										movingsound:Play()
									end
									if currenttween then currenttween:Cancel() end
									tween = tweenService:Create(chairfan, TweenInfo.new(0.15), {Size = Vector3.zero})
									tween.Completed:Connect(function(state)
										if state == Enum.PlaybackState.Completed then 
											chairfan.Transparency = 1
											chairlegs.Transparency = 0
											tween = tweenService:Create(chairlegs, TweenInfo.new(0.15), {Size = Vector3.new(1.8, 1.2, 1.8) / Vector3.new(10.432, 8.105, 9.488)})
											tween:Play()
										end
									end)
									tween:Play()
								end
								oldflying = flying
							end
						else
							chair.Anchored = true
							chairlegs.Anchored = true
							chairfan.Anchored = true
							repeat task.wait() until entityLibrary.isAlive and entityLibrary.character.Humanoid.Health > 0
							chair.Anchored = false
							chairlegs.Anchored = false
							chairfan.Anchored = false
							chairanim:Stop()
						end
					until not GamingChair.Enabled
				end)
			else
				if chair then chair:Destroy() end
				if chairanim then chairanim:Stop() end
				if movingsound then movingsound:Destroy() end
				if flyingsound then flyingsound:Destroy() end
			end
		end
	})
	GamingChairColor = GamingChair.CreateColorSlider({
		Name = "Color",
		Function = function(h, s, v)
			if chairhighlight then 
				chairhighlight.OutlineColor = Color3.fromHSV(h, s, v)
			end
		end
	})
end)

runFunction(function()
	local SongBeats = {Enabled = false}
	local SongBeatsList = {ObjectList = {}}
	local SongTween
	local SongAudio
	local SongFOV

	local function PlaySong(arg)
		local args = arg:split(":")
		local song = isfile(args[1]) and getcustomasset(args[1])
		if not song then 
			warningNotification("SongBeats", "missing music file "..args[1], 5)
			SongBeats.ToggleButton(false)
			return
		end
		local bpm = 1 / (args[2] / 60)
		SongAudio = Instance.new("Sound")
		SongAudio.SoundId = song
		SongAudio.Parent = workspace
		SongAudio:Play()
		repeat
			repeat task.wait() until SongAudio.IsLoaded or (not SongBeats.Enabled) 
			if (not SongBeats.Enabled) then break end
			gameCamera.FieldOfView = SongFOV - 5
			if SongTween then SongTween:Cancel() end
			SongTween = tweenService:Create(gameCamera, TweenInfo.new(0.2), {FieldOfView = SongFOV})
			SongTween:Play()
			task.wait(bpm)
		until (not SongBeats.Enabled) or SongAudio.IsPaused
	end

	SongBeats = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "SongBeats",
		Function = function(callback)
			if callback then 
				SongFOV = gameCamera.FieldOfView
				task.spawn(function()
					if #SongBeatsList.ObjectList <= 0 then 
						warningNotification("SongBeats", "no songs", 5)
						SongBeats.ToggleButton(false)
						return
					end
					local lastChosen
					repeat
						local newSong
						repeat newSong = SongBeatsList.ObjectList[Random.new():NextInteger(1, #SongBeatsList.ObjectList)] task.wait() until newSong ~= lastChosen or #SongBeatsList.ObjectList <= 1
						lastChosen = newSong
						PlaySong(newSong)
						if not SongBeats.Enabled then break end
						task.wait(2)
					until (not SongBeats.Enabled)
				end)
			else
				if SongAudio then SongAudio:Destroy() end
				if SongTween then SongTween:Cancel() end
				gameCamera.FieldOfView = SongFOV
			end
		end
	})
	SongBeatsList = SongBeats.CreateTextList({
		Name = "SongList",
		TempText = "songpath:bpm"
	})
end)

runFunction(function()
	local Atmosphere = {Enabled = false}
	local SkyUp = {Value = ""}
	local SkyDown = {Value = ""}
	local SkyLeft = {Value = ""}
	local SkyRight = {Value = ""}
	local SkyFront = {Value = ""}
	local SkyBack = {Value = ""}
	local SkySun = {Value = ""}
	local SkyMoon = {Value = ""}
	local SkyColor = {Value = 1}
	local skyobj
	local skyatmosphereobj
	local oldobjects = {}
	Atmosphere = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "Atmosphere",
		Function = function(callback)
			if callback then 
				for i,v in pairs(lightingService:GetChildren()) do 
					if v:IsA("PostEffect") or v:IsA("Sky") then 
						table.insert(oldobjects, v)
						v.Parent = game
					end
				end
				skyobj = Instance.new("Sky")
				skyobj.SkyboxBk = tonumber(SkyBack.Value) and "rbxassetid://"..SkyBack.Value or SkyBack.Value
				skyobj.SkyboxDn = tonumber(SkyDown.Value) and "rbxassetid://"..SkyDown.Value or SkyDown.Value
				skyobj.SkyboxFt = tonumber(SkyFront.Value) and "rbxassetid://"..SkyFront.Value or SkyFront.Value
				skyobj.SkyboxLf = tonumber(SkyLeft.Value) and "rbxassetid://"..SkyLeft.Value or SkyLeft.Value
				skyobj.SkyboxRt = tonumber(SkyRight.Value) and "rbxassetid://"..SkyRight.Value or SkyRight.Value
				skyobj.SkyboxUp = tonumber(SkyUp.Value) and "rbxassetid://"..SkyUp.Value or SkyUp.Value
				skyobj.SunTextureId = tonumber(SkySun.Value) and "rbxassetid://"..SkySun.Value or SkySun.Value
				skyobj.MoonTextureId = tonumber(SkyMoon.Value) and "rbxassetid://"..SkyMoon.Value or SkyMoon.Value
				skyobj.Parent = lightingService
				skyatmosphereobj = Instance.new("ColorCorrectionEffect")
				skyatmosphereobj.TintColor = Color3.fromHSV(SkyColor.Hue, SkyColor.Sat, SkyColor.Value)
				skyatmosphereobj.Parent = lightingService
			else
				if skyobj then skyobj:Destroy() end
				if skyatmosphereobj then skyatmosphereobj:Destroy() end
				for i,v in pairs(oldobjects) do 
					v.Parent = lightingService
				end
				table.clear(oldobjects)
			end
		end
	})
	SkyUp = Atmosphere.CreateTextBox({
		Name = "SkyUp",
		TempText = "Sky Top ID",
		FocusLost = function(enter) 
			if Atmosphere.Enabled then 
				Atmosphere.ToggleButton(false)
				Atmosphere.ToggleButton(false)
			end
		end
	})
	SkyDown = Atmosphere.CreateTextBox({
		Name = "SkyDown",
		TempText = "Sky Bottom ID",
		FocusLost = function(enter) 
			if Atmosphere.Enabled then 
				Atmosphere.ToggleButton(false)
				Atmosphere.ToggleButton(false)
			end
		end
	})
	SkyLeft = Atmosphere.CreateTextBox({
		Name = "SkyLeft",
		TempText = "Sky Left ID",
		FocusLost = function(enter) 
			if Atmosphere.Enabled then 
				Atmosphere.ToggleButton(false)
				Atmosphere.ToggleButton(false)
			end
		end
	})
	SkyRight = Atmosphere.CreateTextBox({
		Name = "SkyRight",
		TempText = "Sky Right ID",
		FocusLost = function(enter) 
			if Atmosphere.Enabled then 
				Atmosphere.ToggleButton(false)
				Atmosphere.ToggleButton(false)
			end
		end
	})
	SkyFront = Atmosphere.CreateTextBox({
		Name = "SkyFront",
		TempText = "Sky Front ID",
		FocusLost = function(enter) 
			if Atmosphere.Enabled then 
				Atmosphere.ToggleButton(false)
				Atmosphere.ToggleButton(false)
			end
		end
	})
	SkyBack = Atmosphere.CreateTextBox({
		Name = "SkyBack",
		TempText = "Sky Back ID",
		FocusLost = function(enter) 
			if Atmosphere.Enabled then 
				Atmosphere.ToggleButton(false)
				Atmosphere.ToggleButton(false)
			end
		end
	})
	SkySun = Atmosphere.CreateTextBox({
		Name = "SkySun",
		TempText = "Sky Sun ID",
		FocusLost = function(enter) 
			if Atmosphere.Enabled then 
				Atmosphere.ToggleButton(false)
				Atmosphere.ToggleButton(false)
			end
		end
	})
	SkyMoon = Atmosphere.CreateTextBox({
		Name = "SkyMoon",
		TempText = "Sky Moon ID",
		FocusLost = function(enter) 
			if Atmosphere.Enabled then 
				Atmosphere.ToggleButton(false)
				Atmosphere.ToggleButton(false)
			end
		end
	})
	SkyColor = Atmosphere.CreateColorSlider({
		Name = "Color",
		Function = function(h, s, v)
			if skyatmosphereobj then 
				skyatmosphereobj.TintColor = Color3.fromHSV(SkyColor.Hue, SkyColor.Sat, SkyColor.Value)
			end
		end
	})
end)

runFunction(function()
	local Disabler = {Enabled = false}
	local DisablerAntiKick = {Enabled = false}
	local disablerhooked = false

	local hookmethod = function(self)
		if (not Disabler.Enabled) then return end
		if type(self) == "userdata" and self == lplr then 
			return true
		end
	end
	

	Disabler = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "ClientKickDisabler",
		Function = function(callback)
			if callback then 
				if not disablerhooked then 
					disablerhooked = true
					local oldnamecall
					oldnamecall = hookmetamethod(game, "__namecall", function(self, ...)
						local method = getnamecallmethod()
						if method ~= "Kick" and method ~= "kick" then return oldnamecall(self, ...) end
						if not Disabler.Enabled then
							return oldnamecall(self, ...)
						end
						if not hookmethod(self) then return oldnamecall(self, ...) end
						return
					end)
					local antikick
					antikick = hookfunction(lplr.Kick, function(self, ...)
						if not Disabler.Enabled then return antikick(self, ...) end
						if type(self) == "userdata" and self == lplr then 
							return
						end
						return antikick(self, ...)
					end)
				end
			else
				if restorefunction then 
					restorefunction(lplr.Kick)
					restorefunction(getrawmetatable(game).__namecall)
					disablerhooked = false
				end
			end
		end
	})
end)

runFunction(function()
	local FPS = {}
	local FPSLabel
	FPS = GuiLibrary.CreateLegitModule({
		Name = "FPS",
		Function = function(callback)
			if callback then 
				local frames = {}
				local framerate = 0
				local startClock = os.clock()
				local updateTick = tick()
				RunLoops:BindToHeartbeat("FPS", function()
					-- https://devforum.roblox.com/t/get-client-fps-trough-a-script/282631, annoying math, I thought either adding dt to a table or doing 1 / dt would work, but this is just better lol
					local updateClock = os.clock()
					for i = #frames, 1, -1 do
						frames[i + 1] = frames[i] >= updateClock - 1 and frames[i] or nil
					end
					frames[1] = updateClock
					if updateTick < tick() then 
						updateTick = tick() + 1
						FPSLabel.Text = math.floor(os.clock() - startClock >= 1 and #frames or #frames / (os.clock() - startClock)).." FPS"
					end
				end)
			else
				RunLoops:UnbindFromHeartbeat("FPS")
			end
		end
	})
	FPSLabel = Instance.new("TextLabel")
	FPSLabel.Size = UDim2.new(0, 100, 0, 41)
	FPSLabel.BackgroundTransparency = 0.5
	FPSLabel.TextSize = 15
	FPSLabel.Font = Enum.Font.Gotham
	FPSLabel.Text = "inf FPS"
	FPSLabel.TextColor3 = Color3.new(1, 1, 1)
	FPSLabel.BackgroundColor3 = Color3.new()
	FPSLabel.Parent = FPS.GetCustomChildren()
	local ReachCorner = Instance.new("UICorner")
	ReachCorner.CornerRadius = UDim.new(0, 4)
	ReachCorner.Parent = FPSLabel
end)


runFunction(function()
	local Ping = {}
	local PingLabel
	Ping = GuiLibrary.CreateLegitModule({
		Name = "Ping",
		Function = function(callback)
			if callback then 
				task.spawn(function()
					repeat 
						PingLabel.Text = math.floor(tonumber(game:GetService("Stats"):FindFirstChild("PerformanceStats").Ping:GetValue())).." ms"
						task.wait(1)
					until false
				end)
			end
		end
	})
	PingLabel = Instance.new("TextLabel")
	PingLabel.Size = UDim2.new(0, 100, 0, 41)
	PingLabel.BackgroundTransparency = 0.5
	PingLabel.TextSize = 15
	PingLabel.Font = Enum.Font.Gotham
	PingLabel.Text = "0 ms"
	PingLabel.TextColor3 = Color3.new(1, 1, 1)
	PingLabel.BackgroundColor3 = Color3.new()
	PingLabel.Parent = Ping.GetCustomChildren()
	local PingCorner = Instance.new("UICorner")
	PingCorner.CornerRadius = UDim.new(0, 4)
	PingCorner.Parent = PingLabel
end)

runFunction(function()
	local Keystrokes = {}
	local keys = {}
	local keystrokesframe
	local keyconnection1
	local keyconnection2

	local function createKeystroke(keybutton, pos, pos2)
		local key = Instance.new("Frame")
		key.Size = keybutton == Enum.KeyCode.Space and UDim2.new(0, 110, 0, 24) or UDim2.new(0, 34, 0, 36)
		key.BackgroundColor3 = Color3.new()
		key.BackgroundTransparency = 0.5
		key.Position = pos
		key.Name = keybutton.Name
		key.Parent = keystrokesframe
		local keytext = Instance.new("TextLabel")
		keytext.BackgroundTransparency = 1
		keytext.Size = UDim2.new(1, 0, 1, 0)
		keytext.Font = Enum.Font.Gotham
		keytext.Text = keybutton == Enum.KeyCode.Space and "______" or keybutton.Name
		keytext.TextXAlignment = Enum.TextXAlignment.Left
		keytext.TextYAlignment = Enum.TextYAlignment.Top
		keytext.Position = pos2
		keytext.TextSize = keybutton == Enum.KeyCode.Space and 18 or 15
		keytext.TextColor3 = Color3.new(1, 1, 1)
		keytext.Parent = key
		local keycorner = Instance.new("UICorner")
		keycorner.CornerRadius = UDim.new(0, 4)
		keycorner.Parent = key
		keys[keybutton] = {Key = key}
	end

	Keystrokes = GuiLibrary.CreateLegitModule({
		Name = "Keystrokes",
		Function = function(callback)
			if callback then 
				keyconnection1 = inputService.InputBegan:Connect(function(inputType)
					local key = keys[inputType.KeyCode]
					if key then 
						if key.Tween then key.Tween:Cancel() end
						if key.Tween2 then key.Tween2:Cancel() end
						key.Tween = tweenService:Create(key.Key, TweenInfo.new(0.1), {BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 0})
						key.Tween:Play()
						key.Tween2 = tweenService:Create(key.Key.TextLabel, TweenInfo.new(0.1), {TextColor3 = Color3.new()})
						key.Tween2:Play()
					end
				end)
				keyconnection2 = inputService.InputEnded:Connect(function(inputType)
					local key = keys[inputType.KeyCode]
					if key then 
						if key.Tween then key.Tween:Cancel() end
						if key.Tween2 then key.Tween2:Cancel() end
						key.Tween = tweenService:Create(key.Key, TweenInfo.new(0.1), {BackgroundColor3 = Color3.new(), BackgroundTransparency = 0.5})
						key.Tween:Play()
						key.Tween2 = tweenService:Create(key.Key.TextLabel, TweenInfo.new(0.1), {TextColor3 = Color3.new(1, 1, 1)})
						key.Tween2:Play()
					end
				end)
			else
				if keyconnection1 then keyconnection1:Disconnect() end
				if keyconnection2 then keyconnection2:Disconnect() end
			end
		end
	})
	keystrokesframe = Instance.new("Frame")
	keystrokesframe.Size = UDim2.new(0, 110, 0, 176)
	keystrokesframe.BackgroundTransparency = 1
	keystrokesframe.Parent = Keystrokes.GetCustomChildren()
	createKeystroke(Enum.KeyCode.W, UDim2.new(0, 38, 0, 0), UDim2.new(0, 6, 0, 5))
	createKeystroke(Enum.KeyCode.S, UDim2.new(0, 38, 0, 42), UDim2.new(0, 8, 0, 5))
	createKeystroke(Enum.KeyCode.A, UDim2.new(0, 0, 0, 42), UDim2.new(0, 7, 0, 5))
	createKeystroke(Enum.KeyCode.D, UDim2.new(0, 76, 0, 42), UDim2.new(0, 8, 0, 5))
	createKeystroke(Enum.KeyCode.Space, UDim2.new(0, 0, 0, 83), UDim2.new(0, 25, 0, -10))
end)