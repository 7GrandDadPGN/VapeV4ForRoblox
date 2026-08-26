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

local function ToolAdded(tool)
	if tool then
		if vtool then
			vtool:Destroy()
		end

		old = tool
		vtool = tool:Clone()
		handle = vtool:FindFirstChild('BoundingBox', true) or vtool:FindFirstChild('Center', true)
		vtool.Parent = gameCamera

		local motor = vtool:FindFirstChild('Motor6D', true) or vtool:FindFirstChild('Motor', true)
		if motor then
			motor:Destroy()
		end

		for _, part in vtool:QueryDescendants('BasePart') do
			part.Material = ForceField.Enabled and Enum.Material.ForceField or part.Material
			part.Color = ForceField.Enabled and Color3.fromHSV(ColorSl.Hue, ColorSl.Sat, ColorSl.Value) or part.Color
		end

		for _, inst in old:QueryDescendants('BasePart, Texture, Decal') do
			inst.LocalTransparencyModifier = 1
		end
	end
end

Viewmodel = vape.Legit:CreateModule({
	Name = 'Viewmodel',
	Function = function(callback)
		if callback then
			Viewmodel:Clean(jb.ItemSystemController.OnLocalItemEquipped:Connect(function(item)
				task.spawn(ToolAdded, item.Model)
			end))

			Viewmodel:Clean(jb.ItemSystemController.OnLocalItemUnequipped:Connect(function()
				task.spawn(function()
					if vtool then
						vtool:Destroy()
						vtool = nil
					end

					old = nil
				end)
			end))

			local equipped = jb.ItemSystemController:GetLocalEquipped()
			if equipped then
				task.spawn(ToolAdded, equipped.Model)
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
			if old then
				for _, inst in old:QueryDescendants('BasePart, Texture, Decal') do
					inst.LocalTransparencyModifier = 0
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
	Max = 4,
	Default = 4,
	Decimal = 10
})
Horizontal = Viewmodel:CreateSlider({
	Name = 'Horizontal',
	Min = 0,
	Max = 2.5,
	Default = 2.5,
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