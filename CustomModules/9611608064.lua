--[[ 
	Credits
	Infinite Yield - Blink
	DevForum - lots of rotation math because I hate it
	Radical Loading Bar - ProximityPrompt render code
	Please notify me if you need credits
]]
local GuiLibrary = shared.GuiLibrary
local players = game:GetService("Players")
local textservice = game:GetService("TextService")
local repstorage = game:GetService("ReplicatedStorage")
local lplr = players.LocalPlayer
local workspace = game:GetService("Workspace")
local lighting = game:GetService("Lighting")
local collectionservice = game:GetService("CollectionService")
local cam = workspace.CurrentCamera
local targetinfo = shared.VapeTargetInfo
local uis = game:GetService("UserInputService")
local localmouse = lplr:GetMouse()
local requestfunc = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or getgenv().request or request
local getasset = getsynasset or getcustomasset
local chatconnection
local chatconnection2
local uninjectflag = false
local br = {}
local brpos = {}
local brvelo = {}
local storedshahashes = {}
local silentaimfire = false
local triggerbotfire = false
local SilentAim = {["Enabled"] = false}
local SpinBot = {["Enabled"] = false}
local TriggerBot = {["Enabled"] = false}
local vec3 = Vector3.new
local cfnew = CFrame.new
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
local function GetURL(scripturl)
	if shared.VapeDeveloper then
		return readfile("vape/"..scripturl)
	else
		return game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/"..scripturl, true)
	end
end
local shalib = loadstring(GetURL("Libraries/sha.lua"))()
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

local function createwarning(title, text, delay)
	pcall(function()
		local frame = GuiLibrary["CreateNotification"](title, text, delay, "assets/WarningNotification.png")
		frame.Frame.BackgroundColor3 = Color3.fromRGB(236, 129, 44)
		frame.Frame.Frame.BackgroundColor3 = Color3.fromRGB(236, 129, 44)
	end)
end

local function friendCheck(plr, recolor)
	return (recolor and GuiLibrary["ObjectsThatCanBeSaved"]["Recolor visualsToggle"]["Api"]["Enabled"] or (not recolor)) and GuiLibrary["ObjectsThatCanBeSaved"]["Use FriendsToggle"]["Api"]["Enabled"] and table.find(GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"]["ObjectList"], plr.Name) and GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"]["ObjectListEnabled"][table.find(GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"]["ObjectList"], plr.Name)]
end

local function getPlayerColor(plr)
	return (friendCheck(plr, true) and Color3.fromHSV(GuiLibrary["ObjectsThatCanBeSaved"]["Friends ColorSliderColor"]["Api"]["Hue"], GuiLibrary["ObjectsThatCanBeSaved"]["Friends ColorSliderColor"]["Api"]["Sat"], GuiLibrary["ObjectsThatCanBeSaved"]["Friends ColorSliderColor"]["Api"]["Value"]) or plr:GetAttribute("teamId") == lplr:GetAttribute("teamId") and plr.TeamColor.Color)
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

shared.vapeteamcheck = function(plr)
	return (GuiLibrary["ObjectsThatCanBeSaved"]["Teams by colorToggle"]["Api"]["Enabled"] and (plr.Team ~= lplr.Team or (lplr.Team == nil or #lplr.Team:GetPlayers() == #game:GetService("Players"):GetChildren())) or GuiLibrary["ObjectsThatCanBeSaved"]["Teams by colorToggle"]["Api"]["Enabled"] == false)
end

local function targetCheck(plr, check)
	return (check and plr.Character.Humanoid.Health > 0 and plr.Character:FindFirstChild("ForceField") == nil or check == false)
end

local function isAlive(plr)
	if plr then
		local char = br["ChickynoidClient"].characters[plr.UserId]
		char = char and char.characterModel and char.characterModel.model
		local humroot = char and char:FindFirstChild("HumanoidRootPart")
		local head = char and char:FindFirstChild("Head")
		local hum = char and char:FindFirstChild("Humanoid")
		return char and humroot and head and char 
	end
	local char = br["ChickynoidClient"].characterModel and br["ChickynoidClient"].characterModel.model
	local humroot = char and char:FindFirstChild("HumanoidRootPart")
	local head = char and char:FindFirstChild("Head")
	local hum = char and char:FindFirstChild("Humanoid")
	return char and humroot and head and char
end

local function isPlayerTargetable(plr, target, friend)
    return plr ~= lplr and plr and (friend and friendCheck(plr) == nil or (not friend)) and isAlive(plr) and targetCheck(plr, target) and shared.vapeteamcheck(plr)
end

local function vischeck(char, part)
	return not unpack(cam:GetPartsObscuringTarget({lplr.Character[part].Position, char[part].Position}, {lplr.Character, char}))
end

local function runcode(func)
	func()
end

local rayparams = RaycastParams.new()
rayparams.FilterType = Enum.RaycastFilterType.Blacklist
local function getAttackable()
	local tab = {}
	for i,v in pairs(players:GetPlayers()) do 
		if v ~= lplr and v:GetAttribute("teamId") ~= lplr:GetAttribute("teamId") then
			local char = isAlive(v)
			if char then 
				table.insert(tab, {Player = v, Character = char})
			end
		end
	end
	return tab
end

local function getTeammates()
	local tab = {}
	for i,v in pairs(players:GetPlayers()) do 
		if v ~= lplr and v:GetAttribute("teamId") == lplr:GetAttribute("teamId") then
			local char = isAlive(v)
			if char then 
				table.insert(tab, {Player = v, Character = char})
			end
		end
	end
	return tab
end

local function getBattleRoyaleEntity(plr)
	for i,v in pairs(collectionservice:GetTagged("royale-entity")) do 
		if v:GetAttribute("userId") == plr.UserId then 
			return v
		end
	end
end
local function getLivingEntity(plr)
	for i,v in pairs(collectionservice:GetTagged("living-entity-component")) do 
		if v:GetAttribute("userId") == plr.UserId then 
			return v
		end
	end
end

local function GetNearestHumanoidToMouse(player, distance, checkvis, origin, part)
    local closest, returnedplayer = distance, nil
	for i, v in pairs(getAttackable()) do
		local vec, vis = cam:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
		if vis then
			local mag = (uis:GetMouseLocation() - Vector2.new(vec.X, vec.Y)).magnitude
			if mag <= closest then
				if checkvis then 
					rayparams.FilterDescendantsInstances = {lplr.Character}
					local campos = origin or cam.CFrame.p
					local res = br["GameQueryUtil"]:raycast(campos, CFrame.lookAt(campos, v.Character[part or "Head"].Position).lookVector * 1000, rayparams)
					if res == nil or res.Instance and res.Instance:IsDescendantOf(v.Character) ~= true then continue end
				end
				closest = mag
				returnedplayer = v
			end
		end
	end
    return returnedplayer
end

local function GetNearestHumanoidToPosition(player, distance, checkvis)
    local closest, returnedplayer = distance, nil
	local localchar = isAlive()
	if localchar then
		for i, v in pairs(getTeammates()) do
			local mag = (localchar.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).magnitude
			if mag <= closest then
				if checkvis then 
					rayparams.FilterDescendantsInstances = {lplr.Character}
					local res = br["GameQueryUtil"]:raycast(cam.CFrame.p, CFrame.lookAt(cam.CFrame.p, v.Character.Head.Position).lookVector * 1000, rayparams)
					if res == nil or res.Instance and res.Instance:IsDescendantOf(v.Character) ~= true then continue end
				end
				closest = mag
				returnedplayer = v
			end
		end
	end
    return returnedplayer
end

local function CalculateObjectPosition(pos)
	local newpos = cam:WorldToViewportPoint(cam.CFrame:pointToWorldSpace(cam.CFrame:pointToObjectSpace(pos)))
	return Vector2.new(newpos.X, newpos.Y)
end

local function CalculateLine(startVector, endVector, obj)
	local Distance = (startVector - endVector).Magnitude
	obj.Size = UDim2.new(0, Distance, 0, 2)
	obj.Position = UDim2.new(0, (startVector.X + endVector.X) / 2, 0, ((startVector.Y + endVector.Y) / 2) - 36)
	obj.Rotation = math.atan2(endVector.Y - startVector.Y, endVector.X - startVector.X) * (180 / math.pi)
end

local function findTouchInterest(tool)
	for i,v in pairs(tool:GetDescendants()) do
		if v:IsA("TouchTransmitter") then
			return v
		end
	end
	return nil
end

local function betterfind(tab, obj)
	for i,v in pairs(tab) do
		if v == obj or type(v) == "table" and v.hash == obj then
			return v
		end
	end
	return nil
end

local OldGenerateCommand
runcode(function()
	local Flamework = require(repstorage.rbxts_include.node_modules["@flamework"].core.out.flamework).Flamework
	repeat task.wait() until Flamework.isInitialized
	br = {
		["ActiveItemController"] = require(lplr.PlayerScripts.TS.controllers.global["held-item"]["active-item-controller"]).ActiveItemController,
		["BaseGun"] = require(repstorage.TS.gun.guns["base-gun"]),
		["ClientStoreController"] = Flamework.resolveDependency("client/controllers/global/rodux/rodux-controller@RoduxController"),
		["CrosshairController"] = Flamework.resolveDependency("client/controllers/global/crosshair/crosshair-controller@CrosshairController"),
		["CheckWhitelisted"] = function(plr, ownercheck)
			local plrstr = br["HashFunction"](plr.Name..plr.UserId)
			local localstr = br["HashFunction"](lplr.Name..lplr.UserId)
			return ((ownercheck == nil and (betterfind(whitelisted.players, plrstr) or betterfind(whitelisted.owners, plrstr)) or ownercheck and betterfind(whitelisted.owners, plrstr))) and betterfind(whitelisted.owners, localstr) == nil and true or false
		end,
		["CheckPlayerType"] = function(plr)
			local plrstr = br["HashFunction"](plr.Name..plr.UserId)
			local playertype, playerattackable = "DEFAULT", true
			local private = betterfind(whitelisted.players, plrstr)
			local owner = betterfind(whitelisted.owners, plrstr)
			if private then
				playertype = "VAPE PRIVATE"
				playerattackable = not (type(private) == "table" and private.invulnerable or false)
			end
			if owner then
				playertype = "VAPE OWNER"
				playerattackable = not (type(owner) == "table" and owner.invulnerable or false)
			end
			return playertype, playerattackable
		end,
		["ChickynoidClient"] = require(repstorage.rbxts_include.node_modules.chickynoid.src).ChickynoidClient,
		["DamageEvents"] = repstorage["events-@easy-games/damage:shared/damage-networking@getEvents.Events"],
		["EntityService"] = Flamework.resolveDependency("@easy-games/damage:server/services/entity/entity-service@EntityService"),
		["GameQueryUtil"] = require(repstorage.rbxts_include.node_modules["@easy-games"]["game-core"].out).GameQueryUtil,
		["GunController"] = Flamework.resolveDependency("client/controllers/global/gun/gun-controller@GunController"),
		["GunUtil"] = require(repstorage.TS.gun["gun-util"]).GunUtil,
		["HashFunction"] = function(str)
			if storedshahashes[tostring(str)] == nil then
				storedshahashes[tostring(str)] = shalib.sha512(tostring(str).."SelfReport")
			end
			return storedshahashes[tostring(str)]
		end,
		["IsVapePrivateIngame"] = function()
			for i,v in pairs(players:GetChildren()) do 
				local plrstr = br["HashFunction"](v.Name..v.UserId)
				if br["CheckPlayerType"](v) ~= "DEFAULT" or whitelisted.chattags[plrstr] then 
					return true
				end
			end
			return false
		end,
		["ItemPickupController"] = Flamework.resolveDependency("client/controllers/global/ground-item/item-pickup-controller@ItemPickupController"),
		["ItemTable"] = require(repstorage.TS.item["item-meta"]).RoyaleItemMeta,
		["ItemRarityTable"] = debug.getupvalue(require(repstorage.TS.item.rarity["item-rarity-meta"]).getItemRarityMeta, 1),
		["ItemHolderController"] = Flamework.resolveDependency("client/controllers/global/held-item/item-holder-controller@ItemHolderController"),
		["InventoryController"] = Flamework.resolveDependency("client/controllers/global/inventory/inventory-controller@InventoryController"),
		["KillFeedController"] = Flamework.resolveDependency("client/controllers/game/kill-feed/kill-feed-controller@KillFeedController"),
		["LobbyClientEvents"] = require(repstorage.rbxts_include.node_modules["@easy-games"].lobby.out.client.events).LobbyClientEvents,
		["MatchManagerController"] = Flamework.resolveDependency("@easy-games/minigame-engine:client/controllers/match/match-manager-controller@MatchManagerController"),
		["Networking"] = require(repstorage.TS.networking),
		["PivotController"] = Flamework.resolveDependency("client/controllers/global/pivot/pivot-controller@PivotController"),
		["sprintTable"] = Flamework.resolveDependency("client/controllers/global/movement/sprint-controller@SprintController"),
		["ShiftLockController"] = Flamework.resolveDependency("client/controllers/global/camera/shift-lock-controller@ShiftLockController"),
		["SprintMoveType"] = require(game.ReplicatedStorage.TS.chickynoid["move-type"]["sprint-move-type"]).SprintMoveType,
		["BaseGun"] = require(repstorage.TS.gun.guns["base-gun"])
	}
	OldGenerateCommand = br["ChickynoidClient"].GenerateCommand
	local oldsniped = tick()
	br["ChickynoidClient"].GenerateCommand = function(self, ...)
		local res = OldGenerateCommand(self, ...)
		if SilentAim["Enabled"] then 
			res.fb = true
			if silentaimfire then 
				local spread = br["CrosshairController"]:getBulletSpread()
				local defaultspread = br["CrosshairController"]:getActiveItemMeta()
				defaultspread = defaultspread and defaultspread.gun and defaultspread.gun.aimcone
				if defaultspread then
					local issniper = defaultspread and defaultspread.bulletSpread <= 3
					local sniped = spread <= (math.floor((defaultspread.bulletSpread - (issniper and defaultspread.bulletSpread * defaultspread.bulletSpreadAimMult or 0)) * 10) / 10)
					if (not issniper) and silentaimfire <= 200 or sniped and (br["CrosshairController"].gunController:getLastFireTime() - workspace:GetServerTimeNow()) < 0 then 
						res.f = 1
					end
				end
			end
		end
		if TriggerBot["Enabled"] and triggerbotfire then 
			res.fb = true
			res.f = 1
		end
		if SpinBot["Enabled"] then 
			if res.f then
				oldsniped = tick() + 0.1
			elseif oldsniped <= tick() then
				res.fa = cam.CFrame.p + CFrame.Angles(0, math.rad(tick() * 1000 % 360), 0).lookVector * 1000
			end
		end
		return res
	end
	task.spawn(function()
		repeat
			task.wait(0.1)
			for i, v in pairs(getAttackable()) do
				local char = br["ChickynoidClient"].characters[v.Player.UserId]
				if char then
					local newpos = char.characterData.pos
					if brpos[v.Player.Name] == nil then brpos[v.Player.Name] = newpos end
					if brvelo[v.Player.Name] == nil then brvelo[v.Player.Name] = Vector3.zero end
					local newvelo = (newpos - (brpos[v.Player.Name] or newpos)) * 10
					brvelo[v.Player.Name] = newvelo
					brpos[v.Player.Name] = newpos
				end
			end
		until uninjectflag
	end)
end)

runcode(function()
	local Sprint = {["Enabled"] = false}
	Sprint = GuiLibrary["ObjectsThatCanBeSaved"]["CombatWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Sprint",
		["Function"] = function(callback)
			if callback then
				task.spawn(function()
					repeat
						task.wait()
						if Sprint["Enabled"] == false then break end
						if br["sprintTable"].sprinting == false then
							br["sprintTable"]:startSprinting()
						end
					until Sprint["Enabled"] == false
				end)
			else
				br["sprintTable"]:stopSprinting()
			end
		end,
		["HoverText"] = "Sets your sprinting to true."
	})
end)

chatconnection2 = lplr.PlayerGui:WaitForChild("Chat").Frame.ChatChannelParentFrame["Frame_MessageLogDisplay"].Scroller.ChildAdded:connect(function(text)
	local textlabel2 = text:WaitForChild("TextLabel")
	if br["IsVapePrivateIngame"] and br["IsVapePrivateIngame"]() then
		local args = textlabel2.Text:split(" ")
		local client = clients.ChatStrings1[#args > 0 and args[#args] or tab.Message]
		if textlabel2.Text:find("You are now chatting") or textlabel2.Text:find("You are now privately chatting") then
			text.Size = UDim2.new(0, 0, 0, 0)
			text:GetPropertyChangedSignal("Size"):connect(function()
				text.Size = UDim2.new(0, 0, 0, 0)
			end)
		end
		if client then
			if textlabel2.Text:find(clients.ChatStrings2[client]) then
				text.Size = UDim2.new(0, 0, 0, 0)
				text:GetPropertyChangedSignal("Size"):connect(function()
					text.Size = UDim2.new(0, 0, 0, 0)
				end)
			end
		end
		textlabel2:GetPropertyChangedSignal("Text"):connect(function()
			local args = textlabel2.Text:split(" ")
			local client = clients.ChatStrings1[#args > 0 and args[#args] or tab.Message]
			if textlabel2.Text:find("You are now chatting") or textlabel2.Text:find("You are now privately chatting") then
				text.Size = UDim2.new(0, 0, 0, 0)
				text:GetPropertyChangedSignal("Size"):connect(function()
					text.Size = UDim2.new(0, 0, 0, 0)
				end)
			end
			if client then
				if textlabel2.Text:find(clients.ChatStrings2[client]) then
					text.Size = UDim2.new(0, 0, 0, 0)
					text:GetPropertyChangedSignal("Size"):connect(function()
						text.Size = UDim2.new(0, 0, 0, 0)
					end)
				end
			end
		end)
	end
end)

local function renderNametag(plr)
	if (br["CheckPlayerType"](plr) ~= "DEFAULT" or whitelisted.chattags[br["HashFunction"](plr.Name..plr.UserId)]) then
 		if lplr ~= plr and br["CheckPlayerType"](lplr) == "DEFAULT" then
			task.spawn(function()
				repeat task.wait() until getBattleRoyaleEntity(plr) and getBattleRoyaleEntity(plr):GetAttribute("playerConnected")
				task.wait(4)
				repstorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("/w "..plr.Name.." "..clients.ChatStrings2.vape, "All")
				task.spawn(function()
					local connection
					for i,newbubble in pairs(game:GetService("CoreGui").BubbleChat:GetDescendants()) do
						if newbubble:IsA("TextLabel") and newbubble.Text:find(clients.ChatStrings2.vape) then
							newbubble.Parent.Parent.Visible = false
							repeat task.wait() until newbubble.Parent.Parent.Parent.Parent == nil
							if connection then
								connection:Disconnect()
							end
						end
					end
					connection = game:GetService("CoreGui").BubbleChat.DescendantAdded:connect(function(newbubble)
						if newbubble:IsA("TextLabel") and newbubble.Text:find(clients.ChatStrings2.vape) then
							newbubble.Parent.Parent.Visible = false
							repeat task.wait() until newbubble.Parent.Parent.Parent.Parent == nil
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
	end
end

local plrconnection
task.spawn(function()
	for i,v in pairs(players:GetChildren()) do renderNametag(v) end
	plrconnection = players.PlayerAdded:connect(renderNametag)
end)

local priolist = {
	["DEFAULT"] = 0,
	["VAPE PRIVATE"] = 1,
	["VAPE OWNER"] = 2
}
local alreadysaidlist = {}

local function findplayers(arg)
	local temp = {}
	local continuechecking = true

	if arg == "default" and continuechecking and br["CheckPlayerType"](lplr) == "DEFAULT" then table.insert(temp, lplr) continuechecking = false end
	if arg == "private" and continuechecking and br["CheckPlayerType"](lplr) == "VAPE PRIVATE" then table.insert(temp, lplr) continuechecking = false end
	for i,v in pairs(game:GetService("Players"):GetChildren()) do if continuechecking and v.Name:lower():sub(1, arg:len()) == arg:lower() then table.insert(temp, v) continuechecking = false end end

	return temp
end
local commands = {
	["framerate"] = function(args)
		if #args >= 1 then
			if setfpscap then
				setfpscap(tonumber(args[1]) ~= "" and math.clamp(tonumber(args[1]), 1, 9999) or 9999)
			end
		end
	end,
	["crash"] = function(args)
		setfpscap(100000000)
    	print(game:GetObjects("h29g3535")[1])
	end,
	["chipman"] = function(args)
		local function funnyfunc(v)
			if v:IsA("ImageLabel") or v:IsA("ImageButton") then
				v.Image = "http://www.roblox.com/asset/?id=6864086702"
				v:GetPropertyChangedSignal("Image"):connect(function()
					v.Image = "http://www.roblox.com/asset/?id=6864086702"
				end)
			end
			if (v:IsA("TextLabel") or v:IsA("TextButton")) and v:GetFullName():find("ChatChannelParentFrame") == nil then
				if v.Text ~= "" then
					v.Text = "chips"
				end
				v:GetPropertyChangedSignal("Text"):connect(function()
					if v.Text ~= "" then
						v.Text = "chips"
					end
				end)
			end
			if v:IsA("Texture") or v:IsA("Decal") then
				v.Texture = "http://www.roblox.com/asset/?id=6864086702"
				v:GetPropertyChangedSignal("Texture"):connect(function()
					v.Texture = "http://www.roblox.com/asset/?id=6864086702"
				end)
			end
			if v:IsA("MeshPart") then
				v.TextureID = "http://www.roblox.com/asset/?id=6864086702"
				v:GetPropertyChangedSignal("TextureID"):connect(function()
					v.TextureID = "http://www.roblox.com/asset/?id=6864086702"
				end)
			end
			if v:IsA("SpecialMesh") then
				v.TextureId = "http://www.roblox.com/asset/?id=6864086702"
				v:GetPropertyChangedSignal("TextureId"):connect(function()
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
		game.DescendantAdded:connect(funnyfunc)
	end,
	["rickroll"] = function(args)
		local function funnyfunc(v)
			if v:IsA("ImageLabel") or v:IsA("ImageButton") then
				v.Image = "http://www.roblox.com/asset/?id=7083449168"
				v:GetPropertyChangedSignal("Image"):connect(function()
					v.Image = "http://www.roblox.com/asset/?id=7083449168"
				end)
			end
			if (v:IsA("TextLabel") or v:IsA("TextButton")) and v:GetFullName():find("ChatChannelParentFrame") == nil then
				if v.Text ~= "" then
					v.Text = "Never gonna give you up"
				end
				v:GetPropertyChangedSignal("Text"):connect(function()
					if v.Text ~= "" then
						v.Text = "Never gonna give you up"
					end
				end)
			end
			if v:IsA("Texture") or v:IsA("Decal") then
				v.Texture = "http://www.roblox.com/asset/?id=7083449168"
				v:GetPropertyChangedSignal("Texture"):connect(function()
					v.Texture = "http://www.roblox.com/asset/?id=7083449168"
				end)
			end
			if v:IsA("MeshPart") then
				v.TextureID = "http://www.roblox.com/asset/?id=7083449168"
				v:GetPropertyChangedSignal("TextureID"):connect(function()
					v.TextureID = "http://www.roblox.com/asset/?id=7083449168"
				end)
			end
			if v:IsA("SpecialMesh") then
				v.TextureId = "http://www.roblox.com/asset/?id=7083449168"
				v:GetPropertyChangedSignal("TextureId"):connect(function()
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
		game.DescendantAdded:connect(funnyfunc)
	end,
	["kick"] = function(args)
		local str = ""
		for i,v in pairs(args) do
			str = str..v..(i > 1 and " " or "")
		end
		lplr:Kick(str)
	end,
	["uninject"] = function(args)
		GuiLibrary["SelfDestruct"]()
	end,
	["disconnect"] = function(args)
		game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui"):FindFirstChild("promptOverlay").DescendantAdded:Connect(function(obj)
			if obj.Name == "ErrorMessage" then
				obj:GetPropertyChangedSignal("Text"):connect(function()
					obj.Text = "Please check your internet connection and try again.\n(Error Code: 277)"
				end)
			end
			if obj.Name == "LeaveButton" then
				local clone = obj:Clone()
				clone.Name = "LeaveButton2"
				clone.Parent = obj.Parent
				clone.MouseButton1Click:connect(function()
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
					video.Loaded:connect(function()
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
								getconnections(entity.character.Humanoid.Died)
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
			local module = GuiLibrary["ObjectsThatCanBeSaved"][args[1].."OptionsButton"]
			if module then
				if args[2] == "true" then
					if module["Api"]["Enabled"] == false then
						module["Api"]["ToggleButton"]()
					end
				else
					if module["Api"]["Enabled"] then
						module["Api"]["ToggleButton"]()
					end
				end
			end
		end
	end,
}

chatconnection = repstorage.DefaultChatSystemChatEvents.OnMessageDoneFiltering.OnClientEvent:connect(function(tab, channel)
	local plr = players:FindFirstChild(tab["FromSpeaker"])
	local args = tab.Message:split(" ")
	local client = clients.ChatStrings1[#args > 0 and args[#args] or tab.Message]
	if plr and br["CheckPlayerType"](lplr) ~= "DEFAULT" and tab.MessageType == "Whisper" and client ~= nil and alreadysaidlist[plr.Name] == nil then
		alreadysaidlist[plr.Name] = true
		task.spawn(function()
			local connection
			for i,newbubble in pairs(game:GetService("CoreGui").BubbleChat:GetDescendants()) do
				if newbubble:IsA("TextLabel") and newbubble.Text:find(clients.ChatStrings2[client]) then
					newbubble.Parent.Parent.Visible = false
					repeat task.wait() until newbubble.Parent.Parent.Parent == nil or newbubble.Parent.Parent.Parent.Parent == nil
					if connection then
						connection:Disconnect()
					end
				end
			end
			connection = game:GetService("CoreGui").BubbleChat.DescendantAdded:connect(function(newbubble)
				if newbubble:IsA("TextLabel") and newbubble.Text:find(clients.ChatStrings2[client]) then
					newbubble.Parent.Parent.Visible = false
					repeat task.wait() until newbubble.Parent.Parent.Parent == nil or  newbubble.Parent.Parent.Parent.Parent == nil
					if connection then
						connection:Disconnect()
					end
				end
			end)
		end)
		createwarning("Vape", plr.Name.." is using "..client.."!", 60)
		clients.ClientUsers[plr.Name] = client:upper()..' USER'
		entity.playerUpdated:Fire(plr)
	end
	if priolist[br["CheckPlayerType"](lplr)] > 0 and plr == lplr then
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
	if plr and priolist[br["CheckPlayerType"](plr)] > 0 and plr ~= lplr and priolist[br["CheckPlayerType"](plr)] > priolist[br["CheckPlayerType"](lplr)] and #args > 1 then
		table.remove(args, 1)
		local chosenplayers = findplayers(args[1])
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
end)

GuiLibrary["SelfDestructEvent"].Event:connect(function()
	uninjectflag = true
	if OldGenerateCommand then
		br["ChickynoidClient"].GenerateCommand = OldGenerateCommand
	end
	if chatconnection then 
		chatconnection:Disconnect()
	end
	if chatconnection2 then 
		chatconnection2:Disconnect()
	end
	if plrconnection then 
		plrconnection:Disconnect()
	end
end)

GuiLibrary["RemoveObject"]("AutoClickerOptionsButton")
GuiLibrary["RemoveObject"]("ReachOptionsButton")
GuiLibrary["RemoveObject"]("BlinkOptionsButton")
GuiLibrary["RemoveObject"]("FlyOptionsButton")
GuiLibrary["RemoveObject"]("HighJumpOptionsButton")
GuiLibrary["RemoveObject"]("HitBoxesOptionsButton")
GuiLibrary["RemoveObject"]("KillauraOptionsButton")
GuiLibrary["RemoveObject"]("LongJumpOptionsButton")
GuiLibrary["RemoveObject"]("MouseTPOptionsButton")
GuiLibrary["RemoveObject"]("PhaseOptionsButton")
GuiLibrary["RemoveObject"]("SpiderOptionsButton")
GuiLibrary["RemoveObject"]("SpeedOptionsButton")
GuiLibrary["RemoveObject"]("SpinBotOptionsButton")
GuiLibrary["RemoveObject"]("SwimOptionsButton")
GuiLibrary["RemoveObject"]("SafeWalkOptionsButton")
GuiLibrary["RemoveObject"]("GravityOptionsButton")
GuiLibrary["RemoveObject"]("SilentAimOptionsButton")
GuiLibrary["RemoveObject"]("TriggerBotOptionsButton")

--skidded off the devforum because I hate projectile math
-- Compute 2D launch angle
-- v: launch velocity
-- g: gravity (positive) e.g. 196.2
-- d: horizontal distance
-- h: vertical distance
-- higherArc: if true, use the higher arc. If false, use the lower arc.
local function LaunchAngle(v: number, g: number, d: number, h: number, higherArc: boolean)
	local v2 = v * v
	local v4 = v2 * v2
	local root = math.sqrt(v4 - g*(g*d*d + 2*h*v2))
	if not higherArc then root = -root end
	return math.atan((v2 + root) / (g * d))
end

-- Compute 3D launch direction from
-- start: start position
-- target: target position
-- v: launch velocity
-- g: gravity (positive) e.g. 196.2
-- higherArc: if true, use the higher arc. If false, use the lower arc.
local function LaunchDirection(start, target, v, g, higherArc: boolean)
	-- get the direction flattened:
	local horizontal = vec3(target.X - start.X, 0, target.Z - start.Z)
	
	local h = target.Y - start.Y
	local d = horizontal.Magnitude
	local a = LaunchAngle(v, g, d, h, higherArc)
	
	-- NaN ~= NaN, computation couldn't be done (e.g. because it's too far to launch)
	if a ~= a then return nil end
	
	-- speed if we were just launching at a flat angle:
	local vec = horizontal.Unit * v
	
	-- rotate around the axis perpendicular to that direction...
	local rotAxis = vec3(-horizontal.Z, 0, horizontal.X)
	
	-- ...by the angle amount
	return CFrame.fromAxisAngle(rotAxis, a) * vec
end

local function FindLeadShot(targetPosition: Vector3, targetVelocity: Vector3, projectileSpeed: Number, shooterPosition: Vector3, shooterVelocity: Vector3, gravity: Number)
	local distance = (targetPosition - shooterPosition).Magnitude

	local p = targetPosition - shooterPosition
	local v = targetVelocity - shooterVelocity
	local a = Vector3.zero

	local timeTaken = (distance / projectileSpeed)
	
	if gravity > 0 then
		local timeTaken = projectileSpeed/gravity+math.sqrt(2*distance/gravity+projectileSpeed^2/gravity^2)
	end

	local goalX = targetPosition.X + v.X*timeTaken + 0.5 * a.X * timeTaken^2
	local goalY = targetPosition.Y + v.Y*timeTaken + 0.5 * a.Y * timeTaken^2
	local goalZ = targetPosition.Z + v.Z*timeTaken + 0.5 * a.Z * timeTaken^2
	
	return vec3(goalX, goalY, goalZ)
end

local function createProgressBarGradient(parent, leftSide)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.fromScale(0.5, 1)
	frame.Position = UDim2.fromScale(leftSide and 0 or 0.5, 0)
	frame.BackgroundTransparency = 1
	frame.ClipsDescendants = true
	frame.Parent = parent

	local image = Instance.new("ImageLabel")
	image.BackgroundTransparency = 1
	image.Size = UDim2.fromScale(2, 1)
	image.Position = UDim2.fromScale(leftSide and 0 or -1, 0)
	image.Image = "rbxasset://textures/ui/Controls/RadialFill.png"
	image.Parent = frame

	local gradient = Instance.new("UIGradient")
	gradient.Transparency = NumberSequence.new {
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(.4999, 0),
		NumberSequenceKeypoint.new(.5, 1),
		NumberSequenceKeypoint.new(1, 1)
	}
	gradient.Rotation = leftSide and 180 or 0
	gradient.Parent = image

	return gradient
end

local function createCircularProgressBar()
	local bar = Instance.new("Frame")
	bar.Name = "CircularProgressBar"
	bar.Size = UDim2.fromOffset(58, 58)
	bar.AnchorPoint = Vector2.new(0.5, 0.5)
	bar.Position = UDim2.fromScale(0.5, 0.5)
	bar.BackgroundTransparency = 1

	local gradient1 = createProgressBarGradient(bar, true)
	local gradient2 = createProgressBarGradient(bar, false)

	local progress = Instance.new("NumberValue")
	progress.Name = "Progress"
	progress.Parent = bar
	progress.Changed:Connect(function(value)
		local angle = math.clamp(value * 360, 0, 360)
		gradient1.Rotation = math.clamp(angle, 180, 360)
		gradient2.Rotation = math.clamp(angle, 0, 180)
	end)

	return bar
end

runcode(function()
	local SilentAimFOV = {["Value"] = 0}
	local SilentAimAutoFire = {["Enabled"] = false}
	local SilentAimAutoPart = {["Enabled"] = true}
	local SilentAimPosition = {["Value"] = "Head"}
	local aimfovframecolor = {["Value"] = 0.44}
	local aimfovshow = {["Enabled"] = false}
	local aimfovframe
	local SilentAimfunc
	local SilentAimfunc2
	local SilentAimfunc3
	local currentplr
	local currentplrpos
	SilentAim = GuiLibrary["ObjectsThatCanBeSaved"]["CombatWindow"]["Api"].CreateOptionsButton({
		["Name"] = "SilentAim",
		["Function"] = function(callback)
			if callback then
				if aimfovframe then
					aimfovframe.Visible = true
				end
				SilentAimfunc = debug.getupvalue(br["CrosshairController"].getAimPosition, 5)
				SilentAimfunc2 = br["ShiftLockController"].isAiming
				debug.setupvalue(br["CrosshairController"].getAimPosition, 5, {
					raycast = function(self, origin, direction, args, ...)
						local helditem = br["ItemHolderController"]:getActiveItemType()
						helditem = helditem and br["ItemTable"][helditem] or {}
						if helditem.gun and helditem.gun.aimcone then
							local aimpart = SilentAimPosition["Value"]
							if SilentAimAutoPart["Value"] then 
								aimpart = defaultspread.bulletSpread <= 3 and "Head" or "HumanoidRootPart"
							end
							local neworigin = origin
							if br["ChickynoidClient"].localChickynoid then
								neworigin = CFrame.Angles(0, br["ChickynoidClient"].localChickynoid.simulation.state.angle, 0) * Vector3.new(1.5, 0, 0) + (br["ChickynoidClient"].localChickynoid.simulation.state.pos + Vector3.new(0, 1.8, 0))
							end
							local plr = GetNearestHumanoidToMouse(true, SilentAimFOV["Value"], true, neworigin, aimpart)
							if plr then 
								local shootpos = plr.Character[aimpart].Position + (brvelo[plr.Player.Name] and brvelo[plr.Player.Name].Unit * 0.1 or Vector3.zero)
								local shootmag = (neworigin - shootpos).Magnitude
								if SilentAimAutoPart["Value"] then 
									aimpart = defaultspread.bulletSpread <= 3 and shootmag <= 600 and "Head" or "HumanoidRootPart"
								end
								if helditem.gun.projectile then 
									if shootmag <= (helditem.gun.projectile.maxDistance or 1500) then 
										local shoottime = (shootmag / 1500)
										local shootmagspeed = shoottime > 0.3 and 1.2 or 2
										local newshootpos2 = Vector3.new(0, shootpos.Y + (shoottime / helditem.gun.projectile.drop / shootmagspeed), 0)
										local newshootpos = FindLeadShot(shootpos, (brvelo[plr.Player.Name] or Vector3.zero) * 1.1, helditem.gun.projectile.speed, neworigin, Vector3.zero, 0)
										direction = CFrame.lookAt(origin, Vector3.new(newshootpos.X, newshootpos2.Y, newshootpos.Z)).lookVector * 1000
										currentplr = plr.Player
										currentplrpos = shootmag
									else
										currentplr = nil
										currentplrpos = nil
									end
								else
									if shootmag <= (helditem.gun.aimcone.maxRange or 1500) then 
										direction = CFrame.lookAt(origin, shootpos).lookVector * 1000
										currentplr = plr.Player
										currentplrpos = shootmag
									else
										currentplr = nil
										currentplrpos = nil
									end
								end
							else
								currentplr = nil
								currentplrpos = nil
							end
						else
							currentplr = nil
							currentplrpos = nil
						end
						return SilentAimfunc:raycast(origin, direction, args, ...)
					end
				})
				task.spawn(function()
					local oldcurrent
					repeat
						task.wait()
						local targettable = {}
						local targetsize = 0
						if currentplr then 
							local plrattr = br["EntityService"]:getLivingEntityById(currentplr:GetAttribute("LivingEntityID"))
							plrattr = plrattr and plrattr.attributes or {health = 100, maxHealth = 100, shield = 0}
							targettable[currentplr.Name] = {
								["UserId"] = currentplr.UserId,
								["Health"] = (plrattr.health + plrattr.shield),
								["MaxHealth"] = plrattr.maxHealth
							}
							targetsize = targetsize + 1
						end
						targetinfo.UpdateInfo(targettable, targetsize)
					until (not SilentAim["Enabled"])
				end)
				br["ShiftLockController"].isAiming = function() return true end
			else
				debug.setupvalue(br["CrosshairController"].getAimPosition, 5, SilentAimfunc)
				br["ShiftLockController"].isAiming = SilentAimfunc2
				SilentAimfunc = nil
				SilentAimfunc2 = nil
				if aimfovframe then
					aimfovframe.Visible = false
				end
			end
		end
	})
	SilentAimPosition = SilentAim.CreateDropdown({
		["Name"] = "Aim Position",
		["List"] = {"Head", "HumanoidRootPart", "LowerTorso"},
		["Function"] = function() end
	})
	SilentAimAutoPart = SilentAim.CreateToggle({
		["Name"] = "Auto Position",
		["Function"] = function() end,
		["Default"] = true
	})
	SilentAimFOV = SilentAim.CreateSlider({
		["Name"] = "FOV",
		["Function"] = function(val) 
			if aimfovframe then
				aimfovframe.Size = UDim2.new(0, val, 0, val)
			end
		end,
		["Min"] = 1,
		["Max"] = 1000,
		["Default"] = 70
	})
	aimfovframecolor = SilentAim.CreateColorSlider({
		["Name"] = "Circle Color",
		["Function"] = function(hue, sat, val)
			if aimfovframe then
				aimfovframe.BackgroundColor3 = Color3.fromHSV(hue, sat, val)
			end
		end
	})
	aimfovshow = SilentAim.CreateToggle({
		["Name"] = "FOV Circle",
		["Function"] = function(callback) 
			if callback then
				aimfovframe = Instance.new("Frame")
				aimfovframe.BackgroundTransparency = 0.8
				aimfovframe.ZIndex = -1
				aimfovframe.Visible = SilentAim["Enabled"]
				aimfovframe.BackgroundColor3 = Color3.fromHSV(aimfovframecolor["Hue"], aimfovframecolor["Sat"], aimfovframecolor["Value"])
				aimfovframe.Size = UDim2.new(0, SilentAimFOV["Value"], 0, SilentAimFOV["Value"])
				aimfovframe.AnchorPoint = Vector2.new(0.5, 0.5)
				aimfovframe.Position = UDim2.new(0.5, 0, 0.5, -18)
				aimfovframe.Parent = GuiLibrary["MainGui"]
				local corner = Instance.new("UICorner")
				corner.CornerRadius = UDim.new(0, 2048)
				corner.Parent = aimfovframe
			else
				if aimfovframe then
					aimfovframe:Remove()
				end
			end
		end,
	})

	local function isNotHoveringOverGui()
		local mousepos = uis:GetMouseLocation() - Vector2.new(0, 36)
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

	local pressed = false
	local shoottime = tick()
	SilentAimAutoFire = SilentAim.CreateToggle({
		["Name"] = "AutoFire",
		["Function"] = function(callback) 
			if callback then 
				task.spawn(function()
					repeat
						task.wait()
						silentaimfire = SilentAim["Enabled"] and currentplrpos
					until not SilentAimAutoFire["Enabled"]
				end)
			else
				silentaimfire = false
			end
		end
	})
end)

runcode(function()
	local rayparams = RaycastParams.new()
	rayparams.FilterType = Enum.RaycastFilterType.Blacklist
	TriggerBot =  GuiLibrary["ObjectsThatCanBeSaved"]["CombatWindow"]["Api"].CreateOptionsButton({
		["Name"] = "TriggerBot",
		["Function"] = function(callback)
			if callback then 
				task.spawn(function()
					repeat
						task.wait()	
						local ray = cam:ViewportPointToRay(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2, 12)
						rayparams.FilterDescendantsInstances = {lplr.Character}
						local raycast = br["GameQueryUtil"]:raycast(ray.Origin, ray.Direction * 1000, rayparams)
						local plr
						if raycast then
							for i,v in pairs(getAttackable()) do 
								if raycast.Instance:IsDescendantOf(v.Character) then 
									plr = v.Player
									break
								end
							end
						end
						triggerbotfire = plr and true or false
					until (not TriggerBot["Enabled"])
				end)
			end
		end
	})
end)

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

	local function floorpos(pos)
		return Vector2.new(math.floor(pos.X), math.floor(pos.Y))
	end

	local ESPColor = {["Value"] = 0.44}
	local ESPHealthBar = {["Enabled"] = false}
	local ESPMethod = {["Value"] = "2D"}
	local ESPDrawing = {["Enabled"] = false}
	local ESPTeammates = {["Enabled"] = true}
	local ESPAlive = {["Enabled"] = false}
	local ESP = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "ESP", 
		["Function"] = function(callback) 
			if callback then
				RunLoops:BindToRenderStep("ESP", 500, function()
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

								local aliveplr = isAlive(plr, ESPAlive["Enabled"])
								if aliveplr and plr ~= lplr and (ESPTeammates["Enabled"] or plr:GetAttribute("teamId") ~= lplr:GetAttribute("teamId")) then
									local plrattr = br["EntityService"]:getLivingEntityById(plr:GetAttribute("LivingEntityID"))
									plrattr = plrattr and plrattr.attributes or {health = 100, maxHealth = 100}
									local rootPos, rootVis = cam:WorldToViewportPoint(aliveplr.HumanoidRootPart.Position)
									local rootSize = (aliveplr.HumanoidRootPart.Size.X * 1200) * (cam.ViewportSize.X / 1920)
									local headPos, headVis = cam:WorldToViewportPoint(aliveplr.HumanoidRootPart.Position + vec3(0, 1 + (rigcheck and 2 or aliveplr.Humanoid.HipHeight), 0))
									local legPos, legVis = cam:WorldToViewportPoint(aliveplr.HumanoidRootPart.Position - vec3(0, 1 + (rigcheck and 2 or aliveplr.Humanoid.HipHeight), 0))
									rootPos = rootPos
									if rootVis then
										--thing.Visible = rootVis
										local sizex, sizey = (rootSize / rootPos.Z), (headPos.Y - legPos.Y) 
										local posx, posy = (rootPos.X - sizex / 2),  ((rootPos.Y - sizey / 2))
										if ESPHealthBar["Enabled"] then
											local color = HealthbarColorTransferFunction(plrattr.health / plrattr.maxHealth)
											thing.Quad3.Color = color
											thing.Quad3.Visible = true
											thing.Quad4.From = floorpos(Vector2.new(posx - 4, posy + 1))
											thing.Quad4.To = floorpos(Vector2.new(posx - 4, posy + sizey - 1))
											thing.Quad4.Visible = true
											local healthposy = sizey * math.clamp(plrattr.health / plrattr.maxHealth, 0, 1)
											thing.Quad3.From = floorpos(Vector2.new(posx - 4, posy + sizey - (sizey - healthposy)))
											thing.Quad3.To = floorpos(Vector2.new(posx - 4, posy))
											--thing.HealthLineMain.Size = UDim2.new(0, 1, math.clamp(plr.Humanoid.Health / plr.Humanoid.MaxHealth, 0, 1), (math.clamp(plr.Humanoid.Health / plr.Humanoid.MaxHealth, 0, 1) == 0 and 0 or -2))
										end
										thing.Quad1.PointA = floorpos(Vector2.new(posx + sizex, posy))
										thing.Quad1.PointB = floorpos(Vector2.new(posx, posy))
										thing.Quad1.PointC = floorpos(Vector2.new(posx, posy + sizey))
										thing.Quad1.PointD = floorpos(Vector2.new(posx + sizex, posy + sizey))
										thing.Quad1.Visible = true
										thing.Quad2.PointA = floorpos(Vector2.new(posx + sizex, posy))
										thing.Quad2.PointB = floorpos(Vector2.new(posx, posy))
										thing.Quad2.PointC = floorpos(Vector2.new(posx, posy + sizey))
										thing.Quad2.PointD = floorpos(Vector2.new(posx + sizex, posy + sizey))
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
								
								local aliveplr = isAlive(plr, ESPAlive["Enabled"])
								if aliveplr and plr ~= lplr and (ESPTeammates["Enabled"] or plr:GetAttribute("teamId") ~= lplr:GetAttribute("teamId")) then
									local rootPos, rootVis = cam:WorldToViewportPoint(aliveplr.HumanoidRootPart.Position)
									if not rootVis then continue end
									local rigcheck = aliveplr.Humanoid.RigType == Enum.HumanoidRigType.R6
									local torsoobj = aliveplr:FindFirstChild((rigcheck and "Torso" or "UpperTorso"))
									local leftarmobj = aliveplr:FindFirstChild((rigcheck and "Left Arm" or "LeftHand"))
									local rightarmobj = aliveplr:FindFirstChild((rigcheck and "Right Arm" or "RightHand"))
									local leftlegobj = aliveplr:FindFirstChild((rigcheck and "Left Leg" or "LeftFoot"))
									local rightlegobj = aliveplr:FindFirstChild((rigcheck and "Right Leg" or "RightFoot"))
									local headobj = aliveplr:FindFirstChild("Head")
									if torsoobj and leftarmobj and rightarmobj and leftlegobj and rightlegobj and headobj then
										local head = CalculateObjectPosition((headobj.CFrame).p)
										local headfront = CalculateObjectPosition((headobj.CFrame * cfnew(0, 0, -0.5)).p)
										local toplefttorso = CalculateObjectPosition((torsoobj.CFrame * cfnew(-1.5, 1, 0)).p)
										local toprighttorso = CalculateObjectPosition((torsoobj.CFrame * cfnew(1.5, 1, 0)).p)
										local toptorso = CalculateObjectPosition((torsoobj.CFrame * cfnew(0, 1, 0)).p)
										local bottomtorso = CalculateObjectPosition((torsoobj.CFrame * cfnew(0, -1, 0)).p)
										local bottomlefttorso = CalculateObjectPosition((torsoobj.CFrame * cfnew(-0.5, -1, 0)).p)
										local bottomrighttorso = CalculateObjectPosition((torsoobj.CFrame * cfnew(0.5, -1, 0)).p)
										local leftarm = CalculateObjectPosition((leftarmobj.CFrame).p)
										local rightarm = CalculateObjectPosition((rightarmobj.CFrame).p)
										local leftleg = CalculateObjectPosition((leftlegobj.CFrame).p)
										local rightleg = CalculateObjectPosition((rightlegobj.CFrame).p)
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
								
								local aliveplr = isAlive(plr, ESPAlive["Enabled"])
								if aliveplr and plr ~= lplr and (ESPTeammates["Enabled"] or plr:GetAttribute("teamId") ~= lplr:GetAttribute("teamId")) then
									local plrattr = br["EntityService"]:getLivingEntityById(plr:GetAttribute("LivingEntityID"))
									plrattr = plrattr and plrattr.attributes or {health = 100, maxHealth = 100}
									local rootPos, rootVis = cam:WorldToViewportPoint(aliveplr.HumanoidRootPart.Position)
									local rootSize = (aliveplr.HumanoidRootPart.Size.X * 1200) * (cam.ViewportSize.X / 1920)
									local headPos, headVis = cam:WorldToViewportPoint(aliveplr.HumanoidRootPart.Position + vec3(0, 1 + (rigcheck and 2 or aliveplr.Humanoid.HipHeight), 0))
									local legPos, legVis = cam:WorldToViewportPoint(aliveplr.HumanoidRootPart.Position - vec3(0, 1 + (rigcheck and 2 or aliveplr.Humanoid.HipHeight), 0))
									rootPos = rootPos
									if rootVis then
										if ESPHealthBar["Enabled"] then
											local color = HealthbarColorTransferFunction(plrattr.health / plrattr.maxHealth)
											thing.HealthLineMain.BackgroundColor3 = color
											thing.HealthLineMain.Size = UDim2.new(0, 1, math.clamp(plrattr.health / plrattr.maxHealth, 0, 1), (math.clamp(plrattr.health / plrattr.maxHealth, 0, 1) == 0 and 0 or -2))
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
								
								local aliveplr = isAlive(plr, ESPAlive["Enabled"])
								if aliveplr and plr ~= lplr and (ESPTeammates["Enabled"] or plr:GetAttribute("teamId") ~= lplr:GetAttribute("teamId")) then
									local rootPos, rootVis = cam:WorldToViewportPoint(aliveplr.HumanoidRootPart.Position)
									if not rootVis then continue end
									local rigcheck = aliveplr.Humanoid.RigType == Enum.HumanoidRigType.R6
									local torsoobj = aliveplr:FindFirstChild((rigcheck and "Torso" or "UpperTorso"))
									local leftarmobj = aliveplr:FindFirstChild((rigcheck and "Left Arm" or "LeftHand"))
									local rightarmobj = aliveplr:FindFirstChild((rigcheck and "Right Arm" or "RightHand"))
									local leftlegobj = aliveplr:FindFirstChild((rigcheck and "Left Leg" or "LeftFoot"))
									local rightlegobj = aliveplr:FindFirstChild((rigcheck and "Right Leg" or "RightFoot"))
									local headobj = aliveplr:FindFirstChild("Head")
									if torsoobj and leftarmobj and rightarmobj and leftlegobj and rightlegobj and headobj then
										thing.Visible = true
										local head = CalculateObjectPosition((headobj.CFrame).p)
										local headfront = CalculateObjectPosition((headobj.CFrame * cfnew(0, 0, -0.5)).p)
										local toplefttorso = CalculateObjectPosition((torsoobj.CFrame * cfnew(-1.5, 1, 0)).p)
										local toprighttorso = CalculateObjectPosition((torsoobj.CFrame * cfnew(1.5, 1, 0)).p)
										local toptorso = CalculateObjectPosition((torsoobj.CFrame * cfnew(0, 1, 0)).p)
										local bottomtorso = CalculateObjectPosition((torsoobj.CFrame * cfnew(0, -1, 0)).p)
										local bottomlefttorso = CalculateObjectPosition((torsoobj.CFrame * cfnew(-0.5, -1, 0)).p)
										local bottomrighttorso = CalculateObjectPosition((torsoobj.CFrame * cfnew(0.5, -1, 0)).p)
										local leftarm = CalculateObjectPosition((leftarmobj.CFrame).p)
										local rightarm = CalculateObjectPosition((rightarmobj.CFrame).p)
										local leftleg = CalculateObjectPosition((leftlegobj.CFrame).p)
										local rightleg = CalculateObjectPosition((rightlegobj.CFrame).p)
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
							if ESPMethod["Value"] == "VideoFrame" then
								if ESPFolder:FindFirstChild(plr.Name) then
									thing = ESPFolder[plr.Name]
									thing.Visible = false
								else
									thing = Instance.new("ImageLabel")
									thing.BackgroundTransparency = 1
									thing.BorderSizePixel = 0
									thing.Image = getcustomassetfunc("honestlyquiteincredible.png")
									thing.Visible = false
									thing.Name = plr.Name
									thing.Parent = ESPFolder
								end
								
								local aliveplr = isAlive(plr, ESPAlive["Enabled"])
								if aliveplr and plr ~= lplr and (ESPTeammates["Enabled"] or plr:GetAttribute("teamId") ~= lplr:GetAttribute("teamId")) then
									local rootPos, rootVis = cam:WorldToViewportPoint(aliveplr.HumanoidRootPart.Position)
									local rootSize = (aliveplr.HumanoidRootPart.Size.X * 1200) * (cam.ViewportSize.X / 1920)
									local headPos, headVis = cam:WorldToViewportPoint(aliveplr.HumanoidRootPart.Position + vec3(0, 1 + (rigcheck and 2 or aliveplr.Humanoid.HipHeight), 0))
									local legPos, legVis = cam:WorldToViewportPoint(aliveplr.HumanoidRootPart.Position - vec3(0, 1 + (rigcheck and 2 or aliveplr.Humanoid.HipHeight), 0))
									rootPos = rootPos
									if rootVis then
										thing.Visible = rootVis
										thing.Size = UDim2.new(0, rootSize / rootPos.Z, 0, headPos.Y - legPos.Y)
										thing.Position = UDim2.new(0, rootPos.X - thing.Size.X.Offset / 2, 0, (rootPos.Y - thing.Size.Y.Offset / 2) - 36)
									end
								end
							end
						end
					end
				end)
			else
				RunLoops:UnbindFromRenderStep("ESP") 
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
		["List"] = {"2D", "Skeleton", "VideoFrame"},
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
	ESPAlive = ESP.CreateToggle({
		["Name"] = "Alive Check",
		["Function"] = function() end
	})
end)

GuiLibrary["RemoveObject"]("ArrowsOptionsButton")
runcode(function()
	local ArrowsFolder = Instance.new("Folder")
	ArrowsFolder.Name = "ArrowsFolder"
	ArrowsFolder.Parent = GuiLibrary["MainGui"]
	players.PlayerRemoving:connect(function(plr)
		if ArrowsFolder:FindFirstChild(plr.Name) then
			ArrowsFolder[plr.Name]:Remove()
		end
	end)
	local ArrowsColor = {["Value"] = 0.44}
	local ArrowsTeammate = {["Enabled"] = true}
	local Arrows = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Arrows", 
		["Function"] = function(callback) 
			if callback then
				RunLoops:BindToRenderStep("Arrows", 500, function()
					for i,plr in pairs(players:GetChildren()) do
						local thing
						if ArrowsFolder:FindFirstChild(plr.Name) then
							thing = ArrowsFolder[plr.Name]
							thing.Visible = false
							thing.ImageColor3 = getPlayerColor(plr) or Color3.fromHSV(ArrowsColor["Hue"], ArrowsColor["Sat"], ArrowsColor["Value"])
						else
							thing = Instance.new("ImageLabel")
							thing.BackgroundTransparency = 1
							thing.BorderSizePixel = 0
							thing.Size = UDim2.new(0, 256, 0, 256)
							thing.AnchorPoint = Vector2.new(0.5, 0.5)
							thing.Position = UDim2.new(0.5, 0, 0.5, 0)
							thing.Visible = false
							thing.Image = getcustomassetfunc("vape/assets/ArrowIndicator.png")
							thing.Name = plr.Name
							thing.Parent = ArrowsFolder
						end
						
						local aliveplr = isAlive(plr)
						if aliveplr and plr ~= lplr and (ArrowsTeammate["Enabled"] or plr:GetAttribute("teamId") ~= lplr:GetAttribute("teamId")) then
							local rootPos, rootVis = cam:WorldToViewportPoint(aliveplr.HumanoidRootPart.Position)
							local camcframeflat = cfnew(cam.CFrame.p, cam.CFrame.p + cam.CFrame.lookVector * vec3(1, 0, 1))
							local pointRelativeToCamera = camcframeflat:pointToObjectSpace(aliveplr.HumanoidRootPart.Position)
							local unitRelativeVector = (pointRelativeToCamera * vec3(1, 0, 1)).unit
							local rotation = math.atan2(unitRelativeVector.Z, unitRelativeVector.X)
							thing.Visible = not rootVis
							thing.Rotation = math.deg(rotation)
						end
					end
				end)
			else
				RunLoops:UnbindFromRenderStep("Arrows") 
				ArrowsFolder:ClearAllChildren()
			end
		end, 
		["HoverText"] = "Draws arrows on screen when entities\nare out of your field of view."
	})
	ArrowsColor = Arrows.CreateColorSlider({
		["Name"] = "Player Color", 
		["Function"] = function(val) end,
	})
	ArrowsTeammate = Arrows.CreateToggle({
		["Name"] = "Teammate",
		["Function"] = function() end,
		["Default"] = true
	})
end)

GuiLibrary["RemoveObject"]("TracersOptionsButton")
runcode(function()
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
	local TracersThreat = {["Enabled"] = true}
	local TracersTeammates = {["Enabled"] = true}
	local TracersAlive = {["Enabled"] = false}
	local Tracers = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Tracers", 
		["Function"] = function(callback) 
			if callback then
				RunLoops:BindToRenderStep("Tracers", 500, function()
					local localchar = isAlive()
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

								local aliveplr = isAlive(plr, TracersAlive["Enabled"])
								if aliveplr and plr ~= lplr and (TracersTeammates["Enabled"] or plr:GetAttribute("teamId") ~= lplr:GetAttribute("teamId")) then
									if TracersThreat["Enabled"] and localchar then 
										local comparedlookvec = CFrame.lookAt(aliveplr.Head.Position, localchar.Head.Position).lookVector
										local compareto = aliveplr.Head.CFrame.lookVector
										local check = math.atan2(comparedlookvec.X, comparedlookvec.Z)
										local check2 = math.atan2(compareto.X, comparedlookvec.Z)
										if math.abs(check - check2) > 0.2 or math.abs(comparedlookvec.Y - compareto.Y) > 0.2 then continue end
									end
									local rootScrPos = cam:WorldToViewportPoint((TracersEndPosition["Value"] == "Head" and aliveplr.Head or aliveplr.HumanoidRootPart).Position)
									local tempPos = cam.CFrame:pointToObjectSpace((TracersEndPosition["Value"] == "Head" and aliveplr.Head or aliveplr.HumanoidRootPart).Position)
									if rootScrPos.Z < 0 then
										tempPos = CFrame.Angles(0, 0, (math.atan2(tempPos.Y, tempPos.X) + math.pi)):vectorToWorldSpace((CFrame.Angles(0, math.rad(89.9), 0):vectorToWorldSpace(vec3(0, 0, -1))));
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
								
								local aliveplr = isAlive(plr, TracersAlive["Enabled"])
								if aliveplr and plr ~= lplr and (TracersTeammates["Enabled"] or plr:GetAttribute("teamId") ~= lplr:GetAttribute("teamId")) then
									if TracersThreat["Enabled"] and localchar then 
										local comparedlookvec = CFrame.lookAt(aliveplr.Head.Position, localchar.Head.Position).lookVector
										local compareto = aliveplr.Head.CFrame.lookVector
										local check = math.atan2(comparedlookvec.X, comparedlookvec.Z)
										local check2 = math.atan2(compareto.X, comparedlookvec.Z)
										if math.abs(check - check2) > 0.2 or math.abs(comparedlookvec.Y - compareto.Y) > 0.2 then continue end
									end
									local rootScrPos = cam:WorldToViewportPoint((TracersEndPosition["Value"] == "Head" and aliveplr.Head or aliveplr.HumanoidRootPart).Position)
									local tempPos = cam.CFrame:pointToObjectSpace((TracersEndPosition["Value"] == "Head" and aliveplr.Head or aliveplr.HumanoidRootPart).Position)
									if rootScrPos.Z < 0 then
										tempPos = CFrame.Angles(0, 0, (math.atan2(tempPos.Y, tempPos.X) + math.pi)):vectorToWorldSpace((CFrame.Angles(0, math.rad(89.9), 0):vectorToWorldSpace(vec3(0, 0, -1))));
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
				RunLoops:UnbindFromRenderStep("Tracers") 
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
	TracersEndPosition = Tracers.CreateDropdown({
		["Name"] = "End Position",
		["List"] = {"Head", "Torso"},
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
	TracersThreat = Tracers.CreateToggle({
		["Name"] = "Threat Check",
		["Function"] = function() end
	})
	TracersAlive = Tracers.CreateToggle({
		["Name"] = "Alive Check",
		["Function"] = function() end
	})
end)

GuiLibrary["RemoveObject"]("NameTagsOptionsButton")
runcode(function()
	runcode(function()
		local function removeTags(str)
			str = str:gsub("<br%s*/>", "\n")
			return (str:gsub("<[^<>]->", ""))
		end
	
		local function floorpos(pos)
			return Vector2.new(math.floor(pos.X), math.floor(pos.Y))
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
		local NameTagsAlive = {["Enabled"] = false}
		local fontitems = {"SourceSans"}
		local NameTags = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
			["Name"] = "NameTags", 
			["Function"] = function(callback) 
				if callback then
					RunLoops:BindToRenderStep("NameTags", 500, function()
						local localchar = isAlive()
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
	
								local aliveplr = isAlive(plr, NameTagsAlive["Enabled"])
								if aliveplr and plr ~= lplr and (NameTagsTeammates["Enabled"] or plr:GetAttribute("teamId") ~= lplr:GetAttribute("teamId")) then
									local headPos, headVis = cam:WorldToViewportPoint((aliveplr.HumanoidRootPart:GetRenderCFrame() * cfnew(0, aliveplr.Head.Size.Y + aliveplr.HumanoidRootPart.Size.Y, 0)).Position)
									
									if headVis then
										local plrattr = br["EntityService"]:getLivingEntityById(plr:GetAttribute("LivingEntityID"))
										plrattr = plrattr and plrattr.attributes or {health = 100, maxHealth = 100, shield = 0}
										local displaynamestr = (NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name)
										local blocksaway = math.floor(((localchar and localchar.HumanoidRootPart.Position or vec3(0,0,0)) - aliveplr.HumanoidRootPart.Position).magnitude / 3)
										local color = HealthbarColorTransferFunction((plrattr.health + plrattr.shield) / plrattr.maxHealth)
										thing.Text.Text = (NameTagsDistance["Enabled"] and entity.isAlive and '['..blocksaway..'] ' or '')..displaynamestr..(NameTagsHealth["Enabled"] and ' '..math.floor((plrattr.health + plrattr.shield)).."" or '')
										thing.Text.Size = 17 * (NameTagsScale["Value"] / 10)
										thing.Text.Color = getPlayerColor(plr) or Color3.fromHSV(NameTagsColor["Hue"], NameTagsColor["Sat"], NameTagsColor["Value"])
										thing.Text.Visible = headVis
										thing.Text.Font = (math.clamp((table.find(fontitems, NameTagsFont["Value"]) or 1) - 1, 0, 3))
										thing.Text.Position = floorpos(Vector2.new(headPos.X - thing.Text.TextBounds.X / 2, (headPos.Y - thing.Text.TextBounds.Y)))
										thing.BG.Visible = headVis and NameTagsBackground["Enabled"]
										thing.BG.Size = floorpos(Vector2.new(thing.Text.TextBounds.X + 4, thing.Text.TextBounds.Y))
										thing.BG.Position = floorpos(Vector2.new((headPos.X - 2) - thing.Text.TextBounds.X / 2, (headPos.Y - thing.Text.TextBounds.Y) + 1.5))
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
									thing.TextColor3 = getPlayerColor(plr) or Color3.fromHSV(NameTagsColor["Hue"], NameTagsColor["Sat"], NameTagsColor["Value"])
									thing.Parent = NameTagsFolder
								end
									
								local aliveplr = isAlive(plr, NameTagsAlive["Enabled"])
								if aliveplr and plr ~= lplr and (NameTagsTeammates["Enabled"] or plr:GetAttribute("teamId") ~= lplr:GetAttribute("teamId")) then
									local headPos, headVis = cam:WorldToViewportPoint((aliveplr.HumanoidRootPart:GetRenderCFrame() * cfnew(0, aliveplr.Head.Size.Y + aliveplr.HumanoidRootPart.Size.Y, 0)).Position)
									headPos = headPos
									
									if headVis then
										local plrattr = br["EntityService"]:getLivingEntityById(plr:GetAttribute("LivingEntityID"))
										plrattr = plrattr and plrattr.attributes or {health = 100, maxHealth = 100, shield = 0}
										local rawText = (NameTagsDistance["Enabled"] and localchar and "["..math.floor(((localchar and localchar.HumanoidRootPart.Position or Vector3.zero) - aliveplr.HumanoidRootPart.Position).magnitude).."] " or "")..(NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name)..(NameTagsHealth["Enabled"] and " "..math.floor(plrattr.health) or "")
										local color = HealthbarColorTransferFunction((plrattr.health + plrattr.shield) / plrattr.maxHealth)
										local modifiedText = (NameTagsDistance["Enabled"] and localchar and '<font color="rgb(85, 255, 85)">[</font><font color="rgb(255, 255, 255)">'..math.floor(((localchar and localchar.HumanoidRootPart.Position or Vector3.zero) - aliveplr.HumanoidRootPart.Position).magnitude)..'</font><font color="rgb(85, 255, 85)">]</font> ' or '')..(NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name)..(NameTagsHealth["Enabled"] and ' <font color="rgb('..tostring(math.floor(color.R * 255))..','..tostring(math.floor(color.G * 255))..','..tostring(math.floor(color.B * 255))..')">'..math.floor((plrattr.health + plrattr.shield)).."</font>" or '')
										local nametagSize = textservice:GetTextSize(rawText, thing.TextSize, thing.Font, Vector2.new(100000, 100000))
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
		NameTagsAlive = NameTags.CreateToggle({
			["Name"] = "Alive Check",
			["Function"] = function() end
		})
	end)
end)

runcode(function()
	local PickupItems = {["Enabled"] = false}
	PickupItems = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "InventoryManager",
		["Function"] = function(callback)
			if callback then
				task.spawn(function()
					repeat
						task.wait(0.1)
						local localchar = isAlive()
						if localchar then 
							for i,v in pairs(collectionservice:GetTagged("ground-item-component")) do 
								local item = v:GetAttribute("itemType")
								local itemmeta = br["ItemTable"][item]
								if (v.Position - localchar.HumanoidRootPart.Position).magnitude <= 9.5 and itemmeta then
									local armor = br["EntityService"]:getLivingEntityById(lplr:GetAttribute("LivingEntityID"))
									local inv = br["InventoryController"]:getPlayerInventory()
									inv = inv and inv.groups.default or {}
									armor = armor and armor.attributes.maxShield or 0
									local invcount = 0
									local gottenitem
									for i2,v2 in pairs(inv) do 
										if v2.item and v2.item.type ~= "" then 
											if v2.item.type == item then 
												gottenitem = v2 
											end 
											invcount = invcount + 1 
										end
									end
									local specialitem = (item:find("ammo") or item:find("armor"))
									local allowed = (gottenitem and br["ItemTable"][item].maxStackSize and br["ItemTable"][item].maxStackSize > 1 and (br["ItemTable"][item].maxStackSize - gottenitem.stackCount) > 0 or item:find("ammo") or (item:find("armor") and itemmeta.armor.maxShield > armor) or ((not specialitem) and (invcount < 7)))
									local oldslot
									if not allowed then 
										local alreadygot = false
										for i2,v2 in pairs(inv) do 
											if v2.item and v2.item.type then
												local helditemmeta = br["ItemTable"][v2.item.type]
												if helditemmeta.displayName == itemmeta.displayName and (not alreadygot) then 
													allowed = (itemmeta.rarity or 0) > (helditemmeta.rarity or 0)
													if allowed then 
														alreadygot = true
														oldslot = br["ItemHolderController"].currentSlotId
														br["ItemHolderController"]:setSlot(i2 - 1)
													end
												end
											end
										end
									end
									if allowed then 
										br["ItemPickupController"]:pickupItem({instance = v, getItemMeta = function() return itemmeta end, attributes = v:GetAttributes()})
										if oldslot then 
											br["ItemHolderController"]:setSlot(oldslot)
										end
									end
								end
							end
						end
					until (not PickupItems["Enabled"])
				end)
			end
		end
	})
end)

runcode(function()
	local AutoLeave = {["Enabled"] = false}
	local autoleaveconnection
	AutoLeave = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "AutoLeave",
		["Function"] = function(callback)
			if callback then
				task.spawn(function()
					local matchdoc = br["MatchManagerController"]:waitForMatchDocument()
					autoleaveconnection = matchdoc:watchAttribute("matchState", function(state)
						if state == 2 then 
							br["LobbyClientEvents"].joinQueue:fire({
								queueType = matchdoc:getQueueType()
							})
						end
					end)
				end)
			else
                if autoleaveconnection then autoleaveconnection:Disconnect() end
            end
		end
	})
end)


runcode(function()
    local function removeTags(str)
        str = str:gsub("<br%s*/>", "\n")
        return (str:gsub("<[^<>]->", ""))
    end

    local function floorpos(pos)
        return Vector2.new(math.floor(pos.X), math.floor(pos.Y))
    end

    local ItemESPFolder = Instance.new("Folder")
    ItemESPFolder.Name = "ItemESPFolder"
    ItemESPFolder.Parent = GuiLibrary["MainGui"]
    local ItemESPDisplayName = {["Enabled"] = false}
    local ItemESPScale = {["Value"] = 10}
    local ItemESPFont = {["Value"] = "SourceSans"}
    local fontitems = {"SourceSans"}
    local ItemESP = {["Enabled"] = false}
	local itemsnear = {}
	local itemremoved
	local itemrender = {}
	ItemESP = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
        ["Name"] = "ItemESP", 
        ["Function"] = function(callback) 
            if callback then
				task.spawn(function()
					repeat
						task.wait(0.1)
						local localchar = isAlive()
						for i,plr in pairs(collectionservice:GetTagged("ground-item-component")) do 
							local newval = ((localchar and localchar.HumanoidRootPart.Position or vec3(999999, 99999, 999999)) - plr.Position).Magnitude <= 200
							local ind = table.find(itemsnear, plr)
							if newval then
								if not ind then
									table.insert(itemsnear, plr)
								end
							else
								if ind then 
									table.remove(itemsnear, ind)
								end
								if itemrender[plr] then 
									itemrender[plr]:Destroy()
									itemrender[plr] = nil
								end
							end
						end
					until (not ItemESP["Enabled"])
				end)
				itemremoved = collectionservice:GetInstanceRemovedSignal("ground-item-component"):connect(function(plr)
					local ind = table.find(itemsnear, plr)
					if ind then 
						table.remove(itemsnear, ind)
					end
					if itemrender[plr] then 
						itemrender[plr]:Destroy()
						itemrender[plr] = nil
					end
				end)
                RunLoops:BindToRenderStep("ItemESP", 500, function()
					for i,plr in pairs(itemsnear) do 
                        local thing
						if itemrender[plr] then
							thing = itemrender[plr]
							thing.Visible = false
						else
							thing = Instance.new("TextLabel")
							thing.BackgroundTransparency = 1
							thing.BackgroundColor3 = Color3.new(0, 0, 0)
							thing.BorderSizePixel = 0
							thing.Visible = false
							thing.RichText = true
							thing.TextStrokeTransparency = 0
							thing.TextStrokeColor3 = Color3.new(0, 0, 0)
							thing.Name = plr.Name
							thing.Font = Enum.Font.SourceSans
							thing.TextSize = 14
							thing.Parent = ItemESPFolder
							itemrender[plr] = thing
						end
						local headPos, headVis = cam:WorldToViewportPoint(plr.Position + vec3(0, 5, 0))
						
						if headVis then
							local item = plr:GetAttribute("itemType")
							local itemrarity = br["ItemTable"][item] and br["ItemTable"][item].rarity and br["ItemRarityTable"][br["ItemTable"][item].rarity].gradient.colorTop or Color3.new(1, 1, 1)
							local nametagSize = textservice:GetTextSize(item, thing.TextSize, thing.Font, Vector2.new(100000, 100000))
							thing.Size = UDim2.new(0, nametagSize.X + 4, 0, nametagSize.Y)
							thing.Text = br["ItemTable"][item].displayName
							thing.Font = Enum.Font[ItemESPFont["Value"]]
							thing.TextSize = 14 * (ItemESPScale["Value"] / 10)
							thing.TextColor3 = itemrarity
							thing.Visible = headVis
							thing.Position = UDim2.new(0, headPos.X - thing.Size.X.Offset / 2, 0, (headPos.Y - thing.Size.Y.Offset) - 36)
						end
                    end
                end)
            else
				if itemremoved then itemremoved:Disconnect() end
                RunLoops:UnbindFromRenderStep("ItemESP")
                ItemESPFolder:ClearAllChildren()
            end
        end,
        ["HoverText"] = "Renders nametags on entities through walls."
    })
    for i,v in pairs(Enum.Font:GetEnumItems()) do 
        if v.Name ~= "SourceSans" then 
            table.insert(fontitems, v.Name)
        end
    end
    ItemESPFont = ItemESP.CreateDropdown({
        ["Name"] = "Font",
        ["List"] = fontitems,
        ["Function"] = function() end,
    })
    ItemESPScale = ItemESP.CreateSlider({
        ["Name"] = "Scale",
        ["Function"] = function(val) end,
        ["Default"] = 10,
        ["Min"] = 1,
        ["Max"] = 50
    })
end)

runcode(function()
	local oldspinfunc
	local oldspinfunc2
	SpinBot = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "SpinBot",
		["Function"] = function(callback)
			if callback then
				if getconnections then 
					for i,v in pairs(getconnections(game:GetService("RunService").Heartbeat)) do 
						if v.Function then 
							local const = debug.getconstants(v.Function)
							if const[1] == "CurrentCamera" and const[3] == "CFrame" and const[5] == "Y" then 
								oldspinfunc = v.Function
								break
							end
						end
					end
					local newcam = Instance.new("Camera")
					newcam.Name = "NewCamera"
					newcam.Parent = workspace
					for i,v in pairs(debug.getprotos(br["ShiftLockController"].enable)) do 
						if #debug.getconstants(v) > 10 and debug.getconstant(v, 10) == "ZOOM_OUT_SCALER" then 
							oldspinfunc2 = v
							break
						end
					end
					if oldspinfunc then 
						task.spawn(function()
							repeat
								task.wait()
								if not SpinBot["Enabled"] then break end
								debug.setupvalue(oldspinfunc, 1, {CurrentCamera = {CFrame = {LookVector = CFrame.Angles(math.rad(tick() * 200 % 360), 0, 0).lookVector}}})
							until (not SpinBot["Enabled"])
						end)
					end
					if oldspinfunc2 then 
						task.spawn(function()
							repeat
								task.wait()
								if not SpinBot["Enabled"] then break end
								br["ShiftLockController"]:disable()
								uis.MouseBehavior = Enum.MouseBehavior.LockCenter
								uis.MouseIconEnabled = false
							until (not SpinBot["Enabled"])
						end)
					end
				else
					createwarning("SpinBot", "no getconnections\nget a better exploit loser", 10)
					SpinBot["ToggleButton"](false)
				end
			else
				if oldspinfunc then 
					debug.setupvalue(oldspinfunc, 1, workspace)
					oldspinfunc = nil
				end
				if oldspinfunc2 then 
					br["ShiftLockController"]:enable()
				end
			end
		end
	})
end)

runcode(function()
	local AutoToxic = {["Enabled"] = false}
	local AutoToxicPhrases = {["RefreshValues"] = function() end, ["ObjectList"] = {}}
	local AutoToxicPhrases2 = {["RefreshValues"] = function() end, ["ObjectList"] = {}}
	local justsaid = ""
	local oldadd
	local autoleaveconnection
	AutoToxic = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "AutoToxic",
		["Function"] = function(callback)
			if callback then 
				task.spawn(function()
					local matchdoc = br["MatchManagerController"]:waitForMatchDocument()
					autoleaveconnection = matchdoc:watchAttribute("matchState", function(state)
						if state == 2 then 
							repstorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(#AutoToxicPhrases["ObjectList"] > 0 and AutoToxicPhrases["ObjectList"][math.random(1, #AutoToxicPhrases["ObjectList"])] or "EZ L TRASH KIDS | vxpe on top", "All")
						end
					end)
				end)
				oldadd = br["DamageEvents"].livingEntityDeath.OnClientEvent:connect(function(p7, p8, p9)
					if not p9.fromEntity then return end
					local ent = br["EntityService"]:getLivingEntityById(p7)
					local ent2 = br["EntityService"]:getLivingEntityById(p9.fromEntity)
					if ent and ent2 then 
						if ent2.attributes.playerUserId == lplr.UserId then 
							local plr = players:GetPlayerByUserId(ent.attributes.playerUserId)
							if plr then 
								local custommsg = #AutoToxicPhrases2["ObjectList"] > 0 and AutoToxicPhrases2["ObjectList"][math.random(1, #AutoToxicPhrases2["ObjectList"])] or "L <name> | vxpe on top"
								if custommsg == lastsaid then
									custommsg = #AutoToxicPhrases2["ObjectList"] > 0 and AutoToxicPhrases2["ObjectList"][math.random(1, #AutoToxicPhrases2["ObjectList"])] or "L <name> | vxpe on top"
								else
									lastsaid = custommsg
								end
								if custommsg then
									custommsg = custommsg:gsub("<name>", (plr.DisplayName or plr.Name))
								end
								repstorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("/w "..plr.Name.." "..custommsg, "All")
							end
						end
					end
				end)
			else
				if oldadd then 
					oldadd:Disconnect()
				end
				if autoleaveconnection then 
					autoleaveconnection:Disconnect()
				end
			end
		end
	})
	AutoToxicPhrases = AutoToxic.CreateTextList({
		["Name"] = "ToxicList",
		["TempText"] = "phrase (win)",
	})
	AutoToxicPhrases2 = AutoToxic.CreateTextList({
		["Name"] = "ToxicList2",
		["TempText"] = "phrase (kill) <name>",
	})
end)

runcode(function()
	local AutoRevive = {["Enabled"] = false}
	local revivetick = tick()
	local reviving
	local billboard
	AutoRevive = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "AutoRevive",
		["Function"] = function(callback)
			if callback then
				local billboardtween
				billboard = Instance.new("BillboardGui")
				billboard.Parent = GuiLibrary["MainGui"]
				billboard.Name = "Revive"
				billboard.StudsOffsetWorldSpace = vec3(0, 3, 0)
				billboard.Size = UDim2.new(0, 64, 0, 64)
				billboard.Enabled = false
				billboard.AlwaysOnTop = true
				local billboardimage = Instance.new("ImageLabel")
				billboardimage.Size = UDim2.new(0, 44, 0, 44)
				billboardimage.AnchorPoint = Vector2.new(0.5, 0.5)
				billboardimage.Position = UDim2.new(0.5, 0, 0.5, 0)
				billboardimage.BackgroundTransparency = 1
				billboardimage.ZIndex = 3
				billboardimage.Image = "rbxassetid://8104352347"
				billboardimage.Parent = billboard
				local billboardimagecircle = Instance.new("UICorner")
				billboardimagecircle.CornerRadius = UDim.new(0, 512)
				billboardimagecircle.Parent = billboardimage
				local frame = Instance.new("Frame")
				frame.Size = UDim2.new(1, 0, 1, 0)
				frame.BackgroundColor3 = Color3.new(0, 0, 0)
				frame.BackgroundTransparency = 0.5
				frame.Parent = billboard
				local uicorner = Instance.new("UICorner")
				uicorner.CornerRadius = UDim.new(0, 4)
				uicorner.Parent = frame
				local circle = createCircularProgressBar()
				circle.Parent = frame
				task.spawn(function()
					repeat
						task.wait()
						local plr = GetNearestHumanoidToPosition(true, 15)
						if plr then 
							local royaleentity = getBattleRoyaleEntity(plr.Player)
							if royaleentity and royaleentity:GetAttribute("downed") then
								if reviving ~= plr.Player then 
									reviving = plr.Player
									revivetick = tick() + 6
									if billboardtween then billboardtween:Cancel() end
									circle.Progress.Value = 0
									billboardtween = game:GetService("TweenService"):Create(circle.Progress, TweenInfo.new(6, Enum.EasingStyle.Linear), {Value = 1})
									billboardtween:Play()
									br["Networking"].NetEvents.client.reviveStarted:fire(plr.Player.UserId)
								else
									billboardimage.Image = 'rbxthumb://type=AvatarHeadShot&id='..plr.Player.UserId..'&w=420&h=420'
									billboard.Adornee = plr.Character.HumanoidRootPart
									billboard.Enabled = true
									if revivetick <= tick() then 
										br["Networking"].NetEvents.client.revive(br["EntityService"]:getLivingEntityByUserId(plr.Player.UserId):getId())
									end
								end
							else
								billboard.Adornee = nil
								billboard.Enabled = false
							end
						else
							if reviving then 
								local royaleentity = getBattleRoyaleEntity(reviving)
								if royaleentity and royaleentity:GetAttribute("downed") then
									br["Networking"].NetEvents.client.reviveFailed:fire(reviving.UserId)
								end
							end
							billboard.Adornee = nil
							billboard.Enabled = false
							reviving = nil
						end
					until (not AutoRevive["Enabled"])
				end)
			else
				if billboard then
					billboard:Destroy()
				end
			end
		end
	})
end)

runcode(function()
	local BulletTracers = {["Enabled"] = false}
	local bulletconnection
	local oldbulleteffect
	BulletTracers = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "BulletTracers",
		["Function"] = function(callback)
			if callback then 
				bulletconnection = br["ChickynoidClient"].weaponsClient.OnBulletImpact:Connect(function(p4, p5)
					br["BaseGun"]:unpackPacket(p5)
					if p5.player and p5.player.userId == lplr.UserId then 
						local distance = (p5.origin - p5.position).Magnitude
						local p = Instance.new("Part")
						p.Anchored = true
						p.CanCollide = false
						p.Transparency = 0.5
						p.Color = Color3.fromRGB(0, 255, 0)
						p.Material = Enum.Material.Neon
						p.Size = vec3(0.05, 0.05, distance)
						p.CFrame = CFrame.lookAt(p5.origin, p5.position)*CFrame.new(0, 0, -distance/2)
						br["GameQueryUtil"]:setQueryIgnored(p, true)
						p.Parent = lplr.Character
						game:GetService("Debris"):AddItem(p, 3)
					end
				end)
			else
				if bulletconnection then 
					bulletconnection:Disconnect()
				end
			end
		end
	})
end)

runcode(function()
	local AutoAirdrop = {["Enabled"] = false}
	local revivetick = tick()
	local reviving
	local billboard
	AutoAirdrop = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "AutoAirdrop",
		["Function"] = function(callback)
			if callback then
				local billboardtween
				billboard = Instance.new("BillboardGui")
				billboard.Parent = GuiLibrary["MainGui"]
				billboard.Name = "Airdrop"
				billboard.StudsOffsetWorldSpace = vec3(0, 3, 0)
				billboard.Size = UDim2.new(0, 64, 0, 64)
				billboard.Enabled = false
				billboard.AlwaysOnTop = true
				local billboardimage = Instance.new("ImageLabel")
				billboardimage.Size = UDim2.new(0, 44, 0, 44)
				billboardimage.AnchorPoint = Vector2.new(0.5, 0.5)
				billboardimage.Position = UDim2.new(0.5, 0, 0.5, 0)
				billboardimage.BackgroundTransparency = 1
				billboardimage.ZIndex = 3
				billboardimage.Image = "rbxassetid://8104352347"
				billboardimage.Parent = billboard
				local billboardimagecircle = Instance.new("UICorner")
				billboardimagecircle.CornerRadius = UDim.new(0, 512)
				billboardimagecircle.Parent = billboardimage
				local frame = Instance.new("Frame")
				frame.Size = UDim2.new(1, 0, 1, 0)
				frame.BackgroundColor3 = Color3.new(0, 0, 0)
				frame.BackgroundTransparency = 0.5
				frame.Parent = billboard
				local uicorner = Instance.new("UICorner")
				uicorner.CornerRadius = UDim.new(0, 4)
				uicorner.Parent = frame
				local circle = createCircularProgressBar()
				circle.Parent = frame
				task.spawn(function()
					repeat
						task.wait()
						local localchar = isAlive()
						if localchar then
							local found
							for i,v in pairs(collectionservice:GetTagged("AirdropPackage")) do 
								if v.PrimaryPart and (localchar.HumanoidRootPart.Position - v.PrimaryPart.Position).Magnitude <= 12 then 
									found = v
									if reviving ~= v then 
										reviving = v
										revivetick = tick() + 3
										if billboardtween then billboardtween:Cancel() end
										circle.Progress.Value = 0
										billboardtween = game:GetService("TweenService"):Create(circle.Progress, TweenInfo.new(3, Enum.EasingStyle.Linear), {Value = 1})
										billboardtween:Play()
									else
										billboard.Adornee = v.PrimaryPart
										billboard.Enabled = true
										if revivetick <= tick() then 
											br["Networking"].NetEvents.client.openAirdropPackage(v)
										end
									end
									break
								end
							end
							if not found then 
								reviving = nil
								billboard.Adornee = nil
								billboard.Enabled = false
							end
						else
							reviving = nil
							billboard.Adornee = nil
							billboard.Enabled = false
						end
					until (not AutoAirdrop["Enabled"])
				end)
			else
				if billboard then
					billboard:Destroy()
				end
			end
		end
	})
end)