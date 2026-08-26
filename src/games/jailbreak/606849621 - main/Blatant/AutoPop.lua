local AutoPop
local Range
local TeamCheck
local hitDelays = {}

local function getEntitiesInVehicle(car)
	local entities = {}

	for _, seat in car:GetChildren() do
		if (seat.Name == 'Seat' or seat.Name == 'Passenger') then
			seat = seat:FindFirstChild('PlayerName')
			if seat then
				for _, entity in entitylib.List do
					if entity.Player and entity.Player.Name == seat.Value then
						table.insert(entities, entity)
					end
				end
			end
		end
	end

	return entities
end

local function getVehiclesNear()
	local vehicles = {}

	if entitylib.isAlive then
		local localPosition = entitylib.character.HumanoidRootPart.Position

		for _, vehicle in collectionService:GetTagged('Vehicle') do
			if vehicle.PrimaryPart and (vehicle.PrimaryPart.Position - localPosition).Magnitude <= Range.Value and vehicle:GetAttribute('VehicleHasDriver') then
				local entities = getEntitiesInVehicle(vehicle)
				local canAttack = #entities > 0

				if TeamCheck.Enabled then
					for _, entity in entities do
						if not entity.Targetable then
							canAttack = false
							break
						end
					end
				end

				if canAttack then
					table.insert(vehicles, vehicle)
				end
			end
		end
	end

	return vehicles
end

AutoPop = vape.Categories.Blatant:CreateModule({
	Name = 'AutoPop',
	Function = function(callback)
		if callback then
			task.spawn(function()
				repeat
					local item = jb.ItemSystemController:GetLocalEquipped()
					if item and item.BulletEmitter then
						for _, car in getVehiclesNear() do
							if (hitDelays[car] or 0) > os.clock() then
								continue
							end

							hitDelays[car] = os.clock() + 0.1
							jb:FireServer('PopTires', car, item.__ClassName)
						end
					end

					task.wait(0.016)
				until not AutoPop.Enabled
			end)
		else
			table.clear(hitDelays)
		end
	end,
	Tooltip = 'Automatically pops vehicles tires around you'
})
Range = AutoPop:CreateSlider({
	Name = 'Range',
	Min = 1,
	Max = 640,
	Default = 640,
	Suffix = function(val)
		return val == 1 and 'stud' or 'studs'
	end
})
TeamCheck = AutoPop:CreateToggle({
	Name = 'Priority Only'
})