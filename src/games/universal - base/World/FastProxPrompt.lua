local FastProxPrompt
local Mode
local Value
local modified = {}
local thread

FastProxPrompt = vape.Categories.World:CreateModule({
	Name = 'FastProxPrompt',
	Function = function(callback)
		if callback then
			if Mode.Value == 'Signal' then
				FastProxPrompt:Clean(proxService.PromptButtonHoldBegan:Connect(function(prompt, plr)
					if plr == lplr then
						thread = task.delay(prompt.HoldDuration * (Value.Value / 100), function()
							fireproximityprompt(prompt)
							thread = nil
						end)
					end
				end))

				FastProxPrompt:Clean(proxService.PromptButtonHoldEnded:Connect(function(prompt, plr)
					if plr == lplr and thread then
						task.cancel(thread)
						thread = nil
					end
				end))
			else
				FastProxPrompt:Clean(proxService.PromptShown:Connect(function(prompt)
					if not modified[prompt] then
						modified[prompt] = prompt.HoldDuration
					end

					prompt.HoldDuration = modified[prompt] * (Value.Value / 100)
				end))

				FastProxPrompt:Clean(proxService.PromptHidden:Connect(function(prompt)
					if modified[prompt] then
						prompt.HoldDuration = modified[prompt]
						modified[prompt] = nil
					end
				end))
			end
		else
			if thread then
				task.cancel(thread)
				thread = nil
			end

			for i, v in modified do
				i.HoldDuration = v
			end

			table.clear(modified)
		end
	end,
	Tooltip = 'Allow you to adjust the HoldDuration time of a ProximityPrompt'
})
Mode = FastProxPrompt:CreateDropdown({
	Name = 'Mode',
	List = {'Signal', 'Property'},
	Tooltip = 'Signal - Uses fireproximityprompt after the calculated delay\nProperty - Sets the HoldDuration property',
	Function = function()
		if FastProxPrompt.Enabled then
			FastProxPrompt:Toggle()
			FastProxPrompt:Toggle()
		end
	end
})
Value = FastProxPrompt:CreateSlider({
	Name = 'Modifier',
	Min = 0,
	Max = 100,
	Default = 50,
	Suffix = '%',
	Function = function(val)
		for i, v in modified do
			i.HoldDuration = v * (val / 100)
		end
	end
})