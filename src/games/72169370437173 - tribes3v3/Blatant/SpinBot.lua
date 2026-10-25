local SpinBot
local Mode
local XToggle
local YToggle
local ZToggle
local Value

SpinBot = vape.Categories.Blatant:CreateModule({
	Name = 'SpinBot',
	Function = function(callback)
		if callback then
			SpinBot:Clean(runService.PreSimulation:Connect(function()
				if entitylib.isAlive then
					if Mode.Value == 'RotVelocity' then
						if entitylib.character.Humanoid.Sit then
							return
						end

						local original = entitylib.character.RootPart.AssemblyAngularVelocity
						entitylib.character.Humanoid.AutoRotate = false
						entitylib.character.RootPart.AssemblyAngularVelocity = Vector3.new(XToggle.Enabled and Value.Value or original.X, YToggle.Enabled and Value.Value or original.Y, ZToggle.Enabled and Value.Value or original.Z)
					elseif Mode.Value == 'CFrame' then
						if entitylib.character.Humanoid.Sit then
							return
						end

						local val = math.rad((os.clock() * (20 * Value.Value)) % 360)
						local x, y, z = entitylib.character.RootPart.CFrame:ToOrientation()
						entitylib.character.RootPart.CFrame = CFrame.new(entitylib.character.RootPart.Position) * CFrame.Angles(XToggle.Enabled and val or x, YToggle.Enabled and val or y, ZToggle.Enabled and val or z)
					end
				end
			end))
		else
			if entitylib.isAlive and Mode.Value == 'RotVelocity' then
				entitylib.character.Humanoid.AutoRotate = true
			end
		end
	end,
	Tooltip = 'Makes your character spin around in circles (does not work in first person)'
})
Mode = SpinBot:CreateDropdown({
	Name = 'Mode',
	List = {'CFrame', 'RotVelocity'},
	Tooltip = 'CFrame - Directly adjusts your characters angle\nRotVelocity - Sets the rotation velocity so that you spin'
})
Value = SpinBot:CreateSlider({
	Name = 'Speed',
	Min = 1,
	Max = 100,
	Default = 40
})
XToggle = SpinBot:CreateToggle({
	Name = 'Spin X'
})
YToggle = SpinBot:CreateToggle({
	Name = 'Spin Y',
	Default = true
})
ZToggle = SpinBot:CreateToggle({
	Name = 'Spin Z'
})