local Speed
local Mode
local Options
local AutoJump
local AutoJumpCustom
local AutoJumpValue
local w, s, a, d = 0, 0, 0, 0

Speed = vape.Categories.Blatant:CreateModule({
	Name = 'Speed',
	Function = function(callback)
		frictionTable.Speed = callback and CustomProperties.Enabled or nil
		updateVelocity()
		if callback then
			Speed:Clean(runService.PreSimulation:Connect(function(dt)
				if entitylib.isAlive and not Fly.Enabled and not LongJump.Enabled then
					local state = entitylib.character.Humanoid:GetState()
					if state == Enum.HumanoidStateType.Climbing then return end

					local movevec = TargetStrafeVector or Options.MoveMethod.Value == 'Direct' and calculateMoveVector(Vector3.new(a + d, 0, w + s)) or entitylib.character.Humanoid.MoveDirection
					SpeedMethods[Mode.Value](Options, movevec, dt)
					if AutoJump.Enabled and entitylib.character.Humanoid.FloorMaterial ~= Enum.Material.Air and movevec ~= Vector3.zero then
						if AutoJumpCustom.Enabled then
							local velocity = entitylib.character.RootPart.Velocity * Vector3.new(1, 0, 1)
							entitylib.character.RootPart.Velocity = Vector3.new(velocity.X, AutoJumpValue.Value, velocity.Z)
						else
							entitylib.character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
						end
					end
				end
			end))

			w, s, a, d = inputService:IsKeyDown(Enum.KeyCode.W) and -1 or 0, inputService:IsKeyDown(Enum.KeyCode.S) and 1 or 0, inputService:IsKeyDown(Enum.KeyCode.A) and -1 or 0, inputService:IsKeyDown(Enum.KeyCode.D) and 1 or 0
			for _, v in {'InputBegan', 'InputEnded'} do
				Speed:Clean(inputService[v]:Connect(function(input)
					if not inputService:GetFocusedTextBox() then
						if input.KeyCode == Enum.KeyCode.W then
							w = v == 'InputBegan' and -1 or 0
						elseif input.KeyCode == Enum.KeyCode.S then
							s = v == 'InputBegan' and 1 or 0
						elseif input.KeyCode == Enum.KeyCode.A then
							a = v == 'InputBegan' and -1 or 0
						elseif input.KeyCode == Enum.KeyCode.D then
							d = v == 'InputBegan' and 1 or 0
						end
					end
				end))
			end
		else
			if Options.WalkSpeed and entitylib.isAlive then
				entitylib.character.Humanoid.WalkSpeed = Options.WalkSpeed
			end
			Options.WalkSpeed = nil
		end
	end,
	ExtraText = function()
		return Mode.Value
	end,
	Tooltip = 'Increases your movement with various methods.'
})
Mode = Speed:CreateDropdown({
	Name = 'Mode',
	List = SpeedMethodList,
	Function = function(val)
		Options.WallCheck.Object.Visible = val == 'CFrame' or val == 'TP'
		Options.TPFrequency.Object.Visible = val == 'TP'
		Options.PulseLength.Object.Visible = val == 'Pulse'
		Options.PulseDelay.Object.Visible = val == 'Pulse'
		if Speed.Enabled then
			Speed:Toggle()
			Speed:Toggle()
		end
	end,
	Tooltip = 'Velocity - Uses smooth physics based movement\nImpulse - Same as velocity while using forces instead\nCFrame - Directly adjusts the position of the root\nTP - Large teleports within intervals\nPulse - Controllable bursts of speed\nWalkSpeed - The classic mode of speed, usually detected on most games.'
})
Options = {
	MoveMethod = Speed:CreateDropdown({
		Name = 'Move Mode',
		List = {'MoveDirection', 'Direct'},
		Tooltip = 'MoveDirection - Uses the games input vector for movement\nDirect - Directly calculate our own input vector'
	}),
	Value = Speed:CreateSlider({
		Name = 'Speed',
		Min = 1,
		Max = 150,
		Default = 50,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end
	}),
	TPFrequency = Speed:CreateSlider({
		Name = 'TP Frequency',
		Min = 0,
		Max = 1,
		Decimal = 100,
		Darker = true,
		Visible = false,
		Suffix = function(val)
			return val == 1 and 'second' or 'seconds'
		end
	}),
	PulseLength = Speed:CreateSlider({
		Name = 'Pulse Length',
		Min = 0,
		Max = 1,
		Decimal = 100,
		Darker = true,
		Visible = false,
		Suffix = function(val)
			return val == 1 and 'second' or 'seconds'
		end
	}),
	PulseDelay = Speed:CreateSlider({
		Name = 'Pulse Delay',
		Min = 0,
		Max = 1,
		Decimal = 100,
		Darker = true,
		Visible = false,
		Suffix = function(val)
			return val == 1 and 'second' or 'seconds'
		end
	}),
	WallCheck = Speed:CreateToggle({
		Name = 'Wall Check',
		Default = true,
		Darker = true,
		Visible = false
	}),
	TPTiming = tick(),
	rayCheck = RaycastParams.new()
}
Options.rayCheck.RespectCanCollide = true
CustomProperties = Speed:CreateToggle({
	Name = 'Custom Properties',
	Function = function()
		if Speed.Enabled then
			Speed:Toggle()
			Speed:Toggle()
		end
	end,
	Default = true
})
AutoJump = Speed:CreateToggle({
	Name = 'AutoJump',
	Function = function(callback)
		AutoJumpCustom.Object.Visible = callback
	end
})
AutoJumpCustom = Speed:CreateToggle({
	Name = 'Custom Jump',
	Function = function(callback)
		AutoJumpValue.Object.Visible = callback
	end,
	Tooltip = 'Allows you to adjust the jump power',
	Darker = true,
	Visible = false
})
AutoJumpValue = Speed:CreateSlider({
	Name = 'Jump Power',
	Min = 1,
	Max = 50,
	Default = 30,
	Darker = true,
	Visible = false
})