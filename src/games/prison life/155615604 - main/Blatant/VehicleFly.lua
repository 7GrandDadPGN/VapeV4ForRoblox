local VehicleFly
local Mode
local Speed
local welds = {}
local up, down = 0, 0

VehicleFly = vape.Categories.Blatant:CreateModule({
	Name = 'VehicleFly',
	Function = function(callback)
		if callback then
			up, down = 0, 0
			for _, v in {'InputBegan', 'InputEnded'} do
				VehicleFly:Clean(inputService[v]:Connect(function(input)
					if not inputService:GetFocusedTextBox() then
						if input.KeyCode == Enum.KeyCode.E then
							up = v == 'InputBegan' and 1 or 0
						elseif input.KeyCode == Enum.KeyCode.Q then
							down = v == 'InputBegan' and -1 or 0
						end
					end
				end))
			end

			if Mode.Value == 'Part' then
				local part = Instance.new('Part')
				part.Size = Vector3.new(50, 1, 50)
				part.Anchored = true
				part.CanQuery = false
				part.Transparency = 1

				VehicleFly:Clean(part)
				repeat
					local seat = entitylib.isAlive and entitylib.character.Humanoid.SeatPart
					if seat then
						part.CFrame = CFrame.new(seat.Position - Vector3.new(0, 2.2 - (up + down), 0))
						part.Parent = workspace
					else
						part.Parent = nil
					end

					task.wait(0.05)
				until not VehicleFly.Enabled
			else
				local inCar = false
				local old
				VehicleFly:Clean(runService.PreSimulation:Connect(function(dt)
					local seat = entitylib.isAlive and entitylib.character.Humanoid.SeatPart
					local root = seat and entitylib.character.RootPart

					if root then
						if seat ~= old then
							inCar = seat:IsDescendantOf(workspace.CarContainer) and seat:IsA('VehicleSeat')
							if inCar then
								welds = seat.Parent.Parent.Wheels:QueryDescendants('Rotate')
								for _, v in welds do
									v.Enabled = false
								end
							end

							old = seat
						end

						if inCar then
							root.AssemblyLinearVelocity = Vector3.new(0, 2.25, 0)
							root.CFrame = CFrame.lookAlong(root.Position, gameCamera.CFrame.LookVector) + (entitylib.character.Humanoid.MoveDirection + Vector3.new(0, up + down, 0)) * Speed.Value * dt
							gameCamera.CameraSubject = entitylib.character.Humanoid
						end
					elseif old then
						for _, v in welds do
							v.Enabled = true
						end
						old = nil
					end
				end))
			end
		else
			for _, v in welds do
				v.Enabled = true
			end
			table.clear(welds)
		end
	end,
	Tooltip = 'Allow you to fly with a vehicle'
})
Mode = VehicleFly:CreateDropdown({
	Name = 'Mode',
	List = {'CFrame', 'Part'},
	Function = function(val)
		Speed.Object.Visible = val == 'CFrame'
		if VehicleFly.Enabled then
			VehicleFly:Toggle()
			VehicleFly:Toggle()
		end
	end
})
Speed = VehicleFly:CreateSlider({
	Name = 'Speed',
	Min = 1,
	Max = 100,
	Default = 60,
	Darker = true
})