local AutoQueue

AutoQueue = vape.Categories.Utility:CreateModule({
	Name = 'AutoQueue',
	Function = function(callback)
		if callback then
			if workspace:GetAttribute('ServerType') == 'Lobby' then
				task.spawn(function()
					bw.RemoteIndex.Matchmaking_Request:InvokeServer('queue')
				end)
			end
		end
	end,
	Tooltip = 'Automatically queue in the lobby.'
})