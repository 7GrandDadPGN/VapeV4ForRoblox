local KickAll
local Movement
local AutoRejoin
local didClick = {}
local lastFling = {}
local tempList = setmetatable({}, {
	__mode = 'k'
})

local function getTarget(seat)
	if tempList[seat] and tempList[seat].Health > 0 and not tempList[seat].Humanoid.Sit then
		return tempList[seat]
	end

	if entitylib.isAlive then
		local cloned = table.clone(entitylib.List)
		table.sort(cloned, function(a, b)
			return (lastFling[a.Player.Name] or 0) < (lastFling[b.Player.Name] or 0)
		end)

		for _, entity in cloned do
			if not select(2, whitelist:get(entity.Player)) then continue end
			if entity.Player.Team == teams.Neutral then continue end
			if not (entity.Humanoid.Sit and entity.Humanoid.SeatPart.Anchored) and entity.Humanoid.Health > 0 and (os.clock() - entity.SpawnTime) > 5 then
				lastFling[entity.Player.Name] = os.clock()
				tempList[seat] = entity
				table.clear(cloned)
				notif('KickAll', 'Attempted fling: '..entity.Player.Name, 5)
				return entity
			end
		end

		table.clear(cloned)
	end
end

KickAll = vape.Categories.Blatant:CreateModule({
	Name = 'KickAll',
	Function = function(callback)
		if callback then
			if not vape.Modules.AntiFling.Enabled then
				vape.Modules.AntiFling:Toggle()
			end

			local reqTimer = os.clock()
			local startTime = os.clock()
			local dir = 0
			KickAll:Clean(runService.Heartbeat:Connect(function(dt)
				if lplr.Team == teams.Neutral then
					local gui = lplr.PlayerGui:FindFirstChild('TeamsFrame', true)
					if gui then
						for _, holder in gui:GetChildren() do
							if holder.Button.AutoButtonColor then
								firesignal(holder.Button.MouseButton1Click)
								break
							end
						end
					end

					return
				end

				if AutoRejoin.Enabled then
					local plrCount = #teams.Guards:GetPlayers() + #teams.Inmates:GetPlayers() + #teams.Criminals:GetPlayers()

					if ((os.clock() - startTime) > 6 * 60 or plrCount <= 10) then
						if (os.clock() - reqTimer) > 1 then
							vape.Modules.ServerHop:Toggle()
							reqTimer = os.clock()
						end

						return
					end
				end

				if entitylib.isAlive then
					local root = entitylib.character.RootPart
					local didMove

					for _, button in workspace.Prison_ITEMS.buttons:GetChildren() do
						if button.Name == 'Car Spawner' then
							local mag = (button['Car Spawner'].Position - root.Position).Magnitude
							if mag < 15 and (didClick[button] or 0) < os.clock() then
								didClick[button] = os.clock() + 0.2
								task.spawn(function()
									replicatedStorage.Remotes.InteractWithItem:InvokeServer(button['Car Spawner'])
								end)
							end

							if mag < 50 and button['Car Spawner'].BrickColor == BrickColor.new('Cyan') and not didMove then
								local diff = math.clamp((button['Car Spawner'].Position - root.Position).X, -1, 1)
								dir = math.clamp(dir + (diff * dt * 26), -12, 14)
								didMove = true
							end
						end
					end

					if not didMove then
						local diff = math.clamp(0 - dir, -1, 1)
						dir = math.clamp(dir + (diff * dt * 26), -12, 14)
					end

					if Movement.Enabled and ((root.Position - Vector3.new(633, 98, 2489)).Magnitude < 40 or (os.clock() - entitylib.character.SpawnTime) < 0.4) then
						root.CFrame = CFrame.new(Vector3.new(610 + dir, 90, 2494))
						root.AssemblyLinearVelocity = Vector3.zero
					end

					for _, seat in workspace.CarContainer:QueryDescendants('VehicleSeat') do
						if isnetworkowner(seat) then
							local target = getTarget(seat)
							if target then
								seat.AssemblyLinearVelocity = Vector3.new(10000, 10000, 0)
								seat.CFrame = CFrame.new(target.RootPart.Position) * CFrame.new(-2, -2, -12)
								sethiddenproperty(seat, 'PhysicsRepRootPart', target.RootPart)

								local wheels = seat.Parent.Parent:FindFirstChild('Wheels')
								if wheels then
									wheels:Destroy()
								end
							end
						end
					end
				end
			end))
		end
	end,
	Tooltip = 'aesthetical, just remove collisions on vehicles please, this is the worst.'
})
Movement = KickAll:CreateToggle({
	Name = 'Movement',
	Default = true
})
AutoRejoin = KickAll:CreateToggle({
	Name = 'AutoRejoin'
})