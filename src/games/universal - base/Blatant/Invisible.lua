local Invisible
local Dynamic
local oldcf
local animtrack
local proper = true
local params = RaycastParams.new()
params.RespectCanCollide = true

local function animationTrickery()
	if entitylib.isAlive then
		local isR15 = entitylib.character.Humanoid.RigType == Enum.HumanoidRigType.R15
		local anim = Instance.new('Animation')
		anim.AnimationId = 'rbxassetid://'..(isR15 and '18665825805' or '215384594')
		animtrack = entitylib.character.Humanoid.Animator:LoadAnimation(anim)
		animtrack.Priority = Enum.AnimationPriority.Action4
		animtrack:Play(0, 0.001, 0)
		anim:Destroy()

		task.delay(0, function()
			animtrack.TimePosition = isR15 and 1.95 or 0.4
		end)
	end
end

Invisible = vape.Categories.Blatant:CreateModule({
	Name = 'Invisible',
	Function = function(callback)
		if callback then
			animationTrickery()

			oldcf = nil
			local bindKey = httpService:GenerateGUID(true)
			runService:BindToRenderStep(bindKey, 0, function()
				if entitylib.isAlive and oldcf then
					entitylib.character.RootPart.CFrame = oldcf
					animtrack:AdjustWeight(0.001)
				end
			end)

			Invisible:Clean(function()
				runService:UnbindFromRenderStep(bindKey)
			end)

			Invisible:Clean(runService.Heartbeat:Connect(function(dt)
				task.defer(function()
					if entitylib.isAlive then
						local hum = entitylib.character.Humanoid
						local root = entitylib.character.RootPart
						local isR15 = hum.RigType == Enum.HumanoidRigType.R15
						local offset = isR15 and hum.HipHeight + (root.Size.Y / 2) or 0

						if hum.Sit then
							oldcf = nil
							return
						end

						if isR15 then
							if Dynamic.Enabled then
								params.FilterDescendantsInstances = {lplr.Character, gameCamera}
								params.CollisionGroup = root.CollisionGroup

								local ray = workspace:Blockcast(root.CFrame, Vector3.new(2, 0.1, 1), Vector3.new(0, -offset, 0), params)
								if ray then
									offset = (root.Position.Y - ray.Position.Y) - 1
								else
									offset = 0
								end
							else
								offset -= 1
							end
						end

						oldcf = root.CFrame
						root.CFrame = (root.CFrame - Vector3.new(0, offset, 0)) * CFrame.Angles(math.rad(isR15 and 180 or 90), 0, 0)
						animtrack:AdjustWeight(100)
					end
				end)
			end))

			Invisible:Clean(entitylib.Events.LocalAdded:Connect(function(char)
				local animator = char.Humanoid:WaitForChild('Animator', 1)
				if animator and Invisible.Enabled then
					oldroot = nil
					Invisible:Toggle()
					Invisible:Toggle()
				end
			end))
		else
			if animtrack then
				animtrack:Stop()
				animtrack:Destroy()
			end

			if entitylib.isAlive and oldcf then
				entitylib.character.RootPart.CFrame = oldcf
			end
		end
	end,
	Tooltip = 'Turns you invisible using animations.'
})
Dynamic = Invisible:CreateToggle({
	Name = 'Dynamic',
	Tooltip = 'Dynamically adjust your position to be as close to the ground as possible.',
	Default = true
})