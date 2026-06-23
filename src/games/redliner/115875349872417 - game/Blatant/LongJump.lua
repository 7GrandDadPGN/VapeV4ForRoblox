local Mode
local Value
local AutoDisable

LongJump = vape.Categories.Blatant:CreateModule({
	Name = 'LongJump',
	Function = function(callback)
		if callback then
			local exempt = tick() + 0.1
			if redline[redline.MoveController] and typeof(redline[redline.MoveController][redline.VelocityName]) == 'Vector3' then
				LongJump:Clean(runService.PreSimulation:Connect(function(dt)
					if entitylib.isAlive then
						local dir = redline[redline.MoveController]:getMoveDirection() * Value.Value
						local oldvel = redline[redline.MoveController][redline.VelocityName]

						if entitylib.character.Humanoid.FloorMaterial ~= Enum.Material.Air then
							if exempt < tick() and AutoDisable.Enabled then
								if LongJump.Enabled then
									LongJump:Toggle()
								end
							else
								oldvel = Vector3.new(0, 40, 0)
							end
						end

						redline[redline.MoveController][redline.VelocityName] = Vector3.new(dir.X, oldvel.Y, dir.Z)
					end
				end))
			end
		end
	end,
	ExtraText = function()
		return 'Redliner'
	end,
	Tooltip = 'Lets you jump farther'
})
Value = LongJump:CreateSlider({
	Name = 'Speed',
	Min = 1,
	Max = 150,
	Default = 50,
	Suffix = function(val)
		return val == 1 and 'stud' or 'studs'
	end
})
AutoDisable = LongJump:CreateToggle({
	Name = 'Auto Disable',
	Default = true
})