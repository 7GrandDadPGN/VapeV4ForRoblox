local old

vape.Categories.Blatant:CreateModule({
	Name = 'NoSlowdown',
	Function = function(callback)
		local modifier = bedwars.SprintController:getMovementStatusModifier()
		if callback then
			old = modifier.addModifier
			modifier.addModifier = function(self, tab)
				if tab.moveSpeedMultiplier then
					tab.moveSpeedMultiplier = math.max(tab.moveSpeedMultiplier, 1)
				end
				return old(self, tab)
			end

			for i in modifier.modifiers do
				if (i.moveSpeedMultiplier or 1) < 1 then
					modifier:removeModifier(i)
				end
			end
		else
			modifier.addModifier = old
			old = nil
		end
	end,
	Tooltip = 'Prevents slowing down when using items.'
})