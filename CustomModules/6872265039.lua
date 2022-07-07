-- Credits to Inf Yield & all the other scripts that helped me make bypasses
local GuiLibrary = shared.GuiLibrary
local players = game:GetService("Players")
local textservice = game:GetService("TextService")
local repstorage = game:GetService("ReplicatedStorage")
local lplr = players.LocalPlayer
local workspace = game:GetService("Workspace")
local lighting = game:GetService("Lighting")
local cam = workspace.CurrentCamera
local targetinfo = shared.VapeTargetInfo
local uis = game:GetService("UserInputService")
local mouse = lplr:GetMouse()
local robloxfriends = {}
local bedwars = {}
local getfunctions
local origC0 = nil
local vec3 = Vector3.new
local cfnew = CFrame.new
local function GetURL(scripturl)
	if shared.VapeDeveloper then
		return readfile("vape/"..scripturl)
	else
		return game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/"..scripturl, true)
	end
end
local entity = shared.vapeentity
local queueteleport = syn and syn.queue_on_teleport or queue_on_teleport or fluxus and fluxus.queue_on_teleport or function() end
local teleportfunc
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
local getasset = getsynasset or getcustomasset
local storedshahashes = {}
local oldchanneltab
local oldchannelfunc
local oldchanneltabs = {}
local networkownertick = tick()
local networkownerfunc = isnetworkowner or function(part)
	if gethiddenproperty(part, "NetworkOwnershipRule") == Enum.NetworkOwnership.Manual then 
		sethiddenproperty(part, "NetworkOwnershipRule", Enum.NetworkOwnership.Automatic)
		networkownertick = tick() + 8
	end
	return networkownertick <= tick()
end


local function GetURL(scripturl)
	if shared.VapeDeveloper then
		return readfile("vape/"..scripturl)
	else
		return game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/"..scripturl, true)
	end
end

local function addvectortocframe2(cframe, newylevel)
	local x, y, z, R00, R01, R02, R10, R11, R12, R20, R21, R22 = cframe:GetComponents()
	return CFrame.new(x, newylevel, z, R00, R01, R02, R10, R11, R12, R20, R21, R22)
end

local shalib = loadstring(GetURL("Libraries/sha.lua"))()
local whitelisted = {
	players = {
		"94a10e281a721c62346185156c15dcc62a987aa9a73c482db4d1b0f2b4673261ec808040fb70886bf50453c7af97903ffe398199b43fccf5d8b619121493382d",
		"a91361a785c34c433f33386ef224586b7076e1e10ebb8189fdc39b7e37822eb6c79a7d810e0d2d41e000db65f8c539ffe2144e70d48e6d3df7b66350d4699c36",
		"cd41b8c39abf4b186f611f3afd13e5d0a2e5d65540b0dab93eed68a68f3891e0448d87dbba0937395ab1b7c3d4b6aed4025caad2b90b2cdbf4ca69441644d561",
		"28f1c2514aea620a23ef6a1f084e86a993e2585110c1ddd7f98cc6b3bd331251382c0143f7520153c91a368be5683d3406e06c9e35fba61f8bd2ac811c05f46b",
		"8b6c2833fa6e3a7defdeb8ffb4dcd6d4c652e6d02621c054df7c44ebaf94858ac5cbed6a6aadf0270c07d7054b7a2dd1ebf49ab20ffbc567213376c7848b8b90",
		"6662a5dfbb5311ee66af25cf9b6255c8b70f977022fcaed8fa9e6bcb4fe0159c148835d7c3b599a5f92f9a67455e0158f8977f33e9306dd4cee3efceb0b75441",
		"bdf4e13afb63148ad68cf75e25ec6f0cf11e0c4a597e8bdd5c93724a44bde2ce12eee46549a90ae4390bbfa36f8c662b7634600c552ca21d093004d473f9b23f"
	},
	owners = {
		"66ed442039083616d035cd09a9701e6c225bd61278aaad11a759956172144867ed1b0dc1ecc4f779e6084d7d576e49250f8066e2f9ad86340185939a7e79b30f",
		"55273f4b0931f16c1677680328f2784842114d212498a657a79bb5086b3929c173c5e3ca5b41fa3301b62cccf1b241db68a85e3cd9bbe5545b7a8c6422e7f0d2"
	},
	chattags = {
		["a"] = {
			NameColor = {r = 255, g = 0, b = 0},
			Tags = {
				{
					TagColor = {r = 255, g = 0, b = 0},
					TagText = "okay"
				}
			}
		}
	}
}
pcall(function()
	whitelisted = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/whitelists/main/whitelist2.json", true))
end)

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
			speed = speed + (queueType == "SURVIVAL" and 0.15 or 0.3)
		end
	end
	return reduce and speed ~= 1 and speed * (0.9 - (0.15 * math.floor(speed))) or speed
end

local RunLoops = {RenderStepTable = {}, StepTable = {}, HeartTable = {}}
do
	function RunLoops:BindToRenderStep(name, num, func)
		if RunLoops.RenderStepTable[name] == nil then
			RunLoops.RenderStepTable[name] = game:GetService("RunService").RenderStepped:connect(func)
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
			RunLoops.StepTable[name] = game:GetService("RunService").Stepped:connect(func)
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
			RunLoops.HeartTable[name] = game:GetService("RunService").Heartbeat:connect(func)
		end
	end

	function RunLoops:UnbindFromHeartbeat(name)
		if RunLoops.HeartTable[name] then
			RunLoops.HeartTable[name]:Disconnect()
			RunLoops.HeartTable[name] = nil
		end
	end
end

local function runcode(func)
	func()
end

local function betterfind(tab, obj)
	for i,v in pairs(tab) do
		if v == obj or type(v) == "table" and v.hash == obj then
			return v
		end
	end
	return nil
end

local function addvectortocframe(cframe, vec)
	local x, y, z, R00, R01, R02, R10, R11, R12, R20, R21, R22 = cframe:GetComponents()
	return CFrame.new(x + vec.X, y + vec.Y, z + vec.Z, R00, R01, R02, R10, R11, R12, R20, R21, R22)
end

local function getremote(tab)
	for i,v in pairs(tab) do
		if v == "Client" then
			return tab[i + 1]
		end
	end
	return ""
end

local function getcustomassetfunc(path)
	if not betterisfile(path) then
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
			repeat task.wait() until betterisfile(path)
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

local function isAlive(plr)
	if plr then
		return plr and plr.Character and plr.Character.Parent ~= nil and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("Humanoid")
	end
	return lplr and lplr.Character and lplr.Character.Parent ~= nil and lplr.Character:FindFirstChild("HumanoidRootPart") and lplr.Character:FindFirstChild("Head") and lplr.Character:FindFirstChild("Humanoid")
end

local function createwarning(title, text, delay)
	local suc, res = pcall(function()
		local frame = GuiLibrary["CreateNotification"](title, text, delay, "assets/WarningNotification.png")
		frame.Frame.Frame.ImageColor3 = Color3.fromRGB(236, 129, 44)
		return frame
	end)
	return (suc and res)
end

local newupdate = lplr.PlayerScripts.TS:WaitForChild("ui", 3) and true or false

runcode(function()
    local flaggedremotes = {"SelfReport"}

    getfunctions = function()
        local Flamework = require(repstorage["rbxts_include"]["node_modules"]["@flamework"].core.out).Flamework
		repeat task.wait() until Flamework.isInitialized
        local KnitClient = debug.getupvalue(require(lplr.PlayerScripts.TS.knit).setup, 6)
        local Client = require(repstorage.TS.remotes).default.Client
        local OldClientGet = getmetatable(Client).Get
		local OldClientWaitFor = getmetatable(Client).WaitFor
        bedwars = {
			["BedwarsKits"] = require(repstorage.TS.games.bedwars.kit["bedwars-kit-shop"]).BedwarsKitShop,
            ["ClientHandler"] = Client,
            ["ClientStoreHandler"] = (newupdate and require(lplr.PlayerScripts.TS.ui.store).ClientStore or require(lplr.PlayerScripts.TS.rodux.rodux).ClientStore),
			["QueryUtil"] = require(repstorage["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out).GameQueryUtil,
			["KitMeta"] = require(repstorage.TS.games.bedwars.kit["bedwars-kit-meta"]).BedwarsKitMeta,
			["LobbyClientEvents"] = (newupdate and require(repstorage["rbxts_include"]["node_modules"]["@easy-games"].lobby.out.client.events).LobbyClientEvents),
            ["sprintTable"] = KnitClient.Controllers.SprintController,
			["WeldTable"] = require(repstorage.TS.util["weld-util"]).WeldUtil,
			["QueueMeta"] = require(repstorage.TS.game["queue-meta"]).QueueMeta,
			["CheckWhitelisted"] = function(plr, ownercheck)
				local plrstr = bedwars["HashFunction"](plr.Name..plr.UserId)
				local localstr = bedwars["HashFunction"](lplr.Name..lplr.UserId)
				return ((ownercheck == nil and (betterfind(whitelisted.players, plrstr) or betterfind(whitelisted.owners, plrstr)) or ownercheck and betterfind(whitelisted.owners, plrstr))) and betterfind(whitelisted.players, localstr) == nil and betterfind(whitelisted.owners, localstr) == nil and true or false
			end,
			["CheckPlayerType"] = function(plr)
				local plrstr = bedwars["HashFunction"](plr.Name..plr.UserId)
				local playertype = "DEFAULT"
				if betterfind(whitelisted.players, plrstr) then
					playertype = "VAPE PRIVATE"
				end
				if betterfind(whitelisted.owners, plrstr) then
					playertype = "VAPE OWNER"
				end
				return playertype
			end,
			["HashFunction"] = function(str)
				if storedshahashes[tostring(str)] == nil then
					storedshahashes[tostring(str)] = shalib.sha512(tostring(str).."SelfReport")
				end
				return storedshahashes[tostring(str)]
			end,
			["getEntityTable"] = require(repstorage.TS.entity["entity-util"]).EntityUtil,
        }
		if not shared.vapebypassed then
			local realremote = repstorage:WaitForChild("GameAnalyticsError")
			realremote.Parent = nil
			local fakeremote = Instance.new("RemoteEvent")
			fakeremote.Name = "GameAnalyticsError"
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
		spawn(function()
			local chatsuc, chatres = pcall(function() return game:GetService("HttpService"):JSONDecode(readfile("vape/Profiles/bedwarssettings.json")) end)
			if chatsuc then
				if chatres.crashed and (not chatres.said) then
					pcall(function()
						local notification1 = createwarning("Vape", "either ur poor or its a exploit moment", 10)
						notification1:GetChildren()[5].TextSize = 15
						local notification2 = createwarning("Vape", "getconnections crashed, chat hook not loaded.", 10)
						notification2:GetChildren()[5].TextSize = 13
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
			for i3,v3 in pairs(whitelisted.chattags) do
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
									local plrtype = bedwars["CheckPlayerType"](players[MessageData.FromSpeaker])
									local hash = bedwars["HashFunction"](players[MessageData.FromSpeaker].Name..players[MessageData.FromSpeaker].UserId)
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
									if whitelisted.chattags[hash] then
										MessageData.ExtraData = whitelisted.chattags[hash]
									end
								end
								return addmessage(Self2, MessageData)
							end
						end
						return tab
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
getfunctions()

GuiLibrary["SelfDestructEvent"].Event:connect(function()
	if chatconnection then
		chatconnection:Disconnect()
	end
	if teleportfunc then
		teleportfunc:Disconnect()
	end
	if oldchannelfunc and oldchanneltab then
		oldchanneltab.GetChannel = oldchannelfunc
	end
	for i2,v2 in pairs(oldchanneltabs) do
		i2.AddMessageToChannel = v2
	end
end)

local function getNametagString(plr)
	local nametag = ""
	if bedwars["CheckPlayerType"](plr) == "VAPE PRIVATE" then
		nametag = '<font color="rgb(127, 0, 255)">[VAPE PRIVATE] '..(plr.DisplayName or plr.Name)..'</font>'
	end
	if bedwars["CheckPlayerType"](plr) == "VAPE OWNER" then
		nametag = '<font color="rgb(255, 80, 80)">[VAPE OWNER] '..(plr.DisplayName or plr.Name)..'</font>'
	end
	if whitelisted.chattags[bedwars["HashFunction"](plr.Name..plr.UserId)] then
		local data = whitelisted.chattags[bedwars["HashFunction"](plr.Name..plr.UserId)]
		local newnametag = ""
		if data.Tags then
			for i2,v2 in pairs(data.Tags) do
				newnametag = newnametag..'<font color="rgb('..math.floor(v2.TagColor.r)..', '..math.floor(v2.TagColor.g)..', '..math.floor(v2.TagColor.b)..')">['..v2.TagText..']</font> '
			end
		end
		nametag = newnametag..(newnametag.NameColor and '<font color="rgb('..math.floor(newnametag.NameColor.r)..', '..math.floor(newnametag.NameColor.g)..', '..math.floor(newnametag.NameColor.b)..')">' or '')..(plr.DisplayName or plr.Name)..(newnametag.NameColor and '</font>' or '')
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

local AnticheatBypassNumbers = {
	TPSpeed = 0.1,
	TPCombat = 0.3,
	TPLerp = 0.39,
	TPCheck = 15
}

local function friendCheck(plr, recolor)
	if GuiLibrary["ObjectsThatCanBeSaved"]["Use FriendsToggle"]["Api"]["Enabled"] then
		local friend = (table.find(GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"]["ObjectList"], plr.Name) and GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"]["ObjectListEnabled"][table.find(GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"]["ObjectList"], plr.Name)] and true or nil)
		if recolor then
			return (friend and GuiLibrary["ObjectsThatCanBeSaved"]["Recolor visualsToggle"]["Api"]["Enabled"] and true or nil)
		else
			return friend
		end
	end
	return nil
end

do
	local invadded = {}
	local invremoved = {}
	local armor1 = {}
	local armor2 = {}
	local armor3 = {}
	local hand = {}
	local healthconnection = {}
	GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"].FriendRefresh.Event:connect(function()
		entity.fullEntityRefresh()
	end)
	entity.isPlayerTargetable = function(plr)
		return lplr ~= plr and shared.vapeteamcheck(plr) and friendCheck(plr) == nil
	end
	entity.playerUpdated = Instance.new("BindableEvent")
	entity.characterAdded = function(plr, char, localcheck)
        if char then
            task.spawn(function()
                local humrootpart = char:WaitForChild("HumanoidRootPart", 10)
                local head = char:WaitForChild("Head", 10)
                local hum = char:WaitForChild("Humanoid", 10)
                if humrootpart and hum and head then
                    if localcheck then
                        entity.isAlive = true
                        entity.character.Head = head
                        entity.character.Humanoid = hum
                        entity.character.HumanoidRootPart = humrootpart
                    else
                        table.insert(entity.entityList, {
                            Player = plr,
                            Character = char,
                            RootPart = humrootpart,
							Head = head,
							Humanoid = hum,
                            Targetable = entity.isPlayerTargetable(plr),
                            Team = plr.Team
                        })
                    end
                    entity.entityConnections[#entity.entityConnections + 1] = char.ChildRemoved:connect(function(part)
                        if part.Name == "HumanoidRootPart" or part.Name == "Head" or part.Name == "Humanoid" then
                            if localcheck then
								if char == lplr.Character then
									if part.Name == "HumanoidRootPart" then
										entity.isAlive = false
										local root = char:FindFirstChild("HumanoidRootPart")
										if not root then 
											for i = 1, 30 do 
												task.wait(0.1)
												root = char:FindFirstChild("HumanoidRootPart")
												if root then break end
											end
										end
										if root then 
											entity.character.HumanoidRootPart = root
											entity.isAlive = true
										end
									else
										entity.isAlive = false
									end
								end
                            else
                                entity.removeEntity(plr)
                            end
                        end
                    end)
                end
            end)
        end
    end
	entity.entityAdded = function(plr, localcheck, custom)
        entity.entityConnections[#entity.entityConnections + 1] = plr.CharacterAdded:connect(function(char)
            entity.refreshEntity(plr, localcheck)
        end)
        entity.entityConnections[#entity.entityConnections + 1] = plr.CharacterRemoving:connect(function(char)
            if localcheck then
                entity.isAlive = false
            else
                entity.removeEntity(plr)
            end
        end)
        entity.entityConnections[#entity.entityConnections + 1] = plr:GetAttributeChangedSignal("Team"):connect(function()
            if localcheck then
                entity.fullEntityRefresh()
            else
				entity.refreshEntity(plr, localcheck)
				entity.playerUpdated:Fire(plr)
				if plr:GetAttribute("Team") == lplr:GetAttribute("Team") then 
					task.delay(3, function()
						entity.refreshEntity(plr, localcheck)
						entity.playerUpdated:Fire(plr)
					end)
				end
            end
        end)
        if plr.Character then
            entity.refreshEntity(plr, localcheck)
        end
    end
	entity.fullEntityRefresh()
end

local function renderNametag(plr)
	if bedwars["CheckPlayerType"](plr) ~= "DEFAULT" or whitelisted.chattags[bedwars["HashFunction"](plr.Name..plr.UserId)] then
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
		local nametag = getNametagString(plr)
		plr.CharacterAdded:connect(function(char)
			if char ~= oldchar then
				spawn(function()
					pcall(function() 
						bedwars["getEntityTable"]:getEntity(plr):setNametag(nametag)
						Cape(char, getcustomassetfunc("vape/assets/VapeCape.png"))
					end)
				end)
			end
		end)
		spawn(function()
			if plr.Character and plr.Character ~= oldchar then
				spawn(function()
					pcall(function() 
						bedwars["getEntityTable"]:getEntity(plr):setNametag(nametag)
						Cape(plr.Character, getcustomassetfunc("vape/assets/VapeCape.png"))
					end)
				end)
			end
		end)
	end
end

for i,v in pairs(players:GetChildren()) do renderNametag(v) end
players.PlayerAdded:connect(renderNametag)

GuiLibrary["RemoveObject"]("SilentAimOptionsButton")
GuiLibrary["RemoveObject"]("AutoClickerOptionsButton")
GuiLibrary["RemoveObject"]("MouseTPOptionsButton")
GuiLibrary["RemoveObject"]("ReachOptionsButton")
GuiLibrary["RemoveObject"]("HitBoxesOptionsButton")
GuiLibrary["RemoveObject"]("KillauraOptionsButton")
GuiLibrary["RemoveObject"]("LongJumpOptionsButton")
GuiLibrary["RemoveObject"]("HighJumpOptionsButton")
GuiLibrary["RemoveObject"]("SafeWalkOptionsButton")

teleportfunc = lplr.OnTeleport:Connect(function(State)
    if State == Enum.TeleportState.Started then
		if shared.vapeoverlay then
			queueteleport('shared.vapeoverlay = "'..shared.vapeoverlay..'"')
		end
		if shared.nobolineupdate then
			queueteleport('shared.nobolineupdate = '..tostring(shared.nobolineupdate))
		end
    end
end)

local Sprint = {["Enabled"] = false}
Sprint = GuiLibrary["ObjectsThatCanBeSaved"]["CombatWindow"]["Api"].CreateOptionsButton({
	["Name"] = "Sprint",
	["Function"] = function(callback)
		if callback then
			spawn(function()
				repeat
					task.wait()
					if bedwars["sprintTable"].sprinting == false then
						getmetatable(bedwars["sprintTable"])["startSprinting"](bedwars["sprintTable"])
					end
				until Sprint["Enabled"] == false
			end)
		end
	end, 
	["HoverText"] = "Sets your sprinting to true."
})

GuiLibrary["RemoveObject"]("FlyOptionsButton")
local flymissile
runcode(function()
	local OldNoFallFunction
	local flyspeed = {["Value"] = 40}
	local flyverticalspeed = {["Value"] = 40}
	local flyupanddown = {["Enabled"] = true}
	local flypop = {["Enabled"] = true}
	local flyautodamage = {["Enabled"] = true}
	local olddeflate
	local flyrequests = 0
	local flytime = 60
	local flylimit = false
	local flyup = false
	local flydown = false
	local tnttimer = 0
	local flypress
	local flyendpress
	local flycorountine

	local flytog = false
	local flytogtick = tick()
	fly = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Fly",
		["Function"] = function(callback)
			if callback then
				--buyballoons()
				flypress = uis.InputBegan:connect(function(input1)
					if flyupanddown["Enabled"] and uis:GetFocusedTextBox() == nil then
						if input1.KeyCode == Enum.KeyCode.Space then
							flyup = true
						end
						if input1.KeyCode == Enum.KeyCode.LeftShift then
							flydown = true
						end
					end
				end)
				flyendpress = uis.InputEnded:connect(function(input1)
					if input1.KeyCode == Enum.KeyCode.Space then
						flyup = false
					end
					if input1.KeyCode == Enum.KeyCode.LeftShift then
						flydown = false
					end
				end)
				RunLoops:BindToHeartbeat("Fly", 1, function(delta) 
					if isAlive() then
						local mass = (lplr.Character.HumanoidRootPart:GetMass() - 1.4) * (delta * 100)
						mass = mass + (flytog and -10 or 10)
						if flytogtick <= tick() then
							flytog = not flytog
							flytogtick = tick() + 0.2
						end
						local flypos = lplr.Character.Humanoid.MoveDirection * math.clamp(flyspeed["Value"], 1, 20)
						local flypos2 = (lplr.Character.Humanoid.MoveDirection * math.clamp(flyspeed["Value"] - 20, 0, 1000)) * delta
						lplr.Character.HumanoidRootPart.Transparency = 1
						lplr.Character.HumanoidRootPart.Velocity = flypos + (Vector3.new(0, mass + (flyup and flyverticalspeed["Value"] or 0) + (flydown and -flyverticalspeed["Value"] or 0), 0))
						lplr.Character.HumanoidRootPart.CFrame = lplr.Character.HumanoidRootPart.CFrame + flypos2
						flyvelo = flypos + Vector3.new(0, mass + (flyup and flyverticalspeed["Value"] or 0) + (flydown and -flyverticalspeed["Value"] or 0), 0)
					end
				end)
			else
				flyup = false
				flydown = false
				flypress:Disconnect()
				flyendpress:Disconnect()
				RunLoops:UnbindFromHeartbeat("Fly")
			end
		end,
		["HoverText"] = "Makes you go zoom (Balloons or TNT Required)"
	})
	flyspeed = fly.CreateSlider({
		["Name"] = "Speed",
		["Min"] = 1,
		["Max"] = 38,
		["Function"] = function(val) end, 
		["Default"] = 38
	})
	flyverticalspeed = fly.CreateSlider({
		["Name"] = "Vertical Speed",
		["Min"] = 1,
		["Max"] = 100,
		["Function"] = function(val) end, 
		["Default"] = 44
	})
	flyupanddown = fly.CreateToggle({
		["Name"] = "Y Level",
		["Function"] = function() end, 
		["Default"] = true
	})
end)

local function findfrom(name)
	for i,v in pairs(bedwars["QueueMeta"]) do 
		if v.title == name and i:find("voice") == nil then
			return i
		end
	end
	return "bedwars_to1"
end

local QueueTypes = {}
for i,v in pairs(bedwars["QueueMeta"]) do 
	if v.title:find("Test") == nil then
		table.insert(QueueTypes, v.title..(i:find("voice") and " (VOICE)" or "")) 
	end
end
local JoinQueue = {["Enabled"] = false}
local JoinQueueTypes = {["Value"] = ""}
local JoinQueueDelay = {["Value"] = 1}
local firstqueue = true
JoinQueue = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
	["Name"] = "AutoQueue",
	["Function"] = function(callback)
		if callback then
			spawn(function()
				repeat
					task.wait(JoinQueueDelay["Value"])
					firstqueue = false
					if shared.vapeteammembers and bedwars["ClientStoreHandler"]:getState().Party then
						repeat task.wait() until #bedwars["ClientStoreHandler"]:getState().Party.members >= shared.vapeteammembers or JoinQueue["Enabled"] == false
					end
					if JoinQueue["Enabled"] and JoinQueueTypes["Value"] ~= "" then
						if bedwars["ClientStoreHandler"]:getState().Party.queueState > 0 then
							if newupdate then
								bedwars["LobbyClientEvents"].leaveQueue:fire()
							else
								bedwars["ClientHandler"]:Get("LeaveQueue"):CallServer()
							end
						end
						if bedwars["ClientStoreHandler"]:getState().Party.leader.userId == lplr.UserId and (newupdate and bedwars["LobbyClientEvents"].joinQueue:fire({
							queueType = findfrom(JoinQueueTypes["Value"])
						}) or (not newupdate) and bedwars["ClientHandler"]:Get("JoinQueue"):CallServer({
							queueType = findfrom(JoinQueueTypes["Value"])
						})) then
							if JoinQueue["Enabled"] == false and bedwars["ClientStoreHandler"]:getState().Party.queueState > 0 then
								if newupdate then
									bedwars["LobbyClientEvents"].leaveQueue:fire()
								else
									bedwars["ClientHandler"]:Get("LeaveQueue"):CallServer()
								end
							end
						end
						repeat task.wait() until bedwars["ClientStoreHandler"]:getState().Party.queueState == 3 or JoinQueue["Enabled"] == false
						for i = 1, 10 do
							if JoinQueue["Enabled"] == false then
								break
							end
							task.wait(1)
						end
						if bedwars["ClientStoreHandler"]:getState().Party.queueState > 0 then
							if newupdate then
								bedwars["LobbyClientEvents"].leaveQueue:fire()
							else
								bedwars["ClientHandler"]:Get("LeaveQueue"):CallServer()
							end
						end
					end
				until JoinQueue["Enabled"] == false
			end)
		else
			firstqueue = false
			shared.vapeteammembers = nil
			if bedwars["ClientStoreHandler"]:getState().Party.queueState > 0 then
				if newupdate then
					bedwars["LobbyClientEvents"].leaveQueue:fire()
				else
					bedwars["ClientHandler"]:Get("LeaveQueue"):CallServer()
				end
			end
		end
	end
})
JoinQueueTypes = JoinQueue.CreateDropdown({
	["Name"] = "Mode",
	["List"] = QueueTypes,
	["Function"] = function(val) 
		if JoinQueue["Enabled"] and firstqueue == false then
			JoinQueue["ToggleButton"](false)
			JoinQueue["ToggleButton"](true)
		end
	end
})
JoinQueueDelay = JoinQueue.CreateSlider({
	["Name"] = "Delay",
	["Min"] = 1,
	["Max"] = 10,
	["Function"] = function(val) end,
	["Default"] = 1
})

runcode(function()
	local AutoKitTextList = {["ObjectList"] = {}, ["RefreshValues"] = function() end}

	local function betterfindkit()
		local tab = {}
		local tab2 = {}
		if #AutoKitTextList["ObjectList"] > 0 then
			for i,v in pairs(AutoKitTextList["ObjectList"]) do
				local splitstr = v:split(" : ")
				if #splitstr > 1 then
					tab[tonumber(splitstr[2])] = splitstr[1]:lower()
					if #splitstr > 2 then
						tab2[tonumber(splitstr[2])] = splitstr[3]:lower() == "true"
					end
				end
			end
		else
			tab = {
				[1] = "Trinity",
				[2] = "Grim Reaper",
				[3] = "Infernal Shielder",
				[4] = "Eldertree",
				[5] = "Barbarian",
				[6] = "Melody",
				[7] = "Baker"
			}
			tab2 = {}
		end
		return tab, tab2
	end

	local AutoKit = {["Enabled"] = false}
	local ownedkits = {}
	local ownedkitsamount = 0
	for i3,v3 in pairs(bedwars["BedwarsKits"].FreeKits) do
		ownedkitsamount = ownedkitsamount + 1
		ownedkits[bedwars["KitMeta"][v3].name:lower()] = v3
	end
	AutoKit = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "AutoKit",
		["Function"] = function(callback)
			if callback then
				spawn(function()
					repeat task.wait() until ownedkitsamount > 0
					local tab, tab2 = betterfindkit()
					for i = 1, #tab do
						local v = tab[i]
						if ownedkits[v:lower()] then
							bedwars["ClientHandler"]:Get("BedwarsActivateKit"):CallServerAsync({
								kit = ownedkits[v:lower()]
							})
							bedwars["ClientHandler"]:Get("BedwarsSetUseKitSkin"):CallServerAsync({
								useKitSkin = tab2[i] and true or false
							})
							return
						end
					end
					local rand = math.random(1, ownedkitsamount)
					local ownedkitsnum = 0
					for i2,v2 in pairs(ownedkits) do
						ownedkitsnum = ownedkitsnum + 1
						if ownedkitsnum == rand then
							bedwars["ClientHandler"]:Get("BedwarsActivateKit"):CallServerAsync({
								kit = v2
							})
							bedwars["ClientHandler"]:Get("BedwarsSetUseKitSkin"):CallServerAsync({
								useKitSkin = false
							})
						end
					end
				end)
			end
		end,
		["HoverText"] = "Automatically Equips kits in a list."
	})
	AutoKitTextList = AutoKit.CreateTextList({
		["Name"] = "KitList",
		["TempText"] = "kit name : prio : kitskin",
	})
end)

runcode(function()
	local CameraFix = {["Enabled"] = false}
	CameraFix = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "CameraFix",
		["Function"] = function(callback)
			if callback then
				spawn(function()
					repeat
						task.wait()
						if (not CameraFix["Enabled"]) then break end
						UserSettings():GetService("UserGameSettings").RotationType = ((cam.CFrame.Position - cam.Focus.Position).Magnitude <= 0.5 and Enum.RotationType.CameraRelative or Enum.RotationType.MovementRelative)
					until (not CameraFix["Enabled"])
				end)
			end
		end,
		["HoverText"] = "Fixes third person camera face bug"
	})
end)

local AnticheatBypass = {["Enabled"] = false}
local Scaffold = {["Enabled"] = false}
local longjump = {["Enabled"] = false}
local flyvelo
GuiLibrary["RemoveObject"]("SpeedOptionsButton")
runcode(function()
	local speedmode = {["Value"] = "Normal"}
	local speedval = {["Value"] = 1}
	local speedjump = {["Enabled"] = false}
	local speedjumpheight = {["Value"] = 20}
	local speedjumpalways = {["Enabled"] = false}
	local speedspeedup = {["Enabled"] = false}
	local speedanimation = {["Enabled"] = false}
	local speedtick = tick()
	local bodyvelo
	local raycastparameters = RaycastParams.new()
	speed = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Speed",
		["Function"] = function(callback)
			if callback then
				task.spawn(function()
					repeat task.wait() until shared.VapeFullyLoaded
					if speed["Enabled"] then
						if AnticheatBypass["Enabled"] == false and GuiLibrary["ObjectsThatCanBeSaved"]["Blatant modeToggle"]["Api"]["Enabled"] == false then
							AnticheatBypass["ToggleButton"](false)
						end
					end
				end)
				local lastnear = false
				RunLoops:BindToHeartbeat("Speed", 1, function(delta)
					if entity.isAlive and (GuiLibrary["ObjectsThatCanBeSaved"]["Lobby CheckToggle"]["Api"]["Enabled"] == false or matchState ~= 0) then
						if speedanimation["Enabled"] then
							for i,v in pairs(entity.character.Humanoid:GetPlayingAnimationTracks()) do
								if v.Name == "WalkAnim" or v.Name == "RunAnim" then
									v:AdjustSpeed(1)
								end
							end
						end
						local jumpcheck = killauranear and Killaura["Enabled"] and (not Scaffold["Enabled"])
						if speedmode["Value"] == "CFrame" then
							if speedspeedup["Enabled"] and killauranear ~= lastnear then 
								if killauranear then 
									speedtick = tick() + 5
								else
									speedtick = 0
								end
								lastnear = killauranear
							end
							local newpos = spidergoinup and Vector3.zero or ((entity.character.Humanoid.MoveDirection * (((speedval["Value"] + (speedspeedup["Enabled"] and killauranear and speedtick >= tick() and (48 - speedval["Value"]) or 0))) - 20))) * delta * (GuiLibrary["ObjectsThatCanBeSaved"]["FlyOptionsButton"]["Api"]["Enabled"] and 0 or 1)
							local movevec = entity.character.Humanoid.MoveDirection.Unit * 20
							movevec = movevec == movevec and movevec or Vector3.zero
							local velocheck = not (longjump["Enabled"] and newlongjumpvelo == Vector3.zero)
							raycastparameters.FilterDescendantsInstances = {lplr.Character}
							local ray = workspace:Raycast(entity.character.HumanoidRootPart.Position, newpos, raycastparameters)
							if ray then newpos = (ray.Position - entity.character.HumanoidRootPart.Position) end
							if networkownerfunc and networkownerfunc(entity.character.HumanoidRootPart) or networkownerfunc == nil then
								entity.character.HumanoidRootPart.CFrame = entity.character.HumanoidRootPart.CFrame + newpos
								entity.character.HumanoidRootPart.Velocity = Vector3.new(velocheck and movevec.X or 0, entity.character.HumanoidRootPart.Velocity.Y, velocheck and movevec.Z or 0)
							end
						else
							if (bodyvelo == nil or bodyvelo ~= nil and bodyvelo.Parent ~= entity.character.HumanoidRootPart) then
								bodyvelo = Instance.new("BodyVelocity")
								bodyvelo.Parent = entity.character.HumanoidRootPart
								bodyvelo.MaxForce = Vector3.new(100000, 0, 100000)
							else
								bodyvelo.MaxForce = ((entity.character.Humanoid:GetState() == Enum.HumanoidStateType.Climbing or entity.character.Humanoid.Sit or spidergoinup or GuiLibrary["ObjectsThatCanBeSaved"]["FlyOptionsButton"]["Api"]["Enabled"] or uninjectflag) and Vector3.zero or (longjump["Enabled"] and Vector3.new(100000, 0, 100000) or Vector3.new(100000, 0, 100000)))
								bodyvelo.Velocity = longjump["Enabled"] and longjumpvelo or entity.character.Humanoid.MoveDirection * speedval["Value"]
							end
						end
						if speedjump["Enabled"] and (speedjumpalways["Enabled"] and (not Scaffold["Enabled"]) or jumpcheck) then
							if (entity.character.Humanoid.FloorMaterial ~= Enum.Material.Air) and entity.character.Humanoid.MoveDirection ~= Vector3.zero then
								entity.character.HumanoidRootPart.Velocity = Vector3.new(entity.character.HumanoidRootPart.Velocity.X, speedjumpheight["Value"], entity.character.HumanoidRootPart.Velocity.Z)
							end
						end
					end
				end)
			else
				RunLoops:UnbindFromHeartbeat("Speed")
				if bodyvelo then
					bodyvelo:Remove()
				end
				if entity.isAlive then 
					for i,v in pairs(entity.character.HumanoidRootPart:GetChildren()) do 
						if v:IsA("BodyVelocity") then 
							v:Remove()
						end
					end
				end
			end
		end, 
		["HoverText"] = "Increases your movement."
	})
	speedmode = speed.CreateDropdown({
		["Name"] = "Mode",
		["List"] = {"Normal", "CFrame"},
		["Function"] = function(val)
			if speedspeedup["Object"] then 
				speedspeedup["Object"].Visible = val == "CFrame"
			end
			if bodyvelo then
				bodyvelo:Remove()
			end	
		end
	})
	speedval = speed.CreateSlider({
		["Name"] = "Speed",
		["Min"] = 1,
		["Max"] = 54,
		["Function"] = function(val) end,
		["Default"] = 54
	})
	speedjumpheight = speed.CreateSlider({
		["Name"] = "Jump Height",
		["Min"] = 0,
		["Max"] = 30,
		["Default"] = 25,
		["Function"] = function() end
	})
	speedjump = speed.CreateToggle({
		["Name"] = "AutoJump", 
		["Function"] = function(callback) 
			if speedjumpalways["Object"] then
				speedjump["Object"].ToggleArrow.Visible = callback
				speedjumpalways["Object"].Visible = callback
			end
		end,
		["Default"] = true
	})
	speedjumpalways = speed.CreateToggle({
		["Name"] = "Always Jump",
		["Function"] = function() end
	})
	speedspeedup = speed.CreateToggle({
		["Name"] = "Speedup",
		["Function"] = function() end,
		["HoverText"] = "Speeds up when using killaura."
	})
	speedspeedup["Object"].Visible = speedmode["Value"] == "CFrame"
	speedanimation = speed.CreateToggle({
		["Name"] = "Slowdown Anim",
		["Function"] = function() end
	})
	speedjumpalways["Object"].BackgroundTransparency = 0
	speedjumpalways["Object"].BorderSizePixel = 0
	speedjumpalways["Object"].BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	speedjumpalways["Object"].Visible = speedjump["Enabled"]
end)

runcode(function()
	local Disguise = {["Enabled"] = false}
	local DisguiseId = {["Value"] = ""}
	local desc
	
	local function disguisechar(char)
		task.spawn(function()
			if not char then return end
			char:WaitForChild("Humanoid")
			char:WaitForChild("Head")
			if desc == nil then
				desc = players:GetHumanoidDescriptionFromUserId(DisguiseId["Value"] == "" and 239702688 or tonumber(DisguiseId["Value"]))
			end
			desc.HeightScale = char.Humanoid.HumanoidDescription.HeightScale
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
			char.ChildAdded:connect(function(v)
				if ((v:IsA("Accessory") and v:GetAttribute("InvItem") == nil and v:GetAttribute("ArmorSlot") == nil) or v:IsA("ShirtGraphic") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("BodyColors")) and v:GetAttribute("Disguise") == nil then 
					repeat task.wait() v.Parent = game until v.Parent == game
				end
			end)
			for i,v in pairs(disguiseclone.Animate:GetChildren()) do 
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
			char.Humanoid.HumanoidDescription:SetEmotes(desc:GetEmotes())
			char.Humanoid.HumanoidDescription:SetEquippedEmotes(desc:GetEquippedEmotes())
			disguiseclone:Destroy()
		end)
	end

	local disguiseconnection
	Disguise = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Disguise",
		["Function"] = function(callback)
			if callback then 
				disguiseconnection = lplr.CharacterAdded:connect(disguisechar)
				disguisechar(lplr.Character)
			else
				if disguiseconnection then 
					disguiseconnection:Disconnect()
				end
			end
		end
	})
	DisguiseId = Disguise.CreateTextBox({
		["Name"] = "Disguise",
		["TempText"] = "Disguise User Id",
		["FocusLost"] = function(enter) 
			task.spawn(function() desc = players:GetHumanoidDescriptionFromUserId(DisguiseId["Value"] == "" and 239702688 or tonumber(DisguiseId["Value"])) end)
		end
	})
end)

runcode(function()
	local AnticheatBypassTransparent = {["Enabled"] = false}
	local AnticheatBypassAlternate = {["Enabled"] = false}
	local AnticheatBypassNotification = {["Enabled"] = false}
	local AnticheatBypassAnimation = {["Enabled"] = true}
	local AnticheatBypassAnimationCustom = {["Value"] = ""}
	local AnticheatBypassDisguise = {["Enabled"] = false}
	local AnticheatBypassDisguiseCustom = {["Value"] = ""}
	local AnticheatBypassArrowDodge = {["Enabled"] = false}
	local AnticheatBypassAutoConfig = {["Enabled"] = false}
	local AnticheatBypassAutoConfigBig = {["Enabled"] = false}
	local AnticheatBypassAutoConfigSpeed = {["Value"] = 54}
	local AnticheatBypassAutoConfigSpeed2 = {["Value"] = 54}
	local AnticheatBypassTPSpeed = {["Value"] = 13}
	local AnticheatBypassTPLerp = {["Value"] = 50}
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
		repeat task.wait() until entity.isAlive
		if not AnticheatBypass["Enabled"] then doing = false return end
		oldcloneroot = entity.character.HumanoidRootPart
		lplr.Character.Parent = game
		clone = oldcloneroot:Clone()
		clone.Parent = lplr.Character
		oldcloneroot.Parent = cam
		bedwars["QueryUtil"]:setQueryIgnored(oldcloneroot, true)
		oldcloneroot.Transparency = AnticheatBypassTransparent["Enabled"] and 1 or 0
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
		bodyvelo.MaxForce = vec3(0, 100000, 0)
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
					local sit = entity.character.Humanoid.Sit
					if sit ~= oldseat then 
						oldseat = sit	
					end
					local targetvelo = (clone.AssemblyLinearVelocity)
					local speed = (sit and targetvelo.Magnitude or 20 * getSpeedMultiplier())
					targetvelo = (targetvelo.Unit == targetvelo.Unit and targetvelo.Unit or Vector3.zero) * speed
					bodyvelo.Velocity = vec3(0, clone.Velocity.Y, 0)
					oldcloneroot.Velocity = vec3(math.clamp(targetvelo.X, -speed, speed), clone.Velocity.Y, math.clamp(targetvelo.Z, -speed, speed))
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
			return #fpslist > 0 and (frames / (60 * #fpslist)) <= 1.2 or #fpslist <= 0 or AnticheatBypassAlternate["Enabled"]
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
			for i,v in pairs(game:GetService("CollectionService"):GetTagged("LassoHooked")) do 
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
				if (not AnticheatBypass["Enabled"]) then break end
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
			until (not AnticheatBypass["Enabled"])
		end)
		if anticheatconnection2 then anticheatconnection2:Disconnect() end
		anticheatconnection2 = lplr:GetAttributeChangedSignal("LastTeleported"):connect(function()
			if not AnticheatBypass["Enabled"] then if anticheatconnection2 then anticheatconnection2:Disconnect() end end
			if not (clone and oldcloneroot) then return end
			clone.CFrame = oldcloneroot.CFrame
		end)
		shared.VapeRealCharacter = {
			Humanoid = entity.character.Humanoid,
			Head = entity.character.Head,
			HumanoidRootPart = oldcloneroot
		}
		if shared.VapeOverrideAnticheatBypassPre then 
			shared.VapeOverrideAnticheatBypassPre(lplr.Character)
		end
		repeat
			task.wait()
			if entity.isAlive then
				local oldroot = oldcloneroot
				if oldroot then
					local cloneroot = clone
					if cloneroot then
						if oldroot.Parent ~= nil and ((networkownerfunc and (not networkownerfunc(oldroot)) or networkownerfunc == nil and gethiddenproperty(oldroot, "NetworkOwnershipRule") == Enum.NetworkOwnership.Manual)) then
							if amountoftimes ~= 0 then
								amountoftimes = 0
							end
							if not lagbackchanged then
								lagbackchanged = true
								lagbacktime = tick()
								task.spawn(function()
									local pingspike = didpingspike() 
									if pingspike then
										if AnticheatBypassNotification["Enabled"] then
											createwarning("AnticheatBypass", "Lagspike Detected : "..pingspike, 10)
										end
									else
										if matchState ~= 2 and notlasso() and (not recenttp) then
											lagbacks = lagbacks + 1
										end
									end
									task.spawn(function()
										if AnticheatBypass["Enabled"] then
											AnticheatBypass["ToggleButton"](false)
										end
										local oldclonecharcheck = lplr.Character
										repeat task.wait() until lplr.Character == nil or lplr.Character.Parent == nil or oldclonecharcheck ~= lplr.Character or networkownerfunc(oldroot)
										if AnticheatBypass["Enabled"] == false then
											AnticheatBypass["ToggleButton"](false)
										end
									end)
								end)
							end
							if (tick() - lagbacktime) >= 10 and (not lagbacknotification) then
								lagbacknotification = true
								createwarning("AnticheatBypass", "You have been lagbacked for a \nawfully long time", 10)
							end
							cloneroot.Velocity = Vector3.zero
							oldroot.Velocity = Vector3.zero
							cloneroot.CFrame = oldroot.CFrame
						else
							lagbackchanged = false
							lagbacknotification = false
							if not shared.VapeOverrideAnticheatBypass then
								if (not disabletpcheck) and entity.character.Humanoid.Sit ~= true then
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
												if (vec3(0, oldroot.CFrame.p.Y, 0) - vec3(0, cloneroot.CFrame.p.Y, 0)).magnitude <= 1 then
													oldroot.CFrame = finishcframe(oldroot.CFrame:lerp(addvectortocframe2(cloneroot.CFrame, oldroot.CFrame.p.Y), framerate))
												else
													oldroot.CFrame = finishcframe(oldroot.CFrame:lerp(cloneroot.CFrame, framerate))
												end
											end
										end
										check()
									end
									check()
									task.wait(combatcheck and AnticheatBypassCombatCheck["Enabled"] and AnticheatBypassNumbers.TPCombat or framerate2)
									check()
									if oldroot and cloneroot then
										if (oldroot.CFrame.p - cloneroot.CFrame.p).magnitude >= 0.01 then
											if (vec3(0, oldroot.CFrame.p.Y, 0) - vec3(0, cloneroot.CFrame.p.Y, 0)).magnitude <= 1 then
												oldroot.CFrame = finishcframe(addvectortocframe2(cloneroot.CFrame, oldroot.CFrame.p.Y))
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
		until AnticheatBypass["Enabled"] == false or oldcloneroot == nil or oldcloneroot.Parent == nil 
	end

	local spawncoro
	local function anticheatbypassenable()
		task.spawn(function()
			if spawncoro then return end
			spawncoro = true
			allowspeed = false
			shared.VapeRealCharacter = nil
			repeat task.wait() until entity.isAlive
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
		anticheatconnection = lplr.CharacterAdded:connect(function(char)
			task.spawn(function()
				if spawncoro then return end
				spawncoro = true
				allowspeed = false
				shared.VapeRealCharacter = nil
				repeat task.wait() until entity.isAlive
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

	AnticheatBypass = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
		["Name"] = "AnticheatBypass",
		["Function"] = function(callback)
			if callback then
				task.spawn(function()
					anticheatbypassenable()
				end)
			else
				if anticheatconnection then 
					anticheatconnection:Disconnect()
				end
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
		["HoverText"] = "Makes speed check more stupid.\n(thank you to MicrowaveOverflow.cpp#7030 for no more clone crap)",
	})
	local arrowdodgeconnection
	local arrowdodgedata
	
--[[	AnticheatBypassArrowDodge = AnticheatBypass.CreateToggle({
		["Name"] = "Arrow Dodge",
		["Function"] = function(callback)
			if callback then
				task.spawn(function()
					bedwars["ClientHandler"]:WaitFor("ProjectileLaunch"):andThen(function(p6)
						arrowdodgeconnection = p6:Connect(function(data)
							if oldchar and clone and AnticheatBypass["Enabled"] and (arrowdodgedata == nil or arrowdodgedata.launchVelocity ~= data.launchVelocity) and entity.isAlive and tostring(data.projectile):find("arrow") then
								arrowdodgedata = data
								local projmetatab = bedwars["ProjectileMeta"][tostring(data.projectile)]
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
		["Default"] = true,
		["HoverText"] = "Dodge arrows (tanqr moment)"
	})]]
	AnticheatBypassAlternate = AnticheatBypass.CreateToggle({
		["Name"] = "Alternate Numbers",
		["Function"] = function() end
	})
	AnticheatBypassTransparent = AnticheatBypass.CreateToggle({
		["Name"] = "Transparent",
		["Function"] = function(callback) 
			if oldcloneroot and AnticheatBypass["Enabled"] then
				oldcloneroot.Transparency = callback and 1 or 0
			end
		end,
		["Default"] = true
	})
	AnticheatBypassFlagCheck = AnticheatBypass.CreateToggle({
		["Name"] = "Flag Check",
		["Function"] = function(callback) end,
		["Default"] = true
	})
	local changecheck = false
--[[	AnticheatBypassCombatCheck = AnticheatBypass.CreateToggle({
		["Name"] = "Combat Check",
		["Function"] = function(callback) 
			if callback then 
				task.spawn(function()
					repeat 
						task.wait(0.1)
						if (not AnticheatBypassCombatCheck["Enabled"]) then break end
						if AnticheatBypass["Enabled"] then 
							local plrs = GetAllNearestHumanoidToPosition(true, 30, 1)
							combatcheck = #plrs > 0 and (not GuiLibrary["ObjectsThatCanBeSaved"]["LongJumpOptionsButton"]["Api"]["Enabled"]) and (not GuiLibrary["ObjectsThatCanBeSaved"]["FlyOptionsButton"]["Api"]["Enabled"])
							if combatcheck ~= changecheck then 
								if not combatcheck then 
									combatchecktick = tick() + 1
								end
								changecheck = combatcheck
							end
						end
					until (not AnticheatBypassCombatCheck["Enabled"])
				end)
			else
				combatcheck = false
			end
		end,
		["Default"] = true
	})]]
	AnticheatBypassNotification = AnticheatBypass.CreateToggle({
		["Name"] = "Notifications",
		["Function"] = function() end,
		["Default"] = true
	})
	if shared.VapeDeveloper then 
		AnticheatBypassTPSpeed = AnticheatBypass.CreateSlider({
			["Name"] = "TPSpeed",
			["Function"] = function(val) 
				AnticheatBypassNumbers.TPSpeed = val / 100
			end,
			["Double"] = 100,
			["Min"] = 1,
			["Max"] = 100,
			["Default"] = AnticheatBypassNumbers.TPSpeed * 100,
		})
		AnticheatBypassTPLerp = AnticheatBypass.CreateSlider({
			["Name"] = "TPLerp",
			["Function"] = function(val) 
				AnticheatBypassNumbers.TPLerp = val / 100
			end,
			["Double"] = 100,
			["Min"] = 1,
			["Max"] = 100,
			["Default"] = AnticheatBypassNumbers.TPLerp * 100,
		})
	end
end)

runcode(function()
	local tpstring = shared.vapeoverlay or nil
	local origtpstring = tpstring
	local Overlay = GuiLibrary.CreateCustomWindow({
		["Name"] = "Overlay", 
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
	GuiLibrary["UpdateUI"] = function(...)
		overlayframe2.BackgroundColor3 = Color3.fromHSV(GuiLibrary["Settings"]["GUIObject"]["Color"], 0.7, 0.9)
		return oldguiupdate(...)
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
	local mapname = "Lobby"
	GuiLibrary["ObjectsThatCanBeSaved"]["GUIWindow"]["Api"].CreateCustomToggle({
		["Name"] = "Overlay", 
		["Icon"] = "vape/assets/TargetIcon1.png", 
		["Function"] = function(callback)
			Overlay.SetVisible(callback) 
			if callback then
				task.spawn(function()
					repeat
						wait(1)
						if not tpstring then
							tpstring = tick().."/0/0/0/0/0/0"
							origtpstring = tpstring
						end
						local splitted = origtpstring:split("/")
						label.Text = "Session Info\nTime Played : "..os.date("!%X",math.floor(tick() - splitted[1])).."\nKills : "..(splitted[2]).."\nBeds : "..(splitted[3]).."\nWins : "..(splitted[4]).."\nGames : "..splitted[5].."\nLagbacks : "..(splitted[6]).."\nReported : "..(splitted[7]).."\nMap : "..mapname
						local textsize = textservice:GetTextSize(label.Text, label.TextSize, label.Font, Vector2.new(100000, 100000))
						overlayframe.Size = UDim2.new(0, math.clamp(textsize.X, 200, 10000), 0, (textsize.Y * 1.2) + 10)
						tpstring = splitted[1].."/"..(splitted[2]).."/"..(splitted[3]).."/"..(splitted[4]).."/"..(splitted[5]).."/"..(splitted[6]).."/"..(splitted[7])
					until (Overlay and Overlay.GetCustomChildren() and Overlay.GetCustomChildren().Parent and Overlay.GetCustomChildren().Parent.Visible == false)
				end)
			end
		end, 
		["Priority"] = 2
	})
end)

spawn(function()
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
		notifyframereal.MouseButton1Click:connect(function()
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
					Text = "Vape is currently disabled, check the discord for updates discord.gg/vxpe",
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
					Text = "Vape is currently disabled, check the discord for updates discord.gg/vxpe",
					Duration = 30,
				})
			end
			if datatab.KickUsers and datatab.KickUsers[tostring(lplr.UserId)] then
				lplr:Kick(datatab.KickUsers[tostring(lplr.UserId)])
			end
			if newdatatab.Announcement and newdatatab.Announcement.ExpireTime >= os.time() then 
				spawn(function()
					createannouncement(newdatatab.Announcement)
				end)
			end
		end
	end

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

if shared.nobolineupdate then
	spawn(function()
		repeat
			task.wait()
			if GuiLibrary["MainGui"].Parent ~= nil then
				GuiLibrary["MainGui"].ScaledGui.Visible = false
				GuiLibrary["MainGui"].ScaledGui.ClickGui.Visible = false
				GuiLibrary["MainBlur"].Enabled = false
			else
				break
			end
		until true == false
	end)
	runcode(function()
		local function removeTags(str)
			str = str:gsub("<br%s*/>", "\n")
			str = str:gsub("Vape", "Noboline")
			str = str:gsub("vape", "noboline")
			return (str:gsub("<[^<>]->", ""))
		end
		GuiLibrary["CreateNotification"] = function(top, bottom, duration, customicon)
			game:GetService("StarterGui"):SetCore("SendNotification", {
				Title = "Noboline",
				Text = removeTags(bottom),
				Duration = duration,
			})
		end
	end)
	spawn(function()
		local function isblatant()
			return GuiLibrary["ObjectsThatCanBeSaved"]["SpeedOptionsButton"]["Api"]["Enabled"] or GuiLibrary["ObjectsThatCanBeSaved"]["SpeedOptionsButton"]["Api"]["Keybind"] ~= ""
		end
		task.wait(2)
		local ImageLabel = Instance.new("ImageLabel")
		ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ImageLabel.BackgroundTransparency = 1.000
		ImageLabel.BorderSizePixel = 0
		ImageLabel.Position = UDim2.new(0.5, -120, 0.5, -120)
		ImageLabel.Size = UDim2.new(0, 240, 0, 240)
		ImageLabel.ImageTransparency = 1
		ImageLabel.Image = "http://www.roblox.com/asset/?id=7211055081"
		ImageLabel.Parent = GuiLibrary["MainGui"]
		ImageLabel.Visible = isblatant()
		local TextMessage = Instance.new("TextLabel")
		TextMessage.TextSize = 24
		TextMessage.Font = Enum.Font.SourceSans
		TextMessage.TextStrokeTransparency = 0
		TextMessage.Text = ""
		TextMessage.TextColor3 = Color3.new(1, 1, 1)
		TextMessage.Position = UDim2.new(0.5, 0, 1, 20)
		TextMessage.TextStrokeColor3 = Color3.fromRGB(0,0,0)
		TextMessage.Parent = ImageLabel
		TextMessage.Visible = isblatant()
		for i = 1, 0, -0.1 do 
			wait(0.05)
			ImageLabel.ImageTransparency = i
		end
		task.wait(0.2)
		TextMessage.Text = "Loading dependencies..."
		task.wait(1)
		TextMessage.Text = "Loading tables..."
		task.wait(3)
		TextMessage:Remove()
		ImageLabel:Remove()
		local kavo = loadstring(GetURL("Libraries/kavo.lua"))()
		local window = kavo.CreateLib("Noboline v1.6.2"..(shared.VapePrivate and " - PRIVATE" or ""), "Ocean")
		local realgui = game:GetService("CoreGui")[debug.getupvalue(kavo.ToggleUI, 1)]
		if not is_sirhurt_closure and syn and syn.protect_gui then
			syn.protect_gui(realgui)
		elseif gethui then
			realgui.Parent = gethui()
		end
		fakeuiconnection = uis.InputBegan:connect(function(input1)
			if uis:GetFocusedTextBox() == nil then
				if input1.KeyCode == Enum.KeyCode[GuiLibrary["GUIKeybind"]] and GuiLibrary["KeybindCaptured"] == false then
					realgui.Enabled = not realgui.Enabled
					uis.OverrideMouseIconBehavior = (realgui.Enabled and Enum.OverrideMouseIconBehavior.ForceShow or game:GetService("VRService").VREnabled and Enum.OverrideMouseIconBehavior.ForceHide or Enum.OverrideMouseIconBehavior.None)
				end
			end
		end)
		realgui.Enabled = isblatant()
		game.CoreGui.ChildRemoved:connect(function(obj)
			if obj == realgui then
				GuiLibrary["SelfDestruct"]()
			end
		end)
		local windowtabs = {
			Combat = window:NewTab("Combat"),
			Blatant = window:NewTab("Blatant"),
			Render = window:NewTab("Render"),
			Utility = window:NewTab("Utility"),
			World = window:NewTab("World")
		}
		local windowsections = {}
		local tab = {}
		local tab2 = {}
		for i,v in pairs(GuiLibrary["ObjectsThatCanBeSaved"]) do 
			if v.Type == "OptionsButton" then
				table.insert(tab, v)
			end
			if v.Type == "Toggle" then
				table.insert(tab2, v)
			end
			if v.Type == "Slider" then
				table.insert(tab2, v)
			end
			if v.Type == "Dropdown" then
				table.insert(tab2, v)
			end
			if v.Type == "ColorSlider" then
				table.insert(tab2, v)
			end
		end
		table.sort(tab, function(a, b) 
			if a.Type ~= "OptionsButton" then
				a = {Object = {Name = tostring(a["Object"].Parent):gsub("Children", "")..a["Object"].Name}}
			else
				a = {Object = {Name = a["Object"].Name}}
			end
			if b.Type ~= "OptionsButton" then
				b = {Object = {Name = tostring(b["Object"].Parent):gsub("Children", "")..b["Object"].Name}}
			else
				b = {Object = {Name = b["Object"].Name}}
			end
			return a["Object"].Name:lower() < b["Object"].Name:lower() 
		end)
		table.sort(tab2, function(a, b) 
			a = {Object = {Name = tostring(a["Object"].Parent):gsub("Children", "")..a["Object"].Name}}
			b = {Object = {Name = tostring(b["Object"].Parent):gsub("Children", "")..b["Object"].Name}}
			return a["Object"].Name:lower() < b["Object"].Name:lower() 
		end)
		for i,v in pairs(tab) do 
			if v.Type == "OptionsButton" then 
				local old = v["Api"]["ToggleButton"]
				local newstr = tostring(v["Object"]):gsub("Button", "")
				windowsections[newstr] = windowtabs[tostring(v["Object"].Parent.Parent)]:NewSection(newstr)
				local tog = windowsections[newstr]:NewToggle(newstr, "", function(callback)
					if callback ~= v["Api"]["Enabled"] then
						old(true)
					end
				end)
				local keybind = windowsections[newstr]:NewKeybind("Keybind", "", {Name = v["Api"]["Keybind"] ~= "" and v["Api"]["Keybind"] or "None"}, function(key)
					GuiLibrary["KeybindCaptured"] = true
					v["Api"]["SetKeybind"](key == "None" and "" or key)
					task.delay(0.1, function() GuiLibrary["KeybindCaptured"] = false end)
				end)
				v["Api"]["ToggleButton"] = function(clicked, toggle)
					local res = old(clicked, toggle)
					tog:UpdateToggle(tostring(v["Object"]):gsub("Button", ""), v["Api"]["Enabled"])
					return res
				end
				tog:UpdateToggle(tostring(v["Object"]):gsub("Button", ""), v["Api"]["Enabled"])
			end
		end
		for i,v in pairs(tab2) do 
			if v.Type == "Toggle" and tostring(v["Object"].Parent.Parent.Parent) ~= "ClickGui" and GuiLibrary["ObjectsThatCanBeSaved"][tostring(v["Object"].Parent):gsub("Children", "OptionsButton")] and GuiLibrary["ObjectsThatCanBeSaved"][tostring(v["Object"].Parent):gsub("Children", "OptionsButton")]["ChildrenObject"] == v["Object"].Parent then
				local newstr = tostring(v["Object"].Parent):gsub("Children", "")
				local old = v["Api"]["ToggleButton"]
				local tog = windowsections[newstr]:NewToggle(tostring(v["Object"]):gsub("Button", ""), "", function(callback)
					if callback ~= v["Api"]["Enabled"] then
						old(true)
					end
				end)
				v["Api"]["ToggleButton"] = function(clicked, toggle)
					local res = old(clicked, toggle)
					tog:UpdateToggle(tostring(v["Object"]):gsub("Button", ""), v["Api"]["Enabled"])
					return res
				end
				tog:UpdateToggle(tostring(v["Object"]):gsub("Button", ""), v["Api"]["Enabled"])
			end
			if v.Type == "Slider" and GuiLibrary["ObjectsThatCanBeSaved"][tostring(v["Object"].Parent):gsub("Children", "OptionsButton")] and GuiLibrary["ObjectsThatCanBeSaved"][tostring(v["Object"].Parent):gsub("Children", "OptionsButton")]["ChildrenObject"] == v["Object"].Parent then
				local newstr = tostring(v["Object"].Parent):gsub("Children", "")
				local old = v["Api"]["SetValue"]
				local slider = windowsections[newstr]:NewSlider(v["Object"].Name, "", v["Api"]["Max"], v["Api"]["Min"], function(s) -- 500 (MaxValue) | 0 (MinValue)
					if s ~= v["Api"]["Value"] then
						old(s)
					end
				end)
				v["Api"]["SetValue"] = function(value, ...)
					local res = old(value, ...)
					slider:UpdateSlider(value)
					return res
				end
				v["Api"]["SetValue"](tonumber(v["Api"]["Value"]))
			end
			if v.Type == "ColorSlider" and GuiLibrary["ObjectsThatCanBeSaved"][tostring(v["Object"].Parent):gsub("Children", "OptionsButton")] and GuiLibrary["ObjectsThatCanBeSaved"][tostring(v["Object"].Parent):gsub("Children", "OptionsButton")]["ChildrenObject"] == v["Object"].Parent then
				local newstr = tostring(v["Object"].Parent):gsub("Children", "")
				local old = v["Api"]["SetValue"]
				v["Api"]["RainbowValue"] = false
				local slider = windowsections[newstr]:NewColorPicker(v["Object"].Name, "", Color3.fromHSV(v["Api"]["Hue"], v["Api"]["Sat"], v["Api"]["Value"]), function(col) -- 500 (MaxValue) | 0 (MinValue)
					old(col:ToHSV())
				end)
				--v["Api"]["SetValue"](v["Api"]["Hue"], v["Api"]["Sat"], v["Api"]["Value"])
			end
			if v.Type == "Dropdown" and GuiLibrary["ObjectsThatCanBeSaved"][tostring(v["Object"].Parent):gsub("Children", "OptionsButton")] and GuiLibrary["ObjectsThatCanBeSaved"][tostring(v["Object"].Parent):gsub("Children", "OptionsButton")]["ChildrenObject"] == v["Object"].Parent then
				local newstr = tostring(v["Object"].Parent):gsub("Children", "")
				local old = v["Api"]["SetValue"]
				local dropdown = windowsections[newstr]:NewDropdown(v["Object"].Name, "", debug.getupvalue(v["Api"]["SetValue"], 4)["List"], function(currentOption)
					if currentOption ~= v["Api"]["Value"] then
						v["Api"]["SetValue"](currentOption)
					end
				end)
				dropdown:SetValue(v["Api"]["Value"])
				--v["Api"]["SetValue"](v["Api"]["Hue"], v["Api"]["Sat"], v["Api"]["Value"])
			end
		end
		--windowsections.Combat:NewToggle("a", "", function(callback)
	--		print(callback, "yes")
		--end)
	end)
end