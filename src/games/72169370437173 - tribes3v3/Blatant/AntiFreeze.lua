local AntiFreeze

local function LocalAdded(char)
	AntiFreeze:Clean(char.RootPart.AttributeChanged:Connect(function(key)
		if key == 'SFrozen' and char.RootPart:GetAttribute(key) then
			char.RootPart:SetAttribute(key, nil)
		end
	end))

	char.RootPart:SetAttribute('SFrozen', nil)
end

AntiFreeze = vape.Categories.Blatant:CreateModule({
	Name = 'AntiFreeze',
	Function = function(callback)
		if callback then
			AntiFreeze:Clean(entitylib.Events.LocalAdded:Connect(LocalAdded))
			if entitylib.isAlive then
				LocalAdded(entitylib.character)
			end
		end
	end,
	Tooltip = 'Enable movement during the voting period'
})