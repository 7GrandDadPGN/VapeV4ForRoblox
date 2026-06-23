local Timer
local Value

Timer = vape.Categories.Blatant:CreateModule({
	Name = 'Timer',
	Function = function(callback)
		if callback then
			setfflag('SimEnableStepPhysics', 'True')
			setfflag('SimEnableStepPhysicsSelective', 'True')

			Timer:Clean(runService.RenderStepped:Connect(function(dt)
				if Value.Value > 1 then
					runService:Pause()
					workspace:StepPhysics(dt * (Value.Value - 1), {entitylib.character.RootPart})
					runService:Run()
				end
			end))
		end
	end,
	Tooltip = 'Change the game speed.'
})
Value = Timer:CreateSlider({
	Name = 'Value',
	Min = 1,
	Max = 3,
	Decimal = 10
})