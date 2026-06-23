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
local runService = cloneref(game:GetService('RunService'))
local coreGui = cloneref(game:GetService('CoreGui'))

local gameCamera = workspace.CurrentCamera
local lplr = playersService.LocalPlayer
local vape = shared.vape
local entitylib = vape.Libraries.entity
local targetinfo = vape.Libraries.targetinfo
local mapobj
local lstats

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

local function notif(...)
	return vape:CreateNotification(...)
end

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

run(function()
	lstats = lplr:FindFirstChild('TempPlayerStatsModule')
	if not lstats then
		repeat
			lstats = lplr:FindFirstChild('TempPlayerStatsModule')
			task.wait()
		until lstats or vape.Loaded == nil

		if vape.Loaded == nil then
			return
		end
	end

	local mapval = replicatedStorage.CurrentMap
	local function updateMap()
		if mapval.Value then
			mapobj = mapval.Value
			vapeEvents.MapAdded:Fire(mapobj)
		elseif mapboj then
			vapeEvents.MapRemoved:Fire(mapboj)
			mapobj = nil
		end
	end

	vape:Clean(mapval:GetPropertyChangedSignal('Value'):Connect(updateMap))
	if mapval.Value then
		updateMap()
	end
end)

run(function()
	entitylib.addEntity = function(char, plr, teamfunc)
		if not char then return end
		entitylib.EntityThreads[char] = task.spawn(function()
			local hum = waitForChildOfType(char, 'Humanoid', 10)
			local humrootpart = hum and waitForChildOfType(hum, 'RootPart', workspace.StreamingEnabled and 9e9 or 10, true)
			local head = char:WaitForChild('Head', 10) or humrootpart
			local plrstats = plr:WaitForChild('TempPlayerStatsModule', 10) or {IsBeast = {GetPropertyChangedSignal = function() return {Connect = function() end} end}}

			if hum and humrootpart then
				local entity = {
					Connections = {},
					Character = char,
					Health = hum.Health,
					Head = head,
					Humanoid = hum,
					HumanoidRootPart = humrootpart,
					IsBeast = plrstats.IsBeast.Value,
					HipHeight = hum.HipHeight + (humrootpart.Size.Y / 2) + (hum.RigType == Enum.HumanoidRigType.R6 and 2 or 0),
					MaxHealth = hum.MaxHealth,
					NPC = plr == nil,
					Player = plr,
					RootPart = humrootpart,
					TeamCheck = teamfunc
				}

				if plr == lplr then
					entitylib.character = entity
					entitylib.isAlive = true
					entitylib.Events.LocalAdded:Fire(entity)
				else
					entity.Targetable = entitylib.targetCheck(entity)

					table.insert(entity.Connections, plrstats.IsBeast:GetPropertyChangedSignal('Value'):Connect(function()
						entitylib.refreshEntity(entity.Character, entity.Player)
					end))

					for _, v in entitylib.getUpdateConnections(entity) do
						table.insert(entity.Connections, v:Connect(function()
							entity.Health = hum.Health
							entity.MaxHealth = hum.MaxHealth
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

	entitylib.getEntityColor = function(ent)
		if not (ent.Player and vape.Categories.Main.Options['Use team color'].Enabled) then return end
		if isFriend(ent.Player, true) then
			return Color3.fromHSV(vape.Categories.Friends.Options['Friends color'].Hue, vape.Categories.Friends.Options['Friends color'].Sat, vape.Categories.Friends.Options['Friends color'].Value)
		end
		return ent.IsBeast and Color3.new(1, 0.2, 0.2) or Color3.new(0.3, 1, 0.3)
	end

	entitylib.start()
end)

for _, v in {'AimAssist', 'Reach', 'SilentAim', 'TriggerBot', 'AntiFall', 'Invisible', 'Jesus', 'Killaura', 'AntiRagdoll', 'Disabler', 'MurderMystery'} do
	vape:Remove(v)
end