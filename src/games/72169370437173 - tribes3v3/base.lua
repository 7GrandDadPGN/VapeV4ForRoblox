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
local textChatService = cloneref(game:GetService('TextChatService'))
local runService = cloneref(game:GetService('RunService'))
local guiService = cloneref(game:GetService('GuiService'))
local coreGui = cloneref(game:GetService('CoreGui'))
local contextActionService = cloneref(game:GetService('ContextActionService'))
local vim = cloneref(Instance.new('VirtualInputManager'))

local gameCamera = workspace.CurrentCamera
local lplr = playersService.LocalPlayer
local vape = shared.vape
local entitylib = vape.Libraries.entity
local whitelist = vape.Libraries.whitelist
local prediction = vape.Libraries.prediction
local targetinfo = vape.Libraries.targetinfo
local sessioninfo = vape.Libraries.sessioninfo
local getfontbounds = vape.Libraries.getfontbounds

local tribes = {}
local HitboxHook = {Hooks = {}}
local VelocityTracker = {Entries = setmetatable({}, {__mode = 'k'})}
local isMatch = false
local isVolt = false--identifyexecutor and identifyexecutor() == 'Volt' and trampoline_call and true or false
local clickQueue = {}
local clickThread = nil

local function canClickButton(target)
	if (not target.Visible) and (not guiService.MenuIsOpen) then
		return false
	end

	local pos = target.AbsolutePosition + target.AbsoluteSize / 2
	if gethui and gethui():IsA('BasePlayerGui') then
		for _, obj in gethui():GetGuiObjectsAtPosition(pos.X, pos.Y) do
			if obj:IsA('GuiButton') then
				return obj == target
			end
		end
	end

	for _, obj in coreGui:GetGuiObjectsAtPosition(pos.X, pos.Y) do
		if obj:IsA('GuiButton') then
			return obj == target
		end
	end

	for _, obj in lplr.PlayerGui:GetGuiObjectsAtPosition(pos.X, pos.Y) do
		if obj:IsA('GuiButton') then
			return obj == target
		end
	end

	return false
end

local function clickButton(obj)
	if not (obj and obj:IsA('TextButton')) then
		return
	end

	if not table.find(clickQueue, obj) then
		table.insert(clickQueue, obj)

		if not clickThread then
			task.spawn(function()
				clickThread = coroutine.running()

				repeat
					local i, button = next(clickQueue)
					if i then
						table.remove(clickQueue, i)

						if canClickButton(button) then
							local cPos = (button.AbsolutePosition + button.AbsoluteSize / 2) + guiService:GetGuiInset()

							if inputService.TouchEnabled then
								vim:SendTouchEvent(0, 0, cPos.X, cPos.Y)
								vim:SendTouchEvent(0, 2, cPos.X, cPos.Y)
							else
								vim:SendMouseButtonEvent(cPos.X, cPos.Y, 0, true, gui, 0)
								vim:SendMouseButtonEvent(cPos.X, cPos.Y, 0, false, gui, 0)
							end

							task.wait(0.016)
						end
					else
						clickThread = nil
						break
					end
				until false
			end)
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

local function isTarget(plr)
	return table.find(vape.Categories.Targets.ListEnabled, plr.Name) and true
end

local function notif(...)
	return vape:CreateNotification(...)
end

local function removeTags(str)
	str = str:gsub('<br%s*/>', '\n')
	return (str:gsub('<[^<>]->', ''))
end

run(function()
	entitylib.targetCheck = function(entity)
		if entity.NPC then return lplr:GetAttribute('Team') ~= entity.Character:GetAttribute('Team') end
		if isFriend(entity.Player) then return false end
		if not select(2, whitelist:get(entity.Player)) then return false end
		return lplr:GetAttribute('Team') ~= entity.Character:GetAttribute('Team')
	end

	entitylib.addPlayer = function(plr)

	end

	local oldstart = entitylib.start
	local function customEntity(entity)
		local plr = playersService:GetPlayerFromCharacter(entity)

		entity:GetAttributeChangedSignal('Team'):Connect(function()
			if plr ~= lplr and vape.Loaded ~= nil then
				entitylib.refreshEntity(entity, plr)
			end
		end)

		entitylib.addEntity(entity, plr)
	end

	entitylib.start = function()
		oldstart()
		if entitylib.Running then
			for _, entity in collectionService:GetTagged('Combatant') do
				customEntity(entity)
			end

			table.insert(entitylib.Connections, collectionService:GetInstanceAddedSignal('Combatant'):Connect(customEntity))
			table.insert(entitylib.Connections, collectionService:GetInstanceRemovedSignal('Combatant'):Connect(function(entity)
				entitylib.removeEntity(entity)
			end))
		end
	end
end)
entitylib.start()

run(function()
	tribes = {
		Camera = require(replicatedStorage.Shared.Camera),
		Combat = require(replicatedStorage.Shared.Combat),
		CombatController = require(lplr.PlayerScripts.Combat.Controller),
		Economy = require(lplr.PlayerScripts.UI.Economy),
		Melee = require(lplr.PlayerScripts.Combat.Handlers.Melee),
		Weapons = require(replicatedStorage.Shared.Weapons),
		Util = require(lplr.PlayerScripts.Combat.Util),
		UIState = require(lplr.PlayerScripts.UI.State),
		WeaponIcon = debug.getupvalue(require(lplr.PlayerScripts.UI.WeaponIcon).Init, 5),
		WeaponRedraw = debug.getupvalue(debug.getupvalue(debug.getupvalue(require(lplr.PlayerScripts.UI.WeaponIcon).Init, 5), 3), 8)
	}

	local cIndex = debug.getupvalue(tribes.CombatController.Equip, 11)
	cIndex = type(cIndex) == 'function' and debug.info(cIndex, 'n') == 'refreshEquipped' and 11 or 12

	tribes.State = debug.getupvalue(tribes.CombatController.State, 2)
	tribes.Handlers = debug.getupvalue(debug.getupvalue(tribes.CombatController.Equip, cIndex), 10)
	tribes.SetSpeed = debug.getupvalue(debug.getupvalue(tribes.CombatController.Equip, cIndex), 15)

	local kills = sessioninfo:AddItem('Kills')
	local deaths = sessioninfo:AddItem('Deaths')
	local games = sessioninfo:AddItem('Games')
	local wins = sessioninfo:AddItem('Wins')
	local winstreaks = sessioninfo:AddItem('Winstreaks', '', function()
		local streaks = {}

		for _, plr in playersService:GetPlayers() do
			if plr ~= lplr and (plr:GetAttribute('Streak') or 0) > 0 then
				table.insert(streaks, plr.Name..': '..plr:GetAttribute('Streak'))
			end
		end

		if #streaks > 0 then
			table.sort(streaks, function(a, b)
				return (tonumber(a:split(': ')[2]) or 0) > (tonumber(b:split(': ')[2]) or 0)
			end)

			return '\n'..table.concat(streaks, '\n')
		end

		return 'None'
	end, false)
	isMatch = not workspace:FindFirstChild('Lobby')

	if isMatch then
		task.delay(1, function()
			games:Increment()
		end)
	end

	vape:Clean(replicatedStorage.Remotes.HitConfirm.OnClientEvent:Connect(function(data)
		if data and data.killed and isMatch then
			kills:Increment()
		end
	end))

	vape:Clean(replicatedStorage.Remotes.MatchEvent.OnClientEvent:Connect(function(event, data)
		if isMatch then
			if event == 'MatchEnd' then
				local didWin = data and data.winnerTeam == lplr:GetAttribute('Team')
				if didWin then
					wins:Increment()
				end

				vapeEvents.MatchEnded:Fire(didWin)
			elseif event == 'Elimination' and data and data.victimId == 'p'..lplr.UserId then
				deaths:Increment()
			end
		end
	end))

	vape:Clean(task.spawn(function()
		repeat
			for _, entity in entitylib.List do
				if not VelocityTracker.Entries[entity.RootPart] then
					VelocityTracker.Entries[entity.RootPart] = {}
				end

				local entry = VelocityTracker.Entries[entity.RootPart]
				repeat
					local _, obj = next(entry)
					if obj and (os.clock() - obj[2]) > 0.5 then
						table.remove(entry, 1)
					else
						break
					end
				until false

				table.insert(entry, {entity.RootPart.AssemblyLinearVelocity, os.clock()})
			end

			task.wait()
		until false
	end))

	vape:Clean(function()
		table.clear(clickQueue)

		if clickThread then
			task.cancel(clickThread)
			clickThread = nil
		end
	end)
end)

run(function()
	local oldhitbox

	local function Hook(...)
		if setstackhidden and (not isVolt) then -- volt automatically hides the stack with hookfunction
			local ffunctions = {debug.info(1, 'f'), debug.info(2, 'f'), debug.info(3, 'f'), debug.info(4, 'f'), debug.info(5, 'f')}
			for _, func in ffunctions do
				if isexecutorclosure(func) then
					setstackhidden(func, true)
				end
			end

			table.clear(ffunctions)
		end

		local args = table.pack(...)
		for _, v in HitboxHook.Hooks do
			if v[2](args) then return end
		end

		return oldhitbox(unpack(args, 1, args.n))
	end

	function HitboxHook:Add(key, val, priority)
		table.insert(self.Hooks, {key, val, priority or 0})
		table.sort(self.Hooks, function(a, b)
			return a[3] < b[3]
		end)

		if not oldhitbox then
			oldhitbox = hookfunction(tribes.Melee.Detect, function(...)
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

		if oldhitbox and not next(self.Hooks) then
			if restorefunction then
				restorefunction(tribes.Melee.Detect)
			else
				hookfunction(tribes.Melee.Detect, oldhitbox)
			end

			oldhitbox = nil
		end
	end

	function VelocityTracker:Get(root, diff)
		local entry = self.Entries[root]

		if entry and diff then
			local final, count = Vector3.zero, 0
			local ctime = os.clock()

			for _, velo in entry do
				if (ctime - velo[2]) <= diff then
					final += velo[1]
					count += 1
				end
			end

			if count > 0 then
				final /= count
				return Vector3.new(final.X, root.AssemblyLinearVelocity.Y, final.Z)
			end
		end

		return root.AssemblyLinearVelocity
	end
end)

for _, v in {'AutoClicker', 'TriggerBot', 'HitBoxes', 'Jesus', 'AutoRejoin', 'Disabler', 'MurderMystery', 'Parkour', 'Wallhop'} do
	vape:Remove(v)
end