local run = function(func) func() end
local cloneref = cloneref or function(obj) return obj end

local playersService = cloneref(game:GetService('Players'))
local inputService = cloneref(game:GetService('UserInputService'))
local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local replicatedFirst = cloneref(game:GetService('ReplicatedFirst'))
local collectionService = cloneref(game:GetService('CollectionService'))
local runService = cloneref(game:GetService('RunService'))
local coreGui = cloneref(game:GetService('CoreGui'))

local gameCamera = workspace.CurrentCamera
local lplr = playersService.LocalPlayer
local vape = shared.vape
local entitylib = vape.Libraries.entity
local targetinfo = vape.Libraries.targetinfo
local arena = {}

local oldhit
local Spider = {Enabled = false}
local Phase = {Enabled = false}

local function calculateMoveVector()
	local vec = arena.MoveController:GetMoveVector()
	local c, s
	local _, _, _, R00, R01, R02, _, _, R12, _, _, R22 = gameCamera.CFrame:GetComponents()
	if R12 < 1 and R12 > -1 then
		c = R22
		s = R02
	else
		c = R00
		s = -R01 * math.sign(R12)
	end
	vec = Vector3.new((c * vec.X + s * vec.Z), 0, (c * vec.Z - s * vec.X)) / math.sqrt(c * c + s * s)
	return vec.Unit == vec.Unit and vec.Unit or Vector3.zero
end

local function notif(...)
	return vape:CreateNotification(...)
end

run(function()
	local charscript = lplr.PlayerScripts.CharacterController
	local env = getsenv(charscript)
	if not (env and env.startHit) then
		repeat
			env = getsenv(charscript)
			task.wait()
		until env and env.startHit or vape.Loaded == nil

		if vape.Loaded == nil then return end
	end

	arena = {
		Client = getsenv(charscript),
		PlayerState = require(charscript.PlayerState),
		Inventory = require(charscript.Inventory),
		MoveController = require(lplr.PlayerScripts.PlayerModule):GetControls(),
		SwingFunction = debug.getupvalue(getsenv(charscript).startHit, 1)
	}

	for _, v in getconnections(runService.Heartbeat) do
		if v.Function and islclosure(v.Function) and debug.getconstants(v.Function)[1] == 0.05 then
			-- screw mobile exploits, I only have to add this check because none of these pastesploits can implement a *proper* task scheduler for script execution, what a joke.
			arena.TickFunction = debug.getupvalue(v.Function, 3)
		end
	end

	for _, v in getconnections(replicatedStorage.Remotes.LoadLocalCharacter.OnClientEvent) do
		if v.Function then
			arena.MoveFunction = debug.getupvalue(v.Function, 9)
		end
	end

	vape:Clean(function()
		table.clear(arena)
	end)
end)

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
		return {
			ent.Player.HealthValue:GetPropertyChangedSignal('Value')
		}
	end

	entitylib.addEntity = function(char, plr, teamfunc)
		if not char then return end

		if plr == lplr then
			local hum = {GetState = function() end, Health = 100}
			local humrootpart = gameCamera.CameraSubject

			local entity = {
				Connections = {},
				Character = char,
				Health = 100,
				Head = humrootpart,
				Humanoid = hum,
				HumanoidRootPart = humrootpart,
				HipHeight = 5,
				MaxHealth = 100,
				NPC = plr == nil,
				Player = plr,
				RootPart = humrootpart,
				TeamCheck = teamfunc
			}

			entitylib.character = entity
			entitylib.isAlive = true
			entitylib.Events.LocalAdded:Fire(entity)
			return
		end

		entitylib.EntityThreads[char] = task.spawn(function()
			local hum = waitForChildOfType(char, 'Humanoid', 10)
			local humrootpart = char:WaitForChild('Torso', 10)
			local head = char:WaitForChild('Head', 10) or humrootpart
			local val = plr:WaitForChild('HealthValue', 10)

			if hum and humrootpart then
				local entity = {
					Connections = {},
					Character = char,
					Health = plr.HealthValue.Value,
					Head = head,
					Humanoid = hum,
					HumanoidRootPart = humrootpart,
					Hitbox = char.PlayerHitbox,
					HipHeight = 3,
					MaxHealth = 100,
					NPC = plr == nil,
					Player = plr,
					RootPart = humrootpart,
					TeamCheck = teamfunc
				}

				entity.Targetable = entitylib.targetCheck(entity)
				for _, v in entitylib.getUpdateConnections(entity) do
					table.insert(entity.Connections, v:Connect(function()
						entity.Health = plr.HealthValue.Value
						entitylib.Events.EntityUpdated:Fire(entity)
					end))
				end

				table.insert(entitylib.List, entity)
				entitylib.Events.EntityAdded:Fire(entity)
			end

			entitylib.EntityThreads[char] = nil
		end)
	end

	entitylib.addPlayer = function(plr) end

	local oldstart = entitylib.start
	entitylib.start = function()
		oldstart()
		if entitylib.Running then
			table.insert(entitylib.Connections, gameCamera:GetPropertyChangedSignal('CameraSubject'):Connect(function()
				if gameCamera.CameraSubject then
					entitylib.addEntity(true, lplr)
				end
			end))

			if gameCamera.CameraSubject then
				entitylib.addEntity(true, lplr)
			end

			table.insert(entitylib.Connections, workspace.OtherCharacters.ChildAdded:Connect(function(ent)
				local plr = playersService:FindFirstChild(ent.Name:sub(1, #ent.Name - 14))
				if plr then
					entitylib.refreshEntity(ent, plr)
				end
			end))

			for _, ent in workspace.OtherCharacters:GetChildren() do
				local plr = playersService:FindFirstChild(ent.Name:sub(1, #ent.Name - 14))
				if plr then
					entitylib.refreshEntity(ent, plr)
				end
			end
		end
	end

	entitylib.start()
end)

for _, v in {'AimAssist', 'Reach', 'SilentAim', 'AntiFall', 'Desync', 'Invisible', 'Jesus', 'MouseTP', 'Phase', 'SpinBot', 'Swim', 'TargetStrafe', 'AnimationPlayer', 'AntiRagdoll', 'ChatSpammer', 'Disabler', 'StateSpoofer', 'Freecam', 'Gravity', 'Parkour', 'SafeWalk', 'MurderMystery'} do
	vape:Remove(v)
end