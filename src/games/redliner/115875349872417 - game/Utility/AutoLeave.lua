local AutoLeave
local Delay

AutoLeave = vape.Categories.Utility:CreateModule({
	Name = 'AutoLeave',
	Function = function(callback)
		if callback then
			AutoLeave:Clean(vapeEvents.MatchEnded.Event:Connect(function(_, obj)
				task.delay(Delay.Value, function()
					firesignal(obj.Main.Actions.returnbutton.MouseButton1Click)
				end)
			end))
		end
	end,
	Tooltip = 'Automatically leave after the match ends.'
})
Delay = AutoLeave:CreateSlider({
	Name = 'Delay',
	Min = 0,
	Max = 2,
	Default = 1,
	Decimal = 10,
	Suffix = 'seconds'
})