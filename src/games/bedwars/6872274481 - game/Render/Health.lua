local Health

Health = vape.Categories.Render:CreateModule({
	Name = 'Health',
	Function = function(callback)
		if callback then
			local label = Instance.new('TextLabel')
			label.Size = UDim2.fromOffset(100, 20)
			label.Position = UDim2.new(0.5, 6, 0.5, 30)
			label.BackgroundTransparency = 1
			label.AnchorPoint = Vector2.new(0.5, 0)
			label.Text = entitylib.isAlive and math.round(lplr.Character:GetAttribute('Health'))..' ❤️' or ''
			label.TextColor3 = entitylib.isAlive and Color3.fromHSV((lplr.Character:GetAttribute('Health') / lplr.Character:GetAttribute('MaxHealth')) / 2.8, 0.86, 1) or Color3.new()
			label.TextSize = 18
			label.Font = Enum.Font.Arial
			label.Parent = vape.gui
			Health:Clean(label)
			Health:Clean(vapeEvents.AttributeChanged.Event:Connect(function()
				label.Text = entitylib.isAlive and math.round(lplr.Character:GetAttribute('Health'))..' ❤️' or ''
				label.TextColor3 = entitylib.isAlive and Color3.fromHSV((lplr.Character:GetAttribute('Health') / lplr.Character:GetAttribute('MaxHealth')) / 2.8, 0.86, 1) or Color3.new()
			end))
		end
	end,
	Tooltip = 'Displays your health in the center of your screen.'
})