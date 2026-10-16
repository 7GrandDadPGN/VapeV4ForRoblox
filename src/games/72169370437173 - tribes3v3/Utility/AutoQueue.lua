local AutoQueue

AutoQueue = vape.Categories.Utility:CreateModule({
	Name = 'AutoQueue',
	Function = function(callback)
		if callback then
			AutoQueue:Clean(vapeEvents.MatchEnded.Event:Connect(function()
				task.spawn(function()
					replicatedStorage.Remotes.QueueAction:InvokeServer('PlayAgain')
				end)
			end))
		end
	end,
	Tooltip = 'Automatically requeue after the match ends.'
})