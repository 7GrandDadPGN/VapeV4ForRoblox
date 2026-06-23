local AutoPlay
local Delay

AutoPlay = vape.Categories.Utility:CreateModule({
	Name = 'AutoPlay',
	Function = function(callback)
		if callback then
			AutoPlay:Clean(bd.Blink.game_state.team_won.on(function()
				if bd.ServerData.Submode ~= 'Playground' then
					bd.MatchController:EnterQueue(bd.ServerData.Submode)
				end
			end))
		end
	end,
	Tooltip = 'Automatically queues after the match ends.'
})