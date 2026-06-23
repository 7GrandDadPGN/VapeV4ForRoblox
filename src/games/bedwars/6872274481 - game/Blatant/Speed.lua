local Speed
local Value
local WallCheck
local AutoJump
local AlwaysJump
local rayCheck = RaycastParams.new()
rayCheck.RespectCanCollide = true

Speed = vape.Categories.Blatant:CreateModule({
	Name = 'Speed',
	Function = function(callback)
		frictionTable.Speed = callback or nil
		updateVelocity()
		pcall(function()
			debug.setconstant(bedwars.WindWalkerController.updateSpeed, 7, callback and 'constantSpeedMultiplier' or 'moveSpeedMultiplier')
		end)

		if callback then
			Speed:Clean(runService.PreSimulation:Connect(function(dt)
				bedwars.StatefulEntityKnockbackController.lastImpulseTime = callback and math.huge or time()
				if entitylib.isAlive and not Fly.Enabled and not InfiniteFly.Enabled and not LongJump.Enabled and isnetworkowner(entitylib.character.RootPart) then
					local state = entitylib.character.Humanoid:GetState()
					if state == Enum.HumanoidStateType.Climbing then return end

					local root, velo = entitylib.character.RootPart, getSpeed()
					local moveDirection = AntiFallDirection or entitylib.character.Humanoid.MoveDirection
					local destination = (moveDirection * math.max(Value.Value - velo, 0) * dt)

					if WallCheck.Enabled then
						rayCheck.FilterDescendantsInstances = {lplr.Character, gameCamera}
						rayCheck.CollisionGroup = root.CollisionGroup
						local ray = workspace:Raycast(root.Position, destination, rayCheck)
						if ray then
							destination = ((ray.Position + ray.Normal) - root.Position)
						end
					end

					root.CFrame += destination
					root.AssemblyLinearVelocity = (moveDirection * velo) + Vector3.new(0, root.AssemblyLinearVelocity.Y, 0)
					if AutoJump.Enabled and (state == Enum.HumanoidStateType.Running or state == Enum.HumanoidStateType.Landed) and moveDirection ~= Vector3.zero and (Attacking or AlwaysJump.Enabled) then
						entitylib.character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
					end
				end
			end))
		end
	end,
	ExtraText = function()
		return 'Heatseeker'
	end,
	Tooltip = 'Increases your movement with various methods.'
})
Value = Speed:CreateSlider({
	Name = 'Speed',
	Min = 1,
	Max = 23,
	Default = 23,
	Suffix = function(val)
		return val == 1 and 'stud' or 'studs'
	end
})
WallCheck = Speed:CreateToggle({
	Name = 'Wall Check',
	Default = true
})
AutoJump = Speed:CreateToggle({
	Name = 'AutoJump',
	Function = function(callback)
		AlwaysJump.Object.Visible = callback
	end
})
AlwaysJump = Speed:CreateToggle({
	Name = 'Always Jump',
	Visible = false,
	Darker = true
})