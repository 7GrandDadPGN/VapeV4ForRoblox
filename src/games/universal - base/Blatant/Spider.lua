local Mode
local Value
local State
local rayCheck = RaycastParams.new()
rayCheck.RespectCanCollide = true
local Active, Truss

Spider = vape.Categories.Blatant:CreateModule({
	Name = 'Spider',
	Function = function(callback)
		if callback then
			if Truss then
				Truss.Parent = gameCamera
			end

			Spider:Clean(runService.PreSimulation:Connect(function(dt)
				if entitylib.isAlive then
					local root = entitylib.character.RootPart
					local chars = {gameCamera, lplr.Character, Truss}
					for _, v in entitylib.List do
						table.insert(chars, v.Character)
					end

					SpiderShift = inputService:IsKeyDown(Enum.KeyCode.LeftShift)
					rayCheck.FilterDescendantsInstances = chars
					rayCheck.CollisionGroup = root.CollisionGroup

					if Mode.Value ~= 'Part' then
						local vec = entitylib.character.Humanoid.MoveDirection * 2.5
						local ray = workspace:Raycast(root.Position - Vector3.new(0, entitylib.character.HipHeight - 0.5, 0), vec, rayCheck)
						if Active and not ray then
							root.Velocity = Vector3.new(root.Velocity.X, 0, root.Velocity.Z)
						end

						Active = ray
						if Active and ray.Normal.Y == 0 then
							if not Phase.Enabled or not SpiderShift then
								if State.Enabled then
									entitylib.character.Humanoid:ChangeState(Enum.HumanoidStateType.Climbing)
								end

								root.Velocity *= Vector3.new(1, 0, 1)
								if Mode.Value == 'CFrame' then
									root.CFrame += Vector3.new(0, Value.Value * dt, 0)
								elseif Mode.Value == 'Impulse' then
									root:ApplyImpulse(Vector3.new(0, Value.Value, 0) * root.AssemblyMass)
								else
									root.Velocity += Vector3.new(0, Value.Value, 0)
								end
							end
						end
					else
						local ray = workspace:Raycast(root.Position - Vector3.new(0, entitylib.character.HipHeight - 0.5, 0), entitylib.character.RootPart.CFrame.LookVector * 2, rayCheck)
						if ray and (not Phase.Enabled or not SpiderShift) then
							Truss.Position = ray.Position - ray.Normal * 0.9 or Vector3.zero
						else
							Truss.Position = Vector3.zero
						end
					end
				end
			end))
		else
			if Truss then
				Truss.Parent = nil
			end
			SpiderShift = false
		end
	end,
	Tooltip = 'Lets you climb up walls. (Hold shift to use Phase over spider)'
})
Mode = Spider:CreateDropdown({
	Name = 'Mode',
	List = {'Velocity', 'Impulse', 'CFrame', 'Part'},
	Function = function(val)
		Value.Object.Visible = val ~= 'Part'
		State.Object.Visible = val ~= 'Part'
		if Truss then
			Truss:Destroy()
			Truss = nil
		end
		if val == 'Part' then
			Truss = Instance.new('TrussPart')
			Truss.Size = Vector3.new(2, 2, 2)
			Truss.Transparency = 1
			Truss.Anchored = true
			Truss.Parent = Spider.Enabled and gameCamera or nil
		end
	end,
	Tooltip = 'Velocity - Uses smooth movement to boost you upward\nCFrame - Directly adjusts the position upward\nPart - Positions a climbable part infront of you'
})
Value = Spider:CreateSlider({
	Name = 'Speed',
	Min = 0,
	Max = 100,
	Default = 30,
	Darker = true,
	Suffix = function(val)
		return val == 1 and 'stud' or 'studs'
	end
})
State = Spider:CreateToggle({
	Name = 'Climb State',
	Darker = true
})