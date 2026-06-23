local MissCooldown
local index = game.PlaceId ~= 16483433878 and 20 or 53

MissCooldown = vape.Categories.Combat:CreateModule({
	Name = 'MissCooldown',
	Function = function(callback)
		if callback then
			debug.setconstant(bt.BattleClient.input, index, 0)
		else
			debug.setconstant(bt.BattleClient.input, index, 0.2)
		end
	end,
	Tooltip = 'Remove the cooldown when missing a block or action.'
})