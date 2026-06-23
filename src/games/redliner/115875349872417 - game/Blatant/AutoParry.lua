local AutoParry

AutoParry = vape.Categories.Blatant:CreateModule({
	Name = 'AutoParry',
	Function = function(callback)
		if callback then
			local cooldown = os.clock()

			repeat
				if cooldown < os.clock() then
					local doParry
					for i, v in next, getIndicators() do
						if v.indicator_type == 'surefire_bullet' then
							local localPos = gameCamera.CFrame.Position
							local targetPos = (((i:FindFirstChild('Head') and i.Head.Position or i.PrimaryPart and i.PrimaryPart.Position or i:GetPivot().Position) - localPos) * Vector3.new(1, 0, 1)).Unit
							local diff = 1 - (workspace.CurrentCamera.CFrame.LookVector * Vector3.new(1, 0, 1)).Unit:Dot(targetPos)
							local timediff = (v.expected_shot_time - os.clock())

							if math.abs(diff) <= v.parry_range and timediff < 0.2 and timediff > 0 and v.indicator_ui.Visible then
								doParry = true
							end
						elseif v.indicator_type == 'timing_only' and playersService.NumPlayers <= 2 then
							local timediff = (v.expected_shot_time - os.clock())

							if timediff < 0 and timediff > -0.2 and v.indicator_ui.Visible then
								doParry = true
							end
						end
					end

					if doParry then
						cooldown = os.clock() + 0.2

						task.spawn(function()
							redline.ActionFunction(redline[redline.ActionController], 'PARRY').Pressed:Fire()
						end)
					end
				end

				task.wait(0.05)
			until not AutoParry.Enabled
		end
	end,
	Tooltip = 'lol'
})