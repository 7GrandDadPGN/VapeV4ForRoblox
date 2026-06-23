local SlowBeast

SlowBeast = vape.Categories.Blatant:CreateModule({
	Name = 'SlowBeast',
	Function = function(callback)
		if callback then
			repeat
				for _, v in entitylib.List do
					local rem = v.IsBeast and v.Character:FindFirstChild('PowersEvent', true)
					if rem and rem:IsA('RemoteEvent') then
						rem:FireServer('Jumped')
					end
				end

				task.wait(0.1)
			until not SlowBeast.Enabled
		end
	end,
	Tooltip = 'Force the beast to be slowed'
})