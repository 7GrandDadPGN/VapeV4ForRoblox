local Velocity
local Horizontal
local Vertical
local Chance
local Targeting
local connection
local rand, old = Random.new()

local function velocityFunction(...)
	if rand:NextNumber(0, 100) > Chance.Value then return old(...) end

    local data = ...
	local check = (not Targeting.Enabled) or entitylib.EntityPosition({
		Range = 50,
		Part = 'RootPart',
		Players = true
	})

	if check and not data.position then
		local hort, vert = (Horizontal.Value / 100), (Vertical.Value / 100)
		if hort == 0 and vert == 0 then return end
		data.vel = Vector3.new(data.vel.X * hort, data.vel.Y * vert, data.vel.Z * hort)
	end

	return old(...)
end

Velocity = vape.Categories.Combat:CreateModule({
	Name = 'Velocity',
	Function = function(callback)
		if callback then
			connection = getconnections(replicatedStorage.Remotes.ClientStateUpdate.OnClientEvent)[1]
			if not connection then return end

			old = hookfunction(connection.Function, function(...)
				return velocityFunction(...)
			end)
		else
			if old then
				hookfunction(connection.Function, old)
			end
			connection = nil
		end
	end,
	Tooltip = 'Reduces knockback taken'
})
Horizontal = Velocity:CreateSlider({
	Name = 'Horizontal',
	Min = 0,
	Max = 100,
	Default = 0,
	Suffix = '%'
})
Vertical = Velocity:CreateSlider({
	Name = 'Vertical',
	Min = 0,
	Max = 100,
	Default = 0,
	Suffix = '%'
})
Chance = Velocity:CreateSlider({
	Name = 'Chance',
	Min = 0,
	Max = 100,
	Default = 100,
	Suffix = '%'
})
Targeting = Velocity:CreateToggle({Name = 'Only when targeting'})