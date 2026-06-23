local old

vape.Categories.Blatant:CreateModule({
	Name = 'NoFall',
	Function = function(callback)
		if callback then 
			old = hookfunction(bd.Blink.player_state.take_fall_damage.fire, function() end)
		else
			hookfunction(bd.Blink.player_state.take_fall_damage.fire, old)
			old = nil
		end
	end,
	Tooltip = 'Prevents taking fall damage.'
})