local AutoClicker
local CPS
local Thread

local function AutoClick()
	if Thread then
		task.cancel(Thread)
	end

	Thread = task.delay(1 / CPS.GetRandomValue(), function()
		repeat
			task.spawn(arena.Client.startHit)
			task.wait(1 / CPS.GetRandomValue())
		until not AutoClicker.Enabled
	end)
end

AutoClicker = vape.Categories.Combat:CreateModule({
	Name = 'AutoClicker',
	Function = function(callback)
		if callback then
			AutoClicker:Clean(inputService.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					AutoClick()
				end
			end))

			AutoClicker:Clean(inputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 and Thread then
					task.cancel(Thread)
					Thread = nil
				end
			end))
		else
			if Thread then
				task.cancel(Thread)
				Thread = nil
			end
		end
	end,
	Tooltip = 'Hold attack button to automatically click'
})
CPS = AutoClicker:CreateTwoSlider({
	Name = 'CPS',
	Min = 1,
	Max = 9,
	DefaultMin = 7,
	DefaultMax = 7
})