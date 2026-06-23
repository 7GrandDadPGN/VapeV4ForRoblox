--[[
	Grabbing an accurate count of the current framerate
	Source: https://devforum.roblox.com/t/get-client-FPS-trough-a-script/282631
]]
local FPS
local label

FPS = vape.Legit:CreateModule({
	Name = 'FPS',
	Function = function(callback)
		if callback then
			local frames = {}
			local startClock = os.clock()
			local updateTick = tick()

			FPS:Clean(runService.Heartbeat:Connect(function()
				local updateClock = os.clock()
				for i = #frames, 1, -1 do
					frames[i + 1] = frames[i] >= updateClock - 1 and frames[i] or nil
				end

				frames[1] = updateClock
				if updateTick < tick() then
					updateTick = tick() + 1
					label.Text = math.floor(os.clock() - startClock >= 1 and #frames or #frames / (os.clock() - startClock))..' FPS'
				end
			end))
		end
	end,
	Size = UDim2.fromOffset(100, 41),
	Tooltip = 'Shows the current framerate'
})
FPS:CreateFont({
	Name = 'Font',
	Blacklist = 'Gotham',
	Function = function(val)
		label.FontFace = val
	end
})
FPS:CreateColorSlider({
	Name = 'Color',
	DefaultValue = 0,
	DefaultOpacity = 0.5,
	Function = function(hue, sat, val, opacity)
		label.BackgroundColor3 = Color3.fromHSV(hue, sat, val)
		label.BackgroundTransparency = 1 - opacity
	end
})
label = Instance.new('TextLabel')
label.Size = UDim2.fromScale(1, 1)
label.BackgroundTransparency = 0.5
label.TextSize = 15
label.Font = Enum.Font.Gotham
label.Text = 'inf FPS'
label.TextColor3 = Color3.new(1, 1, 1)
label.BackgroundColor3 = Color3.new()
label.Parent = FPS.Children
local corner = Instance.new('UICorner')
corner.CornerRadius = UDim.new(0, 4)
corner.Parent = label