local SwingSpeed

SwingSpeed = vape.Categories.Blatant:CreateModule({
	Name = 'SwingSpeed',
	Function = function(callback)
		if callback then
			local old
			repeat
				local handler = rawget(tribes.State, 'handler')
				if handler and rawget(handler, 'lastSwing') then
					if rawget(handler, 'lastSwing') ~= old then
						rawset(handler, 'lastSwing', rawget(handler, 'lastSwing') - (safeget(handler, 'preset', 'hitDelay') or 0.1))
						old = rawget(handler, 'lastSwing')
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