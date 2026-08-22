local loadstring = function(...)
	local res, err = loadstring(...)
	if err and vape then vape:CreateNotification('Vape', 'Failed to load : '..err, 30, 'alert') end
	return res
end
local isfile = isfile or function(file)
	local suc, res = pcall(function() return readfile(file) end)
	return suc and res ~= nil and res ~= ''
end
local function downloadFile(path, func)
	if not isfile(path) then
		local suc, res = pcall(function() return game:HttpGet('https://raw.githubusercontent.com/7GrandDadPGN/VapeCompiled/'..readfile('newvape/profiles/commit.txt')..'/'..select(1, path:gsub('newvape/', '')), true) end)
		if not suc or res == '404: Not Found' then error(res) end
		if path:find('.lua') then res = '--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.\n'..res end
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

local playersService = cloneref(game:GetService('Players'))
local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local runService = cloneref(game:GetService('RunService'))
local inputService = cloneref(game:GetService('UserInputService'))
local textService = cloneref(game:GetService('TextService'))
local tweenService = cloneref(game:GetService('TweenService'))
local teamsService = cloneref(game:GetService('Teams'))
local collectionService = cloneref(game:GetService('CollectionService'))
local contextService = cloneref(game:GetService('ContextActionService'))

local gameCamera = workspace.CurrentCamera
local lplr = playersService.LocalPlayer

local vape = shared.vape
local entitylib = vape.Libraries.entity
local whitelist = vape.Libraries.whitelist
local prediction = vape.Libraries.prediction
local targetinfo = vape.Libraries.targetinfo
local sessioninfo = vape.Libraries.sessioninfo
local vm = loadstring(downloadFile('newvape/libraries/vm.lua'), 'vm')()

local jb = {}
local InfNitro = {Enabled = false}
local LazerGodmode = {Enabled = false}
local InvTracker = {Inventories = {}, Connections = {}}
local oldBulletUpdate

local function getVehicle(entity)
	if entity.Player then
		for _, car in collectionService:GetTagged('Vehicle') do
			for _, seat in car:GetChildren() do
				if (seat.Name == 'Seat' or seat.Name == 'Passenger') then
					seat = seat:FindFirstChild('PlayerName')
					if seat and seat.Value == entity.Player.Name then
						return car
					end
				end
			end
		end
	end
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

local function isIllegal(entity)
	if entity.Player and entity.Player.Team == teamsService.Prisoner then
		for tool in InvTracker.Inventories[entity.Player] do
			if tool ~= 'MansionInvite' and tool ~= 'Donut' then
				return true
			end
		end

		return entity.Illegal
	end

	return true
end

local function isTarget(plr)
	return table.find(vape.Categories.Targets.ListEnabled, plr.Name) and true
end

local function notif(...)
	return vape:CreateNotification(...)
end

local OriginScanner = {Cache = {}}
run(function()
	local rayParams = RaycastParams.new()
	local overlapParams = OverlapParams.new()
	rayParams.RespectCanCollide = true
	rayParams.FilterType = Enum.RaycastFilterType.Exclude
	overlapParams.RespectCanCollide = true
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

	local function checkPoint(pos, params)
		for _, part in workspace:GetPartBoundsInRadius(pos, 0, params) do
			if part.CanCollide and (part:GetClosestPointOnSurface(pos) - pos).Magnitude <= 0.0001 then
				return false
			end
		end

		return true
	end

	function OriginScanner:Scan(origin, target, extra, part)
		local scanPositions = {}
		local diff = CFrame.lookAt(origin * Vector3.new(1, 0, 1), target * Vector3.new(1, 0, 1)).LookVector

		if OriginScanner.Cache[part] then
			return table.unpack(OriginScanner.Cache[part])
		end

		if extra then
			if (origin - extra).Magnitude < 14 then
				table.insert(scanPositions, extra)
			end
		end

		if #scanPositions <= 0 then
			for _, offset in positions do
				if (offset * Vector3.new(1, 0, 1)):Dot(diff) > -0.5 then
					table.insert(scanPositions, origin + offset * 14)
				end
			end
		end

		for _, pos in scanPositions do
			local ray = workspace:Raycast(target, (pos - target), rayParams)

			if not ray and checkPoint(target, overlapParams) then
				OriginScanner.Cache[part] = {pos}
				return pos
			end
		end
	end

	function OriginScanner:UpdateIgnore(model)
		local ignore = {lplr.Character, workspace.Items, model}
		for _, entity in entitylib.List do
			table.insert(ignore, entity.Character)
		end

		rayParams.FilterDescendantsInstances = ignore
		overlapParams.FilterDescendantsInstances = ignore
	end
end)

run(function()
	function InvTracker:AddInventory(inventory)
		local plr = inventory.Parent
		if plr and plr:IsA('Player') then
			self.Inventories[plr] = {}
			self.Connections[inventory] = {
				inventory.ChildAdded:Connect(function(tool)
					self.Inventories[plr][tool.Name] = tool
				end),
				inventory.ChildRemoved:Connect(function(tool)
					self.Inventories[plr][tool.Name] = nil
				end),
				inventory.Destroying:Once(function()
					for _, connection in self.Connections[inventory] do
						connection:Disconnect()
					end

					table.clear(self.Connections[inventory])
					table.clear(self.Inventories[plr])
					self.Inventories[plr] = nil
				end)
			}

			for _, tool in inventory:GetChildren() do
				self.Inventories[plr][tool.Name] = tool
			end
		end
	end

	for _, inventory in collectionService:GetTagged('Inventory') do
		InvTracker:AddInventory(inventory)
	end

	vape:Clean(collectionService:GetInstanceAddedSignal('Inventory'):Connect(function(inventory)
		InvTracker:AddInventory(inventory)
	end))

	vape:Clean(function()
		for _, connections in InvTracker.Connections do
			for _, connection in connections do
				connection:Disconnect()
			end
		end

		table.clear(InvTracker.Connections)
		table.clear(InvTracker.Inventories)
	end)
end)

run(function()
	local function getMousePosition()
		if inputService.TouchEnabled then
			return gameCamera.ViewportSize / 2
		end

		return inputService:GetMouseLocation()
	end

	entitylib.getUpdateConnections = function(entity)
		local hum = entity.Humanoid
		entity.Illegal = entity.Character:GetAttribute('InVehicle')

		return {
			hum:GetPropertyChangedSignal('Health'),
			hum:GetPropertyChangedSignal('MaxHealth'),
			entity.Character:GetAttributeChangedSignal('InVehicle'),
			entity.Character:GetAttributeChangedSignal('HasHandcuffs'),
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
		if entity.TeamCheck then return entity:TeamCheck() end
		if entity.NPC then return true end
		if isFriend(entity.Player) then return false end
		if not select(2, whitelist:get(entity.Player)) then return false end

		if lplr.Team == teamsService.Police then
			return entity.Player.Team ~= teamsService.Police
		else
			return entity.Player.Team == teamsService.Police
		end

		return true
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
	local function dumpRemotes(scripts, renamed)
		local returned = {}

		for _, scr in scripts do
			local deserializedcode = vm.luau_deserialize(getscriptbytecode(scr))

			for _, proto in deserializedcode.protoList do
				local stack, top, code = {}, -1, proto.code
				for i, inst in code do
					if inst.opcode == 4 then -- LOADN
						stack[inst.A] = inst.D
					elseif inst.opcode == 5 then -- LOADK
						stack[inst.A] = inst.K
					elseif inst.opcode == 6 then -- MOVE
						stack[inst.A] = stack[inst.B]
					elseif inst.opcode == 12 then -- GETIMPORT
						local count, import = inst.KC, getrenv()[inst.K0]

						if count == 1 then
							stack[inst.A] = import
						elseif count == 2 then
							stack[inst.A] = import[inst.K1]
						elseif count == 3 then
							stack[inst.A] = import[inst.K1][inst.K2]
						end
					elseif inst.opcode == 20 then -- NAMECALL
						local A, B, kv = inst.A, inst.B, inst.K
						stack[A + 1] = stack[B]

						local callInst = code[i + 2]
						local callA, callB, callC = callInst.A, callInst.B, callInst.C
						local params = if callB == 0 then top - callA else callB - 1
						if kv == 'sub' or kv == 'reverse' then
							local arg1, arg2, arg3 = table.unpack(stack, callA + 1, callA + params)
							if kv == 'reverse' and not arg1 then arg1 = 'a' end

							local ret_list = table.pack(string[kv](arg1, arg2, arg3))
							local ret_num = ret_list.n - 1
							if callC == 0 then
								top = callA + ret_num - 1
							else
								ret_num = callC - 1
							end

							table.move(ret_list, 1, ret_num, callA, stack)
						elseif kv == 'FireServer' then
							local name, val = proto.debugname == '(??)' and scr.Name or proto.debugname, stack[callA + 2]
							if name == val then table.insert(returned, val) continue end
							if returned[name] then
								for i = 1, 10 do
									if not returned[name..i] then name ..= i break end
								end
							end

							returned[name] = val
						end
					elseif inst.opcode == 49 then -- CONCAT
						local s = ""
						for i = inst.B, inst.C do
							if type(stack[i]) ~= 'string' then continue end
							s ..= stack[i]
						end
						stack[inst.A] = s
					end
				end
			end
		end

		for i, v in table.clone(returned) do
			if renamed[i] then
				returned[i] = nil
				returned[renamed[i]] = v
			end
		end

		return returned
	end

	local function getAwardEvent()
		for _, callback in debug.getupvalue(jb.TeamChooseController.Init, 2) do
			if type(callback) == 'function' then
				for _, const in debug.getconstants(callback) do
					if tostring(const):find('PlusCash') then
						return callback
					end
				end
			end
		end
	end

	local function toMoney(num)
		local one, two, three = string.match(tostring(num), '^([^%d]*%d)(%d*)(.-)$')
		return one .. (two:reverse():gsub('(%d%d%d)', '%1,'):reverse() .. three)..'$'
	end

	jb = {
		Audio = require(replicatedStorage.Std.Audio),
		BulletEmitter = require(replicatedStorage.Game.ItemSystem.BulletEmitter),
		CircleAction = require(replicatedStorage.Module.UI).CircleAction,
		FallingController = require(replicatedStorage.Game.Falling),
		GunController = require(replicatedStorage.Game.Item.Gun),
		InventoryItemBinder = require(replicatedStorage.Inventory.InventoryItemBinder),
		ItemSystemController = require(replicatedStorage.Game.ItemSystem.ItemSystem),
		LightningUtils = require(replicatedStorage.Game.LightningUtils),
		PlayerUtils = require(replicatedStorage.Game.PlayerUtils),
		TeamChooseController = require(replicatedStorage.TeamSelect.TeamChooseUI),
		VehicleController = require(replicatedStorage.Vehicle.VehicleUtils)
	}

	if not jb.VehicleController.toggleLocalLocked or not jb.VehicleController.NitroShopVisible then
		repeat
			task.wait()
		until (jb.VehicleController.toggleLocalLocked and jb.VehicleController.NitroShopVisible) or vape.Loaded == nil

		if vape.Loaded == nil then
			return
		end
	end

	local remotetable = debug.getupvalue(jb.VehicleController.toggleLocalLocked, 2)
	local fireserver, hook = remotetable.FireServer

	remotes = dumpRemotes({
		replicatedStorage.Game.TrainSystem.LocomotiveFront,
		replicatedStorage.Game.ItemSystem.ItemSystem,
		replicatedStorage.Game.CashBuyUI,
		replicatedStorage.Game.Item.Taser,
		replicatedStorage.Game.Item.Donut,
		replicatedStorage.Game.Item.Gun,
		replicatedStorage.Game.Falling,
		lplr.PlayerScripts.LocalScript
	}, {
		Action = 'Pickup',
		Action3 = 'StartRob',
		Action2 = 'EndRob',
		AttemptArrest = 'Arrest',
		attemptPunch = 'Punch',
		AttemptVehicleEject = 'Eject',
		AttemptVehicleEnter = 'GetIn',
		BroadcastInputBegan = 'InputBegan',
		BroadcastInputEnded = 'InputEnded',
		CalculateDelta = 'UseNitro',
		Draw = 'TaseReplicate',
		Gun = 'PopTires',
		LocalScript2 = 'LookAngle',
		LocalScript = 'SelfDamage',
		onPressed = 'FlipVehicle',
		OnJump = 'GetOut',
		OnJump1 = 'GetOut',
		UpdateMousePosition = 'AimPosition'
	})

	local function FireServerHook(...)
		local self, id = ...
		local remote
		for name, key in remotes do
			if key == id then
				remote = name
			end
		end

		if InfNitro.Enabled and remote == 'UseNitro' then return end
		if LazerGodmode.Enabled and remote == 'SelfDamage' then return end
		if remote ~= 'LookAngle' and remote ~= 'AimPosition' and shared.VapeDeveloper then
			local called = getfenv(3)
			called = called and called.script
			if called and (not remote) then
				print(id, 'called with', called:GetFullName())
			end

			print(id, remote or id, ...)
		end

		return hook(...)
	end

	hook = hookfunction(fireserver, function(...)
		return FireServerHook(...)
	end)

	function jb:FireServer(id, ...)
		if not remotes[id] then
			notif('Vape', 'Failed to find remote ('..id..')', 10, 'alert')
			return
		end

		return hook(remotetable, remotes[id], ...)
	end

	local arrests = sessioninfo:AddItem('Arrested')
	local moneymade = sessioninfo:AddItem('Money Made', 0, toMoney, true)
	local bounty = sessioninfo:AddItem('Bounty List', '', function()
		local board = workspace:FindFirstChild('BountyBoard', true)
		board = board and board:FindFirstChild('MostWanted', true)
		board = board and board:FindFirstChild('Board', true)

		local text = ''

		for _, obj in (board and board:GetChildren() or {}) do
			if obj:IsA('Frame') then
				local plrname = obj:FindFirstChild('NameText', true)
				local bounty = obj:FindFirstChild('BountyText', true)

				if plrname and bounty then
					text = text..'\n'..(plrname.Text..': '..bounty.Text:gsub(' Bounty', ''))
				end
			end
		end

		return text
	end, false)

	local awardCallback = getAwardEvent()
	if awardCallback then
		local hook
		hook = hookfunction(awardCallback, function(amount, text, ...)
			moneymade:Increment(amount)
			if text == 'Arrest' then
				arrests:Increment()
			end

			return hook(amount, text, ...)
		end)

		vape:Clean(function()
			restorefunction(awardCallback)
		end)
	end

	vape:Clean(runService.RenderStepped:Connect(function()
		table.clear(OriginScanner.Cache)
	end))

	vape:Clean(entitylib.Events.EntityUpdated:Connect(function(entity)
		entity.Illegal = entity.Illegal or entity.Character:GetAttribute('InVehicle')

		if entity.Character:GetAttribute('HasHandcuffs') then
			entity.Illegal = false
		end
	end))

	vape:Clean(function()
		table.clear(remotes)
		table.clear(jb)
		restorefunction(fireserver)
	end)
end)

for _, v in {'Reach', 'TriggerBot', 'Disabler', 'AntiFall', 'HitBoxes', 'Killaura', 'MurderMystery'} do
	vape:Remove(v)
end