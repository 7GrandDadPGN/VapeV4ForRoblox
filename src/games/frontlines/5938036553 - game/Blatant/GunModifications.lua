local Reload
local Recoil
local Spread
local FireRate
local Automatic

GunModifications = vape.Categories.Blatant:CreateModule({
	Name = 'GunModifications',
	Function = function(callback)
		if callback then
			GunModifications:Clean(hookEvent('START_FPV_SOL_RECOIL_ANIM', function()
				if Recoil.Enabled then
					frontlines.Main.globals.fpv_sol_recoil.attitude_delta = Vector3.zero
					return true
				end
			end))

			GunModifications:Clean(hookEvent('STEP_FPV_SOL_FIREARM_SPREAD', function()
				if Spread.Enabled then
					frontlines.Main.globals.fpv_sol_spread.spread = 0
					return true
				end
			end))

			repeat
				local gun = frontlines.Main.globals.fpv_sol_equipment.curr_equipment
				if Reload.Enabled then
					local ammo = frontlines.Main.globals.fpv_sol_ammo
					if gun and gun.reload_params and ammo.ammo == 0 and ammo.reserve > 0 then
						frontlines.Main.exe_set(frontlines.Main.exe_set_t.FPV_SOL_AMMO_IN, gun)
					end
				end
				
				if FireRate.Enabled then
					if gun and gun.fire_params then 
						gun.fire_params.rpm = 4000 
					end
				end

				if Automatic.Enabled then 
					if gun and gun.fire_params then 
						gun.fire_params.cycle_mode = frontlines.Main.cycle_mode.AUTO
					end
				end

				task.wait()
			until not GunModifications.Enabled
		end
	end,
	Tooltip = 'Modifications to empower the firearm'
})
Reload = GunModifications:CreateToggle({Name = 'Auto Reload'})
Recoil = GunModifications:CreateToggle({Name = 'No Recoil'})
Spread = GunModifications:CreateToggle({Name = 'No Spread'})
FireRate = GunModifications:CreateToggle({Name = 'Fire rate'})
Automatic = GunModifications:CreateToggle({Name = 'Full Automatic'})