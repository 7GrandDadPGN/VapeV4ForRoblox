local Rejoin

Rejoin = vape.Categories.Utility:CreateModule({
	Name = 'Rejoin',
	Function = function(callback)
		if callback then
			notif('Rejoin', 'Rejoining...', 5)
			Rejoin:Toggle()

			if playersService.NumPlayers > 1 then
				teleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
			else
				teleportService:Teleport(game.PlaceId)
			end
		end
	end,
	Tooltip = 'Rejoins the server'
})