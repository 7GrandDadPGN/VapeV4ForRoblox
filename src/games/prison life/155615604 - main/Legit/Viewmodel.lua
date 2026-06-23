local Viewmodel
local Depth
local Horizontal
local Vertical
local Sway
local ForceField
local ColorSl
local handle
local old
local moveSpring = Spring.new()
local aimSpring = Spring.new({Speed = 15})

local function ToolAdded(obj)
	if obj and obj:IsA('Tool') then
		if old then
			for _, v in old:QueryDescendants('BasePart, Texture, Decal') do
				v.LocalTransparencyModifier = 0
			end
		end

		if vtool then
			vtool:Destroy()
		end

		old = obj
		vtool = obj:Clone()
		handle = vtool:FindFirstChild('Handle')
		vtool.Parent = gameCamera

		for _, v in vtool:QueryDescendants('BasePart') do
			v.Material = ForceField.Enabled and Enum.Material.ForceField or v.Material
			v.Color = ForceField.Enabled and Color3.fromHSV(ColorSl.Hue, ColorSl.Sat, ColorSl.Value) or v.Color
		end

		for _, v in old:QueryDescendants('BasePart, Texture, Decal') do
			v.LocalTransparencyModifier = 1
		end
	end
end

local function EntityAdded(ent)
	if vtool then
		vtool:Destroy()
		vtool = nil
		handle = nil
	end

	Viewmodel:Clean(ent.Character.ChildAdded:Connect(ToolAdded))
	Viewmodel:Clean(ent.Character.ChildRemoved:Connect(function(obj)
		if obj == old then
			if vtool then
				vtool:Destroy()
				vtool = nil
			end

			for _, v in old:QueryDescendants('BasePart, Texture, Decal') do
				v.LocalTransparencyModifier = 0
			end

			old = nil
		end
	end))

	ToolAdded(ent.Character:FindFirstChildWhichIsA('Tool'))
end

Viewmodel = vape.Legit:CreateModule({
	Name = 'Viewmodel',
	Function = function(callback)
		if callback then
			TracerHook:Add('Viewmodel', function(...)
				shootTimer = os.clock() + 0.3
			end, 0)

			Viewmodel:Clean(entitylib.Events.LocalAdded:Connect(EntityAdded))
			if entitylib.isAlive then
				task.spawn(EntityAdded, entitylib.character)
			end

			Viewmodel:Clean(runService.RenderStepped:Connect(function(dt)
				if handle then
					moveSpring.Target = entitylib.isAlive and entitylib.character.RootPart.AssemblyLinearVelocity * 0.005 or Vector3.zero
					if Sway.Enabled then
						if moveSpring.Target.Magnitude > 0.1 then
							moveSpring.Target += (gameCamera.CFrame * CFrame.new(math.sin(tick() * 10) * 0.06, 0, 0)).Position - gameCamera.CFrame.Position
						else
							moveSpring.Target += (gameCamera.CFrame * CFrame.new(0, math.sin(tick()) * 0.04, 0)).Position - gameCamera.CFrame.Position
						end
					end

					local cf = (gameCamera.CFrame * CFrame.new(Horizontal.Value, Vertical.Value, -Depth.Value)) + moveSpring:Update(dt)
					aimSpring.Target = aimTimer > os.clock() and CFrame.lookAt(cf.Position, aimVec).LookVector or gameCamera.CFrame.LookVector
					handle.CFrame = CFrame.lookAlong(cf.Position, aimSpring:Update(dt)) * (CFrame.Angles(math.rad(math.max(shootTimer - os.clock(), 0) * 10), 0, 0) * CFrame.new(0, 0, math.max(shootTimer - os.clock(), 0)))
					handle.AssemblyLinearVelocity = Vector3.zero
				end
			end))
		else
			TracerHook:Remove('Viewmodel')

			if old then
				for _, v in old:QueryDescendants('BasePart, Texture, Decal') do
					v.LocalTransparencyModifier = 0
				end
				old = nil
			end

			if vtool then
				vtool:Destroy()
				vtool = nil
				handle = nil
			end
		end
	end,
	Tooltip = 'Custom viewmodel for guns'
})
Depth = Viewmodel:CreateSlider({
	Name = 'Depth',
	Min = 0,
	Max = 3,
	Default = 3,
	Decimal = 10
})
Horizontal = Viewmodel:CreateSlider({
	Name = 'Horizontal',
	Min = 0,
	Max = 2,
	Default = 2,
	Decimal = 10
})
Vertical = Viewmodel:CreateSlider({
	Name = 'Vertical',
	Min = -1.5,
	Max = 2,
	Default = -1.5,
	Decimal = 10
})
Sway = Viewmodel:CreateToggle({
	Name = 'Sway Effect',
	Default = true
})
ForceField = Viewmodel:CreateToggle({
	Name = 'ForceField Effect',
	Function = function(callback)
		ColorSl.Object.Visible = callback
		if callback and Viewmodel.Enabled then
			Viewmodel:Toggle()
			Viewmodel:Toggle()
		end
	end
})
ColorSl = Viewmodel:CreateColorSlider({
	Name = 'Color',
	Function = function(hue, sat, val)
		if vtool then
			for _, v in vtool:QueryDescendants('BasePart') do
				v.Color = Color3.fromHSV(hue, sat, val)
			end
		end
	end,
	Visible = false
})