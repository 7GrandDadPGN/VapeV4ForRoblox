local AutoCamel

AutoCamel = vape.Categories.Minigames:CreateModule({
	Name = 'AutoCamel',
	Function = function(callback)
		if callback then
			local camel = workspace.NPCs:FindFirstChild('Abu Baba')
			if not camel then
				notif('AutoCamel', 'Missing camel seller!', 5, 'warning')
				AutoCamel:Toggle()
				return
			end

			local module = require(camel.Dialogue:FindFirstChild('RunScript', true).ModuleScript)
			repeat
				if (lplr:GetAttribute('TIX') or 0) >= 30 then
					module:Run()
				end

				task.wait(0.5)
			until not AutoCamel.Enabled
		end
	end,
	Tooltip = 'Automatically buy camels'
})