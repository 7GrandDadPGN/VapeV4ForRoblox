local AntiFling
local params = OverlapParams.new()
params.CollisionGroup = 'Players'
local modified = {}

AntiFling = vape.Categories.Blatant:CreateModule({
	Name = 'AntiFling',
	Function = function(callback)
		if callback then
			AntiFling:Clean(runService.PreSimulation:Connect(function()
				if entitylib.isAlive then
					params.FilterDescendantsInstances = {lplr.Character}
					local parts = workspace:GetPartBoundsInRadius(entitylib.character.Head.Position, 10, params)
					for _, part in parts do
						if not (part.Anchored or part:IsA('VehicleSeat') and part.AssemblyLinearVelocity.Magnitude < 40 and part.AssemblyAngularVelocity.Magnitude < 40) then
							if not modified[part] then
								modified[part] = {part.CanCollide, part.CanTouch}
							end

							part.CanCollide = false
							part.CanTouch = false
						end
					end

					for part in modified do
						if not table.find(parts, part) then
							part.CanCollide = modified[part][1]
							part.CanTouch = modified[part][2]
							modified[part] = nil
						end
					end

					for _, joint in entitylib.character.RootPart:GetJoints() do
						if joint.Name ~= 'RootJoint' and joint.Name ~= 'SeatWeld' then
							joint:Destroy()
						end
					end
				end
			end))
		else
			for part, value in modified do
				part.CanCollide = value[1]
				part.CanTouch = value[2]
			end

			table.clear(modified)
		end
	end,
	Tooltip = 'Prevent certain methods of flinging you'
})