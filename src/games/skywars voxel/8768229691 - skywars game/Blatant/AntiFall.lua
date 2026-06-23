local AntiFall
local Mode
local Material
local Color
local part

local function getLowGround()
	local mag = math.huge
	for pos in store.blocks do
		if pos.Y < mag and not store.blocks[pos + Vector3.new(0, 3, 0)] then
			mag = pos.Y
		end
	end
	return mag
end

AntiFall = vape.Categories.Blatant:CreateModule({
	Name = 'AntiFall',
	Function = function(callback)
		if callback then
			local pos, debounce = getLowGround(), tick()
			if pos ~= math.huge then
				local middle = next(store.blocks)
				part = Instance.new('Part')
				part.Size = Vector3.new(10000, 1, 10000)
				part.Transparency = 1 - Color.Opacity
				part.Material = Enum.Material[Material.Value]
				part.Color = Color3.fromHSV(Color.Hue, Color.Sat, Color.Value)
				part.Position = Vector3.new(middle.X, pos - 2, middle.Z)
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
							root.Velocity = Vector3.new(root.Velocity.X, 100, root.Velocity.Z)
						end
					end
				end))
			end
		end
	end,
	Tooltip = 'Help\'s you with your Parkinson\'s\nPrevents you from falling into the void.'
})
Mode = AntiFall:CreateDropdown({
	Name = 'Move Mode',
	List = {'Velocity', 'Collide'},
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
	Function = function(val)
		if part then 
			part.Material = Enum.Material[val] 
		end
	end
})
Color = AntiFall:CreateColorSlider({
	Name = 'Color',
	DefaultOpacity = 0.5,
	Function = function(h, s, v, o)
		if part then
			part.Color = Color3.fromHSV(h, s, v)
			part.Transparency = 1 - o
		end
	end
})