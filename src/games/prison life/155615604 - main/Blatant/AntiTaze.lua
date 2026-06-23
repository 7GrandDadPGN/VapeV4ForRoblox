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