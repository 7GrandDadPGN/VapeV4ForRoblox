vape.Categories.World:CreateModule({
	Name = 'Anti-AFK',
	Function = function(callback)
		if callback then
			for _, v in getconnections(lplr.Idled) do
				v:Disconnect()
			end

			for _, v in getconnections(runService.Heartbeat) do
				if type(v.Function) == 'function' and table.find(debug.getconstants(v.Function), remotes.AfkStatus) then
					v:Disconnect()
				end
			end

			bedwars.Client:Get(remotes.AfkStatus):SendToServer({
				afk = false
			})
		end
	end,
	Tooltip = 'Lets you stay ingame without getting kicked'
})