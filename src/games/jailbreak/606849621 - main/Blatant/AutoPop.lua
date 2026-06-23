local AutoPop
local Range
local TeamCheck

local function getEntitiesInVehicle(car)
	local entities = {}

	for _, seat in car:GetChildren() do
		if (seat.Name == 'Seat' or seat.Name == 'Passenger') then
			seat = seat:FindFirstChild('PlayerName')
			if seat then
				for _, ent in entitylib.List do
					if ent.Player and ent.Player.Name == seat.Value then
						table.insert(entities, ent)
					end
				end
			end
		end
	end

	return entities
end

local function getVehiclesNear()
	local allowed = {}

	if entitylib.isAlive then
		local localPosition = entitylib.character.HumanoidRootPart.Position
		for _, car in collectionService:GetTagged('Vehicle') do
			if car.PrimaryPart and (car.PrimaryPart.Position - localPosition).Magnitude <= Range.Value then
				local entities = getEntitiesInVehicle(car)
				local check = #entities > 0
				if TeamCheck.Enabled then
					for _, ent in entities do
						if not ent.Targetable then
							check = false
							break
						end
					end
				end

				if check then
					table.insert(allowed, car)
				end
			end
		end
	end

	return allowed
end

AutoPop = vape.Categories.Blatant:CreateModule({
	Name = 'AutoPop',
	Function = function(callback)
		if callback then
			task.spawn(function()
				repeat
					local item = jb.ItemSystemController:GetLocalEquipped()
					if item and item.BulletEmitter and item.Model then
						for _, car in getVehiclesNear() do
							if not (AutoPop.Enabled and item.Model) then break end
							jb:FireServer('PopTires', car, item.Model.Name)
							task.wait(0.1)
						end
					end

					task.wait(0.016)
				until not AutoPop.Enabled
			end)
		end
	end,
	Tooltip = 'Automatically pops vehicles tires around you'
})
Range = AutoPop:CreateSlider({
	Name = 'Range',
	Min = 1,
	Max = 600,
	Default = 600
})
TeamCheck = AutoPop:CreateToggle({Name = 'Team Check'})