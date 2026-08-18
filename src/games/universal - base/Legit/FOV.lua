local FOV
local Value
local oldfov

FOV = vape.Legit:CreateModule({
	Name = 'FOV',
	Function = function(callback)
		if callback then
			oldfov = gameCamera.FieldOfView

			FOV:Clean(runService.RenderStepped:Connect(function()
				gameCamera.FieldOfView = Value.Value
			end))
		else
			gameCamera.FieldOfView = oldfov
		end
	end,
	Tooltip = 'Adjusts camera vision'
})
Value = FOV:CreateSlider({
	Name = 'FOV',
	Min = 30,
	Max = 120
})