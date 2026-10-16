local Velocity

local function LocalAdded(char)
	Velocity:Clean(char.RootPart.AttributeChanged:Connect(function(key)
		if key:find('Kb') and char.RootPart:GetAttribute(key) then
			char.RootPart:SetAttribute(key, nil)
		end
	end))
end

Velocity = vape.Categories.Combat:CreateModule({
	Name = 'Velocity',
	Function = function(callback)
		if callback then
			Velocity:Clean(entitylib.Events.LocalAdded:Connect(LocalAdded))
			if entitylib.isAlive then
				LocalAdded(entitylib.character)
			end
		end
	end,
	Tooltip = 'Prevent the player from taking knockback'
})