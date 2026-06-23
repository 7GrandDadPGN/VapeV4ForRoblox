local SpamBeast

SpamBeast = vape.Categories.Blatant:CreateModule({
	Name = 'SpamBeast',
	Function = function(callback)
		if callback then
			repeat
				for _, v in entitylib.List do
					local rem = v.IsBeast and v.Character:FindFirstChild('PowersEvent', true)
					if rem and rem:IsA('RemoteEvent') then
						rem:FireServer('Input')
					end
				end

				task.wait(0.1)
			until not SpamBeast.Enabled
		end
	end,
	Tooltip = 'Force the beast to use abilities'
})