local AutoTeam

AutoTeam = vape.Categories.Utility:CreateModule({
	Name = 'AutoTeam',
	Function = function(callback)
		if callback then
			local gui = lplr.PlayerGui:FindFirstChild('TeamsFrame', true)
			if gui then
				for _, holder in gui:GetChildren() do
					if holder.Button.AutoButtonColor then
						pickTeam(holder.Button)
						break
					end
				end
			end
		end
	end,
	Tooltip = 'Automatically join a team when joining the server'
})