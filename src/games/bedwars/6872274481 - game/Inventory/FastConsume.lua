local Value
local oldclickhold, oldshowprogress

local FastConsume = vape.Categories.Inventory:CreateModule({
	Name = 'FastConsume',
	Function = function(callback)
		if callback then
			oldclickhold = bedwars.ClickHold.startClick
			oldshowprogress = bedwars.ClickHold.showProgress
			bedwars.ClickHold.startClick = function(self)
				self.startedClickTime = tick()
				local handle = self:showProgress()
				local clicktime = self.startedClickTime
				bedwars.RuntimeLib.Promise.defer(function()
					task.wait(self.durationSeconds * (Value.Value / 40))
					if handle == self.handle and clicktime == self.startedClickTime and self.closeOnComplete then
						self:hideProgress()
						if self.onComplete then self.onComplete() end
						if self.onPartialComplete then self.onPartialComplete(1) end
						self.startedClickTime = -1
					end
				end)
			end

			bedwars.ClickHold.showProgress = function(self)
				local roact = debug.getupvalue(oldshowprogress, 1)
				local countdown = roact.mount(roact.createElement('ScreenGui', {}, { roact.createElement('Frame', {
					[roact.Ref] = self.wrapperRef,
					Size = UDim2.new(),
					Position = UDim2.fromScale(0.5, 0.55),
					AnchorPoint = Vector2.new(0.5, 0),
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 0.8
				}, { roact.createElement('Frame', {
					[roact.Ref] = self.progressRef,
					Size = UDim2.fromScale(0, 1),
					BackgroundColor3 = Color3.new(1, 1, 1),
					BackgroundTransparency = 0.5
				}) }) }), lplr:FindFirstChild('PlayerGui'))

				self.handle = countdown
				local sizetween = tweenService:Create(self.wrapperRef:getValue(), TweenInfo.new(0.1), {
					Size = UDim2.fromScale(0.11, 0.005)
				})
				local countdowntween = tweenService:Create(self.progressRef:getValue(), TweenInfo.new(self.durationSeconds * (Value.Value / 100), Enum.EasingStyle.Linear), {
					Size = UDim2.fromScale(1, 1)
				})

				sizetween:Play()
				countdowntween:Play()
				table.insert(self.tweens, countdowntween)
				table.insert(self.tweens, sizetween)
				
				return countdown
			end
		else
			bedwars.ClickHold.startClick = oldclickhold
			bedwars.ClickHold.showProgress = oldshowprogress
			oldclickhold = nil
			oldshowprogress = nil
		end
	end,
	Tooltip = 'Use/Consume items quicker.'
})
Value = FastConsume:CreateSlider({
	Name = 'Multiplier',
	Min = 0,
	Max = 100
})