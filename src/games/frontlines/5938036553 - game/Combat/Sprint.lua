local Sprint

Sprint = vape.Categories.Combat:CreateModule({
	Name = 'Sprint',
	Function = function(callback)
		if callback then
			repeat
				local states = frontlines.Main.globals.ctrl_states
				local statetimes = frontlines.Main.globals.ctrl_ts
				local sprintcheck = true
				
				if not (states.hold_ads or (time() - statetimes.trigger) < 0.2 or (time() - statetimes.press_crouch) < 0.4) then
					if not states.hold_accel then 
						statetimes.press_accel_prev = time() 
						statetimes.press_accel = time() 
					end
					states.hold_accel = true
				end
				task.wait(0.1)
			until not Sprint.Enabled
		end
	end,
	Tooltip = 'Holds the sprint button'
})