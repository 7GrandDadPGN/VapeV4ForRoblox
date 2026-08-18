local AntiFall
local Method
local Mode
local Material
local Color
local Value
local rayCheck = RaycastParams.new()
rayCheck.RespectCanCollide = true
local part

AntiFall = vape.Categories.Blatant:CreateModule({
	Name = 'AntiFall',
	Function = function(callback)
		if callback then
			if Method.Value == 'Part' then
				local debounce = os.clock()
				part = Instance.new('Part')
				part.Anchored = true
				part.Color = Color3.fromHSV(Color.Hue, Color.Sat, Color.Value)
				part.CanCollide = Mode.Value == 'Collide'
				part.CanQuery = false
				part.Material = Enum.Material[Material.Value]
				part.Size = Vector3.new(10000, 1, 10000)
				part.Transparency = 1 - Color.Opacity
				part.Parent = workspace

				AntiFall:Clean(part)
				AntiFall:Clean(part.Touched:Connect(function(touched)
					if touched:IsDescendantOf(lplr.Character) and entitylib.isAlive and debounce < os.clock() then
						local root = entitylib.character.RootPart
						debounce = os.clock() + 0.1

						if Mode.Value == 'Velocity' then
							root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, Value.Value, root.AssemblyLinearVelocity.Z)
						elseif Mode.Value == 'Impulse' then
							root:ApplyImpulse(Vector3.new(0, (Value.Value - root.AssemblyLinearVelocity.Y), 0) * root.AssemblyMass)
						end
					end
				end))

				repeat
					if entitylib.isAlive then
						local root = entitylib.character.RootPart
						rayCheck.FilterDescendantsInstances = {gameCamera, lplr.Character, part}
						rayCheck.CollisionGroup = root.CollisionGroup

						local ray = workspace:Raycast(root.Position, Vector3.new(0, -1000, 0), rayCheck)
						if ray then
							part.Position = ray.Position - Vector3.new(0, 15, 0)
						end
					end

					task.wait(0.1)
				until not AntiFall.Enabled
			else
				local lastPos
				AntiFall:Clean(runService.PreSimulation:Connect(function()
					if entitylib.isAlive then
						local root = entitylib.character.RootPart
						lastPos = entitylib.character.Humanoid.FloorMaterial ~= Enum.Material.Air and root.Position or lastPos

						if (root.Position.Y + (root.AssemblyLinearVelocity.Y * 0.016)) <= (workspace.FallenPartsDestroyHeight + 10) then
							lastPos = lastPos or Vector3.new(root.Position.X, (workspace.FallenPartsDestroyHeight + 20), root.Position.Z)
							root.CFrame += (lastPos - root.Position)
							root.AssemblyLinearVelocity *= Vector3.new(1, 0, 1)
						end
					end
				end))
			end
		end
	end,
	Tooltip = 'Help\'s you with your Parkinson\'s\nPrevents you from falling into the void.'
})
Method = AntiFall:CreateDropdown({
	Name = 'Method',
	List = {'Part', 'Classic'},
	Function = function(val)
		Mode.Object.Visible = val == 'Part'
		Material.Object.Visible = val == 'Part'
		Color.Object.Visible = val == 'Part'
		Value.Object.Visible = val == 'Part'

		if AntiFall.Enabled then
			AntiFall:Toggle()
			AntiFall:Toggle()
		end
	end,
	Tooltip = 'Part - Moves a part under you that does various methods to stop you from falling\nClassic - Teleports you out of the void after reaching the part destroy plane'
})
Mode = AntiFall:CreateDropdown({
	Name = 'Move Mode',
	List = {'Impulse', 'Velocity', 'Collide'},
	Darker = true,
	Function = function(val)
		if part then
			part.CanCollide = val == 'Collide'
		end
	end,
	Tooltip = 'Impulse - Launches you upward after touching using impulse forces\nVelocity - Launches you upward after touching using velocity\nCollide - Allows you to walk on the part'
})
local materials = {'ForceField'}
for _, material in Enum.Material:GetEnumItems() do
	if material.Name ~= 'ForceField' then
		table.insert(materials, material.Name)
	end
end
Material = AntiFall:CreateDropdown({
	Name = 'Material',
	List = materials,
	Darker = true,
	Function = function(val)
		if part then
			part.Material = Enum.Material[val]
		end
	end
})
Color = AntiFall:CreateColorSlider({
	Name = 'Color',
	DefaultOpacity = 0.5,
	Darker = true,
	Function = function(h, s, v, o)
		if part then
			part.Color = Color3.fromHSV(h, s, v)
			part.Transparency = 1 - o
		end
	end
})
Value = AntiFall:CreateSlider({
	Name = 'Bounce velocity',
	Min = 0,
	Max = 200,
	Default = 100,
	Darker = true,
	Suffix = function(val)
		return val == 1 and 'stud' or 'studs'
	end
})