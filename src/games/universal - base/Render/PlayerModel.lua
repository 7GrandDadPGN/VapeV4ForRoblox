local PlayerModel
local Scale
local Local
local Mesh
local Texture
local Rots = {}
local models = {}

local function addMesh(ent)
	if vape.ThreadFix then 
		setthreadidentity(8)
	end
	local root = ent.RootPart
	local part = Instance.new('Part')
	part.Size = Vector3.new(3, 3, 3)
	part.CFrame = root.CFrame * CFrame.Angles(math.rad(Rots[1].Value), math.rad(Rots[2].Value), math.rad(Rots[3].Value))
	part.CanCollide = false
	part.CanQuery = false
	part.Massless = true
	part.Parent = workspace
	local meshd = Instance.new('SpecialMesh')
	meshd.MeshId = Mesh.Value
	meshd.TextureId = Texture.Value
	meshd.Scale = Vector3.one * Scale.Value
	meshd.Parent = part
	local weld = Instance.new('WeldConstraint')
	weld.Part0 = part
	weld.Part1 = root
	weld.Parent = part
	models[root] = part
end

local function removeMesh(ent)
	if models[ent.RootPart] then 
		models[ent.RootPart]:Destroy()
		models[ent.RootPart] = nil
	end
end

PlayerModel = vape.Categories.Render:CreateModule({
	Name = 'PlayerModel',
	Function = function(callback)
		if callback then 
			if Local.Enabled then 
				PlayerModel:Clean(entitylib.Events.LocalAdded:Connect(addMesh))
				PlayerModel:Clean(entitylib.Events.LocalRemoved:Connect(removeMesh))
				if entitylib.isAlive then 
					task.spawn(addMesh, entitylib.character)
				end
			end
			PlayerModel:Clean(entitylib.Events.EntityAdded:Connect(addMesh))
			PlayerModel:Clean(entitylib.Events.EntityRemoved:Connect(removeMesh))
			for _, ent in entitylib.List do 
				task.spawn(addMesh, ent)
			end
		else
			for _, part in models do 
				part:Destroy()
			end
			table.clear(models)
		end
	end,
	Tooltip = 'Change the player models to a Mesh'
})
Scale = PlayerModel:CreateSlider({
	Name = 'Scale',
	Min = 0,
	Max = 2,
	Default = 1,
	Decimal = 100,
	Function = function(val)
		for _, part in models do 
			part.Mesh.Scale = Vector3.one * val
		end
	end
})
for _, name in {'Rotation X', 'Rotation Y', 'Rotation Z'} do 
	table.insert(Rots, PlayerModel:CreateSlider({
		Name = name,
		Min = 0,
		Max = 360,
		Function = function(val)
			for root, part in models do 
				part.WeldConstraint.Enabled = false
				part.CFrame = root.CFrame * CFrame.Angles(math.rad(Rots[1].Value), math.rad(Rots[2].Value), math.rad(Rots[3].Value))
				part.WeldConstraint.Enabled = true
			end
		end
	}))
end
Local = PlayerModel:CreateToggle({
	Name = 'Local',
	Function = function()
		if PlayerModel.Enabled then 
			PlayerModel:Toggle()
			PlayerModel:Toggle()
		end
	end
})
Mesh = PlayerModel:CreateTextBox({
	Name = 'Mesh',
	Placeholder = 'mesh id',
	Function = function()
		for _, part in models do 
			part.Mesh.MeshId = Mesh.Value
		end
	end
})
Texture = PlayerModel:CreateTextBox({
	Name = 'Texture',
	Placeholder = 'texture id',
	Function = function()
		for _, part in models do 
			part.Mesh.TextureId = Texture.Value
		end
	end
})
