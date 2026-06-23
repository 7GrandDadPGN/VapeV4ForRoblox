local RestrainBeast

RestrainBeast = vape.Categories.Blatant:CreateModule({
	Name = 'RestrainBeast',
	Function = function(callback)
		if callback then
			repeat
				for _, v in entitylib.List do
					local rem = v.IsBeast and v.Character:FindFirstChild('HammerEvent', true)
					if rem and rem:IsA('RemoteEvent') then
						rem:FireServer('HammerClick', true)
					end
				end

				task.wait(0.1)
			until not RestrainBeast.Enabled
		end
	end,
	Tooltip = 'Force the beast to be unable to hook onto survivors'
})