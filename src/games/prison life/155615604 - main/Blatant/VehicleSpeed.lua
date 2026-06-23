local VehicleSpeed
local Speed
local old
local seats = {}

VehicleSpeed = vape.Categories.Blatant:CreateModule({
	Name = 'VehicleSpeed',
	Function = function(callback)
		if callback then
			repeat
				local seat = entitylib.isAlive and entitylib.character.Humanoid.SeatPart
				if seat then
					if seat ~= old then
						if seat:IsDescendantOf(workspace.CarContainer) then
							seats = seat.Parent.Parent:QueryDescendants('VehicleSeat')
						end

						old = seat
					end

					for _, v in seats do
						v.MaxSpeed = Speed.Value
						v.Torque = 4
					end
				end

				task.wait()
			until not VehicleSpeed.Enabled
		else
			table.clear(seats)
		end
	end,
	Tooltip = 'Increase vehicle speed'
})
Speed = VehicleSpeed:CreateSlider({
	Name = 'Speed',
	Min = 80,
	Max = 200,
	Default = 140
})