local MouseTP
local Mode
local MovementMode
local Length
local Delay
local rayCheck = RaycastParams.new()
rayCheck.RespectCanCollide = true

local function getWaypointInMouse()
	local obj, dist, location = nil, math.huge, inputService:GetMouseLocation()

	for _, v in WaypointFolder:GetChildren() do
		local position, vis = gameCamera:WorldToViewportPoint(v.StudsOffsetWorldSpace)
		if not vis then continue end

		local mag = (location - Vector2.new(position.x, position.y)).Magnitude
		if mag < dist then
			obj, dist = v, mag
		end
	end

	return obj
end

MouseTP = vape.Categories.Blatant:CreateModule({
	Name = 'MouseTP',
	Function = function(callback)
		if callback then
			local position
			if Mode.Value == 'Mouse' then
				local ray = cloneref(lplr:GetMouse()).UnitRay
				rayCheck.FilterDescendantsInstances = {lplr.Character, gameCamera}
				ray = workspace:Raycast(ray.Origin, ray.Direction * 10000, rayCheck)
				position = ray and ray.Position + Vector3.new(0, entitylib.character.HipHeight or 2, 0)
			elseif Mode.Value == 'Waypoint' then
				local waypoint = getWaypointInMouse()
				position = waypoint and waypoint.StudsOffsetWorldSpace
			else
				local ent = entitylib.EntityMouse({
					Range = math.huge,
					Part = 'RootPart',
					Players = true
				})
				position = ent and ent.RootPart.Position
			end

			if not position then
				notif('MouseTP', 'No position found.', 5)
				MouseTP:Toggle()
				return
			end

			if MovementMode.Value ~= 'Lerp' then
				MouseTP:Toggle()
				if entitylib.isAlive then
					if MovementMode.Value == 'Motor' then
						motorMove(entitylib.character.RootPart, CFrame.lookAlong(position, entitylib.character.RootPart.CFrame.LookVector))
					else
						entitylib.character.RootPart.CFrame = CFrame.lookAlong(position, entitylib.character.RootPart.CFrame.LookVector)
					end
				end
			else
				MouseTP:Clean(runService.Heartbeat:Connect(function()
					if entitylib.isAlive then
						entitylib.character.RootPart.Velocity = Vector3.zero
					end
				end))

				repeat
					if entitylib.isAlive then
						local direction = CFrame.lookAt(entitylib.character.RootPart.Position, position).LookVector * math.min((entitylib.character.RootPart.Position - position).Magnitude, Length.Value)
						entitylib.character.RootPart.CFrame += direction
						if (entitylib.character.RootPart.Position - position).Magnitude < 3 and MouseTP.Enabled then
							MouseTP:Toggle()
						end
					elseif MouseTP.Enabled then
						MouseTP:Toggle()
						notif('MouseTP', 'Character missing', 5, 'warning')
					end

					task.wait(Delay.Value)
				until not MouseTP.Enabled
			end
		end
	end,
	Tooltip = 'Teleports to a selected position.'
})
Mode = MouseTP:CreateDropdown({
	Name = 'Mode',
	List = {'Mouse', 'Player', 'Waypoint'}
})
MovementMode = MouseTP:CreateDropdown({
	Name = 'Movement',
	List = {'CFrame', 'Motor', 'Lerp'},
	Function = function(val)
		Length.Object.Visible = val == 'Lerp'
		Delay.Object.Visible = val == 'Lerp'
	end
})
Length = MouseTP:CreateSlider({
	Name = 'Length',
	Min = 0,
	Max = 150,
	Darker = true,
	Visible = false,
	Suffix = function(val)
		return val == 1 and 'stud' or 'studs'
	end
})
Delay = MouseTP:CreateSlider({
	Name = 'Delay',
	Min = 0,
	Max = 1,
	Decimal = 100,
	Darker = true,
	Visible = false,
	Suffix = function(val)
		return val == 1 and 'second' or 'seconds'
	end
})