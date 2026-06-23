local SpinBot
local Speed
local Yaw
local Pitch
local aimtable = {}
local maxy = frontlines.Main.consts.fpv_sol_movement.MAX_ATT_X
local yaw, pitch = 0, 90
for i = 1, 40 do
	table.insert(aimtable, Vector3.zero)
end

SpinBot = vape.Categories.Blatant:CreateModule({
	Name = 'SpinBot',
	Function = function(callback)
		if callback then
			SpinBot:Clean(hookEvent('STEP_SOL_CFRAME', function(id)
				if id == frontlines.Main.globals.cli_state.fpv_sol_id then
					local v5 = frontlines.Main.globals.sol_positions[id]
					local v6 = aimtable[frontlines.Main.globals.cli_state.fpv_sol_id]
					frontlines.Main.globals.sol_root_parts[id].Root_M.CFrame = CFrame.Angles(0, 0.5 * v6.y, math.rad(-90))
				end
			end))

			debug.setupvalue(frontlines.Events[frontlines.Main.exe_func_t.STEP_FPV_SOL_NET_EGRESS], 3, aimtable)
			debug.setupvalue(frontlines.Events[frontlines.Main.exe_func_t.STEP_TPV_SOLDIER_JOINTS], 16, aimtable)

			repeat
				aimtable = table.clone(frontlines.Main.globals.sol_attitudes)
				aimtable[frontlines.Main.globals.cli_state.fpv_sol_id] = Vector3.new(math.clamp(math.rad(pitch), -maxy, maxy), math.rad(yaw))
				yaw += task.wait() * (Yaw.Value == 'Clockwise' and (Speed.Value or 0) or -(Speed.Value or 0)) * 1000
				if Pitch.Value == 'Sine' then
					pitch = math.sin(math.rad(yaw)) * 90
				end
			until not SpinBot.Enabled
		else
			yaw = 0
			debug.setupvalue(frontlines.Events[frontlines.Main.exe_func_t.STEP_FPV_SOL_NET_EGRESS], 3, frontlines.Main.globals.sol_attitudes)
			debug.setupvalue(frontlines.Events[frontlines.Main.exe_func_t.STEP_TPV_SOLDIER_JOINTS], 16, frontlines.Main.globals.sol_attitudes)
			local id = frontlines.Main.globals.cli_state.fpv_sol_id
			if frontlines.Main.globals.sol_root_parts[id] then
				frontlines.Main.globals.sol_root_parts[id].Root_M.CFrame = CFrame.Angles(0, math.rad(90), math.rad(-90))
			end
		end
	end,
	Tooltip = 'Rotates the character in a circle'
})
Speed = SpinBot:CreateSlider({
	Name = 'Speed',
	Min = 0,
	Max = 1,
	Default = 1,
	Decimal = 10
})
Yaw = SpinBot:CreateDropdown({
	Name = 'Yaw Direction',
	List = {'Clockwise', 'Counter Clockwise'}
})
Pitch = SpinBot:CreateDropdown({
	Name = 'Pitch Direction',
	List = {'Up', 'Down', 'Forward', 'Sine'},
	Function = function(val)
		pitch = val == 'Up' and 90 or val == 'Down' and -90 or 0
	end
})