local run = function(func)
	func()
end
local cloneref = cloneref or function(obj)
	return obj
end

local playersService = cloneref(game:GetService('Players'))
local inputService = cloneref(game:GetService('UserInputService'))
local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local collectionService = cloneref(game:GetService('CollectionService'))
local runService = cloneref(game:GetService('RunService'))
local guiService = cloneref(game:GetService('GuiService'))
local coreGui = cloneref(game:GetService('CoreGui'))

local gameCamera = workspace.CurrentCamera
local lplr = playersService.LocalPlayer
local vape = shared.vape
local entitylib = vape.Libraries.entity
local whitelist = vape.Libraries.whitelist
local prediction = vape.Libraries.prediction
local targetinfo = vape.Libraries.targetinfo
local sessioninfo = vape.Libraries.sessioninfo

local bw = {}
local blocks = {}
local BlockTimes = {}
local AnticheatBypass
local bypassRoot

local function applySpeed(speed, dt)
	local root = entitylib.character.RootPart
	local dest = (entitylib.character.Humanoid.MoveDirection * math.max((speed + (entitylib.character.Humanoid.WalkSpeed - 16)) - entitylib.character.Humanoid.WalkSpeed, 0) * dt)
	local rayCheck = RaycastParams.new()
	rayCheck.RespectCanCollide = true
	rayCheck.FilterDescendantsInstances = {lplr.Character, gameCamera}
	rayCheck.CollisionGroup = root.CollisionGroup

	local ray = workspace:Raycast(root.Position, dest, rayCheck)
	if ray then
		dest = ((ray.Position + ray.Normal) - root.Position)
	end
	root.CFrame += dest
end

local function collection(tags, module, customadd, customremove)
	tags = typeof(tags) ~= 'table' and {tags} or tags
	local objs, connections = {}, {}

	for _, tag in tags do
		table.insert(connections, collectionService:GetInstanceAddedSignal(tag):Connect(function(v)
			if customadd then
				customadd(objs, v, tag)
				return
			end
			table.insert(objs, v)
		end))
		table.insert(connections, collectionService:GetInstanceRemovedSignal(tag):Connect(function(v)
			if customremove then
				customremove(objs, v, tag)
				return
			end
			v = table.find(objs, v)
			if v then
				table.remove(objs, v)
			end
		end))

		for _, v in collectionService:GetTagged(tag) do
			if customadd then
				customadd(objs, v, tag)
				continue
			end
			table.insert(objs, v)
		end
	end

	local cleanFunc = function(self)
		for _, v in connections do
			v:Disconnect()
		end
		table.clear(connections)
		table.clear(objs)
		table.clear(self)
	end
	if module then
		module:Clean(cleanFunc)
	end
	return objs, cleanFunc
end

local function getTool()
	return lplr.Character and lplr.Character:FindFirstChildWhichIsA('Tool')
end

run(function()
	local oldstart = entitylib.start
	local function customEntity(ent)
		entitylib.addEntity(ent, nil, function(self)
			return (lplr.Team and lplr.Team.Name or '') ~= self.Character:GetAttribute('TeamId')
		end)
	end

	entitylib.start = function()
		oldstart()
		if entitylib.Running then
			for _, ent in collectionService:GetTagged('Attackable') do
				customEntity(ent)
			end
			table.insert(entitylib.Connections, collectionService:GetInstanceAddedSignal('Attackable'):Connect(customEntity))
			table.insert(entitylib.Connections, collectionService:GetInstanceRemovedSignal('Attackable'):Connect(function(ent)
				entitylib.removeEntity(ent)
			end))
		end
	end
end)
entitylib.start()

run(function()
	bw = {
		RemoteIndex = require(replicatedStorage.Modules.RemotesIndex),
		BlockBreakConstants = require(replicatedStorage.Modules.Configs.BlockBreakConfig),
		ShopConfig = require(replicatedStorage.Modules.Configs.ShopConfig),
		Inventory = debug.getupvalue(require(replicatedStorage.Modules.ShopUIClient).Start, 8)
	}

	blocks = collection('BedWarsX_PlacedBlock', vape, function(tab, block)
		tab[block.Position // 3] = block
	end, function(tab, block)
		tab[block.Position // 3] = nil
	end)

	local kills = sessioninfo:AddItem('Kills')
	local beds = sessioninfo:AddItem('Beds')
	local wins = sessioninfo:AddItem('Wins')
	local games = sessioninfo:AddItem('Games')

	task.delay(1, function()
		if workspace:GetAttribute('ServerType') ~= 'Lobby' then
			games:Increment()
		end
	end)

	vape:Clean(lplr:GetAttributeChangedSignal('RoundKills'):Connect(function()
		if lplr:GetAttribute('RoundKills') > 0 then
			kills:Increment()
		end
	end))

	vape:Clean(bw.RemoteIndex.Round_Event.OnClientEvent:Connect(function(data)
		if type(data) == 'table' and data.id == 'final_kill' then
			if lplr.Team and lplr.Team.Name == data.teamId then
				wins:Increment()
			end
		end
	end))

	vape:Clean(bw.RemoteIndex.Bed_Destroyed.OnClientEvent:Connect(function(data)
		if type(data) == 'table' and data.breakerId == lplr.UserId then
			beds:Increment()
		end
	end))

	vape:Clean(entitylib.Events.EntityAdded:Connect(function(entity)
		BlockTimes[entity.Character] = 0

		local animator = entity.Humanoid:FindFirstChild('Animator')
		if animator then
			table.insert(entity.Connections, animator.AnimationPlayed:Connect(function(track)
				if track.Animation.AnimationId == 'rbxassetid://99664081334494' or track.Animation.AnimationId == 'rbxassetid://75062274621204' then
					BlockTimes[entity.Character] = os.clock()
				end
			end))
		end
	end))

	vape:Clean(entitylib.Events.EntityRemoving:Connect(function(entity)
		BlockTimes[entity.Character] = nil
	end))
end)

for _, v in {'AimAssist', 'Reach', 'SilentAim', 'TriggerBot', 'Jesus', 'AutoRejoin', 'Disabler', 'FastProxPrompt', 'SafeWalk', 'MurderMystery'} do
	vape:Remove(v)
end