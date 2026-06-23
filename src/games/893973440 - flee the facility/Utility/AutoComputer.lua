local AutoComputer
local connection, old

local function getConnection(event)
	local connection = getconnections(lstats.TimingGoalPosition.Changed)[1]
	if not connection then
		repeat
			connection = getconnections(lstats.TimingGoalPosition.Changed)[1]
			task.wait()
		until connection or not AutoComputer.Enabled
	end

	return AutoComputer.Enabled and connection
end


AutoComputer = vape.Categories.Utility:CreateModule({
	Name = 'AutoComputer',
	Function = function(callback)
		if callback then
			connection = getConnection()
			if not connection then return end

			old = hookfunction(connection.Function, function(...)
				if lplr.TempPlayerStatsModule.TimingGoalPosition.Value > 0 then
					replicatedStorage.RemoteEvent:FireServer('SetPlayerMinigameResult', true)
				end
			end)
		else
			if old and connection.Function then
				hookfunction(connection.Function, old)
			end
			connection = nil
		end
	end,
	Tooltip = 'Automatically complete the computer skill check.'
})