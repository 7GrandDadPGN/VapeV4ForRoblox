local AutoLeave

AutoLeave = vape.Categories.Utility:CreateModule({
	Name = 'AutoLeave',
	Function = function(callback)
		if callback then
			AutoLeave:Clean(bw.RemoteIndex.Victory_Show.OnClientEvent:Connect(function()
				replicatedStorage.GameEvents.BedWarsRemotes.Return_To_Lobby:FireServer()
			end))
		end
	end,
	Tooltip = 'Automatically leave after the match ends.'
})