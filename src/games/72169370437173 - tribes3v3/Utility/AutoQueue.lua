local AutoQueue
local Delay
local Notification

AutoQueue = vape.Categories.Utility:CreateModule({
	Name = 'AutoQueue',
	Function = function(callback)
		if callback then
			dumpInput()

			AutoQueue:Clean(vapeEvents.MatchEnded.Event:Connect(function()
				if Notification.Enabled and Delay.Value > 0 then
					notif('AutoQueue', 'Playing again in '..string.format('%.1f', Delay.Value)..' seconds!', Delay.Value)
				end

				task.delay(Delay.Value, function()
					local button = lplr.PlayerGui:FindFirstChild('TR_Menus')
					button = button and button:FindFirstChild('MatchEnd', true) or nil
					button = button and button:FindFirstChild('PlayAgain', true) or nil

					if button and button:IsA('TextButton') and realInput then
						firesignal(button.Activated, realInput, 0)
					end
				end)
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