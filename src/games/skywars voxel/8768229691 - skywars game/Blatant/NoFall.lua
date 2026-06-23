local NoFall
local rayCheck = RaycastParams.new()

NoFall = vape.Categories.Blatant:CreateModule({
	Name = 'NoFall',
	Function = function(callback)
		if callback then
			repeat
				local waitdelay = 0
				if entitylib.isAlive then
					local hum = entitylib.character.Humanoid
					if (entitylib.character.GroundPosition.Y - entitylib.character.RootPart.Position.Y) > 10 then
						rayCheck.FilterDescendantsInstances = {lplr.Character, gameCamera}
						local ray = workspace:Raycast(entitylib.character.RootPart.Position, Vector3.new(0, -(entitylib.character.HipHeight + 10), 0), rayCheck)
						if not ray then
							hum:ChangeState(Enum.HumanoidStateType.Ragdoll)
							task.wait(0.1)
							hum:ChangeState(Enum.HumanoidStateType.Running)
							waitdelay = 0.05
						end
					end
				end
				task.wait(waitdelay)
			until not NoFall.Enabled
		end
	end,
	Tooltip = 'Prevents taking fall damage.'
})