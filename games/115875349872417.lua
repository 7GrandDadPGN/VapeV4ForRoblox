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
			return game:HttpGet('https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/'..readfile('newvape/profiles/commit.txt')..'/'..select(1, path:gsub('newvape/', '')), true)
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
local drawingactor = loadstring(downloadFile('newvape/libraries/drawing.lua'), 'drawing')(...)
local redline = {}
local starttime = os.clock()
local TargetStrafeVector

local function searchForPacket(func)
	for _, v in debug.getconstants(func) do
		if rawget(redline.Packets, v) then
			return v
		end
	end
end

local dumplist = {
	Constants = {
		ShootFunction = function(constants, func, inst)
			for _, const in constants do
				if const == 'ViewportPointToRay' then
					redline.ShootFunction = require(inst)[debug.info(func, 'n')]
					break
				end
			end
		end,
		ActionController = function(constants, func, inst)
			for _, const in constants do
				if const == 'getAction FAILED FOR : ' then
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
		ReplicateFunction = function(constants, func, inst)
			for _, const in constants do
				if const == 'Message cannot be empty' then
					redline.ReplicateFunction = require(inst)[debug.info(func, 'n')]
					break
				end
			end
		end,
		MoveController = function(constants, func, inst)
			for _, const in constants do
				if const == 'getMoveDirection' then
					local found = {}
					for _, const2 in constants do
						if tostring(const2):find('_') then
							table.insert(found, const2)
						end
					end

					redline.MoveController = found[1]
					redline.VelocityName = found[2]
					break
				end
			end
		end
	},
	Protos = {
		AttackPacket = function(protos, func, inst)
			for _, proto in protos do
				if debug.info(proto, 'n') == 'redlinerMelee' then
					redline.AttackPacket = searchForPacket(debug.getproto(debug.getproto(proto, 1), 1))
					break
				end
			end
		end,
		IndicatorTable = function(protos, func, inst)
			for _, proto in protos do
				if debug.info(proto, 'n') == 'removeShotIndicator' then
					for _, const in debug.getconstants(proto) do
						if tostring(const):find('_') then
							redline.IndicatorTable = const
							break
						end
					end

					break
				end
			end
		end
	}
}

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

if not select(1, ...) then
	if run_on_actor then
		local oldreload = shared.vapereload
		vape.Load = function()
			task.delay(0, function()
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

			for i, v in getactors() do
				run_on_actor(v, executionString)
				return
			end

			notif('Vape', 'Failed to find actor', 10, 'alert')
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

	entitylib.getUpdateConnections = function(ent)
		local healthval = ent.Player:FindFirstChild('health', true)
		local maxhealthval = ent.Player:FindFirstChild('health_max', true)
		local connections = {
			{
				Connect = function()
					ent.Friend = ent.Player and isFriend(ent.Player) or nil
					ent.Target = ent.Player and isTarget(ent.Player) or nil
					return {Disconnect = function() end}
				end
			}
		}

		if healthval and maxhealthval and healthval:IsA('IntValue') and maxhealthval:IsA('IntValue') then
			table.insert(connections, healthval:GetPropertyChangedSignal('Value'))
			table.insert(connections, maxhealthval:GetPropertyChangedSignal('Value'))
		end

		return connections
	end

	entitylib.addEntity = function(char, plr, teamfunc, spawntime)
		if not char then return end
		entitylib.EntityThreads[char] = task.spawn(function()
			local hum = waitForChildOfType(char, 'Humanoid', 10)
			local humrootpart = hum and waitForChildOfType(hum, 'RootPart', workspace.StreamingEnabled and 9e9 or 10, true)
			local head = char:WaitForChild('Head', 10) or humrootpart
			local healthval = plr:FindFirstChild('health', true)
			local maxhealthval = plr:FindFirstChild('health_max', true)
			local check = healthval and maxhealthval and healthval:IsA('IntValue') and maxhealthval:IsA('IntValue')

			if hum and humrootpart then
				local entity = {
					Connections = {},
					Character = char,
					Health = hum.Health,
					Head = head,
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

					if check then
						entity.Health = healthval.Value
						entity.MaxHealth = maxhealthval.Value
					end

					for _, v in entitylib.getUpdateConnections(entity) do
						table.insert(entity.Connections, v:Connect(function()
							if check then
								entity.Health = healthval.Value
								entity.MaxHealth = maxhealthval.Value
							end

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
end)
entitylib.start()

run(function()
	local root
	for _, v in getloadedmodules() do
		if v:GetFullName() == 'Start.Client.ClientRoot' then
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

	local classList = rawget(root, 'Classes') or {}
	redline = setmetatable({
		AttackBox = require(replicatedStorage.Assets.ModuleScripts.Attack),
		AttackCast = require(replicatedStorage.Assets.ModuleScripts.Attack.Hitbox),
		Packets = require(replicatedStorage.Assets.ModuleScripts.Packets),
		Packet = debug.getupvalue(getrawmetatable(require(replicatedStorage.Assets.ModuleScripts.Packets.Packet)).__call, 2),
		Util = require(replicatedStorage.Assets.SharedClasses.Util)
	}, {
		__index = function(self, ind)
			return rawget(classList, ind)
		end
	})

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

	if redline.AttackPacket then
		redline.AttackPacket = rawget(rawget(redline.Packets, redline.AttackPacket), 'Name')
	end

	local games = sessioninfo:AddItem('Games')
	local wins = sessioninfo:AddItem('Wins')

	if game.PlaceId == 126691165749976 then
		task.delay(1, function()
			games:Increment()
		end)
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

local HitboxHook = {Hooks = {}}
do
	local oldscan

	local function Hook(...)
		local results = table.pack(oldscan(...))
		for _, v in HitboxHook.Hooks do
			if v[2](results) then
				return {}
			end
		end

		return unpack(results, 1, results.n)
	end

	function HitboxHook:Add(key, val, priority)
		table.insert(self.Hooks, {key, val, priority or 0})
		table.sort(self.Hooks, function(a, b)
			return a[3] < b[3]
		end)

		if not oldscan then
			oldscan = hookfunction(redline.AttackBox.castOnce, function(...)
				return Hook(...)
			end)
		end
	end

	function HitboxHook:Remove(key)
		for i, v in self.Hooks do
			if v[1] == key then
				table.remove(self.Hooks, i)
				break
			end
		end

		if oldscan and not next(self.Hooks) then
			if restorefunction then
				restorefunction(redline.AttackBox.castOnce)
			else
				hookfunction(redline.AttackBox.castOnce, oldscan)
			end

			oldscan = nil
		end
	end
end

for _, v in {'Reach', 'TriggerBot', 'AntiFall', 'Desync', 'HitBoxes', 'Invisible', 'Jesus', 'MouseTP', 'Spider', 'SpinBot', 'Swim', 'TargetStrafe', 'AntiRagdoll', 'Disabler', 'StateSpoofer', 'Parkour', 'SafeWalk', 'MurderMystery'} do
	vape:Remove(v)
end
run(function()
	local SilentAim
	local Target
	local Range
	local HitChance
	local CircleColor
	local CircleTransparency
	local CircleFilled
	local CircleObject
	local old
	
	local function Hook(...)
		if debug.info(4, 's'):find('Gun') then
			local ent = entitylib.EntityMouse({
				Range = Range.Value,
				Part = 'RootPart',
				Players = Target.Players.Enabled,
				NPCs = Target.NPCs.Enabled
			})
	
			if ent then
				targetinfo.Targets[ent] = tick() + 1
				return CFrame.lookAt(gameCamera.CFrame.Position, ent.Head.Position).LookVector
			end
		end
	
		return old(...)
	end
	
	SilentAim = vape.Categories.Combat:CreateModule({
		Name = 'SilentAim',
		Function = function(callback)
			if callback then
				old = hookfunction(redline.ShootFunction, function(...)
					return Hook(...)
				end)
	
				repeat
					if CircleObject then
						CircleObject.Position = inputService:GetMouseLocation()
					end
	
					task.wait()
				until not SilentAim.Enabled
			else
				if old then
					if restorefunction then
						restorefunction(redline.ShootFunction)
					else
						hookfunction(redline.ShootFunction, old)
					end
					old = nil
				end
			end
		end,
		ExtraText = function()
			return 'Redliner'
		end,
		Tooltip = 'Silently adjusts your aim towards the enemy'
	})
	Target = SilentAim:CreateTargets({Players = true})
	Range = SilentAim:CreateSlider({
		Name = 'Range',
		Min = 1,
		Max = 1000,
		Default = 150,
		Function = function(val)
			if CircleObject then
				CircleObject.Radius = val
			end
		end,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end
	})
	HitChance = SilentAim:CreateSlider({
		Name = 'Hit Chance',
		Min = 0,
		Max = 100,
		Default = 85,
		Suffix = '%'
	})
	SilentAim:CreateToggle({
		Name = 'Range Circle',
		Function = function(callback)
			if callback then
				CircleObject = Drawing.new('Circle')
				CircleObject.Filled = CircleFilled.Enabled
				CircleObject.Color = Color3.fromHSV(CircleColor.Hue, CircleColor.Sat, CircleColor.Value)
				CircleObject.Position = vape.gui.AbsoluteSize / 2
				CircleObject.Radius = Range.Value
				CircleObject.NumSides = 100
				CircleObject.Transparency = 1 - CircleTransparency.Value
				CircleObject.Visible = SilentAim.Enabled
			else
				pcall(function()
					CircleObject.Visible = false
					CircleObject:Remove()
				end)
			end
			CircleColor.Object.Visible = callback
			CircleTransparency.Object.Visible = callback
			CircleFilled.Object.Visible = callback
		end
	})
	CircleColor = SilentAim:CreateColorSlider({
		Name = 'Circle Color',
		Function = function(hue, sat, val)
			if CircleObject then
				CircleObject.Color = Color3.fromHSV(hue, sat, val)
			end
		end,
		Darker = true,
		Visible = false
	})
	CircleTransparency = SilentAim:CreateSlider({
		Name = 'Transparency',
		Min = 0,
		Max = 1,
		Decimal = 10,
		Default = 0.5,
		Function = function(val)
			if CircleObject then
				CircleObject.Transparency = 1 - val
			end
		end,
		Darker = true,
		Visible = false
	})
	CircleFilled = SilentAim:CreateToggle({
		Name = 'Circle Filled',
		Function = function(callback)
			if CircleObject then
				CircleObject.Filled = callback
			end
		end,
		Darker = true,
		Visible = false
	})
end)
	
run(function()
	local AlwaysStun
	local Spoof
	local oldsend, oldrepl, oldbuf
	
	local function AddHook()
		if not (AlwaysStun.Enabled and redline.ReplicateFunction) then
			return
		end
	
		oldsend = hookfunction(redline.Packet.Fire, function(...)
			local self = ...
			if self and rawget(self, 'Name') == redline.AttackPacket then
				local args = table.pack(...)
				if type(args[7]) == 'number' then
					args[7] = Spoof.Value
				end
	
				return oldsend(unpack(args, 1, args.n))
			end
	
			return oldsend(...)
		end)
	
		local dumped, dumpcaller
		oldrepl = hookfunction(redline.ReplicateFunction, function(...)
			local msg = ...
	
			if dumped then
				if debug.info(2, 's') == dumpcaller or debug.info(3, 's') == dumpcaller then
					buffer.writef32(msg, dumped, Spoof.Value)
				end
			end
	
			return oldrepl(...)
		end)
	
		oldbuf = hookfunction(buffer.writef32, function(...)
			local buf, ind, data = ...
			if data == -2.25 then
				dumped = ind
				dumpcaller = debug.info(3, 's')
	
				task.defer(function()
					if oldbuf then
						if restorefunction then
							restorefunction(buffer.writef32)
						else
							hookfunction(buffer.writef32, oldbuf)
						end
	
						oldbuf = nil
					end
				end)
			end
	
			return oldbuf(...)
		end)
	end
	
	AlwaysStun = vape.Categories.Blatant:CreateModule({
		Name = 'AlwaysStun',
		Function = function(callback)
			if callback then
				if (os.clock() - starttime) < 2 then
					task.delay(2, AddHook)
				else
					AddHook()
				end
			else
				if oldsend then
					if restorefunction then
						restorefunction(redline.Packet.Fire)
					else
						hookfunction(redline.Packet.Fire, oldsend)
					end
					oldsend = nil
				end
	
				if oldrepl then
					if restorefunction then
						restorefunction(redline.ReplicateFunction)
					else
						hookfunction(redline.ReplicateFunction, oldrepl)
					end
					oldrepl = nil
				end
	
				if oldbuf then
					if restorefunction then
						restorefunction(buffer.writef32)
					else
						hookfunction(buffer.writef32, oldbuf)
					end
					oldbuf = nil
				end
			end
		end,
		Tooltip = 'Spoofs velocity to a high value to win every clash.'
	})
	Spoof = AlwaysStun:CreateSlider({
		Name = 'Spoof value',
		Min = 300,
		Max = 800,
		Default = 800,
		Suffix = 'sps'
	})
end)
	
run(function()
	local AntiParry
	local anims = {
		[replicatedStorage.Assets.Animations:FindFirstChild('3P_Parry', true).AnimationId] = true
	}
	
	AntiParry = vape.Categories.Blatant:CreateModule({
		Name = 'AntiParry',
		Function = function(callback)
			if callback then
				HitboxHook:Add('AntiParry', function(results)
					if type(results[1]) == 'table' then
						for _, hit in next, table.clone(results[1]) do
							local char = hit:FindFirstAncestorWhichIsA('Model')
							local animator = char and char:FindFirstChild('Animator', true)
	
							if animator and animator:IsA('Animator') then
								for _, track in animator:GetPlayingAnimationTracks() do
									if track.IsPlaying and anims[track.Animation.AnimationId] then
										local index = table.find(results[1], hit)
										if index then
											table.remove(results[1], index)
										end
									end
								end
							end
						end
					end
				end, 2)
			else
				HitboxHook:Remove('AntiParry')
			end
		end,
		Tooltip = 'Ignores all targets with the parrying animation'
	})
end)
	
run(function()
	local AutoParry
	
	AutoParry = vape.Categories.Blatant:CreateModule({
		Name = 'AutoParry',
		Function = function(callback)
			if callback then
				local cooldown = os.clock()
	
				repeat
					if cooldown < os.clock() then
						local doParry
						for i, v in next, getIndicators() do
							if v.indicator_type == 'surefire_bullet' then
								local localPos = gameCamera.CFrame.Position
								local targetPos = (((i:FindFirstChild('Head') and i.Head.Position or i.PrimaryPart and i.PrimaryPart.Position or i:GetPivot().Position) - localPos) * Vector3.new(1, 0, 1)).Unit
								local diff = 1 - (workspace.CurrentCamera.CFrame.LookVector * Vector3.new(1, 0, 1)).Unit:Dot(targetPos)
								local timediff = (v.expected_shot_time - os.clock())
	
								if math.abs(diff) <= v.parry_range and timediff < 0.2 and timediff > 0 and v.indicator_ui.Visible then
									doParry = true
								end
							elseif v.indicator_type == 'timing_only' and playersService.NumPlayers <= 2 then
								local timediff = (v.expected_shot_time - os.clock())
	
								if timediff < 0 and timediff > -0.2 and v.indicator_ui.Visible then
									doParry = true
								end
							end
						end
	
						if doParry then
							cooldown = os.clock() + 0.2
	
							task.spawn(function()
								redline.ActionFunction(redline[redline.ActionController], 'PARRY').Pressed:Fire()
							end)
						end
					end
	
					task.wait(0.05)
				until not AutoParry.Enabled
			end
		end,
		Tooltip = 'lol'
	})
end)
	
local Fly
local LongJump
run(function()
	local Value
	local VerticalValue
	local up, down = 0, 0

	Fly = vape.Categories.Blatant:CreateModule({
		Name = 'Fly',
		Function = function(callback)
			if callback then
				if redline[redline.MoveController] and typeof(redline[redline.MoveController][redline.VelocityName]) == 'Vector3' then
					Fly:Clean(runService.PreSimulation:Connect(function(dt)
						local dir = ((TargetStrafeVector or redline[redline.MoveController]:getMoveDirection()) * Value.Value) + Vector3.new(0, 3.5 + (up + down) * VerticalValue.Value, 0)
						redline[redline.MoveController][redline.VelocityName] = dir
					end))
				end

				up, down = 0, 0
				for _, v in {'InputBegan', 'InputEnded'} do
					Fly:Clean(inputService[v]:Connect(function(input)
						if not inputService:GetFocusedTextBox() then
							if input.KeyCode == Enum.KeyCode.Space then
								up = v == 'InputBegan' and 1 or 0
							elseif input.KeyCode == Enum.KeyCode.LeftAlt then
								down = v == 'InputBegan' and -1 or 0
							end
						end
					end))
				end
			end
		end,
		ExtraText = function()
			return 'Redliner'
		end,
		Tooltip = 'Makes you go zoom.'
	})
	Value = Fly:CreateSlider({
		Name = 'Speed',
		Min = 1,
		Max = 150,
		Default = 50,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end
	})
	VerticalValue = Fly:CreateSlider({
		Name = 'Vertical Speed',
		Min = 1,
		Max = 150,
		Default = 50,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end
	})
end)
	
run(function()
	local HighJump
	local Value
	
	HighJump = vape.Categories.Blatant:CreateModule({
		Name = 'HighJump',
		Function = function(callback)
			if callback then
				HighJump:Toggle()
				if redline[redline.MoveController] and typeof(redline[redline.MoveController][redline.VelocityName]) == 'Vector3' then
					redline[redline.MoveController][redline.VelocityName] += Vector3.new(0, Value.Value, 0)
				end
			end
		end,
		ExtraText = function()
			return 'Redliner'
		end,
		Tooltip = 'Lets you jump higher'
	})
	Value = HighJump:CreateSlider({
		Name = 'Velocity',
		Min = 1,
		Max = 150,
		Default = 50,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end
	})
end)
	
run(function()
	local Killaura
	local Targets
	local AttackRange
	local AngleSlider
	local BoxSwingColor
	local BoxAttackColor
	local ParticleTexture
	local ParticleColor1
	local ParticleColor2
	local ParticleSize
	local Overlay = OverlapParams.new()
	Overlay.FilterType = Enum.RaycastFilterType.Include
	Overlay.RespectCanCollide = false
	local Particles, Boxes = {}, {}
	local anims = {
		[replicatedStorage.Assets.Animations:FindFirstChild('3P_Parry', true).AnimationId] = true
	}
	
	local function getTarget()
		local selfpos = entitylib.isAlive and entitylib.character.RootPart.Position or Vector3.zero
		local localfacing = gameCamera.CFrame.LookVector * Vector3.new(1, 0, 1)
		local ent = entitylib.EntityPosition({
			Range = AttackRange.Value,
			Part = 'RootPart',
			Players = Targets.Players.Enabled,
			NPCs = Targets.NPCs.Enabled
		})
	
		if ent then
			local delta = (ent.RootPart.Position - selfpos)
			local angle = math.acos(localfacing:Dot((delta * Vector3.new(1, 0, 1)).Unit))
			if angle > (math.rad(AngleSlider.Value) / 2) then
				return
			end
	
			return ent
		end
	end
	
	local function shouldAttack(ent)
		if playersService.NumPlayers <= 2 then
			for i, v in next, getIndicators() do
				if v.indicator_type == 'surefire_bullet' or v.indicator_type == 'timing_only' then
					local timediff = (v.expected_shot_time - os.clock())
					if timediff < 0.4 then
						return false
					end
				end
			end
		end
	
		local animator = ent.Humanoid:FindFirstChildWhichIsA('Animator')
		if animator then
			for _, track in animator:GetPlayingAnimationTracks() do
				if track.IsPlaying and anims[track.Animation.AnimationId] then
					return false
				end
			end
		end
	
		return true
	end
	
	Killaura = vape.Categories.Blatant:CreateModule({
		Name = 'Killaura',
		Function = function(callback)
			if callback then
				HitboxHook:Add('Killaura', function(results)
					if type(results[1]) == 'table' then
						local ent = getTarget()
	
						if ent then
							Overlay.FilterDescendantsInstances = collectionService:GetTagged('Hurtbox')
							local parts = workspace:GetPartBoundsInRadius(ent.RootPart.Position, 6, Overlay)
	
							for _, v in parts do
								table.insert(results[1], v)
							end
						end
					end
				end, 1)
	
				repeat
					local attacked = {}
					if game.PlaceId ~= 94987506187454 then
						local ent = getTarget()
	
						if ent and shouldAttack(ent) then
							table.insert(attacked, {
								Entity = ent,
								Check = BoxAttackColor
							})
	
							targetinfo.Targets[ent] = tick() + 1
							task.spawn(function()
								redline.ActionFunction(redline[redline.ActionController], 'MELEE').Pressed:Fire()
							end)
						end
					end
	
					for i, v in Boxes do
						v.Adornee = attacked[i] and attacked[i].Entity.RootPart or nil
						if v.Adornee then
							v.Color3 = Color3.fromHSV(attacked[i].Check.Hue, attacked[i].Check.Sat, attacked[i].Check.Value)
							v.Transparency = 1 - attacked[i].Check.Opacity
						end
					end
	
					for i, v in Particles do
						v.Position = attacked[i] and attacked[i].Entity.RootPart.Position or Vector3.new(9e9, 9e9, 9e9)
						v.Parent = attacked[i] and gameCamera or nil
					end
	
					task.wait(0.05)
				until not Killaura.Enabled
			else
				HitboxHook:Remove('Killaura')
	
				for _, v in Boxes do
					v.Adornee = nil
				end
	
				for _, v in Particles do
					v.Parent = nil
				end
			end
		end,
		Tooltip = 'Attack players around you\nwithout aiming at them.'
	})
	Targets = Killaura:CreateTargets({Players = true})
	AttackRange = Killaura:CreateSlider({
		Name = 'Attack range',
		Min = 1,
		Max = 40,
		Default = 40,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end
	})
	AngleSlider = Killaura:CreateSlider({
		Name = 'Max angle',
		Min = 1,
		Max = 360,
		Default = 360
	})
	Killaura:CreateToggle({
		Name = 'Show target',
		Function = function(callback)
			BoxSwingColor.Object.Visible = callback
			BoxAttackColor.Object.Visible = callback
			if callback then
				for i = 1, 10 do
					local box = Instance.new('BoxHandleAdornment')
					box.Adornee = nil
					box.AlwaysOnTop = true
					box.Size = Vector3.new(3, 5, 3)
					box.CFrame = CFrame.new(0, -0.5, 0)
					box.ZIndex = 0
					box.Parent = vape.gui
					Boxes[i] = box
				end
			else
				for _, v in Boxes do
					v:Destroy()
				end
				table.clear(Boxes)
			end
		end
	})
	BoxSwingColor = Killaura:CreateColorSlider({
		Name = 'Target Color',
		Darker = true,
		DefaultHue = 0.6,
		DefaultOpacity = 0.5,
		Visible = false
	})
	BoxAttackColor = Killaura:CreateColorSlider({
		Name = 'Attack Color',
		Darker = true,
		DefaultOpacity = 0.5,
		Visible = false
	})
	Killaura:CreateToggle({
		Name = 'Target particles',
		Function = function(callback)
			ParticleTexture.Object.Visible = callback
			ParticleColor1.Object.Visible = callback
			ParticleColor2.Object.Visible = callback
			ParticleSize.Object.Visible = callback
			if callback then
				for i = 1, 10 do
					local part = Instance.new('Part')
					part.Size = Vector3.new(2, 4, 2)
					part.Anchored = true
					part.CanCollide = false
					part.Transparency = 1
					part.CanQuery = false
					part.Parent = Killaura.Enabled and gameCamera or nil
					local particles = Instance.new('ParticleEmitter')
					particles.Brightness = 1.5
					particles.Size = NumberSequence.new(ParticleSize.Value)
					particles.Shape = Enum.ParticleEmitterShape.Sphere
					particles.Texture = ParticleTexture.Value
					particles.Transparency = NumberSequence.new(0)
					particles.Lifetime = NumberRange.new(0.4)
					particles.Speed = NumberRange.new(16)
					particles.Rate = 128
					particles.Drag = 16
					particles.ShapePartial = 1
					particles.Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.fromHSV(ParticleColor1.Hue, ParticleColor1.Sat, ParticleColor1.Value)),
						ColorSequenceKeypoint.new(1, Color3.fromHSV(ParticleColor2.Hue, ParticleColor2.Sat, ParticleColor2.Value))
					})
					particles.Parent = part
					Particles[i] = part
				end
			else
				for _, v in Particles do
					v:Destroy()
				end
				table.clear(Particles)
			end
		end
	})
	ParticleTexture = Killaura:CreateTextBox({
		Name = 'Texture',
		Default = 'rbxassetid://14736249347',
		Function = function()
			for _, v in Particles do
				v.ParticleEmitter.Texture = ParticleTexture.Value
			end
		end,
		Darker = true,
		Visible = false
	})
	ParticleColor1 = Killaura:CreateColorSlider({
		Name = 'Color Begin',
		Function = function(hue, sat, val)
			for _, v in Particles do
				v.ParticleEmitter.Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromHSV(hue, sat, val)),
					ColorSequenceKeypoint.new(1, Color3.fromHSV(ParticleColor2.Hue, ParticleColor2.Sat, ParticleColor2.Value))
				})
			end
		end,
		Darker = true,
		Visible = false
	})
	ParticleColor2 = Killaura:CreateColorSlider({
		Name = 'Color End',
		Function = function(hue, sat, val)
			for _, v in Particles do
				v.ParticleEmitter.Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromHSV(ParticleColor1.Hue, ParticleColor1.Sat, ParticleColor1.Value)),
					ColorSequenceKeypoint.new(1, Color3.fromHSV(hue, sat, val))
				})
			end
		end,
		Darker = true,
		Visible = false
	})
	ParticleSize = Killaura:CreateSlider({
		Name = 'Size',
		Min = 0,
		Max = 1,
		Default = 0.2,
		Decimal = 100,
		Function = function(val)
			for _, v in Particles do
				v.ParticleEmitter.Size = NumberSequence.new(val)
			end
		end,
		Darker = true,
		Visible = false
	})
end)
	
run(function()
	local Mode
	local Value
	local AutoDisable
	
	LongJump = vape.Categories.Blatant:CreateModule({
		Name = 'LongJump',
		Function = function(callback)
			if callback then
				local exempt = tick() + 0.1
				if redline[redline.MoveController] and typeof(redline[redline.MoveController][redline.VelocityName]) == 'Vector3' then
					LongJump:Clean(runService.PreSimulation:Connect(function(dt)
						if entitylib.isAlive then
							local dir = redline[redline.MoveController]:getMoveDirection() * Value.Value
							local oldvel = redline[redline.MoveController][redline.VelocityName]
	
							if entitylib.character.Humanoid.FloorMaterial ~= Enum.Material.Air then
								if exempt < tick() and AutoDisable.Enabled then
									if LongJump.Enabled then
										LongJump:Toggle()
									end
								else
									oldvel = Vector3.new(0, 40, 0)
								end
							end
	
							redline[redline.MoveController][redline.VelocityName] = Vector3.new(dir.X, oldvel.Y, dir.Z)
						end
					end))
				end
			end
		end,
		ExtraText = function()
			return 'Redliner'
		end,
		Tooltip = 'Lets you jump farther'
	})
	Value = LongJump:CreateSlider({
		Name = 'Speed',
		Min = 1,
		Max = 150,
		Default = 50,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end
	})
	AutoDisable = LongJump:CreateToggle({
		Name = 'Auto Disable',
		Default = true
	})
end)
	
run(function()
	local Speed
	local Value
	local AutoJump
	local AutoJumpCustom
	local AutoJumpValue
	
	Speed = vape.Categories.Blatant:CreateModule({
		Name = 'Speed',
		Function = function(callback)
			if callback then
				if redline[redline.MoveController] and typeof(redline[redline.MoveController][redline.VelocityName]) == 'Vector3' then
					Speed:Clean(runService.PreSimulation:Connect(function()
						if not Fly.Enabled and not LongJump.Enabled then
							local dir = (TargetStrafeVector or redline[redline.MoveController]:getMoveDirection()) * Value.Value
							local oldvel = redline[redline.MoveController][redline.VelocityName]
	
							if AutoJump.Enabled and entitylib.isAlive and entitylib.character.Humanoid.FloorMaterial ~= Enum.Material.Air and dir.Magnitude > 0.01 then
								oldvel = Vector3.new(0, AutoJumpCustom.Enabled and AutoJumpValue.Value or 40, 0)
							end
	
							redline[redline.MoveController][redline.VelocityName] = Vector3.new(dir.X, oldvel.Y, dir.Z)
						end
					end))
				end
			end
		end,
		ExtraText = function()
			return 'Redliner'
		end,
		Tooltip = 'Increases your movement with various methods.'
	})
	Value = Speed:CreateSlider({
		Name = 'Speed',
		Min = 1,
		Max = 150,
		Default = 100,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end
	})
	AutoJump = Speed:CreateToggle({
		Name = 'AutoJump',
		Function = function(callback)
			AutoJumpCustom.Object.Visible = callback
		end
	})
	AutoJumpCustom = Speed:CreateToggle({
		Name = 'Custom Jump',
		Function = function(callback)
			AutoJumpValue.Object.Visible = callback
		end,
		Tooltip = 'Allows you to adjust the jump power',
		Darker = true,
		Visible = false
	})
	AutoJumpValue = Speed:CreateSlider({
		Name = 'Jump Power',
		Min = 1,
		Max = 50,
		Default = 30,
		Darker = true,
		Visible = false
	})
end)
	
run(function()
	local TargetStrafe
	local Targets
	local SearchRange
	local StrafeRange
	local YFactor
	local rayCheck = RaycastParams.new()
	rayCheck.FilterDescendantsInstances = {workspace.Map}
	rayCheck.FilterType = Enum.RaycastFilterType.Include
	
	TargetStrafe = vape.Categories.Blatant:CreateModule({
		Name = 'TargetStrafe',
		Function = function(callback)
			if callback then
				local flymod, ang, oldent = vape.Modules.Fly or {Enabled = false}
				TargetStrafe:Clean(runService.PreSimulation:Connect(function()
					local vec
					local wallcheck = Targets.Walls.Enabled
					local ent = not inputService:IsKeyDown(Enum.KeyCode.S) and entitylib.EntityPosition({
						Range = SearchRange.Value,
						Wallcheck = wallcheck,
						Part = 'RootPart',
						Players = Targets.Players.Enabled,
						NPCs = Targets.NPCs.Enabled
					})
	
					if ent then
						local root, targetPos = entitylib.character.RootPart, ent.RootPart.Position
	
						if flymod.Enabled or workspace:Raycast(targetPos, Vector3.new(0, -70, 0), rayCheck) then
							local factor, localPosition = 0, root.Position
							if ent ~= oldent then
								ang = math.deg(select(2, CFrame.lookAt(targetPos, localPosition):ToEulerAnglesYXZ()))
							end
	
							local yFactor = math.abs(localPosition.Y - targetPos.Y) * (YFactor.Value / 100)
							local entityPos = Vector3.new(targetPos.X, localPosition.Y, targetPos.Z)
							local newPos = entityPos + (CFrame.Angles(0, math.rad(ang), 0).LookVector * (StrafeRange.Value - yFactor))
							local startRay, endRay = entityPos, newPos
	
							if not wallcheck and workspace:Raycast(targetPos, (localPosition - targetPos), rayCheck) then
								startRay, endRay = entityPos + (CFrame.Angles(0, math.rad(ang), 0).LookVector * (entityPos - localPosition).Magnitude), entityPos
							end
	
							local ray = workspace:Blockcast(CFrame.new(startRay), Vector3.new(1, entitylib.character.HipHeight + (root.Size.Y / 2), 1), (endRay - startRay), rayCheck)
							if (localPosition - newPos).Magnitude < 3 or ray then
								factor = (8 - math.min((localPosition - newPos).Magnitude, 3))
								if ray then
									newPos = ray.Position + (ray.Normal * 1.5)
									factor = (localPosition - newPos).Magnitude > 3 and 0 or factor
								end
							end
	
							if not flymod.Enabled and not workspace:Raycast(newPos, Vector3.new(0, -70, 0), rayCheck) then
								newPos = entityPos
								factor = 40
							end
	
							ang += factor % 360
							vec = ((newPos - localPosition) * Vector3.new(1, 0, 1)).Unit
							vec = vec == vec and vec or Vector3.zero
							TargetStrafeVector = vec
						else
							ent = nil
						end
					end
	
					TargetStrafeVector = ent and vec or nil
					oldent = ent
				end))
			else
				TargetStrafeVector = nil
			end
		end,
		Tooltip = 'Automatically strafes around the opponent'
	})
	Targets = TargetStrafe:CreateTargets({
		Players = true,
		Walls = true
	})
	SearchRange = TargetStrafe:CreateSlider({
		Name = 'Search Range',
		Min = 1,
		Max = 30,
		Default = 24,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end
	})
	StrafeRange = TargetStrafe:CreateSlider({
		Name = 'Strafe Range',
		Min = 1,
		Max = 30,
		Default = 18,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end
	})
	YFactor = TargetStrafe:CreateSlider({
		Name = 'Y Factor',
		Min = 0,
		Max = 100,
		Default = 100,
		Suffix = '%'
	})
end)
	
run(function()
	local AutoLeave
	local Delay
	
	AutoLeave = vape.Categories.Utility:CreateModule({
		Name = 'AutoLeave',
		Function = function(callback)
			if callback then
				AutoLeave:Clean(vapeEvents.MatchEnded.Event:Connect(function(_, obj)
					task.delay(Delay.Value, function()
						firesignal(obj.Main.Actions.returnbutton.MouseButton1Click)
					end)
				end))
			end
		end,
		Tooltip = 'Automatically leave after the match ends.'
	})
	Delay = AutoLeave:CreateSlider({
		Name = 'Delay',
		Min = 0,
		Max = 2,
		Default = 1,
		Decimal = 10,
		Suffix = 'seconds'
	})
end)
	
run(function()
	local AutoToxic
	local GG
	local Toggles, Lists, said, dead = {}, {}, {}
	
	local function sendMessage(name, obj, default)
		local tab = Lists[name].ListEnabled
		local custommsg = #tab > 0 and tab[math.random(1, #tab)] or default
		if not custommsg then return end
		if #tab > 1 and custommsg == said[name] then
			repeat
				task.wait()
				custommsg = tab[math.random(1, #tab)]
			until custommsg ~= said[name]
		end
		said[name] = custommsg
	
		custommsg = custommsg and custommsg:gsub('<obj>', obj or '') or ''
		if textChatService.ChatVersion == Enum.ChatVersion.TextChatService then
			textChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync(custommsg)
		else
			replicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(custommsg, 'All')
		end
	end
	
	AutoToxic = vape.Categories.Utility:CreateModule({
		Name = 'AutoToxic',
		Function = function(callback)
			if callback then
				AutoToxic:Clean(vapeEvents.MatchEnded.Event:Connect(function(won)
					if GG.Enabled then
						if textChatService.ChatVersion == Enum.ChatVersion.TextChatService then
							textChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync('gg')
						else
							replicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer('gg', 'All')
						end
					end
	
					if won then
						if Toggles.Win.Enabled then
							sendMessage('Win', nil, 'yall garbage')
						end
					end
				end))
			end
		end,
		Tooltip = 'Says a message after a certain action'
	})
	GG = AutoToxic:CreateToggle({
		Name = 'AutoGG',
		Default = true
	})
	for _, v in {'Win'} do
		Toggles[v] = AutoToxic:CreateToggle({
			Name = v..' ',
			Function = function(callback)
				if Lists[v] then
					Lists[v].Object.Visible = callback
				end
			end
		})
		Lists[v] = AutoToxic:CreateTextList({
			Name = v,
			Darker = true,
			Visible = false
		})
	end
end)
	
run(function()
	local Gravity
	local Value
	
	Gravity = vape.Categories.World:CreateModule({
		Name = 'Gravity',
		Function = function(callback)
			if callback then
				if redline[redline.MoveController] and typeof(redline[redline.MoveController][redline.VelocityName]) == 'Vector3' then
					Gravity:Clean(runService.PreSimulation:Connect(function(dt)
						if entitylib.isAlive and entitylib.character.Humanoid.FloorMaterial == Enum.Material.Air then
							redline[redline.MoveController][redline.VelocityName] += Vector3.new(0, dt * (workspace.Gravity - Value.Value), 0)
						end
					end))
				end
			end
		end,
		Tooltip = 'Changes the rate you fall'
	})
	Value = Gravity:CreateSlider({
		Name = 'Gravity',
		Min = 0,
		Max = 192,
		Default = 192
	})
end)
	