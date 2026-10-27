local AutoQueue
local Delay
local Notification

AutoQueue = vape.Categories.Utility:CreateModule({
	Name = 'AutoQueue',
	Function = function(callback)
		if callback then
			AutoQueue:Clean(vapeEvents.MatchEnded.Event:Connect(function()
				repeat
					local button = lplr.PlayerGui:FindFirstChild('TR_Menus')
					local holder = button and button:FindFirstChild('MatchEnd', true) or nil
					button = holder and holder:FindFirstChild('PlayAgain', true) or nil

					if button and button:IsA('TextButton') and button.Visible and holder.Visible then
						AutoQueue:Clean(task.delay(Delay.Value, clickButton, button))
						if Notification.Enabled and Delay.Value > 0 then
							notif('AutoQueue', 'Playing again in '..string.format('%.1f', Delay.Value)..' seconds!', Delay.Value)
						end

						break
					end

					task.wait(0.05)
				until not AutoQueue.Enabled
			end))
		end
	end,
	Tooltip = 'Automatically requeue after the match ends.'
})
Delay = AutoQueue:CreateSlider({
	Name = 'Delay',
	Min = 0,
	Max = 2,
	Default = 1,
	Decimal = 10,
	Suffix = function(val)
		return val == 1 and 'second' or 'seconds'
	end
})
Notification = AutoQueue:CreateToggle({
	Name = 'Notification',
	Default = true
})