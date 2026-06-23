local ThirdPerson
local Distance
local hook = false

ThirdPerson = vape.Categories.Render:CreateModule({
	Name = 'ThirdPerson',
	Function = function(callback)
		if callback then
			ThirdPerson:Clean(hookEvent('STEP_FPV_SOL_CAMERA', function()
				local bone = frontlines.Main.globals.fpv_sol_instances.camera_bone
				local state = frontlines.Main.globals.cli_state
				if bone and state.state == frontlines.Main.cli_state_t.COMBAT then
					local id = state.fpv_sol_id
					local actor = frontlines.Main.soldier_actors[id]
					local cf = bone.TransformedWorldCFrame
					if actor then 
						actor.main.direction.Value = frontlines.Main.globals.fpv_sol_dir.dir 
					end
					
					gameCamera.CFrame = cf * CFrame.new(0, 2, Distance.Value)
					gameCamera.Focus = cf + cf.LookVector
					frontlines.Main.exe_set(frontlines.Main.exe_set_t.TPV_SOLDIER_JOINT_STEP, id)
					return true
				end
			end))

			if entitylib.isAlive then
				local char = entitylib.character.Character
				for i, v in char:GetDescendants() do
					if v:IsA('BasePart') then 
						v.LocalTransparencyModifier = v.Parent ~= char and 1 or 0 
					end
				end
			end

			ThirdPerson:Clean(entitylib.Events.LocalAdded:Connect(function(ent)
				local id = frontlines.Main.globals.cli_state.fpv_sol_id
				local actor = frontlines.Main.soldier_actors[id]
				if actor then
					local gun = frontlines.Main.globals.fpv_sol_equipment.curr_equipment
					frontlines.Events[frontlines.Main.exe_func_t.INIT_TPV_SOL_JOINTS](id)
					frontlines.Events[frontlines.Main.exe_func_t.INIT_TPV_SOL_EQUIPMENT_JOINTS](id, gun)
					frontlines.Events[frontlines.Main.exe_func_t.SET_SOLDIER_ANIMATION_VALUES](id, gun)
					actor.main.alive.Value = true
				end

				for i, v in ent.Character:GetDescendants() do
					if v:IsA('BasePart') then 
						v.LocalTransparencyModifier = v.Parent ~= ent.Character and 1 or 0 
					end
				end
			end))
		else
			if entitylib.isAlive then
				local char = entitylib.character.Character
				for i, v in char:GetDescendants() do
					if v:IsA('BasePart') then 
						v.LocalTransparencyModifier = v.Parent ~= char and 0 or 1 
					end
				end
			end
		end
	end,
	Tooltip = 'View your character in third person'
})
Distance = ThirdPerson:CreateSlider({
	Name = 'Distance',
	Min = 1,
	Max = 15,
	Default = 8
})