local AutoSkip
local RankUp
local Drops
local Replay

AutoSkip = vape.Categories.Inventory:CreateModule({
	Name = 'AutoSkip',
	Function = function(callback)
		if callback then
			repeat
				local bind = contextActionService:GetBoundActionInfo('TR_RankUpKeys')
				if bind.priorityLevel and RankUp.Enabled then
					local rankupgui = lplr.PlayerGui:FindFirstChild('TR_RankUp')
					local button = rankupgui and rankupgui:FindFirstChild('Continue', true) or nil

					if button and button:IsA('TextButton') then
						clickButton(button)
					end
				else
					local reveal = lplr.PlayerGui:FindFirstChild('TR_Reveal')
					reveal = reveal and reveal.Enabled and reveal:FindFirstChild('Canvas') or nil
					reveal = reveal and reveal.Visible and reveal:FindFirstChild('Reveal') or nil

					if Drops.Enabled and reveal and reveal.Visible then
						local button1 = reveal and reveal:FindFirstChild('Skip', true) or nil
						local button2 = reveal and reveal:FindFirstChild('Continue', true) or nil

						if button1 and button1:IsA('TextButton') and button2 and button2:IsA('TextButton') then
							clickButton(button1)
							clickButton(button2)
						end
					elseif Replay.Enabled then
						local replayhud = lplr.PlayerGui:FindFirstChild('TR_ReplayHud')
						local button = replayhud and replayhud:FindFirstChild('Skip', true) or nil

						if button and button:IsA('TextButton') and button.Visible and replayhud.Enabled then
							clickButton(button)
						end
					end
				end

				task.wait(0.05)
			until not AutoSkip.Enabled
		end
	end,
	Tooltip = 'Automatically skip through all possible popups'
})
RankUp = AutoSkip:CreateToggle({
	Name = 'Rank Up',
	Default = true
})
Drops = AutoSkip:CreateToggle({
	Name = 'Crate Drops',
	Default = true
})
Replay = AutoSkip:CreateToggle({
	Name = 'Replay',
	Default = true
})