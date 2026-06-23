local BulletTracers
local Material
local Color
local Lifetime
local Fade
local DrawingToggle
local drawingobjs = {}

BulletTracers = vape.Legit:CreateModule({
	Name = 'BulletTracers',
	Function = function(callback)
		if callback then
			TracerHook:Add('BulletTracers', function(...)
				local origin, dir = ...
				if vtool then
					origin = vtool.Muzzle.Position
				end

				local velocity = CFrame.lookAt(origin, dir).LookVector * 1000
				if DrawingToggle.Enabled then
					local obj = Drawing.new('Line')
					obj.Thickness = 2
					obj.Color = Color3.fromHSV(Color.Hue, Color.Sat, Color.Value)
					drawingobjs[obj] = {origin, origin + velocity, os.clock()}
					task.delay(Lifetime.Value, function()
						drawingobjs[obj] = nil
						obj.Visible = false
						obj:Remove()
					end)
				else
					local obj = Instance.new('Part')
					obj.Size = Vector3.new(0.1, 0.1, velocity.Magnitude)
					obj.CFrame = CFrame.lookAt(origin + (velocity / 2), origin + velocity)
					obj.CanCollide = false
					obj.CanQuery = false
					obj.Anchored = true
					obj.Material = Enum.Material[Material.Value]
					obj.Color = Color3.fromHSV(Color.Hue, Color.Sat, Color.Value)
					obj.Transparency = 1 - Color.Opacity
					obj.Parent = workspace
					if Fade.Enabled then
						local tween = tweenService:Create(obj, TweenInfo.new(Lifetime.Value), {
							Transparency = 1
						})
						tween.Completed:Connect(function()
							tween:Destroy()
						end)
						tween:Play()
					end

					task.delay(Lifetime.Value, obj.Destroy, obj)
				end

				return true
			end, 1)

			if DrawingToggle.Enabled then
				BulletTracers:Clean(runService.RenderStepped:Connect(function()
					for obj, data in drawingobjs do
						local from, vis = gameCamera:WorldToViewportPoint(data[1])
						local to, vis2 = gameCamera:WorldToViewportPoint(data[2])
						if vis and vis2 then
							obj.Visible = true
							obj.From = Vector2.new(from.X, from.Y)
							obj.To = Vector2.new(to.X, to.Y)
							if Fade.Enabled then
								obj.Transparency = Color.Opacity * (1 - math.clamp((os.clock() - data[3]) / Lifetime.Value, 0, 1))
							end
						else
							obj.Visible = false
						end
					end
				end))
			end
		else
			TracerHook:Remove('BulletTracers')
		end
	end,
	Tooltip = 'Allow you to customize bullet tracers.'
})
local materials = {'SmoothPlastic'}
for _, v in Enum.Material:GetEnumItems() do
	if v.Name ~= 'SmoothPlastic' then
		table.insert(materials, v.Name)
	end
end
Material = BulletTracers:CreateDropdown({
	Name = 'Material',
	List = materials
})
Color = BulletTracers:CreateColorSlider({
	Name = 'Tracer Color',
	DefaultOpacity = 0.5
})
Lifetime = BulletTracers:CreateSlider({
	Name = 'Lifetime',
	Min = 0,
	Max = 0.5,
	Default = 0.2,
	Decimal = 10
})
Fade = BulletTracers:CreateToggle({
	Name = 'Fade',
	Default = true
})
DrawingToggle = BulletTracers:CreateToggle({
	Name = 'Drawing',
	Function = function()
		if BulletTracers.Enabled then
			BulletTracers:Toggle()
			BulletTracers:Toggle()
		end
	end
})