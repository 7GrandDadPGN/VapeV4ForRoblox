--[[ 
	Credits
	Infinite Yield - Blink
	DevForum - lots of rotation math because I hate it
	Please notify me if you need credits
]]
local GuiLibrary = shared.GuiLibrary
local players = game:GetService("Players")
local textservice = game:GetService("TextService")
local lplr = players.LocalPlayer
local lighting = game:GetService("Lighting")
local cam = workspace.CurrentCamera
workspace:GetPropertyChangedSignal("CurrentCamera"):connect(function()
	cam = (workspace.CurrentCamera or workspace:FindFirstChild("Camera") or Instance.new("Camera"))
end)
local targetinfo = shared.VapeTargetInfo
local collectionservice = game:GetService("CollectionService")
local uis = game:GetService("UserInputService")
local mouse = lplr:GetMouse()
local prophunt = {}
local getfunctions
local oldchar
local matchState = 0
local kit = ""
local antivoidypos = 0
local kills = 0
local beds = 0
local lagbacks = 0
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
local queueteleport = syn and syn.queue_on_teleport or queue_on_teleport or fluxus and fluxus.queue_on_teleport or function() end
local teleportfunc
local getasset = getsynasset or getcustomasset or function(location) return "rbxasset://"..location end
local ownedkits = {}
local storedshahashes = {}
local oldattack
local oldshoot
local oldbuyitem
local chatconnection
local blocktable
local RenderStepTable = {}
local StepTable = {}
local Hitboxes = {["Enabled"] = false}
local Reach = {["Enabled"] = false}
local Killaura = {["Enabled"] = false}
local nobob = {["Enabled"] = false}
local AnticheatBypass = {["Enabled"] = false}
local AnticheatBypassCombatCheck = {["Enabled"] = false}
local disabletpcheck = false
local oldbob
local oldbreakremote
local FastConsume = {["Enabled"] = false}
local autohealconnection
local chatconnection2
local oldchanneltab
local oldchannelfunc
local oldchanneltabs = {}
local connectionstodisconnect = {}
local anticheatfunny = false
local anticheatfunnyyes = false
local staffleave
local tpstring
local networkownerfunc = isnetworkowner
local vapeusers = {}
local function GetURL(scripturl)
	if shared.VapeDeveloper then
		return readfile("vape/"..scripturl)
	else
		return game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/"..scripturl, true)
	end
end
local shalib = loadstring(GetURL("Libraries/sha.lua"))()
local entity = loadstring(GetURL("Libraries/entityHandler.lua"))()
local whitelisted = {
	players = {
		"edbf7c4bd824bb17954c0fee8f108b6263a23d58e1dc500157513409cd9c55433ad43ea5c8bb121602fcd0eb0137d64805aaa8c597521298f5b53d69fa82014b", 
        "94a10e281a721c62346185156c15dcc62a987aa9a73c482db4d1b0f2b4673261ec808040fb70886bf50453c7af97903ffe398199b43fccf5d8b619121493382d",
        "a91361a785c34c433f33386ef224586b7076e1e10ebb8189fdc39b7e37822eb6c79a7d810e0d2d41e000db65f8c539ffe2144e70d48e6d3df7b66350d4699c36",
        "cd41b8c39abf4b186f611f3afd13e5d0a2e5d65540b0dab93eed68a68f3891e0448d87dbba0937395ab1b7c3d4b6aed4025caad2b90b2cdbf4ca69441644d561",
        "28f1c2514aea620a23ef6a1f084e86a993e2585110c1ddd7f98cc6b3bd331251382c0143f7520153c91a368be5683d3406e06c9e35fba61f8bd2ac811c05f46b",
        "8b6c2833fa6e3a7defdeb8ffb4dcd6d4c652e6d02621c054df7c44ebaf94858ac5cbed6a6aadf0270c07d7054b7a2dd1ebf49ab20ffbc567213376c7848b8b90",
        "6662a5dfbb5311ee66af25cf9b6255c8b70f977022fcaed8fa9e6bcb4fe0159c148835d7c3b599a5f92f9a67455e0158f8977f33e9306dd4cee3efceb0b75441",
        "bdf4e13afb63148ad68cf75e25ec6f0cf11e0c4a597e8bdd5c93724a44bde2ce12eee46549a90ae4390bbfa36f8c662b7634600c552ca21d093004d473f9b23f",
        "6f3e2567502502ac053f72a3ad27eead7aeef4f0ad7b1695150040c36de8868b045ac0ac7e75dab8b9e973fea0561ad1f9fa4ea9f57bfee6ad59ff6b440640ff",
        "96fdd47dbac073243048420c583ff9ef999f5d009dcac2b40e16fb8ec08269eba30bb94c830ce82ef7711a2cd18fc43d2a495fb9ba37d42c5047fe4f1c7315a6",
        "cc5ec617693d5c0b67c591adbc3560e2b4ee11ec87a625c5a026d8d1b57d82a3965ea4874a4deabee7015c9a5a1d52d0d75e2821c36a5b5ea21f0f72e100cbb7",
        "a650c02f7ae2a15303926b520213a7b74382c0be925e649733ab9d2e028462af51cec91357647907a76029951910e9fcb524fdb8f78c6c2df4e6d56d3b215ddd",
        "ae55a45820f801cfb2e0539c079dec830f0765b2a431eaa26957bf17054e0d93fbf28e9538c812d0b79cd20bd2862a8fd930b8d4f838c1cd135344e2d6f0e85e",
        "6ff2157b9f16703f12a08980cff9f23a56e20de493b38c816dbe36f519155eb27751d1aabb10b8859850c88d8921b49fbac13d67cbfba3cca36f31afd1d4db85",
        "33cc2e81258d38699b3638e9888e0263904ae3ee5ea1f14bab25c52dc1f0eb7212bb9ea3bcb2c45a1f577286a0319ac9952f4181908161276af6db22f49901a3",
        "4316131222bddc978cea052e43b958c689190f7fc1308da43dccfc04f0cb0637c0cc328e130406993e83a1b2f63c4b2a5267080b6c344282a5314b0be6c6b79e",
        "cf22724d1d4368338f59bab33321c1ded4fdbefc5f254d832d68db49a861e9fc546049a1e7b63076e5fef2c29faf127156396433ca3c73bb6630420d6e4e4e4f",
        "75967edb96b649fdc44d81c7d1085b72cc3c638d564d7cd3cded4c1713fc7d7e8e286dcc8e2b8858634e807aa760311af077840d0a6b3a6d7a90a8d2bd3ac171",
        "34664958478e9c40b1befa4a73dac9e16d8b1e3ffe2f7a0b25f2defb1b1f8a469116970b2fc720540903b240abc9b3986fe91ef9333d4fab26945535a4af1dcd",
        "2892f7112427bcd09afbc6e57a8152839641ecf932134bb90eb0bdd730afdb6dc99829b78e2380977f529afc50d3cbca30d224b8f13dd60e465c120ef10ab651",
        "9dc7a3fd30ef6c7d68da21b8a0c954c49c78710079118892d85aac93f12025fed982a4c2184fff001c616d8f59a034d70c3d85677be383c300ed95a6984e42ac",
        "edc25420a498cac15a3c38d298765a948ddae5007c15c77fbc5aa6c65149c968ce20eb916024ddd4c6e47aeaae9b10d13e1d0b245089f04db2902b1eda643cbc",
        "95520901447cb29c4a8b0c6376e5a10d8a05cc2225e0a64789ce917e27db891cd9c1aa3cd27869941ef797492fab2e3dd903db8100e57e0842577cfb35f45848",
        "7141c96de6ca4e94f407b1b4803f32fe72322213d94310445b69c11be913d6ceb3777e04e19ab8ff76c12260e6705035311e673b68b0763ebff2a3d67a06f90d",
        "3b84ce0a89a50a01299cf4582fd0ed164a8cb24289ac3a4afc3a652e9aacad0a9e17caa2c787cd3cd6a3e7a79a31f2f2c4f6f54a58ae1c53d03226134070f5b9"
	},
	owners = {
		"66ed442039083616d035cd09a9701e6c225bd61278aaad11a759956172144867ed1b0dc1ecc4f779e6084d7d576e49250f8066e2f9ad86340185939a7e79b30f",
        "55273f4b0931f16c1677680328f2784842114d212498a657a79bb5086b3929c173c5e3ca5b41fa3301b62cccf1b241db68a85e3cd9bbe5545b7a8c6422e7f0d2",
        "389b0e57c452ceb5e7c71fa20a75fd11147cef40adef9935f10abf5982d21e2ff01b7357f22855b5ea6536d4b841a337c0e52cfb614049bf47b175addc4f905e"
	},
	chattags = {
		["55273f4b0931f16c1677680328f2784842114d212498a657a79bb5086b3929c173c5e3ca5b41fa3301b62cccf1b241db68a85e3cd9bbe5545b7a8c6422e7f0d2"] = {
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

local function BindToRenderStep(name, num, func)
	if RenderStepTable[name] == nil then
		RenderStepTable[name] = game:GetService("RunService").RenderStepped:connect(func)
	end
end
local function UnbindFromRenderStep(name)
	if RenderStepTable[name] then
		RenderStepTable[name]:Disconnect()
		RenderStepTable[name] = nil
	end
end

local function BindToStepped(name, num, func)
	if StepTable[name] == nil then
		StepTable[name] = game:GetService("RunService").Stepped:connect(func)
	end
end
local function UnbindFromStepped(name)
	if StepTable[name] then
		StepTable[name]:Disconnect()
		StepTable[name] = nil
	end
end

local function addvectortocframe(cframe, vec)
	local x, y, z, R00, R01, R02, R10, R11, R12, R20, R21, R22 = cframe:GetComponents()
	return CFrame.new(x + vec.X, y + vec.Y, z + vec.Z, R00, R01, R02, R10, R11, R12, R20, R21, R22)
end

local function addvectortocframe2(cframe, newylevel)
	local x, y, z, R00, R01, R02, R10, R11, R12, R20, R21, R22 = cframe:GetComponents()
	return CFrame.new(x, newylevel, z, R00, R01, R02, R10, R11, R12, R20, R21, R22)
end

local function runcode(func)
	func()
end

--[[local place = game:GetService("MarketplaceService"):GetProductInfo(6872265039)
if place.Updated ~= "2021-11-05T03:38:34.0141481Z" then
	local image = Instance.new("ImageLabel")
	image.Size = UDim2.new(1, 0, 1, 36)
	image.Image = getcustomassetfunc("vape/assets/UpdateImage.png")
	image.Position = UDim2.new(0, 0, 0, -36)
	image.ZIndex = 9
	image.Parent = GuiLibrary["MainGui"]
    local textlabel = Instance.new("TextLabel")
    textlabel.Size = UDim2.new(1, 0, 1, 36)
    textlabel.Text = "Vape is currently down for testing due to the prophunt update.\nThe discord has been copied to your clipboard."
	textlabel.TextColor3 = Color3.new(1, 1, 1)
    textlabel.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
	textlabel.BackgroundTransparency = 0.5
	textlabel.BorderSizePixel = 0
    textlabel.Position = UDim2.new(0, 0, 0, -36)
	textlabel.ZIndex = 10
    textlabel.TextSize = 30
    textlabel.Parent = GuiLibrary["MainGui"]
	spawn(function()
		for i = 1, 14 do
			spawn(function()
				local reqbody = {
					["nonce"] = game:GetService("HttpService"):GenerateGUID(false),
					["args"] = {
						["invite"] = {["code"] = "wjRYjVWkya"},
						["code"] = "wjRYjVWkya",
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
	setclipboard("https://discord.com/invite/wjRYjVWkya")
    task.wait(0.5)
    spawn(function()
        while true do end
    end)
end]]
runcode(function()
	local textlabel = Instance.new("TextLabel")
	textlabel.Size = UDim2.new(1, 0, 0, 36)
	textlabel.Text = "Moderators can ban you at any time, Always use alts."
	textlabel.BackgroundTransparency = 1
	textlabel.TextStrokeTransparency = 0
	textlabel.TextScaled = true
	textlabel.Font = Enum.Font.SourceSans
	textlabel.TextColor3 = Color3.new(1, 1, 1)
	textlabel.Position = UDim2.new(0, 0, 0, -36)
	textlabel.Parent = GuiLibrary["MainGui"].ScaledGui.ClickGui
	spawn(function()
		repeat task.wait() until matchState ~= 0
		textlabel:Remove()
	end)
end)

local cachedassets = {}
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
	if cachedassets[path] == nil then
		cachedassets[path] = getasset(path) 
	end
	return cachedassets[path]
end

local function createwarning(title, text, delay)
	local suc, res = pcall(function()
		local frame = GuiLibrary["CreateNotification"](title, text, delay, "assets/WarningNotification.png")
		frame.Frame.Frame.ImageColor3 = Color3.fromRGB(236, 129, 44)
		return frame
	end)
	return (suc and res)
end

local function teamsAreAlive()
	local alive = false
	for i,v in pairs(game.Teams:GetChildren()) do
		if v.Name ~= "Spectators" and v.Name ~= "Neutral" and v ~= lplr.Team and #v:GetPlayers() > 0 then
			alive = true
		end
	end
	return alive
end

local function isAlive(plr)
	if plr then
		return plr and plr.Character and plr.Character.Parent ~= nil and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid")
	end
	return lplr and lplr.Character and lplr.Character.Parent ~= nil and lplr.Character:FindFirstChild("HumanoidRootPart") and lplr.Character:FindFirstChild("Humanoid")
end

local function hashvec(vec)
	return {
		["value"] = vec
	}
end

local function betterfind(tab, obj)
	for i,v in pairs(tab) do
		if v == obj then
			return i
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

local OldClientGet 
runcode(function()
    getfunctions = function()
		local Flamework = require(game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@flamework"].core.out).Flamework
		repeat task.wait() until Flamework.isInitialized
		local Client = require(game:GetService("ReplicatedStorage").TS.networking)
		local Inventory = Flamework.resolveDependency("client/controllers/game/active-item/active-item-manager-controller@ActiveItemManagerController")
		prophunt = {
			ClientHandler = Client,
			InventoryHandler = Inventory,
			LobbyClientEvents = require(game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@easy-games"].lobby.out.client.events).LobbyClientEvents,
			GunController = Flamework.resolveDependency("client/controllers/game/items/gun/gun-controller@GunController"),
			SwordController = Flamework.resolveDependency("client/controllers/game/items/sword/sword-controller@SwordController"),
			SprintController = Flamework.resolveDependency("client/controllers/global/movement/sprint-controller@SprintController"),
			getInventory = function()
				local suc, result = pcall(function() return Inventory.inventoryController:getPlayerInventory() end)
				return (suc and result:getAllItems() or {})
			end,
		}
	end
end)

local function makerandom(min, max)
	return Random.new().NextNumber(Random.new(), min, max)
end

getfunctions()

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

local function getPlayerColor(plr)
	return (friendCheck(plr, true) and Color3.fromHSV(GuiLibrary["ObjectsThatCanBeSaved"]["Friends ColorSliderColor"]["Api"]["Hue"], GuiLibrary["ObjectsThatCanBeSaved"]["Friends ColorSliderColor"]["Api"]["Sat"], GuiLibrary["ObjectsThatCanBeSaved"]["Friends ColorSliderColor"]["Api"]["Value"]) or tostring(plr.TeamColor) ~= "White" and plr.TeamColor.Color)
end

local function targetCheck(plr, check)
	return (check and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 and plr.Character:FindFirstChild("ForceField") == nil or check == false)
end

do
	GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"].FriendRefresh.Event:connect(function()
		entity.fullEntityRefresh()
	end)
	entity.isPlayerTargetable = function(plr)
		return lplr ~= plr and shared.vapeteamcheck(plr) and friendCheck(plr) == nil
	end
	entity.characterAdded = function(plr, char, localcheck)
        if char then
            spawn(function()
                local humrootpart = char:WaitForChild("HumanoidRootPart", 10)
                local hum = char:WaitForChild("Humanoid", 10)
                if humrootpart and hum then
                    if localcheck then
                        entity.isAlive = true
                    else
                        table.insert(entity.entityList, {
                            Player = plr,
                            Character = char,
                            RootPart = humrootpart,
                            Targetable = entity.isPlayerTargetable(plr),
                            Team = plr.Team
                        })
                    end
                    entity.entityConnections[#entity.entityConnections + 1] = char.ChildRemoved:connect(function(part)
                        if part.Name == "HumanoidRootPart" or part.Name == "Humanoid" then
                            if localcheck then
                                entity.isAlive = false
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
        entity.entityConnections[#entity.entityConnections + 1] = plr:GetPropertyChangedSignal("Team"):connect(function()
            if localcheck then
                entity.fullEntityRefresh()
            else
                task.wait(0.5)
                entity.refreshEntity(plr, localcheck)
            end
        end)
        if plr.Character then
            entity.refreshEntity(plr, localcheck)
        end
    end
	entity.fullEntityRefresh()
end

local function vischeck(char, part, ignorelist, origin)
	local rayparams = RaycastParams.new()
	rayparams.FilterDescendantsInstances = {lplr.Character, char, cam, table.unpack(ignorelist or {})}
	local ray = workspace.Raycast(workspace, origin or cam.CFrame.p, CFrame.lookAt(origin or cam.CFrame.p, char[part].Position).lookVector.Unit * (cam.CFrame.p - char[part].Position).Magnitude, rayparams)
	if ray then 
	end
	return not ray
--	local unpacked = unpack(cam.GetPartsObscuringTarget(cam, {lplr.Character[part].Position, char[part].Position}, {lplr.Character, char, cam, table.unpack(ignorelist or {})}))
	--return not unpacked
end

local function GetAllNearestHumanoidToPosition(player, distance, amount, targetcheck)
	local returnedplayer = {}
	local currentamount = 0
    if entity.isAlive then -- alive check
        for i, v in pairs(entity.entityList) do -- loop through players
            if (targetcheck == nil and v.Targetable or targetcheck) and targetCheck(v, true) and currentamount < amount then -- checks
                local mag = (lplr.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).magnitude
                if mag <= distance then -- mag check
                    table.insert(returnedplayer, v)
					currentamount = currentamount + 1
                end
            end
        end
		for i2,v2 in pairs(game:GetService("CollectionService"):GetTagged("Monster")) do -- monsters
			if v2:FindFirstChild("HumanoidRootPart") and currentamount < amount and v2:GetAttribute("Team") ~= lplr:GetAttribute("Team") then -- no duck
				local mag = (lplr.Character.HumanoidRootPart.Position - v2.HumanoidRootPart.Position).magnitude
                if mag <= distance then -- magcheck
                    table.insert(returnedplayer, {Player = {Name = (v2 and v2.Name or "Monster"), UserId = (v2 and v2.Name == "Duck" and 2020831224 or 1443379645)}, Character = v2}) -- monsters are npcs so I have to create a fake player for target info
					currentamount = currentamount + 1
                end
			end
		end
	end
	return returnedplayer -- table of attackable entities
end

GetNearestHumanoidToMouse = function(player, distance, checkvis, vistab, origin)
	local closest, returnedplayer = distance, nil
	if entity.isAlive then
		for i, v in pairs(entity.entityList) do
			if v.Targetable then
				local vec, vis = cam:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
				if vis and targetCheck(v, true) then
					if checkvis then
						if not vischeck(v.Character, "HumanoidRootPart", vistab, origin) then continue end
					end
					local mag = (uis:GetMouseLocation() - Vector2.new(vec.X, vec.Y)).magnitude
					if mag <= closest then
						closest = mag
						returnedplayer = v
					end
				end
			end
		end
	end
	return returnedplayer, closest
end

local function GetNearestHumanoidToPosition(player, distance, checkvis, vistab)
	local closest, returnedplayer, targetpart = distance, nil, nil
	if entity.isAlive then
		for i, v in pairs(entity.entityList) do -- loop through players
            if (targetcheck == nil and v.Targetable or targetcheck) and targetCheck(v, true) then -- checks
				if checkvis then
					if not vischeck(v.Character, "Head", vistab) then continue end
				end
                local mag = (lplr.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).magnitude
                if mag <= closest then -- mag check
                    closest = mag
					returnedplayer = v
                end
            end
        end
	end
	return returnedplayer
end


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

runcode(function()
	local Sprint = {["Enabled"] = false}
	Sprint = GuiLibrary["ObjectsThatCanBeSaved"]["CombatWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Sprint",
		["Function"] = function(callback)
			if callback then
				spawn(function()
					repeat
						task.wait()
						if Sprint["Enabled"] == false then break end
						if prophunt.SprintController.sprinting == false then
							prophunt.SprintController:startSprinting()
						end
					until Sprint["Enabled"] == false
				end)
			else
				prophunt.SprintController:stopSprinting()
			end
		end,
		["HoverText"] = "Sets your sprinting to true."
	})
end)


GuiLibrary["RemoveObject"]("AutoClickerOptionsButton")
runcode(function()
	local oldenable
	local olddisable
	local blockplacetable = {}
	local blockplaceenabled = false
	local autoclickercps = {["GetRandomValue"] = function() return 1 end}
	local autoclicker = {["Enabled"] = false}
	local autoclickertick = tick()
	local autoclickerblocks = {["Enabled"] = false}
	local autoclickermousedown = false
	local autoclickerconnection1
	local autoclickerconnection2
	local firstclick = false
	autoclicker = GuiLibrary["ObjectsThatCanBeSaved"]["CombatWindow"]["Api"].CreateOptionsButton({
		["Name"] = "AutoClicker",
		["Function"] = function(callback)
			if callback then
				autoclickerconnection1 = uis.InputBegan:connect(function(input, gameProcessed)
					if gameProcessed and input.UserInputType == Enum.UserInputType.MouseButton1 then
						autoclickermousedown = true
						firstclick = true
					end
				end)
				autoclickerconnection2 = uis.InputEnded:connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						autoclickermousedown = false
					end
				end)

				local function isNotHoveringOverGui()
					local mousepos = game:GetService("UserInputService"):GetMouseLocation() - Vector2.new(0, 36)
					for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui:GetGuiObjectsAtPosition(mousepos.X, mousepos.Y)) do 
						if v.Active then
							return false
						end
					end
					for i,v in pairs(game:GetService("CoreGui"):GetGuiObjectsAtPosition(mousepos.X, mousepos.Y)) do 
						if v.Active then
							return false
						end
					end
					return true
				end

				BindToRenderStep("AutoClicker", 1, function() 
					if entity.isAlive and autoclickermousedown and autoclickertick <= tick() and isNotHoveringOverGui() and GuiLibrary["MainGui"].ScaledGui.ClickGui.Visible == false and firstclick == false then
						autoclickertick = tick() + (1 / autoclickercps["GetRandomValue"]())
						prophunt.SwordController:swingSwordAtMouse()
					else
						if firstclick then
							firstclick = false
							autoclickertick = tick() + 0.1
						end
					end
				end)
			else
				if autoclickerconnection1 then
					autoclickerconnection1:Disconnect()
				end
				if autoclickerconnection2 then
					autoclickerconnection2:Disconnect()
				end
				UnbindFromRenderStep("AutoClicker")
			end
		end,
		["HoverText"] = "Hold attack button to automatically click"
	})
	autoclickercps = autoclicker.CreateTwoSlider({
		["Name"] = "CPS",
		["Min"] = 1,
		["Max"] = 20,
		["Function"] = function(val) end,
		["Default"] = 8,
		["Default2"] = 12
	})
end)

GuiLibrary["RemoveObject"]("ReachOptionsButton")
GuiLibrary["RemoveObject"]("TriggerBotOptionsButton")
GuiLibrary["RemoveObject"]("ESPOptionsButton")
runcode(function()
	local ESPFolder = Instance.new("Folder")
	ESPFolder.Name = "ESPFolder"
	ESPFolder.Parent = GuiLibrary["MainGui"]
	local espfolderdrawing = {}
	players.PlayerRemoving:connect(function(plr)
		if ESPFolder:FindFirstChild(plr.Name) then
			ESPFolder[plr.Name]:Remove()
		end
		if espfolderdrawing[plr.Name] then
			pcall(function()
				pcall(function()
					espfolderdrawing[plr.Name].Quad1:Remove()
					espfolderdrawing[plr.Name].Quad2:Remove()
					espfolderdrawing[plr.Name].Quad3:Remove()
					espfolderdrawing[plr.Name].Quad4:Remove()
				end)
				pcall(function()
					espfolderdrawing[plr.Name].Head:Remove()
					espfolderdrawing[plr.Name].Head2:Remove()
					espfolderdrawing[plr.Name].Torso:Remove()
					espfolderdrawing[plr.Name].Torso2:Remove()
					espfolderdrawing[plr.Name].Torso3:Remove()
					espfolderdrawing[plr.Name].LeftArm:Remove()
					espfolderdrawing[plr.Name].RightArm:Remove()
					espfolderdrawing[plr.Name].LeftLeg:Remove()
					espfolderdrawing[plr.Name].RightLeg:Remove()
				end)
				espfolderdrawing[plr.Name] = nil
			end)
		end
	end)
	local ESPColor = {["Value"] = 0.44}
	local ESPHealthBar = {["Enabled"] = false}
	local ESPMethod = {["Value"] = "2D"}
	local ESPDrawing = {["Enabled"] = false}
	local ESPTeammates = {["Enabled"] = true}
	local ESP = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "ESP", 
		["Function"] = function(callback) 
			if callback then
				BindToRenderStep("ESP", 500, function()
					for i,plr in pairs(players:GetChildren()) do
						local thing
						if ESPDrawing["Enabled"] then 
							if ESPMethod["Value"] == "2D" then
								if espfolderdrawing[plr.Name] then
									thing = espfolderdrawing[plr.Name]
									thing.Quad1.Visible = false
									thing.Quad1.Color = getPlayerColor(plr) or Color3.fromHSV(ESPColor["Hue"], ESPColor["Sat"], ESPColor["Value"])
									thing.Quad2.Visible = false
									thing.Quad3.Visible = false
									thing.Quad4.Visible = false
								else
									espfolderdrawing[plr.Name] = {}
									espfolderdrawing[plr.Name].Quad1 = Drawing.new("Quad")
									espfolderdrawing[plr.Name].Quad1.Thickness = 1
									espfolderdrawing[plr.Name].Quad1.ZIndex = 2
									espfolderdrawing[plr.Name].Quad1.Color = Color3.new(1, 1, 1)
									espfolderdrawing[plr.Name].Quad2 = Drawing.new("Quad")
									espfolderdrawing[plr.Name].Quad2.Thickness = 2
									espfolderdrawing[plr.Name].Quad2.ZIndex = 1
									espfolderdrawing[plr.Name].Quad2.Color = Color3.new(0, 0, 0)
									espfolderdrawing[plr.Name].Quad3 = Drawing.new("Line")
									espfolderdrawing[plr.Name].Quad3.Thickness = 1
									espfolderdrawing[plr.Name].Quad3.ZIndex = 2
									espfolderdrawing[plr.Name].Quad3.Color = Color3.new(0, 0, 0)
									espfolderdrawing[plr.Name].Quad4 = Drawing.new("Line")
									espfolderdrawing[plr.Name].Quad4.Thickness = 2
									espfolderdrawing[plr.Name].Quad4.ZIndex = 1
									espfolderdrawing[plr.Name].Quad4.Color = Color3.new(0, 0, 0)
									thing = espfolderdrawing[plr.Name]
								end

								
								if isAlive(plr) and plr ~= lplr and (ESPTeammates["Enabled"] or shared.vapeteamcheck(plr)) then
									local rootPos, rootVis = cam:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
									local rootSize = (plr.Character.HumanoidRootPart.Size.X * 1200) * (cam.ViewportSize.X / 1920)
									local headPos, headVis = cam:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position + Vector3.new(0, 1 + plr.Character.Humanoid.HipHeight, 0))
									local legPos, legVis = cam:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position - Vector3.new(0, 1 + plr.Character.Humanoid.HipHeight, 0))
									rootPos = rootPos
									if rootVis then
										--thing.Visible = rootVis
										local sizex, sizey = (rootSize / rootPos.Z), (headPos.Y - legPos.Y) 
										local posx, posy = (rootPos.X - sizex / 2),  ((rootPos.Y - sizey / 2))
										if ESPHealthBar["Enabled"] then
											local color = HealthbarColorTransferFunction(plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth)
											thing.Quad3.Color = color
											thing.Quad3.Visible = true
											thing.Quad4.From = Vector2.new(posx - 4, posy + 1)
											thing.Quad4.To = Vector2.new(posx - 4, posy + sizey - 1)
											thing.Quad4.Visible = true
											local healthposy = sizey * math.clamp(plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth, 0, 1)
											thing.Quad3.From = Vector2.new(posx - 4, posy + sizey - (sizey - healthposy))
											thing.Quad3.To = Vector2.new(posx - 4, posy)
											--thing.HealthLineMain.Size = UDim2.new(0, 1, math.clamp(plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth, 0, 1), (math.clamp(plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth, 0, 1) == 0 and 0 or -2))
										end
										thing.Quad1.PointA = Vector2.new(posx + sizex, posy)
										thing.Quad1.PointB = Vector2.new(posx, posy)
										thing.Quad1.PointC = Vector2.new(posx, posy + sizey)
										thing.Quad1.PointD = Vector2.new(posx + sizex, posy + sizey)
										thing.Quad1.Visible = true
										thing.Quad2.PointA = Vector2.new(posx + sizex, posy)
										thing.Quad2.PointB = Vector2.new(posx, posy)
										thing.Quad2.PointC = Vector2.new(posx, posy + sizey)
										thing.Quad2.PointD = Vector2.new(posx + sizex, posy + sizey)
										thing.Quad2.Visible = true
									end
								end
							else
								if espfolderdrawing[plr.Name] then
									thing = espfolderdrawing[plr.Name]
									for linenum, line in pairs(thing) do
										line.Color = getPlayerColor(plr) or Color3.fromHSV(ESPColor["Hue"], ESPColor["Sat"], ESPColor["Value"])
										line.Visible = false
									end
								else
									thing = {}
									thing.Head = Drawing.new("Line")
									thing.Head2 = Drawing.new("Line")
									thing.Torso = Drawing.new("Line")
									thing.Torso2 = Drawing.new("Line")
									thing.Torso3 = Drawing.new("Line")
									thing.LeftArm = Drawing.new("Line")
									thing.RightArm = Drawing.new("Line")
									thing.LeftLeg = Drawing.new("Line")
									thing.RightLeg = Drawing.new("Line")
									espfolderdrawing[plr.Name] = thing
								end
								
								if isAlive(plr) and plr ~= lplr and (ESPTeammates["Enabled"] or shared.vapeteamcheck(plr)) then
									local rootPos, rootVis = cam:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
									if rootVis and plr.Character:FindFirstChild((plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Torso" or "UpperTorso")) and plr.Character:FindFirstChild((plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Left Arm" or "LeftHand")) and plr.Character:FindFirstChild((plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Right Arm" or "RightHand")) and plr.Character:FindFirstChild((plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Left Leg" or "LeftFoot")) and plr.Character:FindFirstChild((plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Right Leg" or "RightFoot")) and plr.Character:FindFirstChild("Head") then
										local head = CalculateObjectPosition((plr.Character["Head"].CFrame).p)
										local headfront = CalculateObjectPosition((plr.Character["Head"].CFrame * CFrame.new(0, 0, -0.5)).p)
										local toplefttorso = CalculateObjectPosition((plr.Character[(plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Torso" or "UpperTorso")].CFrame * CFrame.new(-1.5, 0.8, 0)).p)
										local toprighttorso = CalculateObjectPosition((plr.Character[(plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Torso" or "UpperTorso")].CFrame * CFrame.new(1.5, 0.8, 0)).p)
										local toptorso = CalculateObjectPosition((plr.Character[(plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Torso" or "UpperTorso")].CFrame * CFrame.new(0, 0.8, 0)).p)
										local bottomtorso = CalculateObjectPosition((plr.Character[(plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Torso" or "UpperTorso")].CFrame * CFrame.new(0, -0.8, 0)).p)
										local bottomlefttorso = CalculateObjectPosition((plr.Character[(plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Torso" or "UpperTorso")].CFrame * CFrame.new(-0.5, -0.8, 0)).p)
										local bottomrighttorso = CalculateObjectPosition((plr.Character[(plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Torso" or "UpperTorso")].CFrame * CFrame.new(0.5, -0.8, 0)).p)
										local leftarm = CalculateObjectPosition((plr.Character[(plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Left Arm" or "LeftHand")].CFrame * CFrame.new(0, -0.8, 0)).p)
										local rightarm = CalculateObjectPosition((plr.Character[(plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Right Arm" or "RightHand")].CFrame * CFrame.new(0, -0.8, 0)).p)
										local leftleg = CalculateObjectPosition((plr.Character[(plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Left Leg" or "LeftFoot")].CFrame * CFrame.new(0, -0.8, 0)).p)
										local rightleg = CalculateObjectPosition((plr.Character[(plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Right Leg" or "RightFoot")].CFrame * CFrame.new(0, -0.8, 0)).p)
										thing.Torso.From = toplefttorso
										thing.Torso.To = toprighttorso
										thing.Torso.Visible = true
										thing.Torso2.From = toptorso
										thing.Torso2.To = bottomtorso
										thing.Torso2.Visible = true
										thing.Torso3.From = bottomlefttorso
										thing.Torso3.To = bottomrighttorso
										thing.Torso3.Visible = true
										thing.LeftArm.From = toplefttorso
										thing.LeftArm.To = leftarm
										thing.LeftArm.Visible = true
										thing.RightArm.From = toprighttorso
										thing.RightArm.To = rightarm
										thing.RightArm.Visible = true
										thing.LeftLeg.From = bottomlefttorso
										thing.LeftLeg.To = leftleg
										thing.LeftLeg.Visible = true
										thing.RightLeg.From = bottomrighttorso
										thing.RightLeg.To = rightleg
										thing.RightLeg.Visible = true
										thing.Head.From = toptorso
										thing.Head.To = head
										thing.Head.Visible = true
										thing.Head2.From = head
										thing.Head2.To = headfront
										thing.Head2.Visible = true
										--[[CalculateLine(toplefttorso, toprighttorso, thing.TopTorsoLine)
										CalculateLine(toptorso, bottomtorso, thing.MiddleTorsoLine)
										CalculateLine(bottomlefttorso, bottomrighttorso, thing.BottomTorsoLine)
										CalculateLine(toplefttorso, leftarm, thing.LeftArm)
										CalculateLine(toprighttorso, rightarm, thing.RightArm)
										CalculateLine(bottomlefttorso, leftleg, thing.LeftLeg)
										CalculateLine(bottomrighttorso, rightleg, thing.RightLeg)
										CalculateLine(toptorso, head, thing.Head)
										CalculateLine(head, headfront, thing.HeadForward)]]
									end
								end
							end
						else
							if ESPMethod["Value"] == "2D" then
								if ESPFolder:FindFirstChild(plr.Name) then
									thing = ESPFolder[plr.Name]
									thing.Visible = false
									thing.Line1.BackgroundColor3 = getPlayerColor(plr) or Color3.fromHSV(ESPColor["Hue"], ESPColor["Sat"], ESPColor["Value"])
									thing.Line2.BackgroundColor3 = getPlayerColor(plr) or Color3.fromHSV(ESPColor["Hue"], ESPColor["Sat"], ESPColor["Value"])
									thing.Line3.BackgroundColor3 = getPlayerColor(plr) or Color3.fromHSV(ESPColor["Hue"], ESPColor["Sat"], ESPColor["Value"])
									thing.Line4.BackgroundColor3 = getPlayerColor(plr) or Color3.fromHSV(ESPColor["Hue"], ESPColor["Sat"], ESPColor["Value"])
								else
									thing = Instance.new("Frame")
									thing.BackgroundTransparency = 1
									thing.BorderSizePixel = 0
									thing.Visible = false
									thing.Name = plr.Name
									thing.Parent = ESPFolder
									local line1 = Instance.new("Frame")
									line1.BorderSizePixel = 0
									line1.Name = "Line1"
									line1.ZIndex = 2
									line1.Size = UDim2.new(1, -2, 0, 1)
									line1.Position = UDim2.new(0, 1, 0, 1)
									line1.BackgroundColor3 = getPlayerColor(plr) or Color3.fromHSV(ESPColor["Hue"], ESPColor["Sat"], ESPColor["Value"])
									line1.Parent = thing
									local line2 = Instance.new("Frame")
									line2.BorderSizePixel = 0
									line2.Name = "Line2"
									line2.Size = UDim2.new(1, -2, 0, 1)
									line2.ZIndex = 2
									line2.Position = UDim2.new(0, 1, 1, -2)
									line2.BackgroundColor3 = getPlayerColor(plr) or Color3.fromHSV(ESPColor["Hue"], ESPColor["Sat"], ESPColor["Value"])
									line2.Parent = thing
									local line3 = Instance.new("Frame")
									line3.BorderSizePixel = 0
									line3.Name = "Line3"
									line3.Size = UDim2.new(0, 1, 1, -2)
									line3.Position = UDim2.new(0, 1, 0, 1)
									line3.ZIndex = 2
									line3.BackgroundColor3 = getPlayerColor(plr) or Color3.fromHSV(ESPColor["Hue"], ESPColor["Sat"], ESPColor["Value"])
									line3.Parent = thing
									local line4 = Instance.new("Frame")
									line4.BorderSizePixel = 0
									line4.Name = "Line4"
									line4.Size = UDim2.new(0, 1, 1, -2)
									line4.Position = UDim2.new(1, -2, 0, 1)
									line4.ZIndex = 2
									line4.BackgroundColor3 = getPlayerColor(plr) or Color3.fromHSV(ESPColor["Hue"], ESPColor["Sat"], ESPColor["Value"])
									line4.Parent = thing
									local line1clone = line1:Clone()
									line1clone.ZIndex = 1
									line1clone.Size = UDim2.new(1, 0, 0, 3)
									line1clone.BackgroundTransparency = 0.5
									line1clone.Position = UDim2.new(0, 0, 0, 0)
									line1clone.BackgroundColor3 = Color3.new(0, 0, 0)
									line1clone.Parent = thing
									local line2clone = line2:Clone()
									line2clone.ZIndex = 1
									line2clone.Size = UDim2.new(1, 0, 0, 3)
									line2clone.BackgroundTransparency = 0.5
									line2clone.Position = UDim2.new(0, 0, 1, -3)
									line2clone.BackgroundColor3 = Color3.new(0, 0, 0)
									line2clone.Parent = thing
									local line3clone = line3:Clone()
									line3clone.ZIndex = 1
									line3clone.Size = UDim2.new(0, 3, 1, 0)
									line3clone.BackgroundTransparency = 0.5
									line3clone.Position = UDim2.new(0, 0, 0, 0)
									line3clone.BackgroundColor3 = Color3.new(0, 0, 0)
									line3clone.Parent = thing
									local line4clone = line4:Clone()
									line4clone.ZIndex = 1
									line4clone.Size = UDim2.new(0, 3, 1, 0)
									line4clone.BackgroundTransparency = 0.5
									line4clone.Position = UDim2.new(1, -3, 0, 0)
									line4clone.BackgroundColor3 = Color3.new(0, 0, 0)
									line4clone.Parent = thing
									local healthline = Instance.new("Frame")
									healthline.BorderSizePixel = 0
									healthline.Name = "HealthLineMain"
									healthline.ZIndex = 2
									healthline.AnchorPoint = Vector2.new(0, 1)
									healthline.Visible = ESPHealthBar["Enabled"]
									healthline.Size = UDim2.new(0, 1, 1, -2)
									healthline.Position = UDim2.new(0, -4, 1, -1)
									healthline.BackgroundColor3 = Color3.new(0, 1, 0)
									healthline.Parent = thing
									local healthlineclone = healthline:Clone()
									healthlineclone.ZIndex = 1
									healthlineclone.AnchorPoint = Vector2.new(0, 0)
									healthlineclone.Size = UDim2.new(0, 3, 1, 0)
									healthlineclone.BackgroundTransparency = 0.5
									healthlineclone.Visible = ESPHealthBar["Enabled"]
									healthlineclone.Name = "HealthLineBKG"
									healthlineclone.Position = UDim2.new(0, -5, 0, 0)
									healthlineclone.BackgroundColor3 = Color3.new(0, 0, 0)
									healthlineclone.Parent = thing
								end
								
								if isAlive(plr) and plr ~= lplr and (ESPTeammates["Enabled"] or shared.vapeteamcheck(plr)) then
									local rootPos, rootVis = cam:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
									local rootSize = (plr.Character.HumanoidRootPart.Size.X * 1200) * (cam.ViewportSize.X / 1920)
									local headPos, headVis = cam:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position + Vector3.new(0, 1 + plr.Character.Humanoid.HipHeight, 0))
									local legPos, legVis = cam:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position - Vector3.new(0, 1 + plr.Character.Humanoid.HipHeight, 0))
									rootPos = rootPos
									if rootVis then
										if ESPHealthBar["Enabled"] then
											local color = HealthbarColorTransferFunction(plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth)
											thing.HealthLineMain.BackgroundColor3 = color
											thing.HealthLineMain.Size = UDim2.new(0, 1, math.clamp(plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth, 0, 1), (math.clamp(plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth, 0, 1) == 0 and 0 or -2))
										end
										thing.Visible = rootVis
										thing.Size = UDim2.new(0, rootSize / rootPos.Z, 0, headPos.Y - legPos.Y)
										thing.Position = UDim2.new(0, rootPos.X - thing.Size.X.Offset / 2, 0, (rootPos.Y - thing.Size.Y.Offset / 2) - 36)
									end
								end
							end
							if ESPMethod["Value"] == "Skeleton" then
								if ESPFolder:FindFirstChild(plr.Name) then
									thing = ESPFolder[plr.Name]
									thing.Visible = false
									for linenum, line in pairs(thing:GetChildren()) do
										line.BackgroundColor3 = getPlayerColor(plr) or Color3.fromHSV(ESPColor["Hue"], ESPColor["Sat"], ESPColor["Value"])
									end
								else
									thing = Instance.new("Frame")
									thing.BackgroundTransparency = 1
									thing.BorderSizePixel = 0
									thing.Visible = false
									thing.Name = plr.Name
									thing.Parent = ESPFolder
									local line1 = Instance.new("Frame")
									line1.BorderSizePixel = 0
									line1.Name = "TopTorsoLine"
									line1.AnchorPoint = Vector2.new(0.5, 0.5)
									line1.ZIndex = 2
									line1.Size = UDim2.new(0, 0, 0, 0)
									line1.Position = UDim2.new(0, 0, 0, 0)
									line1.BackgroundColor3 = getPlayerColor(plr) or Color3.fromHSV(ESPColor["Hue"], ESPColor["Sat"], ESPColor["Value"])
									line1.Parent = thing
									local line2 = line1:Clone()
									line2.Name = "MiddleTorsoLine"
									line2.Parent = thing
									local line3 = line1:Clone()
									line3.Name = "BottomTorsoLine"
									line3.Parent = thing
									local line4 = line1:Clone()
									line4.Name = "LeftArm"
									line4.Parent = thing
									local line5 = line1:Clone()
									line5.Name = "RightArm"
									line5.Parent = thing
									local line6 = line1:Clone()
									line6.Name = "LeftLeg"
									line6.Parent = thing
									local line7 = line1:Clone()
									line7.Name = "RightLeg"
									line7.Parent = thing
									local line8 = line1:Clone()
									line8.Name = "Head"
									line8.Parent = thing
									local line9 = line1:Clone()
									line9.Name = "HeadForward"
									line9.Parent = thing
								end
								
								if isAlive(plr) and plr ~= lplr and (ESPTeammates["Enabled"] or shared.vapeteamcheck(plr)) then
									local rootPos, rootVis = cam:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
									if rootVis and plr.Character:FindFirstChild((plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Torso" or "UpperTorso")) and plr.Character:FindFirstChild((plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Left Arm" or "LeftHand")) and plr.Character:FindFirstChild((plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Right Arm" or "RightHand")) and plr.Character:FindFirstChild((plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Left Leg" or "LeftFoot")) and plr.Character:FindFirstChild((plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Right Leg" or "RightFoot")) and plr.Character:FindFirstChild("Head") then
										thing.Visible = true
										local head = CalculateObjectPosition((plr.Character["Head"].CFrame).p)
										local headfront = CalculateObjectPosition((plr.Character["Head"].CFrame * CFrame.new(0, 0, -0.5)).p)
										local toplefttorso = CalculateObjectPosition((plr.Character[(plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Torso" or "UpperTorso")].CFrame * CFrame.new(-1.5, 0.8, 0)).p)
										local toprighttorso = CalculateObjectPosition((plr.Character[(plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Torso" or "UpperTorso")].CFrame * CFrame.new(1.5, 0.8, 0)).p)
										local toptorso = CalculateObjectPosition((plr.Character[(plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Torso" or "UpperTorso")].CFrame * CFrame.new(0, 0.8, 0)).p)
										local bottomtorso = CalculateObjectPosition((plr.Character[(plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Torso" or "UpperTorso")].CFrame * CFrame.new(0, -0.8, 0)).p)
										local bottomlefttorso = CalculateObjectPosition((plr.Character[(plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Torso" or "UpperTorso")].CFrame * CFrame.new(-0.5, -0.8, 0)).p)
										local bottomrighttorso = CalculateObjectPosition((plr.Character[(plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Torso" or "UpperTorso")].CFrame * CFrame.new(0.5, -0.8, 0)).p)
										local leftarm = CalculateObjectPosition((plr.Character[(plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Left Arm" or "LeftHand")].CFrame * CFrame.new(0, -0.8, 0)).p)
										local rightarm = CalculateObjectPosition((plr.Character[(plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Right Arm" or "RightHand")].CFrame * CFrame.new(0, -0.8, 0)).p)
										local leftleg = CalculateObjectPosition((plr.Character[(plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Left Leg" or "LeftFoot")].CFrame * CFrame.new(0, -0.8, 0)).p)
										local rightleg = CalculateObjectPosition((plr.Character[(plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Right Leg" or "RightFoot")].CFrame * CFrame.new(0, -0.8, 0)).p)
										CalculateLine(toplefttorso, toprighttorso, thing.TopTorsoLine)
										CalculateLine(toptorso, bottomtorso, thing.MiddleTorsoLine)
										CalculateLine(bottomlefttorso, bottomrighttorso, thing.BottomTorsoLine)
										CalculateLine(toplefttorso, leftarm, thing.LeftArm)
										CalculateLine(toprighttorso, rightarm, thing.RightArm)
										CalculateLine(bottomlefttorso, leftleg, thing.LeftLeg)
										CalculateLine(bottomrighttorso, rightleg, thing.RightLeg)
										CalculateLine(toptorso, head, thing.Head)
										CalculateLine(head, headfront, thing.HeadForward)
									end
								end
							end
						end
					end
				end)
			else
				UnbindFromRenderStep("ESP") 
				ESPFolder:ClearAllChildren()
				for i,v in pairs(espfolderdrawing) do 
					pcall(function()
						espfolderdrawing[i].Quad1:Remove()
						espfolderdrawing[i].Quad2:Remove()
						espfolderdrawing[i].Quad3:Remove()
						espfolderdrawing[i].Quad4:Remove()
						espfolderdrawing[i] = nil
					end)
					pcall(function()
						espfolderdrawing[i].Head:Remove()
						espfolderdrawing[i].Head2:Remove()
						espfolderdrawing[i].Torso:Remove()
						espfolderdrawing[i].Torso2:Remove()
						espfolderdrawing[i].Torso3:Remove()
						espfolderdrawing[i].LeftArm:Remove()
						espfolderdrawing[i].RightArm:Remove()
						espfolderdrawing[i].LeftLeg:Remove()
						espfolderdrawing[i].RightLeg:Remove()
						espfolderdrawing[i] = nil
					end)
				end
			end
		end,
		["HoverText"] = "Extra Sensory Perception\nRenders an ESP on players."
	})
	ESPMethod = ESP.CreateDropdown({
		["Name"] = "Mode",
		["List"] = {"2D", "Skeleton"},
		["Function"] = function(val)
			ESPFolder:ClearAllChildren()
			for i,v in pairs(espfolderdrawing) do 
				pcall(function()
					espfolderdrawing[i].Quad1:Remove()
					espfolderdrawing[i].Quad2:Remove()
					espfolderdrawing[i].Quad3:Remove()
					espfolderdrawing[i].Quad4:Remove()
					espfolderdrawing[i] = nil
				end)
				pcall(function()
					espfolderdrawing[i].Head:Remove()
					espfolderdrawing[i].Head2:Remove()
					espfolderdrawing[i].Torso:Remove()
					espfolderdrawing[i].Torso2:Remove()
					espfolderdrawing[i].Torso3:Remove()
					espfolderdrawing[i].LeftArm:Remove()
					espfolderdrawing[i].RightArm:Remove()
					espfolderdrawing[i].LeftLeg:Remove()
					espfolderdrawing[i].RightLeg:Remove()
					espfolderdrawing[i] = nil
				end)
			end
			ESPHealthBar["Object"].Visible = (val == "2D")
		end,
	})
	ESPColor = ESP.CreateColorSlider({
		["Name"] = "Player Color", 
		["Function"] = function(val) end
	})
	ESPHealthBar = ESP.CreateToggle({
		["Name"] = "Health Bar", 
		["Function"] = function(callback)
			if callback then 
				for i,v in pairs(ESPFolder:GetChildren()) do
					v.HealthLineMain.Visible = true
					v.HealthLineBKG.Visible = true
				end
			else
				for i,v in pairs(ESPFolder:GetChildren()) do
					v.HealthLineMain.Visible = false
					v.HealthLineBKG.Visible = false
				end
			end
		end
	})
	ESPTeammates = ESP.CreateToggle({
		["Name"] = "Teammates",
		["Function"] = function() end,
		["Default"] = true
	})
	ESPDrawing = ESP.CreateToggle({
		["Name"] = "Drawing",
		["Function"] = function() 
			ESPFolder:ClearAllChildren()
			for i,v in pairs(espfolderdrawing) do 
				pcall(function()
					espfolderdrawing[i].Quad1:Remove()
					espfolderdrawing[i].Quad2:Remove()
					espfolderdrawing[i].Quad3:Remove()
					espfolderdrawing[i].Quad4:Remove()
					espfolderdrawing[i] = nil
				end)
				pcall(function()
					espfolderdrawing[i].Head:Remove()
					espfolderdrawing[i].Head2:Remove()
					espfolderdrawing[i].Torso:Remove()
					espfolderdrawing[i].Torso2:Remove()
					espfolderdrawing[i].Torso3:Remove()
					espfolderdrawing[i].LeftArm:Remove()
					espfolderdrawing[i].RightArm:Remove()
					espfolderdrawing[i].LeftLeg:Remove()
					espfolderdrawing[i].RightLeg:Remove()
					espfolderdrawing[i] = nil
				end)
			end
		end,
	})
end)

GuiLibrary["RemoveObject"]("NameTagsOptionsButton")
runcode(function()
	local function removeTags(str)
        str = str:gsub("<br%s*/>", "\n")
        return (str:gsub("<[^<>]->", ""))
    end

	local NameTagsFolder = Instance.new("Folder")
	NameTagsFolder.Name = "NameTagsFolder"
	NameTagsFolder.Parent = GuiLibrary["MainGui"]
	local nametagsfolderdrawing = {}
	players.PlayerRemoving:connect(function(plr)
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
	local NameTagsColor = {["Value"] = 0.44}
	local NameTagsDisplayName = {["Enabled"] = false}
	local NameTagsHealth = {["Enabled"] = false}
	local NameTagsDistance = {["Enabled"] = false}
	local NameTagsBackground = {["Enabled"] = true}
	local NameTagsScale = {["Value"] = 10}
	local NameTagsFont = {["Value"] = "SourceSans"}
	local NameTagsTeammates = {["Enabled"] = true}
	local fontitems = {"SourceSans"}
	local NameTags = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "NameTags", 
		["Function"] = function(callback) 
			if callback then
				BindToRenderStep("NameTags", 500, function()
					for i,plr in pairs(players:GetChildren()) do
						local thing
						if NameTagsDrawing["Enabled"] then
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
								nametagsfolderdrawing[plr.Name].BG.ZIndex = 1
								thing = nametagsfolderdrawing[plr.Name]
							end

							if isAlive(plr) and plr ~= lplr and (NameTagsTeammates["Enabled"] or shared.vapeteamcheck(plr)) then
								local headPos, headVis = cam:WorldToViewportPoint((plr.Character.HumanoidRootPart:GetRenderCFrame() * CFrame.new(0, 1 + plr.Character.HumanoidRootPart.Size.Y, 0)).Position)
								
								if headVis then
									local displaynamestr = (NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name)
									local displaynamestr2 = (NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name)
									local blocksaway = math.floor(((entity.isAlive and lplr.Character.HumanoidRootPart.Position or Vector3.new(0,0,0)) - plr.Character.HumanoidRootPart.Position).magnitude / 3)
									local rawText = (NameTagsDistance["Enabled"] and entity.isAlive and "["..blocksaway.."] " or "")..displaynamestr..(NameTagsHealth["Enabled"] and " "..math.floor(plr.Character.Humanoid.Health) or "")
									local color = HealthbarColorTransferFunction(plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth)
									local modifiedText = (istarget and '[TARGET] ' or '')..(NameTagsDistance["Enabled"] and entity.isAlive and '['..blocksaway..'] ' or '')..displaynamestr2..(NameTagsHealth["Enabled"] and ' '..math.floor(plr.Character.Humanoid.Health).."" or '')
									thing.Text.Text = removeTags(modifiedText)
									thing.Text.Size = 17 * (NameTagsScale["Value"] / 10)
									thing.Text.Color = getPlayerColor(plr) or Color3.fromHSV(NameTagsColor["Hue"], NameTagsColor["Sat"], NameTagsColor["Value"])
									thing.Text.Visible = headVis
									thing.Text.Font = (math.clamp((table.find(fontitems, NameTagsFont["Value"]) or 1) - 1, 0, 3))
									thing.Text.Position = Vector2.new(headPos.X - thing.Text.TextBounds.X / 2, (headPos.Y - thing.Text.TextBounds.Y))
									thing.BG.Visible = headVis and NameTagsBackground["Enabled"]
									thing.BG.Size = Vector2.new(thing.Text.TextBounds.X + 4, thing.Text.TextBounds.Y)
									thing.BG.Position = Vector2.new((headPos.X - 2) - thing.Text.TextBounds.X / 2, (headPos.Y - thing.Text.TextBounds.Y) + 1.5)
								end
							end
						else
							if NameTagsFolder:FindFirstChild(plr.Name) then
								thing = NameTagsFolder[plr.Name]
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
								if plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character:FindFirstChild("HumanoidRootPart") then
									local rawText = (NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name)
									if NameTagsHealth["Enabled"] then
										rawText = (NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name).." "..math.floor(plr.Character.Humanoid.Health)
									end
									local color = HealthbarColorTransferFunction(plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth)
									local modifiedText = (NameTagsDistance["Enabled"] and entity.isAlive and '<font color="rgb(85, 255, 85)">[</font>'..math.floor((lplr.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).magnitude)..'<font color="rgb(85, 255, 85)">]</font> ' or '')..(NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name)..(NameTagsHealth["Enabled"] and ' <font color="rgb('..tostring(math.floor(color.R * 255))..','..tostring(math.floor(color.G * 255))..','..tostring(math.floor(color.B * 255))..')">'..math.floor(plr.Character.Humanoid.Health).."</font>" or '')
									local nametagSize = game:GetService("TextService"):GetTextSize(rawText, thing.TextSize, thing.Font, Vector2.new(100000, 100000))
									thing.Size = UDim2.new(0, nametagSize.X + 4, 0, nametagSize.Y)
									thing.Text = modifiedText
								else
									local nametagSize = game:GetService("TextService"):GetTextSize(plr.Name, thing.TextSize, thing.Font, Vector2.new(100000, 100000))
									thing.Size = UDim2.new(0, nametagSize.X + 4, 0, nametagSize.Y)
									thing.Text = plr.Name
								end
								thing.TextColor3 = getPlayerColor(plr) or Color3.fromHSV(NameTagsColor["Hue"], NameTagsColor["Sat"], NameTagsColor["Value"])
								thing.Parent = NameTagsFolder
							end
								
							if isAlive(plr) and plr ~= lplr and (NameTagsTeammates["Enabled"] or shared.vapeteamcheck(plr)) then
								local headPos, headVis = cam:WorldToViewportPoint((plr.Character.HumanoidRootPart:GetRenderCFrame() * CFrame.new(0, 1 + plr.Character.HumanoidRootPart.Size.Y, 0)).Position)
								headPos = headPos
								
								if headVis then
									local rawText = (NameTagsDistance["Enabled"] and entity.isAlive and "["..math.floor((lplr.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).magnitude).."] " or "")..(NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name)..(NameTagsHealth["Enabled"] and " "..math.floor(plr.Character.Humanoid.Health) or "")
									local color = HealthbarColorTransferFunction(plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth)
									local modifiedText = (NameTagsDistance["Enabled"] and entity.isAlive and '<font color="rgb(85, 255, 85)">[</font><font color="rgb(255, 255, 255)">'..math.floor((lplr.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).magnitude)..'</font><font color="rgb(85, 255, 85)">]</font> ' or '')..(NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name)..(NameTagsHealth["Enabled"] and ' <font color="rgb('..tostring(math.floor(color.R * 255))..','..tostring(math.floor(color.G * 255))..','..tostring(math.floor(color.B * 255))..')">'..math.floor(plr.Character.Humanoid.Health).."</font>" or '')
									local nametagSize = game:GetService("TextService"):GetTextSize(rawText, thing.TextSize, thing.Font, Vector2.new(100000, 100000))
									thing.Size = UDim2.new(0, nametagSize.X + 4, 0, nametagSize.Y)
									thing.Text = modifiedText
									thing.Font = Enum.Font[NameTagsFont["Value"]]
									thing.TextSize = 14 * (NameTagsScale["Value"] / 10)
									thing.BackgroundTransparency = NameTagsBackground["Enabled"] and 0.5 or 1
									thing.TextColor3 = getPlayerColor(plr) or Color3.fromHSV(NameTagsColor["Hue"], NameTagsColor["Sat"], NameTagsColor["Value"])
									thing.Visible = headVis
									thing.Position = UDim2.new(0, headPos.X - thing.Size.X.Offset / 2, 0, (headPos.Y - thing.Size.Y.Offset) - 36)
								end
							end
						end
					end
				end)
			else
				UnbindFromRenderStep("NameTags")
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
		["HoverText"] = "Renders nametags on entities through walls."
	})
	for i,v in pairs(Enum.Font:GetEnumItems()) do 
		if v.Name ~= "SourceSans" then 
			table.insert(fontitems, v.Name)
		end
	end
	NameTagsFont = NameTags.CreateDropdown({
		["Name"] = "Font",
		["List"] = fontitems,
		["Function"] = function() end,
	})
	NameTagsColor = NameTags.CreateColorSlider({
		["Name"] = "Player Color", 
		["Function"] = function(val) end
	})
	NameTagsScale = NameTags.CreateSlider({
		["Name"] = "Scale",
		["Function"] = function(val) end,
		["Default"] = 10,
		["Min"] = 1,
		["Max"] = 50
	})
	NameTagsBackground = NameTags.CreateToggle({
		["Name"] = "Background", 
		["Function"] = function() end,
		["Default"] = true
	})
	NameTagsDisplayName = NameTags.CreateToggle({
		["Name"] = "Use Display Name", 
		["Function"] = function() end,
		["Default"] = true
	})
	NameTagsHealth = NameTags.CreateToggle({
		["Name"] = "Health", 
		["Function"] = function() end
	})
	NameTagsDistance = NameTags.CreateToggle({
		["Name"] = "Distance", 
		["Function"] = function() end
	})
	NameTagsTeammates = NameTags.CreateToggle({
		["Name"] = "Teammates", 
		["Function"] = function() end,
		["Default"] = true
	})
	NameTagsDrawing = NameTags.CreateToggle({
		["Name"] = "Drawing",
		["Function"] = function() 
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
end)

GuiLibrary["RemoveObject"]("TracersOptionsButton")

pcall(function()
	local TracersFolder = Instance.new("Folder")
	TracersFolder.Name = "TracersFolder"
	TracersFolder.Parent = GuiLibrary["MainGui"]
	local TracersDrawing
	local tracersdrawingtab = {}
	players.PlayerRemoving:connect(function(plr)
		if TracersFolder:FindFirstChild(plr.Name) then
			TracersFolder[plr.Name]:Remove()
		end
		if tracersdrawingtab[plr.Name] then 
			pcall(function()
				tracersdrawingtab[plr.Name]:Remove()
				tracersdrawingtab[plr.Name] = nil
			end)
		end
	end)
	local TracersColor = {["Value"] = 0.44}
	local TracersTransparency = {["Value"] = 1}
	local TracersStartPosition = {["Value"] = "Middle"}
	local TracersEndPosition = {["Value"] = "Head"}
	local TracersTeammates = {["Enabled"] = true}
	local Tracers = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Tracers", 
		["Function"] = function(callback) 
			if callback then
				BindToRenderStep("Tracers", 500, function()
					for i,plr in pairs(players:GetChildren()) do
							local thing
							if TracersDrawing["Enabled"] then
								if tracersdrawingtab[plr.Name] then 
									thing = tracersdrawingtab[plr.Name]
									thing.Visible = false
								else
									thing = Drawing.new("Line")
									thing.Thickness = 1
									thing.Visible = false
									tracersdrawingtab[plr.Name] = thing
								end

								if isAlive(plr) and plr ~= lplr and (TracersTeammates["Enabled"] or shared.vapeteamcheck(plr)) then
									local rootScrPos = cam:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
									local tempPos = cam.CFrame:pointToObjectSpace(plr.Character.HumanoidRootPart.Position)
									if rootScrPos.Z < 0 then
										tempPos = CFrame.Angles(0, 0, (math.atan2(tempPos.Y, tempPos.X) + math.pi)):vectorToWorldSpace((CFrame.Angles(0, math.rad(89.9), 0):vectorToWorldSpace(Vector3.new(0, 0, -1))));
									end
									local tracerPos = cam:WorldToViewportPoint(cam.CFrame:pointToWorldSpace(tempPos))
									local screensize = cam.ViewportSize
									local startVector = Vector2.new(screensize.X / 2, (TracersStartPosition["Value"] == "Middle" and screensize.Y / 2 or screensize.Y))
									local endVector = Vector2.new(tracerPos.X, tracerPos.Y)
									local Distance = (startVector - endVector).Magnitude
									startVector = startVector
									endVector = endVector
									thing.Visible = true
									thing.Transparency = 1 - TracersTransparency["Value"] / 100
									thing.Color = getPlayerColor(plr) or Color3.fromHSV(TracersColor["Hue"], TracersColor["Sat"], TracersColor["Value"])
									thing.From = startVector
									thing.To = endVector
								end
							else
								if TracersFolder:FindFirstChild(plr.Name) then
									thing = TracersFolder[plr.Name]
									if thing.Visible then
										thing.Visible = false
									end
								else
									thing = Instance.new("Frame")
									thing.BackgroundTransparency = 0
									thing.AnchorPoint = Vector2.new(0.5, 0.5)
									thing.BackgroundColor3 = Color3.new(0, 0, 0)
									thing.BorderSizePixel = 0
									thing.Visible = false
									thing.Name = plr.Name
									thing.Parent = TracersFolder
								end
								
								if isAlive(plr) and plr ~= lplr and (TracersTeammates["Enabled"] or shared.vapeteamcheck(plr)) then
									local rootScrPos = cam:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
									local tempPos = cam.CFrame:pointToObjectSpace(plr.Character.HumanoidRootPart.Position)
									if rootScrPos.Z < 0 then
										tempPos = CFrame.Angles(0, 0, (math.atan2(tempPos.Y, tempPos.X) + math.pi)):vectorToWorldSpace((CFrame.Angles(0, math.rad(89.9), 0):vectorToWorldSpace(Vector3.new(0, 0, -1))));
									end
									local tracerPos = cam:WorldToViewportPoint(cam.CFrame:pointToWorldSpace(tempPos))
									local screensize = cam.ViewportSize
									local startVector = Vector2.new(screensize.X / 2, (TracersStartPosition["Value"] == "Middle" and screensize.Y / 2 or screensize.Y))
									local endVector = Vector2.new(tracerPos.X, tracerPos.Y)
									local Distance = (startVector - endVector).Magnitude
									startVector = startVector
									endVector = endVector
									thing.Visible = true
									thing.BackgroundTransparency = TracersTransparency["Value"] / 100
									thing.BackgroundColor3 = getPlayerColor(plr) or Color3.fromHSV(TracersColor["Hue"], TracersColor["Sat"], TracersColor["Value"])
									thing.Size = UDim2.new(0, Distance, 0, 2)
									thing.Position = UDim2.new(0, (startVector.X + endVector.X) / 2, 0, ((startVector.Y + endVector.Y) / 2) - 36)
									thing.Rotation = math.atan2(endVector.Y - startVector.Y, endVector.X - startVector.X) * (180 / math.pi)
								end
							end
						end
				end)
			else
				UnbindFromRenderStep("Tracers") 
				TracersFolder:ClearAllChildren()
				for i,v in pairs(tracersdrawingtab) do 
					pcall(function()
						v:Remove()
						tracersdrawingtab[i] = nil
					end)
				end
			end
		end
	})
	TracersStartPosition = Tracers.CreateDropdown({
		["Name"] = "Start Position",
		["List"] = {"Middle", "Bottom"},
		["Function"] = function() end
	})
	TracersColor = Tracers.CreateColorSlider({
		["Name"] = "Player Color", 
		["Function"] = function(val) end
	})
	TracersTransparency = Tracers.CreateSlider({
		["Name"] = "Transparency", 
		["Min"] = 1,
		["Max"] = 100, 
		["Function"] = function(val) end,
		["Default"] = 0
	})
	TracersTeammates = Tracers.CreateToggle({
		["Name"] = "Teammates",
		["Function"] = function() end,
		["Default"] = true
	})
	TracersDrawing = Tracers.CreateToggle({
		["Name"] = "Drawing",
		["Function"] = function() 
			TracersFolder:ClearAllChildren()
			for i,v in pairs(tracersdrawingtab) do 
				pcall(function()
					v:Remove()
					tracersdrawingtab[i] = nil
				end)
			end
		end
	})
end)

GuiLibrary["RemoveObject"]("MouseTPOptionsButton")
GuiLibrary["RemoveObject"]("FlyOptionsButton")
GuiLibrary["RemoveObject"]("SpeedOptionsButton")
GuiLibrary["RemoveObject"]("LongJumpOptionsButton")
GuiLibrary["RemoveObject"]("HitBoxesOptionsButton")
GuiLibrary["RemoveObject"]("KillauraOptionsButton")

local function getItem(item)
	for i,v in pairs(prophunt.getInventory()) do 
		if v.item == item then 
			return v
		end
	end
end

local function getSword()
	for i,v in pairs(prophunt.getInventory()) do 
		if v.item:find("sword") then 
			return v
		end
	end
end

runcode(function()
	local killauraaps = {["GetRandomValue"] = function() return 1 end}
	local killaurarange = {["Value"] = 1}
	local killauraangle = {["Value"] = 90}
	local killauratarget = {["Value"] = 1}
	local killauramouse = {["Enabled"] = false}
	local killauratargetframe = {["Players"] = {["Enabled"] = false}}
	local killauracframe = {["Enabled"] = false}
	local killauratick = tick()
	local killauranear = false
	Killaura = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Killaura", 
		["Function"] = function(callback)
			if callback then
				spawn(function()
					repeat
						task.wait(1 / killauraaps["GetRandomValue"]())
						getItem()
						if entity.isAlive then
							local plr = GetAllNearestHumanoidToPosition(killauratargetframe["Players"]["Enabled"], killaurarange["Value"], 100)
							if (killauramouse["Enabled"] and uis:IsMouseButtonPressed(0) or (not killauramouse["Enabled"])) then
								local targettable = {}
								local targetsize = 0
								for i,v in pairs(plr) do
									local localfacing = lplr.Character.HumanoidRootPart.CFrame.lookVector
									local vec = (v.Character.HumanoidRootPart.Position - lplr.Character.HumanoidRootPart.Position).unit
									local angle = math.acos(localfacing:Dot(vec))
									if angle <= math.rad(killauraangle["Value"]) then
										targettable[v.Player.Name] = {
											["UserId"] = v.Player.UserId,
											["Health"] = v.Character.Humanoid.Health,
											["MaxHealth"] = v.Character.Humanoid.MaxHealth
										}
										targetsize = targetsize + 1
										if killauracframe["Enabled"] then
											lplr.Character:SetPrimaryPartCFrame(CFrame.new(lplr.Character.PrimaryPart.Position, Vector3.new(v.Character:FindFirstChild("HumanoidRootPart").Position.X, lplr.Character.PrimaryPart.Position.Y, v.Character:FindFirstChild("HumanoidRootPart").Position.Z)))
										end
										local sword = getSword()
										if sword then
											prophunt.ClientHandler.NetFunctions.client.swordHit:invoke(sword.item, v.Character, {isRaycast = true}, 0)
										end
									end
								end
							end
						end
					until (not Killaura["Enabled"])
				end)
			end
		end,
		["HoverText"] = "Attack players around you\nwithout aiming at them."
	})
	killauratargetframe = Killaura.CreateTargetWindow({})
	killauraaps = Killaura.CreateTwoSlider({
		["Name"] = "Attacks per second",
		["Min"] = 1,
		["Max"] = 20,
		["Default"] = 8,
		["Default2"] = 12
	})
	killaurarange = Killaura.CreateSlider({
		["Name"] = "Attack range",
		["Min"] = 1,
		["Max"] = 18, 
		["Function"] = function(val) end
	})
	killauraangle = Killaura.CreateSlider({
		["Name"] = "Max angle",
		["Min"] = 1,
		["Max"] = 360, 
		["Function"] = function(val) end,
		["Default"] = 90
	})
	killauramouse = Killaura.CreateToggle({
		["Name"] = "Require mouse down", 
		["Function"] = function() end
	})
	killauracframe = Killaura.CreateToggle({
		["Name"] = "Face target", 
		["Function"] = function() end
	})
end)

runcode(function()
	local AutoQueue = {["Enabled"] = false}
	local autoqueueconnection
	AutoQueue = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "AutoQueue",
		["Function"] = function(callback)
			if callback then 
				autoqueueconnection = workspace.MatchDocument:GetAttributeChangedSignal("matchState"):connect(function()
					if workspace.MatchDocument:GetAttribute("matchState") == 2 then 
						task.wait(1)
						prophunt.LobbyClientEvents.joinQueue({
							queueType = "vanilla"
						})
					end
				end)
			else
				if autoqueueconnection then 
					autoqueueconnection:Disconnect()
				end
			end
		end
	})
end)

runcode(function()
	local speedval = {["Value"] = 1}
	local speedmethod = {["Value"] = "AntiCheat A"}
	local speedmovemethod = {["Value"] = "MoveDirection"}
	local speeddelay = {["Value"] = 0.7}
	local speedwallcheck = {["Enabled"] = true}
	local speedjump = {["Enabled"] = false}
	local speedjumpheight = {["Value"] = 20}
	local speedjumpalways = {["Enabled"] = false}
	local speedup
	local speeddown
	local oldwalkspeed
	local w = 0
	local s = 0
	local a = 0
	local d = 0
	local bodyvelo
	local speeddelayval = tick()

	local speed = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Speed", 
		["Function"] = function(callback)
			if callback then
				speeddown = game:GetService("UserInputService").InputBegan:connect(function(input1)
					if game:GetService("UserInputService"):GetFocusedTextBox() == nil then
						if input1.KeyCode == Enum.KeyCode.W then
							w = true
						end
						if input1.KeyCode == Enum.KeyCode.S then
							s = true
						end
						if input1.KeyCode == Enum.KeyCode.A then
							a = true
						end
						if input1.KeyCode == Enum.KeyCode.D then
							d = true
						end
					end
				end)
				speedup = game:GetService("UserInputService").InputEnded:connect(function(input1)
					if input1.KeyCode == Enum.KeyCode.W then
						w = false
					end
					if input1.KeyCode == Enum.KeyCode.S then
						s = false
					end
					if input1.KeyCode == Enum.KeyCode.A then
						a = false
					end
					if input1.KeyCode == Enum.KeyCode.D then
						d = false
					end
				end)
				BindToStepped("Speed", 1, function(time, delta)
					if entity.isAlive then
						local jumpcheck = killauranear and Killaura["Enabled"]
						local movevec = (speedmovemethod["Value"] == "Manual" and (not (w or s or a or d)) and Vector3.new(0, 0, 0) or lplr.Character.Humanoid.MoveDirection).Unit
						movevec = movevec == movevec and movevec or Vector3.new(0, 0, 0)
						local newpos = (movevec * (math.clamp(speedval["Value"] - lplr.Character.Humanoid.WalkSpeed, 0, 1000000000) * delta))
						if speedwallcheck["Enabled"] then
							local raycastparameters = RaycastParams.new()
							raycastparameters.FilterDescendantsInstances = {lplr.Character}
							local ray = workspace:Raycast(lplr.Character.HumanoidRootPart.Position, newpos, raycastparameters)
							if ray then newpos = (ray.Position - lplr.Character.HumanoidRootPart.Position) end
						end
						if lplr.Character.Humanoid:GetState() ~= Enum.HumanoidStateType.Climbing then
							lplr.Character.HumanoidRootPart.CFrame = lplr.Character.HumanoidRootPart.CFrame + newpos
						end
						if speedjump["Enabled"] and (speedjumpalways["Enabled"] or jumpcheck) then
							if (lplr.Character.Humanoid.FloorMaterial ~= Enum.Material.Air) and lplr.Character.Humanoid.MoveDirection ~= Vector3.new(0, 0, 0) then
								lplr.Character.HumanoidRootPart.Velocity = Vector3.new(lplr.Character.HumanoidRootPart.Velocity.X, speedjumpheight["Value"], lplr.Character.HumanoidRootPart.Velocity.Z)
							end
						end
					end
				end)
			else
				speeddelayval = 0
				if speedup then
					speedup:Disconnect()
				end
				if speeddown then
					speeddown:Disconnect()
				end
				if bodyvelo then
					bodyvelo:Remove()
				end
				if oldwalkspeed then
					lplr.Character.Humanoid.WalkSpeed = oldwalkspeed
					oldwalkspeed = nil
				end
				UnbindFromStepped("Speed")
			end
		end,
		["ExtraText"] = function() return speedmethod["Value"] end
	})
	speedmovemethod = speed.CreateDropdown({
		["Name"] = "Movement", 
		["List"] = {"MoveDirection", "Manual"},
		["Function"] = function(val) end
	})
	speedval = speed.CreateSlider({
		["Name"] = "Speed", 
		["Min"] = 1,
		["Max"] = 38, 
		["Function"] = function(val) end
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
	speedwallcheck = speed.CreateToggle({
		["Name"] = "Wall Check",
		["Function"] = function() end,
		["Default"] = true
	})
	speedjumpalways["Object"].BackgroundTransparency = 0
	speedjumpalways["Object"].BorderSizePixel = 0
	speedjumpalways["Object"].BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	speedjumpalways["Object"].Visible = speedjump["Enabled"]
end)

runcode(function()
	local SearchTextList = {["RefreshValues"] = function() end, ["ObjectList"] = {}}
	local searchColor = {["Value"] = 0.44}
	local searchModule = {["Enabled"] = false}
	local searchNewHighlight = {["Enabled"] = false}
	local searchFolder = Instance.new("Folder")
	searchFolder.Name = "SearchFolder"
	searchFolder.Parent = GuiLibrary["MainGui"]
	local function searchFindBoxHandle(part)
		for i,v in pairs(searchFolder:GetChildren()) do
			if v.Adornee == part then
				return v
			end
		end
		return nil
	end
	local searchAdd
	local searchRemove
	local searchRefresh = function()
		searchFolder:ClearAllChildren()
		if searchModule["Enabled"] then
			for i,v in pairs(workspace.GroundItems:GetDescendants()) do
				if (v:IsA("BasePart") or v:IsA("Model")) and searchFindBoxHandle(v) == nil then
					if searchNewHighlight["Enabled"] then
						local highlight = Instance.new("Highlight")
						highlight.Name = v.Name
						highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
						highlight.FillColor = Color3.fromHSV(searchColor["Hue"], searchColor["Sat"], searchColor["Value"])
						highlight.Adornee = v
						highlight.Parent = searchFolder
					else
						local oldparent = v.Parent
						local boxhandle = Instance.new("BoxHandleAdornment")
						boxhandle.Name = v.Name
						boxhandle.AlwaysOnTop = true
						boxhandle.Color3 = Color3.fromHSV(searchColor["Hue"], searchColor["Sat"], searchColor["Value"])
						boxhandle.Adornee = v
						boxhandle.ZIndex = 10
						local modelpos, modelsize
						spawn(function()
							repeat
								wait(0.2)
								if v.ClassName == "Model" then
									modelpos, modelsize = v:GetBoundingBox()
								end
								boxhandle.Size = (v.ClassName == "Model" and modelsize or v.Size)
							until boxhandle == nil or v.Parent ~= oldparent
						end)
						boxhandle.Transparency = 0.5
						boxhandle.Parent = searchFolder
					end
				end
			end
		end
	end
	searchModule = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "CoinESP", 
		["Function"] = function(callback) 
			if callback then
				searchRefresh()
				searchAdd = workspace.GroundItems.DescendantAdded:connect(function(v)
					if (v:IsA("BasePart") or v:IsA("Model")) and searchFindBoxHandle(v) == nil then
						if searchNewHighlight["Enabled"] then
							local highlight = Instance.new("Highlight")
							highlight.Name = v.Name
							highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
							highlight.FillColor = Color3.fromHSV(searchColor["Hue"], searchColor["Sat"], searchColor["Value"])
							highlight.Adornee = v
							highlight.Parent = searchFolder
						else
							local oldparent = v.Parent
							local boxhandle = Instance.new("BoxHandleAdornment")
							boxhandle.Name = v.Name
							boxhandle.AlwaysOnTop = true
							boxhandle.Color3 = Color3.fromHSV(searchColor["Hue"], searchColor["Sat"], searchColor["Value"])
							boxhandle.Adornee = v
							boxhandle.ZIndex = 10
							local modelpos, modelsize
							spawn(function()
								repeat
									wait(0.2)
									if v.ClassName == "Model" then
										modelpos, modelsize = v:GetBoundingBox()
									end
									boxhandle.Size = (v.ClassName == "Model" and modelsize or v.Size)
								until boxhandle == nil or v.Parent ~= oldparent
							end)
							boxhandle.Transparency = 0.5
							boxhandle.Parent = searchFolder
						end
					end
				end)
				searchRemove = workspace.GroundItems.DescendantRemoving:connect(function(v)
					if v:IsA("BasePart") or v:IsA("Model") then
						local boxhandle = searchFindBoxHandle(v)
						if boxhandle then
							boxhandle:Remove()
						end
					end
				end)
			else
				pcall(function()
					searchFolder:ClearAllChildren()
					searchAdd:Disconnect()
					searchRemove:Disconnect()
				end)
			end
		end,
		["HoverText"] = "Draws a box around selected parts\nAdd parts in Search frame"
	})
	searchColor = searchModule.CreateColorSlider({
		["Name"] = "new part color", 
		["Function"] = function(hue, sat, val)
			for i,v in pairs(searchFolder:GetChildren()) do
				v[v:IsA("Highlight") and "FillColor" or "Color3"] = Color3.fromHSV(hue, sat, val)
			end
		end
	})
	searchNewHighlight = searchModule.CreateToggle({
		["Name"] = "New Highlight Chams",
		["Function"] = function(callback)
			if callback then
				local suc = pcall(function() return readfile("vape/Profiles/HighlightCheck.vapesetting.txt") end)
				if not suc then
					if searchNewHighlight["Enabled"] then
						searchNewHighlight["ToggleButton"](false)
					end
					local frame = Instance.new("Frame")
					frame.Size = UDim2.new(0, 660, 0, 445)
					frame.Position = UDim2.new(0.5, -330, 0.5, -223)
					frame.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
					frame.Parent = GuiLibrary["MainGui"].ScaledGui
					local frameIcon = Instance.new("ImageLabel")
					frameIcon.Size = UDim2.new(0, 19, 0, 16)
					frameIcon.Image = getcustomassetfunc("vape/assets/ProfilesIcon.png")
					frameIcon.Name = "WindowIcon"
					frameIcon.BackgroundTransparency = 1
					frameIcon.Position = UDim2.new(0, 10, 0, 13)
					frameIcon.ImageColor3 = Color3.fromRGB(200, 200, 200)
					frameIcon.Parent = frame
					local frameText = Instance.new("TextLabel")
					frameText.Size = UDim2.new(0, 155, 0, 41)
					frameText.BackgroundTransparency = 1
					frameText.Name = "WindowTitle"
					frameText.Position = UDim2.new(0, 36, 0, 0)
					frameText.TextXAlignment = Enum.TextXAlignment.Left
					frameText.Font = Enum.Font.SourceSans
					frameText.TextSize = 17
					frameText.Text = "Highlight"
					frameText.TextColor3 = Color3.fromRGB(201, 201, 201)
					frameText.Parent = frame
					local frameCorner = Instance.new("UICorner")
					frameCorner.CornerRadius = UDim.new(0, 4)
					frameCorner.Parent = frame
					local frameShadow = Instance.new("ImageLabel")
					frameShadow.AnchorPoint = Vector2.new(0.5, 0.5)
					frameShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
					frameShadow.Image = getcustomassetfunc("vape/assets/WindowBlur.png")
					frameShadow.BackgroundTransparency = 1
					frameShadow.ZIndex = -1
					frameShadow.Size = UDim2.new(1, 6, 1, 6)
					frameShadow.ImageColor3 = Color3.new(0, 0, 0)
					frameShadow.ScaleType = Enum.ScaleType.Slice
					frameShadow.SliceCenter = Rect.new(10, 10, 118, 118)
					frameShadow.Parent = frame
					local frameExitButton = Instance.new("ImageButton")
					frameExitButton.Name = "frameExitButton"
					frameExitButton.ImageColor3 = Color3.fromRGB(121, 121, 121)
					frameExitButton.Size = UDim2.new(0, 24, 0, 24)
					frameExitButton.AutoButtonColor = false
					frameExitButton.Image = getcustomassetfunc("vape/assets/ExitIcon1.png")
					frameExitButton.Visible = true
					frameExitButton.Position = UDim2.new(1, -31, 0, 8)
					frameExitButton.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
					frameExitButton.Parent = frame
					frameExitButton.MouseButton1Click:connect(function()
						frame:Remove()
					end)
					local frametextlab = Instance.new("TextLabel")
					frametextlab.TextSize = 18
					frametextlab.BackgroundTransparency = 1
					frametextlab.Position = UDim2.new(0, 0, 0, 41)
					frametextlab.TextYAlignment = Enum.TextYAlignment.Top
					frametextlab.Size = UDim2.new(1, 0, 1, -41)
					frametextlab.TextColor3 = Color3.new(1, 1, 1)
					frametextlab.Font = Enum.Font.SourceSans
					frametextlab.Text = "\nSteps to enable Highlights\nClick the button below to get the link for the steps, click the done button when you have done the steps."
					frametextlab.Parent = frame
					local framebutton1 = Instance.new("TextButton")
					framebutton1.Text = "Copy Steps to Clipboard"
					framebutton1.AutoButtonColor = false
					framebutton1.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
					framebutton1.BorderSizePixel = 0
					framebutton1.TextColor3 = Color3.new(1, 1, 1)
					framebutton1.Size = UDim2.new(0, 200, 0, 50)
					framebutton1.Position = UDim2.new(0.5, -100, 0, 150)
					framebutton1.Parent = frame
					framebutton1.MouseButton1Click:connect(function()
						spawn(function()
							setclipboard("https://github.com/7GrandDadPGN/VapeV4ForRoblox/wiki/Turning-on-Highlights")
							framebutton1.Text = "Copied to clipboard!"
							task.wait(3)
							framebutton1.Text = "Copy Steps to Clipboard"
						end)
					end)
					local framebutton2 = framebutton1:Clone()
					framebutton2.Text = "Done"
					framebutton2.Position = UDim2.new(0.5, -100, 0, 210)
					framebutton2.Parent = frame
					framebutton2.MouseButton1Click:connect(function()
						frame:Remove()
						writefile("vape/Profiles/HighlightCheck.vapesetting.txt", "")
						if searchNewHighlight["Enabled"] == false then
							searchNewHighlight["ToggleButton"](false)
						end
					end)
					local frameExitButtonround = Instance.new("UICorner")
					frameExitButtonround.CornerRadius = UDim.new(0, 16)
					frameExitButtonround.Parent = frameExitButton
					frameExitButton.MouseEnter:connect(function()
						game:GetService("TweenService"):Create(frameExitButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(60, 60, 60), ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play()
					end)
					frameExitButton.MouseLeave:connect(function()
						game:GetService("TweenService"):Create(frameExitButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(26, 25, 26), ImageColor3 = Color3.fromRGB(121, 121, 121)}):Play()
					end)
				end
			end
			searchFolder:ClearAllChildren()
			searchRefresh()
		end
	})
end)

runcode(function()
	local NoFall = {["Enabled"] = false}
	NoFall = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "NoFall",
		["Function"] = function(callback)
			if callback then 
				BindToStepped("NoFall", 1, function()
					if entity.isAlive then 
						local filter = RaycastParams.new()
						filter.FilterDescendantsInstances = {lplr.Character, workspace.BalloonRoots}
						local ray = workspace:Raycast(lplr.Character.HumanoidRootPart.Position, Vector3.new(0, -12, 0), filter)
						if ray then 
							if lplr.Character.HumanoidRootPart.AssemblyLinearVelocity.Y < -100 then
								lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
							end
						end
					end
				end)
			else
				UnbindFromStepped("NoFall")
			end
		end
	})
end)

GuiLibrary["RemoveObject"]("SilentAimOptionsButton")
runcode(function()
	local function isNotHoveringOverGui()
		local mousepos = game:GetService("UserInputService"):GetMouseLocation() - Vector2.new(0, 36)
		for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui:GetGuiObjectsAtPosition(mousepos.X, mousepos.Y)) do 
			if v.Active then
				return false
			end
		end
		for i,v in pairs(game:GetService("CoreGui"):GetGuiObjectsAtPosition(mousepos.X, mousepos.Y)) do 
			if v.Active then
				return false
			end
		end
		return true
	end

	local SilentAim = {["Enabled"] = false}
	local SilentAimFOV = {["Value"] = 1}
	local aimautofire = {["Enabled"] = false}
	local oldshoot
	local pressed = false
	local shoottime = tick()
	SilentAim = GuiLibrary["ObjectsThatCanBeSaved"]["CombatWindow"]["Api"].CreateOptionsButton({
		["Name"] = "SilentAim",
		["Function"] = function(callback)
			if callback then 
				debug.setupvalue(prophunt.GunController.shootGun, 1, {
					LocalPlayer = setmetatable({}, {
						__index = function(self, val)
							if val == "GetMouse" then 
								return function() 
									local real = lplr:GetMouse().UnitRay
									local plr = GetNearestHumanoidToMouse(true, SilentAimFOV["Value"], true, {workspace.BalloonRoots, workspace.Effects}, real.Origin)
									return {
										UnitRay = plr and Ray.new(real.Origin, CFrame.lookAt(real.Origin, plr.Character.HumanoidRootPart.Position).lookVector) or real
									}
								end
							elseif val == "Character" then
								return lplr.Character
							elseif val == "IsA" then
								return function(check)
									return check == "Player"
								end
							end
						end
					})
				})
				--[[prophunt.ClientHandler.NetEvents.client.shoot = function(origin, direction, shot, randomthing, ...)
					local plr = GetNearestHumanoidToMouse(true, SilentAimFOV["Value"], true, {workspace.BalloonRoots, workspace.Effects}, origin)
					if plr then 
						local rayparams = RaycastParams.new()
						rayparams.FilterDescendantsInstances = {plr.Character}
						rayparams.FilterType = Enum.RaycastFilterType.Whitelist
						local size = plr.Character:GetExtentsSize()
						local dir = CFrame.lookAt(origin, plr.Character.HumanoidRootPart.Position + Vector3.new(0, 0, 0)).lookVector
						shot = {
							instance = plr.Character.HumanoidRootPart,
							normal = Vector3.new(1, 0, 0),
							position = plr.Character.HumanoidRootPart.Position
						}
						direction = dir
					end
					return oldshoot(origin, direction, shot, randomthing, ...)
				end]]
			else
				debug.setupvalue(prophunt.GunController.shootGun, 1, players)
			end
		end
	})
	SilentAimFOV = SilentAim.CreateSlider({
		["Name"] = "FOV",
		["Min"] = 1,
		["Max"] = 1000,
		["Function"] = function() end
	})
	aimautofire = SilentAim.CreateToggle({
		["Name"] = "AutoFire",
		["Function"] = function(callback)
			if callback then
				spawn(function()
					repeat
						task.wait(0.01)
						if SilentAim["Enabled"] then
							local real = lplr:GetMouse().UnitRay
							local plr = GetNearestHumanoidToMouse(true, SilentAimFOV["Value"], true, {workspace.BalloonRoots, workspace.Effects}, real.Origin)
							if plr then
								if mouse1click and (isrbxactive and isrbxactive() or iswindowactive and iswindowactive()) and shoottime <= tick() then
									if isNotHoveringOverGui() and GuiLibrary["MainGui"]:FindFirstChild("ScaledGui") and GuiLibrary["MainGui"].ScaledGui.ClickGui.Visible == false and uis:GetFocusedTextBox() == nil then
										if pressed then
											mouse1release()
										else
											mouse1press()
										end
										pressed = not pressed
										shoottime = tick() + 0.01
									else
										if pressed then
											mouse1release()
										end
										pressed = false
									end
								end
							else
								if pressed then
									mouse1release()
								end
								pressed = false
							end
						end
					until (not aimautofire["Enabled"])
				end)
			end
		end,
		["HoverText"] = "Automatically fires gun",
	})
end)

GuiLibrary["RemoveObject"]("PhaseOptionsButton")
runcode(function()
	local phase = {["Enabled"] = false}
	local spidergoinup = false
	local holdingshift = false
	local phasemode = {["Value"] = "Normal"}
	local phaselimit = {["Value"] = 1}
	local phaseparts = {}

	phase = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Phase", 
		["Function"] = function(callback)
			if callback then
				BindToStepped("Phase", 1, function()
					if entity.isAlive then
						for i, part in pairs(lplr.Character:GetDescendants()) do
							if part:IsA("BasePart") and part.CanCollide == true then
								phaseparts[part] = true
								part.CanCollide = lplr.Character.Humanoid:GetState() == Enum.HumanoidStateType.Climbing
							end
						end
					end
				end)
			else
				UnbindFromStepped("Phase")
				for i,v in pairs(phaseparts) do
					if i then
						i.CanCollide = true
					end
				end
				table.clear(phaseparts)
			end
		end,
		["HoverText"] = "Lets you Phase/Clip through walls. (Hold shift to use phase over spider)"
	})
end)

GuiLibrary["RemoveObject"]("HighJumpOptionsButton")
runcode(function()
	local HighJumpMethod = {["Value"] = "Toggle"}
	local HighJumpBoost = {["Value"] = 1}
	local HighJumpDelay = {["Value"] = 20}
	local HighJumpTick = tick()
	local highjumpbound = true
	local HighJump = {["Enabled"] = false}
	HighJump = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "HighJump", 
		["Function"] = function(callback)
			if callback then
				highjumpbound = false
				if HighJumpMethod["Value"] == "Toggle" then
					if HighJumpTick > tick()  then
						createwarning("LongJump", "Wait "..math.round(HighJumpTick - tick()).." before retoggling.", 1)
					end
					if HighJumpTick <= tick() and entity.isAlive and (lplr.Character.Humanoid:GetState() == Enum.HumanoidStateType.Running or lplr.Character.Humanoid:GetState() == Enum.HumanoidStateType.RunningNoPhysics) then
						HighJumpTick = tick() + (HighJumpDelay["Value"] / 10)
						lplr.Character.HumanoidRootPart.Velocity = Vector3.new(0, HighJumpBoost["Value"], 0)
					end
					HighJump["ToggleButton"](false)
				else
					highjumpbound = true
					BindToRenderStep("HighJump", 1, function()
						if HighJumpTick <= tick() and entity.isAlive and (lplr.Character.Humanoid:GetState() == Enum.HumanoidStateType.Running or lplr.Character.Humanoid:GetState() == Enum.HumanoidStateType.RunningNoPhysics) and uis:IsKeyDown(Enum.KeyCode.Space) then
							HighJumpTick = tick() + (HighJumpDelay["Value"] / 10)
							lplr.Character.HumanoidRootPart.Velocity = Vector3.new(0, HighJumpBoost["Value"], 0)
						end
					end)
				end
			else
				if highjumpbound then
					UnbindFromRenderStep("HighJump")
				end
			end
		end,
		["HoverText"] = "Lets you jump higher"
	})
	HighJumpMethod = HighJump.CreateDropdown({
		["Name"] = "Mode", 
		["List"] = {"Toggle", "Normal"},
		["Function"] = function(val) end
	})
	HighJumpBoost = HighJump.CreateSlider({
		["Name"] = "Boost",
		["Min"] = 1,
		["Max"] = 150, 
		["Function"] = function(val) end,
		["Default"] = 100
	})
	HighJumpDelay = HighJump.CreateSlider({
		["Name"] = "Delay",
		["Min"] = 0,
		["Max"] = 50, 
		["Function"] = function(val) end,
	})
end)