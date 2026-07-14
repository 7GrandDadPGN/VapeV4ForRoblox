local InfiniteDash

InfiniteDash = vape.Categories.Blatant:CreateModule({
	Name = 'InfiniteDash',
	Function = function(callback)
		if callback then
			if redline[redline.MoveController] and type(redline[redline.MoveController][redline.DashVariable]) == 'number' and type(redline[redline.MoveController][redline.DashRecoverVariable]) == 'number' then
				InfiniteDash:Clean(runService.PreSimulation:Connect(function()
					rawset(redline[redline.MoveController], redline.DashVariable, 3)
					rawset(redline[redline.MoveController], redline.DashRecoverVariable, 3)
				end))
			end
		end
	end,
	Tooltip = 'Allows you to dash infinitely.'
})