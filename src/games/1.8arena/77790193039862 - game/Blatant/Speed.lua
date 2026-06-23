local Speed
local Value
local AutoJump

Speed = vape.Categories.Blatant:CreateModule({
    Name = 'Speed',
    Function = function(callback)
        if callback then
            Speed:Clean(runService.PreSimulation:Connect(function()
				if not Fly.Enabled and not LongJump.Enabled then
					local movedir = calculateMoveVector() * Value.Value
					local onground = debug.getupvalue(arena.MoveFunction, 4)
					local velocity = debug.getupvalue(arena.TickFunction, 6)

					debug.setupvalue(arena.TickFunction, 6, Vector3.new(movedir.X, AutoJump.Enabled and onground and movedir.Magnitude > 0 and 20 or velocity.Y, movedir.Z))
				end
			end))
        end
    end,
    Tooltip = 'Increases your movement with various methods.'
})
Value = Speed:CreateSlider({
	Name = 'Speed',
	Min = 1,
	Max = 90,
	Default = 30,
	Suffix = function(val)
		return val == 1 and 'stud' or 'studs'
	end
})
AutoJump = Speed:CreateToggle({
	Name = 'AutoJump'
})