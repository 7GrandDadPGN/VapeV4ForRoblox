local SpinBot
local Mode
local XToggle
local YToggle
local ZToggle
local Value
local AngularVelocity

SpinBot = vape.Categories.Blatant:CreateModule({
	Name = 'SpinBot',
	Function = function(callback)
		if callback then
			SpinBot:Clean(runService.PreSimulation:Connect(function()
				if entitylib.isAlive then
					if Mode.Value == 'RotVelocity' then
						local originalRotVelocity = entitylib.character.RootPart.RotVelocity
						entitylib.character.Humanoid.AutoRotate = false
						entitylib.character.RootPart.RotVelocity = Vector3.new(XToggle.Enabled and Value.Value or originalRotVelocity.X, YToggle.Enabled and Value.Value or originalRotVelocity.Y, ZToggle.Enabled and Value.Value or originalRotVelocity.Z)
					elseif Mode.Value == 'CFrame' then
						local val = math.rad((tick() * (20 * Value.Value)) % 360)
						local x, y, z = entitylib.character.RootPart.CFrame:ToOrientation()
						entitylib.character.RootPart.CFrame = CFrame.new(entitylib.character.RootPart.Position) * CFrame.Angles(XToggle.Enabled and val or x, YToggle.Enabled and val or y, ZToggle.Enabled and val or z)
					elseif AngularVelocity then
						AngularVelocity.Parent = entitylib.isAlive and entitylib.character.RootPart
						AngularVelocity.MaxTorque = Vector3.new(XToggle.Enabled and math.huge or 0, YToggle.Enabled and math.huge or 0, ZToggle.Enabled and math.huge or 0)
						AngularVelocity.AngularVelocity = Vector3.new(Value.Value, Value.Value, Value.Value)
					end
				end
			end))
		else
			if entitylib.isAlive and Mode.Value == 'RotVelocity' then
				entitylib.character.Humanoid.AutoRotate = true
			end

			if AngularVelocity then
				AngularVelocity.Parent = nil
			end
		end
	end,
	Tooltip = 'Makes your character spin around in circles (does not work in first person)'
})
Mode = SpinBot:CreateDropdown({
	Name = 'Mode',
	List = {'CFrame', 'RotVelocity', 'BodyMover'},
	Function = function(val)
		if AngularVelocity then
			AngularVelocity:Destroy()
			AngularVelocity = nil
		end
		AngularVelocity = val == 'BodyMover' and Instance.new('BodyAngularVelocity') or nil
	end
})
Value = SpinBot:CreateSlider({
	Name = 'Speed',
	Min = 1,
	Max = 100,
	Default = 40
})
XToggle = SpinBot:CreateToggle({Name = 'Spin X'})
YToggle = SpinBot:CreateToggle({
	Name = 'Spin Y',
	Default = true
})
ZToggle = SpinBot:CreateToggle({Name = 'Spin Z'})