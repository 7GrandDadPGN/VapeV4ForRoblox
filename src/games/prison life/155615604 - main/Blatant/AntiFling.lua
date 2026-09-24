local AntiFling
local modified = {}

local function Modify(part)
	if part:IsA('BasePart') and part.CollisionGroup ~= 'Wheels' then
		if not modified[part] then
			modified[part] = {part.CanCollide, part.CanQuery}
		end

		if (part:IsA('Seat') or part:IsA('VehicleSeat')) and part.Name == part.ClassName then
			local connection
			local prox = Instance.new('ProximityPrompt')
			prox.ActionText = 'Enter'
			prox.Enabled = not part.Occupant
			prox.MaxActivationDistance = 8
			prox.RequiresLineOfSight = false
			prox.Parent = part

			prox.Triggered:Connect(function()
				if entitylib.isAlive then
					part:Sit(entitylib.character.Humanoid)
				end
			end)

			prox.Destroying:Connect(function()
				connection:Disconnect()
			end)

			connection = part:GetPropertyChangedSignal('Occupant'):Connect(function()
				prox.Enabled = not part.Occupant
			end)
		end

		part.CanCollide = false
		part.CanTouch = false
	end
end

AntiFling = vape.Categories.Blatant:CreateModule({
	Name = 'AntiFling',
	Function = function(callback)
		if callback then
			AntiFling:Clean(workspace.CarContainer.DescendantAdded:Connect(Modify))
			for _, part in workspace.CarContainer:QueryDescendants('BasePart') do
				Modify(part)
			end
		else
			for part, value in modified do
				part.CanCollide = value[1]
				part.CanTouch = value[2]
			end

			for _, prompt in workspace.CarContainer:QueryDescendants('ProximityPrompt') do
				prompt:Destroy()
			end

			table.clear(modified)
		end
	end,
	Tooltip = 'Prevent certain methods of flinging you'
})