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
local marketplaceService = cloneref(game:GetService('MarketplaceService'))
local textChatService = cloneref(game:GetService('TextChatService'))
local tweenService = cloneref(game:GetService('TweenService'))
local runService = cloneref(game:GetService('RunService'))
local guiService = cloneref(game:GetService('GuiService'))
local teams = cloneref(game:GetService('Teams'))
local coreGui = cloneref(game:GetService('CoreGui'))

local gameCamera = workspace.CurrentCamera
local lplr = playersService.LocalPlayer
local vape = shared.vape
local entitylib = vape.Libraries.entity
local whitelist = vape.Libraries.whitelist
local targetinfo = vape.Libraries.targetinfo
local sessioninfo = vape.Libraries.sessioninfo
local getfontsize = vape.Libraries.getfontsize

local pl = {}
local Spring = {}
local TracerHook = {Hooks = {}}
local oldshoot, oldequip
local aimTimer, shootTimer, aimVec = os.clock(), os.clock()
local arrestCooldown = os.clock()
local tempTargets = {}
local gamepasses = {}

local function checkPoint(pos, params)
	for _, v in workspace:GetPartBoundsInRadius(pos, 0, params) do
		if v.CanCollide and (v:GetClosestPointOnSurface(pos) - pos).Magnitude <= 0 then
			return false
		end
	end

	return true
end

local function canClick()
	local mousepos = (inputService:GetMouseLocation() - guiService:GetGuiInset())
	for _, v in lplr.PlayerGui:GetGuiObjectsAtPosition(mousepos.X, mousepos.Y) do
		local obj = v:FindFirstAncestorOfClass('ScreenGui')
		if v.Active and v.Visible and obj and obj.Enabled then
			return false
		end
	end
	for _, v in coreGui:GetGuiObjectsAtPosition(mousepos.X, mousepos.Y) do
		local obj = v:FindFirstAncestorOfClass('ScreenGui')
		if v.Active and v.Visible and obj and obj.Enabled then
			return false
		end
	end
	return (not vape.gui.ScaledGui.ClickGui.Visible) and (not inputService:GetFocusedTextBox())
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
	return (table.find(vape.Categories.Targets.ListEnabled, plr.Name) or tempTargets[plr.Name]) and true
end

local function notif(...)
	return vape:CreateNotification(...)
end

local function removeTags(str)
	str = str:gsub('<br%s*/>', '\n')
	return (str:gsub('<[^<>]->', ''))
end

local OriginScanner = {Cache = {}}
run(function()
	local rayParams = RaycastParams.new()
	local overlapParams = OverlapParams.new()
	rayParams.CollisionGroup = 'ClientBullet'
	rayParams.FilterType = Enum.RaycastFilterType.Exclude
	overlapParams.CollisionGroup = 'ClientBullet'
	overlapParams.FilterType = Enum.RaycastFilterType.Exclude
	OriginScanner.Ray = rayParams

	local positions = {
		Vector3.new(0, 1, 0),
		Vector3.new(1, 0, 0),
		Vector3.new(0.7, -0.5, -0.5),
		Vector3.new(-0.1, -0.8, -0.8),
		Vector3.new(-0.8, -0.5, -0.5),
		Vector3.new(-1, 0, 0),
		Vector3.new(-0.8, 0.4, 0.4),
		Vector3.new(0, 0.7, 0.7),
		Vector3.new(0.7, 0.5, 0.5),
		Vector3.new(1, 0, 0),
		Vector3.new(0.7, 0, -0.8),
		Vector3.new(-0.1, 0, -1),
		Vector3.new(-0.8, 0, -0.8),
		Vector3.new(-1, 0, 0),
		Vector3.new(-0.8, 0, 0.7),
		Vector3.new(0, 0, 1),
		Vector3.new(0.7, 0, 0.7),
		Vector3.new(1, 0, 0),
		Vector3.new(0.7, 0.4, -0.5),
		Vector3.new(-0.1, 0.7, -0.8),
		Vector3.new(-0.8, 0.4, -0.5),
		Vector3.new(-1, -0.1, 0),
		Vector3.new(-0.8, -0.5, 0.4),
		Vector3.new(0, -0.8, 0.7),
		Vector3.new(0.7, -0.6, 0.5),
		Vector3.new(0, -1, 0)
	}

	function OriginScanner:Scan(origin, target, extra, part)
		local scanPositions = {}
		local hitboxPositions = {}
		local returnHitbox
		local diff = CFrame.lookAt(origin * Vector3.new(1, 0, 1), target * Vector3.new(1, 0, 1)).LookVector

		if OriginScanner.Cache[part] then
			return table.unpack(OriginScanner.Cache[part])
		end

		if extra then
			if (origin - extra).Magnitude < 7.5 then
				table.insert(scanPositions, extra)
			else
				table.insert(hitboxPositions, target)
				for _, v in Enum.NormalId:GetEnumItems() do
					local vec = Vector3.fromNormalId(v)

					if (vec * Vector3.new(1, 0, 1)):Dot(-diff) > -0.5 then
						local pos = target + vec * 6

						if checkPoint(pos, overlapParams) then
							table.insert(hitboxPositions, pos)
						end
					end
				end
			end
		end

		if #scanPositions <= 0 then
			for _, v in positions do
				if (v * Vector3.new(1, 0, 1)):Dot(diff) > -0.5 then
					table.insert(scanPositions, origin + v * 6)
				end
			end
		end

		if #hitboxPositions > 0 then
			for _, hitbox in hitboxPositions do
				for _, pos in scanPositions do
					local ray = workspace:Raycast(hitbox, (pos - hitbox), rayParams)

					if not ray and checkPoint(pos, overlapParams) then
						OriginScanner.Cache[part] = {pos, hitbox}
						return pos, hitbox
					end
				end
			end
		else
			for _, pos in scanPositions do
				local ray = workspace:Raycast(target, (pos - target), rayParams)

				if not ray and checkPoint(pos, overlapParams) then
					OriginScanner.Cache[part] = {pos}
					return pos
				end
			end
		end
	end

	function OriginScanner:UpdateIgnore()
		local ignore = {lplr.Character}
		for _, entity in entitylib.List do
			table.insert(ignore, entity.Character)
		end

		rayParams.FilterDescendantsInstances = ignore
		overlapParams.FilterDescendantsInstances = ignore
	end
end)

local CheatFlags = {Flags = {}, Flagged = {}}
run(function()
	function CheatFlags:Flag(plr, flagtype, limit)
		if CheatFlags.Flagged[plr.UserId] then
			return
		end

		if not CheatFlags.Flags[plr.UserId] then
			CheatFlags.Flags[plr.UserId] = {}
		end

		local flags = CheatFlags.Flags[plr.UserId]
		flags[flagtype] = (flags[flagtype] or 0) + 1

		if flags[flagtype] > limit then
			CheatFlags.Flagged[plr.UserId] = true
			vapeEvents.CheatFlagged:Fire(plr, flagtype)
		end
	end

	function CheatFlags:Clear()
		table.clear(CheatFlags.Flags)
		table.clear(CheatFlags.Flagged)
	end
end)

run(function()
	local function getMousePosition()
		if inputService.TouchEnabled then
			return gameCamera.ViewportSize / 2
		end
		return inputService.GetMouseLocation(inputService)
	end

	entitylib.getUpdateConnections = function(entity)
		local humanoid = entity.Humanoid
		return {
			humanoid:GetPropertyChangedSignal('Health'),
			humanoid:GetPropertyChangedSignal('MaxHealth'),
			entity.Character:GetAttributeChangedSignal('Trespassing'),
			entity.Character:GetAttributeChangedSignal('Hostile'),
			entity.Player:GetAttributeChangedSignal('InnocentKills'),
			{
				Connect = function()
					entity.Friend = entity.Player and isFriend(entity.Player) or nil
					entity.Target = entity.Player and isTarget(entity.Player) or nil
					return {Disconnect = function() end}
				end
			}
		}
	end

	entitylib.targetCheck = function(entity)
		if entity.TeamCheck then
			return entity:TeamCheck()
		end
		if entity.NPC then return true end
		if isFriend(entity.Player) then return false end
		if not select(2, whitelist:get(entity.Player)) then return false end
		if vape.Categories.Main.Options['Teams by server'].Enabled then
			return lplr.Team ~= entity.Player.Team and entity.Player.Team ~= teams.Neutral
		end
		return true
	end

	entitylib.isVulnerable = function(entity, attackcheck)
		if attackcheck and lplr.Team == teams.Guards and entity.Player.Team == teams.Inmates and not entity.Character:GetAttribute('Hostile') then
			return false
		end

		return entity.Health > 0 and entity.Humanoid:GetState() ~= Enum.HumanoidStateType.Dead and entity.SpawnTime < os.clock() and not entity.Character.FindFirstChildWhichIsA(entity.Character, 'ForceField') and (entity.Player.Team ~= teams.Inmates or (entity.Character:GetAttribute('Trespassing') or entity.Character:GetAttribute('Hostile')))
	end

	entitylib.EntityMouse = function(entitysettings)
		if entitylib.isAlive then
			local mouseLocation, sortingTable = entitysettings.MouseOrigin or getMousePosition(), {}
			local localPosition = entitysettings.Origin or entitylib.character.HumanoidRootPart.Position
			for _, entity in entitylib.List do
				if not entitysettings.Players and entity.Player then continue end
				if not entitysettings.NPCs and entity.NPC then continue end
				if not entity.Targetable then continue end
				local position, vis = gameCamera.WorldToViewportPoint(gameCamera, entity[entitysettings.Part].Position)
				if not vis then continue end
				local mag = (mouseLocation - Vector2.new(position.x, position.y)).Magnitude
				if mag > entitysettings.Range then continue end
				if entitylib.isVulnerable(entity, entitysettings.AttackCheck) then
					if entitysettings.RangePosition then
						local pmag = (entity[entitysettings.Part].Position - localPosition).Magnitude
						if pmag > entitysettings.RangePosition then continue end
					end

					table.insert(sortingTable, {
						Entity = entity,
						Magnitude = entity.Target and -1 or mag
					})
				end
			end

			table.sort(sortingTable, entitysettings.Sort or function(a, b)
				return a.Magnitude < b.Magnitude
			end)

			for _, v in sortingTable do
				if entitysettings.Wallcheck then
					if entitylib.Wallcheck(entitysettings.Origin, v.Entity[entitysettings.Part].Position, entitysettings.Wallbang, v.Entity[entitysettings.Part]) then continue end
				end
				table.clear(entitysettings)
				table.clear(sortingTable)
				return v.Entity
			end
			table.clear(sortingTable)
		end
		table.clear(entitysettings)
	end

	entitylib.EntityPosition = function(entitysettings)
		if entitylib.isAlive then
			local localPosition, sortingTable = entitysettings.Origin or entitylib.character.HumanoidRootPart.Position, {}
			for _, entity in entitylib.List do
				if not entitysettings.Players and entity.Player then continue end
				if not entitysettings.NPCs and entity.NPC then continue end
				if not entity.Targetable then continue end
				local mag = (entity[entitysettings.Part].Position - localPosition).Magnitude
				if mag > entitysettings.Range then continue end
				if entitylib.isVulnerable(entity, entitysettings.AttackCheck) then
					table.insert(sortingTable, {
						Entity = entity,
						Magnitude = entity.Target and -1 or mag
					})
				end
			end

			table.sort(sortingTable, entitysettings.Sort or function(a, b)
				return a.Magnitude < b.Magnitude
			end)

			for _, v in sortingTable do
				if entitysettings.Wallcheck then
					if entitylib.Wallcheck(localPosition, v.Entity[entitysettings.Part].Position, entitysettings.Wallbang, v.Entity[entitysettings.Part]) then continue end
				end
				table.clear(entitysettings)
				table.clear(sortingTable)
				return v.Entity
			end
			table.clear(sortingTable)
		end
		table.clear(entitysettings)
	end

	entitylib.AllPosition = function(entitysettings)
		local returned = {}
		if entitylib.isAlive then
			local localPosition, sortingTable = entitysettings.Origin or entitylib.character.HumanoidRootPart.Position, {}
			for _, entity in entitylib.List do
				if not entitysettings.Players and entity.Player then continue end
				if not entitysettings.NPCs and entity.NPC then continue end
				if not entity.Targetable then continue end
				local mag = (entity[entitysettings.Part].Position - localPosition).Magnitude
				if mag > entitysettings.Range then continue end
				if entitylib.isVulnerable(entity, entitysettings.AttackCheck) then
					table.insert(sortingTable, {
						Entity = entity,
						Magnitude = entity.Target and -1 or mag
					})
				end
			end

			table.sort(sortingTable, entitysettings.Sort or function(a, b)
				return a.Magnitude < b.Magnitude
			end)

			for _, v in sortingTable do
				if entitysettings.Wallcheck then
					if entitylib.Wallcheck(localPosition, v.Entity[entitysettings.Part].Position, entitysettings.Wallbang, v.Entity[entitysettings.Part]) then continue end
				end
				table.insert(returned, v.Entity)
				if #returned >= (entitysettings.Limit or math.huge) then break end
			end
			table.clear(sortingTable)
		end
		table.clear(entitysettings)
		return returned
	end

	entitylib.getEntityColor = function(ent)
		if not (ent.Player and vape.Categories.Main.Options['Use team color'].Enabled) then return end
		if isFriend(ent.Player, true) then
			return Color3.fromHSV(vape.Categories.Friends.Options['Friends color'].Hue, vape.Categories.Friends.Options['Friends color'].Sat, vape.Categories.Friends.Options['Friends color'].Value)
		end

		local color = tostring(ent.Player.TeamColor) ~= 'White' and ent.Player.TeamColor.Color or nil
		if ent.Player.Team == teams.Inmates and (ent.Character:GetAttribute('Hostile') or ent.Character:GetAttribute('Trespassing')) then
			return Color3.new(color.R, color.G * 0.5, color.B * 0.5)
		end

		return color
	end

	entitylib.Wallcheck = function(origin, position, checkpos, part)
		local ray = workspace.Raycast(workspace, position, (origin - position), OriginScanner.Ray)
		if ray then
			return not checkpos or not OriginScanner:Scan(checkpos, position, ray.Position + ray.Normal * 0.01, part)
		end

		return false
	end
end)
entitylib.start()

run(function()
	pl = {
		GunTracers = require(replicatedStorage.SharedModules.GunTracers)
	}

	local gui = lplr.PlayerGui:WaitForChild('Home', 10)
	gui = gui and gui.hud.ActionArea
	if vape.Loaded == nil then
		return
	end

	local function getShootFunction()
		for _, v in getconnections(gui.InputBegan) do
			if v.Function then
				pl.Shoot = debug.getupvalue(v.Function, 2)
				pl.Reload = debug.getupvalue(pl.Shoot, 2)
				pl.Bullet = debug.getupvalue(pl.Shoot, 16)
				pl.PlaySound = debug.getupvalue(pl.Reload, 3)
				break
			end
		end

		for _, v in getconnections(lplr.CharacterAdded) do
			if v.Function and debug.info(v.Function, 's'):find('GunController') then
				pl.Equip = debug.getupvalue(v.Function, 3)
				break
			end
		end

		for _, v in getconnections(lplr:GetAttributeChangedSignal('BackpackEnabled')) do
			pl.SwitchUpdate = debug.getupvalue(debug.getupvalue(v.Function, 10), 5)
			pl.SwitchTable = debug.getupvalue(debug.getupvalue(v.Function, 8), 2)
			break
		end
	end

	getShootFunction()
	if not (pl.Bullet and pl.SwitchTable) then
		repeat
			getShootFunction()
			task.wait()
		until pl.Bullet and pl.SwitchTable or vape.Loaded == nil

		if vape.Loaded == nil then
			table.clear(pl)
		end
	end

	local kills = sessioninfo:AddItem('Kills')
	local deaths = sessioninfo:AddItem('Deaths')
	local arrests = sessioninfo:AddItem('Arrests')
	local cheaterkicked = sessioninfo:AddItem('Cheaters Kicked')
	local cheaters = sessioninfo:AddItem('Cheater List', '', function()
		local text = ''
		for _, plr in playersService:GetPlayers() do
			if CheatFlags.Flagged[plr.UserId] then
				text = text..'\n'..(plr.DisplayName ~= plr.Name and plr.DisplayName..' ('..plr.Name..')' or plr.Name)
			end
		end

		return text
	end, false)

	vape:Clean(replicatedStorage.Killfeed.ChildAdded:Connect(function(obj)
		local names = {}

		-- killer
		local start = obj.Name:find('@')
		local endchar = obj.Name:find(')')
		table.insert(names, obj.Name:sub(start + 1, endchar - 1))

		-- victim
		start = obj.Name:find('killed ') + 7
		endchar = obj.Name:find(' ', start)
		table.insert(names, obj.Name:sub(start, endchar - 1))

		vapeEvents.PlayerKill:Fire(unpack(names))
		if names[1] == lplr.Name then
			kills:Increment()
		elseif names[2] == lplr.Name then
			deaths:Increment()
		end
	end))

	vape:Clean(vapeEvents.Arrested.Event:Connect(function()
		arrests:Increment()
	end))

	vape:Clean(replicatedStorage.Remotes.MessageReceived.OnClientEvent:Connect(function(msg)
		if msg:find('kicked') then
			cheaterkicked:Increment()

			task.defer(function()
				vapeEvents.CheaterKicked:Fire(msg:sub(1, msg:find(' ')))
			end)
		end
	end))

	vape:Clean(entitylib.Events.EntityUpdated:Connect(function(ent)
		if ent.Player and ent.Player.Team == teams.Inmates then
			vape.Categories.Friends.ColorUpdate:Fire()
		end
	end))

	table.insert(whitelist.tagcallback, function(plr, plrtag, rich)
		if plr then
			local ent = entitylib.getEntity(plr)
			if ent then
				if CheatFlags.Flagged[plr.UserId] then
					table.insert(plrtag, {text = rich and '⚠️' or 'Cheater'})
				end

				if plr.Team == teams.Inmates then
					if ent.Character:GetAttribute('Hostile') then
						table.insert(plrtag, {text = rich and '💢' or 'Hostile'})
					elseif ent.Character:GetAttribute('Trespassing') then
						table.insert(plrtag, {text = rich and '🔗' or 'Trespassing'})
					end
				elseif plr.Team == teams.Guards then
					local count = plr:GetAttribute('InnocentKills') or 0
					if count > 0 then
						table.insert(plrtag, {
							text = tostring(count),
							color = Color3.fromHSV(math.clamp(1 - (count / 2), 0, 1) / 2.5, 0.89, 0.75)
						})
					end
				end
			end
		end
	end)

	task.spawn(function()
		gamepasses = {
			['Riot Police'] = marketplaceService:UserOwnsGamePassAsync(lplr.UserId, 643697197),
			Mafia = marketplaceService:UserOwnsGamePassAsync(lplr.UserId, 1443271),
			Sniper = marketplaceService:UserOwnsGamePassAsync(lplr.UserId, 699360089)
		}
	end)

	OriginScanner:UpdateIgnore()
	for _, v in {'EntityAdded', 'LocalAdded'} do
		vape:Clean(entitylib.Events[v]:Connect(function()
			OriginScanner:UpdateIgnore()
		end))
	end

	vape:Clean(runService.RenderStepped:Connect(function()
		table.clear(OriginScanner.Cache)
	end))

	vape:Clean(function()
		table.clear(pl)
	end)
end)

do
	-- https://github.com/J1ck/roblox-spring/blob/main/src/roblox-spring.luau
	Spring.__index = Spring

	function Spring.new(Properties)
		local TypeRefined = Properties or {}

		local self = setmetatable({
			Target = Vector3.new(),
			Position = Vector3.new(),
			Velocity = Vector3.new(),

			Mass = TypeRefined.Mass or 5,
			Force = TypeRefined.Force or 50,
			Damping	= TypeRefined.Damping or 4,
			Speed = TypeRefined.Speed or 4,
		}, Spring)

		return self
	end

	function Spring:Update(DeltaTime)
		local IterationsThisFrame = DeltaTime / ((1 / 60) / 8)
		local ScaledDeltaTime = DeltaTime * self.Speed / IterationsThisFrame

		for i = 1, math.round(IterationsThisFrame) do
			local IterationForce = self.Target - self.Position
			local Acceleration = (IterationForce * self.Force) / self.Mass

			Acceleration -= self.Velocity * self.Damping

			self.Velocity += Acceleration * ScaledDeltaTime
			self.Position += self.Velocity * ScaledDeltaTime
		end

		return self.Position
	end
end

do
	local oldtracer, oldtracertaser, oldtracersniper

	local function Hook(...)
		if debug.info(3, 's') ~= 'ReplicatedStorage.Scripts.Replication.ClientReplicator' then
			for _, v in TracerHook.Hooks do
				if v[2](...) then return end
			end
		end

		return oldtracer(...)
	end

	local function HookTaser(...)
		if debug.info(3, 's') ~= 'ReplicatedStorage.Scripts.Replication.ClientReplicator' then
			for _, v in TracerHook.Hooks do
				if v[2](...) then return end
			end
		end

		return oldtracertaser(...)
	end

	local function HookSniper(...)
		if debug.info(3, 's') ~= 'ReplicatedStorage.Scripts.Replication.ClientReplicator' then
			for _, v in TracerHook.Hooks do
				if v[2](...) then return end
			end
		end

		return oldtracersniper(...)
	end

	function TracerHook:Add(key, val, priority)
		table.insert(self.Hooks, {key, val, priority or 0})
		table.sort(self.Hooks, function(a, b)
			return a[3] < b[3]
		end)

		if not oldtracer then
			oldtracer = hookfunction(pl.GunTracers.createBullet, function(...)
				return Hook(...)
			end)

			oldtracertaser = hookfunction(pl.GunTracers.createTaser, function(...)
				return HookTaser(...)
			end)

			oldtracersniper = hookfunction(pl.GunTracers.createSniper, function(...)
				return HookSniper(...)
			end)
		end
	end

	function TracerHook:Remove(key)
		for i, v in self.Hooks do
			if v[1] == key then
				table.remove(self.Hooks, i)
				break
			end
		end

		if oldtracer and not next(self.Hooks) then
			if restorefunction then
				restorefunction(pl.GunTracers.createBullet)
				restorefunction(pl.GunTracers.createTaser)
				restorefunction(pl.GunTracers.createSniper)
			else
				hookfunction(pl.GunTracers.createBullet, oldtracer)
				hookfunction(pl.GunTracers.createTaser, oldtracertaser)
				hookfunction(pl.GunTracers.createSniper, oldtracersniper)
			end

			oldtracer = nil
			oldtracertaser = nil
			oldtracersniper = nil
		end
	end
end

for _, v in {'Reach', 'Jesus', 'MurderMystery'} do
	vape:Remove(v)
end