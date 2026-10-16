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
local textChatService = cloneref(game:GetService('TextChatService'))
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

local tribes = {}

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

run(function()
	entitylib.targetCheck = function(entity)
		if entity.TeamCheck then
			return entity:TeamCheck()
		end
		if entity.NPC then return true end
		if isFriend(entity.Player) then return false end
		if not select(2, whitelist:get(entity.Player)) then return false end
		return lplr:GetAttribute('Team') ~= entity.Player:GetAttribute('Team')
	end

	entitylib.addPlayer = function(plr)
		if plr.Character then
			entitylib.refreshEntity(plr.Character, plr)
		end

		entitylib.PlayerConnections[plr] = {
			plr.CharacterAdded:Connect(function(char)
				entitylib.refreshEntity(char, plr, os.clock() + 0.4)
			end),
			plr.CharacterRemoving:Connect(function(char)
				entitylib.removeEntity(char, plr == lplr)
			end),
			plr:GetAttributeChangedSignal('Team'):Connect(function()
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
					if entity then
						entitylib.refreshEntity(entity.Character, plr)
					end
				end
			end)
		}
	end

	local oldstart = entitylib.start
	local function customEntity(entity)
		if playersService:GetPlayerFromCharacter(entity) then
			return
		end

		entitylib.addEntity(entity, nil, function(self)
			return lplr:GetAttribute('Team') ~= self.Character:GetAttribute('Team')
		end)
	end

	entitylib.start = function()
		oldstart()
		if entitylib.Running then
			for _, ent in collectionService:GetTagged('Combatant') do
				customEntity(ent)
			end

			table.insert(entitylib.Connections, collectionService:GetInstanceAddedSignal('Combatant'):Connect(customEntity))
			table.insert(entitylib.Connections, collectionService:GetInstanceRemovedSignal('Combatant'):Connect(function(ent)
				entitylib.removeEntity(ent)
			end))
		end
	end
end)
entitylib.start()

run(function()
	tribes = {
		Combat = require(replicatedStorage.Shared.Combat),
		CombatController = require(lplr.PlayerScripts.Combat.Controller),
		Weapons = require(replicatedStorage.Shared.Weapons),
		Util = require(lplr.PlayerScripts.Combat.Util)
	}

	tribes.State = debug.getupvalue(tribes.CombatController.State, 2)
	tribes.SetSpeed = debug.getupvalue(debug.getupvalue(tribes.CombatController.Equip, 11), 15)
end)