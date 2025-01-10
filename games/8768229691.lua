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
local collectionService = cloneref(game:GetService('CollectionService'))
local httpService = cloneref(game:GetService('HttpService'))
local coreGui = cloneref(game:GetService('CoreGui'))
local tweenService = cloneref(game:GetService('TweenService'))
local runService = cloneref(game:GetService('RunService'))

local gameCamera = workspace.CurrentCamera
local lplr = playersService.LocalPlayer
local assetfunction = getcustomasset

local vape = shared.vape
local entitylib = vape.Libraries.entity
local targetinfo = vape.Libraries.targetinfo
local sessioninfo = vape.Libraries.sessioninfo
local uipallet = vape.Libraries.uipallet
local tween = vape.Libraries.tween
local color = vape.Libraries.color
local whitelist = vape.Libraries.whitelist
local prediction = vape.Libraries.prediction
local getcustomasset = vape.Libraries.getcustomasset

local skywars, remotes = {}, {}
local store = {
	blocks = {},
	hand = {},
	inventory = {},
	tools = {},
	noShoot = tick()
}
local ViewmodelTool
local ViewmodelMotor

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

local function getItem(check)
	for _, item in store.inventory do
		if item.Type == check then
			return item
		end
	end
end

local function getSword()
	local bestSword, bestSwordSlot, bestSwordDamage = nil, nil, 0
	for slot, item in store.inventory do
		item = skywars.ItemMeta[item.Type]
		local swordDamage = item.Melee and item.Melee.Damage or 0
		if swordDamage > bestSwordDamage then
			bestSword, bestSwordSlot, bestSwordDamage = item, slot, swordDamage
		end
	end
	return bestSword, bestSwordSlot
end

local function getPickaxe()
	local bestPick, bestPickSlot, bestPickDamage = nil, nil, math.huge
	for slot, item in store.inventory do
		item = skywars.ItemMeta[item.Type]
		local pickDamage = item.Pickaxe and item.Pickaxe.TimeMultiplier or math.huge
		if pickDamage < bestPickDamage then
			bestPick, bestPickSlot, bestPickDamage = item, slot, pickDamage
		end
	end
	return bestPick, bestPickSlot
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

local function parsePositions(v, func)
	if v:IsA('Part') and v.Size // 1 == v.Size then
		local start = (v.Position - (v.Size / 2)) + Vector3.new(1.5, 1.5, 1.5)
		for x = 0, v.Size.X - 1, 3 do
			for y = 0, v.Size.Y - 1, 3 do
				for z = 0, v.Size.Z - 1, 3 do
					func(start + Vector3.new(x, y, z))
				end
			end
		end
	end
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
	entitylib.addPlayer = function(plr)
		if plr.Character then
			entitylib.refreshEntity(plr.Character, plr)
		end
		entitylib.PlayerConnections[plr] = {
			plr.CharacterAdded:Connect(function(char)
				entitylib.refreshEntity(char, plr)
			end),
			plr.CharacterRemoving:Connect(function(char)
				entitylib.removeEntity(char, plr == lplr)
			end),
			plr:GetAttributeChangedSignal('TeamId'):Connect(function()
				for i, v in entitylib.List do
					if v.Targetable ~= entitylib.targetCheck(v) then
						entitylib.refreshEntity(v.Character, v.Player)
					end
				end

				if plr == lplr then
					entitylib.start()
				else
					entitylib.refreshEntity(plr.Character, plr)
				end
			end)
		}
	end

	entitylib.addEntity = function(char, plr, teamfunc)
		if not char then return end
		entitylib.EntityThreads[char] = task.spawn(function()
			local hum = waitForChildOfType(char, 'Humanoid', 10)
			local humrootpart = hum and waitForChildOfType(hum, 'RootPart', workspace.StreamingEnabled and 9e9 or 10, true)
			local head = char:WaitForChild('Head', 10) or humrootpart

			if hum and humrootpart then
				local entity = {
					Connections = {},
					Character = char,
					Health = (plr:GetAttribute('Health') or 100),
					Head = head,
					Humanoid = hum,
					HumanoidRootPart = humrootpart,
					HipHeight = hum.HipHeight + (humrootpart.Size.Y / 2) + (hum.RigType == Enum.HumanoidRigType.R6 and 2 or 0),
					MaxHealth = 100,
					NPC = plr == nil,
					Player = plr,
					RootPart = humrootpart,
					TeamCheck = teamfunc
				}

				if plr == lplr then
					entity.GroundPosition = Vector3.zero
					entitylib.character = entity
					entitylib.isAlive = true
					entitylib.Events.LocalAdded:Fire(entity)
				else
					entity.Targetable = (teamfunc or entitylib.targetCheck)(entity)

					for _, v in entitylib.getUpdateConnections(entity) do
						table.insert(entity.Connections, v:Connect(function()
							entity.Health = (plr:GetAttribute('Health') or 100)
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

	entitylib.getUpdateConnections = function(ent)
		return {
			ent.Player:GetAttributeChangedSignal('Health'),
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
		if ent.NPC then return true end
		if isFriend(ent.Player) then return false end
		if not select(2, whitelist:get(ent.Player)) then return false end
		return lplr:GetAttribute('TeamId') ~= ent.Player:GetAttribute('TeamId')
	end

	entitylib.getEntityColor = function(ent)
		ent = ent.Player
		if not (ent and vape.Categories.Main.Options['Use team color'].Enabled) then return end
		if isFriend(ent, true) then
			return Color3.fromHSV(vape.Categories.Friends.Options['Friends color'].Hue, vape.Categories.Friends.Options['Friends color'].Sat, vape.Categories.Friends.Options['Friends color'].Value)
		end
		return skywars.TeamController:getTeamColour(ent:GetAttribute('TeamId'))
	end
end)
entitylib.start()

run(function()
	local Flamework = require(replicatedStorage['rbxts_include']['node_modules']['@flamework'].core.out).Flamework
	local ControllerTable = {}

	if not debug.getupvalue(Flamework.ignite, 1) then
		repeat task.wait() until debug.getupvalue(Flamework.ignite, 1)
	end

	local function searchFunction(name, i2, v2)
		for i3, v3 in debug.getconstants(v2) do
			if tostring(v3):find('-') == 9 then
				remotes[(rawget(remotes, i2) and name..':' or '')..i2] = v3
			end
		end
	end

	for i, v in debug.getupvalue(Flamework.ignite, 2).idToObj do
		local name = tostring(v)
		ControllerTable[name] = Flamework.resolveDependency(i)
		for i2, v2 in v do
			if type(v2) == 'function' then
				searchFunction(name, i2, v2)

				for _, v3 in debug.getprotos(v2) do
					searchFunction(name, i2, v3)
				end
			end
		end
	end

	local roactCheck = replicatedStorage['rbxts_include']['node_modules']['@rbxts']:FindFirstChild('roact')
	skywars = setmetatable({
		CameraUtil = require(lplr.PlayerScripts.TS.util['camera-util']).CameraUtil,
		FireOrigin = debug.getupvalue(ControllerTable.ProjectileController.chargeBow, 10).ORIGIN_OFFSET,
		Gravity = debug.getupvalue(ControllerTable.ProjectileController.chargeBow, 12).WORLD_ACCELERATION.Y,
		ItemMeta = debug.getupvalue(ControllerTable.HotbarController.getSword, 1),
		Remotes = debug.getupvalue(ControllerTable.MeleeController.strikeDesktop, 6),
		Roact = require(roactCheck and roactCheck.src or replicatedStorage['rbxts_include']['node_modules']['@rbxts'].ReactLua['node_modules']['@jsdotlua']['roact-compat']),
		Store = require(lplr.PlayerScripts.TS.ui.rodux['global-store']).GlobalStore,
		Shop = require(replicatedStorage.TS.game.shop['game-shop']).Shops
	}, {
		__index = function(self, ind)
			rawset(self, ind, ControllerTable[ind])
			return rawget(self, ind)
		end
	})

	local kills = sessioninfo:AddItem('Kills')
	local eggs = sessioninfo:AddItem('Eggs')
	local wins = sessioninfo:AddItem('Wins')
	local games = sessioninfo:AddItem('Games')

	task.delay(1, function()
		games:Increment()
	end)

	local function updateStore(newStore, oldStore)
		if newStore.GameCurrency ~= oldStore.GameCurrency then
			vapeEvents.CurrencyChange:Fire(table.clone(newStore.GameCurrency.Quantities))
		end

		if newStore.ActiveSlot ~= oldStore.ActiveSlot then
			store.hand = newStore.Inventory.Contents[newStore.ActiveSlot]
			store.hand = store.hand and skywars.ItemMeta[store.hand.Type] or {}
		end

		if newStore.Inventory ~= oldStore.Inventory then
			store.inventory = newStore.Inventory.Contents
			store.hand = newStore.Inventory.Contents[newStore.ActiveSlot]
			store.hand = store.hand and skywars.ItemMeta[store.hand.Type] or {}
			store.tools.sword = getSword()
			store.tools.pickaxe = getPickaxe()
			vapeEvents.InventoryAmountChanged:Fire()
		end

		if oldStore.Profile and oldStore.Profile.WasTeleporting and newStore.Profile.Stats ~= oldStore.Profile.Stats then
			if newStore.Profile.Stats.Kills ~= oldStore.Profile.Stats.Kills and oldStore.Profile.Stats.Kills then
				kills:Increment()
			end

			if newStore.Profile.Stats.Wins ~= oldStore.Profile.Stats.Wins and oldStore.Profile.Stats.Wins then
				wins:Increment()
			end
		end
	end

	local storeChanged = skywars.Store.changed:connect(updateStore)
	updateStore(skywars.Store:getState(), {})

	task.spawn(function()
		repeat
			if entitylib.isAlive then
				entitylib.character.GroundPosition = entitylib.character.Humanoid.FloorMaterial ~= Enum.Material.Air and entitylib.character.RootPart.Position or entitylib.character.GroundPosition
			end
			task.wait()
		until vape.Loaded == nil
	end)

	vape:Clean(workspace.BlockContainer.DescendantAdded:Connect(function(v)
		parsePositions(v, function(pos)
			store.blocks[pos] = v
		end)
	end))
	vape:Clean(workspace.BlockContainer.DescendantRemoving:Connect(function(v)
		parsePositions(v, function(pos)
			store.blocks[pos] = nil
		end)
	end))
	for _, v in workspace.BlockContainer:GetDescendants() do
		parsePositions(v, function(pos)
			store.blocks[pos] = v
		end)
	end

	vape:Clean(function()
		for _, v in vapeEvents do
			v:Destroy()
		end
		table.clear(ControllerTable)
		table.clear(RemoteTable)
		table.clear(vapeEvents)
		table.clear(skywars)
		table.clear(store.blocks)
		table.clear(store)
		storeChanged:disconnect()
		storeChanged = nil
	end)
end)

for _, v in {'Reach', 'TriggerBot', 'Disabler', 'SilentAim', 'AutoRejoin', 'Rejoin', 'ServerHop', 'MurderMystery'} do
	vape:Remove(v)
end
run(function()
	local AutoClicker
	local CPS
	local Blocks
	local BlocksCPS = {Object = {}}
	local Thread
	local old
	
	local function AutoClick()
		Thread = task.delay(1 / 8, function()
			repeat
				local held = store.hand
				if held then
					if held.Rewrite and Blocks.Enabled then
						local block = skywars.ItemMeta[held.Rewrite.Type:gsub('{TeamId}', skywars.TeamController:getPlayerTeamId(lplr) or 'White')]
						local ray = skywars.BlockRaycastController:executeRaycast(inputService:GetMouseLocation(), 1, 0, block)
						if ray and ray.BlockPosition then
							skywars.BlockController:placeBlock(ray.BlockPosition, held.Name, block, ray.Rotation)
						end
					elseif held.Melee then
						skywars.MeleeController:strike(held)
					end
				end
	
				task.wait(1 / (held and held.Rewrite and BlocksCPS or CPS).GetRandomValue())
			until not AutoClicker.Enabled
		end)
	end
	
	AutoClicker = vape.Categories.Combat:CreateModule({
		Name = 'AutoClicker',
		Function = function(callback)
			if callback then
				AutoClicker:Clean(inputService.InputBegan:Connect(function(input, gameProcessed)
					if not gameProcessed and input.UserInputType == Enum.UserInputType.MouseButton1 then
						AutoClick()
					end
				end))
				AutoClicker:Clean(inputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 and Thread then
						task.cancel(Thread)
						Thread = nil
					end
				end))
			end
		end,
		Tooltip = 'Hold attack button to automatically click'
	})
	CPS = AutoClicker:CreateTwoSlider({
		Name = 'CPS',
		Min = 1,
		Max = 9,
		DefaultMin = 9,
		DefaultMax = 9
	})
	Blocks = AutoClicker:CreateToggle({
		Name = 'Place Blocks',
		Default = true,
		Function = function(callback)
			BlocksCPS.Object.Visible = callback
		end
	})
	BlocksCPS = AutoClicker:CreateTwoSlider({
		Name = 'Block CPS',
		Min = 1,
		Max = 20,
		DefaultMin = 9,
		DefaultMax = 9,
		Darker = true
	})
end)
	
run(function()
	local Sprint
	local old
	
	Sprint = vape.Categories.Combat:CreateModule({
		Name = 'Sprint',
		Function = function(callback)
			if callback then
				old = skywars.SprintingController.disableSprinting
				skywars.SprintingController.disableSprinting = function(tab, ...)
					local originalCall = old(tab, ...)
					if not tab.canSprint then
						task.spawn(function()
							repeat task.wait(0.1) until tab.canSprint or not Sprint.Enabled
							if Sprint.Enabled then
								skywars.SprintingController:enableSprinting(tab)
							end
						end)
					else
						skywars.SprintingController:enableSprinting(tab)
					end
					return originalCall
				end
				Sprint:Clean(entitylib.Events.LocalAdded:Connect(function()
					skywars.SprintingController:disableSprinting()
				end))
				skywars.SprintingController:disableSprinting()
			else
				skywars.SprintingController.disableSprinting = old
				skywars.SprintingController:disableSprinting()
			end
		end,
		Tooltip = 'Sets your sprinting to true.'
	})
end)
	
run(function()
	local Velocity
	local Horizontal
	local Vertical
	local Chance
	local Targeting
	local connection
	local rand, old = Random.new()
	
	local function velocityFunction(velo, ...)
		if rand:NextNumber(0, 100) > Chance.Value then return end
		local check = (not Targeting.Enabled) or entitylib.EntityPosition({
			Range = 50,
			Part = 'RootPart',
			Players = true
		})
		
		if check then
			local hort, vert = (Horizontal.Value / 100), (Vertical.Value / 100)
			if hort == 0 and vert == 0 then return end
			velo = Vector3.new(velo.X * hort, velo.Y * vert, velo.Z * hort)
		end
	
		return old(velo, ...)
	end
	
	Velocity = vape.Categories.Combat:CreateModule({
		Name = 'Velocity',
		Function = function(callback)
			if callback then
				connection = getconnections(debug.getupvalue(debug.getupvalue(skywars.Remotes[remotes['PlayerVelocityController:onStart']].connect, 1).fireClient, 1).OnClientEvent)[1]
				if not connection then return end
				old = hookfunction(connection.Function, function(...)
					return velocityFunction(...)
				end)
			else
				if old then 
					hookfunction(connection.Function, old) 
				end
				connection = nil
			end
		end,
		Tooltip = 'Reduces knockback taken'
	})
	Horizontal = Velocity:CreateSlider({
		Name = 'Horizontal',
		Min = 0,
		Max = 100,
		Default = 0,
		Suffix = '%'
	})
	Vertical = Velocity:CreateSlider({
		Name = 'Vertical',
		Min = 0,
		Max = 100,
		Default = 0,
		Suffix = '%'
	})
	Chance = Velocity:CreateSlider({
		Name = 'Chance',
		Min = 0,
		Max = 100,
		Default = 100,
		Suffix = '%'
	})
	Targeting = Velocity:CreateToggle({Name = 'Only when targeting'})
end)
	
run(function()
	local AntiFall
	local Mode
	local Material
	local Color
	local part
	
	local function getLowGround()
		local mag = math.huge
		for pos in store.blocks do
			if pos.Y < mag and not store.blocks[pos + Vector3.new(0, 3, 0)] then
				mag = pos.Y
			end
		end
		return mag
	end
	
	AntiFall = vape.Categories.Blatant:CreateModule({
		Name = 'AntiFall',
		Function = function(callback)
			if callback then
				local pos, debounce = getLowGround(), tick()
				if pos ~= math.huge then
					local middle = next(store.blocks)
					part = Instance.new('Part')
					part.Size = Vector3.new(10000, 1, 10000)
					part.Transparency = 1 - Color.Opacity
					part.Material = Enum.Material[Material.Value]
					part.Color = Color3.fromHSV(Color.Hue, Color.Sat, Color.Value)
					part.Position = Vector3.new(middle.X, pos - 2, middle.Z)
					part.CanCollide = Mode.Value == 'Collide'
					part.Anchored = true
					part.CanQuery = false
					part.Parent = workspace
					AntiFall:Clean(part)
					AntiFall:Clean(part.Touched:Connect(function(touchedpart)
						if touchedpart.Parent == lplr.Character and entitylib.isAlive and debounce < tick() then
							local root = entitylib.character.RootPart
							debounce = tick() + 0.1
							if Mode.Value == 'Velocity' then
								root.Velocity = Vector3.new(root.Velocity.X, 100, root.Velocity.Z)
							end
						end
					end))
				end
			end
		end,
		Tooltip = 'Help\'s you with your Parkinson\'s\nPrevents you from falling into the void.'
	})
	Mode = AntiFall:CreateDropdown({
		Name = 'Move Mode',
		List = {'Velocity', 'Collide'},
		Function = function(val)
			if part then
				part.CanCollide = val == 'Collide'
			end
		end,
		Tooltip = 'Velocity - Launches you upward after touching\nCollide - Allows you to walk on the part'
	})
	local materials = {'ForceField'}
	for _, v in Enum.Material:GetEnumItems() do
		if v.Name ~= 'ForceField' then
			table.insert(materials, v.Name)
		end
	end
	Material = AntiFall:CreateDropdown({
		Name = 'Material',
		List = materials,
		Function = function(val)
			if part then 
				part.Material = Enum.Material[val] 
			end
		end
	})
	Color = AntiFall:CreateColorSlider({
		Name = 'Color',
		DefaultOpacity = 0.5,
		Function = function(h, s, v, o)
			if part then
				part.Color = Color3.fromHSV(h, s, v)
				part.Transparency = 1 - o
			end
		end
	})
end)
	
run(function()
	local InvMove
	local old
	
	InvMove = vape.Categories.Blatant:CreateModule({
		Name = 'InvMove',
		Function = function(callback)
			if callback then
				old = skywars.ScreenController.enableFocus
				skywars.ScreenController.enableFocus = function(self, screen, ...)
					screen.Handler.Options.focusedAllowMovement = true
					return old(self, screen, ...)
				end
			else
				skywars.ScreenController.enableFocus = old
				old = nil
			end
		end,
		Tooltip = 'Allows you to continuous movement in menus'
	})
end)
	
run(function()
	local Killaura
	local Targets
	local AttackRange
	local AngleCheck
	local Max
	local Mouse
	local Limit
	local Swing
	local BoxAttackColor
	local ParticleTexture
	local ParticleColor1
	local ParticleColor2
	local ParticleSize
	local Animation
	local AnimationMode
	local AnimationSpeed
	local AnimationTween
	local AnimTween
	local Attacking
	local Particles, Boxes = {}, {}
	local anims, armC0 = vape.Libraries.auraanims
	
	local function getAttackData()
		if Mouse.Enabled then
			if inputService:IsMouseButtonPressed(0) then return false end
		end
	
		return (not Limit.Enabled) and store.tools.sword or store.hand
	end
	
	Killaura = vape.Categories.Blatant:CreateModule({
		Name = 'Killaura',
		Function = function(callback)
			if callback then
				if Animation.Enabled then
					task.spawn(function()
						local started = false
						repeat
							if ViewmodelMotor then
								if Attacking then
									if not armC0 then armC0 = ViewmodelMotor.C0 end
									local first = not started
									started = true
	
									if AnimationMode.Value == 'Random' then
										anims.Random = {{CFrame = CFrame.Angles(math.rad(math.random(1, 360)), math.rad(math.random(1, 360)), math.rad(math.random(1, 360))), Time = 0.12}}
									end
	
									for _, v in anims[AnimationMode.Value] do
										AnimTween = tweenService:Create(ViewmodelMotor, TweenInfo.new(first and (AnimationTween.Enabled and 0.001 or 0.1) or v.Time / AnimationSpeed.Value, Enum.EasingStyle.Linear), {
											C0 = armC0 * v.CFrame
										})
										AnimTween:Play()
										AnimTween.Completed:Wait()
										first = false
										if (not Killaura.Enabled) or (not Attacking) then break end
									end
								elseif started then
									started = false
									AnimTween = tweenService:Create(ViewmodelMotor, TweenInfo.new(AnimationTween.Enabled and 0.001 or 0.3, Enum.EasingStyle.Exponential), {
										C0 = armC0
									})
									AnimTween:Play()
								end
							end
	
							if not started then
								task.wait(1 / 60)
							end
						until (not Killaura.Enabled) or (not Animation.Enabled)
					end)
				end
	
				repeat
					local attacked = {}
					local tool = getAttackData()
					if tool and tool.Melee then
						local plrs = entitylib.AllPosition({
							Range = AttackRange.Value,
							Wallcheck = Targets.Walls.Enabled or nil,
							Part = 'RootPart',
							Players = Targets.Players.Enabled,
							NPCs = Targets.NPCs.Enabled,
							Limit = Max.Value
						})
						local switched = false
	
						if #plrs > 0 then
							local localfacing = entitylib.character.RootPart.CFrame.LookVector * Vector3.new(1, 0, 1)
							store.noShoot = tick() + 1
	
							for i, v in plrs do
								local delta = (v.RootPart.Position - entitylib.character.RootPart.Position)
								local angle = math.acos(localfacing:Dot((delta * Vector3.new(1, 0, 1)).Unit))
								if angle > (math.rad(AngleCheck.Value) / 2) then continue end
								table.insert(attacked, v)
								targetinfo.Targets[v] = tick() + 1
	
								if not Swing.Enabled then
									skywars.MeleeController:playAnimation(lplr.Character, tool)
								end
	
								if not switched then
									switched = true
									skywars.Remotes[remotes.updateActiveItem]:fire(tool.Name)
								end
	
								skywars.Remotes[remotes.strikeDesktop]:fire(v.Player)
							end
						end
	
						if switched then
							skywars.Remotes[remotes.updateActiveItem](store.hand.Name)
						end
					end
	
					Attacking = #attacked > 0
					if Attacking and vape.ThreadFix then
						setthreadidentity(8)
					end
	
					for i, v in Boxes do
						v.Adornee = attacked[i] and attacked[i].RootPart or nil
						if v.Adornee then
							v.Color3 = Color3.fromHSV(BoxAttackColor.Hue, BoxAttackColor.Sat, BoxAttackColor.Value)
							v.Transparency = 1 - BoxAttackColor.Opacity
						end
					end
	
					for i, v in Particles do
						v.Position = attacked[i] and attacked[i].RootPart.Position or Vector3.new(9e9, 9e9, 9e9)
						v.Parent = attacked[i] and gameCamera or nil
					end
	
					task.wait(0.05)
				until not Killaura.Enabled
			else
				for i, v in Boxes do
					v.Adornee = nil
				end
				for i, v in Particles do
					v.Parent = nil
				end
				if armC0 and ViewmodelMotor then
					AnimTween = tweenService:Create(ViewmodelMotor, TweenInfo.new(AnimationTween.Enabled and 0.001 or 0.3, Enum.EasingStyle.Exponential), {
						C0 = armC0
					})
					AnimTween:Play()
				end
			end
		end,
		Tooltip = 'Attack players around you\nwithout aiming at them.'
	})
	Targets = Killaura:CreateTargets({Players = true})
	AttackRange = Killaura:CreateSlider({
		Name = 'Attack range',
		Min = 1,
		Max = 18,
		Default = 18,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end
	})
	AngleCheck = Killaura:CreateSlider({
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
	Swing = Killaura:CreateToggle({Name = 'No Swing'})
	Killaura:CreateToggle({
		Name = 'Show target',
		Function = function(callback)
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
				for i, v in Boxes do
					v:Destroy()
				end
				table.clear(Boxes)
			end
		end
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
		Default = 0.14,
		Decimal = 100,
		Function = function(val)
			for _, v in Particles do
				v.ParticleEmitter.Size = NumberSequence.new(val)
			end
		end,
		Darker = true,
		Visible = false
	})
	Animation = Killaura:CreateToggle({
		Name = 'Custom Animation',
		Function = function(callback)
			AnimationMode.Object.Visible = callback
			AnimationTween.Object.Visible = callback
			AnimationSpeed.Object.Visible = callback
			if Killaura.Enabled then
				Killaura:Toggle()
				Killaura:Toggle()
			end
		end
	})
	local animnames = {}
	for i in anims do
		table.insert(animnames, i)
	end
	AnimationMode = Killaura:CreateDropdown({
		Name = 'Animation Mode',
		List = animnames,
		Darker = true,
		Visible = false
	})
	AnimationSpeed = Killaura:CreateSlider({
		Name = 'Animation Speed',
		Min = 0,
		Max = 2,
		Default = 1,
		Decimal = 10,
		Darker = true,
		Visible = false
	})
	AnimationTween = Killaura:CreateToggle({
		Name = 'No Tween',
		Darker = true,
		Visible = false
	})
	Limit = Killaura:CreateToggle({
		Name = 'Limit to items',
		Tooltip = 'Only attacks when the sword is held'
	})
end)
	
run(function()
	local NoFall
	local rayCheck = RaycastParams.new()
	
	NoFall = vape.Categories.Blatant:CreateModule({
		Name = 'NoFall',
		Function = function(callback)
			if callback then
				repeat
					local waitdelay = 0
					if entitylib.isAlive then
						local hum = entitylib.character.Humanoid
						if (entitylib.character.GroundPosition.Y - entitylib.character.RootPart.Position.Y) > 10 then
							rayCheck.FilterDescendantsInstances = {lplr.Character, gameCamera}
							local ray = workspace:Raycast(entitylib.character.RootPart.Position, Vector3.new(0, -(entitylib.character.HipHeight + 10), 0), rayCheck)
							if not ray then
								hum:ChangeState(Enum.HumanoidStateType.Ragdoll)
								task.wait(0.1)
								hum:ChangeState(Enum.HumanoidStateType.Running)
								waitdelay = 0.05
							end
						end
					end
					task.wait(waitdelay)
				until not NoFall.Enabled
			end
		end,
		Tooltip = 'Prevents taking fall damage.'
	})
end)
	
run(function()
	local old, old2
	
	vape.Categories.Blatant:CreateModule({
		Name = 'NoSlowdown',
		Function = function(callback)
			if callback then
				old = skywars.HumanoidController.addSpeedModifier
				old2 = skywars.SprintingController.setCanSprint
	
				skywars.HumanoidController.addSpeedModifier = function(self, index, speed)
					speed = math.max(speed, 1)
					return old(self, index, speed)
				end
	
				skywars.SprintingController.setCanSprint = function(self, canSprint)
					return old2(self, true)
				end
	
				for i, v in skywars.HumanoidController.speedModifiers do
					if v < 1 then
						skywars.HumanoidController:removeSpeedModifier(i)
					end
				end
				skywars.SprintingController:setCanSprint(true)
				skywars.SprintingController:enableSprinting()
			else
				skywars.HumanoidController.addSpeedModifier = old
				skywars.SprintingController.setCanSprint = old2
				old = nil
				old2 = nil
			end
		end,
		Tooltip = 'Prevents slowing down when using items.'
	})
end)
	
run(function()
	local TargetPart
	local FOV
	local old, oldMobile
	local rayCheck = RaycastParams.new()
	rayCheck.FilterType = Enum.RaycastFilterType.Exclude
	
	local function aimFunction(...)
		if store.hand and store.hand.Ranged then
			local plr = entitylib.EntityMouse({
				Range = FOV.Value,
				Part = 'RootPart',
				Players = true
			})
		
			if plr then
				rayCheck.FilterDescendantsInstances = {plr.Character, gameCamera}
				rayCheck.CollisionGroup = plr[TargetPart.Value].CollisionGroup
				local offsetpos = entitylib.character.RootPart.CFrame * skywars.FireOrigin
				local calc = prediction.SolveTrajectory(offsetpos.Position, 200, math.abs(skywars.Gravity), plr[TargetPart.Value].Position, plr[TargetPart.Value].Velocity, workspace.Gravity, plr.HipHeight, nil, rayCheck)
				
				if calc then
					targetinfo.Targets[plr] = tick() + 1
					return CFrame.new(offsetpos.Position, calc).LookVector
				end
			end
		end
	
		return old(...)
	end
	
	local ProjectileAimbot = vape.Categories.Blatant:CreateModule({
		Name = 'ProjectileAimbot',
		Function = function(callback)
			if callback then 
				old = hookfunction(skywars.CameraUtil.getCursorDirection, function(...)
					return aimFunction(...)
				end)
				oldMobile = hookfunction(skywars.CameraUtil.getDirection, function(...)
					return aimFunction(...)
				end)
			else
				hookfunction(skywars.CameraUtil.getCursorDirection, old)
				hookfunction(skywars.CameraUtil.getDirection, oldMobile)
				old = nil
				oldMobile = nil
			end
		end,
		Tooltip = 'Silently adjusts your aim towards the enemy'
	})
	TargetPart = ProjectileAimbot:CreateDropdown({
		Name = 'Part',
		List = {'RootPart', 'Head'}
	})
	FOV = ProjectileAimbot:CreateSlider({
		Name = 'FOV',
		Min = 1,
		Max = 1000,
		Default = 1000
	})
end)
	
run(function()
	local ProjectileAura
	local Targets
	local Range
	local List
	local rayCheck = RaycastParams.new()
	rayCheck.FilterType = Enum.RaycastFilterType.Exclude
	local FireDelays = {}
	
	local function getProjectiles()
		local items = {}
		for slot, item in store.inventory do
			item = skywars.ItemMeta[item.Type]
			if item.Ranged and table.find(List.ListEnabled, item.Ranged.ProjectileType) and getItem(item.Ranged.ProjectileType) then
				table.insert(items, item)
			end
		end
		return items
	end
	
	ProjectileAura = vape.Categories.Blatant:CreateModule({
		Name = 'ProjectileAura',
		Function = function(callback)
			if callback then
				repeat
					local ent = entitylib.EntityPosition({
						Part = 'RootPart',
						Range = Range.Value,
						Players = Targets.Players.Enabled,
						NPCs = Targets.NPCs.Enabled,
						Wallcheck = Targets.Walls.Enabled
					})
	
					if ent then
						local offsetpos = entitylib.character.RootPart.CFrame * skywars.FireOrigin
						for _, item in getProjectiles() do
							if (FireDelays[item] or 0) < tick() then
								rayCheck.FilterDescendantsInstances = {ent.Character, gameCamera}
								rayCheck.CollisionGroup = ent.RootPart.CollisionGroup
								local calc = prediction.SolveTrajectory(offsetpos.Position, 200, math.abs(skywars.Gravity), ent.RootPart.Position, ent.RootPart.Velocity, workspace.Gravity, ent.HipHeight, nil, rayCheck)
								
								if calc then
									targetinfo.Targets[ent] = tick() + 1
									FireDelays[item] = tick() + 0.5
									skywars.Remotes[remotes.updateActiveItem]:fire(item.Name)
									skywars.Remotes[remotes.chargeBow]:fire(CFrame.new(offsetpos.Position, calc).LookVector, 1)
									skywars.Remotes[remotes.updateActiveItem](store.hand.Name) 
									break
								end
							end
						end
					end
					task.wait(0.1)
				until not ProjectileAura.Enabled
			end
		end,
		Tooltip = 'Shoots people around you'
	})
	Targets = ProjectileAura:CreateTargets({
		Players = true, 
		Walls = true
	})
	List = ProjectileAura:CreateTextList({
		Name = 'Projectiles',
		Default = {'Arrow', 'Snowball', 'Capybara'}
	})
	Range = ProjectileAura:CreateSlider({
		Name = 'Range',
		Min = 1,
		Max = 50,
		Default = 50,
		Suffix = function(val) 
			return val == 1 and 'stud' or 'studs' 
		end
	})
end)
	
run(function()
	local Scaffold
	local Expand
	local Tower
	local Downwards
	local Diagonal
	local LimitItem
	local adjacent, lastpos = {}, Vector3.zero
	
	for x = -3, 3, 3 do
		for y = -3, 3, 3 do
			for z = -3, 3, 3 do
				local vec = Vector3.new(x, y, z)
				if vec.Y ~= 0 and (vec.X ~= 0 or vec.Z ~= 0) then
					continue
				end
	
				if vec ~= Vector3.zero then 
					table.insert(adjacent, vec)
				end
			end
		end
	end
	
	local function getBlocksInPoints(s, e)
		local list = {}
		for x = s.X, e.X, 3 do
			for y = s.Y, e.Y, 3 do
				for z = s.Z, e.Z, 3 do
					local vec = Vector3.new(x, y, z)
					if store.blocks[vec] then
						table.insert(list, vec)
					end
				end
			end
		end
		return list
	end
	
	local function roundPos(vec)
		return Vector3.new(math.round(vec.X / 3) * 3, math.round(vec.Y / 3) * 3, math.round(vec.Z / 3) * 3)
	end
	
	local function nearCorner(poscheck, pos)
		local startpos = poscheck - Vector3.new(3, 3, 3)
		local endpos = poscheck + Vector3.new(3, 3, 3)
		local check = poscheck + (pos - poscheck).Unit * 100
		if math.abs(check.Y - startpos.Y) > 3 then
			return Vector3.new(poscheck.X, math.clamp(check.Y, startpos.Y, endpos.Y), poscheck.Z)
		end
		return Vector3.new(math.clamp(check.X, startpos.X, endpos.X), math.clamp(check.Y, startpos.Y, endpos.Y), math.clamp(check.Z, startpos.Z, endpos.Z))
	end
	
	local function blockProximity(pos)
		local mag, returned = 60
		local tab = getBlocksInPoints(pos - Vector3.new(21, 21, 21), pos + Vector3.new(21, 21, 21))
		for _, v in tab do
			local blockpos = nearCorner(v, pos)
			local newmag = (pos - blockpos).Magnitude
			if newmag < mag then
				mag, returned = newmag, blockpos
			end
		end
		table.clear(tab)
		return returned
	end
	
	local function checkAdjacent(pos)
		for _, v in adjacent do
			if store.blocks[pos + v] then return true end
		end
		return false
	end
	
	local function getBlock()
		for slot, item in store.inventory do
			item = skywars.ItemMeta[item.Type]
			if item.Rewrite then return item, slot end
		end
	end
	
	Scaffold = vape.Categories.Utility:CreateModule({
		Name = 'Scaffold',
		Function = function(callback)
			if callback then
				repeat
					if entitylib.isAlive then
						local wool = (not LimitItem.Enabled) and getBlock() or store.hand.Rewrite and store.hand
						if wool then
							local root = entitylib.character.RootPart
							if Tower.Enabled and inputService:IsKeyDown(Enum.KeyCode.Space) and (not inputService:GetFocusedTextBox()) then
								root.Velocity = Vector3.new(root.Velocity.X, 38, root.Velocity.Z)
							end
	
							for i = Expand.Value, 1, -1 do
								local currentpos = roundPos(root.Position - Vector3.new(0, entitylib.character.HipHeight + (Downwards.Enabled and inputService:IsKeyDown(Enum.KeyCode.LeftShift) and 4.5 or 1.5), 0) + entitylib.character.Humanoid.MoveDirection * (i * 3))
								if Diagonal.Enabled then
									if math.abs(math.round(math.deg(math.atan2(-entitylib.character.Humanoid.MoveDirection.X, -entitylib.character.Humanoid.MoveDirection.Z)) / 45) * 45) % 90 == 45 then
										local dt = (lastpos - currentpos)
										if ((dt.X == 0 and dt.Z ~= 0) or (dt.X ~= 0 and dt.Z == 0)) and ((lastpos - root.Position) * Vector3.new(1, 0, 1)).Magnitude < 2.5 then
											currentpos = lastpos
										end
									end
								end
	
								local block = store.blocks[currentpos]
								if not block then
									blockpos = checkAdjacent(currentpos) and currentpos or blockProximity(currentpos)
									if blockpos then
										local block = skywars.ItemMeta[wool.Rewrite.Type:gsub('{TeamId}', skywars.TeamController:getPlayerTeamId(lplr) or 'White')]
										skywars.BlockController:placeBlock(blockpos, wool.Name, block, Vector3.zero)
									end
								end
								lastpos = currentpos
							end
						end
					end
					task.wait(0.03)
				until not Scaffold.Enabled
			end
		end,
		Tooltip = 'Helps you make bridges/scaffold walk.'
	})
	Expand = Scaffold:CreateSlider({
		Name = 'Expand',
		Min = 1,
		Max = 6
	})
	Tower = Scaffold:CreateToggle({
		Name = 'Tower',
		Default = true
	})
	Downwards = Scaffold:CreateToggle({
		Name = 'Downwards',
		Default = true
	})
	Diagonal = Scaffold:CreateToggle({
		Name = 'Diagonal',
		Default = true
	})
	LimitItem = Scaffold:CreateToggle({Name = 'Limit to items'})
end)
	
run(function()
	local ChestSteal
	local Range
	local Open
	local Delay = {}
	
	ChestSteal = vape.Categories.World:CreateModule({
		Name = 'ChestSteal',
		Function = function(callback)
			if callback then
				local chests = collection('block:chest', ChestSteal)
				ChestSteal:Clean(skywars.Remotes[remotes['ChestController:onStart']]:connect(function(self, items)
					if Delay[self] then return end
	
					for _, item in items do
						skywars.Remotes[remotes.updateChest]:fire(self, item.Type, -item.Quantity)
					end
					skywars.Remotes[remotes.closeChest]:fire(self)
					Delay[self] = true
				end))
	
				repeat
					if entitylib.isAlive and not Open.Enabled then
						local localPosition = entitylib.character.RootPart.Position
						for i, v in chests do
							if v.PrimaryPart and (localPosition - v.PrimaryPart.Position).Magnitude <= Range.Value and not Delay[v] then
								skywars.Remotes[remotes.openChest]:fire(v)
							end
						end
					end
					task.wait(0.1)
				until not ChestSteal.Enabled
			end
		end,
		Tooltip = 'Grabs items from near chests.'
	})
	Range = ChestSteal:CreateSlider({
		Name = 'Range',
		Min = 0,
		Max = 10,
		Default = 10,
		Suffix = function(val) 
			return val == 1 and 'stud' or 'studs' 
		end
	})
	Open = ChestSteal:CreateToggle({Name = 'GUI Check'})
end)
	
run(function()
	local AutoBuy
	local Sword
	local Armor
	local Pickaxe
	local Upgrades
	local UpgradeObjects = {}
	local Functions = {}
	
	local function buyCheck(currencytable)
		for i, v in Functions do 
			v(currencytable) 
		end
	end
	
	local function buyUpgrade(name, upgrade, currencytable)
		local currentitem
		for shopIndex, shopItem in upgrade.Items do
			if shopItem.ItemType == name then 
				currentitem = shopIndex 
			end
		end
		if not currentitem then return end
	
		for i = currentitem + 1, #upgrade.Items do
			local nextitem = upgrade.Items[i]
			if nextitem and currencytable[nextitem.CurrencyType] >= nextitem.Price then
				skywars.Remotes[remotes.purchaseItemUpgrade]:fire('Blacksmith', upgrade.ItemIndex)
				currencytable[nextitem.CurrencyType] -= nextitem.Price
			end
		end
	end
	
	local function buyTeamUpgrade(upgrade, currencytable)
		local currentitem = skywars.Store:getState().TeamUpgrades[upgrade.Name] or 0
		for i = currentitem + 1, #upgrade.Tiers do
			local nextitem = upgrade.Tiers[i]
			if nextitem and currencytable[nextitem.CurrencyType] >= nextitem.Price then
				skywars.Remotes[remotes.purchaseTeamUpgrade]:fire('Merchant', upgrade.ItemIndex)
				currencytable[nextitem.CurrencyType] -= nextitem.Price
			end
		end
	end
	
	AutoBuy = vape.Categories.Inventory:CreateModule({
		Name = 'AutoBuy',
		Function = function(callback)
			if callback then
				AutoBuy:Clean(vapeEvents.CurrencyChange.Event:Connect(buyCheck))
				buyCheck(table.clone(skywars.Store:getState().GameCurrency.Quantities))
			end
		end,
		Tooltip = 'Automatically buys items when you go near the shop'
	})
	Sword = AutoBuy:CreateToggle({
		Name = 'Buy Sword',
		Function = function(callback)
			Functions[2] = callback and function(currencytable, shop, upgrades)
				buyUpgrade(store.tools.sword and store.tools.sword.Name, skywars.Shop.Blacksmith.ItemUpgrades[2], currencytable)
			end or nil
		end,
		Default = true
	})
	Armor = AutoBuy:CreateToggle({
		Name = 'Buy Armor',
		Function = function(callback)
			Functions[1] = callback and function(currencytable, shop, upgrades)
				if lplr.Character then
					for _, v in lplr.Character:GetChildren() do
						if v:GetAttribute('Armour') and v.Name:find('Chestplate') then
							buyUpgrade(v.Name, skywars.Shop.Blacksmith.ItemUpgrades[1], currencytable)
							break
						end
					end
				end
			end or nil
		end,
		Default = true
	})
	Pickaxe = AutoBuy:CreateToggle({
		Name = 'Buy Pickaxe',
		Function = function(callback)
			Functions[3] = callback and function(currencytable, shop, upgrades)
				buyUpgrade(store.tools.pickaxe and store.tools.pickaxe.Name, skywars.Shop.Blacksmith.ItemUpgrades[3], currencytable)
			end or nil
		end,
		Default = true
	})
	Upgrades = AutoBuy:CreateToggle({
		Name = 'Buy Upgrades',
		Function = function(callback)
			for i, v in UpgradeObjects do
				v.Object.Visible = callback
			end
		end,
		Default = true
	})
	for i, v in skywars.Shop.Merchant.TeamUpgrades do
		table.insert(UpgradeObjects, AutoBuy:CreateToggle({
			Name = 'Buy '..v.Name,
			Function = function(callback)
				Functions[4 + i] = callback and function(currencytable, shop, upgrades)
					buyTeamUpgrade(v, currencytable)
				end or nil
			end,
			Darker = true,
			Default = (v.Name == 'Generator' or v.Name == 'Vampyrism')
		}))
	end
end)
	
run(function()
	local AutoConsume
	
	local function consumeCheck()
		if (lplr:GetAttribute('Shield') or 0) <= 0 and getItem('Shield') then
			skywars.Remotes[remotes.updateActiveItem]:fire('Shield')
			skywars.Remotes[remotes.usePowerUp]:fire()
			skywars.Remotes[remotes.updateActiveItem]:fire(store.hand.Name)
		end
	end
	
	AutoConsume = vape.Categories.Inventory:CreateModule({
		Name = 'AutoConsume',
		Function = function(callback)
			if callback then
				AutoConsume:Clean(vapeEvents.InventoryAmountChanged.Event:Connect(consumeCheck))
				AutoConsume:Clean(lplr:GetAttributeChangedSignal('Shield'):Connect(consumeCheck))
				consumeCheck()
			end
		end,
		Tooltip = 'Automatically uses shield potions.'
	})
end)
	
run(function()
	local Breaker
	local Range
	local BreakerPart
	local BreakerUI
	local BreakerRef = skywars.Roact.createRef()
	
	local function clean()
		if not BreakerUI then return end
		if BreakerPart then 
			BreakerPart:Destroy() 
		end
		skywars.Roact.unmount(BreakerUI)
		BreakerUI = nil
		BreakerPart = nil
	end
	
	local function customHealthbar(block, health, maxHealth, changeHealth)
		if not BreakerPart then
			local create = skywars.Roact.createElement
			local percent = math.clamp(health / maxHealth, 0, 1)
			local cleanCheck = true
			local part = Instance.new('Part')
			part.Size = Vector3.one
			part.CFrame = block.PrimaryPart.CFrame
			part.Transparency = 1
			part.Anchored = true
			part.CanCollide = false
			part.Parent = workspace
			BreakerPart = part
	
			BreakerUI = skywars.Roact.mount(create('BillboardGui', {
				Size = UDim2.fromOffset(249, 102),
				StudsOffset = Vector3.new(0, 2.5, 0),
				Adornee = part,
				MaxDistance = 40,
				AlwaysOnTop = true
			}, {
				create('Frame', {
					Size = UDim2.fromOffset(160, 50),
					Position = UDim2.fromOffset(44, 32),
					BackgroundColor3 = Color3.new(),
					BackgroundTransparency = 0.5
				}, {
					create('UICorner', {CornerRadius = UDim.new(0, 5)}),
					create('ImageLabel', {
						Size = UDim2.new(1, 89, 1, 52),
						Position = UDim2.fromOffset(-48, -31),
						BackgroundTransparency = 1,
						Image = getcustomasset('newvape/assets/new/blur.png'),
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(52, 31, 261, 502)
					}),
					create('TextLabel', {
						Size = UDim2.fromOffset(145, 14),
						Position = UDim2.fromOffset(13, 12),
						BackgroundTransparency = 1,
						Text = block.Name,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Top,
						TextColor3 = Color3.new(),
						TextScaled = true,
						Font = Enum.Font.Arial
					}),
					create('TextLabel', {
						Size = UDim2.fromOffset(145, 14),
						Position = UDim2.fromOffset(12, 11),
						BackgroundTransparency = 1,
						Text = block.Name,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Top,
						TextColor3 = color.Dark(uipallet.Text, 0.16),
						TextScaled = true,
						Font = Enum.Font.Arial
					}),
					create('Frame', {
						Size = UDim2.fromOffset(138, 4),
						Position = UDim2.fromOffset(12, 32),
						BackgroundColor3 = uipallet.Main
					}, {
						create('UICorner', {CornerRadius = UDim.new(1, 0)}),
						create('Frame', {
							[skywars.Roact.Ref] = BreakerRef,
							Size = UDim2.fromScale(percent, 1),
							BackgroundColor3 = Color3.fromHSV(math.clamp(percent / 2.5, 0, 1), 0.89, 0.75)
						}, {create('UICorner', {CornerRadius = UDim.new(1, 0)})})
					})
				})
			}), part)
	
			task.delay(5, clean)
		end
	
		local newpercent = math.clamp((health - changeHealth) / maxHealth, 0, 1)
		if newpercent == 0 then 
			clean() 
			return 
		end
		
		task.delay(0, function()
			local val = BreakerRef:getValue()
			if val then
				tweenService:Create(val, TweenInfo.new(0.3), {
					Size = UDim2.fromScale(newpercent, 1), 
					BackgroundColor3 = Color3.fromHSV(math.clamp(newpercent / 2.5, 0, 1), 0.89, 0.75)
				}):Play()
			end
		end)
	end
	
	Breaker = vape.Categories.Minigames:CreateModule({
		Name = 'Breaker',
		Function = function(callback)
			if callback then
				local eggs = collection('egg', Breaker)
				local currentblock
				local oldblockhealth = 0
				
				repeat
					if entitylib.isAlive and store.hand then
						local localPosition = entitylib.character.RootPart.Position
						for i, v in eggs do
							if v.PrimaryPart and (localPosition - v.PrimaryPart.Position).Magnitude < Range.Value then
								local hp = v:GetAttribute('Health') or 0
								if v:GetAttribute('TeamId') == lplr:GetAttribute('TeamId') then continue end
								if currentblock ~= v then
									oldblockhealth = hp
									currentblock = v
								end
	
								if hp ~= oldblockhealth then
									customHealthbar(v, oldblockhealth, 100, oldblockhealth - hp)
									oldblockhealth = hp
								end
	
								store.noShoot = tick() + 1
								if hp <= 0 then continue end
								if store.hand.Melee then 
									skywars.Remotes[remotes['MeleeController:attemptStrikeDesktop']]:fire(v)
								elseif store.hand.Pickaxe then 
									skywars.Remotes[remotes.hitBlock]:fire((v.PrimaryPart.Position + Vector3.new(0, 1.5, 0)) // 1)
								end
							end
						end
					end
					
					task.wait(0.016)
				until not Breaker.Enabled
			end
		end,
		Tooltip = 'Automatically destroys eggs around you'
	})
	Range = Breaker:CreateSlider({
		Name = 'Break range',
		Min = 1,
		Max = 40,
		Default = 40,
		Suffix = function(val) 
			return val == 1 and 'stud' or 'studs' 
		end
	})
end)
	
run(function()
	local Viewmodel
	local oldtool
	
	local function newCharacter(char)
		Viewmodel:Clean(char.Character.ChildAdded:Connect(function(obj)
			if obj:IsA('Tool') then 
				oldtool = obj
				ViewmodelTool = oldtool.Handle:Clone()
				ViewmodelTool.CanCollide = false
				ViewmodelTool.Massless = true
				ViewmodelTool.Anchored = true
				ViewmodelTool:ClearAllChildren()
				ViewmodelTool.Parent = gameCamera
				ViewmodelTool.LocalTransparencyModifier = 0
				oldtool.Handle.LocalTransparencyModifier = 1
			end
		end))
		
		Viewmodel:Clean(char.Character.ChildRemoved:Connect(function(obj)
			if obj == oldtool then 
				ViewmodelTool:Destroy()
				ViewmodelTool = nil
				oldtool = nil
			end
		end))
	end
	
	Viewmodel = vape.Legit:CreateModule({
		Name = 'Viewmodel',
		Function = function(callback)
			if callback then 
				ViewmodelMotor = Instance.new('Motor6D')
				vape:Clean(ViewmodelMotor)
				vape:Clean(runService.RenderStepped:Connect(function()
					if ViewmodelTool then 
						local dcf = ((CFrame.new(2.06, -2.44, -2.24) * CFrame.new(0.6, -0.2, -0.6)) * CFrame.Angles(math.rad(99), math.rad(2), math.rad(-4))) * ViewmodelMotor.C0
						local offsetcf = (CFrame.new(0, -0.15, -1.56) * CFrame.Angles(math.rad(-90), math.rad(-90), 0))
						ViewmodelTool.CFrame = ((gameCamera.CFrame * dcf) * offsetcf)
					end
				end))
				vape:Clean(entitylib.Events.LocalAdded:Connect(newCharacter))
				if entitylib.isAlive then 
					newCharacter(entitylib.character) 
				end
			else
				if ViewmodelTool then 
					ViewmodelTool:Destroy() 
				end
			end
		end,
		Tooltip = 'Replaces the default viewmodel'
	})
end)
	