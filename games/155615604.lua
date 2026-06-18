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
	local rayParams2 = OverlapParams.new()
	rayParams.CollisionGroup = 'ClientBullet'
	rayParams.FilterType = Enum.RaycastFilterType.Exclude
	rayParams2.CollisionGroup = 'ClientBullet'
	rayParams2.FilterType = Enum.RaycastFilterType.Exclude
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

						if checkPoint(pos, rayParams2) then
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

					if not ray and checkPoint(pos, rayParams2) then
						OriginScanner.Cache[part] = {pos, hitbox}
						return pos, hitbox
					end
				end
			end
		else
			for _, pos in scanPositions do
				local ray = workspace:Raycast(target, (pos - target), rayParams)

				if not ray and checkPoint(pos, rayParams2) then
					OriginScanner.Cache[part] = {pos}
					return pos
				end
			end
		end
	end

	function OriginScanner:UpdateIgnore()
		local ignore = {lplr.Character}
		for _, v in entitylib.List do
			table.insert(ignore, v.Character)
		end

		rayParams.FilterDescendantsInstances = ignore
		rayParams2.FilterDescendantsInstances = ignore
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

	entitylib.getUpdateConnections = function(ent)
		local hum = ent.Humanoid
		return {
			hum:GetPropertyChangedSignal('Health'),
			hum:GetPropertyChangedSignal('MaxHealth'),
			ent.Character:GetAttributeChangedSignal('Trespassing'),
			ent.Character:GetAttributeChangedSignal('Hostile'),
			ent.Player:GetAttributeChangedSignal('InnocentKills'),
			{
				Connect = function()
					ent.Friend = ent.Player and isFriend(ent.Player) or nil
					ent.Target = ent.Player and isTarget(ent.Player) or nil
					return {Disconnect = function() end}
				end
			}
		}
	end

	entitylib.targetCheck = function(ent)
		if ent.TeamCheck then
			return ent:TeamCheck()
		end
		if ent.NPC then return true end
		if isFriend(ent.Player) then return false end
		if not select(2, whitelist:get(ent.Player)) then return false end
		if vape.Categories.Main.Options['Teams by server'].Enabled then
			return lplr.Team ~= ent.Player.Team and ent.Player.Team ~= teams.Neutral
		end
		return true
	end

	entitylib.isVulnerable = function(ent, attackcheck)
		if attackcheck and lplr.Team == teams.Guards and ent.Player.Team == teams.Inmates and not ent.Character:GetAttribute('Hostile') then
			return false
		end

		return ent.Humanoid:GetState() ~= Enum.HumanoidStateType.Dead and ent.SpawnTime < os.clock() and not ent.Character.FindFirstChildWhichIsA(ent.Character, 'ForceField') and (ent.Player.Team ~= teams.Inmates or (ent.Character:GetAttribute('Trespassing') or ent.Character:GetAttribute('Hostile')))
	end

	entitylib.EntityMouse = function(entitysettings)
		if entitylib.isAlive then
			local mouseLocation, sortingTable = entitysettings.MouseOrigin or getMousePosition(), {}
			local localPosition = entitysettings.Origin or entitylib.character.HumanoidRootPart.Position
			for _, v in entitylib.List do
				if not entitysettings.Players and v.Player then continue end
				if not entitysettings.NPCs and v.NPC then continue end
				if not v.Targetable then continue end
				local position, vis = gameCamera.WorldToViewportPoint(gameCamera, v[entitysettings.Part].Position)
				if not vis then continue end
				local mag = (mouseLocation - Vector2.new(position.x, position.y)).Magnitude
				if mag > entitysettings.Range then continue end
				if entitylib.isVulnerable(v, entitysettings.AttackCheck) then
					if entitysettings.RangePosition then
						local pmag = (v[entitysettings.Part].Position - localPosition).Magnitude
						if pmag > entitysettings.RangePosition then continue end
					end

					table.insert(sortingTable, {
						Entity = v,
						Magnitude = v.Target and -1 or mag
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
			for _, v in entitylib.List do
				if not entitysettings.Players and v.Player then continue end
				if not entitysettings.NPCs and v.NPC then continue end
				if not v.Targetable then continue end
				local mag = (v[entitysettings.Part].Position - localPosition).Magnitude
				if mag > entitysettings.Range then continue end
				if entitylib.isVulnerable(v, entitysettings.AttackCheck) then
					table.insert(sortingTable, {
						Entity = v,
						Magnitude = v.Target and -1 or mag
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
			for _, v in entitylib.List do
				if not entitysettings.Players and v.Player then continue end
				if not entitysettings.NPCs and v.NPC then continue end
				if not v.Targetable then continue end
				local mag = (v[entitysettings.Part].Position - localPosition).Magnitude
				if mag > entitysettings.Range then continue end
				if entitylib.isVulnerable(v, entitysettings.AttackCheck) then
					table.insert(sortingTable, {Entity = v, Magnitude = v.Target and -1 or mag})
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
			vapeEvents.CheaterKicked:Fire(msg:sub(1, msg:find(' ')))
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
local mouseClicked
run(function()
	local SilentAim
	local Target
	local Mode
	local Range
	local HitChance
	local HeadshotChance
	local AutoFire = {Enabled = false}
	local AutoFireRate
	local AutoFireTaser
	local Wallbang
	local CircleColor
	local CircleTransparency
	local CircleFilled
	local CircleObject
	local rayParams = RaycastParams.new()
	rayParams.CollisionGroup = 'ClientBullet'
	rayParams.FilterType = Enum.RaycastFilterType.Exclude
	local fireoffset, rand, delayCheck = CFrame.identity, Random.new(), tick()
	local old

	local function getTarget(origin, limit, attackcheck)
		if rand.NextNumber(rand, 0, 100) > (AutoFire.Enabled and 100 or HitChance.Value) then return end
		local targetPart = (rand.NextNumber(rand, 0, 100) < (AutoFire.Enabled and 100 or HeadshotChance.Value)) and 'Head' or 'RootPart'
		local ent = entitylib['Entity'..Mode.Value]({
			Range = Mode.Value == 'Position' and math.min(Range.Value, limit) or Range.Value,
			RangePosition = limit,
			AttackCheck = attackcheck,
			Wallcheck = Target.Walls.Enabled and true or nil,
			Wallbang = Wallbang.Enabled and entitylib.character.RootPart.Position or nil,
			Part = targetPart,
			Origin = origin,
			Players = Target.Players.Enabled,
			NPCs = Target.NPCs.Enabled
		})

		if ent then
			targetinfo.Targets[ent] = tick() + 1
		end

		return ent, ent and ent[targetPart], origin
	end

	local function Hook(...)
		local origin, direction = ...
		local gundata = debug.getupvalue(oldshoot or pl.Shoot, 10)
		local ent, targetPart, origin = getTarget(origin, gundata and gundata.Range or 1000, not gundata or gundata.Behavior ~= 'Taser')

		if not ent then return old(...) end

		local args = table.pack(...)
		args[2] = targetPart.Position
		aimTimer = os.clock() + 0.3
		aimVec = args[2]

		if Wallbang.Enabled then
			local ignore = {lplr.Character}
			for _, v in entitylib.List do
				table.insert(ignore, v.Character)
			end
			rayParams.FilterDescendantsInstances = ignore
			local ray = workspace:Raycast(args[2], (origin - args[2]), rayParams)

			if ray then
				local neworigin, hitbox = OriginScanner:Scan(entitylib.character.RootPart.Position, args[2], ray.Position + ray.Normal * 0.01, targetPart)

				if neworigin then
					for i, v in debug.getstack(3) do
						if v == origin then
							debug.setstack(3, i, neworigin)
						end
					end

					args[1] = neworigin
					if hitbox then
						return targetPart, hitbox
					end
				end
			end
		end

		return old(unpack(args, 1, args.n))
	end

	SilentAim = vape.Categories.Combat:CreateModule({
		Name = 'SilentAim',
		Function = function(callback)
			if CircleObject then
				CircleObject.Visible = callback and Mode.Value == 'Mouse'
			end

			if callback then
				old = hookfunction(pl.Bullet, function(...)
					return Hook(...)
				end)

				local autofiretimer = os.clock()
				repeat
					if CircleObject then
						CircleObject.Position = inputService:GetMouseLocation()
					end

					if AutoFire.Enabled and autofiretimer < os.clock() then
						autofiretimer = os.clock() + (1 / AutoFireRate.Value)

						local tool = lplr.Character:FindFirstChildWhichIsA('Tool')
						local gundata = debug.getupvalue(oldshoot or pl.Shoot, 10)
						local ammo = tool and tool:GetAttribute('Local_CurrentAmmo') or 0
						if gundata and ammo > 0 and not tool:GetAttribute('Local_IsShooting') then
							local limit = gundata.Range or 1000
							local taser = gundata and gundata.Behavior == 'Taser'
							local ent = entitylib['Entity'..Mode.Value]({
								Range = Mode.Value == 'Position' and math.min(Range.Value, limit) or Range.Value,
								RangePosition = limit,
								AttackCheck = not taser,
								Wallcheck = Target.Walls.Enabled and true or nil,
								Wallbang = Wallbang.Enabled and entitylib.isAlive and entitylib.character.RootPart.Position or nil,
								Part = 'Head',
								Origin = entitylib.isAlive and entitylib.character.Head.Position or Vector3.zero,
								Players = Target.Players.Enabled
							})

							if ent and entitylib.character.Humanoid.Health > 0 then
								if not ((taser or AutoFireTaser.Enabled) and (ent.Character:GetAttribute('Tased') or ent.Character:GetAttribute('Arrested'))) then
									autofiretimer = os.clock() + (ammo > 1 and gundata.FireRate or 1 / AutoFireRate.Value)
									local obj = {UserInputState = Enum.UserInputState.Begin, UserInputType = Enum.UserInputType.MouseButton1, Position = Vector3.zero}
									task.spawn(pl.Shoot, obj)
									obj.UserInputState = Enum.UserInputState.End
								end
							end
						end
					end

					task.wait()
				until not SilentAim.Enabled
			else
				if old then
					if restorefunction then
						restorefunction(pl.Bullet)
					else
						hookfunction(pl.Bullet, old)
					end
					old = nil
				end
			end
		end,
		ExtraText = function()
			return 'PrisonLife'
		end,
		Tooltip = 'Silently adjusts your aim towards the enemy'
	})
	Target = SilentAim:CreateTargets({Players = true})
	Mode = SilentAim:CreateDropdown({
		Name = 'Mode',
		List = {'Mouse', 'Position'},
		Function = function(val)
			if CircleObject then
				CircleObject.Visible = SilentAim.Enabled and val == 'Mouse'
			end
		end,
		Tooltip = 'Mouse - Checks for entities near the mouses position\nPosition - Checks for entities near the local character'
	})
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
	HeadshotChance = SilentAim:CreateSlider({
		Name = 'Headshot Chance',
		Min = 0,
		Max = 100,
		Default = 65,
		Suffix = '%'
	})
	AutoFire = SilentAim:CreateToggle({
		Name = 'AutoFire',
		Function = function(callback)
			AutoFireRate.Object.Visible = callback
			AutoFireTaser.Object.Visible = callback
		end
	})
	AutoFireRate = SilentAim:CreateSlider({
		Name = 'Update rate',
		Min = 1,
		Max = 120,
		Default = 60,
		Visible = false,
		Darker = true,
		Suffix = 'hz'
	})
	AutoFireTaser = SilentAim:CreateToggle({
		Name = 'Ignore Tased',
		Visible = false,
		Darker = true
	})
	Wallbang = SilentAim:CreateToggle({Name = 'Wallbang'})
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
				CircleObject.Visible = SilentAim.Enabled and Mode.Value == 'Mouse'
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
	local AntiInvisible
	local threads = {}
	local whitelist = {
		-- default roblox animations
		['http://www.roblox.com/asset/?id=125750702'] = true,
		['http://www.roblox.com/asset/?id=128777973'] = true,
		['http://www.roblox.com/asset/?id=128853357'] = true,
		['http://www.roblox.com/asset/?id=129423030'] = true,
		['http://www.roblox.com/asset/?id=129423131'] = true,
		['http://www.roblox.com/asset/?id=129967390'] = true,
		['http://www.roblox.com/asset/?id=129967478'] = true,
		['http://www.roblox.com/asset/?id=178130996'] = true,
		['http://www.roblox.com/asset/?id=180426354'] = true,
		['http://www.roblox.com/asset/?id=180435571'] = true,
		['http://www.roblox.com/asset/?id=180435792'] = true,
		['http://www.roblox.com/asset/?id=180436148'] = true,
		['http://www.roblox.com/asset/?id=180436334'] = true,
		['http://www.roblox.com/asset/?id=182393478'] = true,
		['http://www.roblox.com/asset/?id=182435998'] = true,
		['http://www.roblox.com/asset/?id=182436842'] = true,
		['http://www.roblox.com/asset/?id=182436935'] = true,
		['http://www.roblox.com/asset/?id=182491037'] = true,
		['http://www.roblox.com/asset/?id=182491065'] = true,
		['http://www.roblox.com/asset/?id=182491248'] = true,
		['http://www.roblox.com/asset/?id=182491277'] = true,
		['http://www.roblox.com/asset/?id=182491368'] = true,
		['http://www.roblox.com/asset/?id=182491423'] = true,
		-- game animations
		['rbxassetid://279227693'] = true,
		['rbxassetid://279229192'] = true,
		['rbxassetid://287112271'] = true,
		['rbxassetid://388723916'] = true,
		['rbxassetid://388726667'] = true,
		['rbxassetid://389472570'] = true,
		['rbxassetid://405194080'] = true,
		['rbxassetid://405212265'] = true,
		['rbxassetid://481088553'] = true,
		['rbxassetid://481089053'] = true,
		['rbxassetid://484200742'] = true,
		['rbxassetid://484926359'] = true,
		['rbxassetid://83690472549256'] = true,
		['rbxassetid://107176344504758'] = true,
		['rbxassetid://111090572475133'] = true,
		['rbxassetid://113267949064300'] = true,
		['rbxassetid://131326339350805'] = true
	}
	
	local function AnimationAdded(anim, plr)
		if not whitelist[anim.Animation.AnimationId] and plr then
			if threads[anim] then
				task.cancel(threads[anim])
			end
	
			CheatFlags:Flag(plr, 'invalid animation', 1)
			threads[anim] = task.spawn(function()
				repeat
					anim:AdjustWeight(0, 0)
					task.wait()
				until not (anim.IsPlaying and AntiInvisible.Enabled)
	
				threads[anim] = nil
			end)
		end
	end
	
	local function EntityAdded(ent)
		local animator = ent.Humanoid:WaitForChild('Animator', 5)
	
		if animator and AntiInvisible.Enabled then
			AntiInvisible:Clean(animator.AnimationPlayed:Connect(function(anim)
				AnimationAdded(anim, ent.Player)
			end))
	
			for _, anim in animator:GetPlayingAnimationTracks() do
				task.spawn(AnimationAdded, anim, ent.Player)
			end
		end
	end
	
	for _, v in replicatedStorage:QueryDescendants('Animation') do
		whitelist[v.AnimationId] = true
	end
	
	AntiInvisible = vape.Categories.Blatant:CreateModule({
		Name = 'AntiInvisible',
		Function = function(callback)
			if callback then
				AntiInvisible:Clean(entitylib.Events.EntityAdded:Connect(EntityAdded))
				for _, v in entitylib.List do
					task.spawn(EntityAdded, v)
				end
			else
				for _, v in threads do
					task.cancel(v)
				end
				table.clear(threads)
			end
		end,
		Tooltip = 'Prevent people from using invisible animations'
	})
end)
	
run(function()
	local AntiKillPlane
	
	AntiKillPlane = vape.Categories.Blatant:CreateModule({
		Name = 'AntiKillPlane',
		Function = function(callback)
			if callback then
				for x = -2048, 2048, 2048 do
					for z = -2048, 2048, 2048 do
						local part = Instance.new('Part')
						part.CanQuery = false
						part.CanCollide = true
						part.Anchored = true
						part.Transparency = 1
						part.Size = Vector3.new(2048, 10, 2048)
						part.Position = Vector3.new(x, 170, z)
						part.Parent = workspace
						AntiKillPlane:Clean(part)
					end
				end
			end
		end,
		Tooltip = 'Add\'s a phyiscal part for the kill plane'
	})
end)
	
run(function()
	local AntiRiotShield
	
	AntiRiotShield = vape.Categories.Blatant:CreateModule({
		Name = 'AntiRiotShield',
		Function = function(callback)
			if callback then
				repeat
					for _, ent in entitylib.List do
						local shield = ent.Character:FindFirstChild('RiotShieldPart')
						if shield then
							shield.CanQuery = false
						end
					end
	
					task.wait(0.05)
				until not AntiRiotShield.Enabled
			else
				for _, ent in entitylib.List do
					local shield = ent.Character:FindFirstChild('RiotShieldPart')
					if shield then
						shield.CanQuery = true
					end
				end
			end
		end,
		Tooltip = 'Allow you to shoot through riot shields.'
	})
end)
	
run(function()
	local AntiTaze
	local old, connection
	
	local function EntityAdded(ent)
		connection = getconnections(replicatedStorage.GunRemotes.PlayerTased.OnClientEvent)[1]
		if not (connection and connection.Function) then
			repeat
				connection = getconnections(replicatedStorage.GunRemotes.PlayerTased.OnClientEvent)[1]
				task.wait()
			until connection and connection.Function or not AntiTaze.Enabled
		end
	
		if connection and AntiTaze.Enabled then
			old = hookfunction(connection.Function, function()
				local char = lplr.Character
				lplr:SetAttribute('BackpackEnabled', false)
				if entitylib.isAlive then
					entitylib.character.Humanoid:UnequipTools()
				end
	
				task.wait(3.5)
				if lplr.Character == char then
					lplr:SetAttribute('BackpackEnabled', true)
				end
			end)
		end
	end
	
	AntiTaze = vape.Categories.Blatant:CreateModule({
		Name = 'AntiTaze',
		Function = function(callback)
			if callback then
				AntiTaze:Clean(entitylib.Events.LocalAdded:Connect(EntityAdded))
				if entitylib.isAlive then
					task.spawn(EntityAdded, entitylib.character)
				end
			else
				if old and connection.Function then
					hookfunction(connection.Function, old)
					old = nil
				end
			end
		end,
		Tooltip = 'Prevent you from getting tazed'
	})
end)
	
run(function()
	local AutoArrest
	local Range
	local HandCheck
	local CooldownBar
	local toggles = {}
	local cdholder, cdframe, cdlabel
	
	AutoArrest = vape.Categories.Blatant:CreateModule({
		Name = 'AutoArrest',
		Function = function(callback)
			if callback then
				repeat
					local check = arrestCooldown < os.clock()
					if HandCheck.Enabled then
						local tool = entitylib.isAlive and lplr.Character:FindFirstChildWhichIsA('Tool')
						check = check and tool and tool.Name == 'Handcuffs'
					end
	
					if check then
						local entities = entitylib.AllPosition({
							Range = Range.Value,
							Players = true,
							Part = 'RootPart',
							TargetCheck = true
						})
	
						for _, ent in entities do
							if not ent.Character:GetAttribute('Arrested') then
								local toggle = ent.Player.Team and toggles[ent.Player.Team.Name]
								if toggle and not toggle.Enabled then
									continue
								end
	
								if ent.Player.Team == teams.Inmates and ent.Character:GetAttribute('Hostile') and not ent.Character:GetAttribute('Tased') then
									continue
								end
	
								if replicatedStorage.Remotes.ArrestPlayer:InvokeServer(ent.Player, 1) then
									arrestCooldown = os.clock() + 7
									vapeEvents.Arrested:Fire()
									notif('AutoArrest', 'Arrested '..(ent.Player.Name), 7)
								end
	
								break
							end
						end
					end
	
					if cdholder then
						cdholder.Visible = arrestCooldown > os.clock()
	
						if cdholder.Visible then
							local diff = (arrestCooldown - os.clock())
							cdframe.Size = UDim2.new(math.clamp(diff / 7, 0, 1), -2, 1, -2)
							cdlabel.Text = (math.round(diff * 10) / 10)..'s'
						end
					end
	
					task.wait(0.05)
				until not AutoArrest.Enabled
			else
				if cdholder then
					cdholder.Visible = false
				end
			end
		end,
		Tooltip = 'Automatically uses handcuffs on nearby entities'
	})
	Range = AutoArrest:CreateSlider({
		Name = 'Range',
		Min = 1,
		Max = 8,
		Default = 8,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end
	})
	HandCheck = AutoArrest:CreateToggle({
		Name = 'Hand Check',
		Tooltip = 'Only arrest if you have handcuffs equipped.'
	})
	CooldownBar = AutoArrest:CreateToggle({
		Name = 'Cooldown Bar',
		Function = function(callback)
			if callback then
				cdholder = Instance.new('Frame')
				cdholder.Visible = false
				cdholder.BorderSizePixel = 0
				cdholder.BackgroundTransparency = 0.7
				cdholder.AnchorPoint = Vector2.new(0.5, 0)
				cdholder.BackgroundColor3 = Color3.new(1, 1, 1)
				cdholder.Size = UDim2.new(0.1, 0, 0, 5)
				cdholder.Position = UDim2.fromScale(0.5, 0.55)
				cdholder.Parent = vape.gui
				cdframe = Instance.new('Frame')
				cdframe.BorderSizePixel = 0
				cdframe.BackgroundTransparency = 0.3
				cdframe.BackgroundColor3 = Color3.new(1, 1, 1)
				cdframe.Size = UDim2.new(1, -2, 1, -2)
				cdframe.Position = UDim2.fromOffset(1, 1)
				cdframe.Parent = cdholder
				cdlabel = Instance.new('TextLabel')
				cdlabel.Size = UDim2.new(1, 0, 0, 14)
				cdlabel.Position = UDim2.fromOffset(0, 10)
				cdlabel.BackgroundTransparency = 1
				cdlabel.TextColor3 = Color3.new(1, 1, 1)
				cdlabel.TextScaled = true
				cdlabel.TextStrokeTransparency = 0
				cdlabel.Font = Enum.Font.Arial
				cdlabel.Parent = cdholder
			else
				if cdframe then
					cdframe:Destroy()
					cdframe = nil
				end
			end
		end,
		Tooltip = 'Show the cooldown for arresting'
	})
	
	for _, v in {'Inmates', 'Criminals'} do
		toggles[v] = AutoArrest:CreateToggle({
			Name = 'Arrest '..v,
			Default = true
		})
	end
end)
	
run(function()
	local AutoReset
	
	AutoReset = vape.Categories.Blatant:CreateModule({
		Name = 'AutoReset',
		Function = function(callback)
			if callback then
				AutoReset:Clean(lplr:GetPropertyChangedSignal('Team'):Connect(function()
					if lplr.Team == teams.Criminals and entitylib.isAlive then
						entitylib.character.Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
					end
				end))
			end
		end,
		Tooltip = 'Automatically reset after becoming a criminal.'
	})
end)
	
run(function()
	local AutoTaser
	local Range
	local VelocityCheck
	local cooldown = 0
	
	AutoTaser = vape.Categories.Blatant:CreateModule({
		Name = 'AutoTaser',
		Function = function(callback)
			if callback then
				repeat
					local backpack = lplr:FindFirstChildWhichIsA('Backpack')
					local taser = backpack and backpack:FindFirstChild('Taser')
	
					if taser and (taser:GetAttribute('CurrentAmmo') or 1) > 0 and cooldown < os.clock() and (arrestCooldown - os.clock()) < 3 then
						if not VelocityCheck.Enabled or entitylib.isAlive and entitylib.character.RootPart.AssemblyLinearVelocity.Magnitude < 40 then
							local entities = entitylib.AllPosition({
								Range = Range.Value,
								AttackCheck = false,
								Wallcheck = true,
								Part = 'Head',
								Origin = entitylib.isAlive and entitylib.character.Head.Position or Vector3.zero,
								Players = true
							})
	
							for _, ent in entities do 
								if not (ent.Character:GetAttribute('Tased') or ent.Character:GetAttribute('Arrested')) then
									cooldown = os.clock() + 2
									local equipped = lplr.Character:FindFirstChildWhichIsA('Tool')
									if equipped then 
										equipped.Parent = backpack
									end
	
									taser.Parent = lplr.Character
									break
								end
							end
						end
					end
	
					task.wait(0.05)
				until not AutoTaser.Enabled
			end
		end,
		Tooltip = 'Only works with silentaim autofire with position mode.'
	})
	Range = AutoTaser:CreateSlider({
		Name = 'Range',
		Min = 1,
		Max = 52,
		Default = 52,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end
	})
	VelocityCheck = AutoTaser:CreateToggle({
		Name = 'Velocity Check',
		Default = true
	})
end)
	
run(function()
	local GunModifications
	local Spread
	local FireRate
	local Automatic
	local olddata, old = {}
	local oldhook
	
	local function Modify()
		local data = debug.getupvalue(oldshoot or pl.Shoot, 10)
		if data and GunModifications.Enabled then
			if old ~= data then
				olddata = table.clone(data)
				old = data
			end
	
			data.SpreadRadius = Spread.Enabled and 0 or olddata.SpreadRadius
			data.FireRate = (olddata.FireRate or 0) * (FireRate.Value / 100)
			data.AutoFire = Automatic.Enabled or olddata.AutoFire
		end
	end
	
	
	GunModifications = vape.Categories.Blatant:CreateModule({
		Name = 'GunModifications',
		Function = function(callback)
			if callback then
				oldequip = hookfunction(pl.Equip, function(...)
					local res = table.pack(oldequip(...))
					Modify()
					return unpack(res, 1, res.n)
				end)
	
				Modify()
			else
				if oldequip then
					if restorefunction then
						restorefunction(pl.Equip)
					else
						oldequip = nil
					end
				end
	
				if old then
					for i, v in olddata do
						old[i] = v
					end
					table.clear(olddata)
					old = nil
				end
			end
		end,
		Tooltip = 'Modifications to empower the firearm'
	})
	FireRate = GunModifications:CreateSlider({
		Name = 'FireRate Multiplier',
		Min = 1,
		Max = 100,
		Default = 100,
		Suffix = '%',
		Function = Modify
	})
	Spread = GunModifications:CreateToggle({
		Name = 'No Spread',
		Function = Modify
	})
	Automatic = GunModifications:CreateToggle({
		Name = 'Full Automatic',
		Function = Modify
	})
end)
	
run(function()
	local Killaura
	local Targets
	local AttackRange
	local AngleSlider
	local Max
	local Mouse
	local BoxSwingColor
	local BoxAttackColor
	local ParticleTexture
	local ParticleColor1
	local ParticleColor2
	local ParticleSize
	local Face
	local Overlay = OverlapParams.new()
	Overlay.FilterType = Enum.RaycastFilterType.Include
	local Particles, Boxes, AttackDelay = {}, {}, tick()
	
	local function getAttackData()
		if Mouse.Enabled then
			if not inputService:IsMouseButtonPressed(0) then return false end
		end
	
		return true
	end
	
	Killaura = vape.Categories.Blatant:CreateModule({
		Name = 'Killaura',
		Function = function(callback)
			if callback then
				repeat
					local canAttack = getAttackData()
					local attacked = {}
					if canAttack then
						local plrs = entitylib.AllPosition({
							Range = AttackRange.Value,
							Wallcheck = Targets.Walls.Enabled or nil,
							Part = 'RootPart',
							Players = Targets.Players.Enabled,
							NPCs = Targets.NPCs.Enabled,
							Limit = Max.Value,
							AttackCheck = true
						})
	
						if #plrs > 0 then
							local selfpos = entitylib.character.RootPart.Position
							local localfacing = entitylib.character.RootPart.CFrame.LookVector * Vector3.new(1, 0, 1)
	
							for _, v in plrs do
								local delta = (v.RootPart.Position - selfpos)
								local angle = math.acos(localfacing:Dot((delta * Vector3.new(1, 0, 1)).Unit))
								if angle > (math.rad(AngleSlider.Value) / 2) then continue end
								if lplr.Team == teams.Guards and v.Player.Team == teams.Inmates and not v.Character:GetAttribute('Hostile') then
									continue
								end
	
								table.insert(attacked, {
									Entity = v,
									Check = BoxAttackColor
								})
								targetinfo.Targets[v] = tick() + 1
								replicatedStorage.meleeEvent:FireServer(v.Player, 1, 1)
							end
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
	
					if Face.Enabled and attacked[1] then
						local vec = attacked[1].Entity.RootPart.Position * Vector3.new(1, 0, 1)
						entitylib.character.RootPart.CFrame = CFrame.lookAt(entitylib.character.RootPart.Position, Vector3.new(vec.X, entitylib.character.RootPart.Position.Y + 0.01, vec.Z))
					end
	
					task.wait(0.05)
				until not Killaura.Enabled
			else
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
		Max = 12,
		Default = 12,
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
	Max = Killaura:CreateSlider({
		Name = 'Max targets',
		Min = 1,
		Max = 10,
		Default = 10
	})
	Mouse = Killaura:CreateToggle({Name = 'Require mouse down'})
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
	Face = Killaura:CreateToggle({Name = 'Face target'})
end)
	
run(function()
	local NoJumpCooldown
	local old
	
	local function EntityAdded(ent)
		old = getconnections(ent.Humanoid:GetPropertyChangedSignal('Jump'))[1]
		if not old then
			repeat
				old = getconnections(ent.Humanoid:GetPropertyChangedSignal('Jump'))[1]
				task.wait()
			until old or not NoJumpCooldown.Enabled
	
			if not NoJumpCooldown.Enabled then
				return
			end
		end
	
		if old then
			old:Disable()
		end
	end
	
	NoJumpCooldown = vape.Categories.Blatant:CreateModule({
		Name = 'NoJumpCooldown',
		Function = function(callback)
			if callback then
				NoJumpCooldown:Clean(entitylib.Events.LocalAdded:Connect(EntityAdded))
				if entitylib.isAlive then
					task.spawn(EntityAdded, entitylib.character)
				end
			else
				if old then
					old:Enable()
					old = nil
				end
			end
		end,
		Tooltip = 'Remove the cooldown from jumping'
	})
end)
	
run(function()
	local VehicleFly
	local Mode
	local Speed
	local welds = {}
	local up, down = 0, 0
	
	VehicleFly = vape.Categories.Blatant:CreateModule({
		Name = 'VehicleFly',
		Function = function(callback)
			if callback then
				up, down = 0, 0
				for _, v in {'InputBegan', 'InputEnded'} do
					VehicleFly:Clean(inputService[v]:Connect(function(input)
						if not inputService:GetFocusedTextBox() then
							if input.KeyCode == Enum.KeyCode.E then
								up = v == 'InputBegan' and 1 or 0
							elseif input.KeyCode == Enum.KeyCode.Q then
								down = v == 'InputBegan' and -1 or 0
							end
						end
					end))
				end
	
				if Mode.Value == 'Part' then
					local part = Instance.new('Part')
					part.Size = Vector3.new(50, 1, 50)
					part.Anchored = true
					part.CanQuery = false
					part.Transparency = 1
	
					VehicleFly:Clean(part)
					repeat
						local seat = entitylib.isAlive and entitylib.character.Humanoid.SeatPart
						if seat then
							part.CFrame = CFrame.new(seat.Position - Vector3.new(0, 2.2 - (up + down), 0))
							part.Parent = workspace
						else
							part.Parent = nil
						end
	
						task.wait(0.05)
					until not VehicleFly.Enabled
				else
					local inCar = false
					local old
					VehicleFly:Clean(runService.PreSimulation:Connect(function(dt)
						local seat = entitylib.isAlive and entitylib.character.Humanoid.SeatPart
						local root = seat and entitylib.character.RootPart
	
						if root then
							if seat ~= old then
								inCar = seat:IsDescendantOf(workspace.CarContainer) and seat:IsA('VehicleSeat')
								if inCar then
									welds = seat.Parent.Parent.Wheels:QueryDescendants('Rotate')
									for _, v in welds do
										v.Enabled = false
									end
								end
	
								old = seat
							end
	
							if inCar then
								root.AssemblyLinearVelocity = Vector3.new(0, 2.25, 0)
								root.CFrame = CFrame.lookAlong(root.Position, gameCamera.CFrame.LookVector) + (entitylib.character.Humanoid.MoveDirection + Vector3.new(0, up + down, 0)) * Speed.Value * dt
								gameCamera.CameraSubject = entitylib.character.Humanoid
							end
						elseif old then
							for _, v in welds do
								v.Enabled = true
							end
							old = nil
						end
					end))
				end
			else
				for _, v in welds do
					v.Enabled = true
				end
				table.clear(welds)
			end
		end,
		Tooltip = 'Allow you to fly with a vehicle'
	})
	Mode = VehicleFly:CreateDropdown({
		Name = 'Mode',
		List = {'CFrame', 'Part'},
		Function = function(val)
			Speed.Object.Visible = val == 'CFrame'
			if VehicleFly.Enabled then
				VehicleFly:Toggle()
				VehicleFly:Toggle()
			end
		end
	})
	Speed = VehicleFly:CreateSlider({
		Name = 'Speed',
		Min = 1,
		Max = 100,
		Default = 60,
		Darker = true
	})
end)
	
run(function()
	local VehicleSpeed
	local Speed
	local old
	local seats = {}
	
	VehicleSpeed = vape.Categories.Blatant:CreateModule({
		Name = 'VehicleSpeed',
		Function = function(callback)
			if callback then
				repeat
					local seat = entitylib.isAlive and entitylib.character.Humanoid.SeatPart
					if seat then
						if seat ~= old then
							if seat:IsDescendantOf(workspace.CarContainer) then
								seats = seat.Parent.Parent:QueryDescendants('VehicleSeat')
							end
	
							old = seat
						end
	
						for _, v in seats do
							v.MaxSpeed = Speed.Value
							v.Torque = 4
						end
					end
	
					task.wait()
				until not VehicleSpeed.Enabled
			else
				table.clear(seats)
			end
		end,
		Tooltip = 'Increase vehicle speed'
	})
	Speed = VehicleSpeed:CreateSlider({
		Name = 'Speed',
		Min = 80,
		Max = 200,
		Default = 140
	})
end)
	
run(function()
	local VehicleWallbang
	local modified = {}
	
	local function Modify(part)
		if part:IsA('BasePart') then
			if not modified[part] then
				modified[part] = part.CanQuery
			end
	
			part.CanQuery = false
		end
	end
	
	VehicleWallbang = vape.Categories.Blatant:CreateModule({
		Name = 'VehicleWallbang',
		Function = function(callback)
			if callback then
				VehicleWallbang:Clean(workspace.CarContainer.DescendantAdded:Connect(Modify))
				for _, part in workspace.CarContainer:QueryDescendants('BasePart') do
					Modify(part)
				end
			else
				for i, v in modified do
					i.CanQuery = v
				end
				table.clear(modified)
			end
		end,
		Tooltip = 'Allow you to shoot through vehicles.'
	})
end)
	
run(function()
	local C4ESP
	local FillColor
	local OutlineColor
	local FillTransparency
	local OutlineTransparency
	local Reference = {}
	local Folder = Instance.new('Folder')
	Folder.Parent = vape.gui
	
	local function Added(obj)
		local cham = Instance.new('Highlight')
		cham.Adornee = obj
		cham.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		cham.FillColor = Color3.fromHSV(FillColor.Hue, FillColor.Sat, FillColor.Value)
		cham.OutlineColor = Color3.fromHSV(OutlineColor.Hue, OutlineColor.Sat, OutlineColor.Value)
		cham.FillTransparency = FillTransparency.Value
		cham.OutlineTransparency = OutlineTransparency.Value
		cham.Parent = Folder
	
		Reference[obj] = cham
	end
	
	local function Removed(obj)
		if Reference[obj] then
			if vape.ThreadFix then
				setthreadidentity(8)
			end
	
			Reference[obj]:Destroy()
			Reference[obj] = nil
		end
	end
	
	C4ESP = vape.Categories.Render:CreateModule({
		Name = 'C4ESP',
		Function = function(callback)
			if callback then
				C4ESP:Clean(collectionService:GetInstanceAddedSignal('C4'):Connect(Added))
				C4ESP:Clean(collectionService:GetInstanceRemovedSignal('C4'):Connect(Removed))
	
				for _, obj in collectionService:GetTagged('C4') do
					task.spawn(Added, obj)
				end
			else
				for _, v in Reference do
					v:Destroy()
				end
				table.clear(Reference)
			end
		end,
		Tooltip = 'Display all C4\'s placed'
	})
	FillColor = C4ESP:CreateColorSlider({
		Name = 'Color',
		Function = function(hue, sat, val)
			for _, v in Reference do
				v.FillColor = Color3.fromHSV(hue, sat, val)
			end
		end
	})
	OutlineColor = C4ESP:CreateColorSlider({
		Name = 'Outline Color',
		DefaultSat = 0,
		Function = function(hue, sat, val)
			for _, v in Reference do
				v.OutlineColor = Color3.fromHSV(hue, sat, val)
			end
		end
	})
	FillTransparency = C4ESP:CreateSlider({
		Name = 'Transparency',
		Min = 0,
		Max = 1,
		Default = 0.5,
		Function = function(val)
			for _, v in Reference do
				v.FillTransparency = val
			end
		end,
		Decimal = 10
	})
	OutlineTransparency = C4ESP:CreateSlider({
		Name = 'Outline Transparency',
		Min = 0,
		Max = 1,
		Default = 0.5,
		Function = function(val)
			for _, v in Reference do
				v.OutlineTransparency = val
			end
		end,
		Decimal = 10
	})
end)
	
run(function()
	local CameraPhase
	local old
	
	CameraPhase = vape.Categories.Render:CreateModule({
		Name = 'CameraPhase',
		Function = function(callback)
			if callback then
				local req = require(lplr.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper)
				old = debug.getupvalue(debug.getupvalue(req, 3), 7)
				debug.setconstant(old, 16, 0)
			else
				if old then
					debug.setconstant(old, 16, 0.25)
					old = nil
				end
			end
		end,
		Tooltip = 'Allow the camera to phase through walls.'
	})
end)
	
run(function()
	local KillNotifications
	
	KillNotifications = vape.Categories.Render:CreateModule({
		Name = 'KillNotifications',
		Function = function(callback)
			if callback then
				KillNotifications:Clean(vapeEvents.PlayerKill.Event:Connect(function(killer, victim)
					if victim == lplr.Name and killer ~= lplr.Name then
						notif('KillNotifications', killer..' killed you!', 5)
					end
				end))
			end
		end,
		Tooltip = 'Sends a notification of who killed you.'
	})
end)
	
run(function()
	local AutoDetonate
	local SafeCheck
	local localc4
	local ticks = 0
	local rayParams = RaycastParams.new()
	rayParams.CollisionGroup = 'ClientBullet'
	rayParams.FilterType = Enum.RaycastFilterType.Exclude
	
	AutoDetonate = vape.Categories.Utility:CreateModule({
		Name = 'AutoDetonate',
		Function = function(callback)
			if callback then
				AutoDetonate:Clean(collectionService:GetInstanceAddedSignal('C4'):Connect(function(obj)
					if obj:GetAttribute('UserId') == lplr.UserId then
						localc4 = obj
					end
				end))
	
				for _, obj in collectionService:GetTagged('C4') do
					if obj:GetAttribute('UserId') == lplr.UserId then
						localc4 = obj
					end
				end
	
				repeat
					local backpack = lplr:FindFirstChildWhichIsA('Backpack')
	
					if backpack and localc4 then
						local tool = backpack:FindFirstChild('C4 Explosive')
	
						if tool then
							local ent = entitylib.EntityPosition({
								Players = true,
								Part = 'RootPart',
								Range = 25,
								Origin = localc4.Position
							})
	
							if ent then
								rayParams.FilterDescendantsInstances = {ent.Character, lplr.Character, localc4}
	
								local rootdiff = (entitylib.character.RootPart.Position - localc4.Position)
								local ray = workspace:Raycast(localc4.Position, (ent.RootPart.Position - localc4.Position), rayParams)
								if SafeCheck.Enabled and not ray then
									ray = not (workspace:Raycast(localc4.Position, rootdiff, rayParams) or rootdiff.Magnitude > 40)
								end
	
								if not ray then
									ticks += 1
									if ticks > 3 then
										local equipped = lplr.Character:FindFirstChildWhichIsA('Tool')
										if equipped then
											equipped.Parent = backpack
										end
	
										tool.Parent = lplr.Character
										task.spawn(function()
											replicatedStorage.Remotes.C4.ActivateC4:InvokeServer()
										end)
										tool.Parent = backpack
	
										if equipped then
											equipped.Parent = lplr.Character
										end
									end
	
									task.wait(0.05)
									continue
								end
							end
						end
					end
	
					ticks = 0
					task.wait(0.05)
				until not AutoDetonate.Enabled
			end
		end,
		Tooltip = 'Automatically detonate when enemies are nearby.'
	})
	SafeCheck = AutoDetonate:CreateToggle({
		Name = 'Safety Check'
	})
end)
	
run(function()
	local AutoReload
	local HotSwap
	local thread, oldplaysound
	local priority = {
		M4A1 = 1,
		['AK-47'] = 1,
		MP5 = 1,
		FAL = 1,
		['Remington 870'] = 2,
		M9 = 3,
		Revolver = 4
	}
	
	local function getWeapon()
		local items = {}
		local backpack = lplr:FindFirstChildWhichIsA('Backpack')
		if backpack then
			for _, tool in backpack:GetChildren() do
				if tool:GetAttribute('FireRate') and (tool:GetAttribute('Local_ReloadSession') or 0) <= 0 and tool.Name ~= 'Taser' and tool.Name ~= 'M700' then
					table.insert(items, tool)
				end
			end
	
			table.sort(items, function(a, b)
				return (priority[a.Name] or 100) < (priority[b.Name] or 100)
			end)
	
			return items[1]
		end
	end
	
	AutoReload = vape.Categories.Utility:CreateModule({
		Name = 'AutoReload',
		Function = function(callback)
			if callback then
				TracerHook:Add('AutoReload', function(...)
					if thread then
						return
					end
	
					thread = task.defer(function()
						thread = nil
	
						local tool = debug.getupvalue(pl.Shoot, 1)
						if tool and tool:GetAttribute('Local_CurrentAmmo') <= 0 then
							task.spawn(pl.Reload)
	
							if HotSwap.Enabled then
								local wep = getWeapon()
	
								if wep then
									tool.Parent = lplr.Backpack
									wep.Parent = lplr.Character
								end
							end
						end
					end)
				end)
	
				-- reimplementation of playsound to get rid of the bad error
				oldplaysound = hookfunction(pl.PlaySound, function(sound)
					local soundobj = debug.getupvalue(pl.Shoot, 1)
					soundobj = soundobj and soundobj:FindFirstChild('Handle')
					soundobj = soundobj and soundobj:FindFirstChild(sound)
	
					if soundobj then
						local clone = soundobj:Clone()
						clone.Parent = soundobj.Parent
						clone:Play()
						task.delay(5, clone.Destroy, clone)
					end
				end)
			else
				TracerHook:Remove('AutoReload')
				if oldplaysound then
					if restorefunction then
						restorefunction(pl.PlaySound)
					else
						hookfunction(pl.PlaySound, oldplaysound)
					end
					oldplaysound = nil
				end
			end
		end,
		Tooltip = 'Automatically reload after reaching 0 bullets'
	})
	HotSwap = AutoReload:CreateToggle({
		Name = 'Auto Swap',
		Tooltip = 'Automatically swap weapons when reloading'
	})
end)
	
run(function()
	local AutoToxic
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
				AutoToxic:Clean(vapeEvents.CheaterKicked.Event:Connect(function(plr)
					sendMessage('Kicked', plr, 'skill issue cheat | <obj>')
				end))
			end
		end,
		Tooltip = 'Says a message after a certain action'
	})
	for _, v in {'Kicked'} do
		Toggles[v] = AutoToxic:CreateToggle({
			Name = v..' ',
			Function = function(callback)
				if Lists[v] then
					Lists[v].Object.Visible = callback
				end
			end,
			Default = true
		})
		Lists[v] = AutoToxic:CreateTextList({
			Name = v,
			Darker = true,
			Visible = false
		})
	end
end)
	
run(function()
	local CheatDetector
	local AddTarget
	local overlap = OverlapParams.new()
	overlap.CollisionGroup = 'Players'
	overlap.FilterDescendantsInstances = {workspace.CarContainer, workspace.Doors}
	overlap.FilterType = Enum.RaycastFilterType.Exclude
	local caroverlap = OverlapParams.new()
	caroverlap.FilterDescendantsInstances = {workspace.CarContainer}
	caroverlap.FilterType = Enum.RaycastFilterType.Include
	caroverlap.MaxParts = 1
	
	local whiteliststates = {
		[Enum.HumanoidStateType.Running] = true,
		[Enum.HumanoidStateType.Jumping] = true,
		[Enum.HumanoidStateType.Freefall] = true,
		[Enum.HumanoidStateType.Landed] = true,
		[Enum.HumanoidStateType.FallingDown] = true,
		[Enum.HumanoidStateType.GettingUp] = true,
		[Enum.HumanoidStateType.Climbing] = true,
		[Enum.HumanoidStateType.Seated] = true,
		[Enum.HumanoidStateType.Ragdoll] = true,
		[Enum.HumanoidStateType.Dead] = true,
		[Enum.HumanoidStateType.None] = true
	}
	
	CheatDetector = vape.Categories.Utility:CreateModule({
		Name = 'CheatDetector',
		Function = function(callback)
			if callback then
				CheatDetector:Clean(vapeEvents.CheatFlagged.Event:Connect(function(plr, flagname)
					notif('CheatDetector', 'This player may be cheating! ('..flagname..'): '..plr.Name, 60, 'warning')
					if AddTarget.Enabled then
						tempTargets[plr.Name] = true
					end
	
					local ent = entitylib.getEntity(plr)
					if ent then
						entitylib.Events.EntityUpdated:Fire(ent)
						if AddTarget.Enabled then
							ent.Target = true
						end
					end
				end))
	
				repeat
					for _, ent in entitylib.List do
						if ent.Health > 0 and ent.Player then
							if not checkPoint(ent.Head.Position, overlap) then
								CheatFlags:Flag(ent.Player, 'phase/noclip', 20)
							end
	
							if not whiteliststates[ent.Humanoid:GetState()] then
								CheatFlags:Flag(ent.Player, 'invalid state '..ent.Humanoid:GetState().Name, 1)
							end
	
							local velo = ent.RootPart.AssemblyLinearVelocity
							if not ent.Humanoid.SeatPart then
								if (velo * Vector3.new(1, 0, 1)).Magnitude > 26 then
									if #workspace:GetPartBoundsInRadius(ent.RootPart.Position, 30, caroverlap) <= 0 then
										CheatFlags:Flag(ent.Player, 'speed', 20)
									end
								end
	
								if velo.Y > 50 then
									CheatFlags:Flag(ent.Player, 'highjump', 20)
								end
							end
						end
					end
	
					task.wait(0.05)
				until not CheatDetector.Enabled
			else
				CheatFlags:Clear()
			end
		end,
		Tooltip = 'Alerts for any possible cheaters.'
	})
	AddTarget = CheatDetector:CreateToggle({
		Name = 'Temporary Target',
		Tooltip = 'Add temporary priority for cheaters.',
		Default = true
	})
end)
	
run(function()
	local Disabler
	local old
	
	local function EntityAdded(ent)
		task.defer(function()
			old = getconnections(ent.Head:GetPropertyChangedSignal('CanCollide'))[1]
			if old then
				old:Disable()
			end
		end)
	end
	
	Disabler = vape.Categories.Utility:CreateModule({
		Name = 'Disabler',
		Function = function(callback)
			if callback then
				Disabler:Clean(entitylib.Events.LocalAdded:Connect(EntityAdded))
				if entitylib.isAlive then
					task.spawn(EntityAdded, entitylib.character)
				end
			else
				if old then
					old:Enable()
					old = nil
				end
			end
		end,
		Tooltip = 'Fixes phase with Character mode.',
		ExtraText = function()
			return 'Phase'
		end
	})
end)
	
run(function()
	local AutoArmor
	local pickups = {}
	
	AutoArmor = vape.Categories.Inventory:CreateModule({
		Name = 'AutoArmor',
		Function = function(callback)
			if callback then
				pickups = workspace.Prison_ITEMS.clothes:GetChildren()
	
				AutoArmor:Clean(workspace.Prison_ITEMS.clothes.ChildAdded:Connect(function(obj)
					table.insert(pickups, obj)
				end))
	
				AutoArmor:Clean(workspace.Prison_ITEMS.clothes.ChildRemoved:Connect(function(obj)
					local index = table.find(pickups, obj)
					if index then
						table.remove(pickups, index)
					end
				end))
	
				repeat
					if entitylib.isAlive and entitylib.character.Humanoid.MaxHealth <= 100 then
						local localpos = entitylib.character.RootPart.Position
	
						for _, v in pickups do
							if (v:GetPivot().Position - localpos).Magnitude < 10 and gamepasses[v:GetAttribute('RequiredGamepass')] and AutoArmor.Enabled then
								if v.Name == 'Light Vest' and gamepasses[lplr.Team == teams.Criminals and 'Mafia' or 'Riot Police'] then
									continue
								end
	
								replicatedStorage.Remotes.InteractWithItem:InvokeServer(v:FindFirstChildWhichIsA('BasePart'))
							end
						end
					end
	
					task.wait(0.05)
				until not AutoArmor.Enabled
			else
				table.clear(pickups)
			end
		end,
		Tooltip = 'Automatically equip armor from the wall.'
	})
end)
	
run(function()
	local AutoHeal
	local healItems = {
		Breakfast = true,
		Lunch = true,
		Dinner = true
	}
	
	AutoHeal = vape.Categories.Inventory:CreateModule({
		Name = 'AutoHeal',
		Function = function(callback)
			if callback then
				repeat
					local ent = entitylib.isAlive and entitylib.character
					if ent and ent.Humanoid.Health <= 85 then
						local healTool
						local backpack = lplr:FindFirstChildWhichIsA('Backpack')
						if backpack then
							for _, v in backpack:GetChildren() do
								if healItems[v.Name] then
									healTool = v
								end
							end
	
							if healTool and (os.clock() - (healTool:GetAttribute('Client_LastConsumedAt') or 0)) >= 3 then
								local equipped = ent.Character:FindFirstChildWhichIsA('Tool')
								if equipped then
									equipped.Parent = backpack
								end
	
								healTool.Parent = ent.Character
								healTool:SetAttribute('Quantity', healTool:GetAttribute('Quantity') - 1)
								healTool:SetAttribute('Client_LastConsumedAt', os.clock())
								notif('AutoHeal', 'Quantity: '..healTool:GetAttribute('Quantity'), 3)
								replicatedStorage.Remotes.EatFood:FireServer()
								healTool.Parent = backpack
	
								if equipped then
									equipped.Parent = ent.Character
								end
							end
						end
					end
	
					task.wait(0.05)
				until not AutoHeal.Enabled
			end
		end,
		Tooltip = 'Automatically heal damage with consumables.'
	})
end)
	
run(function()
	local AutoHotbar
	local SortList = {}
	
	local function DoSorting()
		table.sort(pl.SwitchTable, function(a, b)
			return (SortList[a.Tool.name] or 999 + a.Slot) < (SortList[b.Tool.name] or 999 + b.Slot)
		end)
	
		task.spawn(pl.SwitchUpdate)
	end
	
	local function EntityAdded()
		local backpack = lplr:FindFirstChildWhichIsA('Backpack')
		if backpack then
			AutoHotbar:Clean(backpack.ChildAdded:Connect(function(tool)
				if SortList[tool.Name] then
					task.defer(DoSorting)
				end
			end))
		end
	
		DoSorting()
	end
	
	AutoHotbar = vape.Categories.Inventory:CreateModule({
		Name = 'AutoHotbar',
		Function = function(callback)
			if callback then
				AutoHotbar:Clean(entitylib.Events.LocalAdded:Connect(EntityAdded))
				if entitylib.isAlive then
					task.spawn(EntityAdded)
				end
			end
		end,
		Tooltip = 'Automatically sort hotbar entries'
	})
	AutoHotbar:CreateTextList({
		Name = 'Sort Order',
		Default = {'1/AK-47', '1/MP5', '1/M4A1', '2/Remington 870', '2/M700', '3/M9', '3/Revolver', '4/Taser'},
		Function = function(list)
			table.clear(SortList)
			for _, entry in list do
				local tab = entry:split('/')
				local ind = tonumber(tab[1])
				SortList[tab[2]] = ind or 999
			end
		end
	})
end)
	
run(function()
	local AutoPickup
	local Lists = {}
	local items = {}
	local sortedpickups = {Guard = {}, Prisoner = {}, Criminal = {}}
	
	local function AddPickup(obj)
		if obj:IsA('Model') and obj.Name ~= 'Model' and obj:GetAttribute('ToolName') then
			table.insert(items, {obj, obj.Name == 'TouchGiver'})
		end
	end
	
	AutoPickup = vape.Categories.Inventory:CreateModule({
		Name = 'AutoPickup',
		Function = function(callback)
			if callback then
				for _, obj in workspace:GetChildren() do
					task.spawn(AddPickup, obj)
				end
	
				for _, obj in workspace:QueryDescendants('Model > .TouchGiver') do
					task.spawn(AddPickup, obj)
				end
	
				AutoPickup:Clean(workspace.ChildAdded:Connect(AddPickup))
				AutoPickup:Clean(workspace.ChildRemoved:Connect(function(obj)
					for index, entry in items do
						if entry[1] == obj then
							table.remove(items, index)
							break
						end
					end
				end))
	
				repeat
					if entitylib.isAlive then
						local localpos = entitylib.character.RootPart.Position
						local backpack = lplr:FindFirstChildWhichIsA('Backpack')
	
						if backpack then
							for _, v in items do
								if v[1].PrimaryPart and (v[1].PrimaryPart.Position - localpos).Magnitude < 12 then
									local toolname = v[1]:GetAttribute('ToolName')
									if v[2] then
										local found = false
										for _, entry in sortedpickups[lplr.Team == teams.Guards and 'Guard' or (lplr.Team == teams.Criminals and 'Criminal' or 'Prisoner')] do
											if not backpack:FindFirstChild(entry) then
												found = toolname ~= entry
												break
											end
										end
	
										if found then
											continue
										end
									end
	
									if not backpack:FindFirstChild(toolname) then
										replicatedStorage.Remotes.GiverPressed:FireServer(v[1])
									end
								end
							end
						end
					end
	
					task.wait(0.05)
				until not AutoPickup.Enabled
			else
				table.clear(items)
			end
		end,
		Tooltip = 'Automatically grab item pickups'
	})
	
	for _, v in {'Prisoner', 'Guard', 'Criminal'} do
		AutoPickup:CreateTextList({
			Name = v..' Pickups',
			Default = {v == 'Criminal' and '1/AK-47' or '1/MP5', '2/Remington 870'},
			Placeholder = 'priority/item',
			Function = function(list)
				table.clear(sortedpickups[v])
				for _, entry in list do
					local tab = entry:split('/')
					local ind = tonumber(tab[1])
					sortedpickups[v][ind or 999] = tab[2]
				end
			end
		})
	end
end)
	
run(function()
	local BulletTracers
	local Material
	local Color
	local Lifetime
	local Fade
	local DrawingToggle
	local drawingobjs = {}
	
	BulletTracers = vape.Legit:CreateModule({
		Name = 'BulletTracers',
		Function = function(callback)
			if callback then
				TracerHook:Add('BulletTracers', function(...)
					local origin, dir = ...
					if vtool then
						origin = vtool.Muzzle.Position
					end
	
					local velocity = CFrame.lookAt(origin, dir).LookVector * 1000
					if DrawingToggle.Enabled then
						local obj = Drawing.new('Line')
						obj.Thickness = 2
						obj.Color = Color3.fromHSV(Color.Hue, Color.Sat, Color.Value)
						drawingobjs[obj] = {origin, origin + velocity, os.clock()}
						task.delay(Lifetime.Value, function()
							drawingobjs[obj] = nil
							obj.Visible = false
							obj:Remove()
						end)
					else
						local obj = Instance.new('Part')
						obj.Size = Vector3.new(0.1, 0.1, velocity.Magnitude)
						obj.CFrame = CFrame.lookAt(origin + (velocity / 2), origin + velocity)
						obj.CanCollide = false
						obj.CanQuery = false
						obj.Anchored = true
						obj.Material = Enum.Material[Material.Value]
						obj.Color = Color3.fromHSV(Color.Hue, Color.Sat, Color.Value)
						obj.Transparency = 1 - Color.Opacity
						obj.Parent = workspace
						if Fade.Enabled then
							local tween = tweenService:Create(obj, TweenInfo.new(Lifetime.Value), {
								Transparency = 1
							})
							tween.Completed:Connect(function()
								tween:Destroy()
							end)
							tween:Play()
						end
	
						task.delay(Lifetime.Value, obj.Destroy, obj)
					end
	
					return true
				end, 1)
	
				if DrawingToggle.Enabled then
					BulletTracers:Clean(runService.RenderStepped:Connect(function()
						for obj, data in drawingobjs do
							local from, vis = gameCamera:WorldToViewportPoint(data[1])
							local to, vis2 = gameCamera:WorldToViewportPoint(data[2])
							if vis and vis2 then
								obj.Visible = true
								obj.From = Vector2.new(from.X, from.Y)
								obj.To = Vector2.new(to.X, to.Y)
								if Fade.Enabled then
									obj.Transparency = Color.Opacity * (1 - math.clamp((os.clock() - data[3]) / Lifetime.Value, 0, 1))
								end
							else
								obj.Visible = false
							end
						end
					end))
				end
			else
				TracerHook:Remove('BulletTracers')
			end
		end,
		Tooltip = 'Allow you to customize bullet tracers.'
	})
	local materials = {'SmoothPlastic'}
	for _, v in Enum.Material:GetEnumItems() do
		if v.Name ~= 'SmoothPlastic' then
			table.insert(materials, v.Name)
		end
	end
	Material = BulletTracers:CreateDropdown({
		Name = 'Material',
		List = materials
	})
	Color = BulletTracers:CreateColorSlider({
		Name = 'Tracer Color',
		DefaultOpacity = 0.5
	})
	Lifetime = BulletTracers:CreateSlider({
		Name = 'Lifetime',
		Min = 0,
		Max = 0.5,
		Default = 0.2,
		Decimal = 10
	})
	Fade = BulletTracers:CreateToggle({
		Name = 'Fade',
		Default = true
	})
	DrawingToggle = BulletTracers:CreateToggle({
		Name = 'Drawing',
		Function = function()
			if BulletTracers.Enabled then
				BulletTracers:Toggle()
				BulletTracers:Toggle()
			end
		end
	})
end)
	
run(function()
	local Crosshair
	local Image
	local old
	
	Crosshair = vape.Legit:CreateModule({
		Name = 'Crosshair',
		Function = function(callback)
			if callback then
				debug.setconstant(oldequip or pl.Equip, 30, Image.Value:find('rbxasset') and Image.Value or isfile(Image.Value) and getcustomasset(Image.Value) or '')
			else
				debug.setconstant(oldequip or pl.Equip, 30, 'rbxassetid://98794608762931')
			end
		end,
		Tooltip = 'Change the crosshair icon'
	})
	Image = Crosshair:CreateTextBox({
		Name = 'Image',
		Placeholder = 'assetid',
		Function = function()
			if Crosshair.Enabled then
				debug.setconstant(oldequip or pl.Equip, 30, Image.Value:find('rbxasset') and Image.Value or isfile(Image.Value) and getcustomasset(Image.Value) or '')
			end
		end
	})
end)
	
run(function()
	local DamageIndicator
	local FontOption
	local ColorV
	local Size
	local tent, lent
	local thealth, ttimer = 0, 0
	local indi, indipart, indithread
	
	local function createIndicator(damage, pos)
		if indithread then
			task.cancel(indithread)
			indi.Text = math.ceil(tonumber(indi.Text) + damage)
			indipart.Position = pos
		else
			indipart = Instance.new('Part')
			indipart.Size = Vector3.zero
			indipart.Position = pos
			indipart.CanCollide = false
			indipart.CanQuery = false
			indipart.Anchored = true
			indipart.Parent = workspace
			local billboard = Instance.new('BillboardGui')
			billboard.Adornee = indipart
			billboard.Size = UDim2.fromOffset(30, 30)
			billboard.AlwaysOnTop = true
			billboard.Parent = indipart
			indi = Instance.new('TextLabel')
			indi.BackgroundTransparency = 1
			indi.TextStrokeTransparency = 0
			indi.Size = UDim2.fromScale(1, 1)
			indi.Text = math.ceil(damage)
			indi.TextColor3 = Color3.fromHSV(ColorV.Hue, ColorV.Sat, ColorV.Value)
			indi.TextScaled = true
			indi.Font = Enum.Font[FontOption.Value]
			indi.Parent = billboard
		end
	
		indithread = task.delay(1, function()
			indipart:Destroy()
			indipart = nil
			indithread = nil
		end)
	end
	
	DamageIndicator = vape.Legit:CreateModule({
		Name = 'DamageIndicator',
		Function = function(callback)
			if callback then
				TracerHook:Add('DamageIndicator', function(...)
					local part = debug.getstack(4, 17)
					if typeof(part) == 'Instance' then
						for _, v in entitylib.List do
							if part:IsDescendantOf(v.Character) and entitylib.isVulnerable(v, true) then
								if ttimer <= os.clock() or v ~= tent then
									thealth = v.Health
								end
	
								tent = v
								ttimer = os.clock() + 0.5
								break
							end
						end
					end
				end)
	
				DamageIndicator:Clean(entitylib.Events.EntityUpdated:Connect(function(ent)
					if ent == tent and ttimer > os.clock() then
						if ent ~= lent then
							if indi then
								indi.Text = '0'
							end
	
							lent = ent
						end
	
						if thealth > ent.Health then
							createIndicator(thealth - ent.Health, ent.Head.Position + Vector3.new(0, 2, 0))
							thealth = ent.Health
						end
					end
				end))
			else
				TracerHook:Remove('DamageIndicator')
			end
		end,
		Tooltip = 'Add custom damage indicators for gun damage.'
	})
	local fontitems = {'GothamBlack'}
	for _, v in Enum.Font:GetEnumItems() do
		if v.Name ~= 'GothamBlack' then
			table.insert(fontitems, v.Name)
		end
	end
	FontOption = DamageIndicator:CreateDropdown({
		Name = 'Font',
		List = fontitems,
		Function = function(val)
			if indi then
				indi.Font = Enum.Font[val]
			end
		end
	})
	ColorV = DamageIndicator:CreateColorSlider({
		Name = 'Color',
		DefaultHue = 0,
		Function = function(hue, sat, val)
			if indi then
				indi.Color = Color3.fromHSV(hue, sat, val)
			end
		end
	})
end)
	
run(function()
	local HitSound
	local Value
	local Volume
	local PitchShift
	local old, sounds = nil, {}
	
	HitSound = vape.Legit:CreateModule({
		Name = 'HitSound',
		Function = function(callback)
			if callback then
				local played
				TracerHook:Add('HitSound', function(...)
					local part = debug.getstack(4, 17)
					if typeof(part) == 'Instance' then
						for _, v in entitylib.List do
							if part:IsDescendantOf(v.Character) and entitylib.isVulnerable(v, true) then
								if #sounds > 0 and not played then
									local obj = Instance.new('Sound')
									obj.SoundId = sounds[math.random(1, #sounds)]
									obj.PlayOnRemove = true
									obj.PlaybackSpeed = PitchShift.Enabled and 1 + ((0.5 - math.random()) / 10) or 1
									obj.Volume = Volume.Value
									obj.Parent = workspace
									obj:Destroy()
									played = task.defer(function()
										played = nil
									end)
								end
	
								break
							end
						end
					end
				end)
			else
				TracerHook:Remove('HitSound')
			end
		end,
		Tooltip = 'Custom hit sound'
	})
	Value = HitSound:CreateTextList({
		Name = 'Sounds',
		Placeholder = 'sound id (roblox or file path)',
		Function = function(list)
			table.clear(sounds)
			for i, v in list or {} do
				sounds[i] = v:find('rbxasset') and v or isfile(v) and getcustomasset(v) or nil
			end
		end
	})
	Volume = HitSound:CreateSlider({
		Name = 'Volume',
		Min = 0,
		Max = 2,
		Default = 1,
		Decimal = 10
	})
	PitchShift = HitSound:CreateToggle({
		Name = 'Pitch Shift'
	})
end)
	
run(function()
	local KillSound
	local Value
	local Volume
	local PitchShift
	local old, sounds = nil, {}
	
	KillSound = vape.Legit:CreateModule({
		Name = 'KillSound',
		Function = function(callback)
			if callback then
				KillSound:Clean(vapeEvents.PlayerKill.Event:Connect(function(plr)
					if plr == lplr.Name and #sounds > 0 then
						local obj = Instance.new('Sound')
						obj.SoundId = sounds[math.random(1, #sounds)]
						obj.PlayOnRemove = true
						obj.PlaybackSpeed = PitchShift.Enabled and 1 + ((0.5 - math.random()) / 10) or 1
						obj.Volume = Volume.Value
						obj.Parent = workspace
						obj:Destroy()
					end
				end))
			end
		end,
		Tooltip = 'Custom kill sound'
	})
	Value = KillSound:CreateTextList({
		Name = 'Sounds',
		Placeholder = 'sound id (roblox or file path)',
		Function = function(list)
			table.clear(sounds)
			for i, v in list or {} do
				sounds[i] = v:find('rbxasset') and v or isfile(v) and getcustomasset(v) or nil
			end
		end
	})
	Volume = KillSound:CreateSlider({
		Name = 'Volume',
		Min = 0,
		Max = 2,
		Default = 1,
		Decimal = 10
	})
	PitchShift = KillSound:CreateToggle({
		Name = 'Pitch Shift'
	})
end)
	
run(function()
	local Viewmodel
	local Depth
	local Horizontal
	local Vertical
	local Sway
	local ForceField
	local ColorSl
	local handle
	local old
	local moveSpring = Spring.new()
	local aimSpring = Spring.new({Speed = 15})
	
	local function ToolAdded(obj)
		if obj and obj:IsA('Tool') then
			if old then
				for _, v in old:QueryDescendants('BasePart, Texture, Decal') do
					v.LocalTransparencyModifier = 0
				end
			end
	
			if vtool then
				vtool:Destroy()
			end
	
			old = obj
			vtool = obj:Clone()
			handle = vtool:FindFirstChild('Handle')
			vtool.Parent = gameCamera
	
			for _, v in vtool:QueryDescendants('BasePart') do
				v.Material = ForceField.Enabled and Enum.Material.ForceField or v.Material
				v.Color = ForceField.Enabled and Color3.fromHSV(ColorSl.Hue, ColorSl.Sat, ColorSl.Value) or v.Color
			end
	
			for _, v in old:QueryDescendants('BasePart, Texture, Decal') do
				v.LocalTransparencyModifier = 1
			end
		end
	end
	
	local function EntityAdded(ent)
		if vtool then
			vtool:Destroy()
			vtool = nil
			handle = nil
		end
	
		Viewmodel:Clean(ent.Character.ChildAdded:Connect(ToolAdded))
		Viewmodel:Clean(ent.Character.ChildRemoved:Connect(function(obj)
			if obj == old then
				if vtool then
					vtool:Destroy()
					vtool = nil
				end
	
				for _, v in old:QueryDescendants('BasePart, Texture, Decal') do
					v.LocalTransparencyModifier = 0
				end
	
				old = nil
			end
		end))
	
		ToolAdded(ent.Character:FindFirstChildWhichIsA('Tool'))
	end
	
	Viewmodel = vape.Legit:CreateModule({
		Name = 'Viewmodel',
		Function = function(callback)
			if callback then
				TracerHook:Add('Viewmodel', function(...)
					shootTimer = os.clock() + 0.3
				end, 0)
	
				Viewmodel:Clean(entitylib.Events.LocalAdded:Connect(EntityAdded))
				if entitylib.isAlive then
					task.spawn(EntityAdded, entitylib.character)
				end
	
				Viewmodel:Clean(runService.RenderStepped:Connect(function(dt)
					if handle then
						moveSpring.Target = entitylib.isAlive and entitylib.character.RootPart.AssemblyLinearVelocity * 0.005 or Vector3.zero
						if Sway.Enabled then
							if moveSpring.Target.Magnitude > 0.1 then
								moveSpring.Target += (gameCamera.CFrame * CFrame.new(math.sin(tick() * 10) * 0.06, 0, 0)).Position - gameCamera.CFrame.Position
							else
								moveSpring.Target += (gameCamera.CFrame * CFrame.new(0, math.sin(tick()) * 0.04, 0)).Position - gameCamera.CFrame.Position
							end
						end
	
						local cf = (gameCamera.CFrame * CFrame.new(Horizontal.Value, Vertical.Value, -Depth.Value)) + moveSpring:Update(dt)
						aimSpring.Target = aimTimer > os.clock() and CFrame.lookAt(cf.Position, aimVec).LookVector or gameCamera.CFrame.LookVector
						handle.CFrame = CFrame.lookAlong(cf.Position, aimSpring:Update(dt)) * (CFrame.Angles(math.rad(math.max(shootTimer - os.clock(), 0) * 10), 0, 0) * CFrame.new(0, 0, math.max(shootTimer - os.clock(), 0)))
						handle.AssemblyLinearVelocity = Vector3.zero
					end
				end))
			else
				TracerHook:Remove('Viewmodel')
	
				if old then
					for _, v in old:QueryDescendants('BasePart, Texture, Decal') do
						v.LocalTransparencyModifier = 0
					end
					old = nil
				end
	
				if vtool then
					vtool:Destroy()
					vtool = nil
					handle = nil
				end
			end
		end,
		Tooltip = 'Custom viewmodel for guns'
	})
	Depth = Viewmodel:CreateSlider({
		Name = 'Depth',
		Min = 0,
		Max = 3,
		Default = 3,
		Decimal = 10
	})
	Horizontal = Viewmodel:CreateSlider({
		Name = 'Horizontal',
		Min = 0,
		Max = 2,
		Default = 2,
		Decimal = 10
	})
	Vertical = Viewmodel:CreateSlider({
		Name = 'Vertical',
		Min = -1.5,
		Max = 2,
		Default = -1.5,
		Decimal = 10
	})
	Sway = Viewmodel:CreateToggle({
		Name = 'Sway Effect',
		Default = true
	})
	ForceField = Viewmodel:CreateToggle({
		Name = 'ForceField Effect',
		Function = function(callback)
			ColorSl.Object.Visible = callback
			if callback and Viewmodel.Enabled then
				Viewmodel:Toggle()
				Viewmodel:Toggle()
			end
		end
	})
	ColorSl = Viewmodel:CreateColorSlider({
		Name = 'Color',
		Function = function(hue, sat, val)
			if vtool then
				for _, v in vtool:QueryDescendants('BasePart') do
					v.Color = Color3.fromHSV(hue, sat, val)
				end
			end
		end,
		Visible = false
	})
end)
	