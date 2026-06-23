local old, oldcheck

vape.Categories.Blatant:CreateModule({
	Name = 'NoSlowdown',
	Function = function(callback)
		if callback then
			old = skywars.HumanoidController.addSpeedModifier
			oldcheck = skywars.SprintingController.setCanSprint

			skywars.HumanoidController.addSpeedModifier = function(self, index, speed)
				speed = math.max(speed, 1)
				return old(self, index, speed)
			end

			skywars.SprintingController.setCanSprint = function(self, canSprint)
				return oldcheck(self, true)
			end

			for i, v in skywars.HumanoidController.speedModifiers do
				if v < 1 then
					skywars.HumanoidController:removeSpeedModifier(i)
				end
			end

			skywars.SprintingController:setCanSprint(true)
			skywars.SprintingController:enableSprinting()
		else
			skywars.HumanoidController.addSpeedModifier = old
			skywars.SprintingController.setCanSprint = oldcheck
			old = nil
			oldcheck = nil
		end
	end,
	Tooltip = 'Prevents slowing down when using items.'
})