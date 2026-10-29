local SwingSpeed

SwingSpeed = vape.Categories.Blatant:CreateModule({
	Name = 'SwingSpeed',
	Function = function(callback)
		if callback then
			local old
			repeat
				if tribes.State.handler and tribes.State.handler.lastSwing then
					if tribes.State.handler.lastSwing ~= old then
						rawset(tribes.State.handler, 'lastSwing', tribes.State.handler.lastSwing - (tribes.State.handler.preset.hitDelay or 0.1))
						old = tribes.State.handler.lastSwing
					end
				else
					old = nil
				end

				task.wait()
			until not SwingSpeed.Enabled
		end
	end,
	Tooltip = 'Reduce swing cooldown by the max hit delay'
})