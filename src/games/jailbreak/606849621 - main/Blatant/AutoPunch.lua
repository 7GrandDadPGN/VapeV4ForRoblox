local AutoPunch

AutoPunch = vape.Categories.Blatant:CreateModule({
	Name = 'AutoPunch',
	Function = function(callback)
		if callback then
			repeat
				if entitylib.isAlive then
					jb:FireServer('Punch')
				end

				task.wait(0.3)
			until not AutoPunch.Enabled
		end
	end,
	Tooltip = 'Always punches people infront of you'
})