local Disabler

local function characterAdded(char)
	for _, v in getconnections(char.RootPart:GetPropertyChangedSignal('CFrame')) do
		hookfunction(v.Function, function() end)
	end

	for _, v in getconnections(char.RootPart:GetPropertyChangedSignal('Velocity')) do
		hookfunction(v.Function, function() end)
	end
end

Disabler = vape.Categories.Utility:CreateModule({
	Name = 'Disabler',
	Function = function(callback)
		if callback then
			Disabler:Clean(entitylib.Events.LocalAdded:Connect(characterAdded))
			if entitylib.isAlive then
				characterAdded(entitylib.character)
			end
		end
	end,
	Tooltip = 'Disables GetPropertyChangedSignal detections for movement'
})