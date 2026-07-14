local loadstring = function(...)
	local res, err = loadstring(...)
	if err and vape then
		vape:CreateNotification('Vape', 'Failed to load : '..err, 30, 'alert')
	end
	return res
end
local isfile = isfile or function(file)
	local suc, res = pcall(function()
		return readfile(file)
	end)
	return suc and res ~= nil and res ~= ''
end
local function downloadFile(path, func)
	if not isfile(path) then
		local suc, res = pcall(function()
			return game:HttpGet('https://raw.githubusercontent.com/7GrandDadPGN/VapeCompiled/'..readfile('newvape/profiles/commit.txt')..'/'..select(1, path:gsub('newvape/', '')), true)
		end)
		if not suc or res == '404: Not Found' then
			error(res)
		end
		if path:find('.lua') then
			res = '--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.\n'..res
		end
		writefile(path, res)
	end
	return (func or readfile)(path)
end
local run = function(func)
	func()
end
local cloneref = cloneref or function(obj)
	return obj
end

local vapeEvents = setmetatable({}, {
	__index = function(self, index)
		self[index] = Instance.new('BindableEvent')
		return self[index]
	end
})

local playersService = cloneref(game:GetService('Players'))
local inputService = cloneref(game:GetService('UserInputService'))
local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local replicatedFirst = cloneref(game:GetService('ReplicatedFirst'))
local collectionService = cloneref(game:GetService('CollectionService'))
local textChatService = cloneref(game:GetService('TextChatService'))
local runService = cloneref(game:GetService('RunService'))
local coreGui = cloneref(game:GetService('CoreGui'))

local gameCamera = workspace.CurrentCamera
local lplr = playersService.LocalPlayer
local vape = shared.vape
local entitylib = vape.Libraries.entity
local targetinfo = vape.Libraries.targetinfo
local sessioninfo = vape.Libraries.sessioninfo
local whitelist = vape.Libraries.whitelist
local drawingactor = loadstring(downloadFile('newvape/libraries/drawing.lua'), 'drawing')(...)
local redline = {Teams = {}}
local starttime = os.clock()
local TargetStrafeVector
local latestHash = 'c401462bc7f7f49e53b4a8da2de5b57bc2d7e14df1b773e5ccd1bcddb28db9c843b8902d2c93738a2f042e533d3d4971'
local redline_boxes = {
	{
		boxtype = 'redliner_melee',
		data = {
			size = Vector3.new(17.75, 14, 22),
			offset = CFrame.new(0, 0, -11)
		}
	},
	{
		boxtype = 'redliner_charged_melee',
		data = {
			size = Vector3.new(39, 14, 35),
			offset = CFrame.new(0, -0.5, -9)
		}
	}
}

local function addVelocity(velo)
	if redline[redline.MoveController] and typeof(redline[redline.MoveController][redline.LaunchpadFunction]) == 'function' then
		local pad = Instance.new('Model')
		local origin = Instance.new('Part')
		origin.Name = 'Origin'
		origin.CFrame = CFrame.new(100, 100, 100)
		origin.Parent = pad
		local goal = Instance.new('Part')
		goal.Name = 'LaunchGoal'
		goal.CFrame = CFrame.new(100, 100, 100) + (velo.Unit == velo.Unit and velo.Unit or Vector3.zero)
		goal.Parent = pad
		redline[redline.MoveController][redline.LaunchpadFunction](redline[redline.MoveController], pad, {
			base_strength = velo.Magnitude,
			max_strength = velo.Magnitude
		})

		pad:Destroy()
		pad:ClearAllChildren()
	end
end

local function castHitbox(data, origin)
	local hit_hurtboxes = {}
	local params = OverlapParams.new()
	params.FilterType = Enum.RaycastFilterType.Include
	params.RespectCanCollide = false
	params.FilterDescendantsInstances = collectionService:GetTagged('Hurtbox')

	for _, v in params.FilterDescendantsInstances do
		v.Transparency = 0
	end

	for _, hit in workspace:GetPartBoundsInBox(origin * data.offset, data.size, params) do
		if hit:FindFirstAncestorWhichIsA('Model') ~= lplr.Character then
			table.insert(hit_hurtboxes, hit)
		end
	end

	return hit_hurtboxes
end

local function searchForPacket(func, unreliable)
	for _, v in debug.getconstants(func) do
		if rawget(unreliable and redline.Packets.unreliablePackets or redline.Packets, v) then
			return v
		end
	end
end

local function getIndicators()
	return redline[redline.IndicatorController] and redline[redline.IndicatorController][redline.IndicatorTable] or {}
end

local function isFriend(plr, recolor)
	if vape.Categories.Friends.Options['Use friends'].Enabled then
		local friend = table.find(vape.Categories.Friends.ListEnabled, plr.Name) and true
		if recolor then
			friend = friend and vape.Categories.Friends.Options['Recolor visuals'].Enabled
		end
		return friend
	end
	return nil
end

local function isTarget(plr)
	return table.find(vape.Categories.Targets.ListEnabled, plr.Name) and true
end

local function notif(...)
	return vape:CreateNotification(...)
end

local function warningRoutine(hash)
	local path = 'newvape/profiles/agreementhash.txt'
	if (isfile(path) and readfile(path) or '') ~= hash then
		local box = Instance.new('TextLabel')
		box.Size = UDim2.fromScale(1, 1)
		box.BackgroundColor3 = Color3.new()
		box.BackgroundTransparency = 0.5
		box.Text = '⚠️WARNING⚠️\nThe game\'s update hash is not the same as the current script hash, this ⚠️MAY⚠️ mean the game developer has added detections.\nBy clicking OK, you agree to all risks of using this product.\n\n- 7GrandDad'
		box.TextColor3 = Color3.new(1, 1, 1)
		box.TextScaled = true
		box.Font = Enum.Font.Arial
		box.Parent = vape.gui
		local button = Instance.new('TextButton')
		button.AnchorPoint = Vector2.new(0.5, 0.5)
		button.Size = UDim2.fromScale(0.2, 0.05)
		button.Position = UDim2.fromScale(0.5, 0.95)
		button.BackgroundColor3 = Color3.new()
		button.Text = 'OK'
		button.TextColor3 = Color3.new(1, 1, 1)
		button.TextScaled = true
		button.Font = Enum.Font.Arial
		button.Parent = box

		button.MouseButton1Click:Connect(function()
			writefile(path, hash)
			box:Destroy()
		end)

		box.Destroying:Wait()
	end
end

if not select(1, ...) then
	if run_on_actor then
		local oldreload = shared.vapereload
		vape.Load = function()
			task.delay(0.1, function()
				vape:Uninject()
			end)
		end

		task.spawn(function()
			repeat task.wait() until not shared.vape
			local executionString = "loadfile('newvape/main.lua')("..drawingactor..")"
			for i, v in shared do
				if type(v) == 'string' then
					executionString = string.format("shared.%s = '%s'", i, v)..'\n'..executionString
				elseif type(v) == 'boolean' then
					executionString = string.format("shared.%s = %s", i, tostring(v))..'\n'..executionString
				end
			end
			if oldreload then
				executionString = 'shared.vapereload = true\n'..executionString
			end

			if getactorthreads and run_on_thread then
				for _, v in getactorthreads() do
					run_on_thread(v, executionString)
					return
				end
			elseif getactorstates then
				for _, v in getactorstates() do
					if type(v) ~= 'thread' then
						v:Execute(executionString)
						return
					end
				end
			end

			for _, v in (getdeletedactors or getactors)() do
				run_on_actor(v, executionString)
				return
			end

			lplr:Kick('Failed to find actor, Executor: '..identifyexecutor())
		end)
	else
		vape.Load = function()
			notif('Vape', 'Missing actor functions.', 10, 'alert')
		end
	end

	return
end

run(function()
	local function waitForChildOfType(obj, name, timeout, prop)
		local checktick = tick() + timeout
		local returned
		repeat
			returned = prop and obj[name] or obj:FindFirstChildOfClass(name)
			if returned or checktick < tick() then break end
			task.wait()
		until false
		return returned
	end

	entitylib.addEntity = function(char, plr, teamfunc, spawntime)
		if not char then return end
		entitylib.EntityThreads[char] = task.spawn(function()
			local hum = waitForChildOfType(char, 'Humanoid', 10)
			local humrootpart = hum and waitForChildOfType(hum, 'RootPart', workspace.StreamingEnabled and 9e9 or 10, true)
			local head = char:WaitForChild('Head', 10) or humrootpart
			local hitbox = char:FindFirstChild('Head_Hurtbox', true)

			if hum and humrootpart then
				local entity = {
					Connections = {},
					Character = char,
					Health = hum.Health,
					Head = head,
					Hitbox = hitbox or humrootpart,
					Humanoid = hum,
					HumanoidRootPart = humrootpart,
					HipHeight = hum.HipHeight + (humrootpart.Size.Y / 2) + (hum.RigType == Enum.HumanoidRigType.R6 and 2 or 0),
					MaxHealth = hum.MaxHealth,
					NPC = plr == nil,
					Player = plr,
					RootPart = humrootpart,
					SpawnTime = spawntime or 0,
					TeamCheck = teamfunc
				}

				if plr == lplr then
					entitylib.character = entity
					entitylib.isAlive = true
					entitylib.Events.LocalAdded:Fire(entity)
				else
					entity.Targetable = entitylib.targetCheck(entity)

					for _, v in entitylib.getUpdateConnections(entity) do
						table.insert(entity.Connections, v:Connect(function()
							entitylib.Events.EntityUpdated:Fire(entity)
						end))
					end

					table.insert(entitylib.List, entity)
					entitylib.Events.EntityAdded:Fire(entity)
				end
			end

			entitylib.EntityThreads[char] = nil
		end)
	end

	if game.PlaceId == 126691165749976 then
		entitylib.targetCheck = function(entity)
			if entity.NPC then return true end
			if isFriend(entity.Player) then return false end
			if not select(2, whitelist:get(entity.Player)) then return false end
			if vape.Categories.Main.Options['Teams by server'].Enabled then
				if not redline.Teams[tostring(lplr.UserId)] then return true end
				return redline.Teams[tostring(entity.Player.UserId)] ~= redline.Teams[tostring(lplr.UserId)]
			end

			return true
		end

		local function updatePlayer(plr)
			plr = playersService:GetPlayerByUserId(tonumber(plr.Name))

			if plr and entitylib.Running then
				if plr == lplr then
					local cloned = table.clone(entitylib.List)
					for _, entity in cloned do
						if entity.Targetable ~= entitylib.targetCheck(entity) then
							entitylib.refreshEntity(entity.Character, entity.Player)
						end
					end
					table.clear(cloned)
				else
					local entity = entitylib.getEntity(plr)
					if entity and entity.Targetable ~= entitylib.targetCheck(entity) then
						entitylib.refreshEntity(entity.Character, plr)
					end
				end
			end
		end

		local function processPlayer(plr)
			if tonumber(plr.Name) then
				redline.Teams[plr.Name] = plr:GetAttribute('team_id')
				task.spawn(updatePlayer, plr)

				vape:Clean(plr:GetAttributeChangedSignal('team_id'):Connect(function()
					redline.Teams[plr.Name] = plr:GetAttribute('team_id')
					task.spawn(updatePlayer, plr)
				end))
			end
		end

		local function processMatch(match)
			if match and match.Name == 'Match' then
				vape:Clean(match.DescendantAdded:Connect(processPlayer))
				for _, v in match:GetDescendants() do
					processPlayer(v)
				end
			end
		end

		vape:Clean(replicatedStorage.ReadOnly.ChildAdded:Connect(processMatch))
		task.spawn(processMatch, replicatedStorage.ReadOnly:FindFirstChild('Match'))
	end
end)
entitylib.start()

run(function()
	local root

	for i = 1, 3 do
		local doBreak
		for _, v in getloadedmodules() do
			if v:GetFullName() == 'Start.Client.ClientRoot' then
				doBreak = true
				break
			end
		end

		if doBreak then
			break
		end

		task.wait(0.5)
	end

	for _, v in getloadedmodules() do
		if v:GetFullName() == 'Start.Client.ClientRoot' then
			if getscripthash(v) ~= latestHash then
				warningRoutine(getscripthash(v))

				if vape.Loaded == nil then
					return
				end
			end

			root = require(v)
			if not rawget(root, 'loaded') then
				repeat
					task.wait()
				until rawget(root, 'loaded') or vape.Loaded == nil
			end

			if vape.Loaded == nil then
				return
			end
		end
	end

	if not root then
		lplr:Kick('Failed to find root class, please contact 7GrandDad on discord.')
		return
	end

	local classList = rawget(root, 'Classes') or {}
	redline = setmetatable({
		CEnum = require(replicatedStorage.Assets.ModuleScripts.CEnum),
		Packets = require(replicatedStorage.Assets.ModuleScripts.Packets),
		Packet = debug.getupvalue(getrawmetatable(require(replicatedStorage.Assets.ModuleScripts.Packets.Packet)).__call, 3),
		Util = require(replicatedStorage.Assets.SharedClasses.Util),
		Teams = redline.Teams
	}, {
		__index = function(self, ind)
			return rawget(classList, ind)
		end
	})

	local dumplist = {
		Constants = {
			ShootFunction = function(constants, func, inst)
				for _, const in constants do
					if const == 'ViewportPointToRay' and debug.info(func, 'n'):sub(1, 1) == '_' then
						redline.ShootFunction = require(inst)[debug.info(func, 'n')]
						break
					end
				end
			end,
			ActionController = function(constants, func, inst)
				for _, const in constants do
					if const == 'getAction FAILED FOR : ' and debug.info(func, 'n'):sub(1, 1) == '_' then
						redline.ActionController = inst.Name
						redline.ActionFunction = require(inst)[debug.info(func, 'n')]
						break
					end
				end
			end,
			IndicatorController = function(constants, func, inst)
				for _, const in constants do
					if const == 'INVALID crosshair_name : ' then
						redline.IndicatorController = inst.Name
						break
					end
				end
			end,
			ActionEventPacket = function(constants, func, inst)
				local found
				for _, const in constants do
					if const == 'OnClientEvent' then
						found = true
					elseif const == 'onKill' and found then
						redline.ActionEventPacket = searchForPacket(func, true)
						if redline.ActionEventPacket then
							redline.ActionEventPacket = redline.Packets.unreliablePackets[redline.ActionEventPacket]
						end

						break
					end
				end
			end,
			LaunchpadFunction = function(constants, func, inst)
				local found
				for _, const in constants do
					if const == -0.007 then
						found = true
					elseif const == 'augment' and found then
						local dumpList = {}
						for _, const in constants do
							if tostring(const):sub(1, 2) == '_x' then
								table.insert(dumpList, const)
							end
						end

						redline.LaunchpadFunction = dumpList[9]
						break
					end
				end
			end
		},
		Protos = {
			AttackPacket = function(protos, func, inst)
				for _, proto in protos do
					if debug.info(proto, 'n') == 'redlinerMelee' then
						redline.AttackPacket = searchForPacket(proto)
						if redline.AttackPacket then
							redline.AttackPacket = redline.Packets[redline.AttackPacket].Name
						end

						break
					end
				end
			end,
			IndicatorTable = function(protos, func, inst)
				for _, proto in protos do
					if debug.info(proto, 'n') == 'removeShotIndicator' then
						for _, const in debug.getconstants(proto) do
							if tostring(const):sub(1, 1) == '_' then
								redline.IndicatorTable = const
								break
							end
						end

						break
					end
				end
			end,
			DashVariables = function(protos, func, inst)
				for _, proto in protos do
					local doBreak = false
					local found = false
					for _, const in debug.getconstants(proto) do
						if const == 'onDeath' then
							found = true
						elseif const == 'Fire' and found then
							doBreak = true
						end
					end

					if doBreak then
						local dumpList = {}
						for _, const in debug.getconstants(proto) do
							if tostring(const):sub(1, 2) == '_x' then
								table.insert(dumpList, const)
							end
						end

						redline.MoveController = dumpList[3]
						redline.DashRecoverVariable = dumpList[4]
						redline.DashVariable = dumpList[5]
						break
					end
				end
			end
		}
	}

	for _, v in getscripts() do
		if v:GetFullName():sub(1, 5) == 'Start' and v:IsA('ModuleScript') then
			local closure = getscriptclosure(v)
			local protos = debug.getprotos(closure)

			if protos[1] then
				if debug.info(protos[1], 'l') == 3 and #debug.info(protos[1], 'n') <= 2 then
					continue
				end
			end

			for _, func in debug.getprotos(closure) do
				for name, callback in dumplist.Constants do
					if not redline[name] then
						callback(debug.getconstants(func), func, v)
					end
				end

				for name, callback in dumplist.Protos do
					if not redline[name] then
						callback(debug.getprotos(func), func, v)
					end
				end
			end
		end
	end

	local kills = sessioninfo:AddItem('Kills')
	local deaths = sessioninfo:AddItem('Deaths')
	local games = sessioninfo:AddItem('Games')
	local wins = sessioninfo:AddItem('Wins')

	if game.PlaceId == 126691165749976 then
		task.delay(1, function()
			games:Increment()
		end)
	end

	if redline.ActionEventPacket then
		vape:Clean(redline.ActionEventPacket.OnClientEvent:Connect(function(data)
			if type(data) == 'table' then
				task.spawn(function()
					local attacker = data.agent and (playersService:GetPlayerFromCharacter(data.agent) or playersService:FindFirstChild(data.agent.Name))
					local victim = data.victim and (playersService:GetPlayerFromCharacter(data.victim) or playersService:FindFirstChild(data.victim.Name))

					if data.action == 'killed' then
						if attacker == lplr then
							vapeEvents.PlayerKill:Fire()
							kills:Increment()
						elseif victim == lplr then
							deaths:Increment()
						end
					elseif data.action == 'hit' and attacker == lplr then
						vapeEvents.Hit:Fire()
					end
				end)
			end
		end))
	end

	vape:Clean(vapeEvents.MatchEnded.Event:Connect(function(won)
		if won then
			wins:Increment()
		end
	end))

	vape:Clean(lplr.PlayerGui.ChildAdded:Connect(function(obj)
		if obj.Name == 'MatchResultsScreen' then
			local results = obj
			obj = obj:FindFirstChild('Subtext', true)
			obj = obj and obj:FindFirstChildWhichIsA('TextLabel')

			if obj then
				obj:GetPropertyChangedSignal('Text'):Wait()
				vapeEvents.MatchEnded:Fire(obj.Text:find('WON') and true or false, results)
			end
		end
	end))
end)

local SendHook = {Hooks = {}}
do
	local oldsend

	local function Hook(...)
		local args = table.pack(...)
		for _, v in SendHook.Hooks do
			if v[2](args) then
				return
			end
		end

		return oldsend(unpack(args, 1, args.n))
	end

	function SendHook:DoHook()
		if not oldsend and next(self.Hooks) then
			oldsend = hookfunction(redline.Packet.Fire, function(...)
				return Hook(...)
			end)
		end
	end

	function SendHook:Add(key, val, priority)
		table.insert(self.Hooks, {key, val, priority or 0})
		table.sort(self.Hooks, function(a, b)
			return a[3] < b[3]
		end)

		if not oldsend then
			if (os.clock() - starttime) < 2 then
				task.defer(function()
					task.delay(2, function()
						self:DoHook()
					end)
				end)
			else
				self:DoHook()
			end
		end
	end

	function SendHook:Remove(key)
		for i, v in self.Hooks do
			if v[1] == key then
				table.remove(self.Hooks, i)
				break
			end
		end

		if oldsend and not next(self.Hooks) then
			if restorefunction then
				restorefunction(redline.Packet.Fire)
			else
				hookfunction(redline.Packet.Fire, oldsend)
			end

			oldsend = nil
		end
	end
end

for _, v in {'Reach', 'TriggerBot', 'AntiFall', 'Desync', 'HitBoxes', 'Invisible', 'Jesus', 'MouseTP', 'Spider', 'SpinBot', 'Swim', 'TargetStrafe', 'AntiRagdoll', 'Disabler', 'StateSpoofer', 'Parkour', 'SafeWalk', 'MurderMystery'} do
	vape:Remove(v)
end