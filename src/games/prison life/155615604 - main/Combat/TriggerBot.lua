local TriggerBot
local Targets
local rayParams = RaycastParams.new()
rayParams.CollisionGroup = 'ClientBullet'
rayParams.FilterType = Enum.RaycastFilterType.Exclude

local function getTriggerBotTarget()
	rayParams.FilterDescendantsInstances = {lplr.Character}
	if entitylib.isAlive then
		local tool = debug.getupvalue(oldshoot or pl.Shoot, 1)
		local data = debug.getupvalue(oldshoot or pl.Shoot, 10)

		if tool and data and data.Range then
			local posX, posY
			if inputService.MouseBehavior == Enum.MouseBehavior.LockCenter then
				posX = gameCamera.ViewportSize.X / 2
				posY = gameCamera.ViewportSize.Y / 2
			else
				local location = inputService:GetMouseLocation()
				posX = location.X
				posY = location.Y
			end

			local hitPos
			local rayPos = gameCamera:ViewportPointToRay(posX, posY)
			local ray = workspace:Raycast(rayPos.Origin, rayPos.Direction * 1500, rayParams)
			local vEntity

			for _, entity in entitylib.List do
				if entity.Targetable and entity.Character and (Targets.Players.Enabled and entity.Player or Targets.NPCs.Enabled and entity.NPC) and entitylib.isVulnerable(entity, true) and ray.Instance:IsDescendantOf(entity.Character) then
					vEntity = entity
					break
				end
			end

			if vEntity then
				local origin = entitylib.character.Head.Position
				local hitCheck = workspace:Raycast(origin, (ray.Position - origin), rayCheck)
				if hitCheck and hitCheck.Instance:IsDescendantOf(vEntity.Character) and (ray.Position - origin).Magnitude <= data.Range then
					return vEntity
				end
			end
		end
	end
end

TriggerBot = vape.Categories.Combat:CreateModule({
	Name = 'TriggerBot',
	Function = function(callback)
		if callback then
			repeat
				if getTriggerBotTarget() then
					local obj = {UserInputState = Enum.UserInputState.Begin, UserInputType = Enum.UserInputType.MouseButton1, Position = Vector3.zero}
					task.spawn(pl.Shoot, obj)
					obj.UserInputState = Enum.UserInputState.End
				end

				task.wait()
			until not TriggerBot.Enabled
		end
	end,
	Tooltip = 'Shoots people that enter your crosshair'
})
Targets = TriggerBot:CreateTargets({
	Players = true,
	NPCs = true
})