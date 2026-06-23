local AutoClicker
local CPS
local BlockCPS = {}
local Thread

local function AutoClick()
	if Thread then
		task.cancel(Thread)
	end

	Thread = task.delay(1 / 7, function()
		repeat
			if not bedwars.AppController:isLayerOpen(bedwars.UILayers.MAIN) then
				local blockPlacer = bedwars.BlockPlacementController.blockPlacer
				if store.hand.toolType == 'block' and blockPlacer then
					if (workspace:GetServerTimeNow() - bedwars.BlockCpsController.lastPlaceTimestamp) >= ((1 / 12) * 0.5) then
						local mouseinfo = blockPlacer.clientManager:getBlockSelector():getMouseInfo(0)
						if mouseinfo and mouseinfo.placementPosition == mouseinfo.placementPosition then
							task.spawn(blockPlacer.placeBlock, blockPlacer, mouseinfo.placementPosition)
						end
					end
				elseif store.hand.toolType == 'sword' then
					bedwars.SwordController:swingSwordAtMouse()
				end
			end

			task.wait(1 / (store.hand.toolType == 'block' and BlockCPS or CPS).GetRandomValue())
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

			if inputService.TouchEnabled then
				pcall(function()
					AutoClicker:Clean(lplr.PlayerGui.MobileUI['2'].MouseButton1Down:Connect(AutoClick))
					AutoClicker:Clean(lplr.PlayerGui.MobileUI['2'].MouseButton1Up:Connect(function()
						if Thread then
							task.cancel(Thread)
							Thread = nil
						end
					end))
				end)
			end
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
AutoClicker:CreateToggle({
	Name = 'Place Blocks',
	Default = true,
	Function = function(callback)
		if BlockCPS.Object then
			BlockCPS.Object.Visible = callback
		end
	end
})
BlockCPS = AutoClicker:CreateTwoSlider({
	Name = 'Block CPS',
	Min = 1,
	Max = 12,
	DefaultMin = 12,
	DefaultMax = 12,
	Darker = true
})