local LogSpammer
local Message
local rand = Random.new()

LogSpammer = vape.Categories.Utility:CreateModule({
	Name = 'LogSpammer',
	Function = function(callback)
		if callback then
			repeat
				if entitylib.isAlive then
					local animator = entitylib.character.Humanoid:FindFirstChildWhichIsA('Animator')

					if animator then
						if replicatesignal then
							replicatesignal(animator.OnCombinedUpdate, ('http=507770677'..utf8.char(rand:NextInteger(1, 65535))..Message.Value):sub(1, 256), true, 0, 0.0001, 0, 0, Enum.AnimationPriority.Core, true, 255)
						else
							local anim = Instance.new('Animation')
							anim.AnimationId = ('http=507770677'..utf8.char(rand:NextInteger(1, 65535))..Message.Value):sub(1, 256)
							local track = animator:LoadAnimation(anim)
							track:Play(0, 0.0001, 0)
						end
					end
				end

				task.wait()
			until not LogSpammer.Enabled
		end
	end,
	Tooltip = 'Use animations to spam the console of people ingame'
})
Message = LogSpammer:CreateTextBox({
	Name = 'Message',
	Placeholder = 'text (242 character limit)'
})