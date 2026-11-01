local AntiStun

local function LocalAdded(char)
	AntiStun:Clean(char.RootPart.AttributeChanged:Connect(function(key)
		if (key == 'SNoJump' or key == 'SSlow') and char.RootPart:GetAttribute(key) then
			char.RootPart:SetAttribute(key, nil)
		end
	end))

	char.RootPart:SetAttribute('SNoJump', nil)
	char.RootPart:SetAttribute('SSlow', nil)
end

AntiStun = vape.Categories.Blatant:CreateModule({
	Name = 'AntiStun',
	Function = function(callback)
		if callback then
			AntiStun:Clean(entitylib.Events.LocalAdded:Connect(LocalAdded))
			if entitylib.isAlive then
				LocalAdded(entitylib.character)
			end
		end
	end,
	Tooltip = 'Prevent snap traps from freezing you.'
})