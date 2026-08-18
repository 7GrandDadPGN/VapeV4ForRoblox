local TriggerBot
local Targets
local ShootDelay
local Distance
local rayCheck, delayCheck = RaycastParams.new(), os.clock()

local function getTriggerBotTarget()
	rayCheck.FilterDescendantsInstances = {lplr.Character, gameCamera}

	local ray = workspace:Raycast(gameCamera.CFrame.Position, gameCamera.CFrame.LookVector * Distance.Value, rayCheck)
	if ray and ray.Instance then
		for _, entity in entitylib.List do
			if entity.Targetable and entity.Character and (Targets.Players.Enabled and entity.Player or Targets.NPCs.Enabled and entity.NPC) then
				if ray.Instance:IsDescendantOf(entity.Character) then
					return entitylib.isVulnerable(entity) and entity
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
				if mouse1click and (isrbxactive or iswindowactive)() then
					if getTriggerBotTarget() and canClick() then
						if delayCheck < os.clock() then
							if mouseClicked then
								mouse1release()
								delayCheck = os.clock() + ShootDelay.Value
							else
								mouse1press()
							end

							mouseClicked = not mouseClicked
						end
					else
						if mouseClicked then
							mouse1release()
						end
						mouseClicked = false
					end
				end

				task.wait()
			until not TriggerBot.Enabled
		else
			if mouse1click and (isrbxactive or iswindowactive)() then
				if mouseClicked then
					mouse1release()
				end
			end

			mouseClicked = false
		end
	end,
	Tooltip = 'Shoots people that enter your crosshair'
})
Targets = TriggerBot:CreateTargets({
	Players = true,
	NPCs = true
})
ShootDelay = TriggerBot:CreateSlider({
	Name = 'Next Shot Delay',
	Min = 0,
	Max = 1,
	Decimal = 100,
	Suffix = function(val)
		return val == 1 and 'second' or 'seconds'
	end,
	Tooltip = 'The delay set after shooting a target'
})
Distance = TriggerBot:CreateSlider({
	Name = 'Distance',
	Min = 0,
	Max = 1000,
	Default = 1000,
	Suffix = function(val)
		return val == 1 and 'stud' or 'studs'
	end
})