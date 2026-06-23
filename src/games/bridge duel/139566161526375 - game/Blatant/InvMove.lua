local old

vape.Categories.Blatant:CreateModule({
	Name = 'InvMove',
	Function = function(callback)
		if callback then
			old = hookfunction(bd.MovementController.AddSpeedOverride, function(...)
				if select(2, ...) == 'MenuOpen' then
					return
				end

				return old(...)
			end)

			bd.MovementController:RemoveSpeedOverride('MenuOpen')
		else
			if old then
				hookfunction(bd.MovementController.AddSpeedOverride, old)
				old = nil
			end
		end
	end,
	Tooltip = 'Allows you to have continuous movement in menus'
})