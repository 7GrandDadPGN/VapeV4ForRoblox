local Disabler

local function LocalAdded(char)
	for _, prop in {'CFrame', 'Velocity'} do
		for _, connection in getconnections(char.RootPart:GetPropertyChangedSignal(prop)) do
			hookfunction(connection.Function, function() end)
		end
	end
end

Disabler = vape.Categories.Utility:CreateModule({
	Name = 'Disabler',
	Function = function(callback)
		if callback then
			Disabler:Clean(entitylib.Events.LocalAdded:Connect(LocalAdded))
			if entitylib.isAlive then
				LocalAdded(entitylib.character)
			end
		end
	end,
	Tooltip = 'Disables GetPropertyChangedSignal detections for movement'
})