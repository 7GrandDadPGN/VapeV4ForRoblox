local Value
local rayCheck = RaycastParams.new()
rayCheck.RespectCanCollide = true
local Active

Spider = vape.Categories.Blatant:CreateModule({
	Name = 'Spider',
	Function = function(callback)
		if callback then
			Spider:Clean(runService.PreSimulation:Connect(function(dt)
				if entitylib.isAlive then
					local root = entitylib.character.RootPart
					local chars = {gameCamera, lplr.Character}
					for _, v in entitylib.List do
						table.insert(chars, v.Character)
					end

					SpiderShift = inputService:IsKeyDown(Enum.KeyCode.LeftShift)
					rayCheck.FilterDescendantsInstances = chars
					rayCheck.CollisionGroup = 'Hitbox'

					local vec = calculateMoveVector() * 2.5
					local ray = workspace:Raycast(root.Position - Vector3.new(0, entitylib.character.HipHeight - 0.5, 0), vec, rayCheck)
					if Active and not ray then
						root.Velocity = Vector3.new(root.Velocity.X, 0, root.Velocity.Z)
					end

					Active = ray
					if Active and ray.Normal.Y == 0 then
						if not Phase.Enabled or not SpiderShift then
							local velocity = debug.getupvalue(arena.TickFunction, 6)
							debug.setupvalue(arena.TickFunction, 6, Vector3.new(velocity.X, Value.Value, velocity.Z))
						end
					end
				end
			end))
		else
			SpiderShift = false
		end
	end,
	Tooltip = 'Lets you climb up walls. (Hold shift to use Phase over spider)'
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