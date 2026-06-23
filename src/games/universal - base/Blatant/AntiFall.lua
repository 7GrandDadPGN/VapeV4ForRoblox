local AntiFall
local Method
local Mode
local Material
local Color
local rayCheck = RaycastParams.new()
rayCheck.RespectCanCollide = true
local part

AntiFall = vape.Categories.Blatant:CreateModule({
	Name = 'AntiFall',
	Function = function(callback)
		if callback then
			if Method.Value == 'Part' then
				local debounce = tick()
				part = Instance.new('Part')
				part.Size = Vector3.new(10000, 1, 10000)
				part.Transparency = 1 - Color.Opacity
				part.Material = Enum.Material[Material.Value]
				part.Color = Color3.fromHSV(Color.Hue, Color.Sat, Color.Value)
				part.CanCollide = Mode.Value == 'Collide'
				part.Anchored = true
				part.CanQuery = false
				part.Parent = workspace

				AntiFall:Clean(part)
				AntiFall:Clean(part.Touched:Connect(function(touchedpart)
					if touchedpart.Parent == lplr.Character and entitylib.isAlive and debounce < tick() then
						local root = entitylib.character.RootPart
						debounce = tick() + 0.1
						if Mode.Value == 'Velocity' then
							root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, 100, root.AssemblyLinearVelocity.Z)
						elseif Mode.Value == 'Impulse' then
							root:ApplyImpulse(Vector3.new(0, (100 - root.AssemblyLinearVelocity.Y), 0) * root.AssemblyMass)
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
				local lastpos
				AntiFall:Clean(runService.PreSimulation:Connect(function()
					if entitylib.isAlive then
						local root = entitylib.character.RootPart
						lastpos = entitylib.character.Humanoid.FloorMaterial ~= Enum.Material.Air and root.Position or lastpos
						if (root.Position.Y + (root.Velocity.Y * 0.016)) <= (workspace.FallenPartsDestroyHeight + 10) then
							lastpos = lastpos or Vector3.new(root.Position.X, (workspace.FallenPartsDestroyHeight + 20), root.Position.Z)
							root.CFrame += (lastpos - root.Position)
							root.Velocity *= Vector3.new(1, 0, 1)
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
		if Mode.Object then
			Mode.Object.Visible = val == 'Part'
			Material.Object.Visible = val == 'Part'
			Color.Object.Visible = val == 'Part'
		end
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
	Tooltip = 'Velocity - Launches you upward after touching\nCollide - Allows you to walk on the part'
})
local materials = {'ForceField'}
for _, v in Enum.Material:GetEnumItems() do
	if v.Name ~= 'ForceField' then
		table.insert(materials, v.Name)
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