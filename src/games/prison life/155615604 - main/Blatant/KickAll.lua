local KickAll
local Movement
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

			KickAll:Clean(runService.Heartbeat:Connect(function()
				if entitylib.isAlive then
					local root = entitylib.character.RootPart
					if Movement.Enabled and ((root.Position - Vector3.new(633, 98, 2489)).Magnitude < 40 or (os.clock() - entitylib.character.SpawnTime) < 0.4) then
						root.CFrame = CFrame.new(Vector3.new(612 + math.sin(os.clock() * 1.3) * 12, 90, 2494))
						root.AssemblyLinearVelocity = Vector3.zero
					end

					for _, button in workspace.Prison_ITEMS.buttons:GetChildren() do
						if button.Name == 'Car Spawner' and (button['Car Spawner'].Position - root.Position).Magnitude < 15 and (didClick[button] or 0) < os.clock() then
							didClick[button] = os.clock() + 0.2
							task.spawn(function()
								replicatedStorage.Remotes.InteractWithItem:InvokeServer(button['Car Spawner'])
							end)
						end
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