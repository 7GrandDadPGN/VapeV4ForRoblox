local KickAll

KickAll = vape.Categories.Blatant:CreateModule({
	Name = 'KickAll',
	Function = function(callback)
		if callback then
			local cf = {}
			local flingtimes = {}
			local flingcooldown = {}
			KickAll:Clean(runService.Heartbeat:Connect(function()
				local seat = entitylib.isAlive and entitylib.character.Humanoid.SeatPart
				if not (seat and seat:IsDescendantOf(workspace.CarContainer) and seat.Name == 'VehicleSeat') then
					notif('KickAll', 'Vehicle required!', 10)
					KickAll:Toggle()
					return
				end

				local wheelIndex = 1
				local wheels = seat.Parent.Parent.Wheels:QueryDescendants('Rotate')
				local targets = table.clone(entitylib.List)

				table.sort(targets, function(a, b)
					return (a.RootPart.Position - seat.Position).Magnitude < (b.RootPart.Position - seat.Position).Magnitude
				end)

				for _, entity in targets do
					if (os.clock() - entity.SpawnTime) > 5 and entity.Health > 0 and entity.Humanoid:GetState() ~= Enum.HumanoidStateType.Dead and select(2, whitelist:get(entity.Player)) and not (entity.Humanoid.SeatPart and entity.Humanoid.SeatPart.Anchored) and entity.RootPart.AssemblyLinearVelocity.Magnitude < 60 then
						local wheel = wheels[wheelIndex]
						if not wheel then
							break
						end

						if not cf[wheel] then
							cf[wheel] = wheel.Part1.CFrame
						end

						local target = entity.Humanoid.Torso or entity.RootPart
						sethiddenproperty(wheel.Part0, 'PhysicsRepRootPart', entity.RootPart)
						wheel.Part0.CFrame = CFrame.new(target.Position) * CFrame.Angles(0, math.rad(90), 0)
						wheel.Part1.CFrame = cf[wheel]
						wheel.Part0.AssemblyLinearVelocity = Vector3.new(50, 0, 0)
						wheel.Part0.AssemblyAngularVelocity = Vector3.zero
						wheel.Part1.AssemblyLinearVelocity = Vector3.zero
						wheel.Part1.AssemblyAngularVelocity = Vector3.zero

						wheelIndex += 1
					end
				end

				for i = 1, #wheels - wheelIndex do
					local wheel = wheels[wheelIndex]
					if cf[wheel] then
						wheel.Part0.CFrame = cf[wheel]
						wheel.Part1.CFrame = cf[wheel]
					end

					wheel.Part0.AssemblyLinearVelocity = Vector3.zero
					wheel.Part0.AssemblyAngularVelocity = Vector3.zero
					wheel.Part1.AssemblyLinearVelocity = Vector3.zero
					wheel.Part1.AssemblyAngularVelocity = Vector3.zero
				end

				table.clear(targets)
			end))
		end
	end,
	Tooltip = 'kick everyone in the server'
})