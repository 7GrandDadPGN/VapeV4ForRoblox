local old

vape.Categories.Blatant:CreateModule({
	Name = 'Criticals',
	Function = function(callback)
		if callback then
			old = hookfunction(bd.Blink.item_action.attack_entity.fire, function(...)
				local data = ...
				if type(data) == 'table' then
					rawset(data, 'is_crit', true)
				end

				return old(...)
			end)
		else
			hookfunction(bd.Blink.item_action.attack_entity.fire, old)
			old = nil
		end
	end,
	Tooltip = 'Always hit criticals'
})