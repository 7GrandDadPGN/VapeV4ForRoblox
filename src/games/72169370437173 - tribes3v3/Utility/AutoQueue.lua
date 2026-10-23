local AutoQueue
local Delay
local Notification

AutoQueue = vape.Categories.Utility:CreateModule({
	Name = 'AutoQueue',
	Function = function(callback)
		if callback then
			AutoQueue:Clean(vapeEvents.MatchEnded.Event:Connect(function()
				if Notification.Enabled and Delay.Value > 0 then
					notif('AutoQueue', 'Playing again in '..string.format('%.1f', Delay.Value)..' seconds!', Delay.Value)
				end

				task.delay(Delay.Value, function()
					local gui = lplr.PlayerGui:FindFirstChild('TR_Menus')
					gui = gui and gui:FindFirstChild('MatchEnd', true) or nil
					gui = gui and gui:FindFirstChild('PlayAgain', true) or nil

					if gui and gui:IsA('TextButton') then
						firesignal(gui.Activated)
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