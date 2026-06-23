local HighJump
local Value
local AutoDisable

local function jump()
	local onground = debug.getupvalue(arena.MoveFunction, 4)
	if onground then
		local velocity = debug.getupvalue(arena.TickFunction, 6)
		debug.setupvalue(arena.TickFunction, 6, Vector3.new(velocity.X, Value.Value, velocity.Z))
	end
end

HighJump = vape.Categories.Blatant:CreateModule({
	Name = 'HighJump',
	Function = function(callback)
		if callback then
			if AutoDisable.Enabled then
				jump()
				HighJump:Toggle()
			else
				HighJump:Clean(runService.RenderStepped:Connect(function()
					if not inputService:GetFocusedTextBox() and inputService:IsKeyDown(Enum.KeyCode.Space) then
						jump()
					end
				end))
			end
		end
	end,
	Tooltip = 'Lets you jump higher'
})
Value = HighJump:CreateSlider({
	Name = 'Velocity',
	Min = 1,
	Max = 150,
	Default = 50,
	Suffix = function(val)
		return val == 1 and 'stud' or 'studs'
	end
})
AutoDisable = HighJump:CreateToggle({
	Name = 'Auto Disable',
	Default = true
})